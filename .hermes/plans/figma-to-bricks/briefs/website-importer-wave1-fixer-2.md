# Fixer brief: website importer wave 1, fix 2 (web-capture AC4 after verifier 3)

**Role:** fixer (fresh Opus 5.5, xhigh). Justin (2026-11-02): "focus on building and not too much of edge cases." Fix
the one real bug verifier 3 found, plus one small test fix, test first, and stop. Never stop to ask; decide and record.

**Skills:** load `receiving-code-review`, `test-driven-development`, `engineering-best-practices` and
`mutation-testing-discipline`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`,
`references/live-site-reading.md` ("What counts as shown", "Mapping into the Snapshot") and `references/testing-pitfalls.md`.

## Start

Your worktree starts at `main`. `git checkout --detach 5b52fe7ac9ea484b1abda162349c7f5264656058` (wave 1 after fix 1),
then `git switch -c wave1-fix-2`. Approved plan (amended): `~/.hermes/plans/figma-to-bricks/evidence/web-capture/plan-approved.md`
(AC4 as amended by Justin: a part's own fixed content stays in its part; other fixed boxes, the site's own call button
included, go to the footer part's floating extras). Verifier 3's report and probes:
`~/.hermes/plans/figma-to-bricks/evidence/web-capture/verifier-3/` (`report.json`, `probe/fixed2.log`,
`scripts/probe-site/` with `/phonefab/` and `/barhdr/`, `scripts/probe-fixed2.mjs`).

## 1. Fix V3-F1 (AC4, P2), test first

A fixed box the design width (1440) hides but another width shows is lost: in no root, not in `web.floating`, no note.
Real cases: a phone-only "Call now" bar fixed to the bottom (very common on local business sites) is dropped; in a
header holding only fixed bars, a phone-only fixed bar and its words are dropped while the desktop bar is kept.
Cause: `src/web/assemble.ts:63,132-133` collects floating boxes only from the design width's reading;
`src/web/map/tree.ts:89-97` builds a hidden child from the first width that shows it unless it is fixed there, so it
is neither built nor floated. The plan's step 4 reads floating inputs at each range's anchor width. Rule: read fixed
boxes in every range that shows them; a part's own fixed content (amended AC4) is built in its part from the range
that shows it and hidden where the site hides it; every other fixed box goes to the footer's floating extras with the
ranges it shows in (so J5 pastes a phone-only extra hidden on wider screens). Remove HANDOFF's "Deferred" line that
listed this. Test: in `test/web/capture-floating.test.ts`, a fixture page with a phone-only fixed call bar and a
header of a desktop fixed bar plus a phone-only fixed bar: the call bar is an own floating box of the footer with its
showing ranges; both header bars are in the Header root, marked fixed, each hidden where the site hides it. Verify on
5b52fe7 with the verifier's probe first. Kill the mutants of the new rule (under the 4G memory cap).

## 2. Small test fix (FE-1, from the compare auditor)

`test/web/compare-cli.test.ts`'s FE-1 test nests its Chrome temp folder under TMPDIR; Chrome's socket path then passes
107 characters whenever TMPDIR is over ~38 characters (the Mac's default `/var/folders/…/T/` included) and the test
fails at launch ("Socket path too long"). Make it create its temp folder with a short `mkdtemp` under `/tmp` (or
`os.tmpdir()` only when short enough). No behaviour change in `tools/site-compare.ts`.

## Gates (compared by test name with 5b52fe7)

Both typechecks, `npm run check`, the `test/web/capture-*.test.ts` files and `compare-cli.test.ts` run file by file
(with a TMPDIR over 38 characters too, to prove item 2), the five Figma replays byte-identical (hydraulics, GRO,
Repairs, brainstorm, Services from `2199895`, plain and `--site`), and AC14's test on fresh captures of letsgro.ai and
the plugin-made home (`F2B_WEB_SITES=letsgro,plugin-bricks`, GET only). Not the whole test:web/test:browser suites.

## Rules

- Plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged. Don't push, don't bump `BUILD`, don't
  rebase, never bare `git stash`; leave every other branch and worktree alone.
- Chrome: one Chrome job of your own at a time, closed after each step; sibling TMPDIRs if you ever run two at once.
  Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill
  (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`).
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/w1f2/tmp`). Write multi-step
  scripts with Write and run `bash <file>`; git commands as separate plain calls; the bare word `source` in a command is
  refused. Probe pages need `<meta name="viewport" content="width=device-width">`.
- Live reads only of `https://darksalmon-badger-335429.hostingersite.com/` (`?f2b=<random>`) and `https://www.letsgro.ai/`,
  GET only; never bdryswi.com; never write to any WordPress site. Put any summary in your report.
- Evidence in `~/.hermes/plans/figma-to-bricks/evidence/web-capture/fixer-12/`.

## Report

Branch, head SHA, commits; V3-F1 and the FE-1 test fix: fixed (test name, RED log, commit, mutants); gate tallies by
name; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
proposal; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
