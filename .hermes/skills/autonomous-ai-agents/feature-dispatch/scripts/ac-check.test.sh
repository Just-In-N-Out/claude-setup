#!/usr/bin/env bash
# Tests for ac-check.sh. Run: bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.test.sh
# Log fixtures follow real runner output (go test -v ./..., node --test TAP and spec, pytest -v, jest).
set -uo pipefail

CHECK="$(cd "$(dirname "$0")" && pwd)/ac-check.sh"
fails=0
ok()   { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; fails=$((fails + 1)); }

root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT
repo=$root/repo ev=$root/ev
V=$ev/verifier A=$ev/auditor
gitc() { git -C "$repo" -c user.name=t -c user.email=t@t "$@"; }
mkdir -p "$repo"; git -C "$repo" init -q
echo one >"$repo/f.txt"; gitc add f.txt; gitc commit -q -m base
base=$(git -C "$repo" rev-parse HEAD)
gitc checkout -q -b other; gitc commit -q --allow-empty -m other
other=$(git -C "$repo" rev-parse HEAD)
gitc checkout -q -; gitc commit -q --allow-empty -m wip
wip=$(git -C "$repo" rev-parse HEAD)
gitc commit -q --allow-empty -m head
head=$(git -C "$repo" rev-parse HEAD)

# mklog <path> <sha> <exit> [line]... : a log as the run recipe writes it
mklog() { local p=$1 s=$2 x=$3; shift 3; { echo "HEAD=$s"; printf '%s\n' "$@"; echo "EXIT=$x"; } >"$p"; }
png() { printf '\211PNG\r\n\032\nIHDR' >"$1"; }
# fresh folders with receipts for AC1, AC2, AC10 in each
reset() {
  rm -rf "$ev"; mkdir -p "$V" "$A"
  for d in "$V" "$A"; do for ac in AC1 AC2 AC10; do
    mklog "$d/$ac.log" "$head" 0 "=== RUN   Test$ac" "--- PASS: Test$ac (0.00s)" "PASS" "ok  	example.com/m/a	0.4${#d}s"
    mklog "$d/$ac-base.log" "$base" 1 "=== RUN   Test$ac" "--- FAIL: Test$ac (0.00s)" "FAIL"
    png "$d/$ac.png"
  done; done
  mkplan "# Plan" "## Acceptance criteria" "- AC1: x" "- AC2: y"
}
# mkplan <line>...: the approved plan, naming the tests the fixtures use
mkplan() { { printf '%s\n' "$@"; echo "Tests: TestAC1, TestAC2, TestAC3, TestAC10, TestAC1/empty_list, AC1 sorts rows, test_ac1, AC1 sorts rows (by name), HEAD"; } >"$ev/plan.md"; }
# entry <dir> <ac> [accepted] [log] [base_log] [screenshot] [base_exempt] [not_run] [test]
entry() {
  local d=$1 ac=$2
  jq -nc --arg ac "$ac" --argjson acc "${3:-true}" --arg log "${4-$d/$ac.log}" --arg base "${5-$d/$ac-base.log}" \
    --arg shot "${6-$d/$ac.png}" --arg ex "${7-}" --arg nr "${8-}" --arg t "${9-Test$ac}" \
    '{ac: $ac, accepted: $acc, log: $log, screenshot: $shot, evidence: "e"}
     + (if $t == "" then {} else {test: $t} end)
     + (if $base == "" then {} else {base_log: $base} end)
     + (if $ex == "" then {} else {base_exempt: $ex} end)
     + (if $nr == "" then {} else {not_run: $nr} end)'
}
report() { local d=$1 h=$2; shift 2; printf '%s\n' "$@" | jq -s --arg h "$h" '{head: $h, ac_status: .}' >"$d/ac.json"; }
run() { out=$(bash "$CHECK" "$@" 2>&1); rc=$?; }
check() { run --repo "$repo" --base "$base" --plan "$ev/plan.md" "$V/ac.json" "$A/ac.json"; }
line() { grep -E "^$1 " <<<"$out"; }
both_ok() { report "$V" "$head" "$(entry "$V" AC1)" "$(entry "$V" AC2)"; report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2)"; }
# bad <label> <expected text> <verifier AC1 entry>: the auditor is fine, the verifier's AC1 isn't
bad() {
  report "$V" "$head" "$3" "$(entry "$V" AC2)"
  report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2)"
  check
  [[ $rc == 1 && $(line AC1) == *"NOT ACCEPTED"*"$2"* ]] && ok "$1" || fail "$1: rc=$rc out=$out"
}
# good <label> <verifier AC1 entry>: accepted
good() {
  report "$V" "$head" "$2" "$(entry "$V" AC2)"
  report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2)"
  check
  [[ $rc == 0 && $(line AC1) == "AC1  ACCEPTED" ]] && ok "$1" || fail "$1: rc=$rc out=$out"
}

