#!/usr/bin/env bash
# Mutation run on the dream's guards (story dream-pass, plan Task 16). Never mutates the checkout: it
# copies this checkout's HEAD (git archive) into a scratch folder and mutates that, one mutant at a time,
# every test run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
#   bash mutants.sh <report.md> [mutant id...]     e.g. bash mutants.sh ~/x/mutants.md M1 M5
# Exit 0 when every mutant was killed. The table is in mutants.py.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../../.." && pwd)
REPORT=${1:?usage: mutants.sh <report.md> [mutant id...]}
shift
SCRATCH=$(mktemp -d "${DREAM_TEST_ROOT:-$HOME/.cache/dream-tests}/mutants.XXXX" 2>/dev/null) \
  || { mkdir -p "$HOME/.cache/dream-tests" && SCRATCH=$(mktemp -d "$HOME/.cache/dream-tests/mutants.XXXX"); }
trap 'rm -rf "$SCRATCH"' EXIT
HEADSHA=$(git -C "$ROOT" rev-parse HEAD) || exit 2
git -C "$ROOT" archive HEAD | tar -x -C "$SCRATCH" || exit 2
export MUTANT_HEAD=$HEADSHA PYTHONDONTWRITEBYTECODE=1 DREAM_TEST_ROOT="$SCRATCH/.tests"
mkdir -p "$DREAM_TEST_ROOT"
echo "mutating a copy of $HEADSHA in $SCRATCH"
python3 -B "$HERE/mutants.py" "$SCRATCH" "$REPORT" "$@"
