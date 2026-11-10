"""Step 2 of a run, no model: what Justin typed (with Claude's visible text before it as context) and
the new review findings and failed acceptance checks. Rules: DREAM.md sections 2 and 3.

A transcript is parsed by line type, never searched as raw text. A user line of a shape this code does
not know stops that session loudly (UnknownShape): nothing is guessed and nothing is skipped silently.
"""
import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path

CONTEXT_CHARS = 1500
CONTEXT_MAX = 3000
DIGEST_MAX = 120000
CLAIM_MAX = 400
LABEL_CONTEXT = "CONTEXT (what Claude said, not evidence)"
IMAGE_NOTE = "has an image the helper cannot see"

SKIP_PREFIXES = ("<local-command-stdout", "<local-command-stderr", "<bash-input", "<bash-stdout", "<bash-stderr",
                 "[Request interrupted")
SLASH_PREFIXES = ("<command-name", "<command-message")
IMAGE_TOKEN = re.compile(r"\[Image #\d+\]\s?")
PASTE = re.compile(r'<pasted_content id="([^"]*)">(.*?)</pasted_content id="\1">', re.S)
ARGS = re.compile(r"<command-args>(.*?)</command-args>", re.S)
CMD_NAME = re.compile(r"<command-name>/?([^<]*)</command-name>")

# common token shapes, masked before gitleaks (which catches the rest)
TOKEN_RES = [re.compile(p) for p in (
    r"-----BEGIN [A-Z ]*PRIVATE KEY-----[\s\S]*?-----END [A-Z ]*PRIVATE KEY-----",
    r"sk-ant-[A-Za-z0-9_\-]{10,}", r"\bsk-[A-Za-z0-9]{20,}", r"\bgh[pousr]_[A-Za-z0-9]{20,}",
    r"\bgithub_pat_[A-Za-z0-9_]{20,}", r"\bAKIA[0-9A-Z]{16}\b", r"\bxox[abprs]-[A-Za-z0-9-]{10,}",
    r"\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{5,}",
    r"(?i)\b(?:password|passwd|secret|token|api[_-]?key)\s*[:=]\s*\S{6,}",
    r"\b(?=[A-Za-z0-9]*[0-9])(?=[A-Za-z0-9]*[A-Za-z])[A-Za-z0-9]{32,}\b",
)]
MASK = "[masked]"


class UnknownShape(Exception):
    def __init__(self, session, line_no, shape):
        self.session, self.line_no, self.shape = session, line_no, shape
        super().__init__("unknown transcript shape in session %s, line %d: %s" % (session, line_no, shape))


class SessionRead:
    def __init__(self, path):
        self.path = Path(path)
        self.session = self.path.stem
        self.entries = []
        self.lines_read = 0          # complete lines read from the top of the file
        self.last_uuid = None        # of line lines_read - 1, for the marker
        self.last_sha = None
        self.headless = False        # every line with an entrypoint is sdk-cli
        self.rewritten = False       # the marker no longer matched: read again from the top
        self.line_meta = {}          # line index -> (uuid, sha256 of the line), for markers
        self.freeze_lines = []       # 1-based numbers of NUL-only lines after the marker, skipped
        self.cwd = None              # the first working folder a line names: where its memory folder comes from


def freeze_artefact(line):
    """A line of NUL bytes only: what a freeze leaves where a write was cut off (the two real cases are each
    followed by a last-prompt line). It holds nothing to read, so it is skipped and noted, not an unknown
    shape; a line broken in any other way still is one (ruling R1-1)."""
    return "\x00" in line and not line.strip("\x00 \t\r")


def _blocks(content):
    if isinstance(content, str):
        return [{"type": "text", "text": content}]
    if isinstance(content, list):
        return [b if isinstance(b, dict) else {"type": "text", "text": str(b)} for b in content]
    return None


def _texts(blocks):
    return [b.get("text") or "" for b in blocks if b.get("type") == "text"]


def context_tail(text):
    """The last 1,500 characters, moved back to the start of the paragraph the cut falls in, 3,000 at most."""
    if len(text) <= CONTEXT_CHARS:
        return text
    cut = len(text) - CONTEXT_CHARS
    p = text.rfind("\n\n", 0, cut)
    start = p + 2 if p >= 0 else 0
    if len(text) - start > CONTEXT_MAX:
        start = len(text) - CONTEXT_MAX
    return text[start:]