# 1. both agents prove every AC
reset; both_ok; check
[[ $rc == 0 && $(tail -1 <<<"$out") == "ALL ACCEPTED: 2 of 2 ACs on ${head:0:7}" ]] \
  && ok "both prove every AC: ALL ACCEPTED, exit 0" || fail "happy path: rc=$rc out=$out"

# 2. disagreement or a non-boolean accepted
report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2 false)"; check
[[ $rc == 1 && $(line AC1) == "AC1  ACCEPTED" && $(line AC2) == *"NOT ACCEPTED"*"auditor did not accept it"* \
   && $(tail -1 <<<"$out") == "NOT ACCEPTED: 1 of 2 ACs on ${head:0:7}" ]] \
  && ok "auditor rejects AC2: only AC2 is not accepted, exit 1" || fail "disagreement: rc=$rc out=$out"
report "$A" "$head" "$(entry "$A" AC1)" "$(jq -c '.accepted = "true"' <<<"$(entry "$A" AC2)")"; check
[[ $rc == 1 && $(line AC2) == *"auditor did not accept it"* ]] && ok "accepted must be the boolean true" \
  || fail "string accepted: rc=$rc out=$out"

# 3. the head log: the AC's own test must show a pass line, and no fail or skip line
reset
bad "no test name"                       "verifier gives no test name" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/AC1.png" "" "" "")"
mklog "$V/fail.log" "$head" 1 "--- FAIL: TestAC1 (0.00s)" "FAIL"
bad "a failing test log"                 "verifier log exits 1" "$(entry "$V" AC1 true "$V/fail.log")"
mklog "$V/fail0.log" "$head" 0 "=== RUN   TestAC1" "--- FAIL: TestAC1 (0.01s)" "FAIL"
bad "a failed test with EXIT=0 (a pipe hid it)" "verifier log shows TestAC1 failing" "$(entry "$V" AC1 true "$V/fail0.log")"
mklog "$V/skip.log" "$head" 0 "=== RUN   TestAC1" "    a_test.go:16: LEORNA_TEST_DATABASE_URL not set" "--- SKIP: TestAC1 (0.00s)" "PASS"
bad "a skipped test"                     "verifier log shows skipped tests" "$(entry "$V" AC1 true "$V/skip.log")"
printf 'HEAD=%s\nEXIT=0\n--- FAIL: TestAC1\n' "$head" >"$V/midexit.log"
bad "EXIT= not on the last line"         "verifier log's last line is not EXIT=" "$(entry "$V" AC1 true "$V/midexit.log")"
printf 'HEAD=%s\n--- PASS: TestAC1 (0.00s)\nLAST_EXIT=0\n' "$head" >"$V/lastexit.log"
bad "LAST_EXIT=0 is not EXIT="           "verifier log's last line is not EXIT=" "$(entry "$V" AC1 true "$V/lastexit.log")"
bad "a missing log"                      "verifier log missing" "$(entry "$V" AC1 true "$V/nope.log")"
mklog "$V/old.log" "$base" 0 "--- PASS: TestAC1 (0.00s)"
bad "a log from an older commit"         "verifier log ran on ${base:0:7}, not ${head:0:7}" "$(entry "$V" AC1 true "$V/old.log")"
printf -- '--- PASS: TestAC1 (0.00s)\nEXIT=0\n' >"$V/nohead.log"
bad "a log without HEAD="                "verifier log ran on unknown" "$(entry "$V" AC1 true "$V/nohead.log")"
mklog "$V/noname.log" "$head" 0 "ok  	example.com/m/a	0.1s"
bad "no pass line for the test"          "verifier log shows no pass line for TestAC1" "$(entry "$V" AC1 true "$V/noname.log")"
mklog "$V/ten.log" "$head" 0 "--- PASS: TestAC10 (0.00s)"
bad "TestAC10 passing is not TestAC1"    "verifier log shows no pass line for TestAC1" "$(entry "$V" AC1 true "$V/ten.log")"
bad "a test named after the HEAD= stamp" "verifier log shows no pass line for HEAD" \
  "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/AC1.png" "" "" "HEAD")"
mklog "$V/goall.log" "$head" 0 "=== RUN   TestAC1" "--- PASS: TestAC1 (0.00s)" "PASS" "ok  	example.com/m/a	1.872s" \
  "?   	example.com/m/b	[no test files]" "testing: warning: no tests to run" "PASS" "ok  	example.com/m/c	0.986s [no tests to run]"
