#!/usr/bin/env bash
# Switch the model every Codex pipeline role runs on (planner, builder, reviewers, fixers,
# verifier, auditor, finisher), on both machines, until the next switch.
#   set-pipeline-model.sh <model> [effort]    the effort defaults to the current one
# 1. checks <model> and the effort against ~/.codex/models_cache.json, refusing with the valid list;
# 2. writes ~/.claude/setup/codex/pipeline-model.toml (the one setting) and rewrites the role files
#    and ~/.codex/AGENTS.md from it (build-codex.sh);
# 3. runs ~/.claude/setup/sync.sh, which commits and pushes; the other machine gets it at its next pull.
# Exit 0 switched, 2 refused (unknown model or effort, no models list), 1 the sync failed.
set -euo pipefail
DIR=$(cd "$(dirname "$0")" && pwd)
SETTING="$DIR/pipeline-model.toml"
CACHE="${CODEX_HOME:-$HOME/.codex}/models_cache.json"
SYNC=${SETUP_SYNC_SCRIPT:-$HOME/.claude/setup/sync.sh}
model=${1:-}; effort=${2:-}
[ -n "$model" ] || { echo "usage: set-pipeline-model.sh <model> [effort]" >&2; exit 2; }
[ -f "$CACHE" ] || { echo "set-pipeline-model: no $CACHE; run codex once on this machine so it lists your models" >&2; exit 2; }
models=$(jq -r '.models[].slug' "$CACHE")
if ! grep -qxF -- "$model" <<<"$models"; then
  echo "set-pipeline-model: unknown model '$model'. Valid models (from $CACHE):" >&2
  sed 's/^/  /' <<<"$models" >&2; exit 2
fi
current=$(sed -n 's/^model_reasoning_effort = "\(.*\)"$/\1/p' "$SETTING" 2>/dev/null | head -1)
effort=${effort:-${current:-xhigh}}
efforts=$(jq -r --arg m "$model" '.models[] | select(.slug == $m) | .supported_reasoning_levels[]?.effort' "$CACHE")
if ! grep -qxF -- "$effort" <<<"$efforts"; then
  echo "set-pipeline-model: $model has no '$effort' effort. Valid: $(tr '\n' ' ' <<<"$efforts")" >&2; exit 2
fi
tmp=$(mktemp "$SETTING.XXXXXX")
{ grep '^#' "$SETTING" 2>/dev/null || true; printf 'model = "%s"\nmodel_reasoning_effort = "%s"\n' "$model" "$effort"; } >"$tmp"
mv -f "$tmp" "$SETTING"
bash "$DIR/build-codex.sh"
echo "set-pipeline-model: Codex pipeline roles now run on $model at $effort"
bash "$SYNC" || exit 1
