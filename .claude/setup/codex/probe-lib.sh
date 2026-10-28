# probe-lib.sh: run a real `codex exec` without touching ~/.codex.
# CODEX_PROBE_HOME (default ~/.codex-probe) is a Codex home that holds only a ChatGPT sign-in
# (auth.json, file store). A probe copies its AGENTS.md, hooks.json, agents/ and rules/ in, runs,
# then removes them again. One probe at a time (mkdir lock). Never synced (sync.sh DENY_RE).
# Sourced by codex-parity.test.sh and capture-payloads.sh, which set REAL_HOME.
PROBE=${CODEX_PROBE_HOME:-${REAL_HOME:-$HOME}/.codex-probe}
PROBE_MODEL=${CODEX_PROBE_MODEL:-gpt-6.1-sol}
PROBE_EFFORT=${CODEX_PROBE_EFFORT:-low}
probe_ready() {
  [ -s "$PROBE/auth.json" ] && return 0
  echo "# no ChatGPT sign-in in $PROBE. Justin runs once:"
  echo "#   mkdir -p $PROBE && printf 'cli_auth_credentials_store = \"file\"\\n' > $PROBE/config.toml && CODEX_HOME=$PROBE codex login"
  return 1
}
probe_clean() {
  rm -rf "${PROBE:?}/AGENTS.md" "${PROBE:?}/AGENTS.override.md" "${PROBE:?}/hooks.json" "${PROBE:?}/agents" "${PROBE:?}/rules"
  printf 'cli_auth_credentials_store = "file"\n' >"$PROBE/config.toml"
}
probe_begin() { # probe_begin <fake home>: stage that home's Codex files into the probe home
  mkdir "$PROBE/.probe.lock" 2>/dev/null || { echo "# another probe is running ($PROBE/.probe.lock)"; return 1; }
  probe_clean
  [ -f "$1/.codex/AGENTS.md" ] && cp "$1/.codex/AGENTS.md" "$PROBE/"
  [ -f "$1/.codex/hooks.json" ] && cp "$1/.codex/hooks.json" "$PROBE/"
  [ -d "$1/.codex/agents" ] && cp -R "$1/.codex/agents" "$PROBE/"
  [ -d "$1/.codex/rules" ] && cp -R "$1/.codex/rules" "$PROBE/"
  [ -f "$1/.codex/config.toml" ] && { printf 'cli_auth_credentials_store = "file"\n'; cat "$1/.codex/config.toml"; } >"$PROBE/config.toml"
  return 0
}
probe_end() { probe_clean; rmdir "$PROBE/.probe.lock" 2>/dev/null; }
probe_exec() { # probe_exec <fake home> <cwd> <out dir> <prompt> [extra codex args…]
  local h=$1 cwd=$2 out=$3 prompt=$4; shift 4
  HOME="$h" CODEX_HOME="$PROBE" TMPDIR="$(dirname "$h")/tmp" codex exec --ephemeral --skip-git-repo-check \
    --dangerously-bypass-hook-trust -m "$PROBE_MODEL" -c "model_reasoning_effort=\"$PROBE_EFFORT\"" \
    -C "$cwd" --json -o "$out/last.txt" "$@" "$prompt" </dev/null >"$out/events.jsonl" 2>"$out/stderr.txt"
}   # </dev/null: with a non-terminal stdin, codex exec waits to read more prompt from it
