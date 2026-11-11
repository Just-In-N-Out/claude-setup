# Role: verifier (read-only): footer-icon-list

You are a fresh verifier who never saw the build, the reviews or the fixes (**Opus 5.5, high**). Prove each acceptance
criterion yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other
worktrees (read them with `git show`). **Never load bdryswi.com, B-Dry staging** or any live site (local fixture
servers, the offline B-Dry stand-in sites and saved files only); no logins; never write to any WordPress site; never
run `npm run site:upload` or `site:import` against anything but the tests' own 127.0.0.1 stand-in. Nothing may hide
that the importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you didn't start;
touch nothing under `~/Downloads`.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (two
offline B-Dry stand-ins exist; receipts named by sha), `references/live-site-reading.md` ("Writing readers"; "Code-route
paste traps": Bricks prints a class control as `.cls.brxe-<el>`; DevTools doesn't list `border-block`/`border-inline`/
`border` as shorthands) and `references/rendering-validation.md`; `reference/bricks/README.md`.

## Inputs
- Approved plan (read-only, the v2 plan; not `plan-approved-v1-mini.md`):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md` (AC1–AC10; AC6 live: mark it
  `not_run`, owed). The job: the capture's reader keeps each box side and size by one name — the one the site's cascade
  applied — at every width range, under hover and focus, for `::before`/`::after` and inline elements of words, a
  logical name mapped to its physical side through the element's computed writing mode and direction; new captures
  are marked `web.code.oneName: true`; the conversion picks no winner; captures made before this build paste byte for
  byte as before with one note where an element holds a top/bottom side or a size by two names with different values.
  Find every cited test name with ac-check's own grep first (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)"
  <plan>`); read each cited test before you run it (a test that only asserts what a sibling collects is run with its
  whole file); named-only tests run with their variables set (read the test for them).
- Head `fb26a529ee24bfa97f9b563756eb2698e826c328` (branch `footer-icon-list-stack3`; records commit; code head
  `719826bd`), base (old code) main `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9` (Build 2026-11-11.2). In your own
  worktree: `git checkout --detach fb26a529ee24bfa97f9b563756eb2698e826c328`, confirm `git rev-parse HEAD` and a clean
  status. Old code: a tree from `git archive` of `e16d3d1e` with head's test files, fixtures and test-only modules
  copied in (a new module that doesn't import on base is weak RED: prove the test can fail with a one-line mutant of a
  head copy; preservation ACs that rightly pass on base are `base_exempt` with a reason and your own byte receipt). An
  AC log cited in `ac.json` starts with the bare `HEAD=<sha>` (say "archive" on its second line) and ends with one line
  `EXIT=`, skipped 0.
- **AC1's capture:** capture the offline B-Dry stand-in fresh with head's reader (and with base's for RED); never reuse
  a saved capture by path alone (one was overwritten earlier). If you compare with the read-only saved head captures
  (`evidence/footer-icon-list/inputs/standin-capture-joined-f0948ab2.json`), check their sha256 first.
- **Known, not this job's:** control-weight's named `site-inline-own-bytes` story pin fails on the B-Dry captures by this
  job's AC9 note only (four trees in `evidence/footer-icon-list/stack-3/logs/fourtree-inline-own-bytes.log`: record,
  don't count); site-menu's `site-opens-old` with `F2B_SITE_MENU_BDRY` fails on main the same; `capture-speed-bdry`
  "AC2" is stale against code version 3; five browser files fail on main on this desktop (composition-clipping, fonts,
  hero-pair, peer-sides, pill-holder). Known flakes: `capture-entrances` R7-2/R8-1; `site-motion-proof` AC5 under
  load; F6-5 in `capture-opens-guards`; the code-page 5.09 px: rerun alone before judging.
- Don't read the builder's, fixers' or reviewers' reports or folders as proof.

## Work
1. **Gates on head against base by name:** both typechecks (`tsconfig.sandbox.json` too), `npm run check` (8G scope),
   `npm run corpus` (same output as base; v1's Mac files are missing here), the **full** `npm run test:browser` and
   `npm run test:web`, file by file, each alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`
   (B-Dry files 8G; export variables first; no `--setenv=PATH`; a separate TMPDIR of about 24 characters per script
   started at the same time), compared with base by test name; run base's side yourself for every file whose result
   differs. The five Figma replays and `dist/` byte-identical to base's build. `test/unit/plugin-convert.test.ts`.
2. Every AC's named test on head (must pass) and on old code; a picture or terminal capture per AC (AC1: B-Dry's footer
   site | paste at 1025, 768 and 390, before and after).
3. **The winner, proven by you beyond the fixtures** (pages of your own on local servers; each paste drawn as Bricks
   2.4.2 and 2.3.9 print it, against the site at three widths): specificity beating order; `!important` in a sheet and
   inline; `@layer` order (layered `!important` is a recorded limit: R2-2 of review 2 — say what you see); `:where()` /
   `:is()`; a `<style>` added by script; Elementor-style list rows (a reset plus `margin-block-start` /
   `padding-block-end`); Tailwind-v4-like utilities; `writing-mode` / `direction` on an ancestor; `::before` / `::after`;
   hover and focus looks; **an opened box** (a drawer whose rows are spaced by a reset plus logical names, read by
   site-menu's press step): the Offcanvas, opened, draws the site's spacing.
4. **Older captures byte for byte** (AC4, AC9): every saved capture under `~/.hermes/plans/figma-to-bricks/evidence/`
   used as an input file only, both routes, both picture modes, both text modes: payloads and sources equal to base's;
   only the note where the plan says.
5. **The capture's time and requests** (AC10): the offline stand-in, base and head alternately at the same load (base,
   head, head, base), against the plan's limit; requests per address equal.
6. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/verifier/ac.json` and logs in that
   folder; self-check it with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy
   (`--base e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`, no `--reviews`), as the reference says.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/filv/t1`,
`t2`, …; a Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by the PIDs
of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc, a shell
function or a word containing "git" may be refused: write such steps to a script file with Write and run `bash
<file>`; `git -C <absolute path>`). Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running against.
Scripts and logs under `~/.cache/footer-icon-list-verifier/`. SIGTERM / 143 / 137 or "Killed" may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`). `compare-corpus.test.ts` needs
`--test-timeout=3600000`. Waits under 115 s; start long drivers with `setsid --fork` and wait on `^EXIT=` in bounded
loops. The PC restarted three times this week: write each log's `EXIT=` line; when resumed, read your finished logs
first and never start a second driver on a suite one is still working through.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result (or the mutant), evidence path; the winner table (shape → captured name and
value, paste against the site at three widths, head and base); the older-captures byte receipt; AC10's time and
requests; gates; `verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal;
`enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with `MAIN SESSION: check and
save these skill_lessons now.`
