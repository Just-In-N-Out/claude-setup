"""The repeat-mistakes files (DREAM.md section 7; plan "Repeat-mistakes files").

The script owns which entries exist, their order and the text in the heading's brackets; the editor
owns the wording. state/tally.json: {kinds: {<id>: {title, description, area, projects: {<project>:
{stories, findings, last_story, last_seen}}, listed_in, listed_since: {date, seq}, repeats_while_listed, retired,
parked}}, stories: {<project>: [...]}, story_seq: ["<project>/<story>", ...], story_time: {"<project>/<story>":
its first evidence file's date}, seen: [line ids], backfill_done}. Both story lists are in order of date (R5-1);
last_seen is the date of the newest review file that found the kind in that project.
"""
import re

from . import paths, targets

RETIRE_AFTER = 10
FILE_TARGET = 15000     # DREAM.md section 7: about 15 KB per file (the budget is 16,000)
ENTRY_ALLOWANCE = 400   # bytes expected for an entry's Build and Check lines, on top of its heading
SLACK = 2               # blank lines an editor may add or take around one ordered entry or area heading
HEAD = re.compile(r"^### (?P<kind>[a-z0-9][a-z0-9-]*) — (?P<mistake>.*?)(?: \((?P<n>\d+)×: (?P<stories>[^)]*)\))?\s*$")
AREA = re.compile(r"^## (.+?)\s*$")
BUILD = "- **Build it this way:**"
CHECK = "- **Check for it:**"


def slug(s):
    s = re.sub(r"[^a-z0-9]+", "-", str(s or "").lower()).strip("-")
    return s[:60]


# ---------- the tally ----------

def record(env, tally, given, assigns, now):
    """Count the review helper's assignments; returns enforce-backlog lines for kinds seen again in a story
    that began after they were listed."""
    kinds = tally.setdefault("kinds", {})
    stories = tally.setdefault("stories", {})
    seq = tally.setdefault("story_seq", [])
    times = tally.setdefault("story_time", {})
    by_id = {ln["id"]: ln for ln in given}
    new = []
    for ln in given:  # every story counts, also one whose findings are all one-offs
        key = "%s/%s" % (ln["project"], ln["story"])
        if key not in seq and key not in new:
            new.append(key)
            if ln.get("story_time") is not None:
                times[key] = ln["story_time"]
    # the stories new in this run take their places by date, not in the order the evidence walk found them
    # (projects, then story folders, by name): at the first run every story is new at once, and a story counted
    # only in a later run goes among the stories counted before it (R5-1)
    for key in new:
        p, s = key.split("/", 1)
        i = _place(seq, times, key)
        seq.insert(i, key)
        for k in kinds.values():   # the stories counted before a listing stay before its boundary
            if (k.get("listed_since") or {}).get("seq", 0) > i:
                k["listed_since"]["seq"] += 1
        lst = stories.setdefault(p, [])
        if s not in lst:
            lst.insert(_place(["%s/%s" % (p, x) for x in lst], times, key), s)
    out = []
    for a in assigns:
        ln = by_id.get(a.get("line_id"))
        kind = str(a.get("kind") or "none")
        if not ln or kind == "none":
            continue
        if kind == "new":
            nk = a.get("new_kind") or {}
            kid = slug(nk.get("id"))
            if not kid:
                continue
            if kid not in kinds:
                kinds[kid] = {"title": str(nk.get("title") or kid), "description": str(nk.get("description") or ""),
                              "area": str(nk.get("area") or "General"), "projects": {}, "listed_in": None,
                              "listed_since": None, "repeats_while_listed": [], "retired": False}
        else:
            kid = kind
            if kid not in kinds:
                continue
        k = kinds[kid]
        p, s = ln["project"], ln["story"]
        pk = k.setdefault("projects", {}).setdefault(p, {"stories": [], "findings": 0, "last_story": None})
        new_story = s not in pk["stories"]
        if new_story:
            pk["stories"].append(s)
        pk["findings"] = pk.get("findings", 0) + 1
        pk["last_story"] = s
        if ln.get("time") is not None and ln["time"] > (pk.get("last_seen") or float("-inf")):
            pk["last_seen"] = ln["time"]    # a later review round of an older story is a sighting at its own date
        since = k.get("listed_since") or {}
        ps = "%s/%s" % (p, s)
        if k.get("listed_in") and not k.get("retired") and new_story and seq.index(ps) >= since.get("seq", 0) \
                and ps not in (k.get("repeats_while_listed") or []):
            k.setdefault("repeats_while_listed", []).append(ps)
            proposal = str(a.get("enforce_proposal") or "").strip() or (
                "a check that catches \"%s\" (it came back in %s while listed)" % (k["title"], s))
            out.append("- %s | dream | %s | %s | offered" % (now.date().isoformat(),
                                                             targets.skill_of_rm(k["listed_in"]), proposal.replace("|", "/")))
    tally.setdefault("seen", [])
    tally["seen"] += [ln["id"] for ln in given if ln["id"] not in set(tally["seen"])]
    return out