good "a real go test ./... run with other packages' 'no tests'" "$(entry "$V" AC1 true "$V/goall.log")"
mklog "$V/sub.log" "$head" 0 "=== RUN   TestAC1" "=== RUN   TestAC1/empty_list" "    --- PASS: TestAC1/empty_list (0.00s)" "--- PASS: TestAC1 (0.00s)"
mklog "$V/sub-base.log" "$base" 1 "    --- FAIL: TestAC1/empty_list (0.00s)" "--- FAIL: TestAC1 (0.00s)" "FAIL"
good "a Go subtest by its full name" "$(entry "$V" AC1 true "$V/sub.log" "$V/sub-base.log" "$V/AC1.png" "" "" "TestAC1/empty_list")"
mklog "$V/tap.log" "$head" 0 "TAP version 13" "# Subtest: AC1 sorts rows" "ok 1 - AC1 sorts rows" "  ---" "  duration_ms: 1.2" "1..1" "# pass 1"
mklog "$V/tap-base.log" "$base" 1 "TAP version 13" "# Subtest: AC1 sorts rows" "not ok 1 - AC1 sorts rows" "1..1" "# fail 1"
good "node --test TAP output" "$(entry "$V" AC1 true "$V/tap.log" "$V/tap-base.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/tapskip.log" "$head" 0 "ok 1 - AC1 sorts rows # SKIP" "1..1"
bad "a TAP # SKIP"                       "verifier log shows skipped tests" \
  "$(entry "$V" AC1 true "$V/tapskip.log" "$V/AC1-base.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/tapfail.log" "$head" 0 "not ok 1 - AC1 sorts rows" "1..1"
bad "a TAP not ok with EXIT=0"           "verifier log shows AC1 sorts rows failing" \
  "$(entry "$V" AC1 true "$V/tapfail.log" "$V/AC1-base.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/spec.log" "$head" 0 "✔ AC1 sorts rows (1.2ms)" "ℹ tests 1"
mklog "$V/specfail.log" "$base" 1 "✖ AC1 sorts rows (2.1ms)"
good "node --test spec output" "$(entry "$V" AC1 true "$V/spec.log" "$V/specfail.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/py.log" "$head" 0 "tests/test_sync.py::test_ac1 PASSED                [100%]"
mklog "$V/py-base.log" "$base" 1 "tests/test_sync.py::test_ac1 FAILED                [100%]"
good "pytest -v output" "$(entry "$V" AC1 true "$V/py.log" "$V/py-base.log" "$V/AC1.png" "" "" "test_ac1")"
mklog "$V/jest.log" "$head" 0 "  ✓ AC1 sorts rows (5 ms)"
mklog "$V/jest-base.log" "$base" 1 "  ✕ AC1 sorts rows (3 ms)"
good "jest output" "$(entry "$V" AC1 true "$V/jest.log" "$V/jest-base.log" "$V/AC1.png" "" "" "AC1 sorts rows")"

# 4. the base log: the same test fails on the base commit, or fails to build against it
mklog "$V/build.log" "$base" 1 "# example.com/m/a [example.com/m/a.test]" "a/a_test.go:9:5: undefined: NewThing" \
  "FAIL	example.com/m/a [build failed]" "?   	example.com/m/b	[no test files]" "testing: warning: no tests to run" "PASS" "FAIL"
good "a Go build failure on base, with other packages' 'no tests'" "$(entry "$V" AC1 true "$V/AC1.log" "$V/build.log")"
mklog "$V/nodemod.log" "$base" 1 "Error: Cannot find module '../../src/ui/sorter.ts'" "✖ test/unit/sorter.test.ts"
good "a Node test whose new source file is missing on base" "$(entry "$V" AC1 true "$V/AC1.log" "$V/nodemod.log")"
good "a spec ✖ on base, TAP on head" "$(entry "$V" AC1 true "$V/tap.log" "$V/specfail.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
bad "a test that passes on old code"     "verifier: the test passes on the old code" \
  "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1.log")"
