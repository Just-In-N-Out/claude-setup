#!/usr/bin/env bash
# The dream's Python tests (story dream-pass). Everything under test comes from this file's own
# checkout (the story worktree, or $HOME once merged); every test builds a fake home with
# fakehome.py and a fake `claude` (fake-claude), never the real $HOME, setup repo or claude.
#   bash run.sh                      every test except the live one, numbered TAP lines ("ok 3 - test_ac5_...")
#   bash run.sh <test name>...       only those tests (a name that matches no test is an error)
#   bash run.sh --live [<name>...]   also the named-only live test of AC37 (two small real calls)
# Run it under the memory cap on the desktop:
#   systemd-run --user --scope -q -p MemoryMax=4G -p MemorySwapMax=0 bash run.sh
HERE=$(cd "$(dirname "$0")" && pwd)
export PYTHONDONTWRITEBYTECODE=1
exec python3 -B "$HERE/runner.py" "$@"
