# Role: builder (Full): site-fonts-match — a scanned page carries exactly the font files its visitors get

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`,
the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`,
`references/live-site-reading.md` — its fonts lines —, `reference/bricks/README.md`). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. **Never load bdryswi.com** (Justin's rule),
B-Dry staging or any live site except Google Fonts as `site:check` already does; no logins; never write to any WordPress site; touch
nothing under `~/Downloads` (the planner's copies are in its evidence). The importer never hides that its Chrome is automated; every
capture Chrome launches through `launchCaptureChrome`.

## The plan (approved under Justin's standing auto-go; he is asleep: Full, Q1 A ⭐ — match what the official page shows)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/plan-approved.md` (read-only; AC1–AC9; AC9 live). Copy it to
`docs/plans/2026-11-11-site-fonts-match.md`. Planner evidence: `~/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/planner/`
(`measure.log`, pictures, scripts). The fix is not prototyped: build every AC test first (RED on the base, then GREEN), each named
exactly as the plan names it, one picture or terminal capture per AC in
`~/.hermes/plans/figma-to-bricks/evidence/site-fonts-match/builder/` (AC5: a heading and a paragraph site | paste at 1440 and 390 with
the drawn font file named). Keep Q1's default in one place so B is a one-line switch, and say where.

## Where
Your own worktree (starts at `origin/main` = `e61c0ca0`, Build 2026-11-11.6): branch `site-fonts-match-build`. Files: `src/web/read/fonts.ts`,
the capture's end-of-scan step, `src/core/site/fonts.ts`, `controls.ts`, `test/web/lib/site-check.ts`, tests. Overlaps: site-shared-styles
(planned; text classes and Typography controls — name what it must keep), site-no-div (planned), footer-icon-list (other session,
merging: capture readers). Name every shared file you touch.

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) before Task 1 and at the close; the
whole unit suite (golden/pin tests move only by design, each with a four-tree or per-variant proof: older captures byte for byte —
AC7); `test/fixtures/site-no-revert-main.json` remade only if its pastes change; the full `test:web` and `test:browser` file by file
at the close under 4G scopes (B-Dry files 8G), compared with main by name (known failing on main here: composition-clipping, fonts,
hero-pair, peer-sides, pill-holder; flaky under load: capture-opens-guards' service-worker cases, site-live's 5.09 px). Ledger in
`.superpowers/sdd/2026-11-11-site-fonts-match/progress.md`; HANDOFF section (newest first, `Build <set at merge>`, paste check `<id at
merge>`). Commit after each passing task (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't
bump BUILD; don't edit the main folder; never bare `git stash`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sfb/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`). Write scripts with the Write tool, run as plain `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. Stop stand-in servers in one outer `finally`.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to
process'` first and rerun alone under a cap.

## Report (as text), stop at `ready-for-review`
Branch, head and base; per AC: test, RED, GREEN, picture; where Q1's default lives; gates by name; `found_else`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
