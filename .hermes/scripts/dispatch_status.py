#!/usr/bin/env python3
"""Status line for every feature on the feature-dispatch board.

Run by a no-agent cron job every 5 minutes: prints the status message, or nothing
(so nothing is sent) when no feature is actively planning/building/reviewing/finishing.
`--all` prints every feature regardless (used by the main chat for "what are we working on").
Stdlib only; read-only (git rev-list / log).
"""
import json
import os
import subprocess
import sys
from datetime import datetime, timezone

BOARD = os.path.expanduser("~/.hermes/plans/dispatch.json")
FIGMA_REPO = os.path.expanduser("~/Documents/FigmaToBricksV2")
LEORNA_REPOS = [os.path.expanduser("~/Leorna/leorna-client"),
                os.path.expanduser("~/Leorna/leorna-control-plane")]

ACTIVE = {"planning", "building", "reviewing", "finishing", "verifying", "checking"}
ICON = {"planning": "🛠 **planning**", "awaiting-go": "📋 **waiting for your go**",
        "awaiting-answer": "❓ **waiting for your answer**",
        "building": "🔨 **building**", "reviewing": "🔍 **reviewing**", "finishing": "🧩 **finishing**",
        "verifying": "🧪 **verifying fixes**",
        "checking": "🔎 **checking the live page**",
        "merged": "✅ **merged**", "ready": "✅ **ready for PR**", "verified": "✅ **verified live**",
        "queued": "⏳ **approved, queued**", "stopped": "⏸ **stopped**"}


def git(repo, *args):
    try:
        out = subprocess.run(["git", "-C", repo, *args], capture_output=True, text=True, timeout=15)
        return out.stdout.strip() if out.returncode == 0 else ""
    except Exception:
        return ""


def commits(feature):
    """(count, last subject) of the feature's branch ahead of main, or (None, '')."""
    name, project = feature["name"], feature.get("project", "")
    candidates = []
    if project == "figma-to-bricks":
        candidates = [(FIGMA_REPO, feature.get("branch") or f"worktree-{name}")]
    elif project == "leorna":
        candidates = [(r, feature.get("branch") or f"feat/{name}") for r in LEORNA_REPOS]
    for repo, branch in candidates:
        if not git(repo, "rev-parse", "--verify", "--quiet", branch):
            continue
        count = git(repo, "rev-list", "--count", f"main..{branch}")
        last = git(repo, "log", "-1", "--format=%s", branch)
        return (int(count) if count.isdigit() else None), last
    return None, ""


def minutes_since(iso):
    if not iso:
        return None
    try:
        t = datetime.fromisoformat(iso.replace("Z", "+00:00"))
        return int((datetime.now(timezone.utc) - t).total_seconds() // 60)
    except ValueError:
        return None


def fmt_age(m):
    if m is None:
        return ""
    return f"{m} min" if m < 60 else f"{m // 60}h {m % 60:02d}m"


def main():
    show_all = "--all" in sys.argv
    try:
        with open(BOARD, encoding="utf-8") as fh:
            board = json.load(fh)
    except (OSError, ValueError):
        return
    features = [dict(v, name=k) for k, v in board.items() if isinstance(v, dict)]
    open_phases = ACTIVE | {"awaiting-go", "awaiting-answer", "queued", "stopped"}
    if not show_all:  # periodic ping: every open feature; silent when none is open
        features = [f for f in features if f.get("phase") in open_phases]
        if not features:
            return
    order = ["building", "reviewing", "finishing", "verifying", "checking", "planning", "awaiting-answer", "awaiting-go",
             "queued", "stopped", "ready", "merged", "verified"]
    features.sort(key=lambda f: (order.index(f.get("phase")) if f.get("phase") in order else 99, f["name"]))
    lines = [f"⏱ Status {datetime.now().strftime('%H:%M')}"]
    for f in features:
        phase = f.get("phase", "?")
        bits = [ICON.get(phase, phase)]
        age = fmt_age(minutes_since(f.get("phase_since") or f.get("started")))
        if age and phase not in {"merged", "ready", "verified"}:
            bits.append(age)
        if phase in {"building", "reviewing", "finishing", "verifying", "stopped"}:
            n, last = commits(f)
            if n is not None:
                bits.append(f"{n} commit{'s' if n != 1 else ''}" + (f' (last: "{last[:50]}")' if last and n else ""))
        if f.get("model") and phase not in {"merged", "ready", "verified"}:
            bits.append(f"🤖 {f['model']}")
        if f.get("note"):
            bits.append(f["note"])
        proj = {"figma-to-bricks": "Figma", "leorna": "Leorna"}.get(f.get("project"), f.get("project", ""))
        lines.append(f"• {f['name']} [{proj}] — " + ", ".join(bits))
    print("\n".join(lines))


if __name__ == "__main__":
    main()
