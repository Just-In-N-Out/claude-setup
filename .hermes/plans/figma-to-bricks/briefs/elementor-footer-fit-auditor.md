# BLIND AC AUDITOR (read only): elementor-footer-fit (fold rule 9: a widget box stretched past its body keeps the widget's elements)

You are a fresh auditor (Opus 5.5, high). Independently prove the approved acceptance criteria. You have never seen a
builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/` except `plan-approved.md`, the saved inputs named
below, and your own `auditor/` folder; nor HANDOFF, ledgers or session notes. Source and tests are read-only; commit
nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com** or any live site; no logins; never write to any WordPress site.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/plan-approved.md` (AC1–AC6; AC6 is `(live)`, owed to Justin: mark it `not_run`). Use each exact test name the
  plan gives (find them all first with ac-check's own grep).
- Head `8c45dff5810a393b9714957f381693d098c5f25d` (branch `elementor-footer-fit-final2`), base
  `b06d8267d4a3f26ee8ec9b3b0f7f2b45d0a594c9` (`main`, Build 2026-11-09.2, elementor-phone-fit merged), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/auditor/` (empty).
- AC1 and AC5's B-Dry tests are named-only: read the tests for their variables. Main now writes capture code version 3:
  capture your own stand-in from the saved 2026-10-29 bdryswi.com files with this head's capture (about 7–9 min under an
  8G `systemd-run` scope) and use it for head and base; find the saved files from `test/web/site-page-bdry.test.ts`, the
  repo docs and `~/.hermes/plans/figma-to-bricks/evidence/web-code-page/` (another job's folder: read it only to find
  paths). Say it is a saved stand-in, not the live site. Never open `auditor-1-*` or `verifier*` folders.

## Your copy
In your own worktree: `git checkout --detach 8c45dff5810a393b9714957f381693d098c5f25d`, confirm `git rev-parse HEAD` and
a clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly 8388608
bytes and restore them with `git checkout --`). Your `ac.json` names this head and base. Never write in any other worktree
or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` ("Hover, focus and motion") and
`references/rendering-validation.md`; `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top of
its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and base runs
(log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on head and fail on base for new behaviour; a setup
failure is not RED: use a hybrid tree to reach the assertion; preservation that rightly passes on base is `base_exempt`
with a specific reason, backed by a byte-identity probe), your own mutation proof for rule 9's guard (AC3: the height comparison, the tolerance, the margins and units counted, the first measured chain element, rule 8's precedence), your own
byte receipt for AC4 (convert the saved stand-in and the fixture captures in one process on base and head, both routes),
and a screenshot per AC (site | paste at 1025 for AC1, at 390 for AC2, a terminal image for a non-visual AC). Run `git log -p b06d8267..HEAD -- <each AC's test files>` and read every changed assertion
against the plan. Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder
and running `ac-check.sh` on them (no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-a/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run Chrome too: close every Chrome you
  start (kill by its profile path if Node dies). A browser or web run counts only with `skipped 0` for the AC's tests.
  The worktree's `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from a script file written
  with Write, paths spelled out. Never edit a script a background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0
  <cmd>` (B-Dry captures 8G; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls, and copy head's test files
  plus the test-only modules they import into it.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC accepted.
Empty skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with
`MAIN SESSION: check and save these skill_lessons now.`
