"""Step 4 of a run, no model: the bar every helper finding must pass (DREAM.md sections 3, 4, 8, 9)."""
import re

QUOTE_MIN = 15


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