mklog "$V/basepass.log" "$base" 0 "--- PASS: TestAC1 (0.00s)"
bad "a base run that passed"             "verifier: the test passes on the old code" "$(entry "$V" AC1 true "$V/AC1.log" "$V/basepass.log")"
bad "a missing base_log"                 "verifier base_log missing" "$(entry "$V" AC1 true "$V/AC1.log" "$V/nope.log")"
printf 'HEAD=%s\n--- FAIL: TestAC1\n' "$base" >"$V/base-noexit.log"
bad "a base_log without EXIT="           "verifier base_log's last line is not EXIT=" "$(entry "$V" AC1 true "$V/AC1.log" "$V/base-noexit.log")"
never() { # never <label> <line>...: a base run where the test never ran
  local label=$1; shift
  mklog "$V/never.log" "$base" 1 "$@"
  bad "$label" "verifier: the test didn't run on the old code" "$(entry "$V" AC1 true "$V/AC1.log" "$V/never.log")"
}
never "a base run that found no tests"      "No tests found, exiting with code 1"
never "node: the test file isn't there"     "Could not find 'test/unit/ac1.test.ts'"
never "go: the package folder isn't there"  "stat /x/missingpkg: directory not found" "FAIL	./missingpkg [setup failed]" "FAIL"
never "pytest: the file isn't there"        "ERROR: file or directory not found: tests/test_ac1.py"
never "make: no such target"                "make: *** No rule to make target 'test-ac1'.  Stop."
never "node: a package isn't installed"     "Error: Cannot find package 'left-pad' imported from /x/a.test.ts"
never "only other packages' 'no tests'"     "?   	example.com/m/b	[no test files]" "FAIL"
never "the AC's package missing, another failing to build" "stat /x/ac1pkg: directory not found" "FAIL	./ac1pkg [setup failed]" \
  "b/b.go:3:1: undefined: Gone" "FAIL	example.com/m/b [build failed]" "FAIL"
mklog "$V/passbuild.log" "$base" 1 "=== RUN   TestAC1" "--- PASS: TestAC1 (0.00s)" "b/b.go:3:1: undefined: Gone" \
  "FAIL	example.com/m/b [build failed]" "FAIL"
bad "the test passes on base while another package fails to build" "verifier: the test passes on the old code" \
  "$(entry "$V" AC1 true "$V/AC1.log" "$V/passbuild.log")"
mklog "$V/base-127.log" "$base" 127 "bash: tests/ac1.test.sh: No such file or directory"
bad "a base run that couldn't start (127)" "verifier: the test didn't run on the old code" "$(entry "$V" AC1 true "$V/AC1.log" "$V/base-127.log")"
mklog "$V/base-other.log" "$other" 1 "--- FAIL: TestAC1 (0.00s)"
bad "a base run on another branch"       "verifier base_log didn't run on the base commit ${base:0:7}" "$(entry "$V" AC1 true "$V/AC1.log" "$V/base-other.log")"
mklog "$V/base-wip.log" "$wip" 1 "--- FAIL: TestAC1 (0.00s)"
bad "a base run on the branch's own WIP commit" "verifier base_log didn't run on the base commit" "$(entry "$V" AC1 true "$V/AC1.log" "$V/base-wip.log")"
mklog "$V/base-lit.log" "HEAD" 1 "--- FAIL: TestAC1 (0.00s)"
bad "a base stamp of the word HEAD"      "verifier base_log didn't run on the base commit" "$(entry "$V" AC1 true "$V/AC1.log" "$V/base-lit.log")"
mklog "$V/base-short.log" "${head:0:7}" 1 "--- FAIL: TestAC1 (0.00s)"
bad "a base stamp of head's short sha"   "verifier base_log didn't run on the base commit" "$(entry "$V" AC1 true "$V/AC1.log" "$V/base-short.log")"
mklog "$V/base-7.log" "${base:0:7}" 1 "--- FAIL: TestAC1 (0.00s)"
good "a base stamp of base's short sha" "$(entry "$V" AC1 true "$V/AC1.log" "$V/base-7.log")"
bad "no base_log and no base_exempt"     "verifier has no base_log or base_exempt" "$(entry "$V" AC1 true "$V/AC1.log" "")"
bad "base_exempt n/a is not a reason"    "verifier base_exempt is not a reason" "$(entry "$V" AC1 true "$V/AC1.log" "" "$V/AC1.png" "n/a")"
good "base_exempt with a real reason" "$(entry "$V" AC1 true "$V/AC1.log" "" "$V/AC1.png" "the AC keeps existing export behaviour")"

# 4b. round 3: skipped children, crashes and hangs, tests the plan doesn't name
mklog "$V/subskip.log" "$head" 0 "=== RUN   TestAC1" "=== RUN   TestAC1/postgres" "    a_test.go:20: LEORNA_TEST_DATABASE_URL not set" \
  "    --- SKIP: TestAC1/postgres (0.00s)" "--- PASS: TestAC1 (0.00s)" "PASS"
