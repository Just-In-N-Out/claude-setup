# Role: builder (Mini): site-menu-motion — a menu's sub-list slides open and closed as on the site

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`,
`references/live-site-reading.md`, `reference/bricks/README.md`; the Code element only from
`reference/bricks/code-element.json`). Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load bdryswi.com,
B-Dry staging or any live site; no logins; never write to any WordPress site; touch nothing under `~/Downloads`. The
importer never hides that its Chrome is automated; every Chrome a capture starts launches through `launchCaptureChrome`
and presses stay under the press guard (CLAUDE.md).

## The plan (approved under Justin's standing auto-go, ⭐ answers taken: Q1 A script in one Code element, Q2 A re-scan,
Q3 A lists inside opened boxes only, Q4 A same timing closing)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/plan-approved.md` (read-only; AC1–AC7, AC7 live).
Copy it to `docs/plans/2026-11-11-site-menu-motion.md` in your branch. Build every AC test first (RED, then GREEN), each
test named exactly as the plan names it, one picture or terminal capture per AC in
`~/.hermes/plans/figma-to-bricks/evidence/site-menu-motion/builder/` (AC3: frames of site | paste at half-way, 1440 and
390). Planner evidence (probe, Elementor's handler): `…/site-menu-motion/planner/`.

Mini pipeline: if the scan side needs the press guard outside `readOpens`, more than ~6 source files, or a design
decision, stop with `status: stopped`, `stop_reason: escalate to full`.

## Where
Your own worktree (starts at `origin/main` = `0248176342c6…`, Build 2026-11-11.3): branch `site-menu-motion-build`.
Running at the same time: footer-icon-list (capture readers; merging as 11.4), site-native-structure
(`src/core/site/elementor-*`), media-clickable (`src/core/site/background.ts`, `convert.ts`, `test/browser/render.ts`),
site-sticky-header (`src/core/site/stay.ts`, `parts.ts`), site-scroll-lock (page-wide CSS). Stay in the plan's files; name
any shared file you touch.

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) and `npm run corpus` before
Task 1 and at the close; the whole unit suite (`site-slider-unchanged`'s saved sums move only as the plan says — prove
per variant the paste minus the new thing hashes to the old sum before remaking them); the full `test:web` and
`test:browser` file by file at the close under 4G scopes (B-Dry files 8G), compared with main by name (known failing on
main here: composition-clipping, fonts, hero-pair, peer-sides, pill-holder). If the job changes what a site paste
writes, remake `test/fixtures/site-no-revert-main.json` as CLAUDE.md says. Ledger in
`.superpowers/sdd/2026-11-11-site-menu-motion/progress.md`; HANDOFF section (newest first, `Build <set at merge>`, paste
check "next free after 3dz"). Commit after each passing task (plain `git commit -m`, no author override, no AI lines,
never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder; never bare `git stash`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/smb/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start: `pgrep -f
'[u]ser-data-dir=<your profile path>'` (the bracket stops it matching your own shell); never `pkill -f`. Piped/chained
git commands may be refused: script files run with `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under
115 s; long drivers with `setsid --fork`, waiting on `^EXIT=`. Load on the PC is high (load ~110): a timing flake reruns
alone before judging. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o
short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text), stop at `ready-for-review`
Branch, head and base; per AC: test, RED evidence, GREEN, picture; gates against main by name; `found_else`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