def clean_typed(blocks):
    """(label or None, text, has_image) for the blocks of a typed message."""
    has_image = any(b.get("type") == "image" for b in blocks)
    parts = [t for t in _texts(blocks) if not t.lstrip().startswith("[Image:")]
    text = "\n".join(parts)
    if IMAGE_TOKEN.search(text):
        has_image = True
        text = IMAGE_TOKEN.sub("", text)
    pastes = PASTE.findall(text)
    if pastes and not PASTE.sub("", text).strip():
        return "PASTE (whole message)", "\n".join(body for _, body in pastes).strip(), has_image
    text = PASTE.sub(lambda m: "[paste omitted, %d chars]" % len(m.group(2)), text)
    return None, text.strip(), has_image


def _shape(obj, why):
    keys = ",".join(sorted(k for k in obj.keys() if k in (
        "type", "promptSource", "isMeta", "isSidechain", "isCompactSummary", "origin", "toolUseResult")))
    return "%s (keys: %s)" % (why, keys)


def _first_tag(text):
    t = text.lstrip()
    m = re.match(r"<([A-Za-z][\w-]*)", t)
    return ("text starting <%s>" % m.group(1)) if m else "plain text"


def _answers(tur):
    """One ANSWER entry part per answered question of an AskUserQuestion result."""
    qs, ans = tur.get("questions"), tur.get("answers")
    if not isinstance(qs, list) or not isinstance(ans, dict):
        return []
    out = []
    for q in qs:
        if not isinstance(q, dict):
            continue
        question = q.get("question") or ""
        a = ans.get(question)
        if not isinstance(a, str) or not a.strip():
            continue
        labels = [o.get("label", "") for o in q.get("options") or [] if isinstance(o, dict)]
        if a in labels:
            chosen, own = [a], ""
        else:
            parts = [x.strip() for x in a.split(",")] if q.get("multiSelect") else [a.strip()]
            chosen = [x for x in parts if x in labels]
            own = ", ".join(x for x in parts if x not in labels)
        out.append({"question": question, "options": labels, "chosen": chosen, "own": own})
    return out


def read_session(path, start_line=0, seen=(), expect=None):
    """Entries Justin typed in lines [start_line:] of one transcript.

    expect = (uuid, sha) of line start_line - 1 as the marker saw it; when the file no longer has that
    line, it was rewritten and is read from the top (uuids in `seen` are skipped either way).
    """
    r = SessionRead(path)
    raw = r.path.read_bytes().decode("utf-8", errors="replace")
    lines = raw.split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    # a last line that is not valid JSON is still being written: leave it for the next run
    if lines:
        try:
            json.loads(lines[-1])
        except ValueError:
            lines.pop()
    if start_line:
        ok = start_line <= len(lines)
        if ok and expect is not None:
            try:
                prev = json.loads(lines[start_line - 1])
            except ValueError:
                prev = {}
            sha = hashlib.sha256(lines[start_line - 1].encode()).hexdigest()
            ok = (prev.get("uuid") == expect[0]) and (expect[1] is None or expect[1] == sha)
        if not ok:
            r.rewritten = True
            start_line = 0
    seen = set(seen)
    entrypoints = set()
    ctx = []
    for idx in range(len(lines)):
        ln = lines[idx]
        if not ln.strip():
            continue
        if freeze_artefact(ln):
            if idx >= start_line - 1:
                r.line_meta[idx] = (None, hashlib.sha256(ln.encode()).hexdigest())
            if idx >= start_line:
                r.freeze_lines.append(idx + 1)
            continue
        try:
            obj = json.loads(ln)
        except ValueError:
            if idx < start_line:
                continue  # already behind the marker: read once, never again
            raise UnknownShape(r.session, idx + 1, "a line that is not valid JSON")
        if not isinstance(obj, dict):
            if idx < start_line:
                continue
            raise UnknownShape(r.session, idx + 1, "a line that is not a JSON object")
        if obj.get("entrypoint"):
            entrypoints.add(obj["entrypoint"])
        if r.cwd is None and isinstance(obj.get("cwd"), str) and obj["cwd"]:
            r.cwd = obj["cwd"]
        if idx >= start_line - 1:
            r.line_meta[idx] = (obj.get("uuid"), hashlib.sha256(ln.encode()).hexdigest())
        if idx < start_line:
            # behind the marker: no entries, but Claude's text still feeds the context of the first message
            # after it, and an entry there still ends that context (R1-10)
            try:
                _line_entries(r.session, idx, obj, ctx)
            except UnknownShape:
                ctx.clear()
            continue
        new = [e for e in _line_entries(r.session, idx, obj, ctx) if e["uuid"] not in seen]
        r.entries.extend(new)
        seen.update(e["uuid"] for e in new)  # a line repeated later (same uuid) is counted once
    r.lines_read = len(lines)
    if lines:
        try:
            r.last_uuid = json.loads(lines[-1]).get("uuid")
        except ValueError:
            r.last_uuid = None
        r.last_sha = hashlib.sha256(lines[-1].encode()).hexdigest()
    r.headless = bool(entrypoints) and entrypoints == {"sdk-cli"}
    return r


