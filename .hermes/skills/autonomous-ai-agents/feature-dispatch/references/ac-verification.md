# AC verification: verifier, blind auditor, ac-check

Justin, 2026-10-23: the orchestrator confirms every acceptance criterion (AC) is met before the finish step, without doing a lot of work itself. Two independent agents prove each AC with receipts, and one script compares them. Applies to Full and Mini, every repo.

## Why

A single verifier can be wrong. Accepting an unmet AC ships a broken feature; rejecting a met one only costs a round, and the no-progress rule already catches that. Three layers close the dangerous direction:

1. **Receipts:** each accepted AC names its test, a log stamped with the commit it ran on, and a screenshot. The log must show that test's own pass line, with no fail or skip line for it.
2. **Old-code check:** the same test must fail on the base commit (or fail to build against it). A test that passes on both doesn't test the AC.
3. **Blind second opinion:** when the verifier says clean, a fresh AC auditor that never sees the verifier's report or receipts proves every AC again. Any disagreement means not accepted.

## At "go"

The orchestrator makes a read-only copy of the approved plan, which `ac-check.sh` reads from then on, so a later edit can't add ACs or `(live)` tags:

```
mkdir -p <evidence> && install -m 444 <plan> <evidence>/plan-approved.md
```

**AC ids are `AC1`, `AC2`…** (never `AC2a`). **`(live)`** marks an AC only Justin can check (live publish → Sync, a native menu). The planner writes it right after the AC id at the start of the AC's line: `- AC3 (live): …`, also `- AC3 (proposed) (live): …` or `- AC3 (live, proposed): …`. A `(live)` later in the text doesn't count. The plan message lists every live AC before **go**. Agents can't tag ACs live.

## Folders and the run recipe

- Evidence: Leorna `~/.hermes/plans/leorna/evidence/<clickup-id>/`; other projects `~/.hermes/plans/<project>/evidence/<name>/`. The verifier writes only in `<evidence>/verifier/`, the auditor only in `<evidence>/auditor/`. Every receipt a report cites must be inside its own folder, and the two folders never share a file (not even by a hard link). So the auditor takes its own screenshots and runs its own checks. Identical bytes alone don't mean a copy: headless Chrome renders the same static page byte-for-byte, so check the `com.apple.quarantine` xattr timestamp and mtime, not the hash.
- The worktree must be committed and clean: `ac-check.sh` fails any uncommitted or untracked file. Remove tool scratch, or have Justin add it to `.git/info/exclude`. Its check is plain `git status --porcelain`, so in a repo with `status.showUntrackedFiles=no` (the setup repo `~/.claude-setup.git` and its worktrees) it can't see untracked files: builders and verifiers there check `git status --porcelain --untracked-files=all` themselves.
- **The test command** runs only the AC's own test (one the approved plan names; `ac-check.sh` matches plan lines one by one, so a test name the plan wraps across two lines is rejected: planners keep each test name on one line, and an agent naming a script test picks a phrase that sits whole on one plan line) and prints its result by name: `go test -v -count=1 -run '^TestAC1$' ./...`, `node --test --test-name-pattern='^AC1 sorts rows$'` (TAP or spec), `pytest -v -k test_ac1`, `jest --verbose -t 'AC1 sorts rows'`, `bash x.test.sh ac1_name`. A bash test prints numbered TAP, `ok 1 - ac1_name`; the hook tests' unnumbered `ok   - desc` never matches, and the runner prints `not ok` when the test function returns non-zero, so a failed setup can't read as a pass. Any skipped or TODO test in the log, a subtest included, rejects it; for Leorna's Postgres tests, set `LEORNA_TEST_DATABASE_URL`.
- **Run it on head**, from the worktree:

  ```
  ( set -o pipefail; echo "HEAD=$(git -C <worktree> rev-parse HEAD)"; <command>; echo "EXIT=$?" ) > <folder>/ac<n>-<head7>.log 2>&1
  ```

