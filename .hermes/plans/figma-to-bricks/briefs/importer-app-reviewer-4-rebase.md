# Role: reviewer (round 4, DELTA review of the rebase onto main; report only): importer-app

You are a fresh reviewer (**Opus 5.5, high**). Review only: change nothing, commit nothing, start no agents. Plain `git` in your own
worktree, each command alone (never `git -C` the main folder; no git piped into another command: `git archive -o <absolute path> <sha>`,
extract separately; scripts with the Write tool, run as `bash <file>`, no heredocs). Never load any live site; no logins to any real site;
never write to any WordPress site; never call alttext.ai; touch nothing under `~/Downloads` (a test that clicks a download runs Chrome under a
scratch HOME: `chromeAtHome()`, or a copy of the `chrome-f2b` wrapper with absolute paths). **Importer rule:** P0–P2 only for bugs a real run
hits (a scenario and a measured number). Keep it to about 30 minutes. Load `requesting-code-review` and `code-review-practice`; read the
project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md`; read both
`repeat-mistakes.md` files first.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/plan-approved.md` (AC1–AC20; AC20 live).
- Accepted head `7ff5f664abec6005c5cd5b083c7bd2b06bf70c46` on base `7f54b0a59f88f3ca4404b6f14bba3b5abea9dcd8` (ac-check READY FOR THE USER,
  19 of 20). Rebased onto main `392f67e2a6b52c40a64acaf7d344a50c934dee26` as branch `importer-app-final`, head
  **`5848e82922256291b0b9d230094b9dc41850e217`**: 36 rebased commits (last `019465f0`; HANDOFF-only conflicts) plus two test-only commits:
  `7b602c5b` (pin `media-avif-untouched` allows this job's one `package.json` line) and `5848e829` (AC10 and AC16's tests: main's site-no-div
  now writes `structure.txt` and a first `Structure:` line in each part's `notes.txt`, which these tests had faked by hand).
- Finisher's records: `/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/rebase/` (`conflicts.txt`, `range-diff.txt`,
  `pins-*.log`, `receipt-5848e82.log`, `ac10-ac16-test-edit-mutants.log`, `ac18-*.log`, `gates-5848e82/`). A head start, not proof.

## Check
1. **Code identity:** `git merge-tree --write-tree 392f67e2 7ff5f664` diffed against `019465f0`: outside `docs/HANDOFF.md` nothing differs;
   HANDOFF from 392f67e2 deletes 0 lines and keeps both sides' sections word for word. Where `tools/lib/site-upload/flow.ts` and
   `tools/site-upload.ts` merged cleanly, main's `--svg` drawings and this job's marks and progress lines both hold (run
   `test/web/site-upload-icons.test.ts` and the app's upload test on the new head).
2. **`5848e829` keeps AC10's and AC16's meaning as the plan words them:** AC10's "a later job's file stays" and the planted stale
   `structure.txt` now equal to `npm run site`'s own; AC16's three cases (header first, footer last, body none) still tested against the real
   notes with their `Structure:` lines. Each test passes on the new head, fails on a one-line app mutant (try your own, not only the
   finisher's), and nothing an AC promised was dropped.
3. **`7b602c5b`:** allows exactly `git diff --name-status 392f67e2...HEAD -- <the pinned paths>` (`M package.json`, the one `importer` line);
   a stray file and a one-byte change elsewhere still fail it.
4. **AC18 flake:** the job's title below the window after Scan under load (`{"top":1003,…,"window":900}`, 3 of 4 full runs). Is it a real UI
   bug a person hits (the panel scrolled into view once at `page/job.ts:81`, content above it growing after) or only test timing? Measure it;
   a real one is P2 with the scenario.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app/review-4/review.json` (round 4, scope delta, `from`
`7ff5f664abec6005c5cd5b083c7bd2b06bf70c46`, full SHA `head`, a `note` saying it reviews the rebase and its two test commits), in review-3's
format; self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
392f67e2a6b52c40a64acaf7d344a50c934dee26 /home/justin/.hermes/plans/figma-to-bricks/evidence/importer-app` and quote its last line; if it asks
for another scope, say so. Your worktree at `git checkout --detach 5848e82922256291b0b9d230094b9dc41850e217`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/iar4/t1`); scripts under `~/.cache/iar4/s/`;
**`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`**; close every Chrome and app process you start by PID (never `pkill -f`
with a pattern in your own command line; a `user-data-dir=` pattern ends in `/`); before each Chrome suite check `/proc/loadavg`; one Chrome
suite at a time under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 /bin/bash -c 'export
PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; …'`. Foreground Bash moves to the background after about 180 s: wait in bounded steps of
160 s or less from a script file. Use `tail -n 3`. SIGTERM/143/137/"Killed": check earlyoom's log first. Write summaries as .txt/.json.

## Report (as text; only review.json is written)
Findings one line each (id, P0–P3, file:line, scenario, measured) or "none"; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
