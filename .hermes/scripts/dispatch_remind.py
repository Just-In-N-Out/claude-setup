#!/usr/bin/env python3
"""Re-ask Justin about features waiting on him (feature-dispatch board).

Run by a no-agent cron job every 2 minutes. For each board entry in phase
`awaiting-go` or `awaiting-answer` whose question was asked (`asked_at`) at least
2 minutes ago, print a reminder naming the feature, then record it in
reminders.json (never writes the board, which the main chat owns).
At most MAX_REMINDERS per question; prints nothing when nothing is due (= no message).
"""
import json
import os
from datetime import datetime, timezone

BOARD = os.path.expanduser("~/.hermes/plans/dispatch.json")
STATE = os.path.expanduser("~/.hermes/plans/reminders.json")
EVERY_MIN = 2
MAX_REMINDERS = 5
PROJ = {"figma-to-bricks": "Figma", "leorna": "Leorna"}


def load(path, default):
    try:
        with open(path, encoding="utf-8") as fh:
            return json.load(fh)
    except (OSError, ValueError):
        return default


def parse(iso):
    try:
        return datetime.fromisoformat(iso.replace("Z", "+00:00"))
    except (AttributeError, ValueError):
        return None


def main():
    board = load(BOARD, {})
    state = load(STATE, {})
    now = datetime.now(timezone.utc)
    out, waiting = [], []
    for name, f in board.items():
        if not isinstance(f, dict) or f.get("phase") not in {"awaiting-go", "awaiting-answer"}:
            continue
        asked = parse(f.get("asked_at", ""))
        if not asked:
            continue
        key = f"{name}|{f.get('asked_at')}"  # a new question resets the count
        s = state.get(key, {"count": 0, "last": f.get("asked_at")})
        last = parse(s.get("last", "")) or asked
        if s["count"] >= MAX_REMINDERS or (now - last).total_seconds() < EVERY_MIN * 60:
            continue
        mins = int((now - asked).total_seconds() // 60)
        proj = PROJ.get(f.get("project"), f.get("project", ""))
        ask = f.get("ask") or ("plan ready, reply go / 1B" if f["phase"] == "awaiting-go" else "needs your answer")
        reply = f.get("reply_hint") or "go / 1B / change: …"
        waiting.append(name)
        out.append((name, mins, reply))
        state[key] = {"count": s["count"] + 1, "last": now.strftime("%Y-%m-%dT%H:%M:%SZ")}
    live = {f"{n}|{f.get('asked_at')}" for n, f in board.items() if isinstance(f, dict)}
    state = {k: v for k, v in state.items() if k in live}  # forget answered questions
    with open(STATE, "w", encoding="utf-8") as fh:
        json.dump(state, fh)
    if out:  # **bold** because the WhatsApp adapter turns markdown **x** into WhatsApp *x*
        if len(out) == 1:
            n, m, r = out[0]
            print(f"🔔 **NEEDS YOU** · {n} ({m} min) · {r}")
        else:
            print(f"🔔 **NEEDS YOU** ({len(out)})\n" + "\n".join(f"• {n} · {m} min · {r}" for n, m, r in out))


if __name__ == "__main__":
    main()
