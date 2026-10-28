#!/usr/bin/env bash
# Acceptance tests for story harness-guards (~/.hermes/plans/claude-setup/harness-guards.md).
#   bash harness-guards.test.sh                    every offline test (ac1-ac18, ac20)
#   bash harness-guards.test.sh <test> [<test>…]   just those, numbered TAP: "ok 1 - <test>"
# ac19 runs the other suites (and this file's offline run), and the live tests (ac21, ac22) check a
# real machine after the finish: they run only when named.
# Everything under test comes from this file's own checkout (the harness-guards worktree, or $HOME
# once merged), never from the live ~/.claude, ~/.hermes or the real global git config.
# - Hook tests feed JSON to the checkout's scripts with HOME = a fake home.
# - Git tests make repos under ${HARNESS_GUARDS_TEST_ROOT:-$HOME/.cache/harness-guards-tests}, outside
#   the system temp folders (githook.sh skips its checks there), with GIT_CONFIG_GLOBAL = a test file
#   (personal email, an includeIf for <fake home>/Leorna/, core.hooksPath = the checkout's githooks)
#   and GIT_CONFIG_NOSYSTEM=1.
set -uo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
SRC=$(cd "$HERE/../../.." && pwd)            # the checkout root ($HOME-relative layout)
REAL_HOME=$HOME
ROOT=${HARNESS_GUARDS_TEST_ROOT:-$REAL_HOME/.cache/harness-guards-tests}
mkdir -p "$ROOT"
# overrides inherited from a git hook or a Claude session would point the tests at real files: drop them
unset GIT_CONFIG_GLOBAL GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME \
  GIT_COMMITTER_EMAIL GIT_CONFIG_PARAMETERS GIT_CONFIG_COUNT SUBAGENT_LESSONS_STATE_DIR SUBAGENT_AC_STATE_DIR \
  SKILL_NUDGE_STATE_DIR

OFFLINE="ac1_guard_denies_identity_override ac2_guard_denies_gh_account_changes
ac3_guard_denies_remote_and_credential_changes ac4_guard_denies_hook_bypass ac5_guard_allows_leorna_https_fallback
ac6_guard_asks_before_leorna_push ac7_guard_parses_shell_forms ac8_precommit_blocks_claude_md_except_setup_repo
ac9_precommit_blocks_wrong_email_by_folder ac10_commit_msg_blocks_ai_coauthor ac11_githooks_chain_repo_hooks
ac12_temp_repos_skip_checks_but_chain ac13_orchestrator_guard_asks_main_session_code_edit
ac14_orchestrator_guard_quiet_for_subagents_and_own_files ac15_lessons_gate_message_names_enforce
ac16_lessons_gate_sends_back_missing_enforce_once ac17_docs_define_enforce_and_backlog ac18_guard_docs_and_manifest
ac20_settings_register_guards"

GG="$SRC/.claude/hooks/git-guard.sh"
OG="$SRC/.claude/hooks/orchestrator-guard.sh"
GHOOKS="$SRC/.claude/githooks"
LGATE="$SRC/.claude/hooks/subagent-lessons-gate.sh"
WRAPPERS="applypatch-msg pre-applypatch post-applypatch pre-commit pre-merge-commit prepare-commit-msg commit-msg
post-commit pre-rebase post-checkout post-merge pre-push pre-auto-gc post-rewrite sendemail-validate push-to-checkout"
PERSONAL=issajustin04@gmail.com
LEORNA=justin@leorna.com
LAST='MAIN SESSION: check and save these skill_lessons now.'
SHAPE='skill_lessons[{skill, lesson, evidence, enforce}]'
OLD_SHAPE='{skill, lesson, evidence'"}]"   # split so this file never holds the old shape itself
BACKLOG='~/.hermes/plans/claude-setup/enforce-backlog.md'

fail() { echo "FAIL: $*"; return 1; }
need() { [ -e "$1" ] || fail "missing $1 (not built yet)"; }
newroot() { # newroot: a fresh test folder $S with a fake home $H and its git config files
  S=$(mktemp -d "$ROOT/t.XXXXXX") && S=$(cd "$S" && pwd -P) || return 1
  H="$S/home"; mkdir -p "$H/work" "$S/scratchpad"
  printf '[user]\n\tname = Test Personal\n\temail = %s\n[includeIf "gitdir:%s/Leorna/"]\n\tpath = %s/gitconfig-leorna\n[core]\n\thooksPath = %s\n[init]\n\tdefaultBranch = main\n[advice]\n\tdetachedHead = false\n' \
    "$PERSONAL" "$H" "$S" "$GHOOKS" >"$S/gitconfig"
  printf '[user]\n\tname = Test Leorna\n\temail = %s\n' "$LEORNA" >"$S/gitconfig-leorna"
}
ing() { HOME="$H" GIT_CONFIG_GLOBAL="$S/gitconfig" GIT_CONFIG_NOSYSTEM=1 "$@"; }
nohooks() { ing git -c core.hooksPath=/dev/null "$@"; }     # fixtures only: git with no hooks at all
done_ok() { rm -rf "$S"; return 0; }                        # remove the test folder on success (kept on failure)
srcgit() { # git for the checkout: the worktree, or $HOME's bare repo once merged
  if git -C "$SRC" rev-parse --git-dir >/dev/null 2>&1; then git -C "$SRC" "$@"
  else git --git-dir="$SRC/.claude-setup.git" --work-tree="$SRC" "$@"; fi
}
limit() { perl -e '$s = shift; alarm $s; exec @ARGV or die "exec: $!"' "$@"; }   # limit <seconds> <cmd…>

# ---- hook calls: stdout in $out, exit code in $rc ----
hook() { out=$(printf '%s' "$2" | HOME="$H" bash "$1" 2>"$S/hook.err"); rc=$?; }
bashcall() { # bashcall <command> [cwd] [agent_id]: git-guard on a Bash call
  local j
  j=$(jq -nc --arg c "$1" --arg cwd "${2:-$H/work}" --arg a "${3:-}" \
    '{session_id: "s1", transcript_path: "/x/t.jsonl", hook_event_name: "PreToolUse", tool_name: "Bash",
      tool_input: {command: $c, description: "d"}, tool_use_id: "t1", cwd: $cwd, permission_mode: "auto"}
     + (if $a == "" then {} else {agent_id: $a, agent_type: "general-purpose"} end)')
  hook "$GG" "$j"
}
editcall() { # editcall <tool> <path> [agent_id] [mode] [scratchpad_dir]: orchestrator-guard on an edit
  local j key=file_path
  [ "$1" = NotebookEdit ] && key=notebook_path
  j=$(jq -nc --arg t "$1" --arg p "$2" --arg k "$key" --arg a "${3:-}" --arg m "${4:-auto}" \
    --arg sp "${5:-$S/scratchpad}" --arg cwd "$H/work" \
    '{session_id: "s1", transcript_path: "/x/t.jsonl", hook_event_name: "PreToolUse", tool_name: $t,
      tool_input: ({($k): $p} + (if $t == "Write" then {content: "x"} else {old_string: "a", new_string: "b"} end)),
      tool_use_id: "t1", cwd: $cwd, permission_mode: $m, scratchpad_dir: $sp}
     + (if $a == "" then {} else {agent_id: $a, agent_type: "general-purpose"} end)')
  hook "$OG" "$j"
}
decision() { # the permissionDecision in $out; "none" for no output, "bad" for anything that isn't one decision
  [ -n "$out" ] || { echo none; return; }
  [ "$(jq -s 'length' <<<"$out" 2>/dev/null)" = 1 ] || { echo bad; return; }
  jq -er 'if type == "object" then .hookSpecificOutput.permissionDecision // "bad" else "bad" end' <<<"$out" 2>/dev/null || echo bad
}
reason() { jq -r '.hookSpecificOutput.permissionDecisionReason // ""' <<<"$out" 2>/dev/null; }
check() { # check <want> <reason ERE or ""> <what>: $rc must be 0 and $out one JSON with that decision
  local got; got=$(decision)
  [ "$rc" = 0 ] || fail "exit $rc for: $3" || return 1
  [ "$got" = "$1" ] || fail "want $1, got $got for: $3 (out: $out)" || return 1
  if [ -n "$2" ]; then reason | grep -qE -- "$2" || fail "reason lacks /$2/ for: $3 (reason: $(reason))" || return 1; fi
  echo "# $1: $3"
}
expect() { local want=$1 re=$2; shift 2; bashcall "$@"; check "$want" "$re" "$1${2:+ (cwd $2)}${3:+ (agent $3)}"; }
expect_edit() { local want=$1 re=$2; shift 2; editcall "$@"; check "$want" "$re" "$1 $2${3:+ agent=$3}${4:+ mode=$4}"; }

# ---- git helpers ----
gitrepo() { # gitrepo <dir>: a new repo with one seed commit (made with no hooks)
  mkdir -p "$1" && ing git init -q -b main "$1" && echo seed >"$1/seed.txt" && ing git -C "$1" add seed.txt \
    && nohooks -C "$1" commit -q -m seed
}
setuprepo() { # setuprepo: a fake setup repo $H/.claude-setup.git (bare, work tree $H) with one commit
  ing git init -q --bare -b main "$H/.claude-setup.git" && ing git --git-dir="$H/.claude-setup.git" config core.bare false \
    && ing git --git-dir="$H/.claude-setup.git" config core.worktree "$H" \
    && mkdir -p "$H/.claude" && echo seed >"$H/.claude/seed.txt" \
    && (cd "$H" && ing git --git-dir="$H/.claude-setup.git" add .claude/seed.txt \
        && nohooks --git-dir="$H/.claude-setup.git" commit -q -m seed)
}
commit_in() { # commit_in <repo dir> <git commit args…>: $out (both streams), $rc
  local d=$1; shift
  out=$(cd "$d" && ing git commit -q "$@" 2>&1 </dev/null); rc=$?
}
refused() { # refused <hook name> <ERE> <what>: the last commit attempt failed in that hook with a matching message
  [ "$rc" != 0 ] || fail "not refused: $3" || return 1
  grep -qF "githooks ($1)" <<<"$out" || fail "not refused by $1: $3 (out: $out)" || return 1
  grep -qE -- "$2" <<<"$out" || fail "message lacks /$2/: $3 (out: $out)" || return 1
  echo "# refused by $1: $3"
}
passed() { [ "$rc" = 0 ] || fail "refused: $1 (out: $out)" || return 1; echo "# committed: $1"; }

# ---- tests: one function per AC, each in a ( subshell ) via run ----

