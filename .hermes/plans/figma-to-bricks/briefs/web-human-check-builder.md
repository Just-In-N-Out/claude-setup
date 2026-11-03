# Role: builder (Mini): web-human-check (website importer: Justin passes a site's "I am human" check himself)

You are a fresh builder for FigmaToBricksV2. Build the approved plan test-first and stop at `ready-for-review`. Never
touch the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, never push or
merge, don't bump `BUILD`, leave every other worktree alone, start no agents.

## The plan (approved under the standing auto-go, ⭐ answers taken)

- Approved copy (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check/plan-approved.md`.
- In git: branch `web-human-check` at `07ab8099` (`docs/plans/2026-11-03-web-human-check.md`, on main `70be9c09`). That
  branch is checked out in the planner's worktree, so in your own worktree: `git switch -c web-human-check-build
  07ab8099` and build there. Report this branch and its last commit.
- ACs AC1–AC8 (AC8 `(live)`, Justin's). Use each AC's exact test name from the plan (one plan line each).
- **Mini, sized at its upper edge:** the planner counted about 6 modules (`chrome.ts`, `session.ts`, `discover.ts`,
  `capture.ts`, new `human.ts`, `human-run.ts`, `browser-fetch.ts`, both tools), all in the capture's browser, nothing in
  the converter. Justin chose Mini: don't stop for file count alone. Stop with `status: stopped`, `stop_reason: escalate
  to full` only if it needs converter changes (`src/core`, `src/plugin`, `src/shared`, `src/ui`), a new design decision,
  or anything that would hide automation.

**Hard rule (Justin's and the permission system's):** nothing hides that the browser is automated. No
`--disable-blink-features=AutomationControlled`, no patched `navigator.webdriver`, no new user agent, no stealth script,
no code that clicks, types into or solves a check in the product. A test's click stands in for Justin only inside tests,
on the local stand-in site. Never load bdryswi.com; its real pass is AC8, Justin's.

## Work

Load `engineering-best-practices`, `test-driven-development` and `security-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`.
1. Ledger `.superpowers/sdd/2026-11-03-web-human-check/progress.md`. `npm run corpus` before Task 1 and at the close (on
   this desktop the Mac corpus paths don't resolve: see memory `corpus-paths-on-desktop` notes in testing-pitfalls; use the
   local copies and compare with main).
2. Each task test-first: the failing test's RED run first (saved), then GREEN; commit after each passing task (plain
   `git commit -m`, no author override, no AI or Co-Authored-By lines, no CLAUDE.md staged).
3. Tests use the plan's injected launcher (no real window); the one opt-in real-window test (`F2B_VISIBLE_CHROME=1`) runs
   once on this PC at the close, against the local stand-in only, and its window closes.
4. Records (one task): `docs/specs/web-capture.md`'s address section and a HANDOFF section (newest first) for
   web-human-check, its paste check "id given at the merge" naming AC8's steps for Justin.
5. Evidence in `E/builder/` (E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-human-check`): per AC its test
   log (`HEAD=` first, `EXIT=` last, skipped 0) and a terminal capture image; the RED logs; gates: both typechecks,
   `npm run check`, the whole `test:web` file by file against main `70be9c09` (0 changed by test name), the five Figma
   replays byte-identical, `git diff --stat 70be9c09 -- src/core src/plugin src/shared src/ui` empty.
6. Stop at `ready-for-review` with the branch clean.

## Machine

- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; Chrome: the helper finds
  `~/.cache/chrome-for-testing/chrome-f2b` by itself (or `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`); `TMPDIR` at most 38 characters
  (`~/.cache/whc-b/tmp`). One Chrome job of your own at a time, closed after each step. The worktree's `node_modules` may
  lack `.bin` (`npm run typecheck` exits 127): see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; no redirects or the
  bare word `source` in a command.
- Live reads (GET only) only of `https://darksalmon-badger-335429.hostingersite.com/` (`?f2b=<random>`) and
  `https://www.letsgro.ai/`; never write to any WordPress site; never call alttext.ai. Put any summary in your report.

## Report

`status` (`ready-for-review` | `stopped`), branch and last commit (full SHA), per AC its test, RED/GREEN and evidence
paths, gates, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or
a one-line check proposal; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