bad "a skipped Go subtest under a passing parent" "verifier log shows skipped tests" "$(entry "$V" AC1 true "$V/subskip.log")"
mklog "$V/tapinner.log" "$head" 0 "# Subtest: AC1 sorts rows" "    # Subtest: real check" "    ok 1 - real check # SKIP needs Justin server" \
  "    1..1" "ok 1 - AC1 sorts rows" "1..1" "# pass 1" "# skip 1"
bad "a skipped inner TAP test under a passing suite" "verifier log shows skipped tests" \
  "$(entry "$V" AC1 true "$V/tapinner.log" "$V/tap-base.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/specinner.log" "$head" 0 "▶ AC1 sorts rows" "  ﹣ real check (0.038ms) # needs Justin server" "✔ AC1 sorts rows (1.1ms)" "ℹ skipped 1"
bad "a skipped inner spec test (reason instead of # SKIP)" "verifier log shows skipped tests" \
  "$(entry "$V" AC1 true "$V/specinner.log" "$V/specfail.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/spectodo.log" "$head" 0 "✔ AC1 sorts rows (0.5ms) # TODO"
bad "a spec # TODO is not a pass" "verifier log shows skipped tests" \
  "$(entry "$V" AC1 true "$V/spectodo.log" "$V/specfail.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/tapsum.log" "$head" 0 "ok 1 - AC1 sorts rows" "1..1" "# pass 1" "# skip 1"
bad "a TAP summary counting a skip" "verifier log shows skipped tests" \
  "$(entry "$V" AC1 true "$V/tapsum.log" "$V/tap-base.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/crash.log" "$base" 1 "=== RUN   TestAC1" "panic: boom in worker" "" "goroutine 7 [running]:" "FAIL	example.com/m/w	0.2s" "FAIL"
good "a test that starts and crashes on base" "$(entry "$V" AC1 true "$V/AC1.log" "$V/crash.log")"
mklog "$V/hang.log" "$base" 1 "=== RUN   TestAC1" "panic: test timed out after 3s" "	running tests:" "		TestAC1 (3s)" "FAIL	example.com/m/w	3.1s" "FAIL"
good "a test that starts and hangs on base" "$(entry "$V" AC1 true "$V/AC1.log" "$V/hang.log")"
mklog "$V/tapcrash.log" "$base" 1 "# Subtest: AC1 sorts rows" "Error [ERR_UNHANDLED_REJECTION]: boom"
good "a node test that starts and crashes on base" \
  "$(entry "$V" AC1 true "$V/tap.log" "$V/tapcrash.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
mklog "$V/old-pass.log" "$head" 0 "=== RUN   TestOld" "--- PASS: TestOld (0.00s)" "PASS"
mklog "$V/old-base.log" "$base" 1 "a/ac1_test.go:9:5: undefined: NewThing" "FAIL	example.com/m/a [build failed]" "FAIL"
bad "a test the approved plan doesn't name" "verifier: TestOld isn't a test the approved plan names" \
  "$(entry "$V" AC1 true "$V/old-pass.log" "$V/old-base.log" "$V/AC1.png" "" "" "TestOld")"
bad "a test name with a newline" "verifier gives a test name with control characters" \
  "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/AC1.png" "" "" $'TestAC1\nZZZ')"
mklog "$V/paren.log" "$head" 0 "✔ AC1 sorts rows (by name) (1.2ms)"
mklog "$V/paren-base.log" "$base" 1 "✖ AC1 sorts rows (by name) (2.0ms)"
good "a test name with regex characters" \
  "$(entry "$V" AC1 true "$V/paren.log" "$V/paren-base.log" "$V/AC1.png" "" "" "AC1 sorts rows (by name)")"
mklog "$V/noparen.log" "$head" 0 "✔ AC1 sorts rows by name (1.2ms)"
bad "regex characters in a name are literal" "verifier log shows no pass line for AC1 sorts rows (by name)" \
  "$(entry "$V" AC1 true "$V/noparen.log" "$V/paren-base.log" "$V/AC1.png" "" "" "AC1 sorts rows (by name)")"
mklog "$V/build0.log" "$base" 0 "a/a_test.go:9:5: undefined: NewThing" "FAIL	example.com/m/a [build failed]"
bad "a build failure with EXIT=0 on base" "verifier: the test passes on the old code" "$(entry "$V" AC1 true "$V/AC1.log" "$V/build0.log")"
mklog "$V/127build.log" "$base" 127 "SyntaxError: Unexpected token" "sh: vitest: command not found"
bad "exit 127 even with a build error on base" "verifier: the test didn't run on the old code" "$(entry "$V" AC1 true "$V/AC1.log" "$V/127build.log")"