ac1_guard_denies_identity_override() {
  local c
  need "$GG" || return 1
  newroot
  for c in "git -c user.email=x@example.test commit -m x" "git -c user.name=Someone commit -m x" \
    "git -c author.email=x@example.test commit -m x" "git -c author.name=X commit -m x" \
    "git -c committer.email=x@example.test commit -m x" "git -c committer.name=X commit -m x" \
    "git -c User.Email=x@example.test commit -m x" "git --config-env=user.email=MY_EMAIL commit -m x" \
    "git --config-env user.email=MY_EMAIL commit -m x" "git commit --author='X <x@example.test>' -m x" \
    "git commit --author 'X <x@example.test>' -m x" "git commit -m x --author=x@example.test" \
    "GIT_AUTHOR_EMAIL=x@example.test git commit -m x" "GIT_AUTHOR_NAME=X git commit -m x" \
    "GIT_COMMITTER_EMAIL=x@example.test git commit -m x" "GIT_COMMITTER_NAME=X git commit -m x" \
    "env GIT_AUTHOR_EMAIL=x@example.test git commit -m x" "env -i GIT_COMMITTER_EMAIL=x@example.test git commit -m x" \
    "export GIT_AUTHOR_EMAIL=x@example.test" "export GIT_COMMITTER_NAME=X && git commit -m x" \
    "git config user.email x@example.test" "git config --global user.email x@example.test" \
    "git config --local user.name X" "git config set --global user.email x@example.test" \
    "git config --global --replace-all user.email x@example.test" "git config --unset user.email" \
    "GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=user.email GIT_CONFIG_VALUE_0=x@example.test git commit -m x" \
    "export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=user.email GIT_CONFIG_VALUE_0=x@example.test; git commit -m x" \
    "GIT_CONFIG_PARAMETERS=\"'user.email'='x@example.test'\" bash -c 'git commit -m x'" \
    "git commit \$'--author=X <x@example.test>' -m x" "git -c \$'user.\\x65mail=x@example.test' commit -m x" \
    "git config \$'user.email' x@example.test" "git config \$\"user.name\" X"; do
    expect deny 'commit identity' "$c" || return 1
  done
  # git takes any unique abbreviation of a long option (--auth is --author, --val is --value)
  for c in "git commit --auth='X <x@example.test>' -m x" "git commit --au 'X <x@example.test>' -m x" \
    "git commit -m x --autho='Z <z@example.test>'" "git config set --global --val x user.email x@example.test" \
    "git config --global --rep user.email x@example.test" "git config --global --a user.name X" \
    "git config --global --remove-s user" "git config --global --unset-a user.email"; do
    expect deny 'commit identity' "$c" || return 1
  done
  # declare -x, typeset -x, local -x and readonly set a variable as export does
  for c in "typeset -x GIT_AUTHOR_EMAIL=x@example.test; git commit -m x" "declare -x GIT_COMMITTER_EMAIL=x@example.test" \
    "f() { local -x GIT_AUTHOR_NAME=X; git commit -m x; }; f" "declare -gx FOO=1 GIT_COMMITTER_NAME=X && git commit -m x" \
    "readonly GIT_AUTHOR_EMAIL=x@example.test; git commit -m x" \
    "typeset -x GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=user.email GIT_CONFIG_VALUE_0=x@example.test; git commit -m x"; do
    expect deny 'commit identity' "$c" || return 1
  done
  expect deny 'commit identity' "git -c user.email=x@example.test commit -m x" "$H/work" agent-1 || return 1
  for c in "git log --author=x" "git shortlog -se" "git config user.email" "git config --global --get user.email" \
    "git commit --amend --no-edit" "git commit --all -m x" "git commit --mess '--author=x' -q" \
    "declare -x FOO=1; git commit -m x" "declare -p GIT_AUTHOR_EMAIL" "typeset -x GIT_TRACE=1 && git log -1" \
    "git config --get-a user.email" "git config --global --get-r '^user'" "git config --fil x.cfg --get user.email" \
    "git config --global --un user.email" "git config --global --fi x.cfg user.email x@example.test" \
    "git config --global --uns core.hooksPath" "git config --global --e" \
    "git config get user.name" "git config --get-regexp '^user\.'" "unset GIT_AUTHOR_EMAIL" \
    "git log --format='%ae' -1" "git commit -m 'set --author later'" "git commit -m x"; do
    expect none '' "$c" || return 1
  done
  done_ok
}

ac2_guard_denies_gh_account_changes() {
  local c
  need "$GG" || return 1
  newroot
  for c in "gh auth switch" "gh auth switch --user Just-In-N-Out" "gh auth switch -u Justin-Leorna -h github.com" \
    "gh auth setup-git" "/usr/bin/gh auth switch --user Justin-Leorna" "cd /x && gh auth switch"; do
    expect deny 'gh account' "$c" || return 1
  done
  expect deny 'gh account' "gh auth switch" "$H/work" agent-2 || return 1
  for c in "gh auth status" "gh auth token --user Just-In-N-Out" "gh pr list" "gh repo view LeornaAI/leorna-client"; do
    expect none '' "$c" || return 1
  done
  done_ok
}

ac3_guard_denies_remote_and_credential_changes() {
  local c
  need "$GG" || return 1
  newroot
  for c in "git remote set-url origin git@github.com:x/y.git" "git remote set-url --push origin https://x.test/y.git" \
    "git config remote.origin.url https://x.test/y.git" "git config remote.origin.pushurl https://x.test/y.git" \
    "git config --local remote.upstream.url x" "git config set remote.origin.url x"; do
    expect deny 'remote URL' "$c" || return 1
  done
  for c in "git config credential.helper store" "git config --global credential.helper ''" \
    "git config --global --add credential.helper store" "git config --replace-all credential.helper store" \
    "git config --unset credential.helper" "git config --global --unset-all credential.helper" \
    "git config set --global credential.helper store" "git config unset --local credential.helper" \
    "git config --system credential.https://github.com.username x" \
    "git -c credential.helper=store fetch origin" "git -c credential.helper= push origin main" \
    "git -c credential.https://github.com.helper=store push origin main" \
    "export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=credential.helper GIT_CONFIG_VALUE_0=store; git fetch origin" \
    "export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=credential.helper 'GIT_CONFIG_VALUE_0=!gh auth git-credential' && git push https://github.com/LeornaAI/leorna-client.git feat/x" \
    "git config --global --unset-al credential.helper" "git config --global --remove-s credential" \
    "git config --global --a credential.helper store" "git config --global --rep credential.helper store" \
    "git config --global --ty path credential.helper store" "git config set --global --comm hi credential.helper store"; do
    expect deny 'credential helper' "$c" || return 1
  done
  for c in "git config --global --rename-s remote.origin remote.x" "git config --remove-sec remote.origin"; do
    expect deny 'remote URL' "$c" || return 1
  done
  for c in "git config --global --edit" "git config --global --ed" "git config edit --global" "git config -e"; do
    expect deny 'config --edit' "$c" || return 1
  done
  for c in "git remote -v" "git remote add upstream https://github.com/x/y.git" "git config --get-regexp credential" \
    "git config --local --list" "git config get credential.helper" "git config --get remote.origin.url" \
    "git remote get-url origin"; do
    expect none '' "$c" || return 1
  done
  done_ok
}

ac4_guard_denies_hook_bypass() {
  local c
  need "$GG" || return 1
  newroot
  for c in "git commit --no-verify -m x" "git commit -n -m x" "git commit -anm x" "git commit -a -n" \
    "git commit -m x --no-verif" "git push --no-verify" "git push --no-verify origin main" "git merge --no-verify side" \
    "git rebase --no-verify main" "git am --no-verify x.patch" "git cherry-pick --no-verify abc123" \
    "git -c core.hooksPath= commit -m x" "git -c core.hooksPath=/x commit -m x" "git -c core.hookspath=/dev/null commit -m x" \
    "git --config-env=core.hooksPath=X commit -m x" "git config --global core.hooksPath /other" \
    "git config --global --unset core.hooksPath" "git config --local core.hooksPath .githooks" \
    "git config unset --global core.hooksPath" "git config --global core.hooksPath ~/.claude/githooks-old" \
    "git config --global --unset-a core.hooksPath" \
    "git config --global --remove-s core" "git config --global --rep core.hooksPath /x" \
    "GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/x git commit -m x"; do
    expect deny 'skip the git hooks' "$c" || return 1
  done
  # the git config environment counts wherever it is set: export, a ; chain, or a nested shell that inherits it
  for c in "export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null && git commit -m x" \
    "export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null; git commit -m x" \
    "GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null bash -c 'git commit -m x'" \
    "env GIT_CONFIG_PARAMETERS=\"'core.hooksPath'=''\" sh -c \"git commit -m x\"" \
    "export GIT_CONFIG_PARAMETERS=\"'core.hooksPath'=''\"; git commit -m x" \
    "export GIT_CONFIG_COUNT=1; export GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=; git commit -m x" \
    "export GIT_CONFIG_COUNT=1; bash -c 'GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0= git commit -m x'" \
    "declare -x GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null; git commit -m x" \
    "typeset -x GIT_CONFIG_COUNT=1; declare -x GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=; git commit -m x" \
    "f() { local -x GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/x; git commit -m x; }; f" \
    "declare -rx GIT_CONFIG_PARAMETERS=\"'core.hooksPath'=''\"; bash -c 'git commit -m x'"; do
    expect deny 'skip the git hooks' "$c" || return 1
  done
  # bash's $'…' (with its escapes) and $"…" quoting is read the way bash reads it
  for c in "git commit \$'--no-verify' -m x" "git commit \$'--no-\\x76erify' -m x" "git commit \$\"--no-verify\" -m x" \
    "git -c \$'core.hooksPath=' commit -m x" "git commit \$'--no-\\166erify' -m x" "git commit \$'--no-\\u0076erify' -m x" \
    "git commit -m \$'it\\'s' \$'--no-verify'" "git config --global \$'core.hooksPath' /x"; do
    expect deny 'skip the git hooks' "$c" || return 1
  done
  for c in "git commit -am x" "git commit -m '-n'" "git commit -m \"-n\"" "git commit -am '-n'" "git commit -m 'docs: --no-verify'" \
    "git commit -m x -m 'never use -n'" "git commit -F msg.txt" "git commit -C HEAD" \
    "git push -n" "git push --dry-run origin main" "git clean -n" "git clean -nd" "git config --global core.hooksPath" \
    "git config --global core.hooksPath ~/.claude/githooks" "git config --global core.hooksPath '~/.claude/githooks'" \
    "git config --global core.hooksPath \"\$HOME/.claude/githooks\"" "git config --global core.hooksPath \${HOME}/.claude/githooks/" \
    "git config --global core.hooksPath $H/.claude/githooks" "git config --global core.hooksPath \$'$H/.claude/githooks'" \
    "git commit -m \$'it\\'s --no-verify'" "git commit -m \$'line 1\\n--no-verify'" "git commit -m \$\"--no-verify\"" \
    "export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=color.ui GIT_CONFIG_VALUE_0=always; git log -1" \
    "(export GIT_CONFIG_COUNT=1); GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/x git commit -m x"; do
    expect none '' "$c" || return 1
  done
  done_ok
}

ac5_guard_allows_leorna_https_fallback() {
  local c fb="git -c credential.helper= -c 'credential.helper=!gh auth git-credential'"
  need "$GG" || return 1
  newroot; mkdir -p "$H/Leorna/leorna-client"
  expect ask 'Leorna push' "$fb push https://github.com/LeornaAI/leorna-client.git feat/x" || return 1
  expect ask 'Leorna push' "$fb push https://github.com/LeornaAI/leorna-client.git feat/x" "$H/Leorna/leorna-client" agent-5 || return 1
  expect ask 'Leorna push' "$fb push -u https://github.com/LeornaAI/leorna-client.git HEAD:feat/x" || return 1
  expect none '' "$fb fetch https://github.com/LeornaAI/leorna-client.git feat/x:refs/remotes/origin/feat/x" || return 1
  expect none '' "$fb fetch https://github.com/LeornaAI/leorna-client.git feat/x:refs/remotes/origin/feat/x" "$H/Leorna/leorna-client" || return 1
  for c in "$fb push https://github.com/Just-In-N-Out/claude-setup.git main" \
    "$fb push https://github.com/LeornaAIx/leorna-client.git feat/x" \
    "$fb push origin feat/x" \
    "git -c credential.helper= -c 'credential.helper=store' push https://github.com/LeornaAI/leorna-client.git feat/x" \
    "git -c credential.helper= -c 'credential.helper=!gh auth token' push https://github.com/LeornaAI/leorna-client.git feat/x" \
    "$fb ls-remote https://github.com/LeornaAI/leorna-client.git" \
    "$fb clone https://github.com/LeornaAI/leorna-client.git" \
    "$fb pull https://github.com/LeornaAI/leorna-client.git feat/x"; do
    expect deny 'credential helper' "$c" || return 1
  done
  done_ok
}