def migrate(env, tally):
    """A tally written before stories had dates (no story_time; R5-1) holds them in the order the evidence walk
    found them, folder names at the first run. It is migrated, not rebuilt (a rebuild would pay the review helpers
    again): each story gets its first evidence file's date (one whose evidence is gone counts as the oldest), the
    lists go in order of date, and each listing's boundary (listed_since.seq) moves to just after the last story
    counted before it, so a story counted then still began before the listing."""
    if "story_time" in tally or not tally.get("story_seq"):
        return      # dated already, or nothing counted yet: record() dates each story as it comes
    from . import extract
    found = extract.story_times(env)
    old = list(tally.get("story_seq") or [])
    times = tally["story_time"] = {x: found.get(x, 0.0) for x in old}
    new = tally["story_seq"] = sorted(old, key=lambda x: times[x])
    for p, lst in (tally.get("stories") or {}).items():
        lst.sort(key=lambda s: times.get("%s/%s" % (p, s), 0.0))
    if new == old:
        return
    for k in (tally.get("kinds") or {}).values():
        since = k.get("listed_since") or {}
        if since.get("seq"):
            since["seq"] = 1 + max(new.index(x) for x in old[:since["seq"]])


def _place(keys, times, key):
    """Where key goes in keys (in order of date): before the first story that began after it. A story with no
    date (a tally written by hand) counts as older than every dated one."""
    t = times.get(key)
    if t is None:
        return len(keys)
    return next((i for i, x in enumerate(keys) if times.get(x, float("-inf")) > t), len(keys))


def all_stories(k, tally):
    seq = tally.get("story_seq") or []
    pairs = ["%s/%s" % (p, s) for p, v in sorted((k.get("projects") or {}).items()) for s in v.get("stories") or []]
    pairs.sort(key=lambda x: seq.index(x) if x in seq else len(seq))
    return pairs


def target_file(env, tally, kid):
    k = tally["kinds"][kid]
    ps = [p for p, v in (k.get("projects") or {}).items() if v.get("stories")]
    if len(ps) >= 2:
        return targets.general_rm(env)
    if len(ps) == 1 and len(k["projects"][ps[0]]["stories"]) >= 2:
        return targets.rm_for_project(env, ps[0])
    return None


def retire_due(env, tally, kid, f=None):
    """True when kind kid has not come back in RETIRE_AFTER later stories of file f: of its project for a
    project's file, of any project for the general file. f is the file it is listed in, unless given: the file
    it would be added or moved to, where a kind already due is not listed (Justin 2026-11-10, option (b))."""
    k = tally["kinds"][kid]
    f = f or k.get("listed_in")
    if not f:
        return False
    if f == targets.general_rm(env):
        seq = tally.get("story_seq") or []
        last = _last(tally, k, seq, list(k.get("projects") or {}))
        return last is not None and len(seq) - 1 - last >= RETIRE_AFTER
    owner = [p for p in (k.get("projects") or {}) if targets.rm_for_project(env, p) == f]
    for p in owner:
        lst = ["%s/%s" % (p, s) for s in (tally.get("stories") or {}).get(p, [])]
        last = _last(tally, k, lst, [p])
        if last is not None and len(lst) - 1 - last >= RETIRE_AFTER:
            return True
    return False


def _last(tally, k, keys, projects):
    """The place in keys (stories "<project>/<story>" in order of date) where kind k was last seen in projects:
    its newest story there, or, when a later review round of an older story found it again (last_seen, that
    round's file date), the newest story that had begun by then (R5-1). None when it was seen in none of keys."""
    pv = k.get("projects") or {}
    own = {"%s/%s" % (p, s) for p in projects for s in (pv.get(p) or {}).get("stories") or []}
    mine = [i for i, x in enumerate(keys) if x in own]
    if not mine:
        return None
    seen = [pv[p]["last_seen"] for p in projects if (pv.get(p) or {}).get("last_seen") is not None]
    times = tally.get("story_time") or {}
    if seen:
        mine += [i for i, x in enumerate(keys) if x in times and times[x] <= max(seen)]
    return max(mine)


