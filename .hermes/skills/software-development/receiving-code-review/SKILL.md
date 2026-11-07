---
name: receiving-code-review
description: "Use when acting on review findings; verify each first."
version: 0.1.0
author: Justin (Just-In-N-Out), Hermes Agent (adapted from obra/superpowers receiving-code-review, MIT)
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [code-review, review-feedback, verification, pushback, tdd]
    related_skills: [requesting-code-review, test-driven-development, github, leorna, figma-to-bricks]
---

# Receiving Code Review

Turn a review report into verified fixes and reasoned pushback. Understand the complete report and dependencies first, then check each finding against the real code before making its fix. A reviewer can be wrong, can lack context, or may never have run anything.

**Core rule:** verify, then act. Technical correctness over agreement.

## When to Use

- Justin pastes a reviewer's report: a fresh agent from the review prompt, an Opus review, a teammate, or GitHub PR comments
- A `delegate_task` reviewer (including `requesting-code-review` Step 5) returns findings
- Justin says "fix these", "the reviewer said…", "round 2 report"
- Don't use for: reviewing someone else's PR (`github` skill), or the pre-commit review itself (`requesting-code-review`)

## Procedure

1. **Read the whole report first.** Number every finding, restate each in one plain line, and identify dependencies before editing. Hold unclear findings and anything that depends on them; continue only demonstrably independent, already-authorized fixes. If independence cannot be established, clarify the affected group before implementation. Done when every finding is understood or explicitly held with its dependency and missing decision.

2. **Verify each finding in the code.** Read the code it cites (`read_file`, `search_files`). Then prove or disprove the claim:
   - Bug claims: write a failing test or a small probe that reproduces it.
   - Tool or platform claims ("Codex does X", "Windows breaks Y"): run the real tool, or check its docs.
   - "Missing" or "should be added": search for real usage first. If nothing uses it, it's YAGNI.
   - Claims backed by no command output: treat them as unverified and run the commands yourself.
   - Stale comment or doc after a rule changed: also search the diff for the old rule restated in other words (its consequences, not just the cited wording); reviewers cite one site (901y fixer 2 found a second; 901j fixer 9 found two more). A wording-only fix proves the code unchanged: in Go, print each file with `go/parser` (no `ParseComments`) and `go/printer` before and after and require byte-equal output, failing closed on a non-zero exit or empty output (with no `go` on PATH, two empty outputs compare equal), plus one control edit that must show as different.

3. **Give each finding a verdict:**
   - **Valid, introduced:** this branch caused it. Fix it here.
   - **Valid, pre-existing:** the bug was already on main, or comes from a repo-wide pattern. Don't fix it inside the story; list it as a follow-up (Leorna `consistency-over-local-fixes`).
   - **Not valid:** push back, with evidence (a test, a command output, a file and line).
   - **Can't verify:** say what's missing ("needs Windows CI", "needs the live server") and ask how to proceed.

   Also give a severity (blocker / high / low). Check every verdict against Justin's earlier decisions: Figma `CLAUDE.md` "Decisions the user made", and the Leorna notes' "Justin's decisions". If a finding would reverse one, stop and ask him.

4. **Separate bug corrections from product decisions.** Restoring already-approved behaviour does not require another design pick. A new fallback, rejection rule, accepted limitation, reversal of an earlier decision, or data/API contract change outside the approved plan does require Justin's decision. Send a short 1-3-1 (`one-three-one-rule`): the problem, three options with user-visible tradeoffs, your pick. Hold only decision-dependent work; use `review-fix-cadence` to continue independent fixes. Record the exact answer in the plan, current brief, board and handoff before steering the existing fixer; do not restart completed work. Preserve any explicit separate-go gate: selecting a policy is not blanket build, release or publication permission.