ac6_guard_asks_before_leorna_push() {
  local c lc
  need "$GG" || return 1
  newroot; lc="$H/Leorna/leorna-client"; mkdir -p "$lc" "$H/code/site"
  local re='push only after he says "push"'
  expect ask "$re" "git push" "$lc" || return 1
  expect ask "$re" "git push origin feat/x" "$lc/internal/sub" || return 1
  expect ask "$re" "git push --dry-run" "$lc" || return 1
  expect ask "$re" "git push" "$lc" agent-6 || return 1
  for c in "cd ~/Leorna/leorna-client && git push origin feat/x" "cd \$HOME/Leorna/leorna-client; git push" \
    "cd \${HOME}/Leorna/leorna-client && git push" "cd $lc && git push" "cd ../Leorna/leorna-client && git push" \
    "git -C ~/Leorna/leorna-client push origin feat/x" "git -C $lc push" \
    "git push git@github-leorna:LeornaAI/leorna-client.git feat/x" "git push github-leorna:LeornaAI/x.git main" \
    "git push https://github.com/LeornaAI/leorna-control-plane.git feat/x"; do
    expect ask "$re" "$c" || return 1
  done
  expect ask "$re" "git push git@github-leorna:LeornaAI/leorna-client.git feat/x" "$H/work" agent-6 || return 1
  for c in "git push" "git push origin main" "git push https://github.com/Just-In-N-Out/x.git main"; do
    expect none '' "$c" "$H/code/site" || return 1
  done
  mkdir -p "$H/Leorna-old/x"; expect none '' "git push" "$H/Leorna-old/x" || return 1
  # a cd inside ( … ) ends with the subshell; a cd inside { …; } does not
  expect ask "$re" "(cd $H/code/site && git status); git push" "$lc" || return 1
  expect ask "$re" "( (cd $H/code/site) ; git status ) && git push origin feat/x" "$lc" || return 1
  expect none '' "(cd ~/Leorna/leorna-client && git fetch) && git push origin main" "$H/code/site" || return 1
  expect ask "$re" "{ cd ~/Leorna/leorna-client; }; git push" "$H/code/site" || return 1
  # ~/Leorna may be a link to the real folder: its logical and physical paths are both Leorna
  local h0=$H; H="$S/home2"; mkdir -p "$H/work" "$S/data/Leorna/lc"; ln -s "$S/data/Leorna" "$H/Leorna"
  expect ask "$re" "git push" "$H/Leorna/lc" || return 1
  expect ask "$re" "git push" "$S/data/Leorna/lc" || return 1
  expect ask "$re" "git -C ~/Leorna/lc push origin feat/x" || return 1
  expect none '' "git push" "$S/data" || return 1
  H=$h0
  for c in "git fetch" "git status" "git log -1" "git pull --ff-only" "git -C ~/Leorna/leorna-client fetch"; do
    expect none '' "$c" "$lc" || return 1
  done
  done_ok
}

ac7_guard_parses_shell_forms() {
  local c j nv='--no-verify'
  need "$GG" || return 1
  newroot; mkdir -p "$S/nopy"
  for c in "echo hi; git commit $nv -m x" "true && git commit $nv -m x" "false || git commit $nv -m x" \
    "git commit $nv -m x | cat" "echo a | git commit $nv -F -" $'echo a\ngit commit '"$nv"' -m x' \
    $'cd /x \\\n && git commit '"$nv" "bash -c 'git commit $nv -m x'" "sh -c \"git commit $nv -m x\"" \
    "zsh -lc 'cd /x && git commit $nv -m x'" "/bin/bash -ec 'git push $nv'" "eval \"git commit $nv -m x\"" \
    "eval git commit $nv -m x" "bash -c \"sh -c 'git commit $nv -m x'\"" "env FOO=1 git commit $nv -m x" \
    "command git commit $nv -m x" "time git commit $nv -m x" "nohup git push $nv &" "exec git commit $nv" \
    "timeout 60 git push $nv" "/usr/bin/git commit $nv -m x" "(cd /x && git commit $nv -m x)" \
    "echo \$(git commit $nv -m x)" "if true; then git commit $nv -m x; fi" "git commit $nv -m \"unterminated" \
    "echo it's here; git commit $nv -m x" "git commit -m 'a#b' $nv" "echo hi # a comment"$'\n'"git commit $nv" \
    "bash -c \$'git commit $nv -m x'" "eval \$'git push \\x2d-no-verify'" "echo \$'it\\'s'; git commit $nv" \
    "echo \"\$(echo \$'a\\')'; git push $nv)\"" "echo \$\$'\\'; git push $nv #'" \
    $'cat <<\'EOF\' >notes.txt\nit\'s a note\nEOF\ngit commit '"$nv" "git commit $nv -m x 2>&1 >/dev/null" \
    $'cat <<\'EOF\' >n.txt\nit\'s\nEOF\ngit commit '"$nv"$' -m x\necho it\'s done' \
    $'echo hi # don\'t worry\ngit commit '"$nv"$' -m x\necho it\'s done' "git commit -m a#b $nv"; do
    expect deny 'skip the git hooks' "$c" || return 1
  done
  # a heredoc body is a script only when a shell (or eval) reads it; every other heredoc body is data
  for c in $'bash <<\'EOF\'\ngit commit '"$nv"$' -m x\nEOF' $'sh -s <<EOF\necho hi\ngit push '"$nv"$'\nEOF' \
    $'env FOO=1 bash <<\'EOF\'\ncd /x && git commit '"$nv"$'\nEOF' $'timeout 60 /bin/bash <<-\'EOF\'\n\tgit commit '"$nv"$'\n\tEOF' \
    $'cat <<\'EOF\' | bash\ngit commit '"$nv"$' -m x\nEOF' $'cat <<\'A\' >a.txt; bash <<\'B\'\nnot a command\nA\ngit push '"$nv"$'\nB'; do
    expect deny 'skip the git hooks' "$c" || return 1
  done
  # a script reaches a shell (or source) through a pipe from echo/printf, a here-string or source /dev/stdin too
  for c in "echo 'git commit $nv -m x' | bash" "bash <<< 'git commit $nv -m x'" \
    $'source /dev/stdin <<\'X\'\ngit commit '"$nv"$' -m x\nX' "printf 'git push $nv\\n' | sh" \
    "printf '%s\\n' 'cd /x' 'git push $nv' | bash" "echo -e 'git push \\x2d-no-verify' | /bin/bash -s" \
    "command echo \"git commit $nv\" |& env FOO=1 bash" ". /dev/stdin <<< \"git push $nv\"" \
    $'cat <<\'X\' | source /dev/stdin\ngit push '"$nv"$'\nX' "bash -s <<<\"\$(echo x); git commit $nv\"" \
    "printf 'git commit %s -m x\\n' $nv | bash" "zsh <<< \$'git push $nv'" $'cat <<< \'EOF\'\ngit commit '"$nv"$'\nEOF' \
    "echo 'git push $nv' | bash -s arg1" "bash -s -- x <<< 'git push $nv'" "echo 'git push $nv' | bash --norc"; do
    expect deny 'skip the git hooks' "$c" || return 1
  done
  for c in "cat <<< 'git push $nv'" "echo 'git commit $nv' > notes.md" "echo 'git commit $nv' | cat" \
    "grep -c x <<< 'git push $nv'" "echo 'git push $nv' | tee notes.md" "printf 'git push $nv\\n' >> notes.md" \
    "source ./env.sh <<< 'git push $nv'" "printf -v line 'git push $nv'; echo ok | bash" "echo 'git push $nv' > f; bash f" \
    "printf '%s\\0' 'git push $nv' | bash ./decide.sh" "echo 'git push $nv' | bash -c 'cat > f'" "bash x.sh <<< 'git push $nv'" \
    $'bash -c \'cat > f\' <<\'EOF\'\ngit push '"$nv"$'\nEOF' $'bash ./decide.sh <<\'EOF\'\ngit push '"$nv"$'\nEOF' \
    "echo 'git push $nv' | bash --rcfile x.rc ./decide.sh"; do
    expect none '' "$c" || return 1
  done
  mkdir -p "$H/Leorna/x"
  for c in $'cat >> brief.md <<\'EOF\'\n## Addendum\n- The builder\'s first task: fetch main over HTTPS (`git -c credential.helper= -c \'credential.helper=!gh auth git-credential\' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`), then check it.\nEOF' \
    $'python3 - <<\'EOF\'\np = "t.test.sh"\ns = open(p).read().replace("git commit -n -m x", "git commit '"$nv"$' -m x")\nopen(p, "w").write(s)\nEOF' \
    $'git commit -F - <<\'MSG\'\ndocs: off switch\n\ngit config --global --unset core.hooksPath\nMSG' \
    $'cat > notes.md <<\'EOF2\'\nOff switch, in a terminal:\n    git config --global --unset core.hooksPath\nEOF2'; do
    expect none '' "$c" || return 1
  done
  expect none '' $'cat > .claude/settings.json <<\'EOF\'\n{"permissions": {"deny": ["Bash(git push --force:*)", "Bash(git push -f:*)"]}}\nEOF' "$H/Leorna/x" || return 1
  # command substitution runs its body: $(…) and `…`, unquoted or inside double quotes, also in a data heredoc
  # whose delimiter is unquoted; inside single quotes, an escaped \$, or a quoted heredoc it is text
  for c in "echo \"\$(git push $nv)\"" "out=\"\$(git commit $nv -m x)\"" "echo \"\`git push $nv\`\"" \
    "echo \`git commit $nv -m x\`" "x=\`git push $nv\`" "git commit -m \"\$(git commit $nv -m y)\"" \
    "git commit -m \"fix: \$(echo x; git push $nv)\" -q" $'cat <<EOF\nlog: $(git push '"$nv"$')\nEOF' \
    "echo \"a \$(echo \"b \$(git push $nv)\")\""; do
    expect deny 'skip the git hooks' "$c" || return 1
  done
  for c in "echo '\$(git push $nv)'" "echo \"\\\$(git push $nv)\"" $'cat <<\'EOF\'\nlog: $(git push '"$nv"$')\nEOF' \
    $'git commit -m "$(cat <<\'EOF\'\nfix(guard): deny git push '"$nv"$' (it\'s a bypass)\nEOF\n)" -q'; do
    expect none '' "$c" || return 1
  done
  expect ask 'Leorna push' "cd ~/Leorna/x && echo \"\$(git push origin feat/x)\"" || return 1
  # a git command only inside a quoted message, a heredoc body or a comment is not a git command
  for c in "git commit -m 'run git commit $nv later'" "echo 'git push $nv'" "echo hi # git commit $nv" \
    "echo \$'git push $nv'" "echo \$'a\\'b # git push $nv'" "echo \$\"git push $nv\"" \
    "git commit -m \"\$(cat <<'EOF'"$'\nfix: don\'t skip hooks\n\nCo-Authored-By: someone\nEOF\n)"' \
    "git config user.email 2>/dev/null || echo none"; do
    expect none '' "$c" || return 1
  done
  # not a Bash call, bad input, no git at all: exit 0, no output
  j=$(jq -nc '{hook_event_name: "PreToolUse", tool_name: "Write", cwd: "/x", tool_input: {command: "git commit --no-verify", file_path: "/x/git"}}')
  hook "$GG" "$j"; check none '' "a Write call naming git" || return 1
  for j in 'not json at all git' '' '{"tool_name": "Bash", "tool_input": "git push --no-verify"}' '[1, "git"]' \
    '{"tool_name": "Bash", "tool_input": {"command": 42}, "x": "git"}'; do
    hook "$GG" "$j"; check none '' "bad input [$j]" || return 1
  done
  for c in "ls -la" "echo high through" "npm test" "python3 -c 'print(1)'" "cat .gitignore"; do
    expect none '' "$c" || return 1
  done
  # no python3 on PATH: a git command passes with a visible systemMessage, anything else with no output
  j=$(jq -nc --arg cwd "$H/work" '{hook_event_name: "PreToolUse", tool_name: "Bash", cwd: $cwd, tool_input: {command: "git commit --no-verify -m x"}}')
  out=$(printf '%s' "$j" | HOME="$H" PATH="$S/nopy" "$BASH" "$GG" 2>&1); rc=$?
  [ "$rc" = 0 ] && [ "$(jq -s 'length' <<<"$out" 2>/dev/null)" = 1 ] \
    && jq -e 'keys == ["systemMessage"] and (.systemMessage | test("python3 not found"))' <<<"$out" >/dev/null \
    || fail "no python3: want only a systemMessage, got rc=$rc out=$out" || return 1
  echo "# no python3: $out"
  j=$(jq -nc '{hook_event_name: "PreToolUse", tool_name: "Bash", cwd: "/x", tool_input: {command: "ls -la"}}')
  out=$(printf '%s' "$j" | HOME="$H" PATH="$S/nopy" "$BASH" "$GG" 2>&1); rc=$?
  [ "$rc" = 0 ] && [ -z "$out" ] || fail "no python3, no git: want no output, got rc=$rc out=$out" || return 1
  # only the command counts: a description or a folder naming git doesn't wake the guard (jq is there, as for
  # every hook; with no jq either, the raw JSON is read and a git command still gets the warning)
  mkdir -p "$S/nopy-jq"; ln -s "$(command -v jq)" "$S/nopy-jq/jq"
  j=$(jq -nc '{hook_event_name: "PreToolUse", tool_name: "Bash", cwd: "/x/github/gh-tools", tool_input: {command: "ls -la", description: "list the git folder"}}')
  out=$(printf '%s' "$j" | HOME="$H" PATH="$S/nopy-jq" "$BASH" "$GG" 2>&1); rc=$?
  [ "$rc" = 0 ] && [ -z "$out" ] || fail "no python3, git only in the description and cwd: want no output, got rc=$rc out=$out" || return 1
  j=$(jq -nc '{hook_event_name: "PreToolUse", tool_name: "Bash", cwd: "/x", tool_input: {command: "git commit --no-verify -m x"}}')
  out=$(printf '%s' "$j" | HOME="$H" PATH="$S/nopy-jq" "$BASH" "$GG" 2>&1); rc=$?
  [ "$rc" = 0 ] && jq -e 'keys == ["systemMessage"] and (.systemMessage | test("python3 not found"))' <<<"$out" >/dev/null \
    || fail "no python3 (jq there): want only a systemMessage, got rc=$rc out=$out" || return 1
  echo "# no python3: only the command is read; a git command warns"
  # a python3 that fails (macOS's /usr/bin/python3 stub with no developer tools exits 1): the same visible warning
  mkdir -p "$S/badpy"; ln -s "$(command -v jq)" "$S/badpy/jq"
  printf '#!/bin/sh\necho "xcode-select: note: No developer tools were found, requesting install." >&2\nexit 1\n' >"$S/badpy/python3"
  chmod +x "$S/badpy/python3"
  out=$(printf '%s' "$j" | HOME="$H" PATH="$S/badpy" "$BASH" "$GG" 2>/dev/null); rc=$?
  [ "$rc" = 0 ] && [ "$(jq -s 'length' <<<"$out" 2>/dev/null)" = 1 ] \
    && jq -e 'keys == ["systemMessage"] and (.systemMessage | test("python3 failed"))' <<<"$out" >/dev/null \
    || fail "python3 exits 1: want only a systemMessage, got rc=$rc out=$out" || return 1
  echo "# python3 fails: $out"
  done_ok
}