# 4c. round 4: a skip on base, exit 127 alone, a start that exits 0, names inside plan words
mklog "$V/baseskip.log" "$base" 1 "=== RUN   TestAC1" "--- SKIP: TestAC1 (0.00s)" "b/b.go:3:1: undefined: Gone" "FAIL	example.com/m/b [build failed]" "FAIL"
bad "a test that skipped on base, with another package failing" "verifier: the test didn't run on the old code" \
  "$(entry "$V" AC1 true "$V/AC1.log" "$V/baseskip.log")"
mklog "$V/only127.log" "$base" 127 "SyntaxError: Unexpected token"
bad "exit 127 alone (a build error but no other never-ran sign)" "verifier: the test didn't run on the old code" \
  "$(entry "$V" AC1 true "$V/AC1.log" "$V/only127.log")"
mklog "$V/start0.log" "$base" 0 "=== RUN   TestAC1"
bad "a test that started on base and exited 0" "verifier: the test passes on the old code" \
  "$(entry "$V" AC1 true "$V/AC1.log" "$V/start0.log")"
mklog "$V/tapskipped.log" "$head" 0 "ok 1 - AC1 sorts rows" "1..1" "# pass 1" "# skipped 1"
bad "a real node TAP summary '# skipped 1'" "verifier log shows skipped tests" \
  "$(entry "$V" AC1 true "$V/tapskipped.log" "$V/tap-base.log" "$V/AC1.png" "" "" "AC1 sorts rows")"
{ printf -- '- AC1: x\n- AC2: y\n'; echo "Tests: TestAC10, TestAC2"; } >"$ev/plan-sub.md"
report "$V" "$head" "$(entry "$V" AC1)" "$(entry "$V" AC2)"; report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2)"
run --repo "$repo" --base "$base" --plan "$ev/plan-sub.md" "$V/ac.json" "$A/ac.json"
[[ $rc == 1 && $(line AC1) == *"TestAC1 isn't a test the approved plan names"* ]] \
  && ok "a test name inside a longer plan name (TestAC10) doesn't count" || fail "name boundary: rc=$rc out=$out"

# 5. screenshots and folders
bad "a missing screenshot"               "verifier screenshot is not an image file in its folder" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/nope.png")"
bad "a folder as the screenshot"         "verifier screenshot is not an image file in its folder" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V")"
bad "the log as the screenshot"          "verifier screenshot is not an image file in its folder" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/AC1.log")"
printf 'not an image' >"$V/fake.png"
bad "a text file named .png"             "verifier screenshot is not an image file in its folder" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/fake.png")"
printf '\377\330\377\340JFIF' >"$V/shot.jpg"
good "a real JPEG screenshot" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/shot.jpg")"
bad "the auditor's log in the verifier's report" "verifier uses a receipt outside its own folder" "$(entry "$V" AC1 true "$A/AC1.log")"
ln -sf "$A/AC1.png" "$V/link.png"
bad "a symlink to the auditor's screenshot" "verifier uses a receipt outside its own folder" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/link.png")"
ln -f "$A/AC1.png" "$V/hard.png"
bad "a hard link to the auditor's screenshot" "the two reports share a receipt file" "$(entry "$V" AC1 true "$V/AC1.log" "$V/AC1-base.log" "$V/hard.png")"

# 6. reports and worktree must match HEAD
reset
report "$V" "$base" "$(entry "$V" AC1)" "$(entry "$V" AC2)"; report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2)"; check
[[ $rc == 1 && $(line AC1) == *"verifier checked ${base:0:7}, the worktree is at ${head:0:7}"* ]] \
  && ok "a report for another commit is not accepted" || fail "stale report: rc=$rc out=$out"
report "$V" "${head:0:3}" "$(entry "$V" AC1)" "$(entry "$V" AC2)"; check
[[ $rc == 1 && $(line AC1) == *"verifier checked"* ]] && ok "a head under 7 characters is not accepted" || fail "short head: rc=$rc out=$out"
both_ok; echo two >"$repo/f.txt"; check
[[ $rc == 1 && $(tail -1 <<<"$out") == *"NOT ACCEPTED: the worktree has uncommitted changes (f.txt)"*"commit them, or remove tool scratch"* ]] \
  && ok "uncommitted changes are never accepted, and named" || fail "dirty: rc=$rc out=$out"
git -C "$repo" checkout -q -- f.txt; mkdir -p "$repo/.superpowers"; touch "$repo/.superpowers/progress.md"; check
[[ $rc == 1 && $out == *"uncommitted changes (.superpowers/)"* ]] && ok "an untracked folder counts, and is named" || fail "untracked: rc=$rc out=$out"
rm -rf "$repo/.superpowers"

