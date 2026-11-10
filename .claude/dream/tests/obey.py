"""A fake editor that does exactly what the repeat-mistakes orders say, at the largest size they allow
(review 3's R3-1 and R3-2: the script's own orders must pass every guard).

obey(copy_dir, orders) works on the copy the way a careful editor would, with its own small parser (not
dreamlib's): an add order gets an entry of exactly its max_entry_bytes (heading as the order gives it, a
Build line and a Check line) under its area, a new area opened with a blank line before it, and a blank
line after the entry; a remove order deletes its entry whole, and an area left empty loses its heading and
the blank line before it; a move order cuts the entry the same way and pastes it word for word under its
area in the other file. It returns the changes.json items for what it did.
Used by the tests directly and by fake-claude ("editor": {"obey_orders": true}).
"""
import os
import re

HEAD = re.compile(r"^### ([a-z0-9][a-z0-9-]*) — ")
AREA = re.compile(r"^## (?!#)(.+?)\s*$")
BUILD = "- **Build it this way:** "
CHECK = "- **Check for it:** a test of %s through every path this entry names; each must be refused."
PAD = "do it the way the entry says, on every path that reaches the write, with one test per path"


def _read(p):
    return open(p).read() if os.path.exists(p) else ""


def _write(p, text):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, "w") as f:
        f.write(text)


def _area_of(lines, i):
    for j in range(i, -1, -1):
        m = AREA.match(lines[j].rstrip("\n"))
        if m:
            return j, m.group(1)
    return None, None


def cut(text, kind):
    """(text without the entry, the entry's lines, its area) or (text, None, None) when it is not there."""
    lines = text.splitlines(True)
    start = next((i for i, ln in enumerate(lines) if HEAD.match(ln) and HEAD.match(ln).group(1) == kind), None)
    if start is None:
        return text, None, None
    end = start + 1
    while end < len(lines) and not lines[end].startswith("#"):
        end += 1
    entry = [ln for ln in lines[start:end] if ln.strip()]
    a, area = _area_of(lines, start)
    lines = lines[:start] + lines[end:]
    if a is not None:
        nxt = a + 1
        while nxt < len(lines) and not AREA.match(lines[nxt].rstrip("\n")):
            nxt += 1
        if not any(HEAD.match(ln) for ln in lines[a + 1:nxt]):
            lo = a - 1 if a > 0 and not lines[a - 1].strip() else a
            lines = lines[:lo] + lines[nxt:]
    return "".join(lines), entry, area


def paste(text, area, entry, blank_after=True):
    """The entry's lines at the end of its area, the area opened at the end of the file when it is new."""
    block = list(entry) + (["\n"] if blank_after else [])
    lines = text.splitlines(True)
    if lines and not lines[-1].endswith("\n"):
        lines[-1] += "\n"
    a = next((i for i, ln in enumerate(lines) if AREA.match(ln.rstrip("\n")) and AREA.match(ln.rstrip("\n")).group(1) == area),
             None)
    if a is None:
        return "".join(lines) + "\n## %s\n" % area + "".join(block)
    end = a + 1
    while end < len(lines) and not AREA.match(lines[end].rstrip("\n")):
        end += 1
    return "".join(lines[:end] + block + lines[end:])


def largest_entry(o):
    """An entry of exactly the order's max_entry_bytes, heading included (the count and stories as given)."""
    head = "### %s — %s (%d×: %s)\n" % (o["kind"], o["title"], o["count"], ", ".join(o["stories"]))
    check = CHECK % o["kind"]      # every entry's lines its own, so no line of one reads as moved from another
    room = o["max_entry_bytes"] - len(head.encode()) - len(check.encode()) - 2   # two newlines
    body = (BUILD + "for %s, " % o["kind"] + (PAD + ", ") * 40)[:room - 1] + "."
    assert len(body.encode()) == room, (room, len(body.encode()))
    return [head, body + "\n", check + "\n"]


def obey(copy_dir, orders, blank_after=True):
    changes = []
    for o in sorted(orders, key=lambda o: (o["action"] != "remove", o["id"])):
        src = os.path.join(copy_dir, o["file"])
        if o["action"] == "remove":
            text, entry, _ = cut(_read(src), o["kind"])
            if entry is not None:
                _write(src, text)
            files = [o["file"]]
        elif o["action"] == "move":
            text, entry, area = cut(_read(src), o["kind"])
            dst = os.path.join(copy_dir, o["to"])
            if entry is not None:
                _write(src, text)
                _write(dst, paste(_read(dst), area, entry, blank_after))
            files = [o["file"], o["to"]]
        else:
            old = _read(src)
            if not any(HEAD.match(ln) and HEAD.match(ln).group(1) == o["kind"] for ln in old.splitlines()):
                _write(src, paste(old, o.get("area") or "General", largest_entry(o), blank_after))
            files = [o["file"]]
        for f in files:
            changes.append({"file": f, "basis": "order", "finding_ids": [], "order_id": o["id"],
                            "summary": "%s %s" % (o["action"], o["kind"]), "additions": [], "removals": []})
    return changes
