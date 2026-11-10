"""Step 7 of a run, no model: every guard on the editor's copy. Any failure and nothing goes live,
whatever the helpers, the editor and the checker said (DREAM.md sections 5 to 9).

One function per guard, each returning a list of plain-word failures; run_all() runs them all.
"""
import posixpath
import re
import subprocess
from pathlib import Path

from . import extract, mistakes, paths, targets

DATE = re.compile(r"\b\d{4}-\d{2}-\d{2}\b")
WORD = re.compile(r"[a-z0-9]+")
TYPED_LABELS = ("TYPED", "QUEUED", "mid-turn", "ANSWER", "PASTE (whole message)")
# the one shape of the line a move may leave behind (R2-9; Justin 2026-11-10; DREAM.md section 6)
POINTER = "See `%s` for the section \"%s\" (moved there word for word)."
POINTER_BARE = "See `%s` (moved there word for word)."   # for moved text that starts with no heading
HEADING = re.compile(r"^#+\s+(\S.*?)\s*$")
MEMORY_NOTE = re.compile(r"^(\.claude/projects/[^/]+/memory)/([^/]+\.md)$")


def typed_label(label):
    """Entries of text Justin typed, slash-command text included (plan step 2; R1-19)."""
    return label in TYPED_LABELS or str(label or "").startswith("SLASH /")


def norm(s):
    return " ".join((s or "").split())


def pointer_places(src, dst):
    """The files (live paths) a pointer for text moved from src to dst may sit in (R2-9): src itself when dst
    is a file of src's skill's references/ folder; src or its folder's MEMORY.md when both are notes of one
    memory folder (a new note must be named there). None for any other move: the index and the
    repeat-mistakes files are never a side of one."""
    s, t = Path(src), Path(dst)
    if s.suffix != ".md" or t.suffix != ".md" or "MEMORY.md" in (s.name, t.name) or \
            "repeat-mistakes.md" in (s.name, t.name):
        return []
    ms, mt = MEMORY_NOTE.match(src), MEMORY_NOTE.match(dst)
    if ms and mt and ms.group(1) == mt.group(1):
        return [src, ms.group(1) + "/MEMORY.md"]
    if t.parent.name == "references" and s.parent in (t.parent, t.parent.parent):
        return [src]
    return []


def pointer_lines(diffs, live):
    """{(live path of the file a line may sit in, the exact line): (source copy, destination copy)} for every
    move that may leave a pointer: the destination received exactly the lines the source lost to it, in order,
    and nothing else; the line names the destination from the folder of the file it sits in, and the moved
    text's first heading word for word when it starts with one."""
    out = {}
    for s in diffs:
        if s.status != "M":
            continue
        for t in diffs:
            places = pointer_places(live(s), live(t)) if t is not s and t.status != "D" else []
            got = [ln for ln in t.added if ln.strip()]
            block = [ln for ln in s.removed if ln.strip() and ln in set(got)]
            if not places or not got or block != got:
                continue
            h = HEADING.match(block[0])
            for p in places:
                rel = posixpath.relpath(live(t), posixpath.dirname(p))
                out[(p, POINTER % (rel, h.group(1)) if h else POINTER_BARE % rel)] = (s.copy, t.copy)
    return out


