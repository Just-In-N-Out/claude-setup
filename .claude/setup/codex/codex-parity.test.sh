#!/usr/bin/env bash
# Acceptance tests for story codex-parity (~/.hermes/plans/claude-setup/codex-parity.md).
#   bash codex-parity.test.sh                     every offline test (no Codex sign-in, no quota)
#   bash codex-parity.test.sh <test> [<test>…]    just those, numbered TAP: "ok 1 - <test>"
# Probe tests (real `codex exec`) run only when named; they need CODEX_PROBE_HOME signed in.
# Live tests (ac24-ac27) check a real machine and run only when named.
# Everything under test comes from this file's own checkout (the codex-parity worktree, or $HOME
# itself once merged), never from the real ~/.codex, ~/.claude or ~/.hermes. Fake homes live under
# ${CODEX_PARITY_TEST_ROOT:-$HOME/.cache/codex-parity-tests}, outside $TMPDIR and /tmp, so Codex's
# sandbox treats them like a real home.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "$HERE/../../.." && pwd)             # the checkout root ($HOME-relative layout)
REAL_HOME=$HOME
ROOT=${CODEX_PARITY_TEST_ROOT:-$REAL_HOME/.cache/codex-parity-tests}
FIX="$SRC/.codex/hooks/tests/fixtures"
mkdir -p "$ROOT"
. "$HERE/probe-lib.sh" 2>/dev/null || true   # missing on the base commit: probe tests then fail, never skip

OFFLINE="ac1_agents_md_loaded ac3_session_start_rules_fresh ac4_codex_sees_claude_skills ac5_roles_valid_and_load
ac6_gates_match_claude_twins ac7_claude_hooks_unchanged ac8_commit_guard_blocks_ai_trailer ac10_sandbox_profile_and_rules
ac12_sync_codex_paths ac13_sync_suite_green ac14_lock_claude_and_codex_same_moment ac15_session_start_reuses_claude_pull
ac16_stop_hook_pushes_in_background ac18_memory_index_injected ac19_config_merge_idempotent
ac20_codex_edit_reaches_other_machine ac21_pipeline_model_switch ac23_docs_updated"

fail() { echo "FAIL: $*"; return 1; }
need() { [ -e "$1" ] || fail "missing $1 (not built yet)"; }
newroot() { # newroot: a fresh test folder in $S, a fake home in $H; TMPDIR inside it, away from $H
  S=$(mktemp -d "$ROOT/t.XXXXXX"); H="$S/home"; mkdir -p "$H/.codex" "$S/tmp"
  printf '[user]\n\tname = Test Personal\n\temail = personal@example.test\n[includeIf "gitdir:~/Leorna/"]\n\tpath = ~/.gitconfig-leorna\n' >"$H/.gitconfig"
  printf '[user]\n\tname = Test Leorna\n\temail = leorna@example.test\n' >"$H/.gitconfig-leorna"
}
inhome() { HOME="$H" CODEX_HOME="${CH:-$H/.codex}" TMPDIR="$S/tmp" GIT_CONFIG_NOSYSTEM=1 "$@"; }
install_setup() { # copies the checkout's setup files into the fake home (never symlinks into the checkout)
  mkdir -p "$H/.claude/setup" "$H/.claude/hooks" "$H/.codex/hooks" "$H/.codex/agents" "$H/.codex/rules" "$H/.hermes/scripts"
  cp -R "$SRC/.claude/setup/." "$H/.claude/setup/"
  cp "$SRC"/.claude/hooks/*.sh "$H/.claude/hooks/"
  cp "$SRC/.claude/CLAUDE.md" "$H/.claude/CLAUDE.md"
  cp "$SRC"/.codex/hooks/*.sh "$H/.codex/hooks/" 2>/dev/null
  cp "$SRC"/.codex/agents/*.toml "$H/.codex/agents/" 2>/dev/null
  cp "$SRC/.codex/hooks.json" "$H/.codex/" 2>/dev/null
  cp "$SRC/.codex/rules/setup-sync.rules" "$H/.codex/rules/" 2>/dev/null
  cp "$SRC/.hermes/scripts/update-skills-library.sh" "$H/.hermes/scripts/"
}
attach_repo() { # a setup repo for the fake home with a local bare remote at $S/remote.git (sync.test.sh's way)
  git init -q --bare -b main "$S/remote.git"
  (cd "$H" && inhome env SETUP_SYNC_URL="$S/remote.git" bash "$H/.claude/setup/sync.sh" init >/dev/null &&
   inhome env SETUP_SYNC_URL="$S/remote.git" bash "$H/.claude/setup/sync.sh" >/dev/null 2>&1)
}
payload() { jq -c --arg cwd "${2:-$H}" '.cwd = $cwd' "$FIX/$1"; }   # a recorded payload, cwd moved into the fake home

n=0; failed=0
run() {
  local t=$1 out rc
  n=$((n + 1))
  if [ "$(type -t "$t")" != function ]; then echo "not ok $n - $t"; echo "# no such test"; failed=$((failed + 1)); return; fi
  out=$( ( "$t" ) 2>&1 ); rc=$?
  printf '%s\n' "$out" | sed 's/^/#  /'
  if [ $rc -eq 0 ]; then echo "ok $n - $t"; else echo "not ok $n - $t"; failed=$((failed + 1)); fi
}

# ---- tests: one function per AC (ac1_agents_md_loaded … ac27_codex_story_run), each in a ( subshell ) via run ----

ac1_agents_md_loaded() { fail "not written"; }
ac2_first_turn_knows_rules() { fail "not written"; }
ac3_session_start_rules_fresh() { fail "not written"; }
ac4_codex_sees_claude_skills() { fail "not written"; }
ac5_roles_valid_and_load() { fail "not written"; }
ac6_gates_match_claude_twins() { fail "not written"; }
ac7_claude_hooks_unchanged() { fail "not written"; }
ac8_commit_guard_blocks_ai_trailer() { fail "not written"; }
ac9_codex_commit_identity_no_trailer() { fail "not written"; }
ac10_sandbox_profile_and_rules() { fail "not written"; }
ac11_codex_runs_sync_outside_sandbox() { fail "not written"; }
ac12_sync_codex_paths() { fail "not written"; }
ac13_sync_suite_green() { fail "not written"; }
ac14_lock_claude_and_codex_same_moment() { fail "not written"; }
ac15_session_start_reuses_claude_pull() { fail "not written"; }
ac16_stop_hook_pushes_in_background() { fail "not written"; }
ac17_codex_skill_edit_reaches_remote() { fail "not written"; }
ac18_memory_index_injected() { fail "not written"; }
ac19_config_merge_idempotent() { fail "not written"; }
ac20_codex_edit_reaches_other_machine() { fail "not written"; }
ac21_pipeline_model_switch() { fail "not written"; }
ac22_roles_use_switched_model() { fail "not written"; }
ac23_docs_updated() { fail "not written"; }
ac24_linux_suites() { fail "not written"; }
ac25_desktop_codex_parity() { fail "not written"; }
ac26_mac_install_smoke() { fail "not written"; }
ac27_codex_story_run() { fail "not written"; }

if [ $# -gt 0 ]; then for t in "$@"; do run "$t"; done; else for t in $OFFLINE; do run "$t"; done; fi
echo "# passed $((n - failed)), failed $failed"
[ "$failed" -eq 0 ]