def change_cap(env):
    """The bytes a repeat-mistakes file that has entries may change in one run (conf/caps.conf; DREAM.md
    section 6), counted by guards.g_caps on the editor's change."""
    v = paths.read_kv(env.conf / "caps.conf").get("repeat_mistakes_change", "4000")
    return int(v) if v.lstrip("-").isdigit() else 4000


def has_entries(text):
    """A repeat-mistakes file is held to the change cap once it has an entry; before, it may fill to its budget."""
    return "\n### " in "\n" + text


def unread(env, tally):
    """The review lines on disk the tally has not counted (R6-1): those past the 150 a run reads, those of a review
    helper that failed (in the backfill, one project's), those written since the run's evidence walk."""
    from . import extract
    return extract.review_lines(env, tally.get("seen") or [])


def _rewritten(env, rel, tally):
    """The file as the script's own rewrite will leave it (counts, stories, order from the tally): the room an
    order has is measured on that, so a rewrite that waited through review-only runs keeps its room (R2-2)."""
    try:
        return normalize_text((env.home / rel).read_text(), tally)
    except OSError:
        return ""


def orders(env, tally):
    """Remove, move and add orders for the editor. Entries that would take a file past about 15 KB are not
    ordered (R1-9): the most frequent kinds go first, and a kind left out is not parked, it waits for room.
    Every order carries the same fields (id, action, kind, title, description, area, count, stories, file,
    to, max_entry_bytes), so no reader of an order meets a missing one (R3-2); `to` is text in each (a move's
    file, else empty).
    No order at all while review lines on disk wait uncounted (R6-1): any of them may be a listed mistake's newest
    sighting, or stories that make a kind due before it is ever listed (R6-2), and a removal retires a kind for
    good. The orders wait until a run has counted every line."""
    if unread(env, tally):
        return []
    size, texts = {}, {}

    def entries(f):
        if f not in texts:
            texts[f] = entries_of(_rewritten(env, f, tally))
        return texts[f]

    def order(info, action, file, to=""):
        # an add order carries the bytes its entry may take, heading included: what the room below is sized
        # by, what the editor is told (orders.json) and what check_copy holds the added entry to (R2-3)
        most = len(heading_for(info["kind"], info["title"], tally).encode()) + ENTRY_ALLOWANCE if action == "add" else None
        return dict(info, id="%s:%s" % (action, info["kind"]), action=action, file=file, to=to, max_entry_bytes=most)

    cands = []
    for kid in sorted((tally.get("kinds") or {})):
        k = tally["kinds"][kid]
        if k.get("retired") or k.get("parked"):
            continue
        want = target_file(env, tally, kid)
        info = {"kind": kid, "title": k.get("title", ""), "description": k.get("description", ""),
                "area": k.get("area", "General"), "count": len(all_stories(k, tally)),
                "stories": [x.split("/", 1)[1] for x in all_stories(k, tally)]}
        # a kind already due to retire where it would be listed is not added or moved there: it would be removed
        # the next run and then retired for good; it is listed once it comes back in a newer story (option (b))
        if want and retire_due(env, tally, kid, want):
            want = None
        if k.get("listed_in"):
            if retire_due(env, tally, kid):
                cands.append(order(info, "remove", k["listed_in"]))
            elif want and want != k["listed_in"]:
                if kid in entries(k["listed_in"]):
                    cands.append(order(info, "move", k["listed_in"], want))
                else:
                    # its entry is not in the file the tally lists it in (deleted by hand): there is nothing to
                    # move, so the editor writes it where it now belongs, as for any add (R3-2)
                    cands.append(order(info, "add", want))
        elif want:
            cands.append(order(info, "add", want))

    def size_of(f):
        if f not in size:
            size[f] = len(_rewritten(env, f, tally).encode())
        return size[f]

    def entry_bytes(f, kind):
        e = entries(f).get(kind)
        return len((e[1] + e[2]).encode()) if e else 0

    # One run's orders are bounded by the change cap as well as by the room (R3-1): a file that has entries
    # changes at most change_cap bytes a run (DREAM.md section 6), and an editor that does exactly what the
    # orders say must stay inside it. Each order is charged what guards.g_caps counts for it at its largest:
    # an entry taken out whole (a move's two lines arrive word for word elsewhere, so only its heading),
    # an added entry at its max_entry_bytes (a move's heading), a little for blank lines, and an area's
    # heading when the order opens or empties that area. What does not fit waits for a later run, unparked.
    cap, charge, capped, areas, left, opened = change_cap(env), {}, {}, {}, {}, set()

    def fits(f, n):
        if f not in capped:
            try:
                capped[f] = has_entries((env.home / f).read_text())
            except OSError:
                capped[f] = False
        return not capped[f] or charge.get(f, 0) + n <= cap

    def area_cost(f, area):
        if f not in areas:
            areas[f] = {AREA.match(a.rstrip("\n")).group(1): pre for a, pre, _ in parse(_rewritten(env, f, tally))[1]}
        return len(("## %s" % area).encode()) + 1 + len(areas[f].get(area, "").encode()) + SLACK

    def out_cost(f, kind, whole):
        e = entries(f).get(kind)
        if not e:
            return 0, None
        key = (f, e[0])
        left.setdefault(key, sum(1 for a, _, _ in entries(f).values() if a == e[0]))
        n = len((e[1] + e[2] if whole else e[1]).encode()) + SLACK
        return n + (area_cost(f, e[0]) if left[key] == 1 else 0), key   # its area left empty: the heading may go

    def in_cost(f, names, n):
        if f not in areas:
            area_cost(f, "")
        new = [a for a in names if a not in areas[f] and (f, a) not in opened]
        return n + SLACK + (max(area_cost(f, a) for a in new) if new else 0), new

    out = []
    for o in cands:
        if o["action"] == "remove":
            n, key = out_cost(o["file"], o["kind"], True)
            if not fits(o["file"], n):
                continue    # not owed this run: it retires in a later one
            charge[o["file"]] = charge.get(o["file"], 0) + n
            if key:
                left[key] -= 1
            size[o["file"]] = size_of(o["file"]) - entry_bytes(o["file"], o["kind"])
            out.append(o)
    seq = tally.get("story_seq") or []

    def recency(o):     # where the kind was last seen among all stories, in order of date (R5-1)
        k = tally["kinds"][o["kind"]]
        last = _last(tally, k, seq, list(k.get("projects") or {}))
        return -1 if last is None else last

    # most frequent first; of equally frequent kinds, the one seen most recently (the other is nearer to retiring)
    growing = sorted((o for o in cands if o["action"] != "remove"), key=lambda o: (-o["count"], -recency(o), o["kind"]))
    full = set()
    for o in growing:
        dest = o.get("to") or o["file"]
        size_of(dest)
        if o["action"] == "move":
            est = entry_bytes(o["file"], o["kind"])
            n_out, key = out_cost(o["file"], o["kind"], False)
            e = entries(o["file"])[o["kind"]]
            n_in, new = in_cost(dest, {e[0], o["area"]}, len(e[1].encode()))
        else:
            est, n_out, key = o["max_entry_bytes"], 0, None
            n_in, new = in_cost(dest, {o["area"]}, est)
        if dest in full or size[dest] + est > FILE_TARGET or not fits(dest, n_in) or not fits(o["file"], n_out):
            full.add(dest)  # not owed, and nothing less frequent jumps ahead: they wait until the file has room
            continue
        size[dest] += est
        charge[dest] = charge.get(dest, 0) + n_in
        opened.update((dest, a) for a in new)
        if o["action"] == "move":
            size[o["file"]] = size_of(o["file"]) - est
            charge[o["file"]] = charge.get(o["file"], 0) + n_out
            if key:
                left[key] -= 1
        out.append(o)
    return sorted(out, key=lambda o: o["kind"])