- **Run it on the base commit** (`git -C <worktree> merge-base HEAD <integration branch>`: Leorna `origin/main`, local-merge projects `main`) in a separate copy, never in the builder's worktree, with head's versions of the test files:

  ```
  git -C <worktree> worktree add --detach <scratch>/base-<base7> <base>
  # one AC at a time: repeat these four lines for each AC
  git -C <scratch>/base-<base7> reset -q --hard && git -C <scratch>/base-<base7> clean -fdq
  git -C <scratch>/base-<base7> checkout <head sha> -- <this AC's test files>
  ln -sfn <worktree>/node_modules <scratch>/base-<base7>/node_modules    # JS repos only; -sfn because clean -fd keeps the link when node_modules is gitignored
  ( set -o pipefail; cd <scratch>/base-<base7> && echo "HEAD=$(git rev-parse HEAD)"; <command>; echo "EXIT=$?" ) > <folder>/ac<n>-base-<base7>.log 2>&1
  git -C <worktree> worktree remove --force <scratch>/base-<base7>
  ```

  The test must fail there: its own fail line, a crash or timeout after it started, or a build/import failure of the new code (Go `undefined:`, a missing new source file). **Go:** also copy the test files of every package the story creates that the AC test imports. Otherwise the import is missing and Go prints `[setup failed]`, which counts as never run; with them, it prints `[build failed]`. Copy only those: Go builds a package's test files together, so an extra sibling test that imports a new package turns a self-contained AC test's real `--- FAIL` into `[build failed]` (901u v3, 2026-10-24). A missing test file, a missing package, a setup failure or "command not found" means the test never ran, which doesn't count. A base failure (a build failure, or one clause's assertion: a "stays as drawn" AC can fail on base only through its must-change controls while its keep clauses pass trivially) proves the test is new, not that it checks every clause: for a clause the test seems not to exercise, swap the code it depends on with `go test -overlay '{"Replace":{"<abs src>":"<scratch mutated copy>"}}'` (read only) and confirm the AC test fails; if only another test catches it, say so in `found_else` (945u). An AC that keeps existing behaviour (its test rightly passes on base) gets `"base_exempt": "<the reason, 3+ words>"` instead.
- Screenshot per AC, a real PNG, JPEG, GIF or WebP: the real UI result, or a terminal capture of the run for an AC with nothing visual. Where no image tool exists (the WSL desktop has no PIL or ImageMagick), render the log in a `<pre>` page and screenshot it with the repo's Chrome driver. On the WSL desktop that is Chrome for Testing (`~/.cache/chrome-for-testing/chrome-linux64/chrome`) with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` and `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`: without `--disable-software-rasterizer`, `--screenshot` hangs (exit 124) and writes nothing (901a builder, 2026-10-28; the 901j planner saw the hang). With `DISPLAY`/`WAYLAND_DISPLAY` set (WSLg) it hangs even with that flag, `Page.captureScreenshot` included: run it under `env -u DISPLAY -u WAYLAND_DISPLAY` (harness-guards builder, 2026-10-28). With `--single-process` added it can segfault on exit (139) after writing: judge by the "N bytes written" line and the PNG magic `89504e47`, not the exit code (901j builder). A timed-out Chrome leaves child processes: kill only those with your own `--user-data-dir`.
- A `(live)` AC the agent can't run gets `"accepted": false, "not_run": "live: <why>"`. A live AC it ran and saw fail is plain `"accepted": false`, with no `not_run`, so it blocks.
- Report: `<folder>/ac.json`, in the format at the top of `scripts/ac-check.sh`. Before handing back, self-check it while staying blind: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh … <own ac.json> <scratch>/ac.json`, then delete the copy; it catches format, path, head and pass-line slips that would cost a NOT ACCEPTED round. Every agent of every role keeps all scratch in its own `<scratchpad>/<story>-<role>/` folder, created fresh (`mkdir` without `-p`, so it fails if the folder exists), and removes only that: the Claude Code scratchpad is shared by every subagent in the session, so common names (`base/`, `head/`, `run-ac3.sh`) collide, a parallel feature's agent can overwrite another's trees (photo-hotspots reviewer over headline-marker's `base/`/`head/`, 2026-10-28), and a blind auditor can see other roles' files (901v v3 merge auditor, 2026-10-24). Put this line in every brief.

## Steps

1. **VERIFIER** (existing role; source read-only): besides re-running the gates and confirming findings are closed, it does the AC work above in `<evidence>/verifier/` and writes `verifier/ac.json`. Its `verdict: clean` needs every AC accepted, `(live)` ACs marked `not_run` aside.
2. **Not clean** → the usual fixer → verifier round.
3. **Clean** → dispatch the **AC AUDITOR**: a fresh Opus 5.5 xhigh agent, source read-only. Give it only the approved plan copy, the worktree, the head SHA, the base commit and its own folder `<evidence>/auditor/`. Never give it the verifier's folder or report, the reviews or the builder's summary. It does the AC work on its own and writes `auditor/ac.json`. Skills: the project skill, `engineering-best-practices`.
4. **The orchestrator runs one command and reads its last line:**

   ```
   ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> \
     --base <base commit> --plan <evidence>/plan-approved.md <evidence>/verifier/ac.json <evidence>/auditor/ac.json
   ```

   - `ALL ACCEPTED …` → the finish step.
   - `READY FOR THE USER …` → the finish step; the hand-over names the live ACs owed to Justin.
   - `NOT ACCEPTED …` → a fixer gets the `NOT ACCEPTED` lines plus both reports; then verifier → auditor → ac-check again. No round cap.
   - The same AC is NOT ACCEPTED for the same reason twice with no new fact → ask Justin, quoting the two lines.
   - Exit 2 (bad usage or an unreadable report) → fix the command, or send the file back to the agent that wrote it.
5. **The orchestrator does nothing else here:** it doesn't open logs, rerun tests or judge ACs. That is the agents' and the script's work.

Tests for the script: `scripts/ac-check.test.sh` (fixtures follow real go, node, pytest and jest output).
