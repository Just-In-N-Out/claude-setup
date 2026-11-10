"""Step 7 of a run, no model: every guard on the editor's copy. Any failure and nothing goes live,
whatever the helpers, the editor and the checker said (DREAM.md sections 5 to 9).

One function per guard, each returning a list of plain-word failures; run_all() runs them all.
"""
import re
import subprocess
from pathlib import Path

from . import extract, mistakes, paths, targets

DATE = re.compile(r"\b\d{4}-\d{2}-\d{2}\b")
TYPED_LABELS = ("TYPED", "QUEUED", "mid-turn", "ANSWER", "PASTE (whole message)")


def norm(s):
    return " ".join((s or "").split())


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

    def live(self, d):
        m = self.mapping.get(d.copy)
        return m["live"] if m else d.live

    def is_rm(self, d):
        return self.live(d).endswith("/references/repeat-mistakes.md")

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
        if cs and all(c.get("basis") in ("duplicate", "move") for c in cs):
            b = budget_for(env, real)
            if b and len(d.old.encode()) > b[0]:
                over_budget_tidies += 1
                ok_files.add(d.copy)
                continue
        if G.moved_in.get(d.copy) and set(ln for ln in d.added if ln.strip()) <= G.moved_in[d.copy] | _heading_lines(d):
            pending_moves.append(d)
            continue
        out.append("%s: no finding or order allows this file (narrowest place first; the global CLAUDE.md and "
                   "general skills need a finding stated as general or seen in two projects)" % live)
    for d in pending_moves:  # a move's destination is fine when its text came from a file that is fine
        sources = {s for ln in G.moved_in[d.copy] for s in _sources(G, ln)}
        if not sources <= ok_files:
            out.append("%s: text moved here from a file no finding allows" % G.live(d))
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
        for what, old, new, cap in (("bytes", len(d.old.encode()), len(d.new.encode()), b[0]),
                                    ("lines", len(d.old.splitlines()), len(d.new.splitlines()), b[1])):
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
            if "\n### " in "\n" + d.old and added + removed > c.get("repeat_mistakes_change", 4000):
                out.append("%s: %d bytes changed (cap %d per run once it has entries)"
                           % (live, added + removed, c.get("repeat_mistakes_change", 4000)))
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
    out = []
    for c in G.by_file.get(d.copy, []):
        basis = c.get("basis")
        ids = c.get("finding_ids") or []
        if basis == "finding" and ids and all(i in G.findings for i in ids):
            out.append(c)
        elif basis == "order" and c.get("order_id") in G.orders:
            out.append(c)
        elif basis in ("duplicate", "move"):
            out.append(c)
    return out


def _all_copy_text(G):
    out = []
    for d in G.diffs:
        out.append(d.new)
    for rel in G.mapping:
        t = G.copy_text(rel)
        if t:
            out.append(t)
    return "\n".join(out)


def removal_ok(G, d, line, cs, everything):
    n = norm(line)
    for c in cs:
        for r in c.get("removals") or []:
            if not isinstance(r, dict) or n not in norm(r.get("text")):
                continue
            reason = r.get("reason")
            if reason in ("outdated", "wrong") and c.get("basis") == "finding":
                return True
            if reason == "retired" and c.get("basis") == "order":
                return True
            if reason == "duplicate":
                s = norm(r.get("surviving_text"))
                if s and s in norm(everything):
                    return True
            if reason == "moved":
                t = G.copy_text(str(r.get("moved_to") or ""))
                if t is not None and n in norm(t):
                    return True
    return False


def g_accounting(G):
    out = []
    everything = _all_copy_text(G)
    for d in G.diffs:
        if G.is_rm(d):
            continue  # the repeat-mistakes files are checked entry by entry (mistakes.check_copy)
        cs = _valid_changes(G, d)
        mo, mi = G.moved_out.get(d.copy, set()), G.moved_in.get(d.copy, set())
        for ln in d.removed:
            if not ln.strip() or ln in mo:
                continue
            if not removal_ok(G, d, ln, cs, everything):
                out.append("%s: a removed line is not accounted for: \"%s\"" % (G.live(d), ln.strip()[:80]))
        adds = [norm(a) for c in cs if c.get("basis") in ("finding", "order", "duplicate", "move")
                for a in (c.get("additions") or []) if isinstance(a, str)]
        for ln in d.added:
            if not ln.strip() or ln in mi:
                continue
            if not any(norm(ln) in a for a in adds):
                out.append("%s: an added line is not listed against a finding or order: \"%s\"" % (G.live(d), ln.strip()[:80]))
    return out


# ---------- AC44: every finding settled; "already saved" texts really there ----------

def g_settled(G):
    out = []
    ch = G.changes
    seen = {}
    for c in ch.get("changes") or []:
        for i in c.get("finding_ids") or []:
            seen.setdefault(i, []).append("applied")
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
        cs = G.by_file.get(d.copy, [])
        for ln in d.removed:
            dates = DATE.findall(ln)
            if not dates or ln in mo:
                continue
            ok = False
            n = norm(ln)
            for c in cs:
                if not any(n in norm(r.get("text")) for r in c.get("removals") or [] if isinstance(r, dict)):
                    continue
                if c.get("basis") == "finding":
                    fs = [G.findings.get(i) for i in c.get("finding_ids") or []]
                    if any(f and f.get("replaces", "").strip() and not f.get("ambiguous") and
                           f.get("label") in TYPED_LABELS for f in fs):
                        ok = True
                elif c.get("basis") == "duplicate":
                    for r in c.get("removals") or []:
                        if n in norm(r.get("text")) and all(x in (r.get("surviving_text") or "") for x in dates):
                            ok = True
                elif c.get("basis") == "order":
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