ac8_precommit_blocks_claude_md_except_setup_repo() {
  local r f
  need "$GHOOKS/githook.sh" && need "$GHOOKS/pre-commit" || return 1
  newroot
  for r in "$H/code/personal" "$H/Leorna/client"; do
    gitrepo "$r" || fail "repo setup" || return 1
    for f in CLAUDE.md docs/CLAUDE.md claude.md; do
      mkdir -p "$(dirname "$r/$f")"; echo "# notes" >"$r/$f"; ing git -C "$r" add -- "$f"
      commit_in "$r" -m "add $f"; refused pre-commit "$f.*\.git/info/exclude" "$r: staged $f" || return 1
      ing git -C "$r" rm -q --cached -- "$f"; rm -f "$r/$f"
    done
    [ "$(ing git -C "$r" rev-list --count HEAD)" = 1 ] || fail "$r: a refused commit landed" || return 1
    echo x >"$r/CLAUDE.md"; ing git -C "$r" add CLAUDE.md; nohooks -C "$r" commit -q -m "tracked (fixture)"
    ing git -C "$r" rm -q CLAUDE.md
    commit_in "$r" -m "remove CLAUDE.md"; passed "$r: deleting a tracked CLAUDE.md" || return 1
    for f in vendor/github.com/x/CLAUDE.md node_modules/x/CLAUDE.md; do
      mkdir -p "$(dirname "$r/$f")"; echo x >"$r/$f"; ing git -C "$r" add -f -- "$f"
      commit_in "$r" -m "vendored $f"; passed "$r: $f" || return 1
    done
  done
  # a conflicted merge, cherry-pick or revert that brings in the other side's tracked CLAUDE.md, unchanged, concludes
  # (as the same merge without a conflict does); a CLAUDE.md this side changed is still refused
  r="$H/code/merge"; gitrepo "$r" || return 1
  nohooks -C "$r" checkout -q -b up && echo theirs >"$r/CLAUDE.md" && echo up >"$r/a.txt" && ing git -C "$r" add CLAUDE.md a.txt \
    && nohooks -C "$r" commit -q -m "up: a tracked CLAUDE.md (fixture)" && nohooks -C "$r" checkout -q main && echo main >"$r/a.txt" \
    && ing git -C "$r" add a.txt && nohooks -C "$r" commit -q -m main || fail "merge fixture" || return 1
  ing git -C "$r" merge -q up >/dev/null 2>&1; echo resolved >"$r/a.txt"; ing git -C "$r" add a.txt
  [ -f "$r/.git/MERGE_HEAD" ] || fail "the merge fixture did not stop on a conflict" || return 1
  echo mine >"$r/CLAUDE.md"; ing git -C "$r" add CLAUDE.md
  commit_in "$r" --no-edit; refused pre-commit 'CLAUDE\.md' "conflicted merge, CLAUDE.md changed on this side" || return 1
  echo theirs >"$r/CLAUDE.md"; ing git -C "$r" add CLAUDE.md
  commit_in "$r" --no-edit; passed "conflicted merge bringing in the other side's CLAUDE.md" || return 1
  r="$H/code/pick"; gitrepo "$r" || return 1
  nohooks -C "$r" checkout -q -b pk && mkdir -p "$r/docs" && echo theirs >"$r/docs/CLAUDE.md" && echo pk >"$r/b.txt" \
    && ing git -C "$r" add docs b.txt && nohooks -C "$r" commit -q -m "pk (fixture)" && nohooks -C "$r" checkout -q main \
    && echo main >"$r/b.txt" && ing git -C "$r" add b.txt && nohooks -C "$r" commit -q -m main || fail "pick fixture" || return 1
  ing git -C "$r" cherry-pick pk >/dev/null 2>&1; echo resolved >"$r/b.txt"; ing git -C "$r" add b.txt
  [ -f "$r/.git/CHERRY_PICK_HEAD" ] || fail "the cherry-pick fixture did not stop on a conflict" || return 1
  commit_in "$r" --no-edit; passed "conflicted cherry-pick bringing in the picked commit's docs/CLAUDE.md" || return 1
  r="$H/code/revert"; gitrepo "$r" || return 1
  echo old >"$r/CLAUDE.md" && echo c1 >"$r/c.txt" && ing git -C "$r" add CLAUDE.md c.txt && nohooks -C "$r" commit -q -m "r1 (fixture)" \
    && ing git -C "$r" rm -q CLAUDE.md && echo c2 >"$r/c.txt" && ing git -C "$r" add c.txt && nohooks -C "$r" commit -q -m r2 \
    && echo c3 >"$r/c.txt" && ing git -C "$r" add c.txt && nohooks -C "$r" commit -q -m r3 || fail "revert fixture" || return 1
  ing git -C "$r" revert --no-edit HEAD~1 >/dev/null 2>&1; echo resolved >"$r/c.txt"; ing git -C "$r" add c.txt
  [ -f "$r/.git/REVERT_HEAD" ] || fail "the revert fixture did not stop on a conflict" || return 1
  commit_in "$r" --no-edit; passed "conflicted revert bringing back the reverted commit's parent's CLAUDE.md" || return 1
  setuprepo || fail "setup repo" || return 1
  for f in .claude/CLAUDE.md .claude/project-docs/x/CLAUDE.md; do
    mkdir -p "$(dirname "$H/$f")"; echo "# rules" >"$H/$f"; (cd "$H" && ing git --git-dir="$H/.claude-setup.git" add -- "$f")
    out=$(cd "$H" && ing git --git-dir="$H/.claude-setup.git" commit -q -m "sync $f" 2>&1); rc=$?
    passed "setup repo: $f" || return 1
  done
  ing git --git-dir="$H/.claude-setup.git" worktree add -q "$H/wt/setup" -b story main 2>/dev/null \
    || fail "setup repo worktree" || return 1
  for f in .claude/CLAUDE.md .claude/project-docs/x/CLAUDE.md; do
    mkdir -p "$(dirname "$H/wt/setup/$f")"; echo "# story edit" >"$H/wt/setup/$f"; ing git -C "$H/wt/setup" add -- "$f"
    commit_in "$H/wt/setup" -m "story $f"; passed "setup repo worktree: $f" || return 1
  done
  done_ok
}

ac9_precommit_blocks_wrong_email_by_folder() {
  local p l base
  need "$GHOOKS/githook.sh" && need "$GHOOKS/pre-commit" && need "$GHOOKS/pre-merge-commit" || return 1
  newroot; p="$H/code/personal"; l="$H/Leorna/client"
  gitrepo "$p" && gitrepo "$l" && setuprepo || fail "repo setup" || return 1
  # the right email by folder passes
  commit_in "$l" --allow-empty -m ok; passed "Leorna repo, $LEORNA" || return 1
  commit_in "$p" --allow-empty -m ok; passed "personal repo, $PERSONAL" || return 1
  out=$(cd "$H" && ing git --git-dir="$H/.claude-setup.git" commit -q --allow-empty -m ok 2>&1); rc=$?
  passed "setup repo, $PERSONAL" || return 1
  # every way to set the other address is refused, naming the expected one
  check_overrides() { # check_overrides <repo> <expected> <other>
    local r=$1 want=$2 other=$3
    out=$(cd "$r" && ing git -c user.email="$other" commit -q --allow-empty -m x 2>&1); rc=$?
    refused pre-commit "$want" "$r: -c user.email=$other" || return 1
    commit_in "$r" --allow-empty --author="Someone <$other>" -m x; refused pre-commit "$want" "$r: --author" || return 1
    out=$(cd "$r" && GIT_AUTHOR_EMAIL=$other ing git commit -q --allow-empty -m x 2>&1); rc=$?
    refused pre-commit "$want" "$r: GIT_AUTHOR_EMAIL" || return 1
    out=$(cd "$r" && GIT_COMMITTER_EMAIL=$other ing git commit -q --allow-empty -m x 2>&1); rc=$?
    refused pre-commit "$want" "$r: GIT_COMMITTER_EMAIL" || return 1
    ing git -C "$r" config user.email "$other"
    commit_in "$r" --allow-empty -m x; refused pre-commit "$want" "$r: repo-local user.email" || return 1
    ing git -C "$r" config --unset user.email
  }
  check_overrides "$l" "$LEORNA" "$PERSONAL" || return 1
  check_overrides "$p" "$PERSONAL" "$LEORNA" || return 1
  out=$(cd "$H" && ing git --git-dir="$H/.claude-setup.git" -c user.email="$LEORNA" commit -q --allow-empty -m x 2>&1); rc=$?
  refused pre-commit "$PERSONAL" "setup repo: -c user.email=$LEORNA" || return 1
  # a no-conflict merge commit with the wrong email is refused by pre-merge-commit
  nohooks -C "$p" checkout -q -b side && echo s >"$p/side.txt" && ing git -C "$p" add side.txt \
    && nohooks -C "$p" commit -q -m side && nohooks -C "$p" checkout -q main && echo m >"$p/main.txt" \
    && ing git -C "$p" add main.txt && nohooks -C "$p" commit -q -m main || fail "merge fixture" || return 1
  base=$(ing git -C "$p" rev-parse HEAD)
  out=$(cd "$p" && ing git -c user.email="$LEORNA" merge -q --no-ff -m merge side 2>&1 </dev/null); rc=$?
  refused pre-merge-commit "$PERSONAL" "personal repo: merge with -c user.email=$LEORNA" || return 1
  [ "$(ing git -C "$p" rev-parse HEAD)" = "$base" ] || fail "the refused merge made a commit" || return 1
  ing git -C "$p" merge --abort 2>/dev/null; ing git -C "$p" reset -q --hard "$base"
  out=$(cd "$p" && ing git merge -q --no-ff -m merge side 2>&1 </dev/null); rc=$?
  passed "personal repo: merge with $PERSONAL" || return 1
  # ~/Leorna may be a link to the real folder (git's includeIf "gitdir:~/Leorna/" still matches): so does the hook
  rm -rf "$S"; newroot; mkdir -p "$S/data/Leorna"; ln -s "$S/data/Leorna" "$H/Leorna"; l="$H/Leorna/client"
  gitrepo "$l" || fail "linked ~/Leorna repo setup" || return 1
  commit_in "$l" --allow-empty -m ok; passed "linked ~/Leorna repo, $LEORNA" || return 1
  # by its real path git's includeIf misses (it matches the logical path, through $PWD) and git picks the personal
  # email: the repo is still in ~/Leorna, so the hook refuses it
  commit_in "$S/data/Leorna/client" --allow-empty -m x
  refused pre-commit "$LEORNA" "linked ~/Leorna repo by its real path (git picked $PERSONAL)" || return 1
  out=$(cd "$l" && ing git -c user.email="$PERSONAL" commit -q --allow-empty -m x 2>&1); rc=$?
  refused pre-commit "$LEORNA" "linked ~/Leorna repo: -c user.email=$PERSONAL" || return 1
  done_ok
}

