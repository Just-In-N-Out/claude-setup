"""The log (DREAM.md section 12) and Justin's list (section 8).

dream-log.md gets one entry per run that read something, written by the apply step as part of the
dream commit (the markers move only after that commit). At the first run of a month the older month's
entries move to dream-log-YYYY-MM.md.
"""
import re

from . import paths

QUOTE_MAX = 300
LOG_HEAD = ("# Dream log\n\nOne entry per run that read something, newest last (rules: `DREAM.md` section 12). "
            "Older months move to `dream-log-YYYY-MM.md`.\n")
LIST_HEAD = ("# Justin's list\n\nItems only Justin may decide (`DREAM.md` section 8). The dream appends; delete an "
             "item once you have handled it.\n")


def read(env):
    try:
        return (env.dream / "dream-log.md").read_text()
    except OSError:
        return LOG_HEAD


def read_list(env):
    try:
        t = (env.dream / "justin-list.md").read_text()
    except OSError:
        t = LIST_HEAD
    return t if t.endswith("\n") else t + "\n"


def list_open(env):
    try:
        return sum(1 for ln in (env.dream / "justin-list.md").read_text().splitlines() if ln.startswith("- [ ]"))
    except OSError:
        return 0


def cut(text, n=QUOTE_MAX):
    t = " ".join((text or "").split())
    return t if len(t) <= n else t[: n - 1] + "…"


def list_lines(items):
    out = []
    for i in items:
        q = (' "%s"' % cut(i.get("quote"), 200)) if i.get("quote") else ""
        sess = (" (session %s)" % i["session"][:8]) if i.get("session") else ""
        out.append("- [ ] %s %s:%s %s%s. Why: %s\n" % (i.get("date") or "", i.get("kind", "item"), q,
                                                       i.get("statement", ""), sess, i.get("why", "")))
    return "".join(out)


def rotate(text, now):
    """(main log text, {archive file name: text}) — older months leave the main file."""
    parts = re.split(r"(?m)^(?=## Dream \d{4}-\d{2})", text)
    head, entries = parts[0], parts[1:]
    month = now.strftime("%Y-%m")
    keep, archives = [], {}
    for e in entries:
        m = re.match(r"## Dream (\d{4}-\d{2})", e)
        if m and m.group(1) < month:
            name = "dream-log-%s.md" % m.group(1)
            archives.setdefault(name, "# Dream log, %s\n\n" % m.group(1))
            archives[name] += e
        else:
            keep.append(e)
    main = head + "".join(keep)
    if not main.endswith("\n"):
        main += "\n"
    return main, archives


