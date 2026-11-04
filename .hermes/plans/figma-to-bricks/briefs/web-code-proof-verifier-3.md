# Role: verifier (after fix 1, read only): web-code-proof (the site's own HTML + CSS → Bricks, one-section proof)

You are a fresh reviewer who never saw the build (Opus 5.5, high effort at Justin's word). Review only: change no source
or test, commit nothing, start no agents. Never touch the main folder `/home/justin/Documents/FigmaToBricksV2` or other
worktrees. Never load bdryswi.com; never write to any WordPress site.

**Importer rule (Justin, 2026-11-02):** one review per job; P0–P2 only for bugs real use hits (a capture through the panel
or `npm run capture`, Justin's paste of the section into Bricks, any Figma design converting), each with a concrete
scenario. Edge cases are P3 follow-ups. A P0–P2 with no concrete real-use scenario is a P3.

## Inputs

- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/plan-approved.md`
  (T0–T14, AC1–AC10; AC9 `(live)`, Justin's: `not_run`).
- Head `79b0e45bfa3d81e162829642e3535d9f62b10739` (branch `web-code-proof-fix-1`), base
  `10a5dc2c` (main, Build 2026-11-04.5). In your own worktree: `git checkout --detach 79b0e45bfa3d81e162829642e3535d9f62b10739`,
  confirm `git rev-parse HEAD` and a clean `git status --porcelain --untracked-files=all`. Review `git diff 10a5dc2c...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/builder/`,
  its rulings R1–R5 in HANDOFF.

## Context

This head is the accepted `3316940a` (verifier-2 and the blind auditor clean, READY FOR THE USER 9/10) moved by a
pure rebase onto main `10a5dc2c` (receipts `evidence/web-code-proof/fixer-1/rebase/`: 17/18 patch-ids equal, the 18th
context-only in HANDOFF; feature paths identical). Re-prove every AC on this head.


Review 1 (`evidence/web-code-proof/review-1/review.json`) found two P2s, both fixed by fixer 1 (receipts
`evidence/web-code-proof/fixer-1/`): R1-1 the panel/helper capture no longer runs the code reader (`tools/capture-serve.ts`
passes `code: false`; `npm run capture` still records `web.code`); R1-2 `tools/site.ts` writes ASCII-only paste files.
Under the importer's one-review rule no second review runs for these small fixes: you verify them (each P2 really fixed,
with its test able to fail) as part of the AC work, and report any new real-use bug you meet as a finding.

## Verify every AC (the verifier's work)

Each AC's named test on head and on base (a base tree from `git archive -o <scratch>/base.tar 10a5dc2c`, `tar -xf`, with
head's test files and test-only modules copied in; a hybrid tree if base only fails at import), a picture per AC (AC5/AC6
real render shots), `HEAD=` first and `EXIT=` last, skipped 0. Gates by test name against base: both typechecks, `npm
run check`, the five Figma replays byte-identical, renderer tests, the capture web files (`capture-*.test.ts`,
`helper-capture`, `human-*`). Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/verifier-3/ac.json`
(AC9 `not_run`, owed), then self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`
(no `--reviews`) on a copy.

## Skills and machine

Load `engineering-best-practices`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md`, `reference/bricks/README.md`, and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` and `ac-verification.md`.
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-v3/tmp`);
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