class Input:
    def __init__(self, env, run_dir, mapping, diffs, links, findings, orders, changes, tally, rules):
        self.env, self.dir, self.mapping = env, Path(run_dir), mapping
        self.diffs, self.links = diffs, links
        self.findings = {f["id"]: f for f in findings}
        self.orders = {o["id"]: o for o in orders}
        self.changes = changes or {}
        self.tally, self.rules = tally, rules
        self.by_file = {}
        for c in self.changes.get("changes") or []:
            if isinstance(c, dict):
                self.by_file.setdefault(str(c.get("file", "")), []).append(c)
        self.copy = self.dir / "copy"
        # the copy's targets: the files copied in and the files the editor added (never _dream/)
        self.targets = set(mapping) | {d.copy for d in diffs if d.status == "A"}
        # lines that left one file and arrived in another, word for word
        added = {}
        removed = {}
        for d in diffs:
            for ln in d.added:
                if ln.strip():
                    added.setdefault(ln, set()).add(d.copy)
            for ln in d.removed:
                if ln.strip():
                    removed.setdefault(ln, set()).add(d.copy)
        self.moved_out = {d.copy: {ln for ln in d.removed if ln.strip() and added.get(ln, set()) - {d.copy}}
                          for d in diffs}
        self.moved_in = {d.copy: {ln for ln in d.added if ln.strip() and removed.get(ln, set()) - {d.copy}}
                         for d in diffs}
        # whole lines of the targets before and after the edit: a duplicate's surviving text must be in both
        changed = {d.copy for d in diffs}
        self.before_lines, self.after_lines = set(), set()
        for d in diffs:
            self.before_lines.update(norm(ln) for ln in d.old.splitlines() if ln.strip())
            self.after_lines.update(norm(ln) for ln in d.new.splitlines() if ln.strip())
        for rel in mapping:
            if rel not in changed:
                lines = {norm(ln) for ln in (self.copy_text(rel) or "").splitlines() if ln.strip()}
                self.before_lines |= lines
                self.after_lines |= lines
        self.pointers = pointer_lines(diffs, self.live)

    def live(self, d):
        m = self.mapping.get(d.copy)
        return m["live"] if m else d.live

    def is_rm(self, d):
        return self.live(d).endswith("/references/repeat-mistakes.md")

    def base(self, d):
        """What a file's change is measured from. For a repeat-mistakes file that is the script's own rewrite
        of it as it was (counts, stories and order from the tally: mistakes.normalize_text), which is not the
        editor's change and is charged to no cap or budget (R2-2); for any other file, the file as it was."""
        if self.is_rm(d) and d.status == "M":
            return mistakes.normalize_text(d.old, self.tally)
        return d.old

    def copy_text(self, rel):
        try:
            return (self.copy / rel).read_text()
        except OSError:
            return None


# ---------- AC18: allowlist and the narrowest place ----------

def g_allowlist(G):
    out = []
    env = G.env
    ok_files = set()
    pending_moves = []
    pointer_only = []
    over_budget_tidies = 0
    for d in G.diffs:
        live = G.live(d)
        if d.status == "A" and targets.through_link(env, live):
            out.append("%s: reached through a link" % live)
            continue
        real = env.real_rel(live) if d.status == "A" else live
        if real != live:
            out.append("%s: reached through a link (real path %s)" % (live, real))
            continue
        if targets.kind_of(G.rules, real) != "allow":
            out.append("%s: not an allowed target" % live)
            continue
        cs = G.by_file.get(d.copy, [])
        fids = [i for c in cs for i in (c.get("finding_ids") or [])]
        if any(i in G.findings and targets.in_scope(targets.scope_for(env, G.findings[i]), real) for i in fids):
            ok_files.add(d.copy)
            continue
        if any(c.get("basis") == "order" and c.get("order_id") in G.orders and
               real in (G.orders[c["order_id"]].get("file"), G.orders[c["order_id"]].get("to")) for c in cs):
            ok_files.add(d.copy)
            continue
        if G.is_rm(d) and d.status == "M" and mistakes.normalize_text(d.old, G.tally) == d.new:
            ok_files.add(d.copy)  # only the script's own rewrite: counts, stories and order from the tally (R1-3)
            continue
        if cs and all(c.get("basis") in ("duplicate", "move") for c in cs):
            b = budget_for(env, real)
            if b and len(d.old.encode()) > b[0]:
                over_budget_tidies += 1
                ok_files.add(d.copy)
                continue
        if G.moved_in.get(d.copy) and set(ln for ln in d.added if ln.strip()) <= G.moved_in[d.copy] | _heading_lines(d):
            pending_moves.append(d)
            continue
        added = [ln for ln in d.added if ln.strip()]
        if d.status == "M" and added and not any(ln.strip() for ln in d.removed) and \
                all((real, ln) in G.pointers for ln in added):
            pointer_only.append((d, {G.pointers[(real, ln)][0] for ln in added}))   # a MEMORY.md naming a moved note
            continue
        out.append("%s: no finding or order allows this file (narrowest place first; the global CLAUDE.md and "
                   "general skills need a finding stated as general or seen in two projects)" % live)
    for d in pending_moves:  # a move's destination is fine when its text came from a file that is fine
        sources = {s for ln in G.moved_in[d.copy] for s in _sources(G, ln)}
        if not sources <= ok_files:
            out.append("%s: text moved here from a file no finding allows" % G.live(d))
    for d, sources in pointer_only:  # and so is a file whose only change is the pointer to it (R2-9)
        if not sources <= ok_files:
            out.append("%s: a pointer to text moved from a file no finding allows" % G.live(d))
    if over_budget_tidies > 2:
        out.append("tidied %d files over budget with no finding; at most 2" % over_budget_tidies)
    return out


