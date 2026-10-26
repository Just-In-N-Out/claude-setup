#!/usr/bin/env python3
"""One-step updates to the feature-dispatch board (~/.hermes/plans/dispatch.json).

  dispatch_board.py set <name> key=value [key=value ...]   create or update a feature
  dispatch_board.py rm <name>                              remove a feature
  dispatch_board.py show [name]                            print the board (or one feature)

Rules applied on `set` (so the main chat never hand-edits the JSON):
- new feature: stamps started/phase_since, defaults project to figma-to-bricks, plan to
  ~/.hermes/plans/<project>/<name>.md, branch to worktree-<name> (Figma) or feat/<name> (Leorna), note "".
- phase changes: stamps phase_since.
- phase awaiting-go / awaiting-answer: stamps asked_at when the phase changes or a new `ask` is given
  (the reminder job counts from asked_at). Leaving those phases drops asked_at, ask and reply_hint.
- `key=` (empty) deletes the field, except note, which is kept as "".
- every write prunes merged/ready/verified entries whose phase_since is over 3 days old.
Writes atomically. Stdlib only.
"""
import json
import os
import sys
import tempfile
from datetime import datetime, timedelta, timezone

BOARD = os.path.expanduser(os.environ.get("DISPATCH_BOARD", "~/.hermes/plans/dispatch.json"))
WAITING = {"awaiting-go", "awaiting-answer"}
DONE = {"merged", "ready", "verified"}
ASK_FIELDS = ("asked_at", "ask", "reply_hint")


def now_iso():
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%MZ")


def parse_iso(s):
    try:
        return datetime.fromisoformat(s.replace("Z", "+00:00"))
    except (AttributeError, ValueError):
        return None


def load():
    try:
        with open(BOARD, encoding="utf-8") as fh:
            data = json.load(fh)
        return data if isinstance(data, dict) else {}
    except FileNotFoundError:
        return {}


def save(board):
    cutoff = datetime.now(timezone.utc) - timedelta(days=3)
    for name in [n for n, f in board.items() if isinstance(f, dict) and f.get("phase") in DONE]:
        t = parse_iso(board[name].get("phase_since", ""))
        if t and t < cutoff:
            del board[name]
    os.makedirs(os.path.dirname(BOARD), exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=os.path.dirname(BOARD), prefix=".dispatch-", suffix=".json")
    with os.fdopen(fd, "w", encoding="utf-8") as fh:
        json.dump(board, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    os.replace(tmp, BOARD)


def cmd_set(name, pairs):
    board = load()
    stamp = now_iso()
    feat = board.get(name)
    if feat is None:
        feat = {"project": "figma-to-bricks", "started": stamp, "phase_since": stamp, "note": ""}
    old_phase = feat.get("phase")
    updates = {}
    for pair in pairs:
        if "=" not in pair:
            sys.exit(f"bad argument (want key=value): {pair}")
        k, v = pair.split("=", 1)
        updates[k.strip()] = v
    for k, v in updates.items():
        if v == "" and k != "note":
            feat.pop(k, None)
        else:
            feat[k] = v
    project = feat.get("project", "figma-to-bricks")
    feat.setdefault("plan", f"~/.hermes/plans/{project}/{name}.md")
    feat.setdefault("branch", f"feat/{name}" if project == "leorna" else f"worktree-{name}")
    new_phase = feat.get("phase")
    if new_phase != old_phase and "phase_since" not in updates:
        feat["phase_since"] = stamp
    if new_phase in WAITING:
        if (new_phase != old_phase or "ask" in updates) and "asked_at" not in updates:
            feat["asked_at"] = stamp
    else:
        for k in ASK_FIELDS:
            feat.pop(k, None)
    board[name] = feat
    save(board)
    print(json.dumps({name: feat}, ensure_ascii=False))


def main(argv):
    if os.environ.get("DISPATCH_BOARD"):
        print(f"(test board: {BOARD}; unset DISPATCH_BOARD for the real one)", file=sys.stderr)
    if len(argv) < 2 or argv[1] not in {"set", "rm", "show"}:
        sys.exit(__doc__)
    cmd = argv[1]
    if cmd == "show":
        board = load()
        if len(argv) > 2:
            board = {argv[2]: board.get(argv[2])}
        print(json.dumps(board, indent=2, ensure_ascii=False))
    elif cmd == "rm":
        if len(argv) < 3:
            sys.exit("usage: dispatch_board.py rm <name>")
        board = load()
        removed = board.pop(argv[2], None)
        save(board)
        print(f"removed {argv[2]}" if removed else f"no feature {argv[2]}")
    else:
        if len(argv) < 4:
            sys.exit("usage: dispatch_board.py set <name> key=value [...]")
        cmd_set(argv[2], argv[3:])


if __name__ == "__main__":
    main(sys.argv)