def _entry(obj, idx, label, text, image, ctx):
    context = context_tail("\n\n".join(ctx))
    ctx.clear()
    ts = obj.get("timestamp") or ""
    return {"uuid": obj["uuid"], "ts": ts, "date": ts[:10], "label": label, "text": text, "context": context,
            "image": image, "line": idx}


def _line_entries(session, idx, obj, ctx):
    """Entries from one parsed line (usually none). Claude's visible text is collected into ctx."""
    t = obj.get("type")
    if t == "assistant":
        if not obj.get("isSidechain") and not obj.get("isMeta"):
            blocks = _blocks((obj.get("message") or {}).get("content")) or []
            ctx.extend(x for x in _texts(blocks) if x.strip())
        return []
    if t == "attachment":
        att = obj.get("attachment") or {}
        if att.get("type") != "queued_command" or obj.get("isSidechain"):
            return []
        if (att.get("origin") or {}).get("kind") != "human":
            return []  # a task notification or a peer agent's message
        for k in ("uuid", "timestamp"):
            if not obj.get(k):
                raise UnknownShape(session, idx + 1, _shape(obj, "mid-turn prompt without %s" % k))
        blocks = _blocks(att.get("prompt"))
        if blocks is None:
            raise UnknownShape(session, idx + 1, _shape(obj, "mid-turn prompt that is not text"))
        label, text, image = clean_typed(blocks)
        return [_entry(obj, idx, label or "mid-turn", text, image, ctx)] if text else []
    if t != "user":
        return []  # api-request-blob and every other line type are never read for text
    if obj.get("isSidechain") or obj.get("isMeta"):
        return []
    for k in ("uuid", "timestamp"):
        if not obj.get(k):
            raise UnknownShape(session, idx + 1, _shape(obj, "user line without %s" % k))
    msg = obj.get("message")
    blocks = _blocks(msg.get("content")) if isinstance(msg, dict) else None
    if blocks is None:
        raise UnknownShape(session, idx + 1, _shape(obj, "user line without message.content"))
    if any(b.get("type") == "tool_result" for b in blocks):
        tur = obj.get("toolUseResult")
        if isinstance(tur, dict) and "questions" in tur and "answers" in tur:
            out = []
            for a in _answers(tur):
                e = {"uuid": obj["uuid"], "ts": obj["timestamp"], "date": obj["timestamp"][:10], "label": "ANSWER",
                     "text": a["own"] or ", ".join(a["chosen"]), "context": "", "image": False, "line": idx}
                e.update(a)
                out.append(e)
            ctx.clear()
            return out
        return []  # a tool's output is never evidence
    ps = obj.get("promptSource")
    human = (obj.get("origin") or {}).get("kind") == "human"
    if ps in ("typed", "queued"):
        if not human:
            raise UnknownShape(session, idx + 1, _shape(obj, "%s prompt whose origin is not human" % ps))
        label, text, image = clean_typed(blocks)
        if not text:
            return []
        return [_entry(obj, idx, label or ("TYPED" if ps == "typed" else "QUEUED"), text, image, ctx)]
    if ps in ("sdk", "system"):
        return []  # a headless prompt or a task notification
    if ps is not None:
        raise UnknownShape(session, idx + 1, _shape(obj, "promptSource %r" % ps))
    if obj.get("isCompactSummary"):
        return []
    text = "\n".join(_texts(blocks)).lstrip()
    if text.startswith(SLASH_PREFIXES):
        args = ARGS.search(text)
        name = CMD_NAME.search(text)
        if human and args and args.group(1).strip():
            return [_entry(obj, idx, "SLASH /" + (name.group(1).strip() if name else "?"),
                           args.group(1).strip(), False, ctx)]
        return []
    if text.startswith(SKIP_PREFIXES):
        return []
    if not text and any(b.get("type") == "image" for b in blocks):
        return []
    raise UnknownShape(session, idx + 1, _shape(obj, "user line with no promptSource and " + _first_tag(text)))


