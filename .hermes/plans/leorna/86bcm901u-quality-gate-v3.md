# 86bcm901u-quality-gate-v3: Content quality gate (CI)

> **Status: Approved by Justin 2026-10-24** ("go" = this plan + every ⭐ answer: 1A 2A 3A 4A 5A, and the proposed AC4 and the live AC5). Pipeline: Full, every role a fresh Opus 5.5 xhigh agent. The read-only approved copy is `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`.

Written 2026-10-24 by the Opus 5.5 PLANNER.
Card: [Content quality gate (CI)](https://app.clickup.com/t/86bcm901u) (E10 Content Library, PI-2, p1-high, control plane, size M).
Planned on control-plane GitHub `main` **`6e74ced843642439d1dac9f25673440fb0f285f5`** (PR #87 merged) and client GitHub `main` **`ea2b8ab6fc0ebde438476f0b3d1bb43bc6a47f8a`**.

## Questions for Justin

Answer with letters (for example "1A 2A 3A 4A 5A"). ⭐ is my pick, and the whole plan below already assumes it, so a plain **go** means the ⭐ answers.

**Q1. The two agent items list all three tools, but every tool skips agents today. What should CI do?**
- A ⭐ Pass, and show "skipped" with the reason
- B Fail until the agent items change

Why A: B makes the real library fail, and agents can't list zero tools. The report still shows plainly that no tool installs them.

**Q2. A tool renders an item but drops part of it (a warning). What should CI do?**
- A ⭐ Pass, and list the warning in the report
- B Fail on any warning for a listed tool

Why A: the desktop app treats these as warnings too. Errors, empty output and broken files still fail.

**Q3. Where do the per-tool render rules come from?**
- A ⭐ Copy the client's transformers, pinned by its goldens
- B CI checks out the private client repo (needs a token)

Why A: the control plane may never import client code (a CI check enforces it), and B needs an org owner to create a read token first. A copies about 700 lines and proves them byte-for-byte against the client's own golden files, the same way the integration tiles already share fixtures between the repos.

**Q4. Check that Codex's config.toml really parses?**
- A ⭐ Yes, add BurntSushi/toml v1.6.0 (MIT)
- B No, leave TOML unchecked and say so

Why A: the client copies Codex config text through unchecked, so a broken file would reach every Codex user. It adds one small, dependency-free library, used only by the gate.

**Q5. The prompt kind (86bcm9016) isn't merged yet. How to handle it?**
- A ⭐ Port prompt rendering now; either merge order works
- B Leave it out; whoever merges second adds it

Why A: if this story merged first without it, merging PR #85 would turn CI red until someone added prompt rendering.

## Justin's answers (2026-10-24)

**go**: every ⭐ answer, so **Q1-A** (agents pass as "skipped" with the reason), **Q2-A** (warnings pass and are listed), **Q3-A** (copy the client's transformers, pinned by its goldens), **Q4-A** (BurntSushi/toml v1.6.0 parses Codex's config.toml), **Q5-A** (port prompt rendering now). The proposed AC4 and the live AC5 are approved; AC5 is owed to Justin after his auth step and "make a PR".

## Away grant (Justin, 2026-10-24, after "go")

Justin's words: "Look ima go and leave the house you as the orchestrator just keep it going throughout the pipline and go .with the recommendation if it does not have recommendation make it create one."

- **Scope:** this pipeline only (`86bcm901u-quality-gate-v3`): builder → reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → `ac-check.sh` → finisher hand-over, looping fixer → verifier with no round cap. It ends when the hand-over is ready or Justin returns or cancels.
- **How it works:** every question an agent raises takes its recommended option without asking Justin. A question with no recommendation goes back to an agent to write one, which is then applied. A "fix it or accept the side effect" choice takes the scoped fix. A no-progress round gets a fresh fixer told to fix the defect class conservatively instead of stopping. Each pick is recorded below under "Away-grant picks" with its reason.
- **Unchanged (a recommendation never waives these):** no push, PR, merge, remote CI run, credential or token-scope change, ClickUp write or post; no weakening or removing existing CI gates; no touching the earlier 901u attempts, other stories' worktrees or anyone else's DB; AC5 stays live and owed to Justin; acceptance stays honest (hosted CI is NOT VERIFIED; missing screenshots are named).

### Away-grant picks

- **Builder (head `a2bc032`, 2026-10-24 08:44 EDT), rulings for the reviewers to confirm:** (1) kept the plan's real-gitleaks env test (it can't fail: `--config` beats `GITLEAKS_CONFIG*` in gitleaks 8.30.1) and added `TestGitleaksPassesNoGitleaksSettingsToTheScanner` with a recording fake scanner, which kills M11/M11b/M19/M20; (2) PR #20's prompt code lives in its own `prompt.go` with a header naming client `1f259b0`; (3) errcheck fixes to the plan's code (`_ = os.RemoveAll`, `_, _ = fmt.Fprintf`); (4) two README sentences tightened to be true as written; (5) evidence names carry the sha. T7 skipped: PR #85 still open.
- **Reviewer 1 (on `a2bc032`, 2026-10-24 09:01 EDT): findings.** All 6 builder rulings confirmed; AC2–AC4 accepted, AC1 not accepted (F1), AC5 live. Picks, each the reviewer's recommendation: **F1 (P2) fix**: every gitleaks scan copy starts with a fixed header line (gitleaks `dir` skips text files that start with `%PDF-`/`{\rtf`/`%!PS`), line numbers shifted back, `TestSecretBehindBinaryMagicStillFails` + mutation, README sentence. **F2 (P3) fix**: secret-scan `library.json`, and pass the log header's name/version/scanner through `oneLine()`. **F3 (P3) fix**: the AC4 test rejects `if:` and `continue-on-error:` on the gate step. **F4 (P3) → finisher**: redact the commit email in gate receipts before any upload. **F5 (P3) accept and document**: failure reasons quote item text; one README sentence says so (the repo secret scan runs first). Report: `evidence/86bcm901u-quality-gate-v3/review-1/`.
- **Fixer 1 (head `9ce08f6`, 2026-10-24 09:27 EDT): ready-for-next-review.** F1–F3 fixed test first, F5 documented, F4 left to the finisher (new gate logs print no email). Rulings for reviewer 2 to confirm: (1) F1 uses a token-shaped **canary** on the scan-copy header that gitleaks must report on line 1 of every copy, failing closed (exit 2, "gitleaks did not read …") when it's missing, because a plain header still lets `ustar`@257, `DICM`@128 and `CD001`@32769 files be skipped (main session reproduced the `ustar` case); (2) a skipped copy is a gate error (exit 2), not an item failure; (3) when `library.json` holds a secret, the library name is withheld in log, summary and JSON; (4) AC4 rejects any `if`/`continue-on-error` key on the two steps, even `false`; (5) own regression (lost `EvalSymlinks(root)`) fixed in `9ce08f6` with a test; (6) canary uses `math/rand/v2`.
- **Reviewer 2 (on `9ce08f6`, 2026-10-24 09:48 EDT): findings.** Reviewer 1's F1, F3, F5 closed; F2 not closed (via F-R2-1); F4 deferred to finisher. Fixer 1 rulings 2–6 confirmed, ruling 1 rejected in part. AC2–AC4 accepted, AC1 not (F-R2-1), AC5 live. Picks, each the reviewer's recommendation: **F-R2-1 (P2) fix**: gitleaks `dir` reads 100,000-byte chunks (+25,000 peek), so a token across the cut in a padded `item.json`/`library.json` passes and a library-name token is printed raw (main session reproduced it: byte 124,980 missed, 124,500 caught); fail closed (exit 2) on any scan copy over 100,000 bytes incl. header, test + mutation, fix the README "withheld" sentence. **F-R2-2 (P3) fix**: build the canary from a vowel-free alphabet (gitleaks' default global allowlist `(?i)^true|false|null$` drops any token containing "false"; a `…KEY` canary can make a false generic-api-key finding), unit test over 10,000 canaries. **F-R2-3 (P3) fix, test only**: AC4 compares the gate step block, the "Scan repository for secrets" block, the quality job header and the `on:` block to exact expected text, so ` || true`, `shell:` overrides, job-level `if:` and trigger edits fail (folds in fixer 1's job-level `if:` found_else). Upstream gitleaks allowlist note → found-else. Report: `evidence/86bcm901u-quality-gate-v3/review-2/`.
- **Fixer 2 (head `429c2ad`, 2026-10-24 11:51 EDT, after a usage-limit stop and resume): ready-for-verify.** Class audit of gitleaks 8.30.1's `dir` read path (20 paths, `evidence/…/fix-2-class-audit.md`): reachable ones closed, the rest ruled out with reasons. F-R2-1 fixed (any scan copy over 100,000 bytes incl. header → exit 2 naming the file), F-R2-2 fixed (vowel-free canary, header ends ` #`), F-R2-3 fixed test-only (AC4 compares the `on:` block, quality job settings, secret-scan step and gate step exactly, pins the step list and top-level keys; A1–A13 killed; ci.yml unchanged). Rulings: R1 cap rather than overlapping windows (largest valid copy is 73,635 bytes); R2 ` #` kept as defence in depth; R3 AC4 pins more than asked, so later CI edits must update the test; R4 no gate change for the real-secret "false" allowlist (no config key can drop it; upstream follow-up); R5 size error names the scan-copy path. All 16 gates exit 0; AC1–AC4 captures on `429c2ad`.
- **Verifier 1 (on `429c2ad`, 2026-10-24 ~12:25 EDT): clean.** AC1–AC4 accepted (own head/base runs and screenshots in `verifier/`), AC5 not_run (live); self-check `READY FOR THE USER: 4 of 5 ACs proven on 429c2ad; live ACs owed to the user: AC5`. All review findings closed (R1-F4 still owed by the finisher for the old `gates-a2bc032.*`/`gates-a3a2b23.*`). Two new P3s; picks, each the verifier's recommendation: **V1 (P3) fix, test only**: AC4 also compares the whole `library-check` Makefile block exactly, requires one `library-check:` rule and rejects `.IGNORE` (` || true` and `.IGNORE: library-check` survived and made `make library-check` exit 0 on a failing library). **V2 (P3) scoped fix**: a valid MCP template (64 KB body of short args) renders a 208 KB `.mcp.json` and hits the 100,000-byte cap (fails closed, so not a bypass), which contradicts fixer 2's "largest valid copy 73,635 bytes"; the error for a rendered copy names item, tool and size and says to shorten body.md, the README says rendered files can reach the cap, a test covers it, and the class-audit line is corrected (not the overlapping-windows alternative). Head changes, so verifier → auditor → ac-check run again. **Disk:** the Mac's disk was full (268 MB free); main session ran `go clean -cache` (rebuildable Go build cache only) → 9.5 GB free; nothing else deleted. (It broke a concurrent 945u `make check` in another session, which reran it.)
- **Fixer 3 (head `e488a8c`, 2026-10-24 ~12:55 EDT): ready-for-verify.** V1 fixed test-only (AC4 pins the whole `library-check` Makefile block and rejects Makefile-wide weakenings; A10–A23 killed, K1–K3 controls pass); V2 fixed (a rendered copy over the cap names item, tool, file and size and says to shorten body.md; source copies keep the old message; exit 2 unchanged; README updated; fixer 2's "73,635 bytes" corrected in `fix-3-notes-e488a8c.md`). Makefile and ci.yml unchanged. Rulings: R-F3-1 V1 also rejects MAKEFLAGS/SHELL/.SHELLFLAGS/second GO/include (later Makefile edits must update the test); R-F3-2 "up to 4 times" (measured 2.75–4.0×); R-F3-3 one new CLI test. 16 gates exit 0; AC1–AC4 captures on `e488a8c`.
- **Verifier 2 (on `e488a8c`, 2026-10-24 ~13:25 EDT): clean.** AC1–AC4 accepted (receipts in `verifier/`), AC5 not_run (live), self-check `READY FOR THE USER`; every earlier finding closed. Three new P3s, test only; picks, each the verifier's recommendation: **V3 fix**: the AC3 test pins the summary's exact header/separator and 5 cells per row (the "one column per tool, plus secrets" clause was unpinned). **V4 fix**: AC4's Makefile check also rejects `GOFLAGS`/`GOENV` settings (`export GOFLAGS = -n`/`-exec=true` survived). **V5 scoped fix**: AC4 fails if a quality step before the gate mentions `GITHUB_ENV`/`GITHUB_PATH`, and the test comment + README state the boundary: sabotage inside another step's script stays code-review territory (bounds the open-ended "CI weakening AC4 can't see" class; later verifiers report beyond-boundary cases as found_else). Pre-existing-on-main GOFLAGS/GITHUB_ENV risk for Test/Vet/Build → found-else follow-up card. Verifier round 2's folder becomes `verifier-r2/`.
- **Fixer 4 (head `385256e`, 2026-10-24 ~13:25 EDT): ready-for-verify.** V3, V4, V5 fixed test-only + one README sentence (the AC4 boundary); each proven coverage-only (mutants survive the `e488a8c` test via `go test -overlay`, killed by the new one). ci.yml, Makefile and non-test Go source unchanged. Rulings: R-F4-1 AC3 also checks each tool's column content (a count-only check let a column-order mutant survive); R-F4-2 V5 also matches `github.env`/`github.path`, case-insensitively (`github['env']`, `::set-env`/`::add-path` stay code-review territory); R-F4-3 GOENV demonstrated (N5). 16 gates exit 0; 34 mutation entries as expected; AC1–AC4 captures on `385256e`.
- **Verifier 3 (on `385256e`, 2026-10-24 ~13:50 EDT): clean.** AC1–AC4 accepted, AC5 live, self-check `READY FOR THE USER`; all earlier findings closed. Two P3s, same class, inside AC4's boundary: **V6** the Makefile line denylist misses `$(eval …)`, computed names and tab-prefixed assignments (M1–M7 make `make library-check` exit 0); **V7** the step list counts only `- name:` lines, so an unnamed or name-second step is invisible (U1–U3). Main session's call: this is the no-progress pattern (each round patches examples), so one **class fix** per the verifier's recommendation: V6 asks make itself (`make -n -s library-check …` must print exactly the expected command; a probe makefile / `make -p` shows no GOFLAGS/GOENV/SHELL/MAKEFLAGS override or `.IGNORE`; line checks kept as a second layer), V7 counts every list item as a step and requires `- name:` first; plus verifier 3's found_else **AC1 test compares against the literal tool list** (claude-code, codex, cursor) instead of the package's own `Tools`. **Convergence rule:** after this round, further P3 test-sensitivity findings in the CI/Make-weakening class go to the follow-up list, not another loop; a clean verdict goes straight to the blind AC auditor. P0–P2 findings or a non-accepted AC still loop. Verifier round 3's folder becomes `verifier-r3/`.
- **Fixer 5 (head `90407b3`, 2026-10-24 ~14:20 EDT): ready-for-verify.** V6 class fix (AC4 asks make itself: exact `make -n -s` output, a differential stand-in-recipe probe vs an empty makefile, no GNUmakefile/makefile/include, `make -p -n` has no `.IGNORE`/GOFLAGS/GOENV; checked on GNU Make 3.81 and 4.3), V7 (every list item is a step, `- name:` first), AC1 pins the literal tool list. Test only; 17 gates exit 0; 48 mutation entries as expected. Rulings R-F5-1..4 in its report (probe stands in for library-check's own recipe; four extra class checks; V7 stays text-based to avoid a go.mod change; make runs with the test env minus make/Go variables). F5-1 (earlier named step changing the gate env) → follow-up per the convergence rule.
- **Integration (2026-10-24 14:17 EDT): CP PR #85 (86bcm9016 prompt kind) and client PR #20 merged.** CP GitHub main is now `58d1095` (5 commits on `6e74ced`: prompt item `prompt/pr-description` in the library, `pack.KindPrompt`, migration 21, contract changes, `internal/library/README.md`, `README.md`, `delivery/stories.json`). Client main `17f7c1b` = `ea2b8ab` + PR #20 `1f259b0` (unchanged head). Per the approved plan ("if #85 merges first, the rebase conflicts are text-only and T7 swaps in `pack.KindPrompt`"): **fixer 6 rebases the branch onto `58d1095`, resolves text conflicts keeping both sides, runs T7, and re-checks the render port against client main `17f7c1b`** (re-pin SOURCE.md to it if identical; follow the README refresh steps if not). New base for verifier/auditor/ac-check: `58d1095`.
- **Fixer 6 (integration, head `f7dff50`, 2026-10-24 ~15:05 EDT): ready-for-verify.** GitHub main moved again mid-task (PR #89, 86bcm945u upstream sync, merged 14:28), so the branch is rebased onto **`6275a4e`** (contains `58d1095`); old heads kept as local `backup/86bcm901u-v3-pre-rebase` (`90407b3`) and `backup/86bcm901u-v3-pre-rebase-2` (`760dc59`). Rebase 1 clean; rebase 2 one README text conflict (both kept). **Semantic conflict:** PR #89's `content/upstreams/<name>/{upstream.json,LICENSE}` failed the gate's layout check on main's real library → fixed test first in favour of main: the gate accepts `upstreams/` and secret-scans both upstream files (`TestUpstreamRecordsAreAcceptedAndSecretScanned`; MU1–MU5 killed). T7 done (`pack.KindPrompt`; real `prompt/pr-description` passes AC3: Claude Code + Cursor rendered, Codex not declared). Render port re-pinned to client main `17f7c1b` (all 33 copied files byte-identical; same patch-ids as PR #20). 18 gates exit 0 on `f7dff50`; base runs on `6275a4e` fail to build; 59 mutation entries as expected; AC1–AC4 captures + AC3 rendering on `f7dff50`; `make library-check` passes with 10 items. Rulings R-F6-1..4 in its report. **The upstreams acceptance is new behaviour no reviewer has seen: verifier 4 also does a focused fresh review of the integration delta.** New base for verifier 4/auditor/ac-check: **`6275a4e`**.
- **Verifier 4 + focused integration review (on `f7dff50`, base `6275a4e`, 2026-10-24 ~15:50 EDT): clean.** No P0–P2 in review or verification; AC1–AC4 accepted (receipts in `verifier/`), AC5 live; self-check `READY FOR THE USER: 4 of 5 ACs proven on f7dff50; live ACs owed to the user: AC5`. The `upstreams/` acceptance fails closed in 21 probes; 8/8 upstream mutants killed; T7 behaviour-neutral; re-pin byte-identical; rebase range-diff clean; all earlier findings closed; 27/27 CI/Make weakenings fail AC4 on Make 3.81 and 4.3. One **P3 doc nit R4-A1**: a sentence in `internal/library/render/testdata/client/SOURCE.md` says every file below is the same at `ea2b8ab` and `17f7c1b`, but the "Rule sources" table lists files PR #20 changed. Main session's call: **not committed now** (it would move the head off the one the ACs are proven on and force another full verify round for one sentence); the finisher puts the corrected sentence in the hand-over as a ready doc fix for Justin, to land with "make a PR" (where the gates re-run on the pushed head). Next: blind AC auditor on `f7dff50`.
- **Blind AC auditor (on `f7dff50`, 2026-10-24 ~16:45 EDT): all-accepted** (own head/base runs, own screenshots, 7 read-only mutants caught; receipts in `auditor/`). **`ac-check.sh --base 6275a4e…`: `READY FOR THE USER: 4 of 5 ACs proven on f7dff50; live ACs owed to the user: AC5`** (AC1–AC4 ACCEPTED, AC5 NOT VERIFIED live). Next: finisher hand-over on `f7dff50` (no commit).
- **Hand-over ready (2026-10-24 ~17:00 EDT)** in `evidence/…/handover/`. **Justin back: "Post the photos on Clickup and do a PR"** = "make a PR" + "post". PR/post finisher stopped at pre-flight: **PR #88 (86bcm901v catalog browser) merged 21:23Z → GitHub main `b446a89`**; merge-tree conflicts only in `delivery/stories.json`; push auth still blocked (no `workflow` scope, SSH key locked; Justin asked to run `gh auth refresh -h github.com -s workflow`). R4-A1 not added (safer reading; in the PR's Assumptions). **Justin's answers (2026-10-24, form): "Rebase onto new main" and "Full re-verify".** So: fixer 7 rebases onto `b446a89` (backup branch first), keeps both stories.json entries, reruns gates and captures → fresh verifier 5 → blind auditor 2 → ac-check on the new head → PR + post finisher. f7dff50 verifier/auditor folders archived as `verifier-r4/` and `auditor-r1/`.
- **Re-verify on `0cf18f1` (base `b446a89`), 2026-10-24 ~18:20 EDT:** fixer 7 rebase pure (same patch-id as `f7dff50`; stories.json = main's + 86bcm901u last); verifier 5 clean; blind auditor 2 all-accepted; **`ac-check.sh`: `READY FOR THE USER: 4 of 5 ACs proven on 0cf18f1; live ACs owed to the user: AC5`**. PR/post finisher round 2 brief ready (`briefs/86bcm901u-quality-gate-v3-finisher-pr-post-2.md`); **held only on Justin's push auth** (token scopes gist/read:org/repo, SSH key locked).
- **2026-10-24 ~18:50 EDT: PR #90 opened** (https://github.com/LeornaAI/leorna-control-plane/pull/90, head `0cf18f1`, MERGEABLE/CLEAN; Go quality gates pass incl. "Check content library quality") after Justin added the `workflow` scope; **ClickUp evidence comment + 6 images posted and read back** (status unchanged). Local `b13b922` (stories.json → [90]) awaits Justin's "push". AC5's broken-item hosted run, the merge, check-story-shippable, the team message and a merge-facts follow-up comment remain Justin's.

## Acceptance criteria

The card's three ACs are AC1–AC3. AC4 splits "when CI runs" out of AC1. AC5 is the card's **Verify** line on GitHub. Both are marked **proposed**.

- AC1: Given a library change, when the gate runs, then every item is schema-validated, rendered for Claude Code, Codex and Cursor, and secret-scanned (source files and rendered files). A schema error or a secret fails the run and names the item.
  - Test: `TestAC1ValidatesRendersAndScansEveryItem` (`internal/library/gate/gate_test.go`)
  - Command: `LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)" go test -v -count=1 -run '^TestAC1ValidatesRendersAndScansEveryItem$' ./internal/library/gate`
  - On base `6e74ced`: the package doesn't exist, so the copied test fails to build (`undefined: Run`).
- AC2: Given a render failure for a tool the item says it supports, then CI fails, and the failure names the item and the tool (`FAIL <kind>/<name>@<version> <tool>: render: <reason>`, exit 1). The same failure for a tool the item doesn't list is reported but does not fail.
  - Test: `TestAC2RenderFailureFailsCINamingItemAndTool` (`cmd/library-gate/main_test.go`)
  - Command: `go test -v -count=1 -run '^TestAC2RenderFailureFailsCINamingItemAndTool$' ./cmd/library-gate`
  - On base: fails to build (`undefined: run`).
- AC3: Given a passing run, then a per-item compatibility report is produced: a Markdown table appended to the CI job summary (one row per item, one column per tool, plus secrets) and, on request, a JSON report. The real library passes.
  - Test: `TestAC3PassingRunWritesPerItemCompatibilityReport` (`cmd/library-gate/main_test.go`)
  - Command: `LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)" go test -v -count=1 -run '^TestAC3PassingRunWritesPerItemCompatibilityReport$' ./cmd/library-gate`
  - On base: fails to build (`undefined: run`).
- AC4 (proposed): Given any pull request or push to `main`, then the "Go quality gates" job runs the gate (`make library-check`) after the existing secret-scan step, with every existing step still present in the same order and the secret-scan command unchanged, and `make check` runs it too.
  - Test: `TestAC4CIRunsLibraryGateWithoutDroppingGates` (`cmd/library-gate/ci_test.go`, self-contained)
  - Command: `go test -v -count=1 -run '^TestAC4CIRunsLibraryGateWithoutDroppingGates$' ./cmd/library-gate`
  - On base: the test runs and fails (`CI has no "Check content library quality" step`).
- AC5 (proposed) (live): Given the branch on GitHub, then the "Go quality gates" check fails on a throwaway branch holding a deliberately broken item, with the log naming the item and Codex, and passes on the real library with the compatibility report in the job summary.
  - Test: the hosted CI runs themselves (job "Go quality gates", step "Check content library quality"), read with `gh run view <run-id> --log` and the run's summary page.
  - Only Justin can unlock it: it needs a push (his word), and the `gh` token needs the `workflow` scope first (his auth step). Agents mark it `not_run: live`.

**How the card's Verify line is shown locally (before any push):** the built `library-gate` binary runs on a copy of the real library with one deliberately broken item added (exit 1, the `FAIL` line names `mcp_template/broken-args@1.0.0 codex`), and on the real library itself (exit 0, report written). Both runs are captured as screenshots (AC2, AC3).

**What stays NOT VERIFIED until hosted CI runs (AC5):** the new step on GitHub's Ubuntu runner, the `${{ runner.temp }}` gitleaks path on the test step, how GitHub renders the job summary (local rendering only), and the whole workflow change's publication (blocked on the `workflow` token scope).

## Playback

Build the content quality gate again, from scratch, in the control plane. In CI, every content-library item is checked against the library schema, rendered for Claude Code, Codex and Cursor using the desktop client's rules, and scanned for secrets. If an item can't be rendered for a tool it says it supports, CI fails and names the item and the tool. A passing run writes a per-item compatibility report.

**Not in this story:** changing library items (see Other things found), behavioural evals that a skill "fires" (needs real models; card context only), conflicts between two items in one pack (a pack-building concern), parsing rendered files with the real CLIs, render checks at save time in the admin console (card 86bcm9021), any API or database change.

## Context (checked 2026-10-24)

- **Library format and loader (86bcm9018, PR #82, merged):** `internal/library` parses `content/library.json` and `content/items/<kind>/<name>/{item.json,body.md,example.md}` strictly (`library.Parse`, unknown fields rejected, errors name the item). `item.json` `tools` lists `claude-code`, `codex`, `cursor`. Eight items on main: 2 agents, 2 configs, 1 MCP template, 3 skills. `content.lock.json` pins every shipped version (`TestContentLockPinsEveryItemVersion`).
- **The renderers live in the client:** `toolconnector.ConfigTransformer` in `leorna-client` (`toolconnector/transform.go`, `claudecode/config.go` 323 lines, `codex/config.go` 246, `cursor/config.go` 129). They are pure (no files, clock or env) and pinned by golden files. Skills → `SKILL.md` per tool; MCP templates → `.mcp.json` / `config.toml` tables / `mcp.json`; configs → only for the tool whose ID prefixes the item name (`claude-code-`, `codex-`, `cursor-`); agents → a warning and no files for every tool.
- **The control plane may not import client code:** `scripts/verify-workspace.sh:12-15` fails `make workspace` if `go list -deps` finds `github.com/LeornaAI/leorna-client`. Both repos are private.
- **Cross-repo fixtures already exist:** `internal/integration/testdata/rendered/*.json` (PR #87) are byte-identical to the client's `toolconnector/testdata/integrations/*.json` (checked with `cmp`), and the client's goldens for them sit in `toolconnector/testdata/golden/integrations/<variant>/<tool>/`.
- **CI:** one workflow, `.github/workflows/ci.yml`; job "Go quality gates" (the required check, via the "Protect main" ruleset) downloads checksum-verified gitleaks 8.30.1 to `${RUNNER_TEMP}/gitleaks` in its first step and runs `gitleaks git` over all refs. golangci-lint 2.14.0, govulncheck v1.7.0, Go from `go.work` (1.27.3), `GOTOOLCHAIN: local`.
- **Repo `.gitleaks.toml`** extends the default rules but allowlists regexes such as `SCW_[A-Z_]+=` and `postgres://leorna_admin`. Those must not apply to shipped content, so the gate scans content with the default rules only.
- **Local tools on this Mac:** gitleaks 8.30.1 (Homebrew), Homebrew golangci-lint 2.13.2 (wrong; CI's 2.14.0 is at `~/.hermes/cache/scratch/leorna-bin/golangci-lint`), govulncheck v1.8.0 (CI uses v1.7.0), Go 1.27.1 on PATH with toolchains 1.27.2 and 1.27.3 cached, GNU realpath and Bash 5.3 under `/opt/homebrew`, Postgres container `leorna-test-pg` up, no ClickHouse container (those tests skip locally; CI runs them). BurntSushi/toml v1.6.0 is already in the module cache.
- **`gh` token scopes:** `gist`, `read:org`, `repo` (no `workflow`), so pushing a change to `ci.yml` over HTTPS will be refused until Justin runs his own auth step.

## Approach

```
make library-check  ──►  cmd/library-gate  (flags, exit codes 0/1/2, writes log, summary, JSON)
                            │
                            ▼
                    internal/library/gate.Run(fs, scanner)
                      1. layout:  only library.json + items/ at the top; regular files only
                      2. schema:  library.Parse  (the same rules the server loads at startup)
                      3. render:  for each item × [claude-code, codex, cursor]
                                  internal/library/render.Transform (copy of the client's rules)
                                  + parse every rendered .json / .toml file
                      4. secrets: copy each item's 3 source files + every rendered file into a
                                  fresh temp folder; one gitleaks run (default rules, no allowlist,
                                  inline gitleaks:allow ignored); map findings back to items
                      ──► Report {items[], failures[], passed}
```

### Status of one item for one tool

| Render result | Status | Fails CI when the item lists the tool? |
| --- | --- | --- |
| error from the transformer | `failed` (reason = error text) | yes |
| no files, and `render.NotInstalled(kind, tool)` says the tool installs nothing for this kind (agents everywhere; prompts on Codex) | `skipped` (reason) | no (Q1-A) |
| no files otherwise (for example a `claude-code-…` config listing `cursor`) | `failed` ("renders no files for cursor …") | yes |
| files, but a `.json` or `.toml` file doesn't parse | `failed` ("config.toml is not valid TOML: …") | yes |
| files and warnings | `rendered_with_warnings` | no (Q2-A) |
| files, no warnings | `rendered` | no |

Every item is rendered for all three tools. A tool the item doesn't list is reported (`declared: false`) and never fails CI. An item passes when no listed tool failed and no secret was found. The run passes when there is no layout, schema, render or secret failure.

### Files

New:
- `internal/library/render/render.go`: types, `Transform`, `NotInstalled`, `FromLibrary`, `Pack.Validate` (code below).
- `internal/library/render/shared.go`, `claudecode.go`, `codex.go`, `cursor.go`, `prompt.go`: the client's rules, copied (exact rules in T1).
- `internal/library/render/render_test.go`: parity and failure tests.
- `internal/library/render/testdata/client/**`: client fixtures and goldens, plus `SOURCE.md`.
- `internal/library/gate/gate.go`, `scan.go`, `report.go`: the gate (code below).
- `internal/library/gate/gate_test.go` (AC1 and helpers), `internal/library/gate/gate_more_test.go` (other unit tests).
- `cmd/library-gate/main.go`, `cmd/library-gate/main_test.go` (AC2, AC3, usage), `cmd/library-gate/ci_test.go` (AC4).

Changed:
- `.github/workflows/ci.yml`: one new step and one `env:` block (additions only).
- `Makefile`: `library-check` target, added to `check` and `.PHONY`.
- `go.mod`, `go.sum`: `github.com/BurntSushi/toml v1.6.0` (Q4-A).
- `.gitattributes`: one line keeping the new golden files LF.
- `internal/library/README.md` (Quality gate section), `README.md` (one sentence), `delivery/stories.json` (new entry with an empty PR list).

Not touched: `contracts/`, `packages/contracts/` (no API change, so no OpenAPI update), `internal/store/postgres/migrations/` (no migration: the gate reads files, not the database), `internal/library/library.go` and `source.go` (the loader is reused as is), `THIRD_PARTY_NOTICES.md` (it says server dependencies keep their upstream licences; nothing to add), `deploy/local/`.

### Code: `internal/library/render/render.go`

```go
// Package render turns content library items into each AI tool's native files
// with the same rules as the desktop client's per-tool ConfigTransformer
// (LeornaAI/leorna-client toolconnector), so CI can prove an item works in every
// tool it lists before it ships. The control plane must not import client code
// (scripts/verify-workspace.sh), so this package is a copy of the client's
// transformers at the commit named in testdata/client/SOURCE.md, and its tests
// compare the output with that commit's golden files byte for byte. Keep every
// rule and message identical to the client; change them only by copying a
// merged client change.
package render

import (
	"errors"
	"fmt"
	"strings"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// Errors mirror the client's toolconnector.ErrInvalid, ErrUnsupported and ErrConflict.
var (
	ErrInvalid     = errors.New("invalid")
	ErrUnsupported = errors.New("not supported")
	ErrConflict    = errors.New("conflict")
)

// kindPrompt is the "prompt" kind from story 86bcm9016 (control-plane PR #85,
// client PR #20). Use pack.KindPrompt instead once PR #85 is on main.
const kindPrompt pack.Kind = "prompt"

// Pack bounds, as in the client's toolconnector/pack.go.
const (
	maxPackItems            = 500
	maxPackBodyBytes        = 64 << 10
	maxPackDescriptionRunes = 2000
	maxPackNameRunes        = 200
	maxPackVersionRunes     = 50
)

// Item is one pack item as the desktop client receives it.
type Item struct {
	Kind        pack.Kind `json:"kind"`
	Name        string    `json:"name"`
	Version     string    `json:"version"`
	Description string    `json:"description"`
	Body        string    `json:"body"`
}

// Pack is what the client renders.
type Pack struct {
	Name    string `json:"name"`
	Version string `json:"version"`
	Items   []Item `json:"items"`
}

// Bundle is one tool's rendered files, keyed by path relative to where the tool
// reads them, plus warnings naming what the tool skipped.
type Bundle struct {
	Tool     library.Tool
	Files    map[string][]byte
	Warnings []string
}

// FromLibrary is the pack item a library item becomes when it is put in a pack.
func FromLibrary(item library.Item) Item {
	return Item{Kind: item.Kind, Name: item.Name, Version: item.Version, Description: item.Description, Body: item.Body}
}

// Transform renders the pack for one tool. Like the client, it returns no files
// at all when any item cannot be rendered.
func Transform(tool library.Tool, p Pack) (Bundle, error) {
	switch tool {
	case library.ToolClaudeCode:
		return transformClaudeCode(p)
	case library.ToolCodex:
		return transformCodex(p)
	case library.ToolCursor:
		return transformCursor(p)
	default:
		return Bundle{}, fmt.Errorf("%w: unknown tool %q", ErrInvalid, tool)
	}
}

// NotInstalled reports why a tool installs nothing for a kind by design. The
// transformer still renders such an item without error and names it in a
// warning; the gate reports it as skipped rather than failed.
func NotInstalled(kind pack.Kind, tool library.Tool) (string, bool) {
	switch {
	case kind == pack.KindAgent:
		return "the desktop client does not install agents yet", true
	case kind == kindPrompt && tool == library.ToolCodex:
		return codexPromptSkipReason, true
	default:
		return "", false
	}
}

// Validate is the client's Pack.Validate: it reports the first rule a pack breaks.
func (p Pack) Validate() error {
	if !boundedText(p.Name, maxPackNameRunes) || !boundedText(p.Version, maxPackVersionRunes) {
		return fmt.Errorf("%w: pack name and version are required", ErrInvalid)
	}
	if len(p.Items) == 0 || len(p.Items) > maxPackItems {
		return fmt.Errorf("%w: pack must hold 1 to %d items", ErrInvalid, maxPackItems)
	}
	seen := make(map[string]struct{}, len(p.Items))
	for index, item := range p.Items {
		switch item.Kind {
		case pack.KindSkill, pack.KindAgent, pack.KindConfig, pack.KindMCPTemplate, kindPrompt:
		default:
			return fmt.Errorf("%w: pack item %d has an unknown kind", ErrInvalid, index)
		}
		if !boundedText(item.Name, maxPackNameRunes) || !boundedText(item.Version, maxPackVersionRunes) {
			return fmt.Errorf("%w: pack item %d needs a name and version", ErrInvalid, index)
		}
		if !validString(item.Description) || utf8.RuneCountInString(item.Description) > maxPackDescriptionRunes {
			return fmt.Errorf("%w: pack item %q description is too long", ErrInvalid, item.Name)
		}
		if !validString(item.Body) || len(item.Body) > maxPackBodyBytes {
			return fmt.Errorf("%w: pack item %q body is too large", ErrInvalid, item.Name)
		}
		key := string(item.Kind) + "\x00" + item.Name
		if _, duplicate := seen[key]; duplicate {
			return fmt.Errorf("%w: pack item %q is repeated for kind %s", ErrInvalid, item.Name, item.Kind)
		}
		seen[key] = struct{}{}
	}
	return nil
}

func boundedText(value string, maxRunes int) bool {
	if !validString(value) {
		return false
	}
	count := utf8.RuneCountInString(strings.TrimSpace(value))
	return count >= 1 && count <= maxRunes
}

func validString(value string) bool {
	return utf8.ValidString(value) && !strings.ContainsRune(value, 0)
}
```

### Code: `internal/library/gate/gate.go`

```go
// Package gate is the content library quality gate that CI runs on every
// change (story 86bcm901u). Every item is schema-validated with the parser the
// control plane loads at startup, rendered for Claude Code, Codex and Cursor
// with the desktop client's rules (package render), and secret-scanned in its
// source and rendered form. A failure for a tool an item lists fails the run;
// the report covers every item and every tool.
package gate

import (
	"context"
	"encoding/json"
	"fmt"
	"io/fs"
	"path"
	"sort"
	"strings"

	"github.com/BurntSushi/toml"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/render"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// SchemaVersion is the version of the JSON report format.
const SchemaVersion = 1

// Tools are the AI tools every item is rendered for, in report order.
var Tools = []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}

// Status is the outcome of rendering one item for one tool.
type Status string

// Render outcomes. Only StatusFailed on a tool the item lists fails the gate.
const (
	StatusRendered             Status = "rendered"
	StatusRenderedWithWarnings Status = "rendered_with_warnings"
	StatusSkipped              Status = "skipped"
	StatusFailed               Status = "failed"
)

// Stage names the check that found a problem.
type Stage string

// Gate stages, in the order they run.
const (
	StageLayout  Stage = "layout"
	StageSchema  Stage = "schema"
	StageRender  Stage = "render"
	StageSecrets Stage = "secrets"
)

// ToolResult is one item rendered for one tool.
type ToolResult struct {
	Tool     library.Tool `json:"tool"`
	Declared bool         `json:"declared"`
	Status   Status       `json:"status"`
	Files    []string     `json:"files"`
	Warnings []string     `json:"warnings"`
	Reason   string       `json:"reason,omitempty"`
}

// SecretFinding is one secret in an item's source or rendered files. The
// secret itself is never recorded.
type SecretFinding struct {
	File string `json:"file"`
	Rule string `json:"rule"`
	Line int    `json:"line"`
}

// ItemResult is everything the gate found about one item version.
type ItemResult struct {
	Key           string          `json:"key"`
	Kind          pack.Kind       `json:"kind"`
	Name          string          `json:"name"`
	Version       string          `json:"version"`
	DeclaredTools []library.Tool  `json:"declaredTools"`
	Schema        string          `json:"schema"`
	Tools         []ToolResult    `json:"tools"`
	Secrets       []SecretFinding `json:"secrets"`
	Passed        bool            `json:"passed"`
}

// Failure is one reason the gate failed. Item and Tool are empty when the
// problem is not one item's (a layout or schema error names its path itself).
type Failure struct {
	Item   string       `json:"item,omitempty"`
	Tool   library.Tool `json:"tool,omitempty"`
	Stage  Stage        `json:"stage"`
	Reason string       `json:"reason"`
}

// LibraryInfo is the library header.
type LibraryInfo struct {
	Name    string `json:"name"`
	Version string `json:"version"`
}

// Report is the per-item compatibility report.
type Report struct {
	SchemaVersion int            `json:"schemaVersion"`
	Library       LibraryInfo    `json:"library"`
	Tools         []library.Tool `json:"tools"`
	Scanner       string         `json:"scanner"`
	Passed        bool           `json:"passed"`
	Items         []ItemResult   `json:"items"`
	Failures      []Failure      `json:"failures"`
}

// Run checks the library source. Problems with the content go in the report
// (Passed false); an error means the gate could not run, for example because
// the secret scanner is missing.
func Run(ctx context.Context, source fs.FS, scanner Scanner) (Report, error) {
	scannerName, err := scanner.Name(ctx)
	if err != nil {
		return Report{}, err
	}
	report := Report{SchemaVersion: SchemaVersion, Tools: Tools, Scanner: scannerName,
		Items: []ItemResult{}, Failures: []Failure{}}
	if problem := checkLayout(source); problem != "" {
		report.Failures = append(report.Failures, Failure{Stage: StageLayout, Reason: problem})
		return report, nil
	}
	lib, err := library.Parse(source)
	if err != nil {
		report.Failures = append(report.Failures, Failure{Stage: StageSchema, Reason: err.Error()})
		return report, nil
	}
	report.Library = LibraryInfo{Name: lib.Name, Version: lib.Version}

	outputs := make(map[string]map[library.Tool]map[string][]byte, len(lib.Items))
	for _, item := range lib.Items {
		result, files := checkItem(lib, item)
		report.Items = append(report.Items, result)
		outputs[item.Key()] = files
	}
	findings, err := scanSecrets(ctx, source, lib, outputs, scanner)
	if err != nil {
		return Report{}, err
	}
	for index := range report.Items {
		item := &report.Items[index]
		item.Secrets = findings[item.Key]
		if item.Secrets == nil {
			item.Secrets = []SecretFinding{}
		}
		item.Passed = len(item.Secrets) == 0
		for _, tool := range item.Tools {
			if tool.Declared && tool.Status == StatusFailed {
				item.Passed = false
				report.Failures = append(report.Failures,
					Failure{Item: item.Key, Tool: tool.Tool, Stage: StageRender, Reason: tool.Reason})
			}
		}
		for _, finding := range item.Secrets {
			report.Failures = append(report.Failures, Failure{Item: item.Key, Stage: StageSecrets,
				Reason: fmt.Sprintf("%s: secret rule %s on line %d", finding.File, finding.Rule, finding.Line)})
		}
	}
	report.Passed = len(report.Failures) == 0
	return report, nil
}

// checkLayout allows only regular files and folders, and only library.json and
// items/ at the top. library.Parse checks the rest of the layout but never
// reads other top-level entries, which go:embed would still ship.
func checkLayout(source fs.FS) string {
	var problem string
	err := fs.WalkDir(source, ".", func(name string, entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if name == "." {
			return nil
		}
		if !entry.IsDir() && !entry.Type().IsRegular() {
			problem = name + " is not a regular file (links and special files are not allowed)"
			return fs.SkipAll
		}
		if !strings.Contains(name, "/") && name != "library.json" && name != "items" {
			problem = name + " is not part of the library layout (only library.json and items/ belong at the top)"
			return fs.SkipAll
		}
		return nil
	})
	if err != nil && problem == "" {
		problem = "the library folder cannot be read: " + err.Error()
	}
	return problem
}

func checkItem(lib library.Library, item library.Item) (ItemResult, map[library.Tool]map[string][]byte) {
	declared := make(map[library.Tool]bool, len(item.Tools))
	for _, tool := range item.Tools {
		declared[tool] = true
	}
	result := ItemResult{Key: item.Key(), Kind: item.Kind, Name: item.Name, Version: item.Version,
		DeclaredTools: item.Tools, Schema: "pass", Tools: make([]ToolResult, 0, len(Tools))}
	files := make(map[library.Tool]map[string][]byte, len(Tools))
	for _, tool := range Tools {
		outcome, rendered := renderFor(lib, item, tool)
		outcome.Declared = declared[tool]
		result.Tools = append(result.Tools, outcome)
		files[tool] = rendered
	}
	return result, files
}

// renderFor renders the item alone, as a one-item pack, so each result belongs
// to exactly one item.
func renderFor(lib library.Library, item library.Item, tool library.Tool) (ToolResult, map[string][]byte) {
	result := ToolResult{Tool: tool, Files: []string{}, Warnings: []string{}}
	bundle, err := render.Transform(tool, render.Pack{Name: lib.Name, Version: lib.Version,
		Items: []render.Item{render.FromLibrary(item)}})
	if err != nil {
		result.Status, result.Reason = StatusFailed, err.Error()
		return result, nil
	}
	result.Files = sortedPaths(bundle.Files)
	result.Warnings = append(result.Warnings, bundle.Warnings...)
	switch {
	case len(bundle.Files) == 0:
		if reason, ok := render.NotInstalled(item.Kind, tool); ok {
			result.Status, result.Reason = StatusSkipped, reason
		} else {
			result.Status, result.Reason = StatusFailed, noFilesReason(item, tool)
		}
	default:
		if problem := checkFormats(bundle.Files); problem != "" {
			result.Status, result.Reason = StatusFailed, problem
		} else if len(bundle.Warnings) > 0 {
			result.Status = StatusRenderedWithWarnings
		} else {
			result.Status = StatusRendered
		}
	}
	return result, bundle.Files
}

func noFilesReason(item library.Item, tool library.Tool) string {
	reason := "renders no files for " + string(tool)
	if item.Kind == pack.KindConfig {
		reason += fmt.Sprintf(" (a config renders only for the tool its name starts with; %s configs start with %q)",
			tool, string(tool)+"-")
	}
	return reason
}

// checkFormats parses each rendered JSON and TOML file, so a body the client
// copies through unchecked (a Codex config.toml) cannot ship broken.
func checkFormats(files map[string][]byte) string {
	for _, name := range sortedPaths(files) {
		switch path.Ext(name) {
		case ".json":
			if !json.Valid(files[name]) {
				return name + " is not valid JSON"
			}
		case ".toml":
			var document map[string]any
			if err := toml.Unmarshal(files[name], &document); err != nil {
				return fmt.Sprintf("%s is not valid TOML: %v", name, err)
			}
		}
	}
	return ""
}

func sortedPaths(files map[string][]byte) []string {
	paths := make([]string, 0, len(files))
	for name := range files {
		paths = append(paths, name)
	}
	sort.Strings(paths)
	return paths
}
```

### Code: `internal/library/gate/scan.go`

```go
package gate

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
)

// Finding is one secret a Scanner found. Path is slash-separated and relative
// to the folder that was scanned.
type Finding struct {
	Path string
	Rule string
	Line int
}

// Scanner finds secrets in every file under a folder.
type Scanner interface {
	// Name identifies the scanner and its version for the report.
	Name(ctx context.Context) (string, error)
	Scan(ctx context.Context, root string) ([]Finding, error)
}

var sourceFiles = []string{"item.json", "body.md", "example.md"}

// scanSecrets copies every item's source files and every rendered file into a
// fresh folder and scans it once. Only files the library accepts are copied, so
// an ignore file next to the content cannot hide a finding.
func scanSecrets(ctx context.Context, source fs.FS, lib library.Library,
	outputs map[string]map[library.Tool]map[string][]byte, scanner Scanner) (map[string][]SecretFinding, error) {
	root, err := os.MkdirTemp("", "library-gate-scan-")
	if err != nil {
		return nil, fmt.Errorf("prepare secret scan: %w", err)
	}
	defer os.RemoveAll(root)

	type origin struct{ item, file string }
	origins := map[string]origin{}
	write := func(rel string, data []byte, owner origin) error {
		full := filepath.Join(root, filepath.FromSlash(rel))
		if err := os.MkdirAll(filepath.Dir(full), 0o700); err != nil {
			return err
		}
		origins[rel] = owner
		return os.WriteFile(full, data, 0o600)
	}
	for _, item := range lib.Items {
		base := path.Join(string(item.Kind), item.Name)
		for _, name := range sourceFiles {
			data, err := fs.ReadFile(source, path.Join("items", base, name))
			if err != nil {
				return nil, fmt.Errorf("read %s for the secret scan: %w", path.Join(base, name), err)
			}
			if err := write(path.Join(base, "source", name), data, origin{item.Key(), name}); err != nil {
				return nil, fmt.Errorf("prepare secret scan: %w", err)
			}
		}
		for _, tool := range Tools {
			files := outputs[item.Key()][tool]
			for _, name := range sortedPaths(files) {
				owner := origin{item.Key(), string(tool) + " output " + name}
				if err := write(path.Join(base, string(tool), flatName(name)), files[name], owner); err != nil {
					return nil, fmt.Errorf("prepare secret scan: %w", err)
				}
			}
		}
	}

	found, err := scanner.Scan(ctx, root)
	if err != nil {
		return nil, err
	}
	byItem := map[string][]SecretFinding{}
	for _, finding := range found {
		owner, ok := origins[finding.Path]
		if !ok {
			return nil, fmt.Errorf("secret scanner reported %q, which the gate did not write", finding.Path)
		}
		byItem[owner.item] = append(byItem[owner.item], SecretFinding{File: owner.file, Rule: finding.Rule, Line: finding.Line})
	}
	for _, list := range byItem {
		sort.Slice(list, func(i, j int) bool {
			if list[i].File != list[j].File {
				return list[i].File < list[j].File
			}
			if list[i].Line != list[j].Line {
				return list[i].Line < list[j].Line
			}
			return list[i].Rule < list[j].Rule
		})
	}
	return byItem, nil
}

// flatName turns a bundle path such as .claude/skills/x/SKILL.md into one plain
// file name (dot-claude__skills__x__SKILL.md), so no scanned file sits in a
// hidden folder a scanner might skip.
func flatName(bundlePath string) string {
	name := strings.ReplaceAll(bundlePath, "/", "__")
	if strings.HasPrefix(name, ".") {
		name = "dot-" + strings.TrimPrefix(name, ".")
	}
	return name
}

// contentRules configures gitleaks for library content: its default rules with
// nothing allowlisted. The repository's .gitleaks.toml allowlists provisioning
// fixtures, which must never hide a secret in content that ships to engineers.
const contentRules = "[extend]\nuseDefault = true\n"

// Gitleaks scans with a gitleaks binary. CI passes the checksum-verified 8.30.1
// that its secret-scan step downloads.
type Gitleaks struct{ Path string }

// NewGitleaks returns a Scanner for the gitleaks executable at path, or the
// executable of that name on PATH.
func NewGitleaks(path string) Scanner { return Gitleaks{Path: path} }

func (g Gitleaks) binary() (string, error) {
	bin, err := exec.LookPath(g.Path)
	if err != nil {
		return "", fmt.Errorf("secret scanner %q not found (install gitleaks 8.30.1 or pass -gitleaks): %w", g.Path, err)
	}
	return bin, nil
}

// Name runs "gitleaks version".
func (g Gitleaks) Name(ctx context.Context) (string, error) {
	bin, err := g.binary()
	if err != nil {
		return "", err
	}
	out, err := exec.CommandContext(ctx, bin, "version").Output()
	if err != nil {
		return "", fmt.Errorf("secret scanner %q did not run: %w", g.Path, err)
	}
	return "gitleaks " + strings.TrimSpace(string(out)), nil
}

// Scan runs "gitleaks dir" on root and reads its JSON report.
func (g Gitleaks) Scan(ctx context.Context, root string) ([]Finding, error) {
	bin, err := g.binary()
	if err != nil {
		return nil, err
	}
	// Resolve links such as macOS /var -> /private/var, so report paths match.
	if root, err = filepath.EvalSymlinks(root); err != nil {
		return nil, fmt.Errorf("prepare secret scan: %w", err)
	}
	work, err := os.MkdirTemp("", "library-gate-gitleaks-")
	if err != nil {
		return nil, fmt.Errorf("prepare secret scan: %w", err)
	}
	defer os.RemoveAll(work)
	config := filepath.Join(work, "content-rules.toml")
	noIgnore := filepath.Join(work, "no-ignore")
	reportPath := filepath.Join(work, "findings.json")
	if err := os.WriteFile(config, []byte(contentRules), 0o600); err != nil {
		return nil, fmt.Errorf("prepare secret scan: %w", err)
	}
	if err := os.Mkdir(noIgnore, 0o700); err != nil {
		return nil, fmt.Errorf("prepare secret scan: %w", err)
	}

	ctx, cancel := context.WithTimeout(ctx, 2*time.Minute)
	defer cancel()
	// gitleaks honours <scanned folder>/.gitleaksignore and inline gitleaks:allow
	// comments. The scanned folder is one the gate wrote (no ignore file), and
	// --ignore-gitleaks-allow turns the comments off.
	command := exec.CommandContext(ctx, bin, "dir", ".",
		"--config", config, "--gitleaks-ignore-path", noIgnore, "--ignore-gitleaks-allow",
		"--no-banner", "--redact", "--log-level", "error",
		"--report-format", "json", "--report-path", reportPath, "--exit-code", "0")
	command.Dir = root
	command.Env = withoutGitleaksSettings(os.Environ())
	var output bytes.Buffer
	command.Stdout, command.Stderr = &output, &output
	if err := command.Run(); err != nil {
		return nil, fmt.Errorf("secret scan failed: %w: %s", err, strings.TrimSpace(output.String()))
	}
	raw, err := os.ReadFile(reportPath)
	if err != nil {
		return nil, fmt.Errorf("secret scan wrote no report: %w", err)
	}
	var leaks []struct {
		RuleID    string
		File      string
		StartLine int
	}
	if err := json.Unmarshal(raw, &leaks); err != nil {
		return nil, fmt.Errorf("secret scan report is not JSON: %w", err)
	}
	findings := make([]Finding, 0, len(leaks))
	for _, leak := range leaks {
		file := leak.File
		if filepath.IsAbs(file) {
			if rel, err := filepath.Rel(root, file); err == nil {
				file = rel
			}
		}
		findings = append(findings, Finding{Path: filepath.ToSlash(filepath.Clean(file)), Rule: leak.RuleID, Line: leak.StartLine})
	}
	return findings, nil
}

// withoutGitleaksSettings drops GITLEAKS_CONFIG and friends, so a developer's
// or runner's environment cannot swap in an allowlist.
func withoutGitleaksSettings(environ []string) []string {
	kept := make([]string, 0, len(environ))
	for _, entry := range environ {
		if !strings.HasPrefix(entry, "GITLEAKS_") {
			kept = append(kept, entry)
		}
	}
	return kept
}
```

Probe in T3 and adjust only if the probe disproves an assumption (record it in the report): gitleaks 8.30.1 writes `[]` to `--report-path` when it finds nothing; `File` in the report is relative to `command.Dir` when scanning `.`; `--log-level error` is accepted. Never weaken `--ignore-gitleaks-allow`, the empty ignore folder, the environment scrub or the default-rules config to make a probe pass.

### Code: `internal/library/gate/report.go`

```go
package gate

import (
	"encoding/json"
	"fmt"
	"io"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
)

var toolNames = map[library.Tool]string{
	library.ToolClaudeCode: "Claude Code",
	library.ToolCodex:      "Codex",
	library.ToolCursor:     "Cursor",
}

// WriteLog writes one line per item and one per failure, for the CI log.
// Failure lines read "FAIL <item> <tool>: <stage>: <reason>".
func WriteLog(w io.Writer, report Report) error {
	var out strings.Builder
	tools := make([]string, len(report.Tools))
	for index, tool := range report.Tools {
		tools[index] = string(tool)
	}
	fmt.Fprintf(&out, "library-gate: %s %s, %d items, tools %s, secrets %s\n",
		report.Library.Name, report.Library.Version, len(report.Items), strings.Join(tools, " "), report.Scanner)
	for _, item := range report.Items {
		state := "PASS"
		if !item.Passed {
			state = "FAIL"
		}
		fields := make([]string, 0, len(item.Tools)+1)
		for _, tool := range item.Tools {
			word := string(tool.Status)
			if !tool.Declared {
				word = "not-declared(" + word + ")"
			}
			fields = append(fields, string(tool.Tool)+"="+word)
		}
		secrets := "clean"
		if len(item.Secrets) > 0 {
			secrets = fmt.Sprintf("%d-found", len(item.Secrets))
		}
		fields = append(fields, "secrets="+secrets)
		fmt.Fprintf(&out, "%s %s %s\n", state, item.Key, strings.Join(fields, " "))
	}
	for _, failure := range report.Failures {
		fmt.Fprintf(&out, "FAIL %s: %s: %s\n", subject(failure), failure.Stage, oneLine(failure.Reason))
	}
	if report.Passed {
		out.WriteString("library-gate: PASSED\n")
	} else {
		fmt.Fprintf(&out, "library-gate: FAILED with %d problem(s)\n", len(report.Failures))
	}
	_, err := io.WriteString(w, out.String())
	return err
}

func subject(failure Failure) string {
	switch {
	case failure.Item != "" && failure.Tool != "":
		return failure.Item + " " + string(failure.Tool)
	case failure.Item != "":
		return failure.Item
	default:
		return "library"
	}
}

// WriteMarkdown writes the compatibility report for the CI job summary: the
// verdict, one table row per item, then problems and warnings. Item keys are in
// code spans, because GitHub autolinks name@1.0.0 as an email address.
func WriteMarkdown(w io.Writer, report Report) error {
	var out strings.Builder
	verdict := "PASSED"
	if !report.Passed {
		verdict = "FAILED"
	}
	fmt.Fprintf(&out, "## Content library quality gate: %s\n\n", verdict)
	if report.Library.Name != "" {
		fmt.Fprintf(&out, "%s %s: %d items checked for Claude Code, Codex and Cursor. Secret scan: %s, default rules, nothing allowlisted.\n\n",
			cell(report.Library.Name), cell(report.Library.Version), len(report.Items), cell(report.Scanner))
	}
	if len(report.Items) > 0 {
		out.WriteString("| Item | Claude Code | Codex | Cursor | Secrets |\n| --- | --- | --- | --- | --- |\n")
		for _, item := range report.Items {
			row := []string{"`" + item.Key + "`"}
			for _, tool := range item.Tools {
				row = append(row, toolCell(tool))
			}
			secrets := "clean"
			if len(item.Secrets) > 0 {
				secrets = fmt.Sprintf("**%d found**", len(item.Secrets))
			}
			row = append(row, secrets)
			out.WriteString("| " + strings.Join(row, " | ") + " |\n")
		}
		out.WriteString("\n")
	}
	if len(report.Failures) > 0 {
		out.WriteString("### Problems\n\n")
		for _, failure := range report.Failures {
			who := "library"
			if failure.Item != "" {
				who = "`" + failure.Item + "`"
			}
			if failure.Tool != "" {
				who += ", " + toolNames[failure.Tool]
			}
			fmt.Fprintf(&out, "- %s, %s: %s\n", who, failure.Stage, cell(failure.Reason))
		}
		out.WriteString("\n")
	}
	var warnings []string
	for _, item := range report.Items {
		for _, tool := range item.Tools {
			if !tool.Declared || tool.Status == StatusSkipped {
				continue // a skipped cell already says why
			}
			for _, warning := range tool.Warnings {
				warnings = append(warnings, fmt.Sprintf("- `%s`, %s: %s", item.Key, toolNames[tool.Tool], cell(warning)))
			}
		}
	}
	if len(warnings) > 0 {
		out.WriteString("### Warnings (rendered, but the tool drops part of the item)\n\n" + strings.Join(warnings, "\n") + "\n\n")
	}
	_, err := io.WriteString(w, out.String())
	return err
}

func toolCell(tool ToolResult) string {
	if !tool.Declared {
		return "not declared"
	}
	switch tool.Status {
	case StatusRendered:
		return "rendered: " + fileList(tool.Files)
	case StatusRenderedWithWarnings:
		return fmt.Sprintf("rendered with %d warning(s): %s", len(tool.Warnings), fileList(tool.Files))
	case StatusSkipped:
		return "skipped: " + cell(tool.Reason)
	default:
		return "**FAILED**: " + cell(tool.Reason)
	}
}

func fileList(files []string) string {
	shown := files
	if len(shown) > 3 {
		shown = shown[:3]
	}
	parts := make([]string, len(shown))
	for index, file := range shown {
		parts[index] = "`" + strings.ReplaceAll(file, "`", "") + "`"
	}
	list := strings.Join(parts, ", ")
	if extra := len(files) - len(shown); extra > 0 {
		list += fmt.Sprintf(" and %d more", extra)
	}
	return list
}

// cell makes text safe inside a Markdown table cell: one line, no pipes, no HTML.
func cell(text string) string {
	return strings.NewReplacer("\r", " ", "\n", " ", "|", `\|`, "<", "&lt;", ">", "&gt;").Replace(text)
}

func oneLine(text string) string {
	return strings.NewReplacer("\r", " ", "\n", " ").Replace(text)
}

// WriteJSON writes the full report as indented JSON.
func WriteJSON(w io.Writer, report Report) error {
	encoder := json.NewEncoder(w)
	encoder.SetEscapeHTML(false)
	encoder.SetIndent("", "  ")
	return encoder.Encode(report)
}
```

### Code: `cmd/library-gate/main.go`

```go
// Command library-gate is the content library quality gate CI runs on every
// change (story 86bcm901u): layout, schema, per-tool render and secret scan for
// every item. Exit 0: every item passes. Exit 1: an item failed; the log names
// the item and tool. Exit 2: the gate could not run.
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/signal"

	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	code := run(ctx, os.Args[1:], os.Stdout, os.Stderr, gate.NewGitleaks)
	stop()
	os.Exit(code)
}

func run(ctx context.Context, args []string, stdout, stderr io.Writer, newScanner func(path string) gate.Scanner) int {
	flags := flag.NewFlagSet("library-gate", flag.ContinueOnError)
	flags.SetOutput(stderr)
	dir := flags.String("dir", "internal/library/content", "library source folder to check")
	gitleaks := flags.String("gitleaks", "gitleaks", "gitleaks executable: a path, or a name on PATH")
	summary := flags.String("summary", "", "append the Markdown report to this file (CI passes $GITHUB_STEP_SUMMARY)")
	jsonPath := flags.String("json", "", "write the JSON report to this file")
	if err := flags.Parse(args); err != nil {
		if errors.Is(err, flag.ErrHelp) {
			return 0
		}
		return 2
	}
	if flags.NArg() > 0 {
		fmt.Fprintf(stderr, "library-gate: unexpected arguments: %v\n", flags.Args())
		return 2
	}
	if info, err := os.Stat(*dir); err != nil || !info.IsDir() {
		fmt.Fprintf(stderr, "library-gate: %s is not a library folder\n", *dir)
		return 2
	}
	report, err := gate.Run(ctx, os.DirFS(*dir), newScanner(*gitleaks))
	if err != nil {
		fmt.Fprintf(stderr, "library-gate: %v\n", err)
		return 2
	}
	if err := gate.WriteLog(stdout, report); err != nil {
		fmt.Fprintf(stderr, "library-gate: write log: %v\n", err)
		return 2
	}
	if *jsonPath != "" {
		if err := writeReport(*jsonPath, false, func(w io.Writer) error { return gate.WriteJSON(w, report) }); err != nil {
			fmt.Fprintf(stderr, "library-gate: write %s: %v\n", *jsonPath, err)
			return 2
		}
	}
	if *summary != "" {
		if err := writeReport(*summary, true, func(w io.Writer) error { return gate.WriteMarkdown(w, report) }); err != nil {
			fmt.Fprintf(stderr, "library-gate: write %s: %v\n", *summary, err)
			return 2
		}
	}
	if !report.Passed {
		return 1
	}
	return 0
}

// writeReport writes a report file, or appends to it (the CI job summary is
// shared by every step).
func writeReport(name string, appendTo bool, write func(io.Writer) error) (err error) {
	mode := os.O_WRONLY | os.O_CREATE | os.O_TRUNC
	if appendTo {
		mode = os.O_WRONLY | os.O_CREATE | os.O_APPEND
	}
	file, err := os.OpenFile(name, mode, 0o644)
	if err != nil {
		return err
	}
	defer func() {
		if closeErr := file.Close(); err == nil {
			err = closeErr
		}
	}()
	return write(file)
}
```

The 0/1/2 exit contract is pinned by tests on `run()`. Through `make` any failure exits 2, and through `go run` any non-zero child exit becomes 1; never assert those wrapper codes.

### CI and Make changes (exact)

`.github/workflows/ci.yml`, job `quality`: insert this step between "Verify story delivery gate" and "Vet":

```yaml
      - name: Check content library quality
        run: make library-check GITLEAKS="${RUNNER_TEMP}/gitleaks" LIBRARY_SUMMARY="${GITHUB_STEP_SUMMARY}"

```

and give "Test with the race detector" an `env:` block, so the gate's real-gitleaks tests run in CI instead of skipping:

```yaml
      - name: Test with the race detector
        env:
          LEORNA_TEST_GITLEAKS_BIN: ${{ runner.temp }}/gitleaks
        run: make test
```

Nothing else in the workflow changes: `git diff --numstat origin/main...HEAD -- .github/workflows/ci.yml` must show 0 deleted lines. The gitleaks binary already exists by then (first step of the job). The step fails the required "Go quality gates" check on exit 1 or 2.

`Makefile`: add `library-check` to `.PHONY`, make `check` read `check: workspace contracts-check fmt vet test lint audit secrets library-check build`, and add:

```make
# Content library quality gate (story 86bcm901u): layout, schema, per-tool render
# and secret scan for every item. CI passes the job summary as LIBRARY_SUMMARY.
LIBRARY_DIR ?= internal/library/content
LIBRARY_SUMMARY ?=
LIBRARY_REPORT ?=

library-check:
	$(GO) run ./cmd/library-gate -dir "$(LIBRARY_DIR)" -gitleaks "$(GITLEAKS)"$(if $(LIBRARY_SUMMARY), -summary "$(LIBRARY_SUMMARY)")$(if $(LIBRARY_REPORT), -json "$(LIBRARY_REPORT)")
```

(`GITLEAKS ?= gitleaks` already exists at the top of the Makefile. `$(if …)` works on macOS's GNU make 3.81.)

`.gitattributes`: add after the integration lines:

```
# Client transformer goldens copied for the library gate's parity tests (86bcm901u).
internal/library/render/testdata/** text eol=lf
```

## Tasks (in order, test first)

Builder scratch: `S=~/.hermes/cache/scratch/86bcm901u-v3`. Worktree: `W=~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`. Evidence: `EVID=~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3`. Every Go command runs inside `$W`. Never use `-c user.email`, `--author` or AI attribution lines in commits (Justin's CLAUDE.md overrides any tool reminder to add them).

### T0. Set up (about 10 min)

```bash
cd ~/Leorna/leorna-control-plane
git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main
git rev-parse origin/main          # planned on 6e74ced843642439d1dac9f25673440fb0f285f5
git log --oneline 6e74ced..origin/main -- internal/library internal/pack .github/workflows Makefile go.mod
```

- If `origin/main` moved and that log is non-empty, read those commits. If they change the library format, the CI job or the Makefile in a way this plan doesn't cover, stop and report before writing code. If PR #85 (prompt kind) is among them, do T7 as well.
- `git worktree add -b feat/86bcm901u-quality-gate-v3 .claude/worktrees/86bcm901u-quality-gate-v3 origin/main`. Don't touch local `main`, other worktrees, other branches or `deploy/local/`. Don't set an upstream.
- Tools (task-local PATH only): `export PATH="$HOME/.hermes/cache/scratch/leorna-bin:/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:$PATH"`; `golangci-lint --version` must print 2.14.0; `GOBIN=$HOME/.hermes/cache/scratch/leorna-bin go install golang.org/x/vuln/cmd/govulncheck@v1.7.0`; `gitleaks version` must print 8.30.1.
- Own test DB (name must end in `_test`; never share or drop another story's):
  `docker exec leorna-test-pg psql -U leorna -d leorna_test -tAc "SELECT 1 FROM pg_database WHERE datname='leorna_86bcm901u_v3_test'" | grep -q 1 || docker exec leorna-test-pg createdb -U leorna leorna_86bcm901u_v3_test`
  `export LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901u_v3_test?sslmode=disable'`
- `export LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)"`
- Client sources for T1 (scratch only, never the real client checkout):
  ```bash
  mkdir -p "$S" && git -c credential.helper= -c 'credential.helper=!gh auth git-credential' clone -q https://github.com/LeornaAI/leorna-client.git "$S/client"
  git -C "$S/client" checkout -q ea2b8ab6fc0ebde438476f0b3d1bb43bc6a47f8a
  git -C "$S/client" -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch -q origin refs/pull/20/head:refs/remotes/pr20
  git -C "$S/client" rev-parse pr20    # expect 1f259b0faaeb21cac0913ebb97a52d5f23bdc88b; if it moved, use the new head and record it
  ```
- **Before-state capture** (see Evidence): in `$S/before`, `git -C "$W" archive 6e74ced | tar -x -C "$S/before"`, add the broken item (T9 text) under `internal/library/content/items/mcp_template/broken-args/`, run `go test -count=1 ./internal/library -run TestContentLock -update-lock` there, then `go test -v -count=1 -run 'TestEmbeddedLibraryIsValid|TestContentLockPinsEveryItemVersion' ./internal/library` → PASS. That shows main accepts an item Codex can't render. Capture it as `before-main-accepts-broken-item.png`.

### T1. Port the client's renderers (`internal/library/render`) (60–90 min)

1. **Fixtures.** Copy byte-for-byte from `$S/client` at `ea2b8ab` into `internal/library/render/testdata/client/`:
   - `toolconnector/testdata/pack.json` → `pack.json`
   - `toolconnector/claudecode/testdata/invalid-permissions-pack.json` → `invalid-permissions-pack.json`
   - `toolconnector/claudecode/testdata/golden/**` → `golden/claude-code/**` (`.mcp.json`, `.claude/settings.json`, two `.claude/skills/*/SKILL.md`)
   - `toolconnector/codex/testdata/golden/**` → `golden/codex/**` (`config.toml`, two `skills/*/SKILL.md`)
   - `toolconnector/cursor/testdata/golden/**` → `golden/cursor/**` (`mcp.json`, `cli-config.json`, two `skills/*/SKILL.md`)
   - `toolconnector/testdata/golden/integrations/**` → `golden/integrations/**` (5 variants × 3 tools)

   Write `testdata/client/SOURCE.md`: repo, the two commits (`ea2b8ab6fc0ebde438476f0b3d1bb43bc6a47f8a` for files and rules; `1f259b0faaeb21cac0913ebb97a52d5f23bdc88b`, client PR #20, for prompt rules), a table of client path → copy path, and then one line per file in `shasum -a 256` form (`<64 hex>  <path relative to testdata/client>`), made with `cd internal/library/render/testdata/client && find . -type f ! -name SOURCE.md | sort | xargs shasum -a 256 | sed 's#  \./#  #'`. The integration inputs are the control plane's own `internal/integration/testdata/rendered/*.json` (identical to the client's copies), so don't copy them. Add the `.gitattributes` line.
2. **RED.** Write `render_test.go` (package `render`) with:
   - `TestTransformMatchesClientGoldens`: decode `testdata/client/pack.json` (`DisallowUnknownFields`) into `Pack`; for each of the three tools, `Transform` and compare with `golden/<tool>/`: exactly the same file set, byte for byte (helper `compareGolden` walks the golden folder; reports "golden file was not produced", "produced but the client has no golden file", "content differs").
   - `TestIntegrationTemplatesMatchClientGoldens`: for each `../../integration/testdata/rendered/*.json`, build the one-item pack exactly as the client's `TestIntegrationTilesRenderForEveryTool` does (`Name: "integrations", Version: "1"`, item kind `mcp_template`, name = text before `--`, version `0.1.0`, description `"Integration tile " + variant`), require no warnings, and compare with `golden/integrations/<variant>/<tool>/`.
   - `TestClientFixturesMatchSource`: every file under `testdata/client` except `SOURCE.md` is listed in SOURCE.md with its sha256, and every listed file exists.

   Run `go test -count=1 ./internal/library/render`. Expected RED: build failure `undefined: Transform` / `undefined: Pack`.
3. **GREEN: copy the rules.** Write `render.go` (code above). Create `shared.go`, `claudecode.go`, `codex.go`, `cursor.go` by copying the client files at `ea2b8ab` (`toolconnector/transform.go`; `claudecode/config.go`; `codex/config.go`; `cursor/config.go`) with **only** these mechanical changes, and every format string, regexp, map, key order and sort left exactly as it is:
   - `package render`; drop the `tc`/`toolconnectors` import; types: `tc.Pack` → `Pack`, `tc.PackItem` → `Item`, `tc.PackKindSkill/Agent/Config/MCPTemplate` → `pack.KindSkill/KindAgent/KindConfig/KindMCPTemplate`, `tc.ConfigBundle{ToolID: x, …}` → `Bundle{Tool: x, …}`, `tc.ToolID` / `t.ID()` / `ID` → `library.ToolClaudeCode` / `library.ToolCodex` / `library.ToolCursor`, `tc.ErrInvalid/ErrUnsupported/ErrConflict` → `ErrInvalid/ErrUnsupported/ErrConflict`.
   - Unexport the shared helpers: `RenderSkill`→`renderSkill`, `AgentWarnings`→`agentWarnings`, `MCPServer`→`mcpServerDef`, `MCPExtraKey`→`mcpExtraKey`, `CollectMCPServers`→`collectMCPServers`, `CollectMCPServersWithExtras`→`collectMCPServersWithExtras`, `ConfigForTool`→`configForTool`, `WholePlaceholder`→`wholePlaceholder`, `HasPlaceholder`→`hasPlaceholder`, `RewritePlaceholders`→`rewritePlaceholders`. Keep `collectMCPServers`'s private worker as `collectServers`, and keep `parseMCPTemplate`, `decodeOne`, `skillName`, `mcpServerName`, `placeholder` and `maxSkillNameBytes` as they are.
   - Each `Transformer.Transform` becomes a function: `transformClaudeCode(p Pack) (Bundle, error)`, `transformCodex`, `transformCursor`.
   - Rename clashing names: Claude `renderMCP`→`claudeMCP`, `mcpServer`→`claudeServer`, `mcpFile`→`claudeMCPFile`, `settingsFile`→`claudeSettingsFile`, `skillsDir`→`claudeSkillsDir`, `renderSettings`→`claudeSettings`, `checkPermissions`→`claudePermissions`. Cursor `renderMCP`→`cursorMCP`, `mcpServer`→`cursorServer`, `mcpFile`→`cursorMCPFile`, `cliConfigFile`→`cursorCLIConfigFile`, `envForm*` unchanged. Codex `configFile`→`codexConfigFile`, `serverTable`→`codexServerTable`, `remoteTable`→`codexRemoteTable`, the rest unchanged.
   - Header comment in each file: `// Copied from LeornaAI/leorna-client toolconnector/<path> at ea2b8ab (see testdata/client/SOURCE.md). Keep it identical to the client; change it only by copying a merged client change.`

   Run the same command: GREEN. A byte difference is a copying mistake; fix the copy, never the golden.
4. **Prompt rules (Q5-A), test first.** Add `TestPromptsMatchClientPR20` mirroring `toolconnector/prompt_transform_test.go` at `1f259b0` (expected bytes copied from it):
   - Claude Code writes `.claude/commands/pr-description.md` = `"---\ndescription: \"Draft a PR: summary & tests\"\ndisable-model-invocation: true\n---\n\nWrite it.\n\nUse $ARGUMENTS.\n"` for the client's `promptPack()`; an empty description omits the description line; a description with a newline can't add frontmatter keys.
   - Cursor writes `commands/pr-description.md` = `"Write it.\n\nUse $ARGUMENTS.\n"`.
   - Codex writes no prompt file, and its warnings are exactly `prompt "<name>" is not installed for codex: Codex removed custom prompts in 0.117.0 and has no prompt location; skipped`, sorted.
   - Unsafe prompt names (`../escape`, `Has Space`, `UPPER`, `a--b`, 65 a's) and an empty body are refused with `ErrInvalid` and zero files, on Claude Code and Cursor.

   RED (`undefined`/wrong output), then add `prompt.go` with `codexPromptSkipReason`, `promptName` and `skippedPromptWarnings` (copied from client PR #20 `toolconnector/prompt.go`), Claude's `claudeCommandsDir = ".claude/commands/"` + `claudePrompt`, Cursor's `cursorCommandsDir = "commands/"` + `cursorPrompt`, the `switch item.Kind { case skill…; case kindPrompt… }` loops in `transformClaudeCode` / `transformCursor`, and `warnings = append(warnings, skippedPromptWarnings(p, library.ToolCodex, codexPromptSkipReason)...)` in `transformCodex`, all as in PR #20. GREEN.
5. **Failure parity.** Add `TestTransformRejectsWhatTheClientRejects`, a table of the client's refusal cases at `ea2b8ab`, each asserting `errors.Is(err, <sentinel>)`, an error substring, and zero files. At least:

   | Tool | Item | Sentinel | Substring |
   | --- | --- | --- | --- |
   | codex | MCP server with `"args":["--token","${API_TOKEN}"]` | ErrUnsupported | `has a placeholder in its args, which Codex cannot express` |
   | codex | `"command":"${BIN}"` | ErrUnsupported | `has a placeholder in its command` |
   | codex | env value `"Bearer ${T}"` | ErrUnsupported | `has a placeholder inside env value` |
   | codex | url server with `args` | ErrUnsupported | `is a remote server with args or env` |
   | codex | `codex-x` config already holding `[mcp_servers.github]` plus a `github` template | ErrConflict | `already declares MCP server "github"` |
   | codex | configs `codex-a` and `codex-b` | ErrConflict | `both target codex` |
   | claude-code | `testdata/client/invalid-permissions-pack.json` | ErrInvalid | (copy from the client's test) |
   | claude-code | `"command"` with `"type":"http"` | ErrInvalid | `has a command but type "http"` |
   | cursor | `cursor-cli` config body `[1,2]` | ErrInvalid | `must be one JSON object` |
   | all three | MCP template body `not json` | ErrInvalid | `is not one JSON object` |
   | all three | server with both `command` and `url` | ErrInvalid | `needs exactly one of command or url` |
   | all three | server name `bad name` | ErrInvalid | `unsafe server name` |
   | all three | skill named `Bad_Name` | ErrInvalid | `must be lowercase letters, digits and hyphens` |

   Then add every other refusal case in `codex/config_test.go` (`TestTransformRejectsPacksItCannotRender`), `claudecode/config_test.go`, `cursor/config_test.go` and `transform_test.go` at `ea2b8ab`. It passes at once if the copy is faithful; prove it can fail by deleting the Codex args check (mutation M8 in T10).
6. Add `TestNotInstalledMatchesTransformerWarnings`: for (agent, each tool) and (prompt, codex), `Transform` gives zero files and exactly one warning that contains `is not installed for <tool>` and ends `; skipped`, and `NotInstalled` returns true. For skill, config, mcp_template on every tool and prompt on Claude Code and Cursor, `NotInstalled` returns false.
7. `go get github.com/BurntSushi/toml@v1.6.0` is **not** needed yet (T2 uses it). Commit (explicit paths): `feat(86bcm901u): render library items with the desktop client's per-tool rules` (render package, testdata, `.gitattributes`).

### T2. Gate core (`internal/library/gate/gate.go`) (40–60 min)

1. **RED.** `gate_test.go` (package `gate`, internal, so the base-commit run fails to build). Write AC1's first two subtests and the helpers below; run `go test -count=1 -run '^TestAC1ValidatesRendersAndScansEveryItem$' ./internal/library/gate` → `undefined: Run`.

```go
package gate

import (
	"context"
	"crypto/sha256"
	"encoding/json"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

func TestAC1ValidatesRendersAndScansEveryItem(t *testing.T) {
	ctx := context.Background()

	t.Run("every item is schema-checked, rendered for all three tools and scanned", func(t *testing.T) {
		scanner := &recordingScanner{}
		report, err := Run(ctx, writeLibrary(t, sampleLibrary()), scanner)
		if err != nil {
			t.Fatalf("Run: %v", err)
		}
		if !report.Passed || len(report.Failures) != 0 {
			t.Fatalf("the sample library should pass; failures: %+v", report.Failures)
		}
		want := map[string][3]Status{
			"agent/reviewer@1.0.0":              {StatusSkipped, StatusSkipped, StatusSkipped},
			"config/claude-code-settings@1.0.0": {StatusRendered, StatusFailed, StatusFailed},
			"config/codex-defaults@1.0.0":       {StatusFailed, StatusRendered, StatusFailed},
			"mcp_template/github-mcp@1.0.0":     {StatusRendered, StatusRendered, StatusRendered},
			"skill/write-tests@1.0.0":           {StatusRendered, StatusRendered, StatusRendered},
		}
		declared := map[string][3]bool{
			"agent/reviewer@1.0.0":              {true, false, false},
			"config/claude-code-settings@1.0.0": {true, false, false},
			"config/codex-defaults@1.0.0":       {false, true, false},
			"mcp_template/github-mcp@1.0.0":     {true, true, true},
			"skill/write-tests@1.0.0":           {true, true, true},
		}
		if len(report.Items) != len(want) {
			t.Fatalf("report has %d items, want %d", len(report.Items), len(want))
		}
		for _, item := range report.Items {
			statuses, known := want[item.Key]
			if !known {
				t.Fatalf("unexpected item %s", item.Key)
			}
			if item.Schema != "pass" || !item.Passed {
				t.Errorf("%s: schema %q, passed %v", item.Key, item.Schema, item.Passed)
			}
			if len(item.Tools) != len(Tools) {
				t.Fatalf("%s was rendered for %d tools, want %d", item.Key, len(item.Tools), len(Tools))
			}
			for index, tool := range item.Tools {
				if tool.Tool != Tools[index] || tool.Status != statuses[index] || tool.Declared != declared[item.Key][index] {
					t.Errorf("%s %s: status %s declared %v, want %s %s declared %v",
						item.Key, tool.Tool, tool.Status, tool.Declared, Tools[index], statuses[index], declared[item.Key][index])
				}
			}
			base := string(item.Kind) + "/" + item.Name + "/"
			for _, name := range []string{"item.json", "body.md", "example.md"} {
				if !scanner.scanned[base+"source/"+name] {
					t.Errorf("%s: %s was not secret-scanned", item.Key, name)
				}
			}
			for _, tool := range item.Tools {
				for _, file := range tool.Files {
					if !scanner.scanned[base+string(tool.Tool)+"/"+flatName(file)] {
						t.Errorf("%s: %s output %s was not secret-scanned", item.Key, tool.Tool, file)
					}
				}
			}
		}
	})

	t.Run("a schema error fails the run and names the item", func(t *testing.T) {
		files := sampleLibrary()
		files["items/skill/write-tests/item.json"] = strings.Replace(files["items/skill/write-tests/item.json"], `"1.0.0"`, `"1.0"`, 1)
		report, err := Run(ctx, writeLibrary(t, files), &recordingScanner{})
		if err != nil {
			t.Fatalf("Run: %v", err)
		}
		if report.Passed || len(report.Failures) != 1 || report.Failures[0].Stage != StageSchema ||
			!strings.Contains(report.Failures[0].Reason, "skill/write-tests") {
			t.Fatalf("failures = %+v, want one schema failure naming skill/write-tests", report.Failures)
		}
	})
}

// sampleLibrary has one item of each kind; every item passes.
func sampleLibrary() map[string]string {
	meta := func(tools string) string {
		return `{"version":"1.0.0","category":"testing","tags":["gate"],"tools":` + tools + `,"description":"Gate test item."}`
	}
	all := `["claude-code","codex","cursor"]`
	return map[string]string{
		"library.json":                                 `{"name":"Gate test library","version":"1.0.0"}`,
		"items/skill/write-tests/item.json":            meta(all),
		"items/skill/write-tests/body.md":              "# Write tests\nWrite the failing test first.\n",
		"items/skill/write-tests/example.md":           "Ask for tests first.\n",
		"items/agent/reviewer/item.json":               meta(`["claude-code"]`),
		"items/agent/reviewer/body.md":                 "You review diffs.\n",
		"items/agent/reviewer/example.md":              "Use the reviewer.\n",
		"items/config/claude-code-settings/item.json":  meta(`["claude-code"]`),
		"items/config/claude-code-settings/body.md":    `{"permissions":{"allow":["Bash(go test:*)"]}}` + "\n",
		"items/config/claude-code-settings/example.md": "Copy into settings.\n",
		"items/config/codex-defaults/item.json":        meta(`["codex"]`),
		"items/config/codex-defaults/body.md":          "approval_policy = \"on-request\"\n",
		"items/config/codex-defaults/example.md":       "Copy into config.toml.\n",
		"items/mcp_template/github-mcp/item.json":      meta(all),
		"items/mcp_template/github-mcp/body.md":        `{"mcpServers":{"github":{"command":"npx","args":["-y","@modelcontextprotocol/server-github"],"env":{"GITHUB_TOKEN":"${GITHUB_TOKEN}"}}}}` + "\n",
		"items/mcp_template/github-mcp/example.md":     "List my pull requests.\n",
	}
}

func writeLibraryDir(t *testing.T, files map[string]string) string {
	t.Helper()
	dir := t.TempDir()
	for name, content := range files {
		full := filepath.Join(dir, filepath.FromSlash(name))
		if err := os.MkdirAll(filepath.Dir(full), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(full, []byte(content), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	return dir
}

func writeLibrary(t *testing.T, files map[string]string) fs.FS {
	return os.DirFS(writeLibraryDir(t, files))
}

// recordingScanner finds nothing and records every file it was given.
type recordingScanner struct{ scanned map[string]bool }

func (s *recordingScanner) Name(context.Context) (string, error) { return "recording scanner", nil }

func (s *recordingScanner) Scan(_ context.Context, root string) ([]Finding, error) {
	s.scanned = map[string]bool{}
	err := filepath.WalkDir(root, func(name string, entry fs.DirEntry, err error) error {
		if err != nil || entry.IsDir() {
			return err
		}
		rel, err := filepath.Rel(root, name)
		if err != nil {
			return err
		}
		s.scanned[filepath.ToSlash(rel)] = true
		return nil
	})
	return nil, err
}

// gitleaksForTest returns the gitleaks binary from LEORNA_TEST_GITLEAKS_BIN or
// PATH. CI sets the variable to the checksum-verified binary its secret-scan
// step downloads.
func gitleaksForTest(t *testing.T) string {
	t.Helper()
	if bin := os.Getenv("LEORNA_TEST_GITLEAKS_BIN"); bin != "" {
		return bin
	}
	bin, err := exec.LookPath("gitleaks")
	if err != nil {
		t.Skip("gitleaks not found: set LEORNA_TEST_GITLEAKS_BIN to run the secret-scan tests")
	}
	return bin
}

// fakeGitHubToken builds a token-shaped string at run time, so no secret-looking
// literal sits in this file for the repository's own gitleaks scan to flag.
func fakeGitHubToken() string {
	const alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	sum := sha256.Sum256([]byte("leorna library gate test token"))
	var token strings.Builder
	token.WriteString("gh" + "p_")
	for index := 0; index < 36; index++ {
		token.WriteByte(alphabet[int(sum[index%len(sum)]+byte(index))%len(alphabet)])
	}
	return token.String()
}

var _ = json.Marshal // used by the secret subtest added in T3
```

   (Drop the `var _ = json.Marshal` line once T3 uses `json`.)
2. **GREEN.** Write `gate.go` (code above) and the `Finding`/`Scanner`/`scanSecrets`/`flatName` half of `scan.go` (code above, without the `Gitleaks` type yet). Run `go get github.com/BurntSushi/toml@v1.6.0` from `$W`. toml is already in the module graph at v1.3.2 through `github.com/oapi-codegen/runtime` (planner's scratch check: `go mod graph`), so `go get` prints "upgraded … v1.3.2 => v1.6.0" and adds it as `// indirect`. Move that line into the first (direct) `require` block without the `// indirect` comment, then check `git diff go.mod go.sum go.work.sum` shows only toml lines and `go build ./...` passes. Run the AC1 command: both subtests PASS.
3. Add `gate_more_test.go` (package `gate`), each RED first where the behaviour is new:
   - `TestStrayTopLevelFileFails`: `.gitleaksignore` at the top → one `layout` failure whose reason names `.gitleaksignore`.
   - `TestLinkInLibraryFails`: replace `items/skill/write-tests/body.md` with a symlink to a file outside the library → `layout` failure naming that path.
   - `TestBrokenCodexConfigFailsTheTOMLCheck`: codex-defaults body `approval_policy = \n` → one failure: item `config/codex-defaults@1.0.0`, tool `codex`, stage `render`, reason starting `config.toml is not valid TOML: `.
   - `TestConfigForAnotherToolFailsWhenDeclared`: `claude-code-settings` listing `["claude-code","cursor"]` → one failure for `cursor`, reason starting `renders no files for cursor (a config renders only for the tool its name starts with`.
   - `TestWarningsPassAndAreReported` (Q2-A): settings body `{"permissions":{"allow":["Bash(go test:*)"]},"vimMode":true}` → passes; claude-code status `rendered_with_warnings`; warnings contain `claude-code-settings: setting "vimMode" is not supported by the Claude Code transformer; skipped`.
   - `TestScannerErrorStopsTheGate`: a scanner whose `Scan` returns `errors.New("scanner crashed")` → `Run` returns an error containing it (exit 2 path).
   - `TestScannerReportingAnUnknownFileStopsTheGate`: a scanner returning `Finding{Path: "nowhere/x"}` → `Run` errors.

### T3. gitleaks adapter (25–40 min)

1. **RED.** Add AC1's third subtest to `TestAC1ValidatesRendersAndScansEveryItem`:

```go
	t.Run("a secret fails the run and names the item, in its source and rendered files", func(t *testing.T) {
		bin := gitleaksForTest(t)
		token := fakeGitHubToken()
		files := sampleLibrary()
		// The inline allow comment must not hide it: the gate turns those off.
		files["items/skill/write-tests/body.md"] = "# Write tests\nUse " + token + " here. gitleaks:allow\n"
		report, err := Run(ctx, writeLibrary(t, files), NewGitleaks(bin))
		if err != nil {
			t.Fatalf("Run: %v", err)
		}
		if report.Passed {
			t.Fatal("a library holding a GitHub token passed the gate")
		}
		var inSource, inRendered bool
		for _, failure := range report.Failures {
			if failure.Item != "skill/write-tests@1.0.0" || failure.Stage != StageSecrets {
				t.Errorf("unexpected failure %+v", failure)
			}
			inSource = inSource || strings.HasPrefix(failure.Reason, "body.md: ")
			inRendered = inRendered || strings.Contains(failure.Reason, " output ")
		}
		if !inSource || !inRendered {
			t.Fatalf("failures %+v must cover body.md and a rendered file", report.Failures)
		}
		raw, err := json.Marshal(report)
		if err != nil {
			t.Fatal(err)
		}
		if strings.Contains(string(raw), token) {
			t.Fatal("the report repeats the secret")
		}
	})
```

   RED: `undefined: NewGitleaks`.
2. **GREEN.** Add the `Gitleaks` half of `scan.go` (code above). Run the AC1 command with `LEORNA_TEST_GITLEAKS_BIN` set: three PASS lines, no SKIP. If gitleaks doesn't flag the fake token, change the token's shape (still built at run time), never the gate's flags.
3. Add to `gate_more_test.go`:
   - `TestGitleaksIgnoresConfigFromTheEnvironment`: write an allow-everything config (`[extend]\nuseDefault = true\n[allowlist]\nregexes = ['''.*''']\n`), `t.Setenv("GITLEAKS_CONFIG", thatFile)`, scan a temp folder holding `skill/x/source/body.md` with the fake token → at least one finding with `Path == "skill/x/source/body.md"`.
   - `TestMissingGitleaksIsAnError`: `NewGitleaks(filepath.Join(t.TempDir(), "no-gitleaks")).Name(ctx)` errors and says `not found`.
4. **Confirm with gitleaks itself** that the repo stays clean: `gitleaks git --redact --no-banner --exit-code 1 --log-opts="HEAD"` after committing (the test files hold no token literal).

### T4. Report writers (20–30 min)

1. **RED.** `TestMarkdownReportEscapesAndLinksNothing` in `gate_more_test.go`: a hand-built `Report` with a failure reason `a | b <c>` and an item `skill/x@1.0.0` → output contains `a \| b &lt;c&gt;` and ``| `skill/x@1.0.0` |``, and no raw `<c>`. `TestLogNamesItemAndTool`: a report with a render failure → a line exactly `FAIL mcp_template/x@1.0.0 codex: render: boom`.
2. **GREEN.** `report.go` (code above).
3. Commit: `feat(86bcm901u): content library gate: schema, render and secret scan per item` (gate package, `go.mod`, `go.sum`, and `go.work.sum` only if it changed).

### T5. Command and Make target (30–45 min)

1. **RED.** `cmd/library-gate/main_test.go` (package `main`):

```go
package main

import (
	"bytes"
	"context"
	"encoding/json"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

const realLibrary = "../../internal/library/content"

// brokenArgs passes the schema and renders for Claude Code and Cursor, but Codex
// cannot fill a ${VAR} placeholder inside args, so the desktop client refuses it.
const brokenArgs = `{"mcpServers":{"api":{"command":"api-mcp","args":["--token","${API_TOKEN}"]}}}`

type cleanScanner struct{}

func (cleanScanner) Name(context.Context) (string, error)                 { return "test scanner", nil }
func (cleanScanner) Scan(context.Context, string) ([]gate.Finding, error) { return nil, nil }

func newCleanScanner(string) gate.Scanner { return cleanScanner{} }

func TestAC2RenderFailureFailsCINamingItemAndTool(t *testing.T) {
	ctx := context.Background()

	t.Run("a declared tool that cannot render the item fails the run", func(t *testing.T) {
		dir := copyLibrary(t, realLibrary)
		addItem(t, dir, "mcp_template", "broken-args", `["claude-code","codex","cursor"]`, brokenArgs)
		var stdout, stderr bytes.Buffer
		if code := run(ctx, []string{"-dir", dir}, &stdout, &stderr, newCleanScanner); code != 1 {
			t.Fatalf("exit %d, want 1\n%s%s", code, stdout.String(), stderr.String())
		}
		problems := problemLines(stdout.String())
		want := "FAIL mcp_template/broken-args@1.0.0 codex: render: "
		if len(problems) != 1 || !strings.HasPrefix(problems[0], want) ||
			!strings.Contains(problems[0], "has a placeholder in its args, which Codex cannot express") {
			t.Fatalf("problem lines = %q, want exactly one starting %q", problems, want)
		}
		if !strings.Contains(stdout.String(), "\nFAIL mcp_template/broken-args@1.0.0 claude-code=rendered codex=failed cursor=rendered secrets=clean\n") {
			t.Fatalf("the item line does not show Claude Code and Cursor rendering:\n%s", stdout.String())
		}
		if !strings.HasSuffix(stdout.String(), "library-gate: FAILED with 1 problem(s)\n") {
			t.Fatalf("missing the failed verdict:\n%s", stdout.String())
		}
	})

	t.Run("the same failure on a tool the item does not declare passes", func(t *testing.T) {
		dir := copyLibrary(t, realLibrary)
		addItem(t, dir, "mcp_template", "broken-args", `["claude-code","cursor"]`, brokenArgs)
		var stdout, stderr bytes.Buffer
		if code := run(ctx, []string{"-dir", dir}, &stdout, &stderr, newCleanScanner); code != 0 {
			t.Fatalf("exit %d, want 0\n%s%s", code, stdout.String(), stderr.String())
		}
		if !strings.Contains(stdout.String(), "\nPASS mcp_template/broken-args@1.0.0 claude-code=rendered codex=not-declared(failed) cursor=rendered secrets=clean\n") {
			t.Fatalf("the undeclared Codex failure is not reported:\n%s", stdout.String())
		}
	})

	t.Run("a declared tool that gets no files fails", func(t *testing.T) {
		dir := copyLibrary(t, realLibrary)
		addItem(t, dir, "config", "claude-code-strict", `["claude-code","cursor"]`, `{"permissions":{"deny":["Bash(rm:*)"]}}`)
		var stdout, stderr bytes.Buffer
		if code := run(ctx, []string{"-dir", dir}, &stdout, &stderr, newCleanScanner); code != 1 {
			t.Fatalf("exit %d, want 1\n%s%s", code, stdout.String(), stderr.String())
		}
		problems := problemLines(stdout.String())
		if len(problems) != 1 || !strings.HasPrefix(problems[0], "FAIL config/claude-code-strict@1.0.0 cursor: render: renders no files for cursor") {
			t.Fatalf("problem lines = %q", problems)
		}
	})
}

func TestAC3PassingRunWritesPerItemCompatibilityReport(t *testing.T) {
	bin := gitleaksForTest(t)
	out := t.TempDir()
	summary := filepath.Join(out, "summary.md")
	if err := os.WriteFile(summary, []byte("Earlier step output.\n"), 0o600); err != nil {
		t.Fatal(err)
	}
	reportPath := filepath.Join(out, "report.json")
	var stdout, stderr bytes.Buffer
	code := run(context.Background(), []string{"-dir", realLibrary, "-gitleaks", bin, "-summary", summary, "-json", reportPath},
		&stdout, &stderr, gate.NewGitleaks)
	if code != 0 {
		t.Fatalf("the real library failed the gate (exit %d)\n%s%s", code, stdout.String(), stderr.String())
	}

	lib, err := library.Parse(os.DirFS(realLibrary))
	if err != nil {
		t.Fatal(err)
	}
	raw, err := os.ReadFile(reportPath)
	if err != nil {
		t.Fatal(err)
	}
	var report gate.Report
	decoder := json.NewDecoder(bytes.NewReader(raw))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&report); err != nil {
		t.Fatalf("report.json: %v", err)
	}
	if report.SchemaVersion != 1 || !report.Passed || len(report.Failures) != 0 ||
		report.Library.Name != lib.Name || report.Library.Version != lib.Version || !strings.HasPrefix(report.Scanner, "gitleaks ") {
		t.Fatalf("report header = %+v %v %d", report.Library, report.Passed, len(report.Failures))
	}
	if len(report.Items) != len(lib.Items) {
		t.Fatalf("report has %d items, the library %d", len(report.Items), len(lib.Items))
	}
	for index, item := range report.Items {
		source := lib.Items[index]
		if item.Key != source.Key() || !item.Passed || len(item.Secrets) != 0 || len(item.Tools) != 3 {
			t.Fatalf("item %d = %+v, want a passing %s", index, item, source.Key())
		}
		declared := map[library.Tool]bool{}
		for _, tool := range source.Tools {
			declared[tool] = true
		}
		for _, tool := range item.Tools {
			if tool.Declared != declared[tool.Tool] {
				t.Errorf("%s %s: declared %v", item.Key, tool.Tool, tool.Declared)
			}
			if !tool.Declared {
				continue
			}
			status, files := expected(source, tool.Tool)
			if tool.Status != status || strings.Join(tool.Files, ",") != strings.Join(files, ",") {
				t.Errorf("%s %s: %s %v, want %s %v", item.Key, tool.Tool, tool.Status, tool.Files, status, files)
			}
		}
	}

	markdown, err := os.ReadFile(summary)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.HasPrefix(string(markdown), "Earlier step output.\n## Content library quality gate: PASSED\n") {
		t.Fatalf("the job summary was replaced instead of appended to:\n%s", markdown)
	}
	for _, item := range lib.Items {
		if !strings.Contains(string(markdown), "\n| `"+item.Key()+"` | ") {
			t.Errorf("the summary has no row for %s", item.Key())
		}
		if !strings.Contains(stdout.String(), "\nPASS "+item.Key()+" ") {
			t.Errorf("the log has no PASS line for %s", item.Key())
		}
	}
	if !strings.HasSuffix(stdout.String(), "library-gate: PASSED\n") {
		t.Fatalf("missing the passed verdict:\n%s", stdout.String())
	}
}

// expected is what the desktop client's rules give a library item for a tool it
// lists: the status and the files, by kind.
func expected(item library.Item, tool library.Tool) (gate.Status, []string) {
	switch item.Kind {
	case pack.KindAgent:
		return gate.StatusSkipped, []string{}
	case pack.KindSkill:
		if tool == library.ToolClaudeCode {
			return gate.StatusRendered, []string{".claude/skills/" + item.Name + "/SKILL.md"}
		}
		return gate.StatusRendered, []string{"skills/" + item.Name + "/SKILL.md"}
	case pack.KindConfig:
		return gate.StatusRendered, []string{map[library.Tool]string{
			library.ToolClaudeCode: ".claude/settings.json", library.ToolCodex: "config.toml", library.ToolCursor: "cli-config.json"}[tool]}
	case pack.KindMCPTemplate:
		return gate.StatusRendered, []string{map[library.Tool]string{
			library.ToolClaudeCode: ".mcp.json", library.ToolCodex: "config.toml", library.ToolCursor: "mcp.json"}[tool]}
	case pack.Kind("prompt"):
		switch tool {
		case library.ToolClaudeCode:
			return gate.StatusRendered, []string{".claude/commands/" + item.Name + ".md"}
		case library.ToolCursor:
			return gate.StatusRendered, []string{"commands/" + item.Name + ".md"}
		}
		return gate.StatusSkipped, []string{}
	}
	return gate.Status("unknown kind " + string(item.Kind)), nil
}

// problemLines returns the "FAIL <item> <tool>: <stage>: <reason>" lines, not
// the per-item summary lines.
func problemLines(log string) []string {
	var lines []string
	for _, line := range strings.Split(log, "\n") {
		if strings.HasPrefix(line, "FAIL ") && strings.Contains(line, ": ") {
			lines = append(lines, line)
		}
	}
	return lines
}

func copyLibrary(t *testing.T, from string) string {
	t.Helper()
	to := filepath.Join(t.TempDir(), "content")
	err := filepath.WalkDir(from, func(name string, entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(from, name)
		if err != nil {
			return err
		}
		target := filepath.Join(to, rel)
		if entry.IsDir() {
			return os.MkdirAll(target, 0o755)
		}
		data, err := os.ReadFile(name)
		if err != nil {
			return err
		}
		return os.WriteFile(target, data, 0o644)
	})
	if err != nil {
		t.Fatal(err)
	}
	return to
}

func addItem(t *testing.T, dir, kind, name, tools, body string) {
	t.Helper()
	folder := filepath.Join(dir, "items", kind, name)
	if err := os.MkdirAll(folder, 0o755); err != nil {
		t.Fatal(err)
	}
	files := map[string]string{
		"item.json":  `{"version":"1.0.0","category":"testing","tags":["gate-demo"],"tools":` + tools + `,"description":"Deliberately broken item for the gate demo."}`,
		"body.md":    body + "\n",
		"example.md": "Demo only.\n",
	}
	for file, content := range files {
		if err := os.WriteFile(filepath.Join(folder, file), []byte(content), 0o644); err != nil {
			t.Fatal(err)
		}
	}
}
```

   Also add `gitleaksForTest` (same body as in the gate tests; tests in different packages can't share it) and `TestUsageProblemsExitTwo`: `-nope`, an extra argument, a missing `-dir`, and `-gitleaks <temp>/no-gitleaks` each return 2 with `gate.NewGitleaks`.
   RED: `go test -count=1 ./cmd/library-gate` → `undefined: run`.
2. **GREEN.** `main.go` (code above). Run the AC2 and AC3 commands.
3. Makefile changes (exact text above). Check `make -n library-check` and `make -n library-check LIBRARY_SUMMARY=/tmp/x LIBRARY_REPORT=/tmp/y` print the expected `go run` line, then `make library-check` exits 0.
4. Commit: `feat(86bcm901u): library-gate command and make library-check`.

### T6. CI wiring (15–20 min)

1. **RED.** `cmd/library-gate/ci_test.go` (package `main`, no helpers from other test files, so it runs on its own against the base commit):

```go
package main

import (
	"os"
	"strings"
	"testing"
)

// The steps the "Go quality gates" job had before this story (main 6e74ced).
// Every one must still run, in the same order.
var baseQualitySteps = []string{
	"Check out source", "Scan repository for secrets", "Install Go", "Install Helm",
	"Verify workspace membership", "Verify generated contracts", "Verify module-add behavior",
	"Verify formatting", "Verify story delivery gate", "Vet", "Setup OpenTofu",
	"Test with the race detector", "Install linter", "Lint all workspace modules",
	"Install vulnerability scanner", "Audit dependencies", "Validate Helm chart",
	"Build workspace", "Build production container", "Scan production container",
}

const gateStep = "Check content library quality"

func TestAC4CIRunsLibraryGateWithoutDroppingGates(t *testing.T) {
	workflow := readText(t, "../../.github/workflows/ci.yml")
	start := strings.Index(workflow, "\n  quality:\n")
	end := strings.Index(workflow, "\n  publish:\n")
	if start < 0 || end < start {
		t.Fatal("ci.yml has no quality job before the publish job")
	}
	names, blocks := steps(workflow[start:end])
	position := map[string]int{}
	for index, name := range names {
		position[name] = index
	}
	last := -1
	for _, name := range baseQualitySteps {
		index, ok := position[name]
		if !ok {
			t.Fatalf("CI step %q was removed or renamed", name)
		}
		if index < last {
			t.Fatalf("CI step %q moved", name)
		}
		last = index
	}
	at, ok := position[gateStep]
	if !ok {
		t.Fatalf("CI has no %q step", gateStep)
	}
	if at < position["Scan repository for secrets"] || at < position["Install Go"] {
		t.Fatalf("%q runs before gitleaks is downloaded or Go is installed", gateStep)
	}
	if !strings.Contains(blocks[gateStep], `run: make library-check GITLEAKS="${RUNNER_TEMP}/gitleaks" LIBRARY_SUMMARY="${GITHUB_STEP_SUMMARY}"`) {
		t.Fatalf("%q does not run the gate with CI's gitleaks and job summary:\n%s", gateStep, blocks[gateStep])
	}
	if !strings.Contains(blocks["Scan repository for secrets"], `"${RUNNER_TEMP}/gitleaks" git --redact --no-banner --exit-code 1`) {
		t.Fatal("the repository secret scan command changed")
	}
	if !strings.Contains(blocks["Test with the race detector"], "LEORNA_TEST_GITLEAKS_BIN: ${{ runner.temp }}/gitleaks") {
		t.Fatal("the test step does not give the gate's secret-scan tests CI's gitleaks")
	}

	makefile := readText(t, "../../Makefile")
	if !strings.Contains(makefile, "\ncheck: workspace contracts-check fmt vet test lint audit secrets library-check build\n") {
		t.Fatal("make check does not run every earlier gate plus library-check")
	}
	if !strings.Contains(makefile, "\nlibrary-check:\n\t$(GO) run ./cmd/library-gate ") {
		t.Fatal("the Makefile has no library-check target running cmd/library-gate")
	}
}

func readText(t *testing.T, name string) string {
	t.Helper()
	data, err := os.ReadFile(name)
	if err != nil {
		t.Fatal(err)
	}
	return string(data)
}

// steps splits a job into its "      - name: X" steps.
func steps(job string) ([]string, map[string]string) {
	var names []string
	blocks := map[string]string{}
	current := ""
	for _, line := range strings.Split(job, "\n") {
		if name, ok := strings.CutPrefix(line, "      - name: "); ok {
			current = strings.TrimSpace(name)
			names = append(names, current)
		}
		if current != "" {
			blocks[current] += line + "\n"
		}
	}
	return names, blocks
}
```

   RED: `go test -v -count=1 -run '^TestAC4CIRunsLibraryGateWithoutDroppingGates$' ./cmd/library-gate` → `--- FAIL` with `CI has no "Check content library quality" step`.
2. **GREEN.** Edit `ci.yml` exactly as above. Run the AC4 command, then `git diff --numstat origin/main -- .github/workflows/ci.yml` (deletions 0).
3. Commit: `feat(86bcm901u): run the content library gate in Go quality gates`.

### T7. Only if PR #85 (prompt kind) is on `origin/main` before the finish (10 min)

Replace `kindPrompt` with `pack.KindPrompt` in `render.go` (delete the constant), run `go test ./internal/library/... ./cmd/library-gate`, and make sure AC3 passes with the real `prompt/pr-description` item (Claude Code and Cursor rendered, Codex not declared). Commit `feat(86bcm901u): use pack.KindPrompt now that 86bcm9016 is merged`. If PR #85 is still open at the finish, leave `kindPrompt` and say so in the hand-over.

### T8. Docs and records (15 min)

- `internal/library/README.md`: add a `## Quality gate (CI)` section (about 30 lines): what `make library-check` and the CI step "Check content library quality" do (layout, `library.Parse`, render for the three tools with `internal/library/render`, JSON/TOML parse, gitleaks with default rules, `gitleaks:allow` ignored, source and rendered files); what fails CI (a failure for a listed tool, a schema or layout error, a secret) and what doesn't (agents skipped, warnings, tools not listed); the `FAIL <item> <tool>: <stage>: <reason>` line; exit codes 0/1/2; local use (`make library-check`, `make library-check LIBRARY_DIR=<copy> LIBRARY_REPORT=<file>`); "Keeping the renderers in step with the client" (copy the merged client change and its goldens, update `SOURCE.md`, run `go test ./internal/library/render`); and the test names: `TestAC1ValidatesRendersAndScansEveryItem`, `TestAC2RenderFailureFailsCINamingItemAndTool`, `TestAC3PassingRunWritesPerItemCompatibilityReport`, `TestAC4CIRunsLibraryGateWithoutDroppingGates`, `TestTransformMatchesClientGoldens`, `TestIntegrationTemplatesMatchClientGoldens`, `TestTransformRejectsWhatTheClientRejects`, `TestPromptsMatchClientPR20`. Every sentence must be true as written; claim only what a test or run showed.
- `README.md`: in "Individual checks are available through …", add `` `make library-check` (the content library gate) `` before `` `make build` ``.
- `delivery/stories.json`: add at the end, then check `python3 -m json.tool delivery/stories.json >/dev/null` and `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`:
  ```json
    "86bcm901u": {
      "name": "Content quality gate (CI)",
      "prs": {
        "LeornaAI/leorna-control-plane": []
      }
    }
  ```
  The PR number goes in only after the PR exists (finisher, after Justin says "make a PR"; `leorna` step 7.8). Never a guessed number.
- Commit: `docs(86bcm901u): library gate README and delivery inventory`.

Records outside the repo (who updates them):
- `<evidence>/plan-approved.md`: the main session, at **go** (`install -m 444`).
- `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` status line (go, ready-for-review, hand-over): the main session. Agents report; they never edit memory or skills.
- `~/.hermes/plans/leorna/found-else.md`: the main session appends this story's "Other things found" and every agent's `found_else`.
- The finisher's hand-over: PR text draft in `~/.hermes/cache/scratch/leorna-pr-86bcm901u-quality-gate-v3.md`, the review prompt, the ClickUp evidence draft and the team message, none of them posted or pushed.

### T9. Evidence (named build task; capture as each check runs, retake on the final head if output changes)

One screenshot per AC, all real; never a staged screenshot. Terminal captures use the `leorna` skill's recipe: a dedicated Terminal window opened with `osascript` running `exec env -i HOME=… PATH=… PS1='$ ' bash --norc --noprofile`, wait for the `$ ` prompt in the tab's `history` before typing, run `make -s` so recipes don't echo absolute paths, capture with `screencapture -x -o -l <window id>`. Before anything leaves the Mac, look at every image: no token, URL bar, server domain, tenant ID or email. The fake token never appears in any output by design; check anyway.

| AC | Real state to show | When | Path in `$EVID` |
| --- | --- | --- | --- |
| before | main `6e74ced` accepts a Codex-unrenderable item: library tests PASS with `broken-args` added | T0, in `$S/before` (an archive of main, not the worktree) | `before-main-accepts-broken-item.png`, `before-main-accepts-broken-item.txt` |
| AC1 | AC1 command with real gitleaks: three subtests PASS, no SKIP, exit 0 | after T3, retaken on the final head | `ac1-validate-render-scan.png`, `ac1-<sha7>.txt` |
| AC2 | the built binary on a copy of the real library plus `broken-args` (listing all three tools): `FAIL mcp_template/broken-args@1.0.0 codex: render: …`, `exit=1`; then the AC2 test PASS | after T5 | `ac2-broken-item-fails.png`, `ac2-<sha7>.txt` |
| AC3 | the built binary on the real library: one `PASS` line per item, `library-gate: PASSED`, `exit=0`; and the summary Markdown rendered | after T5 | `ac3-real-library-passes.png`, `ac3-compatibility-report.png` (labelled "Local rendering of the job summary, not GitHub"), `ac3-summary.md`, `ac3-report.json`, `ac3-<sha7>.txt` |
| AC4 | `git diff --numstat origin/main -- .github/workflows/ci.yml Makefile` (ci.yml deletions 0), `git diff origin/main -- .github/workflows/ci.yml` (only `+` lines), and the AC4 test PASS | after T6 | `ac4-ci-step-added.png`, `ac4-<sha7>.txt` |
| AC5 (live) | GitHub Actions: the broken-item run failing at "Check content library quality" with the `FAIL … codex` line; the real-library run passing with the table in the job summary | only after Justin's auth step and his "make a PR" (finisher) | `ac5-hosted-broken-fails.png`, `ac5-hosted-summary.png`; until then NOT VERIFIED |
| gates | every gate on the final head with exit codes | T10 | `gates-<sha7>.txt`, `gates-<sha7>.json` (`{"head", "tools":{…versions}, "gates":[{"name","command","exit_code","log"}]}`) |
| mutations | each mutation, the test that caught it, restore proof | T10 | `mutations-<sha7>.txt` |

Demo commands (the AC2 and AC3 captures):

```bash
go build -o "$S/library-gate" ./cmd/library-gate
rm -rf "$S/demo" && mkdir -p "$S/demo" && cp -R internal/library/content "$S/demo/broken"
mkdir -p "$S/demo/broken/items/mcp_template/broken-args"
printf '%s\n' '{"version":"1.0.0","category":"testing","tags":["gate-demo"],"tools":["claude-code","codex","cursor"],"description":"Deliberately broken item for the gate demo."}' > "$S/demo/broken/items/mcp_template/broken-args/item.json"
printf '%s\n' '{"mcpServers":{"api":{"command":"api-mcp","args":["--token","${API_TOKEN}"]}}}' > "$S/demo/broken/items/mcp_template/broken-args/body.md"
printf 'Demo only.\n' > "$S/demo/broken/items/mcp_template/broken-args/example.md"
"$S/library-gate" -dir "$S/demo/broken" -gitleaks "$(command -v gitleaks)"; echo "exit=$?"
rm -f "$EVID/ac3-summary.md"
"$S/library-gate" -dir internal/library/content -gitleaks "$(command -v gitleaks)" -summary "$EVID/ac3-summary.md" -json "$EVID/ac3-report.json"; echo "exit=$?"
```

AC3 rendering: render `ac3-summary.md` to HTML with goldmark (GFM extension) from a throwaway Go program in `$S` (never in the worktree), add a visible banner "Local rendering of the job summary, not GitHub", then screenshot with headless Chrome and a throwaway `--user-data-dir` in `$S`. Check the keys show as code, not `mailto:` links.

### T10. Gates, mutation checks, ready-for-review (45–60 min)

Gates on the final head, each with its log and exit code in `gates-<sha7>.txt` / `.json` (open each log and read its exit code before citing it; a failed first attempt keeps its own file):

```bash
cd "$W"
GOLANGCI_LINT="$HOME/.hermes/cache/scratch/leorna-bin/golangci-lint" GOVULNCHECK="$HOME/.hermes/cache/scratch/leorna-bin/govulncheck" make check
bash ./scripts/test-module-add.sh
go test -v -count=1 -run 'WithPostgres' ./internal/store/postgres/ ./internal/web/ 2>&1 | grep -E -- '--- (PASS|SKIP|FAIL)' | head -40   # Postgres tests ran: PASS lines, no "not set" skips
LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)" go test -race -count=1 -v ./internal/library/... ./cmd/library-gate 2>&1 | grep -E -- '--- (SKIP|FAIL)' ; echo "skips-or-fails-above=$?"   # expect none (grep exit 1)
gitleaks git --redact --no-banner --exit-code 1 --log-opts="HEAD"      # this branch's whole history, as CI sees it
make library-check
git diff --name-only origin/main...HEAD -- contracts packages/contracts internal/store/postgres/migrations   # must print nothing: no API or migration change
git diff --numstat origin/main...HEAD -- .github/workflows/ci.yml                                          # deletions column 0
git log --format='%an <%ae>' origin/main..HEAD | sort -u                                                   # only Justin Issa <justin@leorna.com>
```

- `make check` includes `secrets`, which runs `gitleaks git` over **every local ref**, including other stories' branches. If it fails only on commits not reachable from HEAD, record which commits (`gitleaks git … --log-opts="HEAD"` clean is the story's proof) and don't touch those branches.
- Run gates from inside the worktree: from the main checkout, `scripts/verify-workspace.sh`'s `find` also sees `go.mod` files under `.claude/worktrees/`.
- ClickHouse tests skip locally (no container); CI runs them. Say so; don't start a container.

Mutations (`mutation-testing-discipline`): make each change in the worktree, run the named test, confirm it fails, restore with `git checkout -- <file>`, and confirm `git status` is clean before the next one. Use never-true comparisons (for example `tool.Status == Status("never")`), not `false`, so the build doesn't break.

| # | Mutation | Must be caught by |
| --- | --- | --- |
| M1 | in `Run`, never record render failures for declared tools | AC2 subtest 1 |
| M2 | in `renderFor`, treat every zero-file render as skipped | AC2 subtest 3, `TestConfigForAnotherToolFailsWhenDeclared` |
| M3 | drop `--ignore-gitleaks-allow` | AC1 secret subtest |
| M4 | in `scanSecrets`, skip rendered files | AC1 subtest 1 (scanned rendered output), AC1 secret subtest |
| M5 | map every finding to the first item | AC1 secret subtest |
| M6 | render only declared tools | AC1 subtest 1 |
| M7 | skip the TOML parse | `TestBrokenCodexConfigFailsTheTOMLCheck` |
| M8 | delete the Codex args-placeholder check in `codexServerTable` | `TestTransformRejectsWhatTheClientRejects`, AC2 subtest 1 |
| M9 | open the summary with `O_TRUNC` instead of `O_APPEND` | AC3 |
| M10 | `run` returns 0 when the report failed | AC2 subtests 1 and 3 |
| M11 | stop removing `GITLEAKS_` variables | `TestGitleaksIgnoresConfigFromTheEnvironment` |
| M12 | remove the top-level layout check | `TestStrayTopLevelFileFails` |
| M13 | drop `checkLayout`'s regular-file check | `TestLinkInLibraryFails` |
| M14 | remove the CI step | AC4 |

Stop at **ready-for-review** with: head SHA, `git diff --stat origin/main...HEAD`, the `.github/` paths changed (only `ci.yml`, additions only), gate results with log paths and exit codes, AC → test → log → screenshot table, mutation results, Postgres-ran proof, the probes' outcomes (gitleaks report shape), the test DB name you kept (`leorna_86bcm901u_v3_test`), and any ruling you made that the plan didn't cover.

Forecast for the builder: about 4.5–7 hours of focused work (medium confidence), most of it the port (T1), the gate (T2–T4) and the evidence captures (T9).

## Overlaps and merge order

- **86bcm9016 prompt kind** (CP PR #85 head `5a3b5c6`, MERGEABLE but BEHIND main; client PR #20 head `1f259b0`, based on client `8d540f1`, before PR #21). Shared files: `internal/library/README.md` (both add a section), `delivery/stories.json` (both add an entry). PR #85 also adds `prompt/pr-description` to the library (Claude Code and Cursor), and its `content.lock.json`/`library.json` changes don't touch this story's files. With Q5-A, **either order is safe**: if #85 merges first, the rebase conflicts are text-only and T7 swaps in `pack.KindPrompt`; if this story merges first, #85's CI passes because prompts already render. Recommended: merge #85 first, since it's already pushed and green. Don't touch its worktree (`…/worktrees/86bcm9016-prompt-kind`) or its databases.
- **86bcm901v catalog browser v2** (worktree `…/worktrees/86bcm901v-catalog-browser-v2` at `57c7fc1`, no commits yet; its v2 plan isn't written). The earlier catalog design touched `internal/library` (new `catalog.go`), `internal/web`, `internal/store/postgres`, `internal/library/README.md`, `delivery/stories.json` and possibly the `Makefile`. Possible overlap: `internal/library/README.md`, `delivery/stories.json`, `Makefile`, all text-only. Either order is safe; the second to merge rebases. If the catalog adds library items, this gate checks them too. Don't touch its worktree or databases.
- **Earlier 901u attempts** (v1 and v2 branches and worktrees, their plans and evidence, any `leorna_86bcm901u*` database except the new `leorna_86bcm901u_v3_test`): left exactly as they are. This plan was written without opening them.

## Choices made

- Q1–Q5 as ⭐ (above).
- **Report destination:** the CI job summary (Markdown) plus log lines; JSON only with `-json` (local use and tests). Not uploaded as an artifact, which would add another third-party action.
- **The gate runs on every CI run**, not only when library files change: it takes seconds, and a path filter would need a new job.
- **Items are rendered one at a time.** Two library items that conflict in one pack (two `codex-` configs, two templates defining the same server) are alternatives in a catalog; refusing such packs belongs to pack building (E11).
- **"Schema"** is `library.Parse` (the strict rules the server loads at startup) plus the top-level layout check; no separate JSON Schema file to keep in step.
- **Secret scanning uses gitleaks' default rules, not the repo's `.gitleaks.toml`**, because that file's allowlist (`SCW_[A-Z_]+=` and others) would hide real secrets in content. It scans exact copies of the accepted files plus every rendered file, with inline `gitleaks:allow` turned off and `GITLEAKS_*` settings removed from the environment.
- **CI reuses the gitleaks binary** the job already downloads and checks (8.30.1), and the gate step runs before Vet so content problems show early.

## Assumptions

- "Rendered for a tool" means the client's rules at `ea2b8ab` give at least one file without an error, and each rendered JSON/TOML file parses.
- The client's transformers are the source of truth. If they change, this copy is updated by copying, not redesigned.
- Library content is written by the team (PRs on a private repo), so the gate fails closed but doesn't sandbox gitleaks.
- The hosted proof (AC5) waits for Justin's `workflow`-scope auth step and his "make a PR". The demo branch for the broken item never holds a secret: CI's `gitleaks git` scans every ref, so a planted secret would fail every PR.

## Risks

1. **The copy drifts from the client.** Mitigated by byte-for-byte goldens pinned to a commit, `SOURCE.md` hashes, and README refresh steps. A follow-up could automate the cross-check once a read token exists (Q3-B).
2. **TOML version.** BurntSushi/toml v1.6.0 accepts TOML 1.1 syntax. If Codex's parser is TOML 1.0, a 1.1-only file could pass the gate and still fail in Codex. Follow-up: an env-gated test that loads the rendered `config.toml` in real Codex (the client already has `TestCodexParsesGoldenConfig`).
3. **gitleaks behaviour** (report path form, empty-report file, flags). T3 probes it; the gate fails closed (exit 2) on anything unexpected.
4. **Publication needs the `workflow` token scope**; until Justin's auth step, the branch can't be pushed over HTTPS.
5. **Content changes can turn the gate red** (that's the point). AC3 reads expectations by kind, so renaming an item doesn't break the test.
6. **CI time** grows by roughly 20–40 seconds (compiling the gate).
7. **The toml upgrade reaches another dependency:** `github.com/oapi-codegen/runtime` v1.6.0 requires toml v1.3.2, so requiring v1.6.0 raises the version it gets too (same major version, so it should be compatible). `make test`, `make contracts-check` and `make audit` cover it.

## Plan checks done (no planned work was run)

- Every Go block in this plan parses with `gofmt -e`, and the full blocks are gofmt-clean.
- In a scratch clone of `main` (not the real repo), `gate.go`, `scan.go`, `report.go`, `main.go` and the AC1–AC4 test code type-check with `go vet` against the real `library` and `pack` packages, with a throwaway stub standing in for the copied renderer bodies.
- `ac-check.sh`'s own regexes read this plan's ACs as AC1–AC5, with AC5 the only `(live)` one, and find all four AC test names.

## Skills

⟳ = ends with "Mandatory Validation and Agent Defect Loop" (checked with `grep -l '^## Mandatory Validation and Agent Defect Loop'`): the hand-over waits for a clean independent verifier.

- **Builder:** `leorna` (BUILDER, with the Step 1 load), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the declared-tool and secret-scan guards), `security-best-practices` (Go reference: `exec` without a shell, temp files, nothing secret in logs), `api-contract-drift-guard` ⟳ (confirm an empty contract diff), `backend-data-migrations` ⟳ (confirm no migration).
- **Reviewers 1 and 2 (report only):** `leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `api-contract-drift-guard` ⟳, `backend-data-migrations` ⟳.
- **Fixers:** `leorna`, `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, plus `mutation-testing-discipline` when a guard changes.
- **Verifier (read-only):** `leorna` (VERIFIER), `engineering-best-practices`, `security-best-practices`, `api-contract-drift-guard` ⟳ and `backend-data-migrations` ⟳ (run their validation: `make contracts-check`, the empty `contracts/` and migrations diff, `TestMigrationRoundTrip` unchanged).
- **AC auditor:** `leorna`, `engineering-best-practices`.
- **Finisher:** `leorna` (FINISHER), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`, `github` (PR checks, only after "make a PR").

## Final acceptance checklist (stages are separate)

1. Plan approved (**go**) → builder ready-for-review with gates, evidence and mutations.
2. Review 1 → fix → review 2 → fix → verifier → blind AC auditor → `ac-check.sh`: expected result `READY FOR THE USER` (AC1–AC4 proven; AC5 live, owed to Justin).
3. Hand-over: PR text, review prompt, ClickUp evidence draft, team message. Nothing pushed or posted.
4. Justin: auth step (`workflow` scope), "make a PR" → hosted CI → AC5 proof (both runs) → he merges → `check-story-shippable.py 86bcm901u` → "post" for the ClickUp evidence.

## Other things found

Not fixed here and not part of this story.

1. **Medium (content and product):** both agent items list all three tools (`internal/library/content/items/agent/*/item.json`), but every client transformer skips agents (`toolconnector/transform.go` `AgentWarnings` at `ea2b8ab`). The gate shows them as "skipped". This is already on record in `found-else.md` from the 9016 planner.
2. **Low–medium (content):** `mcp_template/github-mcp` sets `GITHUB_PERSONAL_ACCESS_TOKEN` to `${GITHUB_TOKEN}`. The client's Codex renderer forwards variables by the env key's name (`codex/config.go` `serverTable`, `case whole: forwarded = append(forwarded, key)`), so Codex users must set a different variable than Claude Code and Cursor users. The integration tiles already reject that pattern (`internal/integration/tile.go`, "must be exactly ${KEY}"). Fixing it needs a version bump and an owner decision. Codex runtime behaviour is not verified. Already on record in `found-else.md`.
3. **Low:** client PR #20 is based on client `8d540f1`, before PR #21 added remote MCP servers for Codex, so its `codex/config.go` diff against `main` removes `remoteTable`. Its rebase needs care (`gh pr view 20` showed mergeable UNKNOWN). CP PR #85 is MERGEABLE but BEHIND.
4. **Low:** CP PR #85 adds `86bcm9016` to `delivery/stories.json` with empty PR lists although PRs #85 and #20 exist (`leorna` step 7.8 says add the numbers once the PR exists).
5. **Low:** `library.Parse` never looks at top-level entries other than `library.json` and `items/`, while `//go:embed all:content` ships whatever is there (`internal/library/source.go:35-36`, `Parse`). The gate's layout check covers this for CI.
6. **Info:** the `gh` token's scopes are `gist`, `read:org`, `repo` (no `workflow`), so pushing this story's `ci.yml` change will be refused until Justin's own auth step.
7. **Info:** local tools differ from CI (Homebrew golangci-lint 2.13.2 vs 2.14.0; govulncheck v1.8.0 vs v1.7.0; Go 1.27.1 on PATH vs 1.27.3). The gates in T0/T10 bind CI's versions.

## Skill lessons

- `feature-dispatch` (`references/ac-verification.md`) or `implementation-planning`: when an AC's test lives in a **new** Go package, write it as an internal test package (`package gate`, not `package gate_test`). The base-commit run copies only test files, so an internal test fails to build with `undefined:`, which `ac-check.sh` counts as failing on base. An external `_test` package would fail with Go's "no non-test Go files" message, which neither its `build_re` nor its `never_re` matches. Evidence: `ac-check.sh` `build_re`/`never_re` lines. Inferred from the script, not run in this session.
- `github`: the control-plane `main` is guarded by repository **rulesets**, not classic branch protection. `gh api repos/LeornaAI/leorna-control-plane/branches/main/protection` returns 404 "Branch not protected", while `gh api repos/LeornaAI/leorna-control-plane/rulesets/<id> --jq '.rules[]|select(.type=="required_status_checks")|.parameters.required_status_checks[].context'` shows "Go quality gates" (rulesets "Basic Policy v1" and "Protect main"). Evidence: both commands run 2026-10-24.
