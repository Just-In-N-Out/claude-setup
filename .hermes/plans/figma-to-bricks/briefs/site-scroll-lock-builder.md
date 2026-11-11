# Role: builder (Mini): site-scroll-lock — every website-importer paste locks sideways scrolling

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`,
`references/planning-checks.md`, `references/live-site-reading.md`, `reference/bricks/README.md`). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load bdryswi.com,
B-Dry staging or any live site; no logins; never write to any WordPress site; touch nothing under `~/Downloads`.

## The plan (approved under Justin's standing auto-go and "go with recommended for all": Q1–Q3 ⭐ A)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/plan-approved.md` (read-only; AC1–AC7, AC7 live).
Copy it to `docs/plans/2026-11-11-site-scroll-lock.md` in your branch. The planner's proofs, four test files, source and
pin patches: `~/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/planner/` (`02-source.patch`, `03-pins.patch`,
`pins.md`, `tests/`, `forms.txt`, `noscroll.txt`) — a head start, not proof: build every AC test first (RED on the base,
then GREEN), each named exactly as the plan names it, one picture or terminal capture per AC in
`~/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/builder/` (AC2–AC4 at 390: before and after).

Mini pipeline: if the fix needs more than ~3 source files beyond the plan's, a design decision, or touches auth/data/API,
stop with `status: stopped`, `stop_reason: escalate to full`.

## Where
Your own worktree (starts at `origin/main` = `0248176342c6…`, Build 2026-11-11.3): branch `site-scroll-lock-build`.
**Shared file:** `src/core/site/parts.ts` with site-sticky-header (branch `site-sticky-header-build`, being built: a class
`<page>__site-stay-<4>` on the header root, new `src/core/site/stay.ts`, plus its own `html:root, html:root > body {
overflow-x: clip }` guard) — read its branch (`git -C /home/justin/Documents/FigmaToBricksV2 show
site-sticky-header-build:src/core/site/parts.ts`) and keep your edits self-contained so the second to merge keeps both;
AC3/AC4 must still hold with its guard present. Also running: media-clickable (`background.ts`, `convert.ts`,
`render.ts`), site-menu-motion (`open-paste.ts`, `slide.ts`), site-native-structure (`elementor-*`; merges after
footer-icon-list, 11.4). Name any shared file you touch.

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) and `npm run corpus` before
Task 1 and at the close; the whole unit suite (14 pin tests move as `03-pins.patch` says, by design only; the saved
`code-page` sums in `site-slider-unchanged`: prove per variant the paste minus the lock class hashes to the old sum
before remaking them); remake `test/fixtures/site-no-revert-main.json` with `node tools/site-no-revert-golden.ts .`; the
full `test:web` and `test:browser` file by file at the close under 4G scopes (B-Dry files 8G), compared with main by name
(known failing on main here: composition-clipping, fonts, hero-pair, peer-sides, pill-holder). CLAUDE.md's list of
unprefixed class names gains `site-scroll-lock-<4>` (Q3 A): put that line in HANDOFF for the merge finisher, don't edit
CLAUDE.md. Ledger in `.superpowers/sdd/2026-11-11-site-scroll-lock/progress.md`; HANDOFF section (newest first, `Build
<set at merge>`, paste check "id at merge"). Commit after each passing task (plain `git commit -m`, no author override,
no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder; never bare `git stash`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/slb/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start: `pgrep -f
'[u]ser-data-dir=<your profile path>'`; never `pkill -f`. Over CDP a `mouseWheel` on a locked page is never answered: race
it with a timer; in phone mode read `visualViewport.pageLeft` as well as `scrollX`. Piped/chained git commands may be
refused: script files run with `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s; long drivers
with `setsid --fork`, waiting on `^EXIT=`. 8 agents on the PC: one Chrome suite at a time, under a 4G scope;
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E
'sending SIG[A-Z]* to process'` first and rerun alone under a cap.

## Report (as text), stop at `ready-for-review`
Branch, head and base; per AC: test, RED evidence, GREEN, picture; gates against main by name; the shared `parts.ts`
lines and how they meet site-sticky-header's; `found_else`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
