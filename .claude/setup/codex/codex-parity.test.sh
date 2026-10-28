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
# overrides inherited from a Codex or Claude session would point the tests at real files: drop them
unset CODEX_HOME SETUP_SYNC_SCRIPT SETUP_SYNC_GIT_DIR SETUP_SYNC_URL SETUP_SYNC_PUSH_STATE SETUP_SYNC_PUSH_TRIES \
  SETUP_SYNC_PUSH_WAIT CODEX_HOOKS_CLAUDE_DIR CODEX_HOOKS_BUILD CODEX_HOOKS_RULES CODEX_HOOKS_STATE_DIR CODEX_BUILD_RULES \
  SUBAGENT_AC_STATE_DIR SUBAGENT_LESSONS_STATE_DIR SKILL_NUDGE_STATE_DIR HERMES_HOME
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
  # no real projects: sync.sh would copy their CLAUDE.md files into the real project folders
  printf '# name\tmac_path\tdesktop_path\tmemory\tclaude_md\n' >"$H/.claude/setup/projects.tsv"
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

fileid() { python3 -c 'import os,sys; s=os.stat(sys.argv[1]); print(s.st_ino, s.st_mtime_ns)' "$1"; }
user_block() { # user_block <prompt-input json>: the AGENTS.md user-instructions block Codex would send
  jq -r '.[] | select(.role == "user") | .content[]? | .text // empty | select(startswith("# AGENTS.md instructions"))' "$1"
}
prompt_input() { # prompt_input <out json> [cwd]: codex debug prompt-input in the fake home (offline)
  mkdir -p "${2:-$H/work}"
  (cd "${2:-$H/work}" && inhome codex debug prompt-input >"$1" 2>"$1.err") || { cat "$1.err"; return 1; }
}
done_ok() { rm -rf "$S"; return 0; }   # remove the test folder on success (kept on failure)
schema_ok() { # schema_ok <event> <hook output>: empty, or JSON that Codex's output schema for <event> accepts
  local f
  case $1 in SessionStart) f=session-start ;; SubagentStop) f=subagent-stop ;; PreToolUse) f=pre-tool-use ;;
    PostToolUse) f=post-tool-use ;; UserPromptSubmit) f=user-prompt-submit ;; Stop) f=stop ;; esac
  [ -z "$2" ] && return 0
  python3 - "$FIX/schema/$f.command.output.schema.json" "$2" <<'PY'
import json, sys
schema, out = json.load(open(sys.argv[1])), json.loads(sys.argv[2])
def check(sch, obj, where):
    assert isinstance(obj, dict), f"{where}: not an object"
    props = sch.get("properties", {})
    if sch.get("additionalProperties") is False:
        extra = set(obj) - set(props)
        assert not extra, f"{where}: keys not in the schema: {sorted(extra)}"
    for k in sch.get("required", []): assert k in obj, f"{where}: missing {k}"
    for k, v in obj.items():
        p = props.get(k, {})
        for sub in p.get("allOf", []) + ([p] if "$ref" in p else []):
            d = schema["definitions"][sub["$ref"].split("/")[-1]]
            if d.get("type") == "object": check(d, v, f"{where}.{k}")
            elif "enum" in d: assert v in d["enum"], f"{where}.{k}: {v!r} not in {d['enum']}"
        if "const" in p: assert v == p["const"], f"{where}.{k}: {v!r} != {p['const']!r}"
        t = p.get("type")
        if t == "string": assert isinstance(v, str), f"{where}.{k}: not a string"
        if t == "boolean": assert isinstance(v, bool), f"{where}.{k}: not a boolean"
check(schema, out, "output")
PY
}

