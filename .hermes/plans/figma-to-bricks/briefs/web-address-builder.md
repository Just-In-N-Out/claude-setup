# Builder brief: web-address (type a live website's address in the plugin panel)

**Role:** builder (fresh Opus 5.5, xhigh). You build the approved plan test-first and stop at `ready-for-review`.
Justin (2026-11-02): "focus on building and not too much of edge cases." Take the plan's ⭐ answers; where the plan is
silent or wrong, decide and record the ruling (not yet confirmed) in the ledger and your report. Never stop to ask.
**Keep iterating until every AC passes its test** (never hand back with an AC failing); skip extra probing beyond what
the plan's tasks and ACs need, and note edge cases in one line as follow-ups instead of building for them. AC13 is
`(live)`, owed to Justin.

**Skills:** load `engineering-best-practices`, `test-driven-development` and `security-best-practices` with the Skill
tool (a local server that reads websites on request); read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/live-site-reading.md`,
`references/testing-pitfalls.md`, `references/panel-validation.md` (its "Panel network" section).

## Start

Your worktree starts at `main`. `git checkout --detach 10c7ddc9374de13eda937c413f90952796f625f4` (the plan commit, on
the panel's head `c2f6a16`, which merges into main soon), then `git switch -c web-address-build`. Then
`diff docs/plans/2026-11-02-web-address.md ~/.hermes/plans/figma-to-bricks/evidence/web-address/plan-approved.md` must
be empty. Your base is `c2f6a160f533a8912727e8fcc4cc9ad5255708e7`; at the finish the branch moves onto main with
`git rebase --onto main c2f6a16`. Planner evidence (probes, base tallies, protocol check):
`~/.hermes/plans/figma-to-bricks/evidence/web-address/planner/`.

**One preference beyond the plan:** make Justin's one-time setup as small as you can. If `CHROME_PATH` isn't set, have
the helper find the Chrome this repo's tools already use (the plan's wrapper path, or `~/.cache/chrome-for-testing/`)
and say plainly which one it uses, so `npm run capture:serve` works with no `.bashrc` edit; keep the plan's ACs as written.

## Rules

- Ledger in `.superpowers/sdd/2026-11-02-web-address/progress.md`; commit after each passing task (plain
  `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push, don't bump `BUILD`, never bare
  `git stash`. Write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; the bare
  word `source` in a command is refused.
- Gates at the close, compared by test name with the planner's base tallies at c2f6a16: both typechecks, `npm run check`,
  the panel browser files the change touches plus `panel-google-fonts.test.ts`, the five Figma replays byte-identical, and
  `dist/code.js` unchanged (AC12).
- **Chrome:** at most one Chrome job of your own at a time, closed after each step (Justin lifted the shared slots; if I
  send "back to N slots", hold one of `~/.cache/f2b-chrome.lock`, `-2`, `-3` for your whole Chrome sequence).
- **Runaway memory:** SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill
  (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun such a check under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; mutation runs always use that cap.
- **This machine (WSL):** `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`
  for tests, Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/waddr-build/tmp`).
  A helper you start for a test binds a free port (`--port 0`) and is stopped at the end; never leave one running.
- Live reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only; never bdryswi.com (bot check); never write to any WordPress site; never call
  alttext.ai for real.
- Put any summary in your report, not in a separate summary file.

## Report (`ready-for-review`)

Branch, head SHA, base, commits in order; each AC → its test → evidence file (one screenshot or terminal image per AC);
gate tallies against the base by test name; rulings; follow-ups; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (reusable only; `enforce` `none` or a one-line check proposal; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