ac10_commit_msg_blocks_ai_coauthor() {
  local p n t i=0 names="Claude ANTHROPIC codex OpenAI chatgpt GPT Copilot gemini Hermes"
  need "$GHOOKS/githook.sh" && need "$GHOOKS/commit-msg" || return 1
  newroot; p="$H/code/personal"
  gitrepo "$p" && setuprepo || fail "repo setup" || return 1
  for n in $names; do
    i=$((i + 1))
    case $((i % 3)) in 0) t="Co-authored-by" ;; 1) t="CO-AUTHORED-BY" ;; 2) t="co-authored-by" ;; esac
    commit_in "$p" --allow-empty -m "fix: x" -m "$t: $n <bot@example.test>"
    refused commit-msg 'Co-authored-by' "personal -m: $t: $n" || return 1
  done
  commit_in "$p" --allow-empty -m "fix: x" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
  refused commit-msg 'AI' "personal: the exact Claude Code trailer" || return 1
  commit_in "$p" --allow-empty -m "fix: x" -m "Co-authored-by: GPT-4o <x@example.test>"
  refused commit-msg 'AI' "personal: GPT-4o" || return 1
  # a scissors line typed into the message (git keeps it, and the trailer below it): only git's own verbose cut,
  # followed by its explanation and the diff, ends the message
  commit_in "$p" --allow-empty -m fix -m "# ------------------------ >8 ------------------------" \
    -m "Co-authored-by: Claude <noreply@anthropic.com>"
  refused commit-msg 'AI' "personal: a scissors line given with -m above the trailer" || return 1
  commit_in "$p" --allow-empty -m $'fix\n\n# ------------------------ >8 ------------------------\n# Do not modify or remove the line above.\n# Everything below it will be ignored.\nCo-authored-by: Claude <noreply@anthropic.com>'
  refused commit-msg 'AI' "personal: git's cut text given with -m, with no diff below it" || return 1
  printf 'fix: y\n\nCo-authored-by: Claude <noreply@anthropic.com>\n' >"$S/msg.txt"
  commit_in "$p" --allow-empty -F "$S/msg.txt"; refused commit-msg 'AI' "personal -F" || return 1
  commit_in "$p" --allow-empty -m "fix: z"; passed "personal: plain message" || return 1
  commit_in "$p" --amend --allow-empty -m "fix: z" -m "Co-authored-by: Codex <codex@openai.com>"
  refused commit-msg 'AI' "personal --amend" || return 1
  out=$(cd "$H" && ing git --git-dir="$H/.claude-setup.git" commit -q --allow-empty -m "sync" -m "Co-authored-by: Claude <noreply@anthropic.com>" 2>&1); rc=$?
  refused commit-msg 'AI' "setup repo" || return 1
  # merge message
  nohooks -C "$p" checkout -q -b side && echo s >"$p/side.txt" && ing git -C "$p" add side.txt \
    && nohooks -C "$p" commit -q -m side && nohooks -C "$p" checkout -q main || fail "merge fixture" || return 1
  out=$(cd "$p" && ing git merge -q --no-ff -m "merge side" -m "Co-authored-by: Claude <noreply@anthropic.com>" side 2>&1 </dev/null); rc=$?
  refused commit-msg 'AI' "personal: merge message" || return 1
  ing git -C "$p" merge --abort 2>/dev/null; ing git -C "$p" reset -q --hard main
  # humans, the word Claude in a body, and a verbose diff showing a trailer line all pass
  commit_in "$p" --allow-empty -m "fix: pair" -m "Co-authored-by: Jane Doe <jane@example.test>"
  passed "a human co-author" || return 1
  commit_in "$p" --allow-empty -m "docs: how Claude and Codex share hooks" -m "Claude reads CLAUDE.md; GPT does not."
  passed "the word Claude in the subject and body" || return 1
  commit_in "$p" --allow-empty -m "fix: x" -m "Co-authored-by: Amy Mcclaude <amy@example.test>"
  passed "a human whose name ends in an AI's name" || return 1
  commit_in "$p" --allow-empty -m "fix: x" -m "Co-authored-by: Claudette Smith <cs@example.test>"
  passed "a human whose name starts with an AI's name" || return 1
  printf 'a\nCo-authored-by: Claude <noreply@anthropic.com>\nb\n' >"$p/doc.txt"; ing git -C "$p" add doc.txt
  nohooks -C "$p" commit -q -m "doc (fixture)"
  printf 'a\nCo-authored-by: Claude <noreply@anthropic.com>\nb changed\n' >"$p/doc.txt"; ing git -C "$p" add doc.txt
  out=$(cd "$p" && GIT_EDITOR=true ing git commit -q -v -e -m "docs: edit" 2>&1 </dev/null); rc=$?
  passed "commit -v: a trailer line inside the diff below the scissors line" || return 1
  out=$(cd "$H" && ing git --git-dir="$H/.claude-setup.git" commit -q --allow-empty -m "sync" -m "Co-authored-by: Jane <j@example.test>" 2>&1); rc=$?
  passed "setup repo: a human co-author" || return 1
  done_ok
}

ac11_githooks_chain_repo_hooks() {
  local p w f mode n=0 log
  need "$GHOOKS/githook.sh" || return 1
  for f in $WRAPPERS; do need "$GHOOKS/$f" || return 1; done
  # the 16 wrappers: identical, and every githooks file is mode 100755 in git
  for f in $WRAPPERS; do
    cmp -s "$GHOOKS/$f" "$GHOOKS/pre-commit" || fail "$f differs from the pre-commit wrapper" || return 1
  done
  grep -q 'githook\.sh' "$GHOOKS/pre-commit" || fail "the wrapper does not call githook.sh" || return 1
  while read -r mode _ _ f; do
    n=$((n + 1)); [ "$mode" = 100755 ] || fail "$f is mode $mode in git, not 100755" || return 1
  done < <(srcgit ls-files -s -- .claude/githooks)
  [ "$n" = 17 ] || fail "git tracks $n files in .claude/githooks, want 17 (githook.sh + 16 wrappers)" || return 1
  echo "# 17 githooks files, all 100755; wrappers identical"
  newroot; p="$H/code/personal"; log="$S/own.log"
  gitrepo "$p" || fail "repo setup" || return 1
  ownhook() { # ownhook <repo git common dir> <name> <exit code> [extra shell]: an own hook that logs its args
    printf '#!/bin/sh\necho "own %s args: $*" >>"%s"\n%s\nexit %s\n' "$2" "$log" "${4:-}" "$3" >"$1/hooks/$2"
    chmod +x "$1/hooks/$2"
  }
  ownhook "$p/.git" pre-commit 1
  commit_in "$p" --allow-empty -m blocked
  [ "$rc" != 0 ] && grep -q "own pre-commit" "$log" || fail "own pre-commit (exit 1) did not block (rc=$rc)" || return 1
  echo "# own pre-commit ran and blocked"
  ownhook "$p/.git" pre-commit 0
  ownhook "$p/.git" commit-msg 0 "cat \"\$1\" >>\"$log\""
  commit_in "$p" --allow-empty -m "chain-message-$$"
  [ "$rc" = 0 ] && grep -q "chain-message-$$" "$log" && grep -q "own commit-msg args: .*COMMIT_EDITMSG" "$log" \
    || fail "own commit-msg did not get the message file (rc=$rc)" || return 1
  echo "# own commit-msg got the message file"
  ownhook "$p/.git" commit-msg 1
  commit_in "$p" --allow-empty -m "blocked by own commit-msg"; [ "$rc" != 0 ] || fail "own commit-msg exit 1 did not block" || return 1
  rm "$p/.git/hooks/commit-msg"
  ing git init -q --bare -b main "$S/remote.git"
  ownhook "$p/.git" pre-push 1 "cat >>\"$log\""
  out=$(ing git -C "$p" push -q "$S/remote.git" main 2>&1); rc=$?
  [ "$rc" != 0 ] && grep -q "own pre-push args: $S/remote.git $S/remote.git" "$log" \
    && grep -qE "^refs/heads/main [0-9a-f]{40} refs/heads/main 0{40}$" "$log" \
    || fail "own pre-push did not get args and ref lines, or did not block (rc=$rc out=$out)" || return 1
  [ -z "$(ing git -C "$S/remote.git" rev-parse -q --verify refs/heads/main)" ] || fail "the blocked push landed" || return 1
  echo "# own pre-push read the ref lines on stdin and blocked"
  ownhook "$p/.git" post-checkout 0
  ing git -C "$p" checkout -q -b other 2>/dev/null
  grep -qE "own post-checkout args: [0-9a-f]{40} [0-9a-f]{40} 1" "$log" || fail "own post-checkout did not run" || return 1
  echo "# own post-checkout ran"
  # a linked worktree runs the common dir's hooks
  w="$H/code/personal-wt"
  ing git -C "$p" worktree add -q "$w" -b wtb 2>/dev/null || fail "worktree add" || return 1
  ownhook "$p/.git" pre-commit 1
  : >"$log"; commit_in "$w" --allow-empty -m blocked
  [ "$rc" != 0 ] && grep -q "own pre-commit" "$log" || fail "worktree: own pre-commit did not run or block" || return 1
  echo "# linked worktree: the common dir's pre-commit ran"
  # missing or non-executable: skipped
  chmod -x "$p/.git/hooks/pre-commit"; : >"$log"
  commit_in "$p" --allow-empty -m "non-executable own hook"
  [ "$rc" = 0 ] && ! grep -q "own pre-commit" "$log" || fail "a non-executable own hook ran or blocked (rc=$rc)" || return 1
  rm "$p/.git/hooks/pre-commit"
  commit_in "$p" --allow-empty -m "no own hook"; passed "no own hook" || return 1
  # push-to-checkout replaces git's own updateInstead update, so with no own hook it does git's default:
  # a clean target's work tree moves to the pushed tip; a dirty one refuses the push and keeps its files
  local t="$H/code/target" c="$H/code/clone" tip
  gitrepo "$t" && ing git -C "$t" config receive.denyCurrentBranch updateInstead && ing git clone -q "$t" "$c" \
    || fail "push-to-checkout fixture" || return 1
  echo v2 >"$c/seed.txt"; commit_in "$c" -am v2; passed "clone: v2" || return 1
  out=$(ing git -C "$c" push -q origin main 2>&1); rc=$?; tip=$(ing git -C "$c" rev-parse HEAD)
  [ "$rc" = 0 ] && [ "$(ing git -C "$t" rev-parse HEAD)" = "$tip" ] && [ "$(cat "$t/seed.txt")" = v2 ] \
    && [ -z "$(ing git -C "$t" status --porcelain)" ] \
    || fail "updateInstead push: rc=$rc target HEAD/work tree not the pushed tip, or not clean: seed.txt=[$(cat "$t/seed.txt")] status=[$(ing git -C "$t" status --porcelain)] out=$out" || return 1
  echo "# push-to-checkout, no own hook: the target's work tree is the pushed tip and clean"
  echo local-edit >"$t/seed.txt"; echo v3 >"$c/seed.txt"; commit_in "$c" -am v3; passed "clone: v3" || return 1
  out=$(ing git -C "$c" push -q origin main 2>&1); rc=$?
  [ "$rc" != 0 ] && [ "$(ing git -C "$t" rev-parse HEAD)" = "$tip" ] && [ "$(cat "$t/seed.txt")" = local-edit ] \
    || fail "updateInstead push into a dirty work tree: rc=$rc, want refused with the edit kept (out: $out)" || return 1
  echo "# push-to-checkout, no own hook: a dirty target refuses the push and keeps its edit"
  # a repo whose hooks folder is the githooks folder itself: no self-exec loop
  cp -R "$GHOOKS" "$S/gh-copy"; gitrepo "$H/code/loop" || return 1
  rm -rf "$H/code/loop/.git/hooks"; ln -s "$S/gh-copy" "$H/code/loop/.git/hooks"
  # output to a file, not $(…): a looping hook outlives the git the alarm kills and would hold a pipe open
  (cd "$H/code/loop" && limit 30 env HOME="$H" GIT_CONFIG_GLOBAL="$S/gitconfig" GIT_CONFIG_NOSYSTEM=1 \
    git -c core.hooksPath="$S/gh-copy" commit -q --allow-empty -m loop >"$S/loop.out" 2>&1); rc=$?
  pkill -f "$H/code/loop/" 2>/dev/null; pkill -f "$S/gh-copy/" 2>/dev/null; out=$(cat "$S/loop.out")
  [ "$rc" = 0 ] || fail "hooks folder = githooks folder: rc=$rc (142 = looped until the alarm) out=$out" || return 1
  echo "# hooks folder = githooks folder: no self-exec"
  done_ok
}

