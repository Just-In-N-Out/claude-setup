# Role: finisher (step 1, merge prep): site-native-structure — test-only re-pins, HANDOFF notes, receipt

You are a fresh finisher (**Opus 5.5, high**). Load `git-commit-rules`, `engineering-best-practices`, `test-driven-development`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (rebase receipt) and the repo `CLAUDE.md` "Finish"
step 1; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`.
Read both `repeat-mistakes.md` files first. Never load bdryswi.com, B-Dry staging or any live site; never write to any WordPress site; touch
nothing under `~/Downloads`. Commit to your branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare
`git stash`. Plain `git` in your own worktree, each command alone (never `git -C` the main folder). **No ledger move** (the after-merge
finisher does it). Change no file under `src/` or `tools/`.

## State
site-native-structure is accepted: `ac-check.sh` READY FOR THE USER (14 of 15, AC15 live) on head `d6f169848744d4f23f8dd2a8b2b6787dae1872f7`
(branch `site-native-structure-final2`), which sits directly on local main `4f8b61165d98002e64f97aa2e4330f6cf9801c1d` (Build 2026-11-11.10).
Read `git rev-parse main` at your start; if main moved past 4f8b6116, stop and report (don't rebase).

## Do
1. Your own worktree: `git checkout -B site-native-structure-merge d6f169848744d4f23f8dd2a8b2b6787dae1872f7`.
2. **Test-only re-pins (Justin's notes-only rule).** Two named-only tests of merged jobs fail on this head only because they compare the
   set of files under `src/` and see this job's new files (`src/core/site/elementor-button.ts` and the others the diff adds):
   `media-avif-untouched` and `site-import-figma-unchanged`. Find each by name (`grep -rn` in `test/`), run it with its variables on head
   (RED, log), change only what it compares so this job's added `src/` files are allowed and every other guard stays (the build it guards is
   byte-identical: prove `dist/` equal to main's), GREEN, and a one-line mutant (a stray added `src/` file) that still fails it. One commit:
   "site-native-structure merge prep: re-pin <names> for this job's new src files (test-only)".
3. **HANDOFF only** (`docs/HANDOFF.md`, this job's section), one commit:
   - R8-1: its paste-check step 1 offers the old f2b-test capture (it reads no opens). Add the pop-up step from the approved plan
     (`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`, its paste check / AC15) and "a capture made
     with Build 2026-11-11.2 or later".
   - Deferred (one line each, if missing): R8-2 (`test/web/site-elementor-button.test.ts:136` waits a fixed 700 ms before the at-rest picture;
     flakes under load: wait until `document.getAnimations()` is empty on both pages); the auditor's holder-bottom-margin refusal under
     Elementor's `height:100%` holder (named, 1:1, not on B-Dry); a ☰ icon widget pasted as page code noted "opens nothing" (base the same).
   - `cmp` `docs/plans/<this job's plan>.md` with the approved plan above; copy it over if they differ (same commit).
4. **Receipt** `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/rebase/receipt-<head7>.log` (`HEAD=` first, each AC's
   `ok` line, `EXIT=` last, skipped 0): every agent-run AC test AC1–AC14 by its plan name with the plan's variables (AC13 `F2B_PIN_BASE=1`;
   AC14 `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`, `F2B_ELEMENTOR_STANDIN` = `evidence/site-native-structure/inputs/standin-capture-b2435de.json`
   — read the plan for the rest), plus both re-pinned tests. Then `npm run check` (8G scope), and `site-native-stay` (unit and web),
   `site-elementor-button`, `site-check-lifted` in Chrome (4G, one suite at a time).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/snm/t1`); scripts under `~/.cache/snm/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`** (without it browser tests skip and exit 0); close every Chrome you start;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`.
Write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/
"Killed" may be earlyoom: check first.

## Report (as text)
New head (full SHA), its main; each commit with its files; the re-pins' RED/GREEN/mutant; receipt path and last line; gates;
`skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
