"""Step 4 of a run, no model: the bar every helper finding must pass (DREAM.md sections 3, 4, 8, 9).

Per finding, in this order: the quote must be word for word in the named entry's own text; a finding
already applied, a personal detail, a secret, or a code-like token the quote does not hold is dropped
(its text is never logged); anything loosening safety or weakening a check, anything ambiguous or meant
for one task goes on Justin's list; a stated correction, decision, preference or fact passes at once;
an implied one (or one that needs an unseen image) waits in the pending list for a second session.
"""
import datetime
import hashlib
import re

from . import extract, paths

QUOTE_MIN = 15
PENDING_DAYS = 60
STATED = {"correction", "decision", "preference", "fact"}


def norm(s):
    return " ".join((s or "").split())


def quotable(entry):
    """The text of an entry that is Justin's own: for an ANSWER, the option he chose and what he wrote."""
    if entry.get("label") == "ANSWER":
        return [c for c in entry.get("chosen") or []] + ([entry["own"]] if entry.get("own") else [])
    return [entry.get("text") or ""]


def quote_ok(entries, uuid, quote):
    """The quote is word for word (whitespace runs as one space) in the own text of an entry with that uuid,
    and is at least 15 characters long or the whole of that text."""
    q = norm(quote)
    if not q:
        return False
    for e in entries:
        if e.get("uuid") != uuid:
            continue
        for t in quotable(e):
            t = norm(t)
            if q in t and (len(q) >= QUOTE_MIN or q == t):
                return True
    return False


def finding_id(session, uuid, quote):
    return hashlib.sha256(("%s\0%s\0%s" % (session, uuid, norm(quote))).encode()).hexdigest()[:12]


def code_like(statement, source):
    """Tokens of the statement that look like a code (8+ characters mixing letters and digits, or 6+
    digits) and are not in the quoted entry's text."""
    out = []
    for t in re.findall(r"[A-Za-z0-9]+", statement or ""):
        if (len(t) >= 8 and re.search(r"\d", t) and re.search(r"[A-Za-z]", t)) or re.fullmatch(r"\d{6,}", t):
            if t not in source:
                out.append(t)
    return out


def task_only_phrases(env):
    return [ln.strip().lower() for ln in paths.read_conf_lines(env.conf / "task-only-phrases.txt")]


def list_item(f, why, kind="could not apply"):
    return {"id": f.get("id", ""), "date": f.get("date", ""), "kind": kind, "quote": f.get("quote", ""),
            "statement": f.get("statement", ""), "session": f.get("session", ""), "why": why}


class Result:
    def __init__(self):
        self.total = 0
        self.passed = []
        self.list_items = []
        self.dropped = []
        self.discarded = False
        self.corrections = 0


def check(env, read, used, findings, pending, applied, now):
    """Run the bar over one helper's findings for one session read. `pending` is updated in place unless
    the helper's output is discarded (more than half of its quotes failed)."""
    res = Result()
    findings = [f for f in findings if isinstance(f, dict)]
    res.total = len(findings)
    session = read.session
    phrases = task_only_phrases(env)
    cands = dict((pending or {}).get("candidates") or {})
    cands = {k: dict(v) for k, v in cands.items()}
    quoted, failed = [], 0
    for f in findings:
        uuid, quote = str(f.get("uuid") or ""), str(f.get("quote") or "")
        if not quote_ok(used, uuid, quote):
            failed += 1
            res.dropped.append("1 quote not found in its entry (session %s)" % session[:8])
            continue
        quoted.append(f)
    if failed * 2 > res.total:
        res.discarded = True
        res.dropped.append("all %d finding(s) of session %s discarded: more than half had no verbatim quote; the "
                           "session is read again next run" % (res.total, session[:8]))
        return res
    texts = [norm(f.get("quote")) + "\n" + norm(f.get("statement")) for f in quoted]
    flagged = set(i for i, hit in enumerate(extract.secret_flags(texts, env)) if hit) if texts else set()
    for i, f in enumerate(quoted):
        uuid, quote = str(f["uuid"]), str(f["quote"])
        entries = [e for e in used if e.get("uuid") == uuid]
        source = "\n".join(t for e in entries for t in quotable(e))
        fid = finding_id(session, uuid, quote)
        rec = {"id": fid, "session": session, "folder": read.folder, "project": read.project, "uuid": uuid,
               "quote": quote, "kind": f.get("kind"), "statement": str(f.get("statement") or ""),
               "date": entries[0]["date"], "label": entries[0]["label"], "general": bool(f.get("general")),
               "two_projects": False, "replaces": str(f.get("replaces") or ""), "ambiguous": bool(f.get("ambiguous")),
               "tries": 0}
        if f.get("kind") == "correction":
            res.corrections += 1
        if fid in applied:
            res.dropped.append("1 finding already applied (%s)" % fid)
            continue
        if f.get("personal"):
            res.dropped.append("1 finding dropped: a personal detail about another person (session %s)" % session[:8])
            continue
        if i in flagged:
            res.dropped.append("1 finding dropped: its text looks like a secret (session %s)" % session[:8])
            continue
        if code_like(rec["statement"], source):
            res.dropped.append("1 finding dropped: its lesson holds a code-like token its message does not "
                               "(session %s)" % session[:8])
            continue
        if f.get("loosens_safety") or f.get("weakens_check"):
            why = "loosens a safety rule" if f.get("loosens_safety") else "a fix that weakens a check"
            res.list_items.append(list_item(rec, why + ": only Justin decides this", kind="safety"))
            continue
        q = norm(quote).lower()
        if f.get("ambiguous") or any(p in q for p in phrases):
            why = "the message can be read two ways" if f.get("ambiguous") else "it reads as meant for one task"
            res.list_items.append(list_item(rec, why + "; is it a standing rule?", kind="question"))
            continue
        kind = "implied" if f.get("depends_on_image") else f.get("kind")
        if kind in STATED:
            res.passed.append(rec)
            continue
        if kind != "implied":
            res.dropped.append("1 finding dropped: unknown kind (session %s)" % session[:8])
            continue
        m = str(f.get("matches_pending") or "")
        if m and m in cands:
            c = cands[m]
            if session in (c.get("sessions") or []):
                continue  # the same session again is not a second sighting
            projects = set(c.get("projects") or []) | {read.project}
            rec["two_projects"] = len(projects) >= 2
            rec["pending_id"] = m
            res.passed.append(rec)
            del cands[m]
            continue
        if fid not in cands:
            cands[fid] = {"statement": rec["statement"], "quote": quote, "uuid": uuid, "session": session,
                          "folder": read.folder, "project": read.project, "date": rec["date"],
                          "first_seen": now.date().isoformat(), "sessions": [session], "projects": [read.project]}
    pending["candidates"] = cands
    return res


def expire(pending, now):
    """Drop pending candidates unmatched for 60 days; one log line each."""
    out = []
    cands = pending.setdefault("candidates", {})
    for k in sorted(cands):
        try:
            seen = datetime.date.fromisoformat(cands[k].get("first_seen", ""))
        except ValueError:
            continue
        if (now.date() - seen).days > PENDING_DAYS:
            del cands[k]
            out.append("pending candidate %s dropped: unmatched for %d days" % (k, PENDING_DAYS))
    return out
