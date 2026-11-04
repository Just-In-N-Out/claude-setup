# Role: reviewer + verifier (round 1, report only): web-code-proof (the site's own HTML + CSS → Bricks, one-section proof)

You are a fresh reviewer who never saw the build (Opus 5.5, high effort at Justin's word). Review only: change no source
or test, commit nothing, start no agents. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees. Never load bdryswi.com; never write to any WordPress site.

**Importer rule (Justin, 2026-11-02):** one review per job; P0–P2 only for bugs real use hits (a capture through the panel
or `npm run capture`, Justin's paste of the section into Bricks, any Figma design converting), each with a concrete
scenario. Edge cases are P3 follow-ups. A P0–P2 with no concrete real-use scenario is a P3.

## Inputs

- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/plan-approved.md`
  (T0–T14, AC1–AC10; AC9 `(live)`, Justin's: `not_run`).
- Head `b4834946dfe094fb58f89d9fd20af5185c1099f3` (branch `web-code-proof-build`), base
  `31321bb4` (main, Build 2026-11-04.3). In your own worktree: `git checkout --detach b4834946dfe094fb58f89d9fd20af5185c1099f3`,
  confirm `git rev-parse HEAD` and a clean `git status --porcelain --untracked-files=all`. Review `git diff 31321bb4...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/builder/`,
  its rulings R1–R5 in HANDOFF.

## Look hardest at

1. **The capture's new cost:** the builder reports the code reader adds about 90 s per width range and is on by default
   (`CaptureOptions.code`), so every panel/helper capture gets ~20 minutes slower on bdryswi.com although nothing in the
   panel uses `web.code` yet. Is that a real-use regression (P2), and what's the smallest fix (default off for the panel
   and helper with the proof's commands asking for it, or parallel DevTools calls)?
2. **1:1 claims:** do AC5/AC6 really prove 1:1 (0 px at every width), or can they pass vacuously (pictures, fonts,
   synthetic bold, the stand-in's lazy-background fix)? Spot-check the side-by-side pictures yourself.
3. **Will the paste work in real Bricks 2.3.9:** `payloadProblems`, class/id shapes against `reference/bricks/` samples,
   the reset class's print order, values in controls, custom tags, custom CSS selectors (`%root%`?), the Bricks caps
   (max-width 100%, wrap at 767), Theme Style leaks. Unverified-in-Bricks items are fine as long as AC9 names them.
4. **Figma designs untouched** (AC10) and the architecture rules: typed values until emit, deterministic ids, no `figma.*`
   or web classes in sandbox code.

Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/review-1/review.json`.

## Verify every AC (the verifier's work)

Each AC's named test on head and on base (a base tree from `git archive -o <scratch>/base.tar 31321bb4`, `tar -xf`, with
head's test files and test-only modules copied in; a hybrid tree if base only fails at import), a picture per AC (AC5/AC6
real render shots), `HEAD=` first and `EXIT=` last, skipped 0. Gates by test name against base: both typechecks, `npm
run check`, the five Figma replays byte-identical, renderer tests, the capture web files (`capture-*.test.ts`,
`helper-capture`, `human-*`). Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/verifier/ac.json`
(AC9 `not_run`, owed), then self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`
(no `--reviews`) on a copy.

## Skills and machine

Load `requesting-code-review`, `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md`, `reference/bricks/README.md`, and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and `ac-verification.md`.
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-r/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time, closed after each step. The
  worktree's `node_modules` may lack `.bin`; base trees under `~/.cache` need the main folder's `node_modules/.bin` on
  PATH (testing-pitfalls).
- Runaway memory: SIGTERM, 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write scripts with Write and run `bash <file>` / `python3 -I <script>`; git commands as separate plain calls; no
  redirects, heredocs or the bare word `source`. Live reads (GET only) only of the Hostinger site (`?f2b=`) and letsgro.ai.

## Report

`{verdict: clean|findings, head, base, findings[{id,severity,claim,scenario,evidence}], ac_status[{ac,accepted,test,
screenshot,evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Empty skill_lessons is
normal; never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
