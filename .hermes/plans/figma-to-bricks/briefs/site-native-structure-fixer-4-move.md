# Role: fixer (move + small fixes): site-native-structure — onto footer-icon-list's accepted branch

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review`, `engineering-best-practices`,
`test-driven-development`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(with `references/testing-pitfalls.md`) and read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load bdryswi.com,
B-Dry staging or any live site; no logins; never write to any WordPress site; touch nothing under `~/Downloads`. Never
stop a Chrome you didn't start. Commit to your branch only; don't push; don't bump `BUILD`; don't edit the main folder or
CLAUDE.md; never bare `git stash`.

## State
`site-native-structure` (Justin's "the paste should look built in Bricks: Section/Container/Block, Button, Image…, not
div div div") is review-clean (review 4, MOVE ON) at branch `site-native-structure-fix3`, head `138799bb` (code head
`41c0a262`) on old main `7eeca437`. Its whole state and every finding: read
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/follow-ups.md` in full; approved plan
`evidence/site-native-structure/plan-approved.md` (read-only). It waited for **footer-icon-list** (B-Dry's footer icon
list drawn 69 px off by main's renderer broke its AC14 footer rows). footer-icon-list is review-clean on branch
`footer-icon-list-final`, head `731707c5e84f9495e152b60d302fe640f6f06554`, on main `02481763` (Build 2026-11-11.3) and is
being verified now; it merges next as Build 2026-11-11.4 (only a build commit will follow it on main).

## Do
1. In your own worktree make branch `site-native-structure-stack6` = `site-native-structure-fix3` rebased onto
   `731707c5e84f9495e152b60d302fe640f6f06554` (main's jobs since 7eeca437: staging-fit-renderer…capture-refused-styles,
   incl. control-weight, site-one-command, site-menu, footer-icon-list). Keep both sides' meaning on every conflict
   (HANDOFF sections both stay); record each conflict and its resolution in `evidence/site-native-structure/stack-6/`
   (`conflicts.md`), and where the jobs meet (control-weight's lifted-child / inline-word widths on a folded Button or
   lifted part — its fixture must still pass or be moved by this job's design with a four-tree proof; site-menu's
   Offcanvas and openers inside folded/lifted parts; footer-icon-list's one-name reader under the fold).
2. Take, test first: **R4-1** (`test/web/lib/site-check.ts`: read the origin `o` after the loop that finishes or holds
   running animations, as main's 971a2e99 did); **R1-6** (a section's own `id` is pasted so in-page links like
   `#service` jump — only if Bricks keeps it: check `reference/bricks/README.md` for `_cssId`; it's listed as
   unverified there — if unverified, don't write it; record why); **R4-2** if cheap (a test that kills the
   first-top-element-only mutant of `site-check-lifted`).
3. Gates on your head: `npm run check` (8G scope), `npm run corpus`, the full `test:web` and `test:browser` file by file
   under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry files 8G), compared with the base
   `731707c5` by name (known failing on main on this desktop: composition-clipping, fonts, hero-pair, peer-sides,
   pill-holder). AC14's whole-page test (`site-native-bdry`) and `site-elementor-page-bdry`: say whether the footer rows
   now pass.
4. **AC14's input:** footer-icon-list changes the capture (`web.code.oneName`); say exactly what AC14's stand-in capture
   should become (re-made by the new head's capture from the saved 2026-10-29 home served locally; its sha256) and what
   AC14's pinned counts are on it — a planner amends the AC after you (you don't edit the plan). Put the new stand-in in
   `evidence/site-native-structure/inputs/`.
5. Stop at `ready-for-review`: report the new head, the conflicts, the meeting points, the gates against base by name.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sn6/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (by the PIDs of its own
profile path; never `pkill -f`). A piped, chained or redirected git command, a heredoc or a shell function may be
refused: write such steps to a script file and run `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`. Waits under
115 s; long drivers with `setsid --fork`, waiting on `^EXIT=` in bounded loops; write each log's `EXIT=` line. Logs under
`~/.cache/sns-stack6/`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o
short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result.

## Report (as text)
Branch and head; conflicts and resolutions; meeting points; R4-1/R1-6/R4-2 (RED→GREEN); gates against base by name;
AC14's proposed input and counts; `found_else`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
