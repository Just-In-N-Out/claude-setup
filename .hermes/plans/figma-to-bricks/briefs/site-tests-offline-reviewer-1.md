# Role: reviewer round 1 + verifier AC work (Mini; report only): site-tests-offline

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Mini pipeline: this is the job's one full review, and you also do
the verifier's AC work (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`). Change no source or test,
commit nothing, start no agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into
another command: `git archive -o <absolute path> <sha>`, extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs).
**Never load any live site:** run any test that draws Justin's scan or the B-Dry stand-in only on the head (offline) or under the job's sink
wrapper (`test/web/offline/sink.ts`; every outside host answered on 127.0.0.1); never write to any WordPress site; touch nothing under
`~/Downloads`. Load `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first. Don't read the builder's report or folder as proof. Report P0–P2 only for what a real test run or agent hits.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md` (AC1–AC4, none live;
  Q1 ⭐ A every test file that draws a site paste or capture; Q2 ⭐ A `site-live-widget-bdry.test.ts` is the one kept exception).
- Head **`4b8b757397a69abe8afb65a5607085f3b51cd144`** (branch `site-tests-offline-build`), base **`392f67e2a6b52c40a64acaf7d344a50c934dee26`**.
  `git checkout --detach 4b8b7573…`. Review `git diff 392f67e2...4b8b7573` (76 files: 67 converted test files, the helper
  `test/web/lib/offline-chrome.ts`, its test, the guard `test/unit/site-tests-offline.test.ts`, the scan test, `test/web/offline/{tally,sink}.ts`,
  HANDOFF, ledger, plan copy).
- Justin's scans (read-only): `F2B_BDRY_CAPTURE=/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`,
  `F2B_BDRY_CAPTURE_1109=/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`; each only to its own file.

## Check hardest
1. **The guard can't be dodged by normal code:** a new test file that draws a site paste through a helper the guard doesn't name, a launcher
   re-exported from a test lib, a dynamic import, `puppeteer`-style direct spawn of `CHROME_PATH`, a test lib under `test/web/lib/` that
   launches for its callers. Which of these would a real future test plausibly write? Is the "draws a site" detection wide enough (every
   converter/drawing helper name in `test/web/lib/` and `test/fixtures/`)? Mutants beyond the builder's three.
2. **`launchOffline()`:** one host-rule switch, last on the command line (Chrome reads only the last); a test's own maps only to 127.0.0.1; it
   throws on another map; Google Fonts optional; nothing else a caller passes can add a second `--host-resolver-rules`.
3. **No test lost its meaning:** the 67 one-line edits keep each test's own maps (e.g. `MAP www.x.test 127.0.0.1`), and AC4's tally (base vs
   head, 239 tests by name) is right — run it yourself on a sample.
4. **What's left online:** the capture's own Chrome (`launchCaptureChrome`) and site:live's Chrome carry no host rule (src/ and tools/ code,
   out of this Mini's scope); are any tests now offline only in name because the Chrome that draws is one of those?

## AC work (verifier)
Every AC's test by its plan name on head (pass) and on old code (a `git archive` of 392f67e2 with head's test files; fail on its own
assertion) or a one-line mutant; AC2 on the base only under the sink wrapper. A terminal capture per AC. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/verifier/ac.json` and logs there (create it; check it is empty);
self-check with `ac-check.sh` on a copy (`--base 392f67e2…`, no `--reviews`). Gates: both typechecks, `npm run check` (8G).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/review-1/review.json` (round 1, scope full from
`392f67e2a6b52c40a64acaf7d344a50c934dee26`, full SHA `head`), in the format `review-check.sh` reads (see a recent example:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-4/review.json`); self-check with
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
392f67e2a6b52c40a64acaf7d344a50c934dee26 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline` and quote its last line.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/stor/t1`); scripts under `~/.cache/stor/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill -f` with a pattern in
your own command line; a `user-data-dir=` pattern ends in `/`); before each Chrome suite check `/proc/loadavg`; one Chrome suite at a time
under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH";
…'` (B-Dry files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`). Foreground
Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/
"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write summaries as
.txt/.json.

## Report (as text; only review.json, ac.json and logs are written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; per AC: head, old code or mutant, evidence; gates; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
