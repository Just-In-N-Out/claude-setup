# Role: reviewer round 2 + verifier AC work (Mini; report only): site-tests-offline

You are a fresh reviewer who never saw the build or the fixes (**Opus 5.5, high**). This round reviews the job on its new base (it was
rebased onto main) and does the verifier's AC work
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`). Change no source or test, commit nothing, start no
agents. Plain `git` in your own worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive
-o <absolute path> <sha>`, extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). **Never load any live site:**
run any test that draws Justin's scan or the B-Dry stand-in only on the head (offline) or inside a no-network namespace (`unshare -rn sh -c
'ip link set lo up && ip link add d0 type dummy && ip addr add 10.255.0.2/24 dev d0 && ip link set d0 up && ip route add unreachable default
&& exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`), base runs also under the job's sink wrapper (`test/web/offline/sink.ts`);
never write to any WordPress site; touch nothing under `~/Downloads`. Load `requesting-code-review`, `code-review-practice`,
`mutation-testing-discipline`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with
`references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first. Don't read the builder's or fixer's reports or folders as
proof. P0–P2 only for what a real test run or agent hits; edge cases are P3. Keep it to about 60 minutes.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/plan-approved.md` (AC1–AC4, none live;
  Q1 ⭐ A every test file that draws a site paste or capture; Q2 ⭐ A `site-live-widget-bdry.test.ts` is the one kept exception).
- Head **`001f2a1a906504f1e06193eb143c265547e740a5`** (branch `site-tests-offline-fix1`), base **main `fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`**.
  `git checkout --detach 001f2a1a…`. Review `git diff fe29b65d...001f2a1a` (tests, test libs, HANDOFF, ledger, plan copy only; nothing under
  `src/` or `tools/`). Round 1 (`evidence/site-tests-offline/review-1/review.json`, on the pre-rebase head 4b8b7573) found R1-1 (captures
  download through Node's fetch, outside Chrome's rule), R1-2 (the guard missed helpers that launch Chrome for their callers), R1-3 (AC2
  could pass drawing nothing); the fixes add `offlineFetch` (`test/web/lib/offline-chrome.ts`), a guard that follows local imports and
  requires a fetcher on every capture call, AC2 launch counting, and the tally/sink fixes (new files listed as "new in this job, no base";
  the sink leaves `*.localhost` alone).

## Check hardest
1. **Nothing leaves the computer from a converted test:** `offlineFetch` refuses every non-loopback host before sending (redirects too);
   every `captureSite` / `captureFixture` call in a capturing test passes it (except a capture with a person check, which keeps the
   browser fetcher: is that offline?); the guard can't be dodged by a normal future test (a helper re-exported from a test lib, a capture
   call through a wrapper function, a dynamic import). Probe it yourself: a logging/refusing `globalThis.fetch` and Chrome under the sink on
   a sample of capturing files, 0 outside requests.
2. **No test lost its meaning:** the converted launches keep each test's own maps; tests whose result could change because a font or
   picture is now refused (compare base and head behind the same refusal on a sample, and AC4's tally yourself).
3. **The tally's new-file rule:** a file missing on head that the base has still fails; a base test name missing on head still fails.

## AC work (verifier)
Every AC's test by its plan name on head (pass) and on old code (a `git archive` of fe29b65d with head's test files copied in: fail on its own
assertion) or a one-line mutant; AC4's tally base vs head yourself (both in the namespace under the sink). A terminal capture per AC. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/verifier-2/ac.json` and logs there (create it; check it is empty);
self-check with `ac-check.sh` on a copy (`--base fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`, no `--reviews`). Gates: both typechecks, `npm run
check` (8G).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline/review-2/review.json` (round 2, scope full, `from`
`fe29b65d94da2c6f4e1ecb881354b9e9b9842cef`, full SHA `head`, a `note` that it is the full review on the rebased head), in review-1's format;
self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
fe29b65d94da2c6f4e1ecb881354b9e9b9842cef /home/justin/.hermes/plans/figma-to-bricks/evidence/site-tests-offline` and quote its last line.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/stor2/t1`); scripts under `~/.cache/stor2/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome you start by PID (never `pkill -f`/`pgrep -f` with a
pattern in your own command line; a `user-data-dir=` pattern ends in `/`); before each Chrome suite check `/proc/loadavg` (above ~40: unit
work first); one Chrome suite at a time under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …` outside the namespace (B-Dry
files 8G). An archive tree has no `node_modules/.bin` (a `tsc` wrapper first on PATH) and no repo (set `GIT_DIR`, and `F2B_SERVICES_FILE`).
Foreground Bash moves to the background after about 180 s: wait in bounded steps of 160 s or less from a script file. Use `tail -n 3`.
SIGTERM/143/137/"Killed": check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Write
summaries as .txt/.json.

## Report (as text; only review.json, ac.json and logs are written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; per AC: head, old code or mutant, evidence; gates; `verdict`;
`ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory; empty is normal), ending with: `MAIN SESSION:
check and save these skill_lessons now.`
