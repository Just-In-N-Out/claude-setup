# Role: builder (Mini): media-clickable — a box's own library background becomes Bricks' Background image setting

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`,
`references/live-site-reading.md` "Code-route paste traps", `reference/bricks/README.md`). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load bdryswi.com,
B-Dry staging or any live site; no logins; never write to any WordPress site; never run `site:upload`/`site:import`
against anything but the tests' 127.0.0.1 stand-in; touch nothing under `~/Downloads` (the planner copied Justin's run to
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`).

## The plan (approved under Justin's standing auto-go, ⭐ answers taken: Q1 A, Q2 A, Q3 A)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/plan-approved.md` (read-only; AC1–AC7, AC7 live).
Copy it to `docs/plans/2026-11-11-media-clickable.md` in your branch. Build every AC test first (RED, then GREEN), one
test per AC named exactly as the plan names it, and one screenshot or terminal capture per AC in
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/builder/` (AC4: site | paste at three widths before and after).

Mini pipeline: if the fix needs more than ~3 source files beyond the plan's, a design decision, or touches auth/data/API
areas, stop with `status: stopped`, `stop_reason: escalate to full`.

## Where
Your own worktree (it starts at `origin/main` = `0248176342c6…`, Build 2026-11-11.3): branch
`media-clickable-build`. Other jobs running at the same time: footer-icon-list (merging next as 11.4: capture readers),
site-native-structure (src/core/site/elementor-*), site-menu-motion (open-paste, slide), media-avif-alt
(tools/lib/site-upload/, maybe media.ts), site-scroll-lock / site-sticky-header (page-wide CSS, header). Stay in the plan's
files; name any shared file you must touch.

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) and `npm run corpus` before
Task 1 and at the close; the full `test:web` and `test:browser` file by file at the close under 4G scopes (B-Dry files 8G),
compared with main by name (known failing on main on this desktop: composition-clipping, fonts, hero-pair, peer-sides,
pill-holder). If the job changes what a site paste writes, remake `test/fixtures/site-no-revert-main.json` as CLAUDE.md
says. Keep a ledger in `.superpowers/sdd/2026-11-11-media-clickable/progress.md`; HANDOFF section (new, newest first,
`Build <set at merge>`, paste check "next free after 3dz"). Commit after each passing task (plain `git commit -m`, no
author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder; never bare
`git stash`. Mutation-test the new rule's guards (`mutation-testing-discipline`, under a 4G scope).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/mcb/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (by the PIDs of its own
profile path; never `pkill -f`). Piped/chained git commands may be refused: script files run with `bash <file>`; `git -C
<absolute path>`. Use `tail -n 3`. Waits under 115 s; long drivers with `setsid --fork`, waiting on `^EXIT=`. Load on the
PC is high (other agents): a timing flake reruns alone before judging. SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text), stop at `ready-for-review`
Branch, head and base; per AC: test, RED evidence, GREEN, picture; gates against main by name; Justin's run remade
(AC6 counts); what stays CSS and why; `found_else`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