def entry(R, unsettled, P, changes, list_items, lg, cursors):
    env = R.env
    out = ["\n## Dream %s (run %s, %s)\n\n" % (R.now.strftime("%Y-%m-%d %H:%M"), R.id, R.mode)]
    sessions = lg.get("sessions") or []
    typed = sum((lg.get("typed") or {}).values())
    out.append("- Read: %d session(s), %d typed message(s); %d review line(s).\n"
               % (len(sessions), typed, R.facts.get("review_lines", 0)))
    for s in sessions:
        out.append("  - session %s (%s): %d entr%s, %d finding(s) from the helper, %d passed the bar\n"
                   % (s["session"], s["project"], s["entries"], "y" if s["entries"] == 1 else "ies", s["findings"],
                      s["passed"]))
    by_id = {f["id"]: f for f in unsettled.get("findings") or []}
    ch = [c for c in changes.get("changes") or [] if isinstance(c, dict)]
    out.append("- Changed: %d file(s) from %d finding(s)\n" % (len(P.target_files()), len(P.settled)))
    live_of = {w["rel"]: w for w in P.writes}
    from . import targets
    for c in ch:
        rel = targets.live_rel(str(c.get("file", "")))
        out.append("  - `%s` (%s): %s\n" % (rel, c.get("basis", ""), cut(c.get("summary"), 200)))
        for i in c.get("finding_ids") or []:
            f = by_id.get(i)
            if f:
                out.append("    > %s\n" % cut(f["quote"]))
                out.append("    (%s, %s, session %s)\n" % (f["kind"], f["date"], f["session"][:8]))
        if c.get("order_id"):
            out.append("    order: %s\n" % c["order_id"])
        for r in c.get("removals") or []:
            if isinstance(r, dict):
                out.append("    - removed (%s): \"%s\"%s\n" % (r.get("reason"), cut(r.get("text"), 200),
                                                             (" → " + r["moved_to"]) if r.get("moved_to") else ""))
    saved = changes.get("already_saved") or []
    out.append("- Already saved: %d (the lesson was already in the file; counted apart from what this run added)\n"
               % len(saved))
    for s in saved:
        out.append("  - `%s`: \"%s\"\n" % (targets.live_rel(str(s.get("file", ""))), cut(s.get("existing_text"), 150)))
    dec = changes.get("declined") or []
    if dec:
        out.append("- Declined by the editor: %d (on Justin's list)\n" % len(dec))
    out.append("- Justin's list: %d new item(s)\n" % len(list_items))
    for i in list_items:
        out.append("  - %s: \"%s\" (%s)\n" % (i.get("kind"), cut(i.get("quote"), 200), i.get("why", "")))
    dropped = list(R.facts.get("dropped") or []) + list(R.facts.get("pending_expired") or [])
    out.append("- Dropped: %s\n" % ("; ".join(dropped) if dropped else "none"))
    if R.facts.get("masked"):
        out.append("- Masked before any model saw them: %d secret-like string(s)\n" % R.facts["masked"])
    if P.orders_done:
        out.append("- Repeat-mistakes orders: %s\n" % ", ".join(o["id"] for o in P.orders_done))
    if unsettled.get("enforce_lines"):
        out.append("- Enforce proposals added to enforce-backlog.md: %d\n" % len(unsettled["enforce_lines"]))
    un = R.facts.get("unattributed") or []
    out.append("- Unattributed changes: %s\n" % ("; ".join("`%s` (%s)" % (u["path"], u["git"]) for u in un) if un else "none"))
    if R.facts.get("format_errors"):
        out.append("- Format errors (sessions not read): %s\n" % "; ".join(R.facts["format_errors"]))
    corr = []
    for p, n in sorted((lg.get("typed") or {}).items()):
        c = (lg.get("corrections") or {}).get(p, 0)
        corr.append("%s: %d corrections per 100 typed messages (%d of %d)" % (p, round(100.0 * c / n) if n else 0, c, n))
    out.append("- Corrections: %s\n" % ("; ".join(corr) if corr else "no typed messages read"))
    calls = R.calls
    roles = {}
    for c in calls:
        roles[c["role"]] = roles.get(c["role"], 0) + 1
    tin = sum(c["input_tokens"] or 0 for c in calls)
    tout = sum(c["output_tokens"] or 0 for c in calls)
    cost = sum(c["cost"] or 0 for c in calls)
    out.append("- Model calls: %d (%s), tokens %d in / %d out, $%.2f\n"
               % (len(calls), ", ".join("%s %d" % kv for kv in sorted(roles.items())) or "none", tin, tout, cost))
    marks = []
    for k, m in sorted((P.markers_after or {}).items()):
        marks.append("session %s read to line %d" % (k.split("/")[-1][:-6][:8] if k.endswith(".jsonl") else k,
                                                      m.get("extracted_line", 0)))
    out.append("- Markers: %s.\n" % ("; ".join(marks) if marks else "no session marker moves"))
    return "".join(out)


def append_stop(env, R, reason):
    """A run that stopped with nothing live notes its reason in the log (the next sync commits it)."""
    text = read(env)
    if not text.endswith("\n"):
        text += "\n"
    text += "\n## Dream %s (run %s, %s): stopped, nothing went live\n\n- Reason: %s\n- The markers did not move; " \
            "the findings wait for the next run.\n" % (R.now.strftime("%Y-%m-%d %H:%M"), R.id, R.mode, cut(reason, 600))
    paths.write_atomic(env.dream / "dream-log.md", text)