def merge_orders(old, new):
    tries = {o["id"]: o.get("tries", 0) for o in old or []}
    return [dict(o, tries=tries.get(o["id"], 0)) for o in new]


def order_list_item(o):
    return {"id": o["id"], "date": "", "kind": "could not apply", "quote": "",
            "statement": "repeat-mistakes order: %s %s in %s" % (o["action"], o["kind"], o.get("to") or o["file"]),
            "session": "", "why": "could not apply automatically after two tries"}


def after_commit(tally, done, now, settled=True):
    """The tally once the orders are live. A removed kind is retired for good only when settled: no review line
    on disk waited uncounted as the run settled its tally (one written while the editor worked, after the orders
    were made; R6-1). Otherwise it is only taken out, and a later run lists it again if those lines show it
    came back, or not while it is due (option (b))."""
    for o in done:
        k = tally["kinds"].get(o["kind"])
        if not k:
            continue
        if o["action"] == "remove":
            k["listed_in"], k["retired"] = None, bool(settled)
        else:
            k["listed_in"] = o.get("to") or o["file"]
            k["listed_since"] = {"date": now.date().isoformat(), "seq": len(tally.get("story_seq") or [])}


# ---------- the files ----------

def parse(text):
    """(header, [(area line, prelude, [(kind, heading, body)])]); joining every part gives the text back."""
    lines = text.splitlines(True)
    header, areas = [], []
    cur_area, cur = None, None
    for ln in lines:
        bare = ln.rstrip("\n")
        h = HEAD.match(bare)
        if not ln.startswith("###") and AREA.match(bare):
            cur_area = [ln, "", []]
            areas.append(cur_area)
            cur = None
        elif h and cur_area is not None:
            cur = [h.group("kind"), ln, ""]
            cur_area[2].append(cur)
        elif cur is not None:
            cur[2] += ln
        elif cur_area is not None:
            cur_area[1] += ln
        else:
            header.append(ln)
    return "".join(header), [(a, pre, [tuple(e) for e in es]) for a, pre, es in areas]