# ---------- scrubbing: a regex pass for common token shapes, then gitleaks ----------

def _gitleaks_secrets(texts, env):
    """The strings gitleaks flags in each text (a list of sets)."""
    if not shutil.which("gitleaks", path=env.environ.get("PATH")):
        raise RuntimeError("gitleaks is not installed; it guards every digest, diff and log against secrets")
    env.cache.mkdir(parents=True, exist_ok=True)
    d = tempfile.mkdtemp(prefix="scrub-", dir=str(env.cache))
    try:
        src = Path(d) / "in"
        src.mkdir()
        for i, t in enumerate(texts):
            (src / ("t%d.txt" % i)).write_text(t)
        report = Path(d) / "report.json"
        cmd = ["gitleaks", "dir", str(src), "--no-banner", "--report-format", "json", "--report-path", str(report),
               "--exit-code", "0"]
        cfg = env.home / ".claude/setup/gitleaks.toml"
        if cfg.exists():
            cmd += ["--config", str(cfg)]
        p = subprocess.run(cmd, capture_output=True, text=True, env=env.environ)
        if p.returncode != 0:
            raise RuntimeError("gitleaks failed (exit %d)" % p.returncode)
        try:
            found = json.loads(report.read_text() or "[]") or []
        except (OSError, ValueError):
            raise RuntimeError("gitleaks wrote no readable report")
        out = [set() for _ in texts]
        for f in found:
            m = re.search(r"t(\d+)\.txt$", f.get("File", ""))
            s = f.get("Secret") or f.get("Match") or ""
            if m and s:
                out[int(m.group(1))].add(s)
        return out
    finally:
        shutil.rmtree(d, ignore_errors=True)


def scrub_texts(texts, env):
    """Mask secrets in every text: (masked texts, number masked)."""
    n = 0
    out = []
    for t in texts:
        for rx in TOKEN_RES:
            t, k = rx.subn(MASK, t)
            n += k
        out.append(t)
    for i, secrets in enumerate(_gitleaks_secrets(out, env)):
        for s in sorted(secrets, key=len, reverse=True):
            if s in out[i]:
                n += out[i].count(s)
                out[i] = out[i].replace(s, MASK)
    return out, n


def secret_flags(texts, env):
    """For each text: does gitleaks (or the regex pass) flag it?"""
    return [bool(s) or any(rx.search(t) for rx in TOKEN_RES) for t, s in zip(texts, _gitleaks_secrets(texts, env))]


SCRUB_FIELDS = ("text", "context", "own", "question")


def scrub_entries(entries, env):
    """Mask secrets in every text an entry holds, context blocks included. Returns how many were masked."""
    flat = []
    for e in entries:
        for k in SCRUB_FIELDS:
            if isinstance(e.get(k), str):
                flat.append((e, k, None))
        for k in ("chosen", "options"):
            for i, _ in enumerate(e.get(k) or []):
                flat.append((e, k, i))
    texts = [(e[k] if i is None else e[k][i]) for e, k, i in flat]
    if not texts:
        return 0
    masked, n = scrub_texts(texts, env)
    for (e, k, i), t in zip(flat, masked):
        if i is None:
            e[k] = t
        else:
            e[k][i] = t
    return n


def render_entry(e):
    head = "=== ENTRY uuid=%s time=%s kind=%s" % (e["uuid"], e["ts"], e["label"])
    if e.get("image"):
        head += " [%s]" % IMAGE_NOTE
    out = [head]
    if e["label"] == "ANSWER":
        out += ["--- QUESTION (Claude asked)", e.get("question", ""), "--- OPTIONS OFFERED"]
        out += ["- " + o for o in e.get("options") or []]
        out += ["--- JUSTIN CHOSE"] + (["- " + c for c in e.get("chosen") or []] or ["(none)"])
        if e.get("own"):
            out += ["--- JUSTIN WROTE", e["own"]]
    else:
        if e.get("context"):
            out += ["--- " + LABEL_CONTEXT, e["context"]]
        out += ["--- JUSTIN", e["text"]]
    return "\n".join(out) + "\n\n"