ac12_temp_repos_skip_checks_but_chain() {
  local d
  need "$GHOOKS/githook.sh" && need "$GHOOKS/pre-commit" && need "$GHOOKS/commit-msg" || return 1
  newroot
  # env -u TMPDIR: a suite run with TMPDIR inside a fake home (codex-parity's ac7) still gets the system temp folder
  for d in "$(env -u TMPDIR mktemp -d)" "$(mktemp -d /tmp/hg.XXXXXX)"; do
    [ -d "$d" ] || fail "mktemp failed" || return 1
    ing git init -q -b main "$d"; echo x >"$d/CLAUDE.md"; ing git -C "$d" add CLAUDE.md
    out=$(cd "$d" && ing git -c user.email=t@t.test commit -q -m t -m "Co-authored-by: Claude <noreply@anthropic.com>" 2>&1); rc=$?
    [ "$rc" = 0 ] || { rm -rf "$d"; fail "$d: a scratch repo commit was refused: $out"; return 1; }
    echo "# $d: CLAUDE.md, t@t.test and an AI trailer committed"
    printf '#!/bin/sh\necho own-pre-commit-ran >&2\nexit 1\n' >"$d/.git/hooks/pre-commit"; chmod +x "$d/.git/hooks/pre-commit"
    out=$(cd "$d" && ing git commit -q --allow-empty -m t2 2>&1); rc=$?
    rm -rf "$d"
    [ "$rc" != 0 ] && grep -q own-pre-commit-ran <<<"$out" || fail "$d: own pre-commit did not run or block (rc=$rc)" || return 1
    echo "# $d: own pre-commit still ran and blocked"
  done
  done_ok
}

ac13_orchestrator_guard_asks_main_session_code_edit() {
  local f m re='only orchestrates'
  need "$OG" || return 1
  newroot
  ing git init -q "$H/code/app"; mkdir -p "$H/code/app/src" "$H/code/wt" "$H/.hermes/skills/a/b/scripts"
  printf 'gitdir: %s/code/app/.git/worktrees/wt\n' "$H" >"$H/code/wt/.git"   # a linked worktree's .git file
  mkdir -p "$H/.claude/skills"; ln -s "$H/.hermes/skills/a/b" "$H/.claude/skills/b"
  for m in auto default; do
    expect_edit ask "$re" Edit "$H/code/app/src/main.go" "" "$m" || return 1
    expect_edit ask "code/app/new/sub/file.ts" Write "$H/code/app/new/sub/file.ts" "" "$m" || return 1
    expect_edit ask "$re" NotebookEdit "$H/code/app/nb.ipynb" "" "$m" || return 1
    expect_edit ask "$re" Edit "$H/code/wt/src/x.go" "" "$m" || return 1
  done
  expect_edit ask "$re" Edit "$H/code/app/README.md" || return 1
  for f in .claude/hooks/x.sh .claude/githooks/pre-commit .claude/settings.json .claude/settings.local.json \
    .claude/setup/sync.sh .codex/hooks/codex-hooks.sh .codex/hooks.json .codex/agents/pipeline-builder.toml \
    .hermes/scripts/x.sh .hermes/skills/a/b/scripts/x.sh .claude/skills/b/scripts/x.sh; do
    expect_edit ask "$re" Edit "$H/$f" || return 1
  done
  editcall Edit "$H/code/app/src/main.go"
  reason | grep -qF "$H/code/app/src/main.go" || fail "the reason does not name the file: $(reason)" || return 1
  done_ok
}

ac14_orchestrator_guard_quiet_for_subagents_and_own_files() {
  local f j m
  need "$OG" || return 1
  newroot
  ing git init -q "$H/code/app"; mkdir -p "$H/code/app/src" "$H/.hermes/skills/a/b" "$H/.claude/skills"
  ln -s "$H/.hermes/skills/a/b" "$H/.claude/skills/b"
  for f in code/app/src/main.go .claude/hooks/x.sh .claude/settings.json .hermes/scripts/x.sh; do
    expect_edit none '' Edit "$H/$f" agent-14 || return 1
    expect_edit none '' Write "$H/$f" agent-14 default || return 1
  done
  for f in .hermes/plans/claude-setup/harness-guards.md .hermes/plans/claude-setup/briefs/x-builder.md \
    .hermes/plans/claude-setup/evidence/harness-guards/x.png .hermes/plans/dispatch.json \
    .hermes/skills/a/b/SKILL.md .hermes/skills/a/b/references/r.md .claude/skills/b/SKILL.md \
    .claude/projects/p/memory/x.md .claude/projects/p/memory/MEMORY.md code/app/CLAUDE.md code/app/src/CLAUDE.local.md \
    .claude/CLAUDE.md Documents/note.txt .claude/plans/p.md; do
    expect_edit none '' Edit "$H/$f" || return 1
  done
  expect_edit none '' Write "$H/code/app/.scratch/x.sh" "" auto "$H/code/app/.scratch" || return 1
  # an empty .git folder is not a repo (this desktop has one in ~/.claude): git needs a HEAD in it
  mkdir -p "$H/.claude/.git" "$H/notes/.git/objects"
  expect_edit none '' Edit "$H/.claude/plans/q.md" || return 1
  expect_edit none '' Write "$H/notes/todo.txt" || return 1
  expect_edit none '' Write "$S/scratchpad/run.sh" || return 1
  for m in acceptEdits bypassPermissions; do
    expect_edit none '' Edit "$H/code/app/src/main.go" "" "$m" || return 1
  done
  for f in Read Bash Glob MultiEdit; do
    expect_edit none '' "$f" "$H/code/app/src/main.go" || return 1
  done
  for j in 'not json' '' '{"tool_name": "Edit"}' '{"tool_name": "Edit", "tool_input": {"file_path": ""}}' '[]'; do
    hook "$OG" "$j"; check none '' "bad input [$j]" || return 1
  done
  # library skills: ~/.claude/skills/<name> -> ~/.hermes/skills/<cat>/<name> -> ~/.hermes/skills-library/skills/<name>,
  # a git clone: its .md files are skill text the main session saves lessons to; its scripts stay code
  ing git init -q "$H/.hermes/skills-library"; mkdir -p "$H/.hermes/skills-library/skills/lib/references" \
    "$H/.hermes/skills-library/skills/lib/scripts" "$H/.hermes/skills/cat"
  ln -s "$H/.hermes/skills-library/skills/lib" "$H/.hermes/skills/cat/lib"; ln -s "$H/.hermes/skills/cat/lib" "$H/.claude/skills/lib"
  for f in .claude/skills/lib/SKILL.md .claude/skills/lib/references/r.md .hermes/skills/cat/lib/SKILL.md \
    .hermes/skills-library/skills/lib/SKILL.md .hermes/skills-library/README.md; do
    expect_edit none '' Edit "$H/$f" || return 1
  done
  for f in .claude/skills/lib/scripts/x.sh .hermes/skills/cat/lib/scripts/x.sh .hermes/skills-library/skills/lib/scripts/x.sh; do
    expect_edit ask 'only orchestrates' Edit "$H/$f" || return 1   # control: library scripts are code
  done
  # own files stay quiet even inside a work tree: a repo copy in evidence, ~/.hermes or ~/.claude kept in git
  ing git init -q "$H/.hermes/plans/p/evidence/src-copy"
  expect_edit none '' Write "$H/.hermes/plans/p/evidence/src-copy/notes.txt" || return 1
  ing git init -q "$H/.hermes"; ing git init -q "$H/.claude"
  for f in .hermes/plans/p/plan.md .hermes/plans/p/briefs/b-builder.md .hermes/skills/a/b/SKILL.md \
    .claude/projects/p/memory/x.md .claude/CLAUDE.md; do
    expect_edit none '' Edit "$H/$f" || return 1
  done
  expect_edit ask 'only orchestrates' Edit "$H/.hermes/notes.txt" || return 1   # control: that repo is seen
  done_ok
}

ac15_lessons_gate_message_names_enforce() {
  local j r
  need "$LGATE" || return 1
  newroot
  has_text() { # has_text <reason> <what>
    grep -qF -- "$SHAPE" <<<"$1" || fail "$2 does not name $SHAPE" || return 1
    grep -qiE 'enforce.? is .?none' <<<"$1" || fail "$2 does not say enforce is none or a proposal" || return 1
    grep -qiE 'one-line' <<<"$1" && grep -qiE 'Claude Code hook' <<<"$1" && grep -qiE 'git hook' <<<"$1" \
      && grep -qiE 'what it checks' <<<"$1" && grep -qiE 'where it runs' <<<"$1" \
      || fail "$2 does not describe the proposal (kind, what it checks, where it runs)" || return 1
    grep -qF -- "End with this exact last line: $LAST" <<<"$1" || fail "$2 lost its last-line instruction" || return 1
  }
  j=$(jq -nc '{hook_event_name: "SubagentStop", session_id: "s1", agent_id: "a1", agent_type: "general-purpose",
               stop_hook_active: false, last_assistant_message: "Done. All green."}')
  hook "$LGATE" "$j"
  r=$(jq -r 'select(.decision == "block") | .reason' <<<"$out" 2>/dev/null)
  [ -n "$r" ] || fail "SubagentStop without lessons was not blocked: $out" || return 1
  has_text "$r" "the SubagentStop reason" || return 1
  [ "${r: -${#LAST}}" = "$LAST" ] || fail "the SubagentStop reason does not end with: $LAST" || return 1
  echo "# SubagentStop block names the four fields and ends with the MAIN SESSION line"
  j=$(jq -nc '{hook_event_name: "PreToolUse", session_id: "s1", agent_id: "b1", agent_type: "general-purpose",
               tool_name: "SubagentHandback", tool_input: {message: "Done. All green."}}')
  out=$(printf '%s' "$j" | HOME="$H" SUBAGENT_LESSONS_STATE_DIR="$S/lessons" bash "$LGATE"); r=$(reason)
  [ "$(decision)" = deny ] || fail "SubagentHandback without lessons was not denied: $out" || return 1
  has_text "$r" "the SubagentHandback reason" || return 1
  echo "# SubagentHandback deny names the four fields"
  j=$(jq -nc '{hook_event_name: "PreToolUse", session_id: "s1", agent_id: "c1", agent_type: "general-purpose",
               tool_name: "SubagentHandback", tool_input: {message: "Verdict: clean. Done."}}')
  out=$(printf '%s' "$j" | HOME="$H" SUBAGENT_LESSONS_STATE_DIR="$S/lessons" SUBAGENT_AC_STATE_DIR="$S/ac" \
    bash "$SRC/.claude/hooks/subagent-handback-gate.sh"); r=$(reason)
  [ "$(decision)" = deny ] || fail "the handback gate did not deny: $out" || return 1
  has_text "$r" "the handback gate's combined reason" || return 1
  echo "# handback gate's combined deny names the four fields"
  j=$(jq -nc '{hook_event_name: "PostToolUse", session_id: "s1", agent_id: "d1", tool_name: "Bash"}')
  out=$(printf '%s' "$j" | HOME="$H" SKILL_NUDGE_TOOLS=1 SKILL_NUDGE_STATE_DIR="$S/nudge" bash "$SRC/.claude/hooks/skill-review-nudge.sh")
  r=$(jq -r '.hookSpecificOutput.additionalContext // ""' <<<"$out" 2>/dev/null)
  grep -qF -- "$SHAPE" <<<"$r" || fail "the subagent nudge does not name $SHAPE: $r" || return 1
  echo "# subagent nudge names the four fields"
  done_ok
}

