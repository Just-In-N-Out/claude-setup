#!/usr/bin/env bash
# Justin's git hooks for every repo: global core.hooksPath = ~/.claude/githooks (one-time per machine:
#   git config --global core.hooksPath '~/.claude/githooks').
# Each other file here is a wrapper: githook.sh <hook name> <git's args>.
#   pre-commit        no staged CLAUDE.md (any folder; vendor/ and node_modules/ ignored; setup repo excepted),
#                     then author and committer email by folder
#   pre-merge-commit  author and committer email by folder
#   commit-msg        no Co-authored-by trailer naming an AI
# Then it hands over to the repo's own <git common dir>/hooks/<name> when that is executable
# (exec: same args, same stdin, its exit code), because a global hooks path hides the repo's own hooks.
# Repos under the system temp folders are scratch (test suites): no checks, hand-over only.
# Leorna is decided by the git common dir (like includeIf "gitdir:~/Leorna/"), so a linked worktree of a
# Leorna repo counts as Leorna wherever it sits, and the setup repo's worktrees share its CLAUDE.md exception.
# Off on one machine: git config --global --unset core.hooksPath (in a terminal; Claude's git-guard denies it).
# macOS bash 3.2 and Ubuntu. Tests: ~/.claude/hooks/tests/harness-guards.test.sh (ac8-ac12)
set -uo pipefail
name=${1:-}; shift || true
LEORNA_EMAIL=justin@leorna.com
PERSONAL_EMAIL=issajustin04@gmail.com
AI_NAMES='claude|anthropic|codex|openai|chatgpt|gpt|copilot|gemini|hermes'
self=$(cd "$(dirname "$0")" && pwd -P)
home=$(cd "$HOME" 2>/dev/null && pwd -P) || home=$HOME
common=$(cd "$(git rev-parse --git-common-dir 2>/dev/null)" 2>/dev/null && pwd -P) || common=""
top=$(cd "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null && pwd -P) || top=$PWD

stop() { printf 'githooks (%s): %s\n' "$name" "$*" >&2; exit 1; }
scratch() { case "$top/" in /tmp/* | /private/tmp/* | /var/tmp/* | /var/folders/* | /private/var/folders/*) return 0 ;; esac; return 1; }
setup_repo() { [ -n "$common" ] && [ "$common" = "$(cd "$home/.claude-setup.git" 2>/dev/null && pwd -P)" ]; }
email_of() { git var "GIT_$1_IDENT" 2>/dev/null | sed -n 's/.*<\([^>]*\)>.*/\1/p'; }
check_identity() {
  local want who got
  case "$common/" in "$home/Leorna/"*) want=$LEORNA_EMAIL ;; *) want=$PERSONAL_EMAIL ;; esac
  for who in AUTHOR COMMITTER; do
    got=$(email_of "$who")
    [ "$got" = "$want" ] || stop "$(echo "$who" | tr A-Z a-z) email is '$got'; this folder needs $want (CLAUDE.md, Git Commit Authorship). Don't override it: fix git config, or tell Justin (an amended commit keeps its old author)."
  done
}
check_claude_md() {
  setup_repo && return 0
  local p bad=""
  while IFS= read -r -d '' p; do
    case "/$p" in */vendor/* | */node_modules/*) continue ;; esac
    case "${p##*/}" in [Cc][Ll][Aa][Uu][Dd][Ee].[Mm][Dd]) bad="$bad $p" ;; esac
  done < <(git diff --cached --name-only -z --diff-filter=ACMRT 2>/dev/null)
  [ -z "$bad" ] || stop "CLAUDE.md files are never committed (CLAUDE.md, Git & GitHub Privacy):$bad. Unstage with git restore --staged <path> and list it in .git/info/exclude."
}
check_trailer() {
  # the message as git will keep it: stop at the scissors line (commit -v puts the diff below it), skip # comments
  [ -f "${1:-}" ] || return 0
  if awk '/^# -+ >8 -+$/ { exit } /^#/ { next } { print tolower($0) }' "$1" \
    | grep -qE "^[[:space:]]*co-authored-by:(.*[^[:alpha:]])?($AI_NAMES)([^[:alpha:]]|$)"; then
    stop "no Co-authored-by line naming an AI (CLAUDE.md, Git & GitHub Privacy). Remove that trailer and commit again."
  fi
}

if ! scratch; then
  case $name in
    pre-commit) check_claude_md; check_identity ;;
    pre-merge-commit) check_identity ;;
    commit-msg) check_trailer "${1:-}" ;;
  esac
fi
own="$common/hooks/$name"
if [ -n "$common" ] && [ -f "$own" ] && [ -x "$own" ] && [ "$(cd "$common/hooks" && pwd -P)" != "$self" ]; then
  exec "$own" "$@"
fi
exit 0
