"""The repeat-mistakes files (DREAM.md section 7; plan "Repeat-mistakes files").

The script owns which entries exist, their order and the text in the heading's brackets; the editor
owns the wording. state/tally.json: {kinds: {<id>: {title, description, area, projects: {<project>:
{stories, findings, last_story}}, listed_in, listed_since: {date, seq}, repeats_while_listed, retired,
parked}}, stories: {<project>: [...]}, story_seq: ["<project>/<story>", ...], seen: [line ids], backfill_done}.
"""
import re

from . import targets

RETIRE_AFTER = 10
FILE_TARGET = 15000     # DREAM.md section 7: about 15 KB per file (the budget is 16,000)
ENTRY_ALLOWANCE = 400   # bytes expected for an entry's Build and Check lines, on top of its heading
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
    by_id = {ln["id"]: ln for ln in given}
    for ln in given:  # every story counts, also one whose findings are all one-offs
        if ln["story"] not in stories.setdefault(ln["project"], []):
            stories[ln["project"]].append(ln["story"])
        if "%s/%s" % (ln["project"], ln["story"]) not in seq:
            seq.append("%s/%s" % (ln["project"], ln["story"]))
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


def retire_due(env, tally, kid):
    k = tally["kinds"][kid]
    f = k.get("listed_in")
    if not f:
        return False
    if f == targets.general_rm(env):
        seq = tally.get("story_seq") or []
        mine = [i for i, x in enumerate(seq) if x in set(all_stories(k, tally))]
        return bool(mine) and len(seq) - 1 - max(mine) >= RETIRE_AFTER
    owner = [p for p in (k.get("projects") or {}) if targets.rm_for_project(env, p) == f]
    for p in owner:
        lst = (tally.get("stories") or {}).get(p, [])
        mine = [lst.index(s) for s in k["projects"][p].get("stories") or [] if s in lst]
        if mine and len(lst) - 1 - max(mine) >= RETIRE_AFTER:
            return True
    return False


def _rewritten(env, rel, tally):
    """The file as the script's own rewrite will leave it (counts, stories, order from the tally): the room an
    order has is measured on that, so a rewrite that waited through review-only runs keeps its room (R2-2)."""
    try:
        return normalize_text((env.home / rel).read_text(), tally)
    except OSError:
        return ""


def orders(env, tally):
    """Remove, move and add orders for the editor. Entries that would take a file past about 15 KB are not
    ordered (R1-9): the most frequent kinds go first, and a kind left out is not parked, it waits for room."""
    cands = []
    for kid in sorted((tally.get("kinds") or {})):
        k = tally["kinds"][kid]
        if k.get("retired") or k.get("parked"):
            continue
        want = target_file(env, tally, kid)
        info = {"kind": kid, "title": k.get("title", ""), "description": k.get("description", ""),
                "area": k.get("area", "General"), "count": len(all_stories(k, tally)),
                "stories": [x.split("/", 1)[1] for x in all_stories(k, tally)]}
        if k.get("listed_in"):
            if retire_due(env, tally, kid):
                cands.append(dict(info, id="remove:" + kid, action="remove", file=k["listed_in"]))
            elif want and want != k["listed_in"]:
                cands.append(dict(info, id="move:" + kid, action="move", file=k["listed_in"], to=want))
        elif want:
            # the bytes its entry may take, heading included: what the room below is sized by, what the editor
            # is told (orders.json) and what check_copy holds the added entry to (R2-3)
            cands.append(dict(info, id="add:" + kid, action="add", file=want,
                              max_entry_bytes=len(heading_for(kid, info["title"], tally).encode()) + ENTRY_ALLOWANCE))
    size, texts = {}, {}

    def size_of(f):
        if f not in size:
            size[f] = len(_rewritten(env, f, tally).encode())
        return size[f]

    def entry_bytes(f, kind):
        if f not in texts:
            texts[f] = entries_of(_rewritten(env, f, tally))
        e = texts[f].get(kind)
        return len((e[1] + e[2]).encode()) if e else 0

    out = []
    for o in cands:
        if o["action"] == "remove":
            size[o["file"]] = size_of(o["file"]) - entry_bytes(o["file"], o["kind"])
            out.append(o)
    growing = sorted((o for o in cands if o["action"] != "remove"), key=lambda o: (-o["count"], o["kind"]))
    full = set()
    for o in growing:
        dest = o.get("to") or o["file"]
        size_of(dest)
        est = entry_bytes(o["file"], o["kind"]) if o["action"] == "move" else 0
        est = est or o["max_entry_bytes"]
        if dest in full or size[dest] + est > FILE_TARGET:
            full.add(dest)  # not owed, and nothing less frequent jumps ahead: they wait until the file has room
            continue
        size[dest] += est
        if o["action"] == "move":
            size[o["file"]] = size_of(o["file"]) - est
        out.append(o)
    return sorted(out, key=lambda o: o["kind"])


def merge_orders(old, new):
    tries = {o["id"]: o.get("tries", 0) for o in old or []}
    return [dict(o, tries=tries.get(o["id"], 0)) for o in new]


def order_list_item(o):
    return {"id": o["id"], "date": "", "kind": "could not apply", "quote": "",
            "statement": "repeat-mistakes order: %s %s in %s" % (o["action"], o["kind"], o.get("to") or o["file"]),
            "session": "", "why": "could not apply automatically after two tries"}


def after_commit(tally, done, now):
    """The tally once the orders are live."""
    for o in done:
        k = tally["kinds"].get(o["kind"])
        if not k:
            continue
        if o["action"] == "remove":
            k["listed_in"], k["retired"] = None, True
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
