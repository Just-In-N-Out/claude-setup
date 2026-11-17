---
name: test-driven-development
description: "TDD: enforce RED-GREEN-REFACTOR, tests before code."
version: 1.1.1
author: Hermes Agent (adapted from obra/superpowers)
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [testing, tdd, development, quality, red-green-refactor]
    related_skills: [systematic-debugging, subagent-driven-development]
---

# Test-Driven Development (TDD)

## Overview

Load `engineering-best-practices` first. This skill supplies the test-first method
inside its Build loop; inherit the same acceptance, owner, estimate, spent attempts,
authority and stop conditions. Use the repository's runner. No separate tracker,
agent team or new dependency is required.

Write the behavioral test first, observe the intended failure, then make the
smallest sound repair and refactor with relevant tests green. A failure must be
caused by the missing/wrong behavior, not setup; it demonstrates sensitivity to
that case, not complete correctness.

## When to Use

- New features, bug fixes and intentional behavior changes: observed RED before
  implementation is the default and any stricter project rule remains binding.
- Refactoring existing behavior: characterization/regression checks may start
  green. Preserve behavior and use focused sensitivity proof when needed; do not
  introduce a fake defect merely to get RED.
- Docs/config/generated output: use applicable link/schema/generator/build checks;
  use behavioral tests when runtime effects change. Follow the primary skill's
  scope decision instead of asking for another approval for an already covered
  method. Missing required proof is blocked, not permission to skip it.

## Ownership and honest chronology

Never delete user code, reviewed/frozen inputs, predecessor evidence or unrelated
partial work to restart TDD. Preserve unvalidated task-owned code and disclose
post-hoc tests if implementation already exists; do not relabel it test-first.
If a strict RED-first gate is required, recover only the authorized task-owned
baseline in an isolated copy and execute the causal slice there; retained partial
work is not authority to overwrite the real candidate. No automatic rewrite for
ceremony. Record the public caller, unchanged oracle/source identities and real
exits before crediting RED/GREEN.

Reproduce defects only inside the actual path/execution grant. Static review
inspects recorded evidence without running the product. Generic notices do not
refill a launch cap or deadline. Full-suite checks obey the actual allocation;
required gates lacking resources remain blocked and explicitly unrun.

## Red-Green-Refactor Cycle

### RED — Write Failing Test

Write one minimal test showing what should happen.

**Good test:**
```python
def test_retries_failed_operations_3_times():
    attempts = 0
    def operation():
        nonlocal attempts
        attempts += 1
        if attempts < 3:
            raise Exception('fail')
        return 'success'

    result = retry_operation(operation)

    assert result == 'success'
    assert attempts == 3
```
Clear name, tests real behavior, one thing.

**Bad test:**
```python
def test_retry_works():
    mock = MagicMock()
    mock.side_effect = [Exception(), Exception(), 'success']
    result = retry_operation(mock)
    assert result == 'success'  # What about retry count? Timing?
```
The retry loop is real, but this assertion misses retry count. A fake operation
is acceptable; replacing the retry loop itself would avoid testing the contract.

**Requirements:**
- One coherent behavior per test; multiple meaningful assertions are fine.
- Name describes the observable behavior, not internal implementation.
- Keep the system under test real; fake external cost/failure/clock boundaries
  deliberately and state what live integration remains unproven. When an AC is live-only
  (the user runs it), dry-run its test end to end against the offline stub first, so
  plumbing bugs surface before the user's live run (cortexos-memory-hook AC15: 3 found). A logging shim used by parallel callers must write each line with one `printf` (build it in a variable first): several printfs per line interleave and make `grep -c .` undercount calls (cortexos-memory-hook verifier 3: 122 vs 129).

### Verify RED — Watch It Fail

**MANDATORY. Never skip.**

```bash
# Use terminal tool to run the specific test
pytest tests/test_feature.py::test_specific_behavior -v
```

Confirm:
- Test fails (not errors from typos)
- Failure message is expected
- Fails because the feature is missing

**Test passes immediately?** Check whether the defect is reproduced at the real
caller with realistic inputs. An existing-behavior/added-coverage test can
legitimately start green; label it honestly and establish sensitivity when needed.
Do not weaken or distort its oracle to manufacture a failure.

**Test errors?** Diagnose setup within the primary skill's existing time/repair
allowance; an import/fixture failure is not the intended RED (so a test file meant
to go RED on the old tree imports none of the fix's new exports: tests of a new
helper go in their own file; site-menu fixer 1). Narrow or block,
never rerun indefinitely.

### GREEN — Minimal Code

Write the simplest code to pass the test. Nothing more.

