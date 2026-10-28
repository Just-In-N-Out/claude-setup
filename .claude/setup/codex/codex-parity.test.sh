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

fileid() { python3 -c 'import os,sys; s=os.stat(sys.argv[1]); print(s.st_ino, s.st_mtime_ns)' "$1"; }
user_block() { # user_block <prompt-input json>: the AGENTS.md user-instructions block Codex would send
  jq -r '.[] | select(.role == "user") | .content[]? | .text // empty | select(startswith("# AGENTS.md instructions"))' "$1"
}
prompt_input() { # prompt_input <out json> [cwd]: codex debug prompt-input in the fake home (offline)
  mkdir -p "${2:-$H/work}"
  (cd "${2:-$H/work}" && inhome codex debug prompt-input >"$1" 2>"$1.err") || { cat "$1.err"; return 1; }
}
done_ok() { rm -rf "$S"; return 0; }   # remove the test folder on success (kept on failure)

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
ac2_first_turn_knows_rules() { fail "not written"; }
ac3_session_start_rules_fresh() { fail "not written"; }
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
