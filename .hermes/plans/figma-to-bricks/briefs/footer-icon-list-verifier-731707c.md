# Role: verifier (read-only), the rebased head: footer-icon-list

You are a fresh verifier who never saw the build, the reviews or the fixes (**Opus 5.5, high**). Prove each acceptance
criterion yourself on the rebased head. Change no source or test, commit nothing, start no agents. Never edit the main
folder or other worktrees (read them with `git show`). **Never load bdryswi.com, B-Dry staging** or any live site (local
fixture servers, the offline B-Dry stand-in sites and saved files only); no logins; never write to any WordPress site;
never run `npm run site:upload` or `site:import` against anything but the tests' own 127.0.0.1 stand-in. Nothing may
hide that the importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you didn't
start; touch nothing under `~/Downloads`.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`; `reference/bricks/README.md`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Why you run
footer-icon-list was accepted on `fb26a529` (main `e16d3d1e`). It was rebased onto main
`0248176342c662b821629d462f4d15a2a2a1df98` (Build 2026-11-11.3, capture-refused-styles) as branch
`footer-icon-list-final`, head **`731707c5e84f9495e152b60d302fe640f6f06554`**; the rebase resolved conflicts in
`docs/HANDOFF.md` only, so the earlier reports don't carry over: every AC is proven again on this head against base
`02481763`. A clean delta review (review-4) found the job's code outside HANDOFF byte-identical to the accepted head.
Two features that pass alone can break together: the gates matter as much as the ACs.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/plan-approved.md`
  (AC1–AC10; AC6 live: mark it `not_run`, owed). Find every cited test name with ac-check's own grep first (`command
  grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`); read each cited test before you run it (a test that only
  asserts what a sibling collects is run with its whole file); named-only tests run with their variables set.
- In your own worktree: `git checkout --detach 731707c5e84f9495e152b60d302fe640f6f06554`, confirm `git rev-parse HEAD`
  and a clean status. Old code: a tree from `git archive` of `02481763` with head's test files, fixtures and test-only
  modules copied in (a new module that doesn't import on base is weak RED: prove the test can fail with a one-line
  mutant of a head copy; preservation ACs that rightly pass on base are `base_exempt` with a reason and your own byte
  receipt). An AC log cited in `ac.json` starts with the bare `HEAD=<sha>` (say "archive" on its second line) and ends
  with one line `EXIT=`, skipped 0.
- **AC1's capture:** capture the offline B-Dry stand-in fresh with head's reader (and with base's for RED); never reuse
  a saved capture by path alone.
- **Known, not this job's:** control-weight's `site-inline-own-bytes` story pin fails on the B-Dry captures by this job's
  AC9 note only (record, don't count); site-menu's `site-opens-old` with `F2B_SITE_MENU_BDRY` fails on main the same;
  `capture-speed-bdry` "AC2" is stale against code version 3; five browser files fail on main on this desktop
  (composition-clipping, fonts, hero-pair, peer-sides, pill-holder). Known flakes: `capture-entrances` R7-2/R8-1;
  `site-motion-proof` AC5 under load; F6-5 in `capture-opens-guards`; the code-page 5.09 px: rerun alone before judging.
- Don't read the builder's, fixers', reviewers', earlier verifier's or auditor's reports or folders as proof
  (`verifier-fb26a529/`, `auditor-fb26a529/` included).

## Work
1. **Gates on head against base by name:** both typechecks (`tsconfig.sandbox.json` too), `npm run check` (8G scope),
   `npm run corpus` (same output as base), the **full** `npm run test:browser` and `npm run test:web`, file by file, each
   alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry files 8G), compared with base by
   test name; run base's side yourself for every file whose result differs. Pay special attention to
   capture-refused-styles' tests (`capture-refused`, `site-import`) and this job's capture tests running together. The
   five Figma replays and `dist/` byte-identical to base's build. `test/unit/plugin-convert.test.ts`.
2. Every AC's named test on head (must pass) and on old code; a picture or terminal capture per AC (AC1: B-Dry's footer
   site | paste at 1025, 768 and 390, before and after).
3. **Older captures byte for byte** (AC4, AC9): every saved capture under `~/.hermes/plans/figma-to-bricks/evidence/`
   used as an input file only, both routes, both picture modes, both text modes: payloads and sources equal to base's;
   only the note where the plan says.
4. **The capture's time and requests** (AC10): the offline stand-in, base and head alternately (base, head, head, base),
   against the plan's limit; requests per address equal.
5. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/footer-icon-list/verifier/ac.json` and logs in that
   folder; self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` on a copy
   (`--base 0248176342c662b821629d462f4d15a2a2a1df98`, no `--reviews`), as the reference says.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/fv7/t1`, `t2`, …;
a Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (by the PIDs of its own
profile path; never `pkill -f`). A `git archive` scratch tree has neither `tsc` nor `node_modules` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH and symlink the main folder's `node_modules` in; a
piped, chained or redirected git command, a heredoc, a shell function or a word containing "git" may be refused: write
such steps to a script file and run `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`. Never edit a tree a test
is running against. Scripts and logs under `~/.cache/fil-verifier7/`. SIGTERM / 143 / 137 or "Killed" may be earlyoom
(`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`).
`compare-corpus.test.ts` needs `--test-timeout=3600000`. Waits under 115 s; start long drivers with `setsid --fork` and
wait on `^EXIT=` in bounded loops. Write each log's `EXIT=` line; when resumed, read your finished logs first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result (or the mutant), evidence path; the older-captures byte receipt; AC10's time
and requests; gates against base by name; `verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
