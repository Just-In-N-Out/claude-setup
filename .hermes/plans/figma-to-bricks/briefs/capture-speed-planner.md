# Role: planner: capture-speed (make `npm run capture` of a live site much faster)

You are a fresh planner for FigmaToBricksV2 (Opus 5.5, xhigh). Plan only: no product code, no BUILD bump, no merge, no
push, never start other agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never
bare `git stash`, leave other worktrees alone. **Never load bdryswi.com** (it has a bot check; only Justin runs it) and
log in to no site; never write to any WordPress site. Nothing paid: no paid service or API.

**Skills to load:** the project skill `figma-to-bricks` (`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/live-site-reading.md` and `references/testing-pitfalls.md`), `engineering-best-practices`,
`implementation-planning`, plus `perf-regression-hunter` for measuring where the time goes.

## Where you work
Your own copy of the repo (from `main`, Build 2026-11-07.1). Write `docs/plans/2026-11-07-capture-speed.md` and commit it
(`git commit -m "capture-speed plan: …"`, `git diff --cached --name-only` must not list CLAUDE.md). Report branch and commit.

## Why (Justin, 2026-11-07: "Is there a way we can make this faster the scanning to cut the time?")
Justin's capture of bdryswi.com today (`npm run capture -- https://bdryswi.com/`, `tools/capture.ts`, `src/web/`) took
about 30–40 minutes. Its output (he pasted it):
- switch points found by checking 32 boundaries; then "Reading at 48 widths… (16 ranges …)";
- the "I am human" check appeared **5 times**: each range seems to load the page afresh, and a reload after his wifi
  dropped brought the check back; 4 of 16 ranges then got an HTTP 403 or a self-reload and were never read;
- fonts, 66/79 pictures, three parts, 422 moving boxes, a 25.2 MB file.
The saved stand-in capture of the same page takes about 33 min (testing-pitfalls). The importer now pastes from the
site's own code (`web.code`), so ask what each step still needs: per-width full page loads vs. one load resized,
reading code once and only geometry per width, how many widths are needed when the CSS media queries are known,
parallel tabs in the one visible window (the human check must still be passed by a person; the importer never hides
automation: CLAUDE.md "The importer never hides that its Chrome is automated"), picture downloads in parallel, waits
that are fixed sleeps.

## What the plan must do
1. **Measure first:** time each phase on the repo's offline fixtures and a local stand-in served from the saved capture
   (no live site), and name where the minutes go, with file:line evidence.
2. Propose the changes that cut the most time, ranked, each keeping the paste's result: the pastes `npm run site` makes
   from a faster capture must be the same as from today's capture (byte-identical where the page is the same), and
   `site:check` must still pass within 2 px on the saved B-Dry stand-in. Also: a page load that fails (403, reload) is
   retried in the same window rather than skipped, and the person check is asked at most once per capture when the
   site allows it.
3. Numbered ACs AC1, AC2… with one named test each, a target time (say what is realistic, e.g. under 10 minutes for
   bdryswi.com's home), and `(live)` on any AC only Justin can check (the real bdryswi.com timing).
4. Questions for Justin at the top with ⭐ recommended answers (the project's standing auto-go takes them).

## Report (as text)
Branch, commit, the plan path, the measured phase times, the ACs one line each, the questions with ⭐ answers, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/cs-p/tmp`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; one Chrome job of your own at a time; heavy runs under
`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; SIGTERM/143/137 may be earlyoom (`journalctl -u earlyoom
--since "-30 min" -o short-iso | grep sending`). Keep foreground waits under 115 s.