def render_digest(session, project, entries, max_chars=DIGEST_MAX):
    """(digest text, the entries it holds): it stops before the entry that would pass max_chars."""
    head = ("# Digest of session %s (project %s). CONTEXT blocks are what Claude said: never evidence, "
            "never quote them.\n\n" % (session, project))
    parts, used, size = [head], [], len(head)
    for e in entries:
        block = render_entry(e)
        if size + len(block) > max_chars:
            if used:
                break
            block = block[: max(1000, max_chars - size - 100)] + "\n[cut: the entry is longer than a digest]\n\n"
        parts.append(block)
        used.append(e)
        size += len(block)
    return "".join(parts), used


# ---------- review findings and failed acceptance checks ----------

SEVERE = {"P0", "P1", "P2", "high", "medium"}


def evidence_files(env):
    """review.json in review-<n>/reviewer-<n> folders and every ac.json under ~/.hermes/plans/*/evidence/,
    found with a walk that never follows a link and skips earlier-*/original-* copies."""
    out = []
    try:
        projects = sorted(p for p in env.plans.iterdir() if p.is_dir() and not p.is_symlink())
    except OSError:
        return out
    for proj in projects:
        ev = proj / "evidence"
        if not ev.is_dir() or ev.is_symlink():
            continue
        for root, dirs, files in os.walk(ev, followlinks=False):
            dirs[:] = sorted(d for d in dirs if not d.startswith(("earlier-", "original-"))
                             and not os.path.islink(os.path.join(root, d)))
            rel = Path(root).relative_to(ev)
            if not rel.parts:
                continue
            story = rel.parts[0]
            folder = Path(root).name
            for f in sorted(files):
                full = Path(root) / f
                if full.is_symlink():
                    continue
                if f == "review.json" and re.fullmatch(r"review(er)?-\d+", folder):
                    out.append((proj.name, story, full))
                elif f == "ac.json":
                    out.append((proj.name, story, full))
    return out


def line_id(project, story, claim):
    return hashlib.sha256(("%s\0%s\0%s" % (project, story, claim)).encode()).hexdigest()


def mtime(f):
    try:
        return f.stat().st_mtime
    except OSError:
        return None


def story_times(env, files=None):
    """{"<project>/<story>": the time of the story's first evidence file}: its earliest review.json or ac.json.
    A later review round adds newer files and leaves it as it was; evidence never leaves the machine it was
    written on (setup/mac.md), so these are that machine's own clock (R5-1)."""
    out = {}
    for project, story, f in evidence_files(env) if files is None else files:
        t, key = mtime(f), "%s/%s" % (project, story)
        if t is not None and (key not in out or t < out[key]):
            out[key] = t
    return out


def review_lines(env, seen):
    """One line per new P0-P2 (or high/medium) finding and per failed AC; `seen` holds line ids done. Each line
    carries `time`, its file's time, and `story_time`, its story's first evidence (story_times)."""
    seen = set(seen)
    out = []
    files = evidence_files(env)
    first = story_times(env, files)
    for project, story, f in files:
        try:
            data = json.loads(f.read_text())
        except (OSError, ValueError):
            continue
        if not isinstance(data, dict):
            continue  # not the shape of a review or an ac.json (R1-13)
        rows = []
        if f.name == "review.json":
            for x in data.get("findings") or []:
                if not isinstance(x, dict) or x.get("severity") not in SEVERE:
                    continue
                where = x.get("file_line") or ":".join(str(x[k]) for k in ("file", "line") if x.get(k) is not None)
                rows.append((str(x.get("id", "")), x["severity"], where, str(x.get("claim") or x.get("title") or "")))
        else:
            for x in data.get("ac_status") or []:
                if not isinstance(x, dict) or x.get("accepted") is not False or x.get("not_run"):
                    continue
                claim = str(x.get("reason") or x.get("evidence") or x.get("why") or "not accepted")
                rows.append((str(x.get("ac", "")), "AC", str(x.get("test") or ""), claim))
        for fid, sev, where, claim in rows:
            claim = claim[:CLAIM_MAX]
            lid = line_id(project, story, claim)
            if lid in seen:
                continue
            seen.add(lid)
            out.append({"id": lid, "project": project, "story": story, "finding": fid, "severity": sev,
                        "file": where, "claim": claim, "time": mtime(f),
                        "story_time": first.get("%s/%s" % (project, story))})
    return out