# 7. every AC counts, once
both_ok; mkplan "- AC1: x" "- AC2: y" "- AC3: z"; check
[[ $rc == 1 && $(line AC3) == *"verifier has no entry"*"auditor has no entry"* ]] \
  && ok "a plan AC both agents skipped is not accepted" || fail "plan AC: rc=$rc out=$out"
mkplan "- AC1: x" "- AC2: y"
report "$A" "$head" "$(entry "$A" AC1)"; check
[[ $rc == 1 && $(line AC2) == *"auditor has no entry"* ]] && ok "an AC one agent skipped is not accepted" || fail "one-sided: rc=$rc out=$out"
report "$V" "$head" "$(entry "$V" AC1)" "$(entry "$V" AC1 false)" "$(entry "$V" AC2)"; report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2)"; check
[[ $rc == 1 && $(line AC1) == *"verifier lists AC1 twice"* ]] && ok "an AC listed twice is not accepted" || fail "duplicate: rc=$rc out=$out"
report "$V" "$head" "$(entry "$V" AC1)" "$(entry "$V" AC10)" "$(entry "$V" AC2)"
report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC10)" "$(entry "$A" AC2)"
mkplan "- AC1" "- AC2" "- AC10"; check
[[ $(grep -oE '^AC[0-9]+' <<<"$out" | tr '\n' ' ') == "AC1 AC2 AC10 " ]] && ok "ACs are listed in number order" || fail "order: $out"

# 8. (live): only the planner's tag right after the AC id; a recorded failure still blocks
nr() { entry "$1" "$2" false "" "" "" "" "live: needs Justin's server"; }
live() { mkplan "$@"; check; }
report "$V" "$head" "$(entry "$V" AC1)" "$(nr "$V" AC2)"; report "$A" "$head" "$(entry "$A" AC1)" "$(nr "$A" AC2)"
live "- AC1: x" "- AC2 (live): publish then Sync shows the item"
[[ $rc == 0 && $(line AC2) == "AC2  NOT VERIFIED (live: the user checks it)" \
   && $(tail -1 <<<"$out") == "READY FOR THE USER: 1 of 2 ACs proven on ${head:0:7}; live ACs owed to the user: AC2" ]] \
  && ok "a (live) AC both agents couldn't run is owed to the user" || fail "live owed: rc=$rc out=$out"
for form in "- **AC2** (live): publish" "- AC2 (proposed) (live): publish" "- AC2 (live, proposed): publish" \
            "- AC2 (proposed, live): publish" "- [ ] AC2 (live): publish" "### AC2 (live) publish" "| AC2 (live) | publish |" \
            "1. AC2 (live): publish"; do
  live "- AC1: x" "$form"
  [[ $rc == 0 && $(line AC2) == *"NOT VERIFIED (live"* ]] && ok "live tag form: $form" || fail "live form '$form': rc=$rc out=$out"
done
report "$A" "$head" "$(entry "$A" AC1)" "$(entry "$A" AC2 false)"
live "- AC1: x" "- AC2 (live): publish"
[[ $rc == 1 && $(line AC2) == *"NOT ACCEPTED"* ]] && ok "a (live) AC an agent saw fail still blocks" || fail "live failed: rc=$rc out=$out"
report "$V" "$head" "$(nr "$V" AC1)" "$(nr "$V" AC2)"; report "$A" "$head" "$(nr "$A" AC1)" "$(nr "$A" AC2)"
for form in "- AC2 (live): publish, and AC1 export still works" "- AC1: the badge shows Connected (live)" \
            "Note: AC1 (live) was discussed" "- AC1 (lively): x"; do
  live "- AC1: export" "- AC2 (live): publish" "$form"
  [[ $rc == 1 && $(line AC1) == *"NOT ACCEPTED"* ]] && ok "not a live tag for AC1: $form" || fail "live grab '$form': rc=$rc out=$out"
done
report "$V" "$head" "$(nr "$V" AC1)" "$(entry "$V" AC2)"; report "$A" "$head" "$(nr "$A" AC1)" "$(entry "$A" AC2)"
live "- AC1: x" "- AC2: y"
[[ $rc == 1 && $(line AC1) == *"NOT ACCEPTED"* ]] && ok "not_run doesn't excuse an AC that isn't (live)" || fail "not_run plain: rc=$rc out=$out"

