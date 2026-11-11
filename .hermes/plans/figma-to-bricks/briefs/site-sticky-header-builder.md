# Role: builder (Mini): site-sticky-header — a header the site keeps at the top stays at the top in the paste

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline` (for the rule's guards), the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`,
`references/planning-checks.md`, `references/live-site-reading.md`, `reference/bricks/README.md`). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load bdryswi.com,
B-Dry staging or any live site; no logins; never write to any WordPress site; touch nothing under `~/Downloads`.

## The plan (approved under Justin's standing auto-go and his "go with recommended for all": Q1–Q5 ⭐ A)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/plan-approved.md` (read-only; AC1–AC9, AC9 live).
Copy it to `docs/plans/2026-11-11-site-sticky-header.md` in your branch. The planner's prototype, patch, tests and logs:
`~/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/planner/proto/` (with `SHA256SUMS`) — a head start, not
proof: build every AC test first (RED on the base, then GREEN), each named exactly as the plan names it, one picture or
terminal capture per AC in `~/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/builder/` (AC1–AC3: the bar's top
before and after the scroll, desktop and phone).

Mini pipeline: if the fix needs more than ~3 source files beyond the plan's, a design decision, or touches auth/data/API,
stop with `status: stopped`, `stop_reason: escalate to full`.

## Where
Your own worktree (starts at `origin/main` = `0248176342c6…`, Build 2026-11-11.3): branch `site-sticky-header-build`.
**Shared file:** `src/core/site/parts.ts` with site-scroll-lock (planning now: a sideways-scroll lock on every importer
paste, `overflow-x: clip`) — the plan says how the second to merge keeps both; keep your edits there small and
self-contained. Also running: media-clickable (`background.ts`, `convert.ts`, `render.ts`), site-menu-motion
(`open-paste.ts`, `slide.ts`, capture readers), site-native-structure (`elementor-*`), footer-icon-list (merging as 11.4).

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) and `npm run corpus` before
Task 1 and at the close; the whole unit suite (the saved `code-page` sums in `site-slider-unchanged` move only as the plan
says: prove per variant that the paste minus the class and note hashes to the old sum before remaking them); the full
`test:web` and `test:browser` file by file at the close under 4G scopes (B-Dry files 8G), compared with main by name
(known failing on main here: composition-clipping, fonts, hero-pair, peer-sides, pill-holder; `site-upload-cli` AC11 is a
load flake: rerun alone). Remake `test/fixtures/site-no-revert-main.json` if the paste changes, as CLAUDE.md says. Ledger
in `.superpowers/sdd/2026-11-11-site-sticky-header/progress.md`; HANDOFF section (newest first, `Build <set at merge>`,
paste check "next free after 3ea"). Commit after each passing task (plain `git commit -m`, no author override, no AI
lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder; never bare `git stash`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ssb/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start: `pgrep -f
'[u]ser-data-dir=<your profile path>'`; never `pkill -f`. Piped/chained git commands may be refused: script files run
with `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under 115 s; long drivers with `setsid --fork`,
waiting on `^EXIT=`. The PC is loaded (8 agents, earlyoom has been killing Chrome renderers): run one Chrome suite at a
time, every Chrome run under a 4G scope; SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since
"-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first and rerun alone under a cap.

## Report (as text), stop at `ready-for-review`
Branch, head and base; per AC: test, RED evidence, GREEN, picture; gates against main by name; the shared `parts.ts`
lines; `found_else`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