ac1_agents_md_loaded() {
  local C="$SRC/.claude/setup/codex" first id1 id2
  need "$C/build-codex.sh" && need "$C/agents-header.md" && need "$C/pipeline-model.toml" || return 1
  newroot; echo "# test folder: $S"; install_setup
  inhome bash "$H/.claude/setup/codex/build-codex.sh" || fail "build-codex.sh failed" || return 1
  # AGENTS.md = header with the pipeline model filled in + git-hash marker + CLAUDE.md byte-identical
  python3 - "$H/.claude/setup/codex/agents-header.md" "$H/.claude/setup/codex/pipeline-model.toml" \
    "$H/.claude/CLAUDE.md" "$H/.codex/AGENTS.md" "$(git hash-object "$H/.claude/CLAUDE.md")" <<'PY' || fail "AGENTS.md is not header + marker + CLAUDE.md" || return 1
import sys, tomllib
header, setting, rules, out, h = sys.argv[1:6]
m = tomllib.load(open(setting, "rb"))
hdr = open(header, "rb").read().replace(b"@PIPELINE_MODEL@", m["model"].encode()).replace(b"@PIPELINE_EFFORT@", m["model_reasoning_effort"].encode())
data, cm = open(out, "rb").read(), open(rules, "rb").read()
assert b"@PIPELINE_" not in hdr and m["model"].encode() in hdr, "model not filled in"
assert data.startswith(hdr), "does not start with the filled header"
marker = ("<!-- BEGIN ~/.claude/CLAUDE.md verbatim, git-hash %s -->" % h).encode()
i = data.find(b"\n" + marker + b"\n")
assert i >= len(hdr) - 1, "no git-hash marker line after the header"
body = data[i + len(marker) + 2:]
assert body.startswith(b"\n" + cm), "CLAUDE.md is not copied byte-identical after the marker"
assert body[len(cm) + 1:] == b"\n<!-- END ~/.claude/CLAUDE.md -->\n", "unexpected tail after CLAUDE.md"
PY
  # a second run doesn't rewrite it
  id1=$(fileid "$H/.codex/AGENTS.md"); sleep 1
  inhome bash "$H/.claude/setup/codex/build-codex.sh" || fail "second run failed" || return 1
  id2=$(fileid "$H/.codex/AGENTS.md")
  [ "$id1" = "$id2" ] || fail "second run rewrote AGENTS.md ($id1 -> $id2)" || return 1
  # --check: 0 current, 1 after CLAUDE.md changes, 0 after a rebuild
  inhome bash "$H/.claude/setup/codex/build-codex.sh" --check || fail "--check not 0 when current" || return 1
  echo "- a new rule line for ac1" >>"$H/.claude/CLAUDE.md"
  inhome bash "$H/.claude/setup/codex/build-codex.sh" --check; [ $? -eq 1 ] || fail "--check not 1 after CLAUDE.md changed" || return 1
  inhome bash "$H/.claude/setup/codex/build-codex.sh" && inhome bash "$H/.claude/setup/codex/build-codex.sh" --check \
    || fail "--check not 0 after a rebuild" || return 1
  grep -qF -- "- a new rule line for ac1" "$H/.codex/AGENTS.md" || fail "rebuild missed the new line" || return 1
  # Codex really loads it: the user-instructions block shows the header, CLAUDE.md and the skills root
  prompt_input "$S/pi.json" || fail "codex debug prompt-input failed" || return 1
  user_block "$S/pi.json" >"$S/user.txt"
  first=$(head -1 "$H/.claude/setup/codex/agents-header.md")
  grep -qF -- "$first" "$S/user.txt" || fail "header first line not in the user-instructions block" || return 1
  grep -qF -- "**The main session only orchestrates.**" "$S/user.txt" || fail "CLAUDE.md sentence not loaded" || return 1
  grep -qF -- "~/.agents/skills" "$S/user.txt" || fail "~/.agents/skills not named in the loaded rules" || return 1
  done_ok
}
ctx_of() { jq -r '.hookSpecificOutput.additionalContext // empty' <<<"$1" 2>/dev/null; }
msg_of() { jq -r '.systemMessage // empty' <<<"$1" 2>/dev/null; }
session_start() { # session_start [cwd]: the Codex session-start hook on the recorded payload -> $out, $rc
  out=$(payload SessionStart.json "${1:-$H}" | codex_hook session-start); rc=$?
}
ac3_session_start_rules_fresh() {
  local B ctx
  need "$SRC/.codex/hooks/codex-hooks.sh" && need "$SRC/.claude/setup/codex/build-codex.sh" || return 1
  grep -q 'session-start)' "$SRC/.codex/hooks/codex-hooks.sh" || fail "no session-start mode (not built yet)" || return 1
  newroot; echo "# test folder: $S"; install_setup; hooks_env
  export SETUP_SYNC_GIT_DIR="$S/no-setup-repo.git"          # no setup repo: the pull part is silent
  B="$H/.claude/setup/codex/build-codex.sh"
  # 1. AGENTS.md current: the short pointer only
  inhome bash "$B" || return 1
  session_start; ctx=$(ctx_of "$out")
  [ $rc -eq 0 ] && schema_ok SessionStart "$out" || fail "current: exit $rc or schema: $out" || return 1
  for s in "~/.claude/CLAUDE.md" "~/.agents/skills" "~/.hermes/skills"; do
    grep -qF -- "$s" <<<"$ctx" || fail "current: pointer lacks $s" || return 1
  done
  ! grep -qF "The main session only orchestrates" <<<"$ctx" && ! grep -q supersedes <<<"$ctx" || fail "current: full rules injected" || return 1
  # 2. CLAUDE.md changed after the build: the full current text, "supersedes", and AGENTS.md rebuilt
  printf -- '- ac3 rule added after the build\n' >>"$H/.claude/CLAUDE.md"
  inhome bash "$B" --check; [ $? -eq 1 ] || fail "setup: --check should be stale" || return 1
  session_start; ctx=$(ctx_of "$out")
  [ $rc -eq 0 ] && schema_ok SessionStart "$out" || fail "stale: exit $rc or schema" || return 1
  grep -q supersedes <<<"$ctx" && grep -qF -- "$(cat "$H/.claude/CLAUDE.md")" <<<"$ctx" || fail "stale: full current CLAUDE.md missing" || return 1
  inhome bash "$B" --check || fail "stale: AGENTS.md not rebuilt" || return 1
  # 3. AGENTS.md missing: the full CLAUDE.md
  rm -f "$H/.codex/AGENTS.md"
  session_start; ctx=$(ctx_of "$out")
  [ $rc -eq 0 ] && schema_ok SessionStart "$out" || fail "missing: exit $rc or schema" || return 1
  grep -qF -- "$(cat "$H/.claude/CLAUDE.md")" <<<"$ctx" || fail "missing: full CLAUDE.md not injected" || return 1
  done_ok
}
LIBSKILLS="engineering-best-practices implementation-planning mutation-testing-discipline code-review-practice
adversarial-verification-loop security-best-practices multi-tenant-auth-management api-contract-drift-guard backend-data-migrations"
hermes_home() { # hermes_home: own skills from the checkout, a fake library (clone of $S/upstream), the lists
  local n
  mkdir -p "$H/.hermes" "$S/upstream/skills"
  cp -R "$SRC/.hermes/skills" "$H/.hermes/skills"
  cp "$SRC/.hermes/skills-library-claude.txt" "$H/.hermes/"
  printf 'name\tcategory\torigin\tplatforms\tdescription\n' >"$S/upstream/catalog.tsv"
  : >"$H/.hermes/skills-library-keep.txt"
  for n in $LIBSKILLS; do
    mkdir -p "$S/upstream/skills/$n"
    printf -- '---\nname: %s\ndescription: Fake library copy of %s for the codex-parity tests.\n---\n# %s\n' "$n" "$n" "$n" >"$S/upstream/skills/$n/SKILL.md"
    printf '%s\tx\tlocal\tmac\tfake\n' "$n" >>"$S/upstream/catalog.tsv"
    grep -E "^$n[[:space:]]" "$SRC/.hermes/skills-library-keep.txt" >>"$H/.hermes/skills-library-keep.txt"
  done
  git -C "$S/upstream" init -q -b main && git -C "$S/upstream" add -A && inhome git -C "$S/upstream" commit -qm lib
  git clone -q "$S/upstream" "$H/.hermes/skills-library"
}
agents_prestate() { # stale, broken and foreign links plus a folder of Justin's own in ~/.agents/skills
  mkdir -p "$H/.agents/skills/mine" "$S/elsewhere/elsewhere-skill"
  printf -- '---\nname: mine\ndescription: a Codex skill of my own\n---\nx\n' >"$H/.agents/skills/mine/SKILL.md"
  printf -- '---\nname: elsewhere-skill\ndescription: linked by hand from elsewhere\n---\nx\n' >"$S/elsewhere/elsewhere-skill/SKILL.md"
  ln -sfn "$H/.hermes/skills/autonomous-ai-agents/feature-dispatch" "$H/.agents/skills/feature-dispatch"   # stale
  ln -sfn "$H/.hermes/skills/software-development/gone-skill" "$H/.agents/skills/gone-skill"               # broken
  ln -sfn "$S/elsewhere/elsewhere-skill" "$H/.agents/skills/elsewhere-skill"                               # not ours
}
links_of() { # links_of <dir>: "<name> <target>" for each link into the fake ~/.hermes
  local l; for l in "$1"/*; do [ -L "$l" ] || continue
    case $(readlink "$l") in "$H/.hermes/"*) echo "$(basename "$l") $(readlink "$l")" ;; esac; done | sort
}
skill_names() { # skill_names <prompt-input json>: the name of every skill Codex lists, one per line
  jq -r '.[] | .content[]? | .text // empty' "$1" | sed -n 's/^- \([^:]*\): .*(file: r[0-9]*\/.*/\1/p'
}
ac4_codex_sees_claude_skills() {
  local U="$SRC/.hermes/scripts/update-skills-library.sh" CLASH=review-fix-cadence want n out
  need "$U" && grep -q -- '--links-only' "$U" || fail "update-skills-library.sh has no --links-only (not built yet)" || return 1
  newroot; echo "# test folder: $S"; install_setup; hermes_home
  prompt_input "$S/pi0.json" || return 1                     # Codex installs its .system skills first
  mkdir -p "$H/.codex/skills/.system/$CLASH"                 # then a Hermes name also in .system
  printf -- '---\nname: %s\ndescription: system copy\n---\nx\n' "$CLASH" >"$H/.codex/skills/.system/$CLASH/SKILL.md"
  agents_prestate
  want=$(grep -vE '^[[:space:]]*(#|$)' "$H/.hermes/skills-library-claude.txt" | awk '{print $1}' | sort)
  [ "$(wc -l <<<"$want" | tr -d ' ')" = 17 ] || fail "expected 17 Claude-linked names" || return 1
  for mode in default --links-only; do
    if [ $mode = --links-only ]; then rm -rf "$H/.agents/skills"; agents_prestate; fi
    out=$(HERMES_HOME="$H/.hermes" inhome bash "$H/.hermes/scripts/update-skills-library.sh" ${mode#default} 2>&1) \
      || { echo "$out"; fail "update-skills-library.sh $mode failed"; return 1; }
    echo "# $mode: $(tail -n 3 <<<"$out" | tr '\n' ' ')"
    # exactly the Claude-linked names, same targets, minus the .system clash
    [ "$(links_of "$H/.claude/skills" | awk '{print $1}')" = "$want" ] || fail "$mode: ~/.claude/skills is not the 17 names" || return 1
    [ "$(links_of "$H/.agents/skills")" = "$(links_of "$H/.claude/skills" | grep -v "^$CLASH ")" ] \
      || { diff <(links_of "$H/.claude/skills") <(links_of "$H/.agents/skills") | sed 's/^/# /'; fail "$mode: ~/.agents/skills differs from ~/.claude/skills"; return 1; }
    grep -q "codex: skip $CLASH" <<<"$out" || fail "$mode: no message for the .system clash" || return 1
    grep -q "codex links: +16 -2" <<<"$out" || fail "$mode: summary is not 'codex links: +16 -2'" || return 1
    [ ! -e "$H/.agents/skills/feature-dispatch" ] && [ ! -L "$H/.agents/skills/gone-skill" ] || fail "$mode: stale or broken link left" || return 1
    [ -f "$H/.agents/skills/mine/SKILL.md" ] && [ ! -L "$H/.agents/skills/mine" ] || fail "$mode: own folder touched" || return 1
    [ "$(readlink "$H/.agents/skills/elsewhere-skill")" = "$S/elsewhere/elsewhere-skill" ] || fail "$mode: foreign link touched" || return 1
  done
  # a second run changes nothing
  before=$(ls -l "$H/.agents/skills" "$H/.claude/skills")
  out=$(HERMES_HOME="$H/.hermes" inhome bash "$H/.hermes/scripts/update-skills-library.sh" --links-only 2>&1)
  grep -q "claude links: +0 -0   codex links: +0 -0" <<<"$out" && [ "$(ls -l "$H/.agents/skills" "$H/.claude/skills")" = "$before" ] \
    || { echo "$out"; fail "second run changed something"; return 1; }
  # Codex lists each of the 17 exactly once, and no name twice across all roots
  prompt_input "$S/pi.json" || return 1
  skill_names "$S/pi.json" | sort >"$S/names.txt"
  for n in $want; do [ "$(grep -cx "$n" "$S/names.txt")" = 1 ] || fail "$n listed $(grep -cx "$n" "$S/names.txt") times" || return 1; done
  [ -z "$(uniq -d "$S/names.txt")" ] || fail "listed twice: $(uniq -d "$S/names.txt" | tr '\n' ' ')" || return 1
  done_ok
}
ROLES="planner builder reviewer fixer verifier auditor finisher"
doctor_json() { # doctor_json <out>: codex doctor --json in the fake home (its exit is 1 without a sign-in)
  (mkdir -p "$H/work" && cd "$H/work" && inhome codex doctor --json >"$1" 2>"$1.err"); jq -e .checks "$1" >/dev/null
}
ac5_roles_valid_and_load() {
  local r f
  for r in $ROLES; do need "$SRC/.codex/agents/pipeline-$r.toml" || return 1; done
  newroot; echo "# test folder: $S"; mkdir -p "$H/.codex/agents"
  for r in $ROLES; do cp "$SRC/.codex/agents/pipeline-$r.toml" "$H/.codex/agents/"; done
  # content: name, description, developer_instructions, the model lines from the one setting, the contract
  python3 - "$SRC/.claude/setup/codex/pipeline-model.toml" "$H/.codex/agents" $ROLES <<'PY' || fail "role file content" || return 1
import sys, tomllib
setting, d, roles = sys.argv[1], sys.argv[2], sys.argv[3:]
m = tomllib.load(open(setting, "rb"))
bad = []
for r in roles:
    t = tomllib.load(open(f"{d}/pipeline-{r}.toml", "rb"))
    di = t.get("developer_instructions", "")
    if t.get("name") != f"pipeline_{r}": bad.append(f"{r}: name {t.get('name')!r}")
    if not t.get("description"): bad.append(f"{r}: no description")
    if not di.strip(): bad.append(f"{r}: no developer_instructions")
    if t.get("model") != m["model"] or t.get("model_reasoning_effort") != m["model_reasoning_effort"]:
        bad.append(f"{r}: model {t.get('model')}/{t.get('model_reasoning_effort')} != setting {m['model']}/{m['model_reasoning_effort']}")
    for p in ["brief", "skill_lessons", "MAIN SESSION: check and save these skill_lessons now.", "Never spawn"]:
        if p not in di: bad.append(f"{r}: lacks {p!r}")
    if r in ("reviewer", "verifier", "auditor"):
        for p in ["verdict", "ac_status"]:
            if p not in di: bad.append(f"{r}: lacks {p!r}")
        if "never edit" not in di.lower(): bad.append(f"{r}: does not say it never edits source files")
for b in bad: print("#", b)
sys.exit(1 if bad else 0)
PY
  # they load: no malformed-role warning, while a broken copy does produce one
  doctor_json "$S/doctor.json" || fail "codex doctor --json gave no report: $(head -c 300 "$S/doctor.json.err")" || return 1
  if grep -q 'malformed agent role' "$S/doctor.json"; then
    grep -o 'malformed agent role[^"]*' "$S/doctor.json" | head -3; fail "doctor reports a malformed role"; return 1
  fi
  sed 's/^developer_instructions = """/developer_instructions = """broken/; s/^name = /name  /' "$H/.codex/agents/pipeline-planner.toml" >"$H/.codex/agents/pipeline-broken.toml"
  doctor_json "$S/doctor-broken.json"
  grep -q 'malformed agent role.*pipeline-broken.toml' "$S/doctor-broken.json" || fail "a broken copy is not reported" || return 1
  done_ok
}
hooks_env() { # hook state for a test, never the real ~/.codex or ~/.claude
  export CODEX_HOOKS_STATE_DIR="$S/codex-state" SUBAGENT_AC_STATE_DIR="$S/claude-state/ac" \
    SUBAGENT_LESSONS_STATE_DIR="$S/claude-state/lessons" SKILL_NUDGE_STATE_DIR="$S/claude-state/nudge"
}
codex_hook() { inhome bash "$H/.codex/hooks/codex-hooks.sh" "$@"; }
ac6_gates_match_claude_twins() {
  local i msg active cp cl out rc want r ac lessons got n c p
  need "$SRC/.codex/hooks/codex-hooks.sh" && need "$SRC/.codex/hooks.json" || return 1
  newroot; echo "# test folder: $S"; install_setup; hooks_env
  # SubagentStop: block exactly when the Claude gates block on the Claude-shaped payload, reasons joined, AC first
  local -a msgs=(
    $'Verdict: clean\nNo findings.\nskill_lessons: []'                                   # verdict without ac_status
    $'Verdict: clean\nac_status: [{"ac":"AC1","accepted":true}]\nskill_lessons: []'      # verdict with it
    $'Built the thing. All tests pass.'                                                  # no lessons
    $'Built the thing.\n## Skill lessons\nskill_lessons: []'                             # lessons
    $'status: ready-for-review\nhead_sha: 1234567\nAC1: ok - ac1_x\nskill_lessons: []\nMAIN SESSION: check and save these skill_lessons now.'  # builder report
    NULL                                                                                 # null message
    $'Verdict: findings\nno lessons here'                                                # both missing
    ACTIVE                                                                               # stop_hook_active: true
  )
  for i in "${!msgs[@]}"; do
    msg=${msgs[$i]}; active=false
    case $msg in NULL) ;; ACTIVE) active=true; msg=$'Verdict: findings\nno lessons here' ;; esac
    if [ "$msg" = NULL ]; then
      cp=$(payload SubagentStop.json | jq -c --argjson a $active '.last_assistant_message = null | .stop_hook_active = $a')
    else
      cp=$(payload SubagentStop.json | jq -c --arg m "$msg" --argjson a $active '.last_assistant_message = $m | .stop_hook_active = $a')
    fi
    cl=$(jq -c '{session_id, transcript_path, cwd, hook_event_name, stop_hook_active, agent_id, agent_type, last_assistant_message}' <<<"$cp")
    want=""
    for g in subagent-ac-gate.sh subagent-lessons-gate.sh; do
      r=$(printf '%s' "$cl" | bash "$SRC/.claude/hooks/$g" | jq -r 'select(.decision == "block") | .reason // empty')
      [ -n "$r" ] && want="${want:+$want

}$r"
    done
    out=$(printf '%s' "$cp" | codex_hook subagent-stop); rc=$?
    [ $rc -eq 0 ] || fail "case $i: exit $rc" || return 1
    schema_ok SubagentStop "$out" || fail "case $i: output fails the SubagentStop schema: $out" || return 1
    got=$(jq -r 'select(.decision == "block") | .reason // empty' <<<"$out" 2>/dev/null)
    [ "$got" = "$want" ] || { echo "# case $i want: ${want:0:120}"; echo "# case $i got:  ${got:0:120}"; fail "case $i: SubagentStop differs from the Claude gates"; return 1; }
    echo "# case $i: $( [ -n "$want" ] && echo "blocks ($(grep -c 'Before you finish' <<<"$want") reason(s))" || echo allows)"
  done
  # Nudges: identical text on the same counts, main session, subagent and prompts
  for p in PostToolUse-Bash.json PostToolUse-Bash-subagent.json UserPromptSubmit.json; do
    case $p in UserPromptSubmit.json) c=10; mode=prompt ;; *) c=15; mode=post-tool ;; esac
    for n in $(seq 1 $c); do
      out=$(payload "$p" | codex_hook "$mode")
      want=$(payload "$p" | bash "$SRC/.claude/hooks/skill-review-nudge.sh" | jq -r '.hookSpecificOutput.additionalContext // empty')
      got=$(jq -r '.hookSpecificOutput.additionalContext // empty' <<<"$out" 2>/dev/null)
      schema_ok "$(jq -r .hook_event_name "$FIX/$p")" "$out" || fail "$p #$n: output fails the schema" || return 1
      if [ "$n" -lt "$c" ]; then [ -z "$got" ] && [ -z "$want" ] || fail "$p #$n: nudged early" || return 1
      else [ -n "$want" ] && [ "$got" = "$want" ] || { echo "# got: ${got:0:100}"; fail "$p #$n: nudge text differs"; return 1; }; fi
    done
    case $p in *subagent*) grep -q 'skill_lessons\[' <<<"$got" || fail "subagent did not get the subagent text" || return 1 ;;
      *) grep -q 'Self-improvement check' <<<"$got" || fail "$p: main text expected" || return 1 ;; esac
    echo "# $p: nudge on call $c, same text as skill-review-nudge.sh"
  done
  done_ok
}
srcgit() { # git for the checkout: the worktree, or $HOME's bare repo once merged
  if git -C "$SRC" rev-parse --git-dir >/dev/null 2>&1; then git -C "$SRC" "$@"
  else git --git-dir="$SRC/.claude-setup.git" --work-tree="$SRC" "$@"; fi
}
base_commit() { # the story's base: CODEX_PARITY_BASE, else the merge-base with main (origin/main in a clone)
  [ -n "${CODEX_PARITY_BASE:-}" ] && { echo "$CODEX_PARITY_BASE"; return; }
  srcgit merge-base HEAD main 2>/dev/null || srcgit merge-base HEAD origin/main
}
ac7_claude_hooks_unchanged() {
  local base f files="" t
  base=$(base_commit) || fail "no base commit" || return 1
  for f in setup-sync-pull skill-review-nudge subagent-ac-gate subagent-lessons-gate subagent-handback-gate; do
    files="$files .claude/hooks/$f.sh .claude/hooks/tests/$f.test.sh"
  done
  files="$files .claude/settings.json"
  echo "# base $base"
  for f in $files; do
    srcgit cat-file -e "$base:$f" 2>/dev/null || fail "$f missing at base" || return 1
    srcgit show "$base:$f" | cmp -s - "$SRC/$f" || fail "$f differs from base" || return 1
  done
  newroot
  for t in "$SRC"/.claude/hooks/tests/*.test.sh; do
    inhome bash "$t" >"$S/$(basename "$t").out" 2>&1 || { tail -5 "$S/$(basename "$t").out"; fail "$(basename "$t") failed"; return 1; }
    echo "# $(basename "$t"): $(tail -1 "$S/$(basename "$t").out")"
  done
  [ "$(ls "$SRC"/.claude/hooks/tests/*.test.sh | wc -l | tr -d ' ')" = 5 ] || fail "expected five Claude hook test files" || return 1
  done_ok
}
bash_payload() { # bash_payload <fixture> <command> [cwd] [tool name]
  payload "$1" "${3:-$H}" | jq -c --arg c "$2" --arg t "${4:-Bash}" '.tool_name = $t | .tool_input = {command: $c}'
}
decision() { # decision <hook output>: deny, block or nothing
  jq -r '.hookSpecificOutput.permissionDecision // .decision // empty' <<<"$1" 2>/dev/null
}
ac8_commit_guard_blocks_ai_trailer() {
  local c out d i name repo q
  need "$SRC/.codex/hooks/codex-hooks.sh" || return 1
  grep -q 'pre-tool)' "$SRC/.codex/hooks/codex-hooks.sh" || fail "codex-hooks.sh has no pre-tool mode (not built yet)" || return 1
  newroot; echo "# test folder: $S"; install_setup; hooks_env
  repo="$H/proj/repo"; mkdir -p "$repo"; inhome git -C "$repo" init -q -b main
  printf 'fix: x\n\nCo-authored-by: Codex <noreply@openai.com>\n' >"$repo/ai-msg.txt"
  printf 'fix: x\n\nCo-authored-by: Jane Doe <jane@example.test>\n' >"$repo/human-msg.txt"
  # pre-tool: deny each AI name, any case, inline or in a -F/--file file
  i=0
  for name in Codex OpenAI ChatGPT GPT-6.1 Claude Anthropic Copilot Gemini; do
    for q in "Co-authored-by: $name <noreply@example.test>" "CO-AUTHORED-BY: $(tr '[:upper:]' '[:lower:]' <<<"$name") <x@example.test>"; do
      i=$((i + 1))
      out=$(bash_payload PreToolUse-Bash.json "git commit -m \"fix: x\" -m \"$q\"" "$repo" | codex_hook pre-tool)
      [ "$(decision "$out")" = deny ] || fail "pre-tool allowed: $q" || return 1
      schema_ok PreToolUse "$out" || fail "deny output fails the PreToolUse schema" || return 1
    done
  done
  for c in "git -C $repo commit -F $repo/ai-msg.txt" "cd $repo && git commit --file=ai-msg.txt" "git commit -F ai-msg.txt -q" \
           "git -c user.name=x commit -m 'a' -m 'co-authored-by: claude <noreply@anthropic.com>'" \
           $'git commit -F - <<\'EOF\'\nfix: y\n\nCo-authored-by: Codex <noreply@openai.com>\nEOF'; do
    out=$(bash_payload PreToolUse-Bash.json "$c" "$repo" | codex_hook pre-tool)
    [ "$(decision "$out")" = deny ] || fail "pre-tool allowed: $c" || return 1
  done
  echo "# pre-tool: denied $i inline trailers and 5 file/flag/heredoc forms"
  # ... and allows other commits and other commands
  for c in "git commit -m 'fix: thing'" "git commit -F $repo/human-msg.txt" "git commit -m 'x' -m 'Co-authored-by: Jane Doe <jane@example.test>'" \
           "echo 'Co-authored-by: Codex <noreply@openai.com>'" "git log --grep 'Co-authored-by: Claude'" "git status"; do
    out=$(bash_payload PreToolUse-Bash.json "$c" "$repo" | codex_hook pre-tool)
    [ -z "$(decision "$out")" ] || fail "pre-tool blocked: $c" || return 1
  done
  out=$(bash_payload PreToolUse-Bash.json "git commit -m 'x' -m 'Co-authored-by: Codex <n@x>'" "$repo" apply_patch | codex_hook pre-tool)
  [ -z "$(decision "$out")" ] || fail "pre-tool blocked a non-Bash tool" || return 1
  # post-tool: a fresh HEAD with an AI trailer is blocked with "amend"; clean, old or foreign HEADs are not
  echo a >"$repo/a"; inhome git -C "$repo" add a; inhome git -C "$repo" commit -q -F "$repo/ai-msg.txt"
  out=$(bash_payload PostToolUse-Bash.json "git commit -F ai-msg.txt" "$repo" | codex_hook post-tool)
  [ "$(decision "$out")" = block ] && jq -r .reason <<<"$out" | grep -qi amend || fail "post-tool did not block an AI-trailer HEAD: $out" || return 1
  schema_ok PostToolUse "$out" || fail "block output fails the PostToolUse schema" || return 1
  out=$(bash_payload PostToolUse-Bash.json "git -C $repo commit -m x" "$H" | codex_hook post-tool)
  [ "$(decision "$out")" = block ] || fail "post-tool missed git -C <repo> commit" || return 1
  echo b >"$repo/b"; inhome git -C "$repo" add b; inhome git -C "$repo" commit -q -m "fix: clean"
  out=$(bash_payload PostToolUse-Bash.json "git commit -m 'fix: clean'" "$repo" | codex_hook post-tool)
  [ -z "$(decision "$out")" ] || fail "post-tool blocked a clean HEAD" || return 1
  echo c >"$repo/c"; inhome git -C "$repo" add c
  GIT_COMMITTER_DATE="$(date -v-1H '+%s %z' 2>/dev/null || date -d '1 hour ago' '+%s %z')" inhome git -C "$repo" commit -q -F "$repo/ai-msg.txt"
  out=$(bash_payload PostToolUse-Bash.json "git commit -m x" "$repo" | codex_hook post-tool)
  [ -z "$(decision "$out")" ] || fail "post-tool blocked an old HEAD" || return 1
  echo d >"$repo/d"; inhome git -C "$repo" add d
  GIT_COMMITTER_EMAIL=someone-else@example.test inhome git -C "$repo" commit -q -F "$repo/ai-msg.txt"
  out=$(bash_payload PostToolUse-Bash.json "git commit -m x" "$repo" | codex_hook post-tool)
  [ -z "$(decision "$out")" ] || fail "post-tool blocked another committer's HEAD" || return 1
  out=$(bash_payload PostToolUse-Bash.json "git status" "$repo" | codex_hook post-tool)
  [ -z "$(decision "$out")" ] || fail "post-tool blocked a non-commit command" || return 1
  done_ok
}
sandboxed() { # sandboxed <shell command>: run it under Codex's real sandbox with the claude-setup profile
  (cd "$H/work" && inhome codex sandbox -P claude-setup -C "$H/work" -- /bin/sh -c "$1") >"$S/sbx.out" 2>"$S/sbx.err"
}
policy() { # policy <argv…>: the decision setup-sync.rules gives, or "none"
  inhome codex execpolicy check --rules "$H/.codex/rules/setup-sync.rules" -- "$@" 2>"$S/policy.err" | jq -r '.decision // "none"'
}
ac10_sandbox_profile_and_rules() {
  local p c
  need "$SRC/.claude/setup/codex/config.managed.toml" && need "$SRC/.codex/rules/setup-sync.rules" || return 1
  newroot; echo "# test folder: $S"; install_setup
  cp "$SRC/.claude/setup/codex/config.managed.toml" "$H/.codex/config.toml"
  mkdir -p "$H/work" "$H/.hermes/skills" "$H/.hermes/plans" "$H/.hermes/scripts" "$H/.claude/projects/k/memory" "$H/.claude-setup.git" "$H/other"
  echo 'SECRET_FOR_AC10=1' >"$H/.hermes/.env"; echo '{}' >"$H/.claude/settings.json"
  inhome git -C "$H/work" init -q -b main
  for p in .hermes/skills/x .hermes/plans/x .claude/CLAUDE.md .claude/projects/k/memory/n.md; do
    sandboxed "echo ac10 > '$H/$p'" && [ "$(cat "$H/$p")" = ac10 ] || fail "write denied to ~/$p: $(head -c 200 "$S/sbx.err")" || return 1
  done
  echo w >"$H/work/w.txt"
  sandboxed "cd '$H/work' && git add w.txt && git commit -q -m 'ac10 commit'" || fail "git commit denied in the workspace: $(head -c 300 "$S/sbx.err")" || return 1
  [ "$(inhome git -C "$H/work" log -1 --format=%s 2>/dev/null)" = "ac10 commit" ] || fail "no commit in the workspace" || return 1
  for p in .claude/setup/sync.sh .claude/settings.json .claude/hooks/x .hermes/scripts/x .claude-setup.git/x \
           .codex/config.toml .codex/hooks.json .codex/rules/x other/x; do
    [ -e "$H/$p" ] && c=$(cat "$H/$p") || c=ABSENT
    sandboxed "echo ac10 > '$H/$p'" && fail "write allowed to ~/$p" && return 1
    { [ "$c" = ABSENT ] && [ ! -e "$H/$p" ]; } || [ "$c" = "$(cat "$H/$p" 2>/dev/null)" ] || fail "~/$p changed" || return 1
  done
  sandboxed "cat '$H/.hermes/.env'" && fail "~/.hermes/.env is readable" && return 1
  ! grep -q SECRET_FOR_AC10 "$S/sbx.out" || fail "~/.hermes/.env leaked" || return 1
  echo "# sandbox: 4 writes allowed, git commit works, 9 writes and the .env read denied"
  for c in "/Users/justin/.claude/setup/sync.sh" "/home/justin/.claude/setup/sync.sh pull" \
           "/Users/justin/.claude/setup/codex/set-pipeline-model.sh gpt-6-luna"; do
    [ "$(policy $c)" = allow ] || fail "rules: '$c' is not allowed: $(head -c 200 "$S/policy.err")" || return 1
  done
  for c in "bash /Users/justin/.claude/setup/sync.sh" "/tmp/sync.sh" "rm -rf /"; do
    [ "$(policy $c)" = none ] || fail "rules: '$c' matched" || return 1
  done
  echo "# rules: allow for the 3 setup commands, no match for the 3 others"
  done_ok
}
sync_suite() { # sync_suite <out>: this checkout's sync.test.sh, with HOME a fake home that has no sync.sh
  newroot; echo "# test folder: $S"
  (cd "$S" && HOME="$H" TMPDIR="$S/tmp" GIT_CONFIG_NOSYSTEM=1 bash "$SRC/.claude/setup/sync.test.sh") >"$1" 2>&1
}
ac12_sync_codex_paths() {
  local l
  need "$SRC/.claude/setup/sync.test.sh" || return 1
  sync_suite "$ROOT/ac12.out.$$"; mv "$ROOT/ac12.out.$$" "$S/out.txt"
  for l in "codex files synced" "codex state never synced, even with a widened manifest" \
           "AGENTS.md and role models rebuilt on sync and after a pull" \
           "sync.sh changed: 1 when clean, 0 after an edit, a new file, a library edit, or an unpushed commit"; do
    grep -qxF "ok - $l" "$S/out.txt" || { grep -E "NOT OK|  " "$S/out.txt" | tail -5; fail "no 'ok - $l'"; return 1; }
    echo "# ok - $l"
  done
  done_ok
}
ac13_sync_suite_green() {
  local l last n
  need "$SRC/.claude/setup/sync.test.sh" || return 1
  sync_suite "$ROOT/ac13.out.$$"; mv "$ROOT/ac13.out.$$" "$S/out.txt"
  last=$(tail -1 "$S/out.txt"); echo "# $last"
  [[ $last =~ ^passed\ ([0-9]+),\ failed\ 0$ ]] || fail "last line is not 'passed N, failed 0'" || return 1
  n=${BASH_REMATCH[1]}; [ "$n" -ge 32 ] || fail "only $n checks" || return 1
  while IFS= read -r l; do   # the 28 checks sync.test.sh had before this story
    grep -qF "ok - $l" "$S/out.txt" || fail "old check missing: $l" || return 1
  done <<'OLD'
skill synced
CLAUDE.md, settings, hook, test, memory synced
plan + brief synced
project CLAUDE.md copied in
no evidence/private/.env/.usage/config.yaml
no symlinks in repo
author is the personal identity
1500-file commit is pushed (rc=
secret blocks the sync (rc=
nothing pushed
nothing committed locally
over-5MB file not synced
files checked out
existing settings.json backed up
desktop memory linked to Mac memory
project CLAUDE.md written + excluded
no .env checked out
skill change arrived on Mac
memory note written through link arrived
project CLAUDE.md copied out on Mac
desktop link not committed
Mac change arrived on desktop
conflict stops the sync
nothing pushed on conflict
desktop file kept its own text
no rebase left half-done
lock released
a deletion syncs
OLD
  # it tests its own checkout's sync.sh: the fake HOME above has no ~/.claude/setup/sync.sh at all
  [ ! -e "$H/.claude/setup/sync.sh" ] || fail "fake home unexpectedly has sync.sh" || return 1
  done_ok
}
no_locks() { # nothing half-done in the fake home's setup repo or the push state
  local G="$H/.claude-setup.git"
  [ ! -e "$G/setup-sync.lock" ] && [ ! -e "$(PUSHST)/worker.lock" ] && [ ! -e "$G/index.lock" ] \
    && [ ! -d "$G/rebase-merge" ] && [ ! -d "$G/rebase-apply" ]
}
once_on_remote() { # once_on_remote <base> <file> <text>: one commit since <base> touched <file>, and it has <text>
  [ "$(git --git-dir="$S/remote.git" log --format=%H "$1..main" -- "$2" | wc -l | tr -d ' ')" = 1 ] && remote_has "$2" "$3"
}
ac14_lock_claude_and_codex_same_moment() {
  local base round mrc wrc c id
  push_ready || return 1
  newroot; echo "# test folder: $S"; install_setup; attach_repo || fail "setup repo attach failed" || return 1
  export SETUP_SYNC_PUSH_WAIT=1 SETUP_SYNC_PUSH_TRIES=8
  # `sync.sh changed` takes no index lock, so it can't break a sync running at that moment
  touch "$H/.claude/setup/mac.md"; id=$(fileid "$H/.claude-setup.git/index")
  (cd "$H" && inhome bash "$H/.claude/setup/sync.sh" changed) >/dev/null 2>&1
  [ "$(fileid "$H/.claude-setup.git/index")" = "$id" ] || fail "'sync.sh changed' rewrote the index" || return 1
  # 1. a Claude-style manual sync and a Codex push worker start at the same instant (three rounds)
  for round in 1 2 3; do
    base=$(git --git-dir="$S/remote.git" rev-parse main)
    echo "- ac14 round $round edit 1" >>"$H/.claude/setup/mac.md"; echo "- ac14 round $round edit 2" >>"$H/.claude/setup/desktop.md"
    rm -f "$S/go"
    (until [ -e "$S/go" ]; do sleep 0.01; done; cd "$H" && inhome bash "$H/.claude/setup/sync.sh") >"$S/manual.$round" 2>&1 & m=$!
    (until [ -e "$S/go" ]; do sleep 0.01; done; inhome bash "$H/.claude/hooks/setup-sync-push.sh" worker) >"$S/worker.$round" 2>&1 & w=$!
    touch "$S/go"; wait $m; mrc=$?; wait $w; wrc=$?
    [ $wrc -eq 0 ] || fail "round $round: worker exit $wrc" || return 1
    if [ $mrc -ne 0 ]; then
      grep -q "another sync is running" "$S/manual.$round" || { cat "$S/manual.$round"; fail "round $round: manual sync failed"; return 1; }
      c=$(remote_count); (cd "$H" && inhome bash "$H/.claude/setup/sync.sh") >/dev/null 2>&1 || fail "round $round: retry failed" || return 1
      [ "$(remote_count)" = "$c" ] || fail "round $round: the retry made a new commit" || return 1
    fi
    echo "# round $round: manual exit $mrc, worker exit $wrc"
    once_on_remote "$base" .claude/setup/mac.md "- ac14 round $round edit 1" && once_on_remote "$base" .claude/setup/desktop.md "- ac14 round $round edit 2" \
      || fail "round $round: an edit is not on the remote exactly once" || return 1
    no_locks || fail "round $round: a lock or half-done rebase is left" || return 1
    no_flags || fail "round $round: failure flag left: $(cat "$(PUSHST)"/*.flag)" || return 1
  done
  # 2. a sync already holds the lock when the worker starts; it is released two seconds later
  base=$(git --git-dir="$S/remote.git" rev-parse main)
  echo "- ac14 held-lock edit" >>"$H/.claude/setup/mac.md"
  mkdir "$H/.claude-setup.git/setup-sync.lock"
  inhome bash "$H/.claude/hooks/setup-sync-push.sh" worker >"$S/worker.held" 2>&1 & w=$!
  sleep 2; rmdir "$H/.claude-setup.git/setup-sync.lock"
  wait $w; wrc=$?
  [ $wrc -eq 0 ] || fail "held lock: worker exit $wrc" || return 1
  once_on_remote "$base" .claude/setup/mac.md "- ac14 held-lock edit" || fail "held lock: edit not on the remote exactly once" || return 1
  no_locks && no_flags || fail "held lock: lock or flag left" || return 1
  echo "# held lock: worker waited and pushed"
  done_ok
}
pull_stub() { # pull_stub <exit code> <output> [extra shell line]: a fake sync.sh (setup-sync-pull.test.sh's style)
  { printf '#!/usr/bin/env bash\n[ "$1" = pull ] || exit 9\n%s\n' "${3:-}"
    printf 'cat <<'"'"'EOF'"'"'\n%s\nEOF\nexit %s\n' "$2" "$1"; } >"$SETUP_SYNC_SCRIPT"
  chmod +x "$SETUP_SYNC_SCRIPT"
}
ac15_session_start_reuses_claude_pull() {
  local name code text cl cmsg cctx msg ctx
  need "$SRC/.codex/hooks/codex-hooks.sh" || return 1
  grep -q 'session-start)' "$SRC/.codex/hooks/codex-hooks.sh" || fail "no session-start mode (not built yet)" || return 1
  newroot; echo "# test folder: $S"; install_setup; hooks_env
  git init -q --bare "$S/setup.git"
  export SETUP_SYNC_GIT_DIR="$S/setup.git" SETUP_SYNC_SCRIPT="$S/sync.sh"
  inhome bash "$H/.claude/setup/codex/build-codex.sh" || return 1
  while IFS='|' read -r name code text; do
    pull_stub "$code" "$(printf '%b' "$text")"
    cl=$(payload SessionStart.json | inhome bash "$SRC/.claude/hooks/setup-sync-pull.sh")   # Claude's own answer
    cmsg=$(msg_of "$cl"); cctx=$(ctx_of "$cl")
    session_start; msg=$(msg_of "$out"); ctx=$(ctx_of "$out")
    [ $rc -eq 0 ] && schema_ok SessionStart "$out" || fail "$name: exit $rc or schema: $out" || return 1
    [ -n "$cmsg" ] && [ "$msg" = "$cmsg" ] || fail "$name: systemMessage '$msg' != Claude's '$cmsg'" || return 1
    [ "${ctx:0:${#cctx}}" = "$cctx" ] || fail "$name: Claude's additionalContext is not at the start" || return 1
    echo "# $name: $msg"
  done <<'CASES'
up to date|0|
pulled|0|setup-sync: pulled from GitHub:\n  .claude/CLAUDE.md\n  .hermes/skills/a/SKILL.md
CONFLICT|1|setup-sync: CONFLICT: this machine and GitHub both changed the same file (above)
unreachable|0|setup-sync: GitHub unreachable; changes are committed here and go up on the next sync.
failed|1|setup-sync: gitleaks found what looks like a secret (above).
busy|1|setup-sync: another sync is running (/x/setup-sync.lock); try again in a minute.
CASES
  # the pull runs before CLAUDE.md is read: a pull that rewrites it brings the full new text
  pull_stub 0 $'setup-sync: pulled from GitHub:\n  .claude/CLAUDE.md' \
    "printf '# Rules v2 from the other machine\\n- ac15 pulled rule\\n' >\"\$HOME/.claude/CLAUDE.md\""
  session_start; ctx=$(ctx_of "$out")
  schema_ok SessionStart "$out" || return 1
  grep -qF -- "- ac15 pulled rule" <<<"$ctx" && grep -q supersedes <<<"$ctx" || fail "pulled CLAUDE.md not in the context" || return 1
  done_ok
}
now() { perl -MTime::HiRes=time -e 'printf "%.3f", time'; }
wait_for() { # wait_for <seconds> <shell condition>: poll until it holds
  local end=$(( $(date +%s) + $1 )); shift
  until eval "$1"; do [ "$(date +%s)" -lt "$end" ] || return 1; sleep 0.2; done
}
remote_count() { git --git-dir="$S/remote.git" rev-list --count main 2>/dev/null || echo 0; }
remote_has() { git --git-dir="$S/remote.git" show "main:$1" 2>/dev/null | grep -qF -- "$2"; }
gh_() { git --git-dir="$H/.claude-setup.git" --work-tree="$H" "$@"; }   # the fake home's setup repo
PUSHST() { echo "$H/.claude/hooks/state/setup-sync-push"; }
no_flags() { ! ls "$(PUSHST)"/*.flag >/dev/null 2>&1; }
worker_idle() { [ ! -d "$(PUSHST)/worker.lock" ]; }
stop_hook() { payload Stop.json | codex_hook stop; }
prompt_ctx() { ctx_of "$(payload UserPromptSubmit.json | codex_hook prompt)"; }
push_ready() {
  need "$SRC/.claude/hooks/setup-sync-push.sh" && need "$SRC/.codex/hooks/codex-hooks.sh" || return 1
  grep -q 'stop)' "$SRC/.codex/hooks/codex-hooks.sh" || fail "codex-hooks.sh has no stop mode (not built yet)"
}
ac16_stop_hook_pushes_in_background() {
  local c0 t0 t1 pid lines fh
  push_ready || return 1
  newroot; echo "# test folder: $S"; install_setup; attach_repo || fail "setup repo attach failed" || return 1
  export SETUP_SYNC_PUSH_WAIT=1 SETUP_SYNC_PUSH_TRIES=8
  c0=$(remote_count); [ "$c0" -ge 1 ] || fail "no first sync on the remote" || return 1
  echo "- ac16 edit" >>"$H/.claude/CLAUDE.md"
  # the hook, in its own process group, returns within 1 s with no output ...
  t0=$(now)
  payload Stop.json | inhome perl -MPOSIX -e 'POSIX::setsid(); exec @ARGV' bash "$H/.codex/hooks/codex-hooks.sh" stop >"$S/stop.out" 2>&1 &
  pid=$!; wait $pid; t1=$(now)
  kill -TERM -"$pid" 2>/dev/null                              # ... and killing that group doesn't stop the worker
  echo "# stop hook returned in $(perl -e "printf '%.3f', $t1 - $t0") s"
  perl -e "exit(($t1 - $t0) < 1.0 ? 0 : 1)" || fail "stop hook took $(perl -e "print $t1 - $t0") s" || return 1
  [ ! -s "$S/stop.out" ] || fail "stop hook printed: $(cat "$S/stop.out")" || return 1
  wait_for 30 '[ "$(remote_count)" -gt "$c0" ]' || fail "no push within 30 s: $(cat "$(PUSHST)/worker.log" 2>/dev/null | tail -5)" || return 1
  wait_for 30 worker_idle || fail "worker still running" || return 1
  [ "$(remote_count)" = $((c0 + 1)) ] && remote_has .claude/CLAUDE.md "- ac16 edit" || fail "not exactly one commit with the edit" || return 1
  no_flags || fail "flag left after a clean push" || return 1
  # nothing changed and nothing unpushed: no sync.sh run (no fetch, no new log line)
  lines=$(grep -c ' rc=' "$(PUSHST)/worker.log"); fh=$(fileid "$H/.claude-setup.git/FETCH_HEAD")
  stop_hook; sleep 3; wait_for 30 worker_idle
  [ "$(grep -c ' rc=' "$(PUSHST)/worker.log")" = "$lines" ] && [ "$(fileid "$H/.claude-setup.git/FETCH_HEAD")" = "$fh" ] \
    || fail "worker ran sync.sh with nothing to sync" || return 1
  # a gitleaks block leaves a flag, the next prompt shows it, a later clean sync clears it
  printf 'aws_access_key_id = %s%s\n' AKIA Z7XQ3MLP4RTW2KD5 >"$H/.claude/setup/leak.md"
  printf 'aws_secret_access_key = %s%s\n' Zx9pQ2rT7vW1yB4n M8kL3jH6gF5dS0aQwErTyUiO >>"$H/.claude/setup/leak.md"
  stop_hook; wait_for 30 '[ -f "$(PUSHST)/blocked.flag" ]' || fail "no flag after a gitleaks block" || return 1
  prompt_ctx | grep -q 'BLOCKED' && prompt_ctx | grep -q gitleaks || fail "prompt does not show the block" || return 1
  rm -f "$H/.claude/setup/leak.md"; wait_for 30 worker_idle
  stop_hook; wait_for 30 'no_flags && worker_idle' || fail "clean sync did not clear the flag" || return 1
  [ -z "$(prompt_ctx | grep 'Setup sync')" ] || fail "prompt still shows a sync problem" || return 1
  # a CONFLICT leaves a flag too; merging and a clean sync clear it
  git clone -q "$S/remote.git" "$S/other" && echo "- the other machine's line" >>"$S/other/.claude/CLAUDE.md"
  inhome git -C "$S/other" commit -qam other && git -C "$S/other" push -q origin HEAD:main || return 1
  echo "- this machine's line" >>"$H/.claude/CLAUDE.md"
  stop_hook; wait_for 30 '[ -f "$(PUSHST)/conflict.flag" ]' || fail "no flag after a CONFLICT" || return 1
  prompt_ctx | grep -q CONFLICT || fail "prompt does not show the CONFLICT" || return 1
  wait_for 30 worker_idle; gh_ reset -q --soft refs/remotes/origin/main   # merge by hand: keep both lines
  { gh_ show refs/remotes/origin/main:.claude/CLAUDE.md; echo "- this machine's line"; } >"$S/merged.md" && mv "$S/merged.md" "$H/.claude/CLAUDE.md"
  stop_hook; wait_for 30 'no_flags && worker_idle' || fail "flag kept after the merge was synced" || return 1
  remote_has .claude/CLAUDE.md "- this machine's line" && remote_has .claude/CLAUDE.md "- the other machine's line" || fail "merge not pushed" || return 1
  done_ok
}
memkey() { printf '%s' "$1" | sed 's/[^a-zA-Z0-9]/-/g'; }   # Claude's project key, computed independently
ac18_memory_index_injected() {
  local P K ctx i
  need "$SRC/.codex/hooks/codex-hooks.sh" && need "$SRC/.claude/setup/codex/config.managed.toml" || return 1
  grep -q 'session-start)' "$SRC/.codex/hooks/codex-hooks.sh" || fail "no session-start mode (not built yet)" || return 1
  newroot; echo "# test folder: $S"; install_setup; hooks_env
  export SETUP_SYNC_GIT_DIR="$S/no-setup-repo.git"
  inhome bash "$H/.claude/setup/codex/build-codex.sh" || return 1
  P=$(cd "$H" && pwd -P)/x/proj; K=$(memkey "$P")
  mkdir -p "$P/sub" "$H/.claude/projects/$K/memory"
  for i in $(seq 1 250); do echo "- index line $i"; done >"$H/.claude/projects/$K/memory/MEMORY.md"
  # a parent folder finds it (no git)
  session_start "$P/sub"; ctx=$(ctx_of "$out")
  schema_ok SessionStart "$out" || return 1
  grep -qF -- "$H/.claude/projects/$K/memory" <<<"$ctx" || fail "parent: folder path missing" || return 1
  grep -qx -- "- index line 200" <<<"$ctx" && ! grep -qx -- "- index line 201" <<<"$ctx" || fail "parent: not the first 200 lines" || return 1
  grep -q 'MEMORY.md' <<<"$ctx" && grep -qi 'front matter' <<<"$ctx" && grep -qi 're-read' <<<"$ctx" || fail "parent: no save instructions" || return 1
  # the git root finds it when the cwd reaches the repo through a symlink (no parent folder has a memory key)
  inhome git -C "$P" init -q; ln -s "$P" "$H/via-link"
  session_start "$H/via-link/sub"; ctx=$(ctx_of "$out")
  grep -qx -- "- index line 1" <<<"$ctx" || fail "git root: memory not found" || return 1
  # a desktop-style symlinked memory folder
  mkdir -p "$H/desk/proj2" "$H/.claude/projects/$(memkey "$H/desk/proj2")"
  ln -s "../$K/memory" "$H/.claude/projects/$(memkey "$H/desk/proj2")/memory"
  session_start "$H/desk/proj2"; ctx=$(ctx_of "$out")
  grep -qx -- "- index line 7" <<<"$ctx" || fail "symlinked memory folder not read" || return 1
  # no memory, no memory text
  mkdir -p "$H/elsewhere"
  session_start "$H/elsewhere"; ctx=$(ctx_of "$out")
  ! grep -q 'Claude memory' <<<"$ctx" && ! grep -q 'index line' <<<"$ctx" || fail "memory text without a memory folder" || return 1
  # Codex's own memories stay off: the managed config sets no features.memories or memories.* key
  python3 - "$SRC/.claude/setup/codex/config.managed.toml" <<'PY' || fail "managed config touches memories" || return 1
import sys, tomllib
d = tomllib.load(open(sys.argv[1], "rb"))
assert "memories" not in d.get("features", {}) and "memories" not in d, d.keys()
PY
  done_ok
}
justin_config() { # a config.toml shaped like Justin's (fake values)
  cat <<'EOF'
model = "gpt-5.6-luna"
model_reasoning_effort = "medium"
personality = "pragmatic"

[projects."/Users/justin/Documents/weightstone-journal"]
trust_level = "trusted"

[plugins."github@openai-curated"]
enabled = true

[hooks.state."x"]
trusted_hash = "sha256:0000000000000000000000000000000000000000000000000000000000000000"

[mcp_servers.x]
command = "npx"
args = ["-y", "example-mcp-server"]

[mcp_servers.x.env]
X_API_KEY = "fake-value-for-the-ac19-test"

[tui]
screen_reader_detection_done = true
EOF
}
ac19_config_merge_idempotent() {
  local SC b1 out rc k
  SC="$SRC/.claude/setup/codex/setup-codex.sh"
  need "$SC" && need "$SRC/.claude/setup/codex/config.managed.toml" || return 1
  newroot; echo "# test folder: $S"; install_setup; hermes_home
  mkdir -p "$H/.codex/plugins/cache/openai-curated/github/c6ea566d/skills/github" "$H/.codex/plugins/cache/openai-curated/github/c6ea566d/skills/yeet"
  printf -- '---\nname: github\ndescription: plugin copy\n---\nx\n' >"$H/.codex/plugins/cache/openai-curated/github/c6ea566d/skills/github/SKILL.md"
  printf -- '---\nname: yeet\ndescription: plugin only\n---\nx\n' >"$H/.codex/plugins/cache/openai-curated/github/c6ea566d/skills/yeet/SKILL.md"
  HERMES_HOME="$H/.hermes" inhome bash "$H/.hermes/scripts/update-skills-library.sh" >"$S/lib.out" 2>&1 || fail "library links" || return 1
  justin_config >"$H/.codex/config.toml"; cp "$H/.codex/config.toml" "$S/original.toml"
  out=$(HERMES_HOME="$H/.hermes" inhome bash "$H/.claude/setup/codex/setup-codex.sh" 2>&1); rc=$?
  echo "$out" | sed 's/^/# /' | head -12
  [ $rc -eq 0 ] || fail "setup-codex.sh exit $rc" || return 1
  # a backup of the original, mode 600
  b1=$(ls "$H"/.codex/backups/config.toml.* 2>/dev/null | head -1)
  [ -n "$b1" ] && cmp -s "$b1" "$S/original.toml" || fail "no backup of the original" || return 1
  [ "$(python3 -c 'import os,sys; print(oct(os.stat(sys.argv[1]).st_mode & 0o777))' "$b1")" = 0o600 ] || fail "backup is not mode 600" || return 1
  # managed top-level keys before the first table, managed tables at the end, every other key kept
  python3 - "$S/original.toml" "$H/.codex/config.toml" "$H/.codex/plugins/cache/openai-curated/github/c6ea566d/skills/github/SKILL.md" <<'PY' || fail "merged config" || return 1
import re, sys, tomllib
orig, new, gh = sys.argv[1:4]
o, t = tomllib.load(open(orig, "rb")), open(new).read()
n = tomllib.loads(t)
lines = t.splitlines()
first_table = next(i for i, l in enumerate(lines) if re.match(r"\s*\[", l))
top = lines.index("# >>> claude-setup managed: top-level >>>"); tab = lines.index("# >>> claude-setup managed: tables >>>")
assert top < first_table, "top-level block is not before the first table"
assert lines[-1] == "# <<< claude-setup managed: tables <<<", "tables block does not end the file"
own = [i for i, l in enumerate(lines) if re.match(r"\s*\[", l) and "claude-setup" not in l and "skills.config" not in l]
assert own and max(own) < tab, "a table of Justin's comes after the managed tables block"
def walk(a, b, p=""):
    for k, v in a.items():
        assert k in b, f"lost {p}{k}"
        if isinstance(v, dict): walk(v, b[k], f"{p}{k}.")
        else: assert b[k] == v, f"changed {p}{k}: {v!r} -> {b[k]!r}"
walk(o, n)
assert n["default_permissions"] == "claude-setup" and n["project_doc_fallback_filenames"] == ["CLAUDE.md"] and n["project_doc_max_bytes"] == 262144
assert n["permissions"]["claude-setup"]["extends"] == ":workspace"
sc = n.get("skills", {}).get("config", [])
assert [s["path"] for s in sc if s.get("enabled") is False] == [gh], f"plugin duplicate not disabled exactly: {sc}"
PY
  # a second run is byte-identical and makes no new backup
  cp "$H/.codex/config.toml" "$S/first.toml"
  HERMES_HOME="$H/.hermes" inhome bash "$H/.claude/setup/codex/setup-codex.sh" >"$S/second.out" 2>&1 || fail "second run failed" || return 1
  cmp -s "$S/first.toml" "$H/.codex/config.toml" || fail "second run changed config.toml" || return 1
  [ "$(ls "$H"/.codex/backups/ | wc -l | tr -d ' ')" = 1 ] || fail "second run made a backup" || return 1
  HERMES_HOME="$H/.hermes" inhome bash "$H/.claude/setup/codex/setup-codex.sh" --check >"$S/check.out" 2>&1 || { cat "$S/check.out"; fail "--check not 0 when current"; return 1; }
  # Codex sees the claude-setup permission entries
  prompt_input "$S/pi.json" || return 1
  jq -r '.[] | .content[]? | .text // empty' "$S/pi.json" >"$S/pi.txt"
  grep -qF "<entry access=\"write\"><path>$H/.hermes</path>" "$S/pi.txt" && grep -qF "<entry access=\"read\"><path>$H/.claude/setup</path>" "$S/pi.txt" \
    && grep -qF "<entry access=\"write\"><path>$H/work/.git</path>" "$S/pi.txt" || fail "claude-setup permission entries not in the prompt" || return 1
  # an unmanaged managed key makes it refuse: exit 3, file untouched
  for k in 'project_doc_max_bytes = 65536' 'sandbox_mode = "workspace-write"'; do
    { echo "$k"; justin_config; } >"$H/.codex/config.toml"; cp "$H/.codex/config.toml" "$S/hand.toml"
    HERMES_HOME="$H/.hermes" inhome bash "$H/.claude/setup/codex/setup-codex.sh" >"$S/refuse.out" 2>&1; rc=$?
    [ $rc -eq 3 ] && cmp -s "$S/hand.toml" "$H/.codex/config.toml" || { cat "$S/refuse.out"; fail "'$k': exit $rc, or the file changed"; return 1; }
    grep -q "${k%% *}" "$S/refuse.out" || fail "refusal does not name ${k%% *}" || return 1
  done
  echo "# refused with exit 3 for a hand-set project_doc_max_bytes and sandbox_mode"
  done_ok
}
attach_desk() { # attach_desk <home>: a second machine on the same remote, attached the way desktop.md says
  local B=$1
  mkdir -p "$B"; cp "$H/.gitconfig" "$H/.gitconfig-leorna" "$B/"
  git clone -q --bare "$S/remote.git" "$B/.claude-setup.git"
  (cd "$B" && HOME="$B" CODEX_HOME="$B/.codex" TMPDIR="$S/tmp" GIT_CONFIG_NOSYSTEM=1 \
    bash <(git --git-dir="$B/.claude-setup.git" show main:.claude/setup/sync.sh) attach) >"$S/attach-$(basename "$B").out" 2>&1
}
ac20_codex_edit_reaches_other_machine() {
  local B c0 out ctx
  push_ready || return 1
  newroot; echo "# test folder: $S"; install_setup
  mkdir -p "$H/.hermes/skills/sd/foo" "$H/.claude/projects/-mac-proj/memory"
  echo "Version: v1" >"$H/.hermes/skills/sd/foo/SKILL.md"
  echo "- [note](note.md)" >"$H/.claude/projects/-mac-proj/memory/MEMORY.md"; echo "note v1" >"$H/.claude/projects/-mac-proj/memory/note.md"
  attach_repo || fail "setup repo attach failed" || return 1
  B="$S/desk"; attach_desk "$B" || { cat "$S/attach-desk.out"; fail "desk attach failed"; return 1; }
  [ -f "$B/.codex/AGENTS.md" ] || fail "desk has no AGENTS.md after attach" || return 1
  # A (mac) edits a skill, CLAUDE.md and a memory note; its Stop hook pushes in the background
  export SETUP_SYNC_PUSH_WAIT=1 SETUP_SYNC_PUSH_TRIES=8
  c0=$(remote_count)
  echo "Version: v2" >"$H/.hermes/skills/sd/foo/SKILL.md"
  echo "- ac20 rule from the Mac" >>"$H/.claude/CLAUDE.md"
  echo "note v2" >"$H/.claude/projects/-mac-proj/memory/note.md"
  stop_hook
  wait_for 45 '[ "$(remote_count)" -gt "$c0" ] && worker_idle' || fail "mac's edits not pushed: $(tail -5 "$(PUSHST)/worker.log")" || return 1
  # B (desk) starts a Codex session: the hook pulls, rebuilds AGENTS.md and hands over the new CLAUDE.md
  out=$(H="$B"; payload SessionStart.json "$B" | codex_hook session-start); ctx=$(ctx_of "$out")
  echo "# desk: $(msg_of "$out")"
  schema_ok SessionStart "$out" || return 1
  grep -qx "Version: v2" "$B/.hermes/skills/sd/foo/SKILL.md" || fail "skill edit not on the desk" || return 1
  grep -qxF -- "- ac20 rule from the Mac" "$B/.claude/CLAUDE.md" || fail "CLAUDE.md edit not on the desk" || return 1
  grep -qx "note v2" "$B/.claude/projects/-mac-proj/memory/note.md" || fail "memory note edit not on the desk" || return 1
  grep -qxF -- "- ac20 rule from the Mac" "$B/.codex/AGENTS.md" || fail "desk AGENTS.md not rebuilt" || return 1
  grep -q supersedes <<<"$ctx" && grep -qF -- "$(cat "$B/.claude/CLAUDE.md")" <<<"$ctx" || fail "new CLAUDE.md not in full in the context" || return 1
  done_ok
}
model_state() { # everything a refused switch must leave alone
  (cd "$H" && shasum .claude/setup/codex/pipeline-model.toml .codex/agents/pipeline-*.toml .codex/AGENTS.md)
  gh_ rev-parse HEAD; gh_ status --porcelain; remote_count
}
roles_say() { # roles_say <home> <model> <effort>: all seven role files and AGENTS.md carry them
  local r
  for r in $ROLES; do
    grep -qx "model = \"$2\"" "$1/.codex/agents/pipeline-$r.toml" && grep -qx "model_reasoning_effort = \"$3\"" "$1/.codex/agents/pipeline-$r.toml" \
      || { echo "# $1: pipeline-$r.toml is not $2/$3"; return 1; }
  done
  grep -qF "**$2** at **$3** effort" "$1/.codex/AGENTS.md" || { echo "# $1: AGENTS.md is not $2/$3"; return 1; }
}
last_commit_files() { git --git-dir="$S/remote.git" show --name-only --format= main | sort; }
ac21_pipeline_model_switch() {
  local SP B before out rc c0 want r
  need "$SRC/.claude/setup/codex/set-pipeline-model.sh" || return 1
  newroot; echo "# test folder: $S"; install_setup; SP="$H/.claude/setup/codex/set-pipeline-model.sh"
  cp "$FIX/models_cache.sample.json" "$H/.codex/models_cache.json"
  attach_repo || fail "setup repo attach failed" || return 1
  B="$S/desk"; attach_desk "$B" || { cat "$S/attach-desk.out"; fail "desk attach failed"; return 1; }
  roles_say "$H" gpt-6.1-sol xhigh && roles_say "$B" gpt-6.1-sol xhigh || fail "start state is not gpt-6.1-sol/xhigh" || return 1
  # an unknown model: exit 2, the valid list, nothing changed
  before=$(model_state)
  out=$(cd "$H" && inhome bash "$SP" gpt-nope 2>&1); rc=$?
  [ $rc -eq 2 ] && grep -q "gpt-6-luna" <<<"$out" && grep -q "gpt-6.1-sol" <<<"$out" || fail "gpt-nope: exit $rc, or no model list: $out" || return 1
  [ "$(model_state)" = "$before" ] || fail "gpt-nope changed a file or commit" || return 1
  # an effort the model doesn't have: exit 2 and luna's efforts
  out=$(cd "$H" && inhome bash "$SP" gpt-6-luna ultra 2>&1); rc=$?
  [ $rc -eq 2 ] && grep -q "low medium high xhigh max" <<<"$out" || fail "gpt-6-luna ultra: exit $rc: $out" || return 1
  [ "$(model_state)" = "$before" ] || fail "gpt-6-luna ultra changed a file or commit" || return 1
  # a valid switch: seven role files + AGENTS.md, one commit holding the setting and the role files
  c0=$(remote_count)
  (cd "$H" && inhome bash "$SP" gpt-6-luna low) >"$S/switch.out" 2>&1 || { cat "$S/switch.out"; fail "switch failed"; return 1; }
  roles_say "$H" gpt-6-luna low || fail "A not switched" || return 1
  [ "$(remote_count)" = $((c0 + 1)) ] || fail "not exactly one new commit on the remote" || return 1
  want=$( { echo .claude/setup/codex/pipeline-model.toml; for r in $ROLES; do echo ".codex/agents/pipeline-$r.toml"; done; } | sort)
  [ "$(last_commit_files)" = "$want" ] || { last_commit_files | sed 's/^/# /'; fail "the commit is not the setting + seven role files"; return 1; }
  (H="$B"; cd "$B" && inhome bash "$B/.claude/setup/sync.sh" pull) >"$S/pull.out" 2>&1 || { cat "$S/pull.out"; fail "desk pull failed"; return 1; }
  roles_say "$B" gpt-6-luna low || fail "desk not switched after its pull" || return 1
  # a hand edit of the setting: sync.sh rewrites and commits all seven role files too
  printf '# edited by hand\nmodel = "gpt-6.1-sol"\nmodel_reasoning_effort = "xhigh"\n' >"$H/.claude/setup/codex/pipeline-model.toml"
  (cd "$H" && inhome bash "$H/.claude/setup/sync.sh") >"$S/hand.out" 2>&1 || { cat "$S/hand.out"; fail "sync after the hand edit failed"; return 1; }
  roles_say "$H" gpt-6.1-sol xhigh || fail "hand edit: role files not rewritten" || return 1
  [ "$(last_commit_files)" = "$want" ] || fail "hand edit: the commit is not the setting + seven role files" || return 1
  for r in $ROLES; do git --git-dir="$S/remote.git" show "main:.codex/agents/pipeline-$r.toml" | grep -qx 'model = "gpt-6.1-sol"' || fail "remote $r not gpt-6.1-sol" || return 1; done
  done_ok
}
codex_section() { # codex_section <md file>: the text of its "Codex" section, up to the next heading as high
  awk 'BEGIN { lvl = 0 }
    /^#+ / { n = index($0, " ") - 1
             if (lvl && n <= lvl) exit
             if (!lvl && $0 ~ /Codex/) { lvl = n } }
    lvl { print }' "$1"
}
ac23_docs_updated() {
  local f sec s base n total added
  for f in .claude/setup/mac.md .claude/setup/desktop.md .github/README.md; do
    sec=$(codex_section "$SRC/$f")
    [ -n "$sec" ] || fail "$f has no Codex section" || return 1
    for s in "codex login" "setup-codex.sh" "/hooks" "pipeline-model.toml" "set-pipeline-model.sh" "models_cache.json" \
             "role files" "sync.sh" "auth.json" "config.toml" "AGENTS.md" "/import"; do
      grep -qF -- "$s" <<<"$sec" || fail "$f Codex section lacks '$s'" || return 1
    done
    grep -qiE "never (synced|syncs)|not synced" <<<"$sec" || fail "$f does not say what never syncs" || return 1
    grep -qiE "(don't|do not|never) use[^.]*/import" <<<"$sec" || fail "$f does not say not to use /import" || return 1
    case $f in
      *mac.md) grep -qF "npm install -g @openai/codex" <<<"$sec" || fail "mac.md lacks the install command" || return 1 ;;
      *) grep -qF "curl -fsSL https://chatgpt.com/codex/install.sh | sh" <<<"$sec" || fail "$f lacks the install command" || return 1 ;;
    esac
    echo "# $f: Codex section complete ($(wc -l <<<"$sec" | tr -d ' ') lines)"
  done
  total=$(grep -c '^ok "' "$SRC/.claude/setup/sync.test.sh")
  grep -qF "passed $total, failed 0" "$SRC/.claude/setup/desktop.md" || fail "desktop.md does not expect 'passed $total, failed 0'" || return 1
  ! grep -q "passed 28, failed 0" "$SRC/.claude/setup/desktop.md" || fail "desktop.md still says passed 28" || return 1
  # CLAUDE.md: exactly one added line, in Setup Sync, naming Codex
  base=$(base_commit) || return 1
  [ "$(srcgit diff --numstat "$base" -- .claude/CLAUDE.md | awk '{print $1" "$2}')" = "1 0" ] || fail "CLAUDE.md is not exactly one added line" || return 1
  added=$(srcgit diff -U0 "$base" -- .claude/CLAUDE.md | sed -n 's/^+\([^+].*\)/\1/p')
  grep -q Codex <<<"$added" || fail "the added CLAUDE.md line does not mention Codex" || return 1
  awk '/^## /{ s = ($0 ~ /^## Setup Sync/) } s' "$SRC/.claude/CLAUDE.md" | grep -qxF -- "$added" || fail "the added line is not in Setup Sync" || return 1
  echo "# CLAUDE.md: + $added"
}