ac16_lessons_gate_sends_back_missing_enforce_once() {
  local m j r
  need "$LGATE" || return 1
  newroot
  stopcall() { # stopcall <message> [stop_hook_active]
    j=$(jq -nc --arg m "$1" --argjson a "${2:-false}" '{hook_event_name: "SubagentStop", session_id: "s1", agent_id: "a1",
        agent_type: "general-purpose", stop_hook_active: $a, last_assistant_message: $m}')
    out=$(printf '%s' "$j" | HOME="$H" SUBAGENT_LESSONS_STATE_DIR="$S/lessons" bash "$LGATE"); rc=$?
  }
  handcall() { # handcall <message> <agent_id>
    j=$(jq -nc --arg m "$1" --arg a "$2" '{hook_event_name: "PreToolUse", session_id: "s1", agent_id: $a,
        agent_type: "general-purpose", tool_name: "SubagentHandback", tool_input: {message: $m}}')
    out=$(printf '%s' "$j" | HOME="$H" SUBAGENT_LESSONS_STATE_DIR="$S/lessons" bash "$LGATE"); rc=$?
  }
  enforce_reason() { grep -qi 'no enforce field' <<<"$1" && grep -qF "$LAST" <<<"$1"; }
  local no1 no2 no3 yes1 yes2
  no1=$'status: ready\nskill_lessons: [{skill: leorna, lesson: "x", evidence: "y"}]\n'"$LAST"
  no2=$'{"status": "ready", "skill_lessons": [ {"skill": "leorna", "lesson": "x", "evidence": "y"} ]}'
  no3=$'status: ready\nskill_lessons:\n  [\n    {"skill": "git-commit-rules", "lesson": "x",\n     "evidence": "y"}\n  ]\n'"$LAST"
  yes1=$'status: ready\nskill_lessons: [{skill: leorna, lesson: "x", evidence: "y", enforce: none}]\n'"$LAST"
  yes2=$'{"skill_lessons": [{"skill": "leorna", "lesson": "x", "evidence": "y", "enforce": "git hook: pre-commit refuses x"}]}'
  for m in "$no1" "$no2" "$no3"; do
    stopcall "$m"
    r=$(jq -r 'select(.decision == "block") | .reason' <<<"$out" 2>/dev/null)
    [ "$rc" = 0 ] && enforce_reason "$r" || fail "SubagentStop: lessons without enforce not sent back: [$m] out=$out" || return 1
    stopcall "$m" true
    [ "$rc" = 0 ] && [ -z "$out" ] || fail "SubagentStop with stop_hook_active=true was sent back again: $out" || return 1
  done
  echo "# SubagentStop: three structured forms without enforce sent back once"
  handcall "$no1" h1; [ "$(decision)" = deny ] && enforce_reason "$(reason)" || fail "first handback not denied: $out" || return 1
  handcall "$no1" h1; [ "$rc" = 0 ] && [ -z "$out" ] || fail "second handback from the same agent was denied: $out" || return 1
  handcall "$no2" h2; [ "$(decision)" = deny ] || fail "another agent's first handback not denied: $out" || return 1
  echo "# SubagentHandback: denied once per agent"
  for m in "$yes1" "$yes2" $'Report.\nskill_lessons: []\n'"$LAST" \
    $'Report.\n\n## Skill lessons\n- leorna: x (evidence: y)\n'"$LAST" \
    $'Report.\n\n## Skill lessons\n- skill: leorna\n  lesson: x\n'"$LAST"; do
    stopcall "$m"; [ "$rc" = 0 ] && [ -z "$out" ] || fail "SubagentStop sent back a passing report [$m]: $out" || return 1
    handcall "$m" "h-$RANDOM"; [ "$rc" = 0 ] && [ -z "$out" ] || fail "SubagentHandback denied a passing report [$m]: $out" || return 1
  done
  echo "# with enforce, an empty list, or markdown-only lessons: passes"
  stopcall "Done, no lessons at all."
  r=$(jq -r '.reason // ""' <<<"$out"); grep -qF "$SHAPE" <<<"$r" && ! grep -qi 'no enforce field' <<<"$r" \
    || fail "a report with no lessons did not get the no-lessons reason: $out" || return 1
  echo "# no lessons at all: the no-lessons reason (checked first)"
  done_ok
}

ac17_docs_define_enforce_and_backlog() {
  local f n line hits rc
  need "$SRC/.hermes/plans/claude-setup/enforce-backlog.md" || return 1
  srcgit ls-files --error-unmatch -- .hermes/plans/claude-setup/enforce-backlog.md >/dev/null 2>&1 \
    || fail "enforce-backlog.md is not tracked (it would not sync)" || return 1
  intake_ok() { # intake_ok <line> <what>: the shape, the backlog, the story offer, never builds it
    grep -qF -- "$SHAPE" <<<"$1" || fail "$2: no $SHAPE" || return 1
    grep -qF -- "$BACKLOG" <<<"$1" || fail "$2: no $BACKLOG" || return 1
    grep -qiE 'offer[^.]*story' <<<"$1" || fail "$2: no one-line story offer" || return 1
    grep -qiE 'never builds?' <<<"$1" || fail "$2: does not say the main session never builds the check" || return 1
  }
  line=$(grep -F -- '**Subagents report skill lessons' "$SRC/.claude/CLAUDE.md")
  [ "$(grep -c . <<<"$line")" = 1 ] || fail "CLAUDE.md: the lessons bullet is not one line" || return 1
  intake_ok "$line" "CLAUDE.md lessons bullet" || return 1
  line=$(grep -F -- 'If you learn something reusable' "$SRC/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md")
  [ "$(grep -c . <<<"$line")" = 1 ] || fail "feature-dispatch: the lesson line is not one line" || return 1
  intake_ok "$line" "feature-dispatch lesson line" || return 1
  line=$(grep -F -- '**Skill lessons' "$SRC/.hermes/skills/software-development/leorna/SKILL.md")
  grep -qF -- "$SHAPE" <<<"$line" || fail "leorna SKILL.md lessons line: no $SHAPE" || return 1
  n=0
  for f in "$SRC"/.codex/agents/pipeline-*.toml; do
    n=$((n + 1)); grep -qF -- "$SHAPE" "$f" || fail "$f: no $SHAPE" || return 1
  done
  [ "$n" = 7 ] || fail "want seven pipeline-*.toml, found $n" || return 1
  n=0
  while IFS= read -r f; do
    n=$((n + 1)); grep -qF -- "$SHAPE" "$SRC/$f" || fail "$f: no $SHAPE" || return 1
  done < <(srcgit ls-files -- ':(glob).claude/projects/*/memory/periodic-skill-review.md')
  [ "$n" -ge 1 ] || fail "no periodic-skill-review.md memory copy tracked" || return 1
  echo "# CLAUDE.md, feature-dispatch, leorna, 7 role files and $n memory copies name the four fields"
  # git grep reads the tracked files itself: no GNU-only grep -z pipeline (this also runs on the Mac)
  hits=$(cd "$SRC" && srcgit grep -lF -- "$OLD_SHAPE" -- . ':!.hermes/plans'); rc=$?
  [ "$rc" = 1 ] || fail "synced files outside .hermes/plans/ still hold the old shape (git grep exit $rc): $(echo $hits)" || return 1
  n=$(python3 -c 'import sys; print(len(open(sys.argv[1], encoding="utf-8").read()))' \
    "$SRC/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md")
  [ "$n" -lt 100000 ] || fail "feature-dispatch SKILL.md is $n characters (limit 100,000)" || return 1
  echo "# no old shape outside .hermes/plans/; feature-dispatch SKILL.md is $n characters"
}

ac18_guard_docs_and_manifest() {
  local f sec spec err n mode
  section() { awk -v h="$2" 'index($0, "## ") == 1 { s = (index($0, h) == 1) } s' "$1"; }
  need "$SRC/.claude/CLAUDE.md" || return 1
  sec=$(section "$SRC/.claude/CLAUDE.md" "## Git & GitHub Privacy")
  grep -qF '~/.claude/githooks' <<<"$sec" || fail "CLAUDE.md Privacy section does not name ~/.claude/githooks" || return 1
  sec=$(section "$SRC/.claude/CLAUDE.md" "## Git Commit Authorship")
  grep -qF 'git-guard.sh' <<<"$sec" && grep -qF '~/.claude/githooks' <<<"$sec" \
    || fail "CLAUDE.md Authorship section does not name git-guard.sh and ~/.claude/githooks" || return 1
  grep -F 'push or open a PR only when' <<<"$sec" | grep -qF 'git-guard.sh' \
    || fail "CLAUDE.md: the Leorna push rule does not name git-guard.sh" || return 1
  grep -F '**The main session only orchestrates.**' "$SRC/.claude/CLAUDE.md" | grep -qF 'orchestrator-guard.sh' \
    || fail "CLAUDE.md: 'The main session only orchestrates' does not name orchestrator-guard.sh" || return 1
  echo "# CLAUDE.md names the guards beside their rules"
  f="$SRC/.hermes/skills/software-development/git-commit-rules/SKILL.md"
  grep -qF '~/.claude/githooks' "$f" && grep -qF 'git-guard.sh' "$f" || fail "git-commit-rules does not name the git hooks and git-guard" || return 1
  for f in .claude/setup/desktop.md .claude/setup/mac.md; do
    grep -qF "git config --global core.hooksPath '~/.claude/githooks'" "$SRC/$f" || fail "$f: no one-time command" || return 1
    grep -qF 'git config --global --unset core.hooksPath' "$SRC/$f" || fail "$f: no git hooks off switch" || return 1
    grep -qE 'settings\.json' "$SRC/$f" && grep -qiE 'delete (its|the guard.s) entry' "$SRC/$f" \
      || fail "$f: no Claude Code guard off switch (delete its entry from settings.json)" || return 1
  done
  grep -qF '.claude/githooks/' "$SRC/.github/README.md" || fail "README.md does not list .claude/githooks/" || return 1
  grep -qxF ':(glob).claude/githooks/**' "$SRC/.claude/setup/manifest.txt" || fail "manifest.txt lacks :(glob).claude/githooks/**" || return 1
  echo "# git-commit-rules, desktop.md, mac.md, README.md and manifest.txt updated"
  # Codex reads CLAUDE.md through its header: the tool map says the two guards are Claude Code only
  f="$SRC/.claude/setup/codex/agents-header.md"
  grep -F '`git-guard.sh`' "$f" | grep -F '`orchestrator-guard.sh`' | grep -F 'Claude Code only' | grep -qF '~/.claude/githooks' \
    || fail "agents-header.md: no tool-map row saying git-guard.sh and orchestrator-guard.sh are Claude Code only" || return 1
  # the github skill's push/fetch by URL through gh is for LeornaAI repos only (git-guard denies any other owner)
  f="$SRC/.hermes/skills/software-development/github/references/pr-workflow.md"
  ! grep -qF 'github.com/$OWNER/$REPO.git $BRANCH' "$f" && grep -F 'git-guard' "$f" | grep -qF 'LeornaAI' \
    || fail "github pr-workflow.md: the push/fetch by URL form is not limited to LeornaAI repos with git-guard named" || return 1
  echo "# the Codex header and the github skill's by-URL form name the guards"
  need "$GHOOKS/githook.sh" || return 1
  newroot; mkdir -p "$S/m/.claude"; ing git init -q "$S/m"; cp -Rp "$GHOOKS" "$S/m/.claude/githooks"
  while IFS= read -r spec || [ -n "$spec" ]; do
    case "$spec" in '' | '#'*) continue ;; esac
    if ! err=$(cd "$S/m" && ing git add -A -- "$spec" 2>&1); then
      case "$err" in *"did not match any file"*) ;; *) fail "git add '$spec': $err"; return 1 ;; esac
    fi
  done <"$SRC/.claude/setup/manifest.txt"
  n=0
  while read -r mode _ _ f; do
    n=$((n + 1)); [ "$mode" = 100755 ] || fail "$f staged as $mode" || return 1
  done < <(git -C "$S/m" ls-files -s -- .claude/githooks)
  [ "$n" = 17 ] || fail "the manifest picks up $n githooks files, want 17" || return 1
  echo "# the manifest picks up all 17 githooks files, mode 100755"
  done_ok
}