def _heading_lines(d):
    return {ln for ln in d.added if ln.startswith("#")}


def _sources(G, line):
    return {d.copy for d in G.diffs if line in d.removed}


# ---------- AC11: frozen sections ----------

def section(text, heading):
    lines = text.splitlines(True)
    for i, ln in enumerate(lines):
        m = re.match(r"^(#+) (.*?)\s*$", ln)
        if m and m.group(2) == heading:
            level = len(m.group(1))
            j = i + 1
            while j < len(lines):
                n = re.match(r"^(#+) ", lines[j])
                if n and len(n.group(1)) <= level:
                    break
                j += 1
            return "".join(lines[i:j])
    return None


def g_protected(G):
    out = []
    by_live = {G.live(d): d for d in G.diffs}
    for row in paths.read_tsv(G.env.conf / "protected.tsv"):
        if len(row) < 2:
            continue
        rel, heading = row[0], row[1]
        d = by_live.get(rel)
        if d is None:
            continue
        if d.status == "D":
            out.append("%s: a file with a frozen section was deleted" % rel)
        elif heading == "*":
            out.append("%s: the whole file is frozen" % rel)
        else:
            old, new = section(d.old, heading), section(d.new, heading)
            if old is None:
                out.append("%s: the frozen heading \"%s\" no longer exists in its file" % (rel, heading))
            elif new != old:
                out.append("%s: changed the frozen section \"%s\"" % (rel, heading))
    return out


# ---------- AC14: budgets ----------

def budget_for(env, rel):
    for row in paths.read_tsv(env.conf / "budgets.tsv"):
        if len(row) >= 2 and paths.glob_match(row[0], rel):
            return int(row[1]), (int(row[2]) if len(row) > 2 and row[2].strip() else None)
    return None


def g_budgets(G):
    out = []
    for d in G.diffs:
        live = G.live(d)
        b = budget_for(G.env, live)
        if not b or d.status == "D":
            continue
        base = G.base(d)
        for what, old, new, cap in (("bytes", len(base.encode()), len(d.new.encode()), b[0]),
                                    ("lines", len(base.splitlines()), len(d.new.splitlines()), b[1])):
            if cap is None:
                continue
            if old > cap and new > old:
                out.append("%s: over its budget (%d %s > %d) and growing; it may only shrink" % (live, old, what, cap))
            elif old <= cap < new:
                out.append("%s: would cross its budget (%d %s > %d)" % (live, new, what, cap))
    return out


# ---------- AC15: change caps ----------

def caps(env):
    kv = paths.read_kv(env.conf / "caps.conf")
    return {k: int(v) for k, v in kv.items() if v.lstrip("-").isdigit()}