# ---- probe tests (a real `codex exec` through the probe home; run only when named) ----
AC2_PROMPT="Answer briefly, in three numbered lines: 1) May a git commit carry an AI Co-Authored-By line? 2) What does the main session do for a bug or story? 3) Where are Justin's Hermes skills?"
rules_answer_ok() { # rules_answer_ok <last.txt> <events.jsonl>: the three AC2 answers, on the first turn, with no tool call
  local a a1 types
  a=$(cat "$1" 2>/dev/null); echo "# answer: $(tr '\n' ' ' <<<"$a" | cut -c1-300)"
  a1=$(grep -m1 -E '^[[:space:]*#]*1[).:]' <<<"$a"); [ -n "$a1" ] || a1=$a   # answer 1's line when numbered
  grep -qiE '(^|[^a-z])(no|never)([^a-z]|$)' <<<"$a1" || fail "answer 1 is not no/never" || return 1
  grep -qi 'orchestrat' <<<"$a" || fail "answer 2 does not say the main session orchestrates" || return 1
  grep -qF '.hermes/skills' <<<"$a" || fail "answer 3 does not name ~/.hermes/skills" || return 1
  # the one "error" item allowed is Codex's notice that --dangerously-bypass-hook-trust is on (probe runs)
  types=$(jq -r 'select(.item.type? != null) | .item | select(.type != "error" or ((.message // "") | contains("dangerously-bypass-hook-trust") | not)) | .type' "$2" 2>/dev/null | sort -u | tr '\n' ' ')
  echo "# event item types: $types"
  [ -z "$(tr ' ' '\n' <<<"$types" | grep -v '^$' | grep -vxE 'agent_message|reasoning')" ] || fail "the first turn used a tool ($types)" || return 1
}
probe_home_setup() { # a fake home with the built rules, hooks, managed config and linked skills
  newroot; echo "# test folder: $S"; install_setup; hermes_home
  HERMES_HOME="$H/.hermes" inhome bash "$H/.hermes/scripts/update-skills-library.sh" >"$S/lib.out" 2>&1 || fail "skill links" || return 1
  cp "$SRC/.claude/setup/codex/config.managed.toml" "$H/.codex/config.toml"
  inhome bash "$H/.claude/setup/codex/build-codex.sh" || fail "build-codex.sh" || return 1
  mkdir -p "$H/work" "$S/run"
}
ac2_first_turn_knows_rules() {
  need "$SRC/.claude/setup/codex/build-codex.sh" && need "$SRC/.codex/hooks.json" || return 1
  probe_ready || return 1
  probe_home_setup || return 1
  probe_begin "$H" || return 1; trap probe_end EXIT
  probe_exec "$H" "$H/work" "$S/run" "$AC2_PROMPT" || { tail -5 "$S/run/stderr.txt"; fail "codex exec failed"; return 1; }
  rules_answer_ok "$S/run/last.txt" "$S/run/events.jsonl" || return 1
  done_ok
}
ac9_codex_commit_identity_no_trailer() {
  local r1 r2 l1 l2
  need "$SRC/.codex/hooks/codex-hooks.sh" && need "$SRC/.claude/setup/codex/config.managed.toml" || return 1
  probe_ready || return 1
  probe_home_setup || return 1
  r1="$H/Leorna/repo1"; r2="$H/proj/repo2"; mkdir -p "$r1" "$r2"
  inhome git -C "$r1" init -q -b main; inhome git -C "$r2" init -q -b main
  probe_begin "$H" || return 1; trap probe_end EXIT
  probe_exec "$H" "$r1" "$S/run" "Create a file a.txt containing the word one in this repository and commit it with the message 'add a'. Then create b.txt containing the word two in $r2 and commit it there with the message 'add b'. Use plain git commands; don't change any git configuration." \
    --add-dir "$r2" -c 'approval_policy="never"' || { tail -5 "$S/run/stderr.txt"; fail "codex exec failed"; return 1; }
  l1=$(inhome git -C "$r1" log -1 --format='%an <%ae>%n%B' 2>/dev/null); l2=$(inhome git -C "$r2" log -1 --format='%an <%ae>%n%B' 2>/dev/null)
  echo "# repo1: $(head -1 <<<"$l1")   repo2: $(head -1 <<<"$l2")"
  [ "$(head -1 <<<"$l1")" = "Test Leorna <leorna@example.test>" ] || fail "repo1 not authored by the Leorna identity" || return 1
  [ "$(head -1 <<<"$l2")" = "Test Personal <personal@example.test>" ] || fail "repo2 not authored by the personal identity" || return 1
  ! grep -qi 'co-authored-by' <<<"$l1$l2" || fail "a commit carries a Co-authored-by line" || return 1
  done_ok
}
ac11_codex_runs_sync_outside_sandbox() {
  local c0
  need "$SRC/.codex/rules/setup-sync.rules" && need "$SRC/.claude/setup/codex/config.managed.toml" || return 1
  probe_ready || return 1
  newroot; echo "# test folder: $S"; install_setup
  mkdir -p "$H/.hermes/skills/sd/foo" "$H/work" "$S/run"; echo "Version: v1" >"$H/.hermes/skills/sd/foo/SKILL.md"
  attach_repo || fail "setup repo attach failed" || return 1
  cp "$SRC/.claude/setup/codex/config.managed.toml" "$H/.codex/config.toml"
  sed -e "s|/Users/justin|$H|g" -e "s|/home/justin|$H|g" "$SRC/.codex/rules/setup-sync.rules" >"$H/.codex/rules/setup-sync.rules"
  rm -f "$H/.codex/hooks.json"                                  # no hooks: only Codex itself can sync
  echo "Version: v2 (ac11)" >"$H/.hermes/skills/sd/foo/SKILL.md"; c0=$(remote_count)
  probe_begin "$H" || return 1; trap probe_end EXIT
  probe_exec "$H" "$H/work" "$S/run" "Run the setup sync now: run exactly $H/.claude/setup/sync.sh as one plain command, then tell me its last line." \
    -c 'approval_policy="never"' || { tail -5 "$S/run/stderr.txt"; fail "codex exec failed"; return 1; }
  remote_has .hermes/skills/sd/foo/SKILL.md "Version: v2 (ac11)" && [ "$(remote_count)" -gt "$c0" ] || fail "the edit is not on the remote: $(cat "$S/run/last.txt")" || return 1
  [ ! -e "$H/.claude-setup.git/setup-sync.lock" ] || fail "sync lock left" || return 1
  done_ok
}
ac17_codex_skill_edit_reaches_remote() {
  local c0 msg
  push_ready || return 1
  probe_ready || return 1
  newroot; echo "# test folder: $S"; install_setup
  mkdir -p "$H/.hermes/skills/sd/foo" "$H/.agents/skills" "$H/work" "$S/run"
  printf -- '---\nname: foo\ndescription: Probe skill for the codex-parity tests.\n---\nVersion: v1\n' >"$H/.hermes/skills/sd/foo/SKILL.md"
  ln -s "$H/.hermes/skills/sd/foo" "$H/.agents/skills/foo"
  attach_repo || fail "setup repo attach failed" || return 1
  cp "$SRC/.claude/setup/codex/config.managed.toml" "$H/.codex/config.toml"
  inhome bash "$H/.claude/setup/codex/build-codex.sh" || return 1
  export SETUP_SYNC_PUSH_WAIT=2 SETUP_SYNC_PUSH_TRIES=8; c0=$(remote_count)
  probe_begin "$H" || return 1; trap probe_end EXIT
  probe_exec "$H" "$H/work" "$S/run" "In the skill named foo (your skills list), change the line 'Version: v1' to 'Version: v2'. Don't run any setup sync yourself." \
    || { tail -5 "$S/run/stderr.txt"; fail "codex exec failed"; return 1; }
  wait_for 90 'remote_has .hermes/skills/sd/foo/SKILL.md "Version: v2" && worker_idle' || fail "v2 not on the remote within 90 s: $(tail -5 "$(PUSHST)/worker.log" 2>/dev/null)" || return 1
  msg=$(git --git-dir="$S/remote.git" log -1 --format='%ae%n%B' main -- .hermes/skills/sd/foo/SKILL.md)
  [ "$(head -1 <<<"$msg")" = personal@example.test ] || fail "commit not by the fake home's identity" || return 1
  ! grep -qi co-authored-by <<<"$msg" || fail "commit has a Co-authored-by line" || return 1
  no_flags && worker_idle || fail "worker lock or flag left" || return 1
  done_ok
}
ac22_roles_use_switched_model() {
  local f
  need "$SRC/.claude/setup/codex/set-pipeline-model.sh" && need "$SRC/.codex/agents/pipeline-planner.toml" || return 1
  probe_ready || return 1
  newroot; echo "# test folder: $S"; install_setup; mkdir -p "$H/work" "$S/run" "$S/payloads"
  cp "$FIX/models_cache.sample.json" "$H/.codex/models_cache.json"
  attach_repo || fail "setup repo attach failed" || return 1
  (cd "$H" && inhome bash "$H/.claude/setup/codex/set-pipeline-model.sh" gpt-6-luna low) >"$S/switch.out" 2>&1 || { cat "$S/switch.out"; return 1; }
  cp "$SRC/.claude/setup/codex/config.managed.toml" "$H/.codex/config.toml"
  printf '#!/usr/bin/env bash\ncat >"%s/payloads/$(perl -MTime::HiRes=time -e '"'"'printf "%%.6f", time'"'"')-$1.json"\n' "$S" >"$S/log.sh"
  jq --arg c "bash $S/log.sh" '.hooks.SubagentStop[0].hooks += [{type: "command", command: ($c + " SubagentStop"), timeout: 10}]
    | .hooks.Stop[0].hooks += [{type: "command", command: ($c + " Stop"), timeout: 10}]' "$H/.codex/hooks.json" >"$S/hooks.json" && mv "$S/hooks.json" "$H/.codex/hooks.json"
  probe_begin "$H" || return 1; trap probe_end EXIT
  probe_exec "$H" "$H/work" "$S/run" "Spawn one pipeline_planner agent with this message: 'Probe brief: do no work. Reply with the word PLANNED, then the line skill_lessons: [] and then the line MAIN SESSION: check and save these skill_lessons now.' Wait for it, then reply with its answer." \
    || { tail -5 "$S/run/stderr.txt"; fail "codex exec failed"; return 1; }
  f=$(cat "$S"/payloads/*-SubagentStop.json 2>/dev/null | jq -s -c 'map(select(.agent_type == "pipeline_planner")) | first // empty')
  echo "# planner SubagentStop: $(jq -c '{agent_type, model}' <<<"$f" 2>/dev/null)"
  [ "$(jq -r .model <<<"$f" 2>/dev/null)" = gpt-6-luna ] || fail "the planner did not run on gpt-6-luna" || return 1
  [ "$(cat "$S"/payloads/*-Stop.json 2>/dev/null | jq -rs 'map(.model) | first // empty')" = "$PROBE_MODEL" ] && [ "$PROBE_MODEL" != gpt-6-luna ] \
    || fail "the parent did not run on a different model" || return 1
  done_ok
}

# ---- live tests (the real machine; run only when named) ----
real_checks() { # the real ~/.codex: AGENTS.md current, header + 17 skills once, no malformed role, hooks trusted, AC2 answer
  [ "${CODEX_PARITY_REAL:-}" = 1 ] || fail "live: run on the real machine with CODEX_PARITY_REAL=1" || return 1
  local T; T=$(mktemp -d "$ROOT/live.XXXXXX"); echo "# scratch: $T"
  bash "$REAL_HOME/.claude/setup/codex/build-codex.sh" --check || fail "~/.codex/AGENTS.md is stale" || return 1
  (cd "$REAL_HOME" && codex debug prompt-input >"$T/pi.json") || fail "prompt-input failed" || return 1
  jq -r '.[] | .content[]? | .text // empty' "$T/pi.json" >"$T/pi.txt"
  grep -qF "$(head -1 "$REAL_HOME/.claude/setup/codex/agents-header.md")" "$T/pi.txt" || fail "header not loaded" || return 1
  skill_names "$T/pi.json" | sort >"$T/names"
  for n in $(grep -vE '^[[:space:]]*(#|$)' "$REAL_HOME/.hermes/skills-library-claude.txt" | awk '{print $1}'); do
    [ "$(grep -cx "$n" "$T/names")" = 1 ] || fail "skill $n listed $(grep -cx "$n" "$T/names") times" || return 1
  done
  [ -z "$(uniq -d "$T/names")" ] || fail "listed twice: $(uniq -d "$T/names" | tr '\n' ' ')" || return 1
  (cd "$REAL_HOME" && codex doctor --json >"$T/doctor.json" 2>/dev/null)
  ! grep -q 'malformed agent role' "$T/doctor.json" || fail "malformed role" || return 1
  [ "$(grep -c 'trusted_hash' "$REAL_HOME/.codex/config.toml")" -ge 6 ] || fail "fewer than 6 trusted hooks (open codex, /hooks)" || return 1
  (cd "$REAL_HOME" && codex exec --ephemeral --skip-git-repo-check -m gpt-6.1-sol -c 'model_reasoning_effort="low"' --json -o "$T/last.txt" "$AC2_PROMPT" >"$T/events.jsonl" 2>"$T/stderr.txt") \
    || fail "codex exec failed: $(tail -3 "$T/stderr.txt")" || return 1
  rules_answer_ok "$T/last.txt" "$T/events.jsonl" || return 1
  grep -q 'Setup sync:' "$T/events.jsonl" "$T/stderr.txt" || fail "no 'Setup sync:' line at session start" || return 1
}
ac25_desktop_codex_parity() {
  [ "$(uname -s)" = Linux ] || fail "live: run on the desktop (WSL Ubuntu)" || return 1
  real_checks
}
ac26_mac_install_smoke() {
  [ "$(uname -s)" = Darwin ] || fail "live: run on the Mac" || return 1
  real_checks
}
ac27_codex_story_run() {
  local E=${CODEX_STORY_EVIDENCE:-}
  [ -n "$E" ] && [ -d "$E" ] || fail "live: set CODEX_STORY_EVIDENCE=<evidence dir of a real Codex story run>" || return 1
  [ -f "$E/ac-check.log" ] && tail -1 "$E/ac-check.log" | grep -qE '^(ALL ACCEPTED|READY FOR THE USER)' || fail "ac-check.log does not end ALL ACCEPTED / READY FOR THE USER" || return 1
  [ -f "$E/gate.log" ] && grep -q 'SubagentStop' "$E/gate.log" && grep -q '"decision":"block"' "$E/gate.log" || fail "gate.log shows no SubagentStop block" || return 1
  for r in planner builder reviewer fixer verifier auditor; do
    grep -q "pipeline_$r" "$E/gate.log" || fail "gate.log shows no pipeline_$r agent" || return 1
  done
}
ac24_linux_suites() {
  docker info >/dev/null 2>&1 || fail "live: Docker is not running" || return 1
  docker run --rm --privileged -v "$REAL_HOME/.claude-setup.git:/repo.git:ro" ubuntu:24.04 bash -lc '
    set -e; apt-get update -qq; apt-get install -y -qq git jq curl perl python3 bubblewrap ca-certificates >/dev/null
    curl -fsSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_arm64.tar.gz | tar -xz -C /usr/local/bin gitleaks
    curl -fsSL https://github.com/openai/codex/releases/download/rust-v0.163.0/codex-aarch64-unknown-linux-musl.tar.gz | tar -xz -C /tmp && install /tmp/codex-aarch64-unknown-linux-musl /usr/local/bin/codex
    useradd -m t; su t -c "git config --global user.name T && git config --global user.email t@example.test &&
      git clone -q -b codex-parity /repo.git ~/wt && cd ~/wt &&
      bash .claude/setup/codex/codex-parity.test.sh && bash .claude/setup/sync.test.sh &&
      for f in .claude/hooks/tests/*.test.sh; do bash \$f || exit 1; done"'
}

if [ $# -gt 0 ]; then for t in "$@"; do run "$t"; done; else for t in $OFFLINE; do run "$t"; done; fi
echo "# passed $((n - failed)), failed $failed"
[ "$failed" -eq 0 ]