ac19_existing_suites_pass() {
  local t f
  newroot
  suite() { # suite <label> <script> [env…]: run it, keep the log, require exit 0 and its own pass line
    local label=$1 script=$2; shift 2
    env "$@" bash "$script" >"$S/$label.log" 2>&1 || { tail -15 "$S/$label.log"; fail "$label failed"; return 1; }
    echo "# $label: $(grep -E '^(all passed|passed [0-9]+, failed 0|# passed [0-9]+, failed 0)' "$S/$label.log" | tail -1)"
  }
  for f in setup-sync-pull skill-review-nudge subagent-ac-gate subagent-handback-gate subagent-lessons-gate; do
    suite "$f" "$SRC/.claude/hooks/tests/$f.test.sh" || return 1
  done
  suite sync "$SRC/.claude/setup/sync.test.sh" || return 1
  suite ac-check "$SRC/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.test.sh" || return 1
  suite codex-parity "$SRC/.claude/setup/codex/codex-parity.test.sh" || return 1
  # again with the git hooks active: a copy of the real ~/.gitconfig plus core.hooksPath = the checkout's githooks
  if [ -f "$REAL_HOME/.gitconfig" ]; then cp "$REAL_HOME/.gitconfig" "$S/live-gitconfig"; else : >"$S/live-gitconfig"; fi
  git config -f "$S/live-gitconfig" core.hooksPath "$GHOOKS"
  for f in setup-sync-pull skill-review-nudge subagent-ac-gate subagent-handback-gate subagent-lessons-gate; do
    suite "hooks-on-$f" "$SRC/.claude/hooks/tests/$f.test.sh" GIT_CONFIG_GLOBAL="$S/live-gitconfig" || return 1
  done
  suite hooks-on-ac-check "$SRC/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.test.sh" \
    GIT_CONFIG_GLOBAL="$S/live-gitconfig" || return 1
  suite hooks-on-harness-guards "$HERE/harness-guards.test.sh" GIT_CONFIG_GLOBAL="$S/live-gitconfig" || return 1
  done_ok
}

ac20_settings_register_guards() {
  local base cur strip cmd mode f n=0
  need "$GG" && need "$OG" || return 1
  cur="$SRC/.claude/settings.json"
  jq -e . "$cur" >/dev/null || fail "settings.json is not valid JSON" || return 1
  reg() { # reg <matcher> <command>: registered once, timeout 10
    jq -e --arg m "$1" --arg c "$2" '[.hooks.PreToolUse[] | select(.matcher == $m) | .hooks[]
      | select(.type == "command" and .command == $c and .timeout == 10)] | length == 1' "$cur" >/dev/null
  }
  reg Bash '~/.claude/hooks/git-guard.sh' || fail "git-guard.sh is not registered on PreToolUse Bash (timeout 10)" || return 1
  reg '^(Edit|Write|NotebookEdit)$' '~/.claude/hooks/orchestrator-guard.sh' \
    || fail "orchestrator-guard.sh is not registered on ^(Edit|Write|NotebookEdit)$ (timeout 10)" || return 1
  jq -e '[.hooks.PreToolUse[] | select(.matcher == "SubagentHandback")] as $g
         | ($g | length) == 1 and ($g[0].hooks | length) == 1
           and $g[0].hooks[0].command == "~/.claude/hooks/subagent-handback-gate.sh"' "$cur" >/dev/null \
    || fail "the SubagentHandback group is not alone with its one gate" || return 1
  base=$(srcgit merge-base HEAD main 2>/dev/null || srcgit merge-base HEAD origin/main) || fail "no base commit" || return 1
  strip='del(.hooks.PreToolUse[] | select(any(.hooks[]; .command == "~/.claude/hooks/git-guard.sh"
           or .command == "~/.claude/hooks/orchestrator-guard.sh")))'
  [ "$(jq -S "$strip" "$cur")" = "$(srcgit show "$base:.claude/settings.json" | jq -S "$strip")" ] \
    || fail "settings.json changed more than the two guard groups (base $base)" || return 1
  echo "# settings.json: two guard groups added, everything else equal to base $base"
  while read -r mode _ _ f; do
    n=$((n + 1)); [ "$mode" = 100755 ] || fail "$f is mode $mode in git" || return 1
  done < <(srcgit ls-files -s -- .claude/hooks/git-guard.sh .claude/hooks/orchestrator-guard.sh)
  [ "$n" = 2 ] || fail "git tracks $n of the two guard scripts" || return 1
  newroot; ing git init -q "$H/code/app"
  cmd=$(jq -r '.hooks.PreToolUse[] | select(.matcher == "Bash") | .hooks[] | .command' "$cur" | grep git-guard)
  out=$(jq -nc --arg cwd "$H/work" '{hook_event_name: "PreToolUse", tool_name: "Bash", cwd: $cwd,
        tool_input: {command: "git commit --no-verify -m x"}}' | HOME="$H" "${cmd/#\~/$SRC}"); rc=$?
  check deny 'skip the git hooks' "registered $cmd: git commit --no-verify" || return 1
  cmd=$(jq -r '.hooks.PreToolUse[] | select(.matcher == "^(Edit|Write|NotebookEdit)$") | .hooks[] | .command' "$cur")
  out=$(jq -nc --arg p "$H/code/app/main.go" '{hook_event_name: "PreToolUse", tool_name: "Edit", permission_mode: "auto",
        tool_input: {file_path: $p, old_string: "a", new_string: "b"}}' | HOME="$H" "${cmd/#\~/$SRC}"); rc=$?
  check ask 'only orchestrates' "registered $cmd: main-session repo edit" || return 1
  done_ok
}

ac21_desktop_live_smoke() {
  local v d
  v=$(cd "$REAL_HOME" && env -u GIT_CONFIG_GLOBAL HOME="$REAL_HOME" git config --global --get core.hooksPath)
  echo "# this machine: global core.hooksPath = [$v]"
  [ "$v" = '~/.claude/githooks' ] || fail "live: core.hooksPath is not ~/.claude/githooks (run the one-time command first)" || return 1
  [ -x "$REAL_HOME/.claude/githooks/pre-commit" ] && [ -x "$REAL_HOME/.claude/hooks/git-guard.sh" ] \
    && [ -x "$REAL_HOME/.claude/hooks/orchestrator-guard.sh" ] || fail "live: the guards are not installed under ~/.claude" || return 1
  d="$REAL_HOME/.cache/hg-live/desktop-$$"; mkdir -p "$d"
  (cd "$d" && env -u GIT_CONFIG_GLOBAL HOME="$REAL_HOME" git init -q && echo x >f.txt && env -u GIT_CONFIG_GLOBAL HOME="$REAL_HOME" git add f.txt)
  out=$(cd "$d" && env -u GIT_CONFIG_GLOBAL HOME="$REAL_HOME" git -c user.email=x@example.test commit -q -m t 2>&1); rc=$?
  rm -rf "$d"
  [ "$rc" != 0 ] && grep -q 'githooks (pre-commit)' <<<"$out" || fail "live: a wrong-email terminal commit was not refused: $out" || return 1
  echo "# terminal commit with -c user.email=x@example.test in ~/.cache/hg-live: refused by pre-commit"
  cat <<'STEPS'
# Manual steps for Justin (a new Claude Code session on the desktop):
#  1. Ask Claude: in a scratch repo under ~/.cache/hg-live/, run `git commit --allow-empty --no-verify -m t`
#     -> refused with git-guard's "never skip the git hooks" reason.
#  2. Ask Claude: run `git push --dry-run` in ~/Leorna/leorna-client -> a yes/no prompt naming the Leorna rule. Answer No.
#  3. Ask the main session to edit a file in ~/Documents/FigmaToBricksV2 -> the orchestrator prompt. Answer No.
STEPS
}

ac22_mac_activation_live() {
  local v d f c
  [ "$(uname -s)" = Darwin ] || fail "live: run this on the Mac after sync.sh pull" || return 1
  for f in "$REAL_HOME"/.claude/githooks/*; do [ -x "$f" ] || fail "live: $f is not executable" || return 1; done
  v=$(env -u GIT_CONFIG_GLOBAL HOME="$REAL_HOME" git config --global --get core.hooksPath)
  echo "# global core.hooksPath = [$v]"
  [ "$v" = '~/.claude/githooks' ] || fail "live: run git config --global core.hooksPath '~/.claude/githooks' first" || return 1
  command -v python3 >/dev/null || fail "live: python3 not found (git-guard would only warn)" || return 1
  d="$REAL_HOME/.cache/hg-live/mac-$$"; mkdir -p "$d"
  (cd "$d" && env -u GIT_CONFIG_GLOBAL git init -q && echo x >f.txt && env -u GIT_CONFIG_GLOBAL git add f.txt)
  out=$(cd "$d" && env -u GIT_CONFIG_GLOBAL git -c user.email=x@example.test commit -q -m t 2>&1); rc=$?
  rm -rf "$d"
  [ "$rc" != 0 ] && grep -q 'githooks (pre-commit)' <<<"$out" || fail "live: a wrong-email commit was not refused: $out" || return 1
  echo "# wrong-email commit in ~/.cache/hg-live: refused"
  echo "# Repos with a local core.hooksPath or own .git/hooks (reported, not changed):"
  for d in "$REAL_HOME"/Leorna/* $(awk -F'\t' '!/^#/{print $2}' "$REAL_HOME/.claude/setup/projects.tsv"); do
    [ -d "$d/.git" ] || [ -f "$d/.git" ] || continue
    c=$(git -C "$d" rev-parse --git-common-dir)
    case $c in /*) ;; *) c="$d/$c" ;; esac
    echo "#   $d hooksPath=[$(git -C "$d" config --local --get core.hooksPath)] own=[$(ls "$c/hooks" 2>/dev/null | grep -v '\.sample$' | tr '\n' ' ')]"
  done
  echo "# ~/Leorna (a link is fine: both guards match its logical and physical paths): $(ls -ld "$REAL_HOME/Leorna" 2>&1)"
  echo "# Manual step: in a Claude Code session on the Mac, ask for 'git commit --no-verify -m t' in a scratch repo -> denied."
}

n=0; failed=0
run() {
  local t=$1 out rc
  n=$((n + 1))
  if [ "$(type -t "$t")" != function ]; then echo "not ok $n - $t"; echo "# no such test"; failed=$((failed + 1)); return; fi
  out=$( ( "$t" ) 2>&1 ); rc=$?
  printf '%s\n' "$out" | sed 's/^/#  /'
  if [ $rc -eq 0 ]; then echo "ok $n - $t"; else echo "not ok $n - $t"; failed=$((failed + 1)); fi
}
if [ $# -gt 0 ]; then for t in "$@"; do run "$t"; done; else for t in $OFFLINE; do run "$t"; done; fi
echo "# passed $((n - failed)), failed $failed"
[ "$failed" -eq 0 ]
