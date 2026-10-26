#!/usr/bin/env python3
"""One-shot reminder only; never claim quota reset or start agents."""
import argparse
import json
import os
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--board", type=Path)
args = parser.parse_args()
home = Path(os.environ.get("HERMES_HOME", str(Path.home() / ".hermes")))
board = args.board or home / "plans" / "dispatch.json"
try:
    task = json.loads(board.read_text()).get("86bcm901u-content-quality-gate", {})
except (OSError, ValueError):
    task = {}
if task.get("phase") == "queued" and task.get("reviewer_opus") == "quota-held-after-sol":
    print("⏰ **86bcm901u**: the Opus reset was due at **17:19 EDT on October 22**; live quota is not verified. Reply **start** to check quota and launch the second full review. Sol found two diagnostic-output defects; the finisher still waits for Opus.")