def g_caps(G):
    c = caps(G.env)
    nb = targets.FileDiff.nbytes
    out = []
    files = [d for d in G.diffs]
    if len(files) > c.get("files_changed", 12):
        out.append("%d files changed (cap %d)" % (len(files), c.get("files_changed", 12)))
    new = [d for d in files if d.status == "A"]
    if len(new) > c.get("new_files", 2):
        out.append("%d new files (cap %d)" % (len(new), c.get("new_files", 2)))
    gone = [d for d in files if d.status == "D"]
    if len(gone) > c.get("deleted_files", 0):
        out.append("a file would be deleted (%s)" % ", ".join(G.live(d) for d in gone))
    libs = {targets.library_skill(G.live(d)) for d in files if targets.is_library(G.live(d))}
    if len(libs) > c.get("library_skills", 3):
        out.append("%d library skills changed (cap %d)" % (len(libs), c.get("library_skills", 3)))
    run_add = run_rem = moved = 0
    for d in files:
        live = G.live(d)
        mo, mi = G.moved_out.get(d.copy, set()), G.moved_in.get(d.copy, set())
        added = nb([ln for ln in d.added if ln not in mi])
        removed = nb([ln for ln in d.removed if ln not in mo])
        moved += nb([ln for ln in d.removed if ln in mo])
        if G.is_rm(d):
            ed = targets.FileDiff(d.copy, d.status, G.base(d), d.new)  # the editor's change, not the script's (R2-2)
            changed = nb([ln for ln in ed.added if ln not in mi]) + nb([ln for ln in ed.removed if ln not in mo])
            if "\n### " in "\n" + d.old and changed > c.get("repeat_mistakes_change", 4000):
                out.append("%s: %d bytes changed (cap %d per run once it has entries)"
                           % (live, changed, c.get("repeat_mistakes_change", 4000)))
            continue
        if added > c.get("file_added", 3000):
            out.append("%s: %d bytes added (cap %d)" % (live, added, c.get("file_added", 3000)))
        cap_rem = max(c.get("file_removed", 3000), len(d.old.encode()) * c.get("file_removed_pct", 5) // 100)
        if removed > cap_rem:
            out.append("%s: %d bytes removed (cap %d)" % (live, removed, cap_rem))
        run_add += added
        run_rem += removed
    if run_add > c.get("run_added", 12000):
        out.append("%d bytes added in this run (cap %d)" % (run_add, c.get("run_added", 12000)))
    if run_rem > c.get("run_removed", 12000):
        out.append("%d bytes removed in this run (cap %d)" % (run_rem, c.get("run_removed", 12000)))
    if moved > c.get("moved", 30000):
        out.append("%d bytes moved in this run (cap %d)" % (moved, c.get("moved", 30000)))
    return out


# ---------- AC16: canary facts ----------

def g_canary(G):
    out = []
    by_live = {G.live(d): d for d in G.diffs}
    for row in paths.read_tsv(G.env.conf / "canary.tsv"):
        if len(row) < 2:
            continue
        d = by_live.get(row[0])
        if d and row[1] in d.old and row[1] not in d.new:
            out.append("%s: lost the exact fact \"%s\"" % (row[0], row[1][:80]))
    return out


# ---------- AC17: every removed and added line is accounted for ----------

def _valid_changes(G, d):
    """The changes whose lines may count in this file (R2-1). A finding change counts only in a file every
    finding it cites may change (its narrowest place, AC18); a tidy (duplicate or move) counts where the
    allowlist lets it, and adds nothing. An order names a repeat-mistakes file, which mistakes.check_copy
    checks entry by entry and this accounting skips, so an order change counts in no file here."""
    real = G.env.real_rel(G.live(d)) if d.status == "A" else G.live(d)
    out = []
    for c in G.by_file.get(d.copy, []):
        basis = c.get("basis")
        ids = c.get("finding_ids") or []
        if basis == "finding" and ids and all(
                i in G.findings and targets.in_scope(targets.scope_for(G.env, G.findings[i]), real) for i in ids):
            out.append(c)
        elif basis in ("duplicate", "move"):
            out.append(c)
    return out


def words(s):
    return {w for w in WORD.findall((s or "").lower()) if len(w) >= 3}


def duplicate_ok(G, line, removal):
    """A removal called a duplicate (R1-2): its surviving text is one or more whole lines that were in a
    target before the edit and are still there after it, and they say what the removed line says: at least
    half of its words and every date it holds."""
    surv = [norm(x) for x in str(removal.get("surviving_text") or "").splitlines() if x.strip()]
    if not surv or any(s not in G.before_lines or s not in G.after_lines for s in surv):
        return False
    text = " ".join(surv)
    if not all(x in text for x in DATE.findall(line)):
        return False
    rw = words(line)
    if not rw:
        return norm(line) in surv
    return 2 * len(rw & words(text)) >= len(rw)


def removal_ok(G, d, line, cs):
    n = norm(line)
    for c in cs:
        for r in c.get("removals") or []:
            if not isinstance(r, dict) or n not in norm(r.get("text")):
                continue
            reason = r.get("reason")
            if reason in ("outdated", "wrong") and c.get("basis") == "finding":
                return True
            if reason == "duplicate" and duplicate_ok(G, line, r):
                return True
            if reason == "moved":
                # the destination is a target of the copy, never the editor's own _dream/ files (R2-1)
                dest = str(r.get("moved_to") or "")
                t = G.copy_text(dest) if dest in G.targets else None
                if t is not None and n in norm(t):
                    return True
    return False


def fold_rest(old_line, new_line):
    """The words a fold adds (R2-4), or None. A fold keeps the old line whole, word for word, at the start of the
    new one (only its final full stop or semicolon may go) and goes on after it at a word boundary: nothing of
    the old line is lost, and nothing is put in front of it that could turn it around."""
    o, n = norm(old_line), norm(new_line)
    core = o.rstrip(".;").rstrip()
    if not core or len(n) <= len(core) or not n.startswith(core) or (n[len(core)].isalnum() or n[len(core)] == "_"):
        return None
    return n[len(core):].strip(" .,;:") or None


def folds(G, d):
    """{added line: the removed line it folds}: an added line that starts with a removed line of the same file
    whole and whose added words are a listed addition of a finding change that may change this file (DREAM.md
    section 6: fold a lesson into an existing line first; dated entries keep their date and their why)."""
    adds = [norm(a) for c in _valid_changes(G, d) if c.get("basis") == "finding"
            for a in (c.get("additions") or []) if isinstance(a, str)]
    mi = G.moved_in.get(d.copy, set())
    out = {}
    for a in d.added:
        if not a.strip() or a in mi:
            continue
        for r in d.removed:
            rest = fold_rest(r, a) if r.strip() else None
            if rest and any(rest in x for x in adds):
                out[a] = r
                break
    return out


def g_accounting(G):
    out = []
    used = set()  # one pointer per move (R2-9)
    for d in G.diffs:
        if G.is_rm(d):
            continue  # the repeat-mistakes files are checked entry by entry (mistakes.check_copy)
        cs = _valid_changes(G, d)
        mo, mi = G.moved_out.get(d.copy, set()), G.moved_in.get(d.copy, set())
        fo = folds(G, d)  # a line folded into stays whole in its new line: no removal, and its new line is listed
        kept = set(fo.values())
        for ln in d.removed:
            if not ln.strip() or ln in mo or ln in kept:
                continue
            if not removal_ok(G, d, ln, cs):
                out.append("%s: a removed line is not accounted for: \"%s\"" % (G.live(d), ln.strip()[:80]))
        # text a tidy writes (basis duplicate or move) is not evidence: only a finding may add a line here (an
        # order adds only to its repeat-mistakes file); text moved word for word from another target is not an
        # addition (R1-2, R2-1)
        adds = [norm(a) for c in cs if c.get("basis") == "finding"
                for a in (c.get("additions") or []) if isinstance(a, str)]
        for ln in d.added:
            if not ln.strip() or ln in mi or ln in fo:
                continue
            mv = G.pointers.get((G.live(d), ln)) if d.status == "M" else None
            if mv and mv not in used:
                used.add(mv)  # the line a move leaves behind, of the one shape the script builds (R2-9)
                continue
            if not any(norm(ln) in a for a in adds):
                out.append("%s: an added line is not listed against a finding or order: \"%s\"" % (G.live(d), ln.strip()[:80]))
    return out


# ---------- AC44: every finding settled; "already saved" texts really there ----------

def g_settled(G):
    out = []
    ch = G.changes
    seen = {}
    by_copy = {d.copy: d for d in G.diffs}
    for c in ch.get("changes") or []:
        ids = c.get("finding_ids") or []
        for i in ids:
            seen.setdefault(i, []).append("applied")
        if not ids:
            continue
        # applied means the file really changed and holds what the change lists (R1-4)
        d = by_copy.get(str(c.get("file") or ""))
        if d is None:
            out.append("finding %s: changes.json lists it as applied to %s, which the editor did not change"
                       % (", ".join(ids), c.get("file")))
            continue
        added = norm("\n".join(d.added))
        for a in c.get("additions") or []:
            if norm(a) and norm(a) not in added:
                out.append("finding %s: an addition changes.json lists is not in the diff of %s: \"%s\""
                           % (", ".join(ids), c.get("file"), norm(a)[:80]))
    for s in ch.get("already_saved") or []:
        i = s.get("finding_id")
        seen.setdefault(i, []).append("saved")
        text = G.copy_text(str(s.get("file") or ""))
        ex = norm(s.get("existing_text"))
        if not ex or text is None or ex not in norm(text):
            out.append("finding %s: the text the editor says is already saved is not in %s" % (i, s.get("file")))
    for s in ch.get("declined") or []:
        i = s.get("finding_id")
        seen.setdefault(i, []).append("declined")
        if not str(s.get("reason") or "").strip():
            out.append("finding %s: declined with no reason" % i)
    for i in G.findings:
        if i not in seen:
            out.append("finding %s: neither applied, already saved nor declined" % i)
    for i in seen:
        if i not in G.findings:
            out.append("changes.json names a finding that is not in this run: %s" % i)
    return out


# ---------- AC45: dated lines ----------

def g_dated_lines(G):
    out = []
    for d in G.diffs:
        if G.is_rm(d):
            continue
        mo = G.moved_out.get(d.copy, set())
        cs = G.by_file.get(d.copy, [])  # an order replaces no dated line: it adds only to its repeat-mistakes file (R2-1)
        kept = set(folds(G, d).values())  # a dated line folded into stays whole, date and why included (R2-4)
        for ln in d.removed:
            dates = DATE.findall(ln)
            if not dates or ln in mo or ln in kept:
                continue
            ok = False
            n = norm(ln)
            for c in cs:
                if not any(n in norm(r.get("text")) for r in c.get("removals") or [] if isinstance(r, dict)):
                    continue
                if c.get("basis") == "finding":
                    fs = [G.findings.get(i) for i in c.get("finding_ids") or []]
                    if any(f and f.get("replaces", "").strip() and not f.get("ambiguous") and
                           typed_label(f.get("label")) for f in fs):
                        ok = True
                elif c.get("basis") == "duplicate":
                    for r in c.get("removals") or []:
                        if isinstance(r, dict) and n in norm(r.get("text")) and duplicate_ok(G, ln, r):
                            ok = True
            if not ok:
                out.append("%s: a dated line was removed or replaced without a clear typed finding naming what it "
                           "replaces: \"%s\"" % (G.live(d), ln.strip()[:80]))
    return out


# ---------- AC9: dates on additions ----------

def g_dates_on_additions(G):
    out = []
    for d in G.diffs:
        added = "\n".join(d.added)
        for c in G.by_file.get(d.copy, []):
            if c.get("basis") != "finding" or not (c.get("additions") or d.added):
                continue
            for i in c.get("finding_ids") or []:
                f = G.findings.get(i)
                if f and f.get("date") and f["date"] not in added:
                    out.append("%s: what was added for finding %s does not carry its date %s" % (G.live(d), i, f["date"]))
    return out


# ---------- AC12: secrets ----------

def g_secrets(G):
    texts, names = [], []
    for d in G.diffs:
        if d.status == "D":
            continue
        texts.append(d.new)
        names.append(G.live(d))
    flags = extract.secret_flags(texts, G.env) if texts else []
    out = []
    for d, name, t, hit in zip([d for d in G.diffs if d.status != "D"], names, texts, flags):
        regex_hit = any(rx.search("\n".join(d.added)) for rx in extract.TOKEN_RES)
        secret = extract._gitleaks_secrets([t], G.env)[0] if hit else set()
        if secret or regex_hit:
            out.append("%s: gitleaks or the token check flags the edited file" % name)
    return out


def log_secrets(env, text):
    flags = extract.secret_flags([text], env)
    return ["the log entry holds what looks like a secret"] if flags and flags[0] else []


# ---------- the rest ----------

def g_memory_index(G):
    out = []
    for d in G.diffs:
        live = G.live(d)
        m = re.match(r"^(\.claude/projects/[^/]+/memory)/(.+\.md)$", live)
        if d.status != "A" or not m or m.group(2) == "MEMORY.md":
            continue
        idx = G.copy_text(targets.copy_rel(m.group(1) + "/MEMORY.md"))
        if idx is None or Path(m.group(2)).name not in idx:
            out.append("%s: a new memory note must be named in its folder's MEMORY.md" % live)
    return out


def hunks(old, new):
    import difflib
    return sum(1 for ln in difflib.unified_diff(old.splitlines(), new.splitlines(), lineterm="", n=3)
               if ln.startswith("@@"))


def g_library(G):
    out = []
    lib = G.env.lib
    for d in G.diffs:
        live = G.live(d)
        if not targets.is_library(live):
            continue
        inner = live[len(".hermes/skills-library/"):]
        p = subprocess.run(["git", "-C", str(lib), "show", "HEAD:" + inner], capture_output=True, text=True,
                           env=G.env.environ)
        upstream = p.stdout if p.returncode == 0 else ""
        before = hunks(upstream, d.old)
        after = hunks(upstream, d.new)
        if after > max(1, before):
            out.append("%s: %d diff blocks against the library (was %d); keep library edits in one block per file"
                       % (live, after, before))
    return out


def g_links(G):
    return ["the copy holds a link: %s" % x for x in G.links]


def g_repeat_mistakes(G):
    return mistakes.check_copy(G)


ALL = [g_links, g_allowlist, g_protected, g_budgets, g_caps, g_canary, g_accounting, g_settled, g_dated_lines,
       g_dates_on_additions, g_secrets, g_repeat_mistakes, g_memory_index, g_library]


def run_all(G):
    out = []
    for g in ALL:
        out += g(G)
    return out