**Good:**
```python
def add(a, b):
    return a + b  # Nothing extra
```

**Bad:**
```python
def add(a, b):
    result = a + b
    logging.info(f"Adding {a} + {b} = {result}")  # Extra!
    return result
```

Don't add features, refactor other code, or "improve" beyond the test.

Minimal does not mean a test-specific hardcode or omitted acceptance cases.
Generalize to the contract and add relevant boundary/negative cases through
small vertical cycles; never ship a single-example shortcut as the full outcome.

### Verify GREEN — Watch It Pass

**MANDATORY.**

```bash
# Run the specific test
pytest tests/test_feature.py::test_specific_behavior -v

# At the integration/completion boundary, run configured required gates.
# Example only, if this is the repository's actual regression command:
pytest tests/ -q
```

Confirm:
- The unchanged test passes for the expected reason and actually executed.
- Affected regression and required project checks pass at their proper boundary;
  do not run every expensive suite after every line or silently omit a required gate.
  Run the quick whole suite (e.g. `npm run check`) right after the targeted tests go
  GREEN and before ledger commits or long gates: targeted ACs can pass while other unit
  tests are red (plugin-parity fixer 3: 11 reds found only at the long gate, two restarts).
- Preserve baseline/new failures, skips/xfails, warnings and retries; exit zero
  or zero executed cases alone is not proof.

**Test fails?** Diagnose the implementation or fixture against the contract; do
not weaken assertions to get green. Fix introduced regressions within the existing
repair allowance; required unresolved checks block completion.

### REFACTOR — Clean Up

After green only:
- Remove duplication
- Improve names
- Extract helpers
- Simplify expressions

Keep tests green throughout. Don't add behavior.

**If tests fail during refactor:** Preserve the failure; restore only your owned
change to its known-green bytes, verify restoration, then take a smaller step
within the inherited allowance. Never reset unrelated working-tree changes.

### Repeat

Next failing test for next behavior. One cycle at a time.

## Avoid Horizontal Slices

Do **not** write all tests first and then all implementation. That is horizontal slicing: RED becomes "write a pile of imagined tests" and GREEN becomes "make the pile pass." It produces brittle tests because the tests are designed before the implementation has taught you what behavior and interface actually matter.

Use vertical tracer bullets instead:

```text
WRONG:
  RED:   test1, test2, test3, test4
  GREEN: impl1, impl2, impl3, impl4

RIGHT:
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
```

A tracer bullet is one end-to-end behavior slice. It proves the path works, teaches you about the interface, and keeps each next test grounded in what you just learned.

## Evidence and stopping rules

- Test-first gives causal failure evidence for the selected behavior; it does
  not guarantee complete coverage or prove every assertion is sensitive.
- Characterization, later-added tests and documented manual checks are useful
  evidence with different scope. Never invent RED, human acceptance or live
  integration proof from them.
- Use `mutation-testing-discipline` for doubtful sensitivity or critical guards.
  A focused observed regression RED need not trigger another full mutation run.
- Inspect one hypothesis at a time. The primary skill's time/resource/repair
  allowance is shared, not restarted per test or specialist. Preserve failures
  and narrow or block on expiry; no rerun-until-green or delete-and-restart loop.

## Verification Checklist

Before marking the requested milestone complete:

- [ ] Each acceptance/risk has an appropriate check at the right layer.
- [ ] Claimed test-first cases have observed intended RED and unchanged-oracle GREEN;
      characterization/later tests are distinguished honestly.
- [ ] Real caller, relevant boundary/error cases and assertion sensitivity covered.
- [ ] Expected cases actually executed; baseline/new failures, skips and flakes visible.
- [ ] Affected regression, combined integration and required project checks accounted
      for on current source/test identities; missing required gates stay blocked.
- [ ] Owned work preserved, actual commands/results retained and resources cleaned up.

An unmet box needs a specific repair or disclosed blocker, not automatic deletion
or a new clock.

## When Stuck

| Problem | Solution |
|---------|----------|
| Don't know how to test | Write the wished-for API. Write the assertion first. Ask the user. |
| Test too complicated | Design too complicated. Simplify the interface. |
| Must mock everything | Code too coupled. Use dependency injection. |
| Test setup huge | Extract helpers. Still complex? Simplify the design. |

## Hermes Agent Integration

### Running Tests

Use the `terminal` tool to run tests at each step:

```python
# RED — verify failure
terminal("pytest tests/test_feature.py::test_name -v")

# GREEN — verify pass
terminal("pytest tests/test_feature.py::test_name -v")

# Configured regression gate at the appropriate boundary (example only)
terminal("pytest tests/ -q")
```

