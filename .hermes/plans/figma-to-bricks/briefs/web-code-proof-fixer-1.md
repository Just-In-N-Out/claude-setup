# Role: fixer (round 1): web-code-proof

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, high effort at Justin's word). Fix review 1's two P2 findings
test-first and stop at `ready-for-verify`. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read
it only), never bare `git stash`, never push or merge, don't bump `BUILD`, start no agents. Never load bdryswi.com.

## Inputs

- Review: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/review-1/review.json` (R1-1, R1-2 are P2;
  R1-3…R1-9 are P3 follow-ups, don't fix them unless a P2 fix touches the same line naturally).
- Plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/plan-approved.md`.
- Branch `web-code-proof-build` at `b4834946dfe094fb58f89d9fd20af5185c1099f3` (base main `31321bb4`), checked out in the
  builder's worktree, so in yours: `git switch -c web-code-proof-fix-1 b4834946dfe094fb58f89d9fd20af5185c1099f3`.

## Fix

- **R1-1:** the code reader must not slow ordinary captures. The panel/helper captures (`tools/capture-serve.ts` →
  `helperCaptures` → `job.ts`) pass `code: false` (nothing there reads `web.code` yet); `npm run capture` keeps or gains a
  way to ask for it so AC9 step 1 (HANDOFF 3dc) works; say in HANDOFF which command records the code. A test pins that the
  helper's capture doesn't run the code reader and that the CLI route still records `web.code`.
- **R1-2:** `tools/site.ts` writes `bricks.json` (and any other file Justin copies) ASCII-only: every character above
  U+007F as `\uXXXX`, the same JSON value. A test with non-ASCII words asserts no byte above 0x7F and that the parsed value
  is unchanged; HANDOFF 3dc step 4 stays `clip.exe` (now safe) or uses PowerShell `Set-Clipboard`, whichever the test proves.

Load `receiving-code-review` (verify each finding first), `test-driven-development` and `engineering-best-practices`; read
the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md`. RED saved before each fix, then GREEN; commit each fix (plain `git commit -m`, no
author override, no AI or Co-Authored-By lines, no CLAUDE.md staged). Re-run the affected AC tests (AC1, AC7, AC8),
both typechecks and `npm run check`; the capture web files touched by the helper change (`helper-capture`,
`capture-cli`, `human-*`) by name against `b4834946`. Note the two fixes and their receipts in HANDOFF's web-code-proof
section and the ledger. Evidence in `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/fixer-1/`.

## Machine

WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-f/tmp`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job at a time. SIGTERM / 143 / 137 /
"Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Write scripts with Write and run `bash <file>` /
`python3 -I <script>`; git commands as separate plain calls; no redirects, heredocs or the bare word `source`.

## Report

`status`, branch and last commit (full SHA), per finding: verified? RED/GREEN receipts; gates; then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
