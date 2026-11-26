---
name: requesting-code-review
description: "Use when reviewing changes before commit or release."
version: 2.2.0
author: Hermes Agent (adapted from obra/superpowers + MorAlekss)
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [code-review, security, verification, quality, pre-commit]
    related_skills: [engineering-best-practices, subagent-driven-development, test-driven-development, mutation-testing-discipline, github]
---

# Pre-Commit Code Verification

Load `engineering-best-practices` first. Verify one explicit candidate through
**pin scope → inspect risk → execute admitted checks → independent review →
authorized correction → report**. Inherit the project's authority, models,
required gates, remaining allowance and stopping point; do not invent another
tracker, automatic publication or a competing agent lifecycle.

## When to use

- Verify a feature, repair or substantive refactor before commit or release.
- Perform a fresh independent review in an agent delivery pipeline.
- Review behavior-affecting configuration, workflows and security controls as
  well as source. A file extension is not grounds for skipping verification.
- Use the `github` skill additionally for hosted PR threads, checks or posting.

## 1. Pin the candidate and the role

1. Resolve the actual Git root, project instructions, branch/worktree, complete
   status and requested scope before reading the diff.
2. For a committed story, review the **entire assigned base-to-head range**, not
   only the last commit. An empty index does not mean there is nothing to review;
   the last commit may contain documentation while earlier commits contain code.
3. For staged or uncommitted review, identify the exact staged/working-tree
   candidate, include owned new files and preserve unrelated changes. Never stage
   files merely to make a diff appear, or tell the user to stage already-committed
   work. Record source and test identities before checks.
4. Distinguish coordinator/implementer from **read-only reviewer**. A dispatched
   reviewer reports only: skip nested reviewer spawning, auto-fix and commit steps.
   The parent owns later pipeline transitions. Do not run application tests or
   solve source defects in a manager-only dispatcher.

## 2. Inspect the complete risk boundary

- Inspect changed behavior, relevant callers and existing tests against the plan
  and acceptance criteria, not just added lines. When the plan embeds full code, first diff its
  fenced blocks (cut by `sed -n` line range) against the built files: it proves plan
  compliance in seconds and shows where the review is really judging the plan's design. Check trust, input/path validation,
  credentials, external side effects, cancellation, time/output limits and failure
  reporting where applicable.
- Use project security tools and targeted source inspection. Scanner matches are
  leads to classify, not automatic proof of an exploit or permission to suppress
  a finding. Preserve exact diagnostics and source identity. Trace untrusted
  diagnostics through every report, log stream and retained failed-run artifact;
  redacting a scanner's own finding does not sanitize schema errors, transformer
  warnings or subprocess output. For CI command injection, inspect both ordinary
  stdout/stderr and trusted annotation paths. Read
  `references/runtime-guard-validation.md` for the real-CLI canary/control recipe.
