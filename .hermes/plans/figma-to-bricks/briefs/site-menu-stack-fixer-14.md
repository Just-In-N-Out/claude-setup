# Role: stack fixer (stack 14: move site-menu onto main Build 2026-11-11.1 and make the launch join by hand)

You are a fresh fixer (**Opus 5.5, high**). site-menu is review-clean (review 9: MOVE ON) at
`058ec3ea04203d4793e862b1f882c7a1fdbb7695` (branch `site-menu-fix7`) on main `11e885fda5d08863a5875f939085350c007ac732`.
Main has moved: site-one-command merged as Build 2026-11-11.1, local `main` = `3f4a0718d974ec66167ce788ed3fe2672df9feb6`.
Move the job onto it, make the join the two plans name, prove nothing was lost, and stop at `ready-for-review` (a
rebase that resolves conflicts — and this join — is reviewed before the job is verified).

Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't
bump `BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com, B-Dry staging or any live site
(local fixture servers and the offline B-Dry stand-in only); no logins; never write to any WordPress site; never run
`npm run site:upload` or `npm run site:import` against anything but the tests' own 127.0.0.1 stand-in. Nothing may
hide that the importer's Chrome is automated. Justin may be running his own Chrome: never stop a Chrome you didn't
start; touch nothing under `~/Downloads`.

**Skills:** `git-commit-rules`, `engineering-best-practices`, `test-driven-development`, `receiving-code-review`; read
the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge into
main", the stacking lines: patch-ids with `--full-index`, context-only conflicts, "a clean textual resolution can still
lose the join", "when main's side of a conflict is 'this code moved to a new file', taking main's hunk drops the job's
change: port it into the moved file") with `references/testing-pitfalls.md` and `references/live-site-reading.md`
("Holding a Chrome to read-only").

## What main changed that meets this job
site-one-command (`git diff 11e885fd 3f4a0718`): `tools/capture.ts` no longer launches Chrome itself — it calls
`captureRun(chrome, …)` from a **new file** `tools/lib/capture-run.ts`, which holds the one launch line
(`launchChrome({ path: chrome.path, args: chrome.args, visible })`) shared with the new `tools/site-import.ts`;
`tools/lib/capture-pages.ts` gained the command's shared page loop; `test/unit/capture-chrome.test.ts`'s case "npm run
capture launches the Chrome findChrome finds and prints the helper's line when it finds none (amendment 2)" was
rewritten to pin `capture-run.ts`'s launch and `doesNotMatch(/launch\w*Chrome\(/)` for both commands;
`tools/lib/site-upload/` was refactored (`site-upload.ts`'s body moved into `flow.ts`; `ask.ts` gained the fresh
drop; this job changes only `pictures.ts` there). This job: one launch for every Chrome a capture starts,
`launchCaptureChrome` in `src/web/capture.ts` (it starts the socket gate), with `tools/capture.ts`,
`tools/capture-serve.ts` and the capture's own launch calling it, and its own version of the same `capture-chrome`
case pinning `launchCaptureChrome` in `tools/capture.ts`.

## Your copy (you start in your own worktree)
`git checkout -B site-menu-stack14 058ec3ea04203d4793e862b1f882c7a1fdbb7695` then `git rebase --onto main
11e885fda5d08863a5875f939085350c007ac732` (check `git rev-parse main` = `3f4a0718…`; if main moved again, use it and
say so).

## The join (the approved plan's "Overlaps with unmerged jobs", the site-one-command bullet; read it first:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/plan-approved.md`)
- `tools/capture.ts`: take main's `captureRun` shape; it launches nothing itself.
- **`tools/lib/capture-run.ts` (git shows no conflict here — the swap is by hand):** import `launchCaptureChrome` from
  `../../src/web/capture.ts` and call `launchCaptureChrome({ path: chrome.path, args: chrome.args, visible })` exactly
  once, in place of `launchChrome(…)`; keep everything else main has there.
- `tools/site-import.ts`: calls only `captureRun` (unchanged from main).
- `tools/capture-serve.ts` keeps this job's own `launchCaptureChrome` call.
- `test/unit/capture-chrome.test.ts`: keep main's case under its unchanged title; its `capture-run.ts` assertion names
  `launchCaptureChrome\(\{ path: chrome\.path, args: chrome\.args, visible \}\)`, plus one assertion that
  `capture-run.ts` imports `launchCaptureChrome` from `../../src/web/capture.ts`; keep main's `doesNotMatch` for both
  commands and its missing-Chrome lines.
