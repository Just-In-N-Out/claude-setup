# BLIND AC AUDITOR (read only): staging-fit-capture (a width range read without the site's styles is read again, or the capture stops; a flagged capture is refused)

You are a fresh auditor (Fable 5.2, high). Independently prove the approved acceptance criteria. You have never seen a
builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/` except `plan-approved.md` and your own
`auditor/` folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `follow-ups.md`); nor HANDOFF, ledgers or
session notes. Source and tests are read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (local fixture servers and saved files only); no logins; never
write to any WordPress site. Nothing may hide that the importer's Chrome is automated.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/plan-approved.md` (AC1–AC6;
  AC6 is `(live)`, owed to Justin: mark it `not_run`). Use each exact test name the plan gives (find them all first
  with ac-check's own grep, `command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`; when a runner prints a
  name differently from the plan's phrase, use a by-name checker as `ac-verification.md` describes, never an edited
  plan).
- Head `7f44f989ae5780289a7f3df99aa87bf8d3825833` (branch `staging-fit-capture-fix1`), base
  `fd1986dcdbc8cf35f114b80be456e94279346743` (`main`, Build 2026-11-09.3), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/staging-fit-capture/auditor/` (empty).
- Saved inputs the plan names: Justin's capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` (read only).
  This machine has no `corpus/web` folder in the repo: a "no corpus capture is flagged" clause needs saved captures that
  hold `web.code` (search `~/.cache` and `~/.hermes/plans/figma-to-bricks/evidence/` for `*.f2b-capture.json`, other
  jobs' folders only to find such files; say which you used and whether each holds code).

## Your copy
In your own worktree: `git checkout --detach 7f44f989ae5780289a7f3df99aa87bf8d3825833`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly
8388608 bytes and restore them with `git checkout --`). Your `ac.json` names this head and base. Never write in any
other worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md` and `references/live-site-reading.md`; the repo `CLAUDE.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and
base runs (log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on head and fail on base for new
behaviour; a setup or import failure of a new module is weak RED: add a supporting base run with a labelled stand-in
giving base's behaviour so the test fails on its own assertion; preservation that rightly passes on base is
`base_exempt` with a specific reason, backed by your own byte-identity probe). Also:
- Your own mutation proof for the guards: AC1's re-read (the retry removed; the styled check always true), AC2's stop
  (exit code, the file not written), AC3's `unstyledRanges` (its threshold or comparison), AC4's refusal in `site` and
  `site:check`.
- AC3 on Justin's real capture: the exact ranges the plan names.
- AC4 on Justin's real capture through the real commands (`npm run site`, `--elementor`, `site:check`): the exit code
  and the line.
- AC5: your own byte receipt, base against head in one process each (the Figma replays of the repo's real files;
  `dist/code.js`; clean fixture captures through `npm run site` on both routes and both picture modes).
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p fd1986dc..HEAD -- <each AC's test files>` and read every changed assertion against the plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfc-a/tmp`,
  one per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: close every Chrome you start (kill by its profile path if Node dies). A browser or web run counts only
  with `skipped 0` for the AC's tests. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls. Run
  multi-step commands from a script file written with Write, paths spelled out; keep scripts and logs under
  `~/.cache/sfc-a/` and copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a script a background run
  is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (the parallel unit suite may need 8G; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls into a fresh folder named
  for your role, and copy head's test files plus the test-only modules and fixtures they import into it.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC accepted.
Empty skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with
`MAIN SESSION: check and save these skill_lessons now.`