### With delegate_task

When dispatching subagents for implementation, enforce TDD in the goal:

```python
delegate_task(tasks=[{
    "goal": "Implement the scoped feature using strict vertical TDD",
    "context": """
    Load engineering-best-practices first, then test-driven-development.
    Inherit the parent's acceptance, estimates, spent attempts and stop conditions.
    Follow TDD within the explicit path and execution grant:
    1. Write one failing public-caller test FIRST.
    2. Run its admitted command; retain the expected real RED and input hashes.
    3. Write the minimal owned implementation.
    4. Run unchanged-oracle GREEN and the admitted regression population.
    5. Refactor only within remaining allowance; requalify changed final bytes.
    6. Report real results, exact artifact paths, budget/cleanup and missing gates.
       Commit only when explicitly authorized with an exclusive Git-index owner.

    Supply exact interpreter/cwd/paths, source pins, test commands, integer
    resource/launch limits, deadline/report reserve and stop conditions here.
    Do not infer that an all-tests example overrides a narrower allocation.
    """
}])
```

### With systematic-debugging

Bug found? Write failing test reproducing it. Follow TDD cycle. The test proves the fix and prevents regression.

Never fix bugs without a test.

## Testing Anti-Patterns

- **Testing mock behavior instead of real behavior** — mocks should verify interactions, not replace the system under test
- **Testing implementation details** — test behavior/results, not internal method calls
- **Happy path only** — always test edge cases, errors, and boundaries
- **An assertion behind a found-element guard** — `if (el && …) assert(…)` checks nothing when the lookup misses: assert the lookup first, then the property (mobile-fit AC6: the FAQ's span check never ran because Elementor folded the wrapper; caught only by a missing screenshot)
- **Brittle tests** — tests should verify behavior, not structure; refactoring shouldn't break them
- **A retry that hides a side effect** — when a test gains a retry of a flaky step, keep every side-effect check (a write outside the sandbox, a leaked session) on every attempt, the abandoned one included; only the success checks belong to the attempt that counts. Pin it with a fake case where the abandoned attempt leaves the side effect and the retry is clean (dream-pass R13-1)
- **Races that never race** — a test of work running side by side can pass on buggy code because a fast stand-in never overlaps; slow the transport (answer calls N ms later) and assert the overlap really happened (capture-speed fixer 1). A byte-for-byte check of a file side-by-side workers write in completion order (a record keyed as uploads answer) fails only under load: compare it parsed and prove the loosening with an order-only mutant the old test kills (importer-app builder). Assert a secret box is empty by its length, never by value: a failure diff prints the secret. A byte compare across two stand-ins differing only by port breaks on any digest of text holding the address (substitution can't reach inside a hash): compare such a file by its readable parts (short-class-names builder). For a new module, import it dynamically after a behaviour assertion so the old tree fails by assertion, not import error. Look at each AC's picture before closing: a box-only receipt can't see a part showing inside a hidden box (forms-wpforms: a lone required "*"). A test that answers a child's prompts by matching its accumulated output with an end-anchored pattern types an answer twice when a prompt prints no newline after a piped answer: answer each prompt once from a step list, or have the tool end the line after a non-terminal answer (site-media-upload builder: the password was read as the "yes")
- **Bash test idioms that hide a failure** — under `set -o pipefail`, `producer | grep -q pat` reads as "no match" at random once the producer writes more than a pipe buffer (about 64 KB): `grep -q` exits at the first match and the producer dies of SIGPIPE, so use `grep pat >/dev/null` or grep a file (dream-trim builder: an 80 KB list failed AC6 once). The same SIGPIPE hits a hook test that feeds stdin with `printf json | bash "$HOOK"`: a hook that exits before reading stdin kills the writer and the pipeline returns 141, only under CPU load, so feed stdin from a file (a here-string works but adds a newline, which changes an exact-bytes or empty-input case) and rerun a new hook suite about 30 times under a short CPU burst, since 9 runs can miss it (dream-pass verifier 1 and fixer 7: 7 of 30 failed under load, 0 of 30 alone). And `cmd && fail "msg" && return 1` prints FAIL and keeps going when `fail` returns 1, so the control never fails on its own: write `if cmd; then fail "msg"; return 1; fi`, grep the whole suite for the rest, and prove each control with an exit-code-only mutant (the checker still prints FAIL but exits 0), since a control that greps the output still passes (dream-trim fixer 1, verifier)

## Final Rule

Claim TDD only for observed intended RED → unchanged-oracle GREEN. Report other
valid verification by its actual method. The primary engineering contract owns
completion; this method does not waive required checks or grant extra execution.
