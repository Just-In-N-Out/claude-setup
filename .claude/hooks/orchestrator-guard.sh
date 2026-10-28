#!/usr/bin/env bash
# Orchestrator guard: Claude Code PreToolUse hook on ^(Edit|Write|NotebookEdit)$.
# CLAUDE.md: "The main session only orchestrates." During a bug or story it dispatches agents and never
# writes code itself. This hook makes that a yes/no prompt: when the MAIN session (no agent_id) is about
# to edit code, it asks Justin. Code is a file inside a git work tree (a .git folder or a linked
# worktree's .git file in its folder or any folder above), or a setup code path: ~/.claude/hooks,
# ~/.claude/githooks, ~/.claude/setup, ~/.claude/settings*.json, ~/.codex/hooks*, ~/.codex/agents,
# ~/.hermes/scripts, and non-.md files under ~/.hermes/skills.
# Silent (no output):
#   - subagents (agent_id set): they are the ones who write code;
#   - accept-edits or bypass mode, which only Justin can switch on (Shift+Tab), e.g. for "do it here";
#   - the orchestrator's own files: any CLAUDE.md / CLAUDE.local.md, ~/.hermes/plans/** (plans, briefs,
#     evidence, dispatch.json), ~/.hermes/skills/**/*.md, ~/.claude/projects/*/memory/**, and anything
#     under the session's scratchpad_dir;
#   - anything else (a note in ~/Documents, ~/.claude/plans/*.md).
# Paths are compared physically: the nearest existing folder goes through `cd … && pwd -P`, so a file
# reached through ~/.claude/skills/<name> (a link) is judged where it really lives, in ~/.hermes/skills.
# Writes through Bash (sed -i, tee, heredocs) are not seen: a seatbelt, not a sandbox.
# Any bad input exits 0 silently: this hook must never block a tool call by mistake.
# Off: delete its entry from ~/.claude/settings.json. Tests: tests/harness-guards.test.sh (ac13, ac14, ac20)
set -uo pipefail

input=$(cat) || exit 0
# fields joined by the unit separator: a tab IFS would merge an empty field into the next one
fields=$(jq -r '[.agent_id // "", .tool_name // "", .permission_mode // "",
                 (.tool_input.file_path // .tool_input.notebook_path // ""), .scratchpad_dir // "", .cwd // ""]
                | map(tostring | gsub("[\u001f\n]"; "")) | join("\u001f")' <<<"$input" 2>/dev/null) || exit 0
IFS=$'\x1f' read -r agent tool mode path scratch cwd <<<"$fields"

[[ -z $agent ]] || exit 0
case $tool in Edit | Write | NotebookEdit) ;; *) exit 0 ;; esac
case $mode in acceptEdits | bypassPermissions) exit 0 ;; esac
[[ -n $path ]] || exit 0
path=${path//\\//}
if [[ $path != /* ]]; then
  [[ $cwd == /* ]] || exit 0
  path="$cwd/$path"
fi

resolve() { # resolve <absolute path>: its nearest existing folder made physical (pwd -P), plus the rest
  local p=$1 rest="" d
  while [[ -n $p && ! -d $p ]]; do
    rest="/${p##*/}$rest"
    p=${p%/*}
  done
  d=$(cd "${p:-/}" 2>/dev/null && pwd -P) || d=$p
  [[ $d == / ]] && d=""
  printf '%s%s' "$d" "$rest"
}

home=$(cd "$HOME" 2>/dev/null && pwd -P) || exit 0
real=$(resolve "$path")
if [[ -L $real ]]; then # the file itself is a link: judge its target
  target=$(readlink "$real") || exit 0
  [[ $target == /* ]] || target="${real%/*}/$target"
  real=$(resolve "$target")
fi

# the orchestrator's own files
case ${real##*/} in CLAUDE.md | CLAUDE.local.md) exit 0 ;; esac
case $real in
  "$home"/.hermes/plans/* | "$home"/.hermes/skills/*.md | "$home"/.claude/projects/*/memory/*) exit 0 ;;
esac
if [[ $scratch == /* ]]; then
  sp=$(resolve "$scratch")
  [[ $real == "$sp" || $real == "$sp"/* ]] && exit 0
fi

# code: inside a git work tree, or a setup code path
code=""
d=${real%/*}
while [[ -n $d ]]; do
  if [[ -e $d/.git ]]; then code=repo; break; fi
  d=${d%/*}
done
case $real in
  "$home"/.claude/hooks/* | "$home"/.claude/githooks/* | "$home"/.claude/setup/* | \
    "$home"/.claude/settings.json | "$home"/.claude/settings.local.json | \
    "$home"/.codex/hooks/* | "$home"/.codex/hooks.json | "$home"/.codex/agents/* | \
    "$home"/.hermes/scripts/* | "$home"/.hermes/skills/*) code=setup ;;
esac
[[ -n $code ]] || exit 0

jq -nc --arg p "$path" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask",
  permissionDecisionReason: ("Orchestrator guard: the main session is about to edit " + $p + ", which is code. During a bug or story the main session only orchestrates (CLAUDE.md); approve only for a one-line edit or when you said \"do it here\".")}}'
exit 0