def entries_of(text):
    _, areas = parse(text)
    return {kind: (AREA.match(area.rstrip("\n")).group(1), head, body) for area, _, es in areas
            for kind, head, body in es}


def heading_for(kind, mistake, tally):
    k = (tally.get("kinds") or {}).get(kind)
    if not k:
        return None
    st = all_stories(k, tally) if tally.get("story_seq") else \
        ["%s/%s" % (p, s) for p, v in sorted(k.get("projects", {}).items()) for s in v.get("stories") or []]
    return "### %s — %s (%d×: %s)\n" % (kind, mistake, len(st), ", ".join(x.split("/", 1)[1] for x in st))


def normalize_text(text, tally):
    """Headings' brackets from the tally, entries most frequent first within each area; nothing else moves."""
    header, areas = parse(text)
    out = [header]
    for area, pre, es in areas:
        rows = []
        for kind, head, body in es:
            m = HEAD.match(head.rstrip("\n"))
            new = heading_for(kind, m.group("mistake"), tally) if m else None
            n = int(re.search(r"\((\d+)×", new).group(1)) if new else 0
            if body and not body.endswith("\n"):
                body += "\n"
            rows.append((n, new or head, body))
        rows.sort(key=lambda r: -r[0])
        out.append(area + pre)
        out += [head + body for _, head, body in rows]
    return "".join(out)


def rm_copies(env, mapping):
    return {c: v["live"] for c, v in mapping.items() if v["live"].endswith("/references/repeat-mistakes.md")}


def normalize_copy(env, run_dir, mapping, tally, orders_):
    for c in rm_copies(env, mapping):
        f = run_dir / "copy" / c
        if f.exists():
            t = f.read_text()
            n = normalize_text(t, tally)
            if n != t:
                f.write_text(n)


def _mistake(head):
    m = HEAD.match(head.rstrip("\n"))
    return m.group("mistake") if m else None


def _shape_problems(live, old, new, areas_ok):
    """Text outside the entries (R1-8): every builder, reviewer and fixer reads these files, and the line
    accounting does not look at them, so the header and the text under an area stay as they were, and a new
    area is one an order names, with nothing under it but its entries."""
    out = []
    h_old, a_old = parse(old)
    h_new, a_new = parse(new)
    if h_new.strip() != h_old.strip():
        out.append("%s: the header changed; only the script writes it" % live)
    pre_old = {AREA.match(a.rstrip("\n")).group(1): pre for a, pre, _ in a_old}
    for area, pre, _ in a_new:
        name = AREA.match(area.rstrip("\n")).group(1)
        if name in pre_old:
            if pre.strip() != pre_old[name].strip():
                out.append("%s: text under area %s changed outside any entry" % (live, name))
        elif name not in areas_ok:
            out.append("%s: a new area %s that no order names" % (live, name))
        elif pre.strip():
            out.append("%s: text under the new area %s outside any entry" % (live, name))
    return out


