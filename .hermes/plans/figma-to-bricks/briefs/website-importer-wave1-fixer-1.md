# Fixer brief: website importer wave 1 (web-capture), fix 1 after the final verifier

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building and not too much of edge cases."
Fix the one real bug the final verifier found, amend the plan as Justin ruled, test first, and stop. Never stop to ask;
decide and record.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline` with the Skill tool; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and `references/live-site-reading.md` ("Writing
readers", "Mapping into the Snapshot"), `references/testing-pitfalls.md`.

## Start

Your worktree starts at `main`. `git checkout --detach a2ae004dff5de3f1405bde34c7d93dc79e329403` (wave 1's combined
head on main `b09727f`), then `git switch -c wave1-fix-1`. Plan: `docs/plans/2026-10-29-web-capture.md` (its approved
copy `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`). Verifier report and probes:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/verifier-2/` (`report.json`, `ac.json`, `probe/probe-check.log`,
`probe/probe-nonewidth.log`, `probe/probe-extras.log`, `probe/live-fixed-in-roots.log`).

## 1. Fix V2-F2 (AC3, P2), test first

A box's own stretchy width (%, vw, calc, `var()`) is recorded only when its parent maps to auto layout. It is lost (no
`web.stretchy.width`, no note) for a box whose parent maps to `layoutMode: NONE` and for an absolutely placed box: a
40vw box beside a `margin: auto` sibling, `width: var(--w)` (80%) with `max-width: 900px`, inline-block cards at 30%, a
placed box at 40%. Cause: `src/web/map/node.ts:214-221` returns before `sizingOf`, the only writer of the width
(node.ts:237), and `STRETCH_PROPS` (node.ts:38) has no width. On the live plugin-made home 217 of 582 non-root layers
sit in NONE frames. Rule: record a box's own stretchy width (and its min/max) whatever its parent's layout, under the
same check AC3 already applies (it reproduces the browser's px at every sample, else the existing note). Verify on
a2ae004 with the verifier's probes first, RED with a generic fixture, then the fix. Kill the mutants of the new rule
(under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`).

## 2. Amend the plan as Justin ruled (2026-11-02), one commit, plan text only

- **AC4:** Justin chose "Keep it in the Header": a part's own fixed content (a sticky header bar) stays inside its part,
  marked `web.position: "fixed"`; other fixed boxes (chat bubbles, plugin buttons, the site's own call button, cookie
  bars) still go to the footer part's floating extras. Replace AC4's clause "no root's tree holds a fixed box" with that
  rule; keep the rest of AC4 and its test name.
- **AC14 / new AC15:** Justin chose "Mark it mine, merge now". AC14 keeps its test and covers the home page of each other
  site in `corpus/web.json` (www.letsgro.ai, the plugin-made Bricks site). Add `- AC15 (live): every page in bdryswi.com's
  sitemap passes the same capture check once Justin allow-lists the capture there.` (owed to Justin).
- Add one line under the plan's top: "Amendment 1 (2026-11-02, Justin): AC4 part-own fixed content; AC14 split, AC15
  live." Record both rulings in HANDOFF's web-capture section as Justin's (confirmed).

## Gates (compared by test name with a2ae004)

Both typechecks, `npm run check`, the capture test files (`test/web/capture-*.test.ts`) run file by file, the five
Figma replays byte-identical (hydraulics, GRO, Repairs, brainstorm, Services from `2199895`, plain and `--site`), and
AC14's test on fresh captures of letsgro.ai and the plugin-made home (`F2B_WEB_CAPTURES`, `F2B_WEB_SITES=letsgro,plugin-bricks`,
GET only). Don't re-run the whole test:web or test:browser suites unless your fix touches files they load beyond `src/web`.

## Rules

- Plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged. Don't push, don't bump `BUILD`, don't
  rebase, never bare `git stash`; leave `wave1-final` and every other branch and worktree alone.
- Chrome: at most one Chrome job of your own at a time, closed after each step; sibling TMPDIRs if you ever run two
  steps at once. Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill
  (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/w1-fix1/tmp`). Write
  multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; the bare word `source` in a
  command is refused. Probe pages need `<meta name="viewport" content="width=device-width">`.
- Live reads only of `https://darksalmon-badger-335429.hostingersite.com/` (`?f2b=<random>`) and `https://www.letsgro.ai/`,
  GET only; never bdryswi.com; never write to any WordPress site. Put any summary in your report.
- Evidence in `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-11/`.

## Report

Branch, head SHA, commits; V2-F2: fixed (test name, RED log, commit, mutants); the plan amendment commit; gate tallies
by name; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
proposal; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