5. **Fix, one finding at a time, test first.** Order: blockers (security, data loss, broken acceptance criteria), then simple fixes, then complex ones. For each:
   - the test fails for the right reason;
   - fix;
   - the test passes;
   - where the project requires it, prove the test catches the bug (mutate or revert the fix, see it fail, restore).

   For a resource-guard or rendering-fallback regression, freeze the approved ordinary-output behavior, fallback trigger and existing safety/size bounds before editing. An implementation threshold is not user acceptance of a lower effective input or formatting limit. Pair realistic ordinary and code-heavy inputs at small, intermediate and maximum supported sizes with the original pathological families and mixed benign/adversarial regions; uniform padding proves byte capacity, not realistic behavior. Assert preserved output semantics and no needless fallback for ordinary inputs, and retained protection for costly inputs. Prove sensitivity in both directions with unaffected controls green. Replace tests that encode the rejected heuristic with stronger independent contract oracles, rather than skipping protection coverage or preserving the heuristic as product policy. Use [resource-guard regression checks](references/resource-guard-regressions.md) for the focused validation matrix; it does not prescribe an unverified replacement algorithm.

   For a coverage-only finding where production is already correct, use honest sensitivity evidence instead of inventing a product RED: record the green baseline and a compile-valid mutant surviving the old tests (Go, same tree and same mutated bytes: keep the new tests uncommitted, run the packages with `go test -skip '^(NewA|NewB)$'`, then `-run` the new ones; new subtests of an existing test skip as `-skip '^Parent$/^(subA|subB)$'`; with the mutant held in a `-overlay`, the new tests can be committed first so the receipt binds to a SHA); add independent cases that reject the identical mutant for the intended assertion; restore and prove GREEN. Keep positive controls passing. Use `mutation-testing-discipline` for qualification.

   Commit per the project's rules. Add newly approved decision-dependent work as a separate named task/commit at a dependency-safe boundary, rather than folding it into completed fixes.

6. **Re-run the full gates** after the last fix: Leorna's `make check` set, or Figma's `npm run check` plus `npm run corpus`. Two correct fixes can still break each other. When a fix widens what a guard scans or matches, replay real recorded inputs (for a Claude Code hook, the transcripts' commands) before committing it, because hand-written controls miss false denies.

7. **Report back:**
   - a one-line verdict;
   - a table: # | finding | verdict | evidence | fix (commit) or reason;
   - the follow-ups list;
   - any open questions.

   For another round, give a fresh review prompt that lists every previous finding and the claimed fix for each (Leorna `review-prompt-for-agent.md` format).

8. **Record what you learned:** Leorna in the shared notes, the Figma plugin in `docs/HANDOFF.md` / the ledger.

## How to answer

- No performative agreement or thanks ("Great catch!", "You're absolutely right!"). State the fix: "Fixed: X in `file:line`, test `TestY`."
- Pushback is technical: what you checked, what it showed, and what would change your mind.
- If your pushback was wrong: "Checked again: you were right because X. Fixing." Say it once and move on.
- Never post replies on GitHub or ClickUp unless Justin asks. When he does, reply in the inline thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level comment.

## Pitfalls

- **Do not send known unfixed blockers to the next reviewer by default.** For multi-review work, load `review-fix-cadence`: verified Sol fixes precede the next unstarted independent review of the corrected candidate. This is not approval for a product-policy change, self-review, release or skipped verification.

- **Verify execution claims against raw receipts and the tested revision.** A source-only review can identify defects but cannot establish passing tests or mutation kills; route missing execution to the authorized review/validation owner.
- **A suggested fix is a hypothesis.** For a performance finding, time each stage of the cited code before adopting it (the cited jq dedupe was 9.6 s of 33 s; an uncited `splits` was 22 s), and check what a suggested input cut does to length-based filters: cutting a prompt at 4000 characters split a `ghp_` token below the 16-character secret filter and leaked its prefix (cortexos-memory-hook fixer 1).
- **Disprove a finding with a discriminating test, not intuition.** Green ordinary tests can miss the invariant the reviewer challenged. When the reviewer's probe shows a consequence with two causes (one of them a separate finding), make a variant probe without the other cause and run it on a base archive and on the fix; on the original probe alone a fixed consequence still looks unfixed (web-capture fixer 2).
- **Probe competing tool or platform explanations.** Plausible reasoning on either side is not evidence; use the real tool or primary documentation within the approved scope.
- **Fixing a pre-existing pattern in a feature branch** grows the diff and decides team-wide behaviour alone. List it as a follow-up instead.
- **Batching fixes without tests** hides which change broke what.

## Verification

- Every finding has a verdict, with evidence from this session.
- TDD evidence matches the change type: regression RED/GREEN for a product fix, or an old-test survivor/new-test intended mutant failure/restored GREEN for coverage-only work.
- The full gates are green after the last fix.
- Nothing Justin decided earlier was reversed without asking him.