def check_copy(G):
    """Each repeat-mistakes file after the edit: exactly the entries the tally and the orders say, in the
    entry format, wording unchanged except for an order, most frequent first within each area, and no text
    outside the entries changed."""
    out = []
    rms = {v["live"]: c for c, v in G.mapping.items() if v["live"].endswith("/references/repeat-mistakes.md")}
    diffs = {G.live(d): d for d in G.diffs}
    for o in G.orders.values():
        for f in (o.get("file"), o.get("to")):
            if f and f not in rms:
                out.append("order %s names %s, which is not in the copy" % (o["id"], f))
    for live, c in rms.items():
        d = diffs.get(live)
        old = d.old if d else (G.copy_text(c) or "")
        new = d.new if d else old
        if d and d.status == "D":
            out.append("%s: a repeat-mistakes file was deleted" % live)
            continue
        before, after = entries_of(old), entries_of(new)
        areas_ok = set()
        for o in G.orders.values():
            if (o["action"] == "add" and o["file"] == live) or (o["action"] == "move" and o.get("to") == live):
                areas_ok.add(o.get("area") or "General")
                src = diffs[o["file"]].old if o["file"] in diffs else (G.copy_text(rms.get(o["file"], "")) or "")
                if o["kind"] in entries_of(src):
                    areas_ok.add(entries_of(src)[o["kind"]][0])
        out += _shape_problems(live, old, new, areas_ok)
        want = {k for k in before}
        for o in G.orders.values():
            if o["action"] in ("remove", "move") and o["file"] == live:
                want.discard(o["kind"])
            if o["action"] == "add" and o["file"] == live:
                want.add(o["kind"])
            if o["action"] == "move" and o.get("to") == live:
                want.add(o["kind"])
        if set(after) != want:
            missing, extra = sorted(want - set(after)), sorted(set(after) - want)
            out.append("%s: entries %s%s; the orders say otherwise" % (
                live, ("missing " + ", ".join(missing)) if missing else "", (" unexpected " + ", ".join(extra)) if extra else ""))
        for kind, (area, head, body) in after.items():
            lines = [ln for ln in body.splitlines() if ln.strip()]
            if len(lines) != 2 or not lines[0].startswith(BUILD) or not lines[1].startswith(CHECK):
                out.append("%s: entry %s must be its heading, one \"Build it this way\" line and one \"Check for it\" "
                           "line" % (live, kind))
            # an added entry, heading included, holds to the bytes its order was sized by and the editor was told
            # (max_entry_bytes in orders.json), so an editor that keeps to them stays inside the budget (R2-3)
            size = len(head.encode()) + sum(len(ln.encode()) + 1 for ln in lines)
            for o in G.orders.values():
                if kind not in before and o["action"] == "add" and o["kind"] == kind:
                    if size > o["max_entry_bytes"]:
                        out.append("%s: entry %s is %d bytes, heading included; its order holds it to at most %d "
                                   "(max_entry_bytes in orders.json)" % (live, kind, size, o["max_entry_bytes"]))
            m = HEAD.match(head.rstrip("\n"))
            if not m or m.group("n") is None or head != heading_for(kind, m.group("mistake"), G.tally):
                out.append("%s: entry %s has a heading the tally does not give" % (live, kind))
            if kind in before and (before[kind][2].rstrip() != body.rstrip() or
                                   _mistake(before[kind][1]) != _mistake(head)):
                out.append("%s: the wording of entry %s changed with no order" % (live, kind))
            mv = [o for o in G.orders.values() if o["action"] == "move" and o["kind"] == kind and o.get("to") == live]
            for o in mv:
                src = entries_of(diffs[o["file"]].old if o["file"] in diffs else (G.copy_text(rms.get(o["file"], "")) or ""))
                if kind in src and (src[kind][2].rstrip() != body.rstrip() or _mistake(src[kind][1]) != _mistake(head)):
                    out.append("%s: entry %s was not moved word for word" % (live, kind))
        _, areas = parse(new)
        for area, _pre, es in areas:
            counts = [int(HEAD.match(h.rstrip("\n")).group("n") or 0) for _, h, _ in es if HEAD.match(h.rstrip("\n"))]
            if counts != sorted(counts, reverse=True):
                out.append("%s: area %s is not ordered most frequent first" % (live, area))
    return out
