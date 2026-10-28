#!/usr/bin/env bash
# Justin's git hooks for every repo: global core.hooksPath = ~/.claude/githooks (one-time per machine:
#   git config --global core.hooksPath '~/.claude/githooks').
# Each other file here is a wrapper: githook.sh <hook name> <git's args>.
#   pre-commit        no staged CLAUDE.md (any folder; vendor/ and node_modules/ ignored; setup repo excepted;
#                     one a conflicted merge, cherry-pick or revert brings in unchanged is not new), then author
#                     and committer email by folder (a conflicted cherry-pick may keep the picked commit's author)
#   pre-merge-commit  author and committer email by folder
#   commit-msg        no Co-authored-by trailer naming an AI
#   git am: applypatch-msg checks the trailer as commit-msg does; pre-applypatch checks CLAUDE.md as pre-commit
#                     does, and the committer email (the patch keeps its author)
# Then it hands over to the repo's own <git common dir>/hooks/<name> when that is executable
# (exec: same args, same stdin, its exit code), because a global hooks path hides the repo's own hooks.
# push-to-checkout with no own hook does git's default updateInstead update itself, because any
# push-to-checkout hook replaces it (as git's push-to-checkout.sample does).
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
# ~/Leorna may be a link: git's includeIf "gitdir:~/Leorna/" matches both its paths, so the hook does too
leorna=$(cd "$HOME/Leorna" 2>/dev/null && pwd -P) || leorna="$home/Leorna"
common=$(cd "$(git rev-parse --git-common-dir 2>/dev/null)" 2>/dev/null && pwd -P) || common=""
top=$(cd "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null && pwd -P) || top=$PWD

stop() { printf 'githooks (%s): %s\n' "$name" "$*" >&2; exit 1; }
scratch() { case "$top/" in /tmp/* | /private/tmp/* | /var/tmp/* | /var/folders/* | /private/var/folders/*) return 0 ;; esac; return 1; }
setup_repo() { [ -n "$common" ] && [ "$common" = "$(cd "$home/.claude-setup.git" 2>/dev/null && pwd -P)" ]; }
email_of() { git var "GIT_$1_IDENT" 2>/dev/null | sed -n 's/.*<\([^>]*\)>.*/\1/p'; }
check_identity() { # check_identity AUTHOR and/or COMMITTER
  local want who got pick picked=""
  case "$common/" in "$home/Leorna/"* | "$leorna/"*) want=$LEORNA_EMAIL ;; *) want=$PERSONAL_EMAIL ;; esac
  # a conflicted cherry-pick, concluded with --continue or commit, keeps the picked commit's (a teammate's) author
  pick=$(git rev-parse -q --verify CHERRY_PICK_HEAD 2>/dev/null) && picked=$(git log -1 --format=%ae "$pick" 2>/dev/null)
  for who in "$@"; do
    got=$(email_of "$who")
    [ "$got" = "$want" ] && continue
    [ "$who" = AUTHOR ] && [ -n "$picked" ] && [ "$got" = "$picked" ] && continue
    stop "$(echo "$who" | tr A-Z a-z) email is '$got'; this folder needs $want (CLAUDE.md, Git Commit Authorship). Don't override it: fix git config, or tell Justin (an amended commit keeps its old author)."
  done
}
# the commits whose files a conflicted merge, cherry-pick or revert brings in (a revert brings back its parent's)
sides() { git rev-parse -q --verify MERGE_HEAD; git rev-parse -q --verify CHERRY_PICK_HEAD; git rev-parse -q --verify 'REVERT_HEAD^'; } 2>/dev/null
from_side() { # from_side <path> <commits>: the staged blob is the one in one of those commits (not a new CLAUDE.md)
  local staged c
  staged=$(git rev-parse -q --verify ":$1" 2>/dev/null) || return 1
  for c in $2; do [ "$(git rev-parse -q --verify "$c:$1" 2>/dev/null)" = "$staged" ] && return 0; done
  return 1
}
check_claude_md() {
  setup_repo && return 0
  local p bad="" incoming
  incoming=$(sides)
  while IFS= read -r -d '' p; do
    case "/$p" in */vendor/* | */node_modules/*) continue ;; esac
    case "${p##*/}" in [Cc][Ll][Aa][Uu][Dd][Ee].[Mm][Dd]) ;; *) continue ;; esac
    [ -n "$incoming" ] && from_side "$p" "$incoming" && continue
    bad="$bad $p"
  done < <(git diff --cached --name-only -z --diff-filter=ACMRT 2>/dev/null)
  [ -z "$bad" ] || stop "CLAUDE.md files are never committed (CLAUDE.md, Git & GitHub Privacy):$bad. Unstage with git restore --staged <path> and list it in .git/info/exclude."
}
check_trailer() {
  # the message as git will keep it: skip # comments, and stop at git's own verbose cut (commit -v): its scissors
  # line, then "# Do not modify or remove the line above.", its other comment lines and the diff. A scissors line
  # typed into the message (-m) is kept by git, and so is anything below it.
  [ -f "${1:-}" ] || return 0
  if awk '{ l[NR] = $0 }
      END {
        for (i = 1; i <= NR; i++) {
          if (l[i] ~ /^# -+ >8 -+$/ && l[i + 1] == "# Do not modify or remove the line above.") {
            j = i + 2
            while (j <= NR && l[j] ~ /^#/) j++
            if (j <= NR && index(l[j], "diff --git ") == 1) exit
          }
          if (l[i] !~ /^#/) print tolower(l[i])
        }
      }' "$1" \
    | grep -qE "^[[:space:]]*co-authored-by:(.*[^[:alpha:]])?($AI_NAMES)([^[:alpha:]]|$)"; then
    stop "no Co-authored-by line naming an AI (CLAUDE.md, Git & GitHub Privacy). Remove that trailer and commit again."
  fi
}

if ! scratch; then
  case $name in
    pre-commit) check_claude_md; check_identity AUTHOR COMMITTER ;;
    pre-merge-commit) check_identity AUTHOR COMMITTER ;;
    commit-msg | applypatch-msg) check_trailer "${1:-}" ;;
    pre-applypatch) check_claude_md; check_identity COMMITTER ;;
  esac
fi
own="$common/hooks/$name"
if [ -n "$common" ] && [ -f "$own" ] && [ -x "$own" ] && [ "$(cd "$common/hooks" && pwd -P)" != "$self" ]; then
  exec "$own" "$@"
fi
if [ "$name" = push-to-checkout ]; then
  git update-index -q --ignore-submodules --refresh || stop "Up-to-date check failed"
  git diff-files --quiet --ignore-submodules -- || stop "Working directory has unstaged changes"
  if git cat-file -e HEAD 2>/dev/null; then head=HEAD; else head=$(git hash-object -t tree --stdin </dev/null); fi
  git diff-index --quiet --cached --ignore-submodules "$head" -- || stop "Working directory has staged changes"
  git read-tree -u -m "${1:-}" || stop "Could not update working tree to new HEAD"
fi
exit 0