# 9. paths relative to the report's folder and to ~/
reset; mkdir -p "$root/home/ev/v" "$root/home/ev/a"
for d in "$root/home/ev/v" "$root/home/ev/a"; do cp "$V/AC1.log" "$V/AC1-base.log" "$d/"; png "$d/AC1.png"; done
report "$root/home/ev/v" "$head" "$(entry x AC1 true AC1.log AC1-base.log AC1.png)"
report "$root/home/ev/a" "$head" "$(entry x AC1 true '~/ev/a/AC1.log' '~/ev/a/AC1-base.log' '~/ev/a/AC1.png')"
mkplan "- AC1"
out=$(HOME=$root/home bash "$CHECK" --repo "$repo" --base "$base" --plan "$ev/plan.md" "$root/home/ev/v/ac.json" "$root/home/ev/a/ac.json" 2>&1); rc=$?
[[ $rc == 0 ]] && ok "relative and ~/ paths resolve" || fail "paths: rc=$rc out=$out"

# 10. bad usage or input: exit 2
reset; both_ok; P=$ev/plan.md
two() { [[ $rc == 2 ]] && ok "$1" || fail "$1: rc=$rc out=$out"; }
run --repo "$repo" --base "$base" "$V/ac.json" "$A/ac.json";                 two "missing --plan exits 2"
run --repo "$repo" --plan "$P" "$V/ac.json" "$A/ac.json";                    two "missing --base exits 2"
run --base "$base" --plan "$P" "$V/ac.json" "$A/ac.json";                    two "missing --repo exits 2"
run --repo "$repo" --base nope --plan "$P" "$V/ac.json" "$A/ac.json";        two "an unknown --base exits 2"
run --repo "$repo" --base "$head" --plan "$P" "$V/ac.json" "$A/ac.json";     two "--base equal to HEAD exits 2"
run --repo "$repo" --base "$other" --plan "$P" "$V/ac.json" "$A/ac.json";    two "--base not under HEAD exits 2"
run --repo "$repo" --base "$base" --plan "$P" "$V/ac.json";                  two "one report exits 2"
run --repo "$repo" --base "$base" --plan "$P" "$V/ac.json" "$V/ac.json";     two "the same report twice exits 2"
cp "$A/ac.json" "$V/ac2.json"
run --repo "$repo" --base "$base" --plan "$P" "$V/ac.json" "$V/ac2.json";    two "both reports in one folder exits 2"
rm "$A/ac.json"; ln "$V/ac.json" "$A/ac.json"
run --repo "$repo" --base "$base" --plan "$P" "$V/ac.json" "$A/ac.json";     two "a hard-linked report exits 2"
reset; both_ok
mkdir -p "$V/sub"; cp "$A/ac.json" "$V/sub/ac.json"
run --repo "$repo" --base "$base" --plan "$P" "$V/ac.json" "$V/sub/ac.json"; two "the auditor's folder inside the verifier's exits 2"
mkdir -p "$A/sub"; cp "$V/ac.json" "$A/sub/ac.json"
run --repo "$repo" --base "$base" --plan "$P" "$A/sub/ac.json" "$A/ac.json"; two "the verifier's folder inside the auditor's exits 2"
printf -- '- AC-1: x\n1. y\n' >"$ev/noac.md"
run --repo "$repo" --base "$base" --plan "$ev/noac.md" "$V/ac.json" "$A/ac.json"; two "a plan with no AC<n> exits 2"
{ printf -- '- AC1: x\n- AC2: y\nOld card: see AC4 there; the AC1s from it; it("AC1_export")\n'; echo "Tests: TestAC1, TestAC2"; } >"$ev/prose.md"
run --repo "$repo" --base "$base" --plan "$ev/prose.md" "$V/ac.json" "$A/ac.json"
[[ $rc == 0 ]] && ok "AC ids in prose (AC4, AC1s, AC1_export) are neither required nor errors" || fail "prose ids: rc=$rc out=$out"
printf -- '- AC1: x\n- AC2a: y\n' >"$ev/ac2a.md"
run --repo "$repo" --base "$base" --plan "$ev/ac2a.md" "$V/ac.json" "$A/ac.json"; two "a plan with an AC2a-style id exits 2"
run --repo "$repo" --base "$base" --plan "$ev/none.md" "$V/ac.json" "$A/ac.json"; two "a missing plan exits 2"
printf 'not json' >"$A/bad.json"
run --repo "$repo" --base "$base" --plan "$P" "$V/ac.json" "$A/bad.json";    two "an unreadable report exits 2"
run --repo "$root" --base "$base" --plan "$P" "$V/ac.json" "$A/ac.json";     two "a folder that isn't a git worktree exits 2"

echo
[[ $fails == 0 ]] && echo "all passed" || echo "$fails failed"
exit $((fails > 0))