- Honor explicit scoped exceptions and accepted limits. Review an authorized CI
  hunk against its approved scope rather than rejecting every workflow change.
  A "CI runs X" guard test must also fail when the step gets `if: false`,
  `continue-on-error: true`, ` || true` or a `shell:` override, and when the job
  gets an `if:` or the `on:` triggers change; substring checks survive these.
  Compare the step blocks, job header and `on:` block to the expected text exactly,
  count every list item as a step (not only `- name:` lines), and reject earlier
  steps writing `$GITHUB_ENV`/`$GITHUB_PATH`. For the Make target the step calls,
  ask make rather than reading text: `make -n -s <target>` must print exactly the
  expected command and `make -p` must show no `.IGNORE` or `GOFLAGS`/`GOENV`/
  `MAKEFLAGS`/`SHELL` override. Probe differentially: a stand-in recipe run in the
  target's place (`make -f Makefile -f probe.mk <target>`) must see the same
  origins, `MAKEFLAGS` and environment as under an empty makefile (3.81 and 4.3
  report different default origins), and make must report its forced failure. Line denylists miss `$(eval …)`, computed names and
  tab-prefixed assignments, each of which makes `make <target>` exit 0 on failing
  input (901u v3; macOS make is GNU 3.81, CI's ubuntu has 4.3).
  An accepted reasoned skip is not delivered support; independent errors and
  silent-drop controls must still fail.
- For selected runtime bounds, trace optimized interface paths as well as the
  obvious helper. A capped `Write` does not prove a Go `io.Copy`/`os/exec` path is
  capped if an embedded type promotes `ReadFrom`. Require real-path coverage and
  a mutation of the bypass boundary. Load
  `references/runtime-guard-validation.md` for the focused recipe.

## 3. Execute the admitted validation

1. Resolve commands from the repository and actual task workspace. An executing
   review runs its required gates; a static-only review inspects source and
   existing receipts and must not be presented as full execution acceptance.
2. Run canonical checks **directly**, in the plain environment (no job variable such as `F2B_*` exported: a new guard can break untouched tests that a builder's exported variable hid; heading-classes review 1), retaining complete output and each tested
   process's real exit code, cwd and revision. Capture the original process status
   before any filtering, truncation or log-copying pipeline; a final success marker
   or successful receipt writer cannot establish a passing test. Inspect saved
   output with `read_file` and `search_files` only after capturing that result.
   A by-name compare of two suite runs (main vs head) counts only when both runs
   finished (a DONE marker, the same file count): a compare taken mid-run reads
   like a gate with most files "MAIN ONLY" (site-shared-styles review 3).
3. Require the expected cases to execute. Do not add `--passWithNoTests`, a no-op
   target or an early test return to obtain green. For dependency-backed claims,
   supply the admitted dependency and verify exact test identities and intended
   effects; a test name or filtered command alone does not prove database coverage.
4. Report required missing/skipped cases as blocked. Preserve legitimate optional
   or platform skips with their declared reasons; do not fail every occurrence
   of the word `skipping`. Report unavailable tooling instead of silently skipping,
   installing without authority or claiming success.
5. Reproduce a suspected baseline failure only in an authorized isolated copy
   with matching inputs. Preserve both observations. Pre-existing attribution is
   not a waiver of a required failed gate or authority to repair unrelated code.
6. Keep failed receipts and distinguish setup/parser errors from behavioral RED.
   Use `test-driven-development`, `systematic-debugging` and
   `mutation-testing-discipline` for their respective checks, without duplicating
   adequate existing proof or extending an exhausted allocation.

## 4. Obtain fresh independent review

- Use a separate fresh reviewer that did not build or finish the candidate.
  Supply immutable base/head identities, the plan/AC contract, relevant risk and
  accepted-limit records, exact evidence paths, required skills and stopping point.
  A diff without its contract is insufficient; do not require a full chat replay.
- Follow project routing and reviewer count. When a leaf or noninteractive session
  cannot spawn the required reviewer, report that unmet stage to the parent; do
  not turn the limitation into self-review permission. Only an explicit authorized
  waiver may remove an otherwise required independent review.
- For concurrent reviews, use separate immutable source copies, mutation outputs,
  caches and resettable database namespaces. A read-only source intention does
  not make a test runner or fixture read-only. Preserve other owners' state.
- Inspect actual gates and try meaningful sensitivity checks for critical selected
  claims; do not accept the builder's summary as proof. Temporary mutations stay
  inside owned copies, with unchanged oracles and exact restoration verified.
- Reviewers never auto-fix, commit, publish or impersonate human approval. A missing
  or unparseable verdict is unresolved review, not a pass or proof of a code bug.

## 5. Classify findings and correct only with authority

1. Separate introduced defects, baseline failures, accepted limitations, missing
   proof and nonblocking suggestions. Each finding names severity, exact candidate,
   file/line or observed behavior, reproduction/exit and durable evidence.
2. Distinguish source-predicted concerns from executed failures. Do not relitigate
   an accepted limitation or silently broaden it to cover a new regression.
3. Route valid fixes to the authorized owner, test first, within the approved
   scope. A review-only role returns findings instead of applying them. Do not
   launch an auto-fix loop merely because a tool suggested one.
4. Preserve failed witnesses, user edits and candidate state. When an approved
   security-contract change invalidates an old output assertion, require a
   stronger replacement: retain the error category and exit semantics, assert
   the new safe output and reject the old unsafe value. Require a mutation that
   restores the old behavior to fail that oracle, with positive controls passing;
   deleting or loosening the assertion is not closure. After the permitted repair
   cycles, escalate remaining findings; do not suggest stash/reset as a default
   escape from failed verification.
5. Re-review changed behavior using fresh independent reviewers under project
   policy, then run any required independent verifier. A previous green applies
   to its exact inputs, not a later fix or integration candidate.

## 6. Finish only the authorized milestone

- Return the review to its owner. Passing review does not authorize commit, push,
  PR, merge, deployment, cleanup or tracker changes.
- If separately authorized to commit, inspect the complete staged paths, use
  explicit files and the project's identity/message convention. Do not use
  blanket `git add -A`, invent a `[verified]` prefix or imply eligible human
  approval from an agent review.
- Report local correctness separately from release acceptance: local runs do not
  prove hosted CI, private-repo fetch reachability, artifact upload, an installed
  app or a live deployment. Preserve every outstanding gate and its owner.
- Bind screenshots to the actual producing run/report and tested revision. Label
  a browser rendering of saved local output as local evidence, not a native UI
  or hosted CI screenshot. Privacy-check before sharing and publish only within
  explicit authority. A payload scan does not turn a failed full-directory scan
  green; retain both scopes, findings and any evidence-backed classification.

## Specialized review pitfalls

- **Review-only JS/TS mutations without disk edits:** on Node with `node:module`
  `registerHooks`, put a preload hook in owned scratch and run
  `MODE=<mutation> node --import <hook.mjs> --test <focused-tests>`. In
  `load(url, context, nextLoad)`, transform only the exact target module's returned
  source; fail if the replacement did not match, and assert exactly one module
  replacement per test-file child process (the `--test` parent loads no product
  module; `NODE_OPTIONS='--import <hook.mjs>'` reaches every child, except a CLI the
  test spawns with its own small `env`: count APPLIED per process and aim the mutant at a
  test that imports the module itself). Run an unhooked green control afterward and verify
  status. Select focused tests that actually import the module: zero replacements
  is a harness failure, not a killed product mutation. Go: `go test -overlay <json>`
  swaps a source file for a mutated scratch copy, or adds a scratch
  `zz_<role>_probe_test.go` (a Replace entry for a path not on disk) that drives
  edge cases through the package's own fixtures; `git status --porcelain` stays
  empty (901y review 1).
- **Font-capture reviews:** separate requested names, registered face states and
  actual painted fonts. Use Chrome CDP `CSS.getPlatformFontsForNode` on direct-text
  nodes with visible range rectangles. A `local("Arial")`-backed face can supply
  glyphs while `isCustomFont` is false; that flag alone is not the oracle. Preserve
  failed probes and original captures.
- **Comparability gates:** test CSS case-only family-name variations while keeping
  observed spelling, and current-only files with no baseline entry. Exercise the
  real CLI exit branch with explicitly labeled fixtures/dependency hooks; a helper
  checking only baseline/current intersections can silently omit new files.

## Required report

Return the verdict, candidate/base identities, complete reviewed scope, findings
with reproducible evidence, actual gate results and permitted skips, mutation
controls/restoration, loaded skills, durable report/artifact paths, accepted limits
and remaining holds. Use **passed / failed / blocked / not run / N/A with reason**.
Keep the chat summary short; put detailed receipts in the review artifact.