- Put the join in its own commit after the rebase (the rebase's resolutions keep both sides' meaning; the join itself
  is a change of this job's, test first: the case's new assertions fail on the plain rebased tree, then pass).
- **Check after the join:** `git grep -n -E 'launch(Capture)?Chrome\(' -- tools/capture.ts tools/site-import.ts`
  prints nothing; `git grep -c 'launchCaptureChrome(' -- tools/lib/capture-run.ts` prints `tools/lib/capture-run.ts:1`.
- **Prove the gate reaches both commands:** a web test (or this job's existing socket test extended, under its
  unchanged name or a new supporting one) where a press opens a socket during `npm run capture` **and** during `npm
  run site:import` against the 127.0.0.1 stand-in with a made-up password: 0 handshakes at the server in both. A
  mutant that puts `launchChrome` back in `capture-run.ts` fails it.
- Anything else conflicting: keep both sides' meaning; HANDOFF: this job's section first, then main's lines exactly as
  main has them (the `<site-menu id at merge>` placeholders stay); `tools/lib/site-upload/pictures.ts`: this job's
  `uploadList` change on main's refactored module (check main's `flow.ts` still calls it as before).

## Proofs
- `git range-diff 11e885fd..058ec3ea 3f4a0718..<rebased head before the join commit>`; patch-ids commit by commit
  (`git show --full-index <c> | git patch-id --stable`; for a context-only conflict the `-U0` patch-id); for each
  conflicted commit, the +/- lines per file compared and each resolution saved under `resolutions/`.
- `git diff -U0 058ec3ea <rebased head before the join>` equals `git diff -U0 11e885fd 3f4a0718` after dropping
  `^(index |@@ )` lines, except the conflicted files (listed, each explained).
- **Where the sides meet:** site-one-command's AC tests on the joined head (every `site-import-*` web file and its unit
  files, `capture-cli`, `human-check`; its AC11 story pin with `F2B_STORY_PINS=1`, `F2B_BASE_TREE` = a `git archive`
  of `3f4a0718`: `capture`'s and `site:upload`'s printed bytes must equal main's where this job doesn't change them by
  design — if a byte moves by this job's design (a note of the press guard), prove it by four trees and record it);
  this job's AC tests and socket/press tests (`socket-gate`, `web-press-guard`, `press-guard-sockets`,
  `capture-opens-guards`, `capture-opens`, `site-opens-proof`, `site-upload-opens`, `site-opens-own-pictures`,
  `site-made-in-open`).

## Gates (light; the verifier runs the full ones)
On a `git archive` scratch copy of the joined head: both typechecks and `npm run check` (8G scope); the files above,
each web file alone under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` (export variables first; no
`--setenv=PATH`); `test/unit/plugin-convert.test.ts`. Each log starts `HEAD=` and ends with one line `EXIT=`. Known
flakes (F6-5 in `capture-opens-guards`' service-worker cases; `site-upload-cli`/`site-upload-stop` timing tests under
load): rerun alone before judging.

## Records and commits
The ledger (`docs/plans/2026-11-09-site-menu-ledger.md`: "Stack 14": each conflict and its resolution, the join, the
proofs, the gates) as the branch's last commit. Commits: plain `git commit -m` (or `-F <file>`), no author override,
no AI or Co-Authored-By lines, `git diff --cached --name-only` without CLAUDE.md. Evidence in
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-menu/stack-14/` (`range-diff.txt`, `patch-ids.txt`,
`conflicts.md`, `resolutions/`, `join/`, `meet/`, `logs/`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sm14/t1`; a
Chrome profile under a long TMPDIR dies with "Socket path too long");
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (stop it by the PIDs
of its own profile path; never `pkill -f <pattern>`). A worktree's `node_modules` may lack `.bin`, and a `git archive`
scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
PATH and symlink the main folder's `node_modules` in; a piped, chained or redirected git command, a heredoc or a shell
function may be refused: write such steps to a script file with Write and run `bash <file>`; `git -C <absolute
path>`). Use `tail -n 3`, never `tail -3`. Never edit a tree a test is running against. Scripts under
`~/.cache/site-menu-stack14/`. SIGTERM / 143 / 137 may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
short-iso | grep sending`). Waits under 115 s. The PC restarted three times this week: write each log's `EXIT=` line;
after a restart check `git status` and `git cat-file -t HEAD`, read your finished logs first.

## Report (as text)
`status: ready-for-review`, branch, the new HEAD (full SHA), its base (full SHA), the conflicts and resolutions commit
by commit, the join commit and its proofs (the two greps, the case, the gate reaching both commands, the mutant),
where the sides meet, each gate's result, `found_else`, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
