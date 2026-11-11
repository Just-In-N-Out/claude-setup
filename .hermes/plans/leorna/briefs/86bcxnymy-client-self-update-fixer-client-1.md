# FIXER brief: 86bcxnymy client, fix round 1

**Role:** FIXER for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout), Part 2: the client, after client review round 1. **Model:** Opus 5.5, effort high. You are a fresh agent.

## Where

- Client worktree: `~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update`, branch `feat/86bcxnymy-client-self-update`, head `74b60d648ce13af6781b29917eccec9a5f8d99d7`, base `a7839b3af664efcfa59eb1ed3fe276ec1262a4de`.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md` (Design D8–D10 for the engine, guard and worker).
- Review record and the reviewer's probes, mutants and logs: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/review-1/` (`review.json`, `probes/`, `mutants-*`). Builder 2's evidence: `.../builder/` (INVENTORY.md with its rulings).
- Control plane for the end-to-end ACs: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update` is being fixed and reviewed by other agents; treat it as read-only. Build the control-plane binary from **your own detached copy** of the current control-plane story head (`git -C ~/Leorna/leorna-control-plane rev-parse feat/86bcxnymy-client-self-update`, at writing `581cf77`; tests and README changes only since `2d640f1`, same contract) and record the head you used.
- **Stay in the client repo.** If a fix needs a control-plane change (a new report outcome, a contract field, an endpoint behaviour), stop and report with the options; don't edit the other repo.

## The referee's lines (summary; read each full entry in `review-1/review.json`): fix these four

```
R1-1  P2  selfupdate/guard.go:74   A release file whose own version stamp differs from the approved label installs again on every check: the guard calls the pending update "swap never finished" (74-78) or "stale" (79-81) and clears it with no block and no report, so the next check reinstalls and restarts. Probe: 6 installs in 6 cycles, 0 reports, no block. A file stamped `dev` leaves the client on a dev build that can never update itself.
R1-2  P2  selfupdate/updater.go:168  A download cut short because the app is closing is recorded as a real failure: a 1-hour block and a queued `download_failed` sent at the next launch.
R1-3  P2  desktop/selfupdate.go:232  The check runs 3 s after startup and, after `signed_out`, only every 5 minutes; nothing runs it when sign-in finishes, and tokens last one hour with no refresh (login/manager.go:213, 216-231). A sign-in-sync-close within 5 minutes never checks in; a queued `start_failed` report stays unsent.
R1-4  P2  selfupdate/state_test.go:106  TestStateFileSaveIsAtomicAndRoundTrips fails natively on Windows 3 of 3: `os.SameFile(before, after)` is true there after a rename-replace; SaveState itself is right. Fix the test, not the code.
REVIEW AGAIN: 4 P0-P2 finding(s) in review-1 at 74b60d6: fix them, then review again (Full: round 2 reviews the whole story from a7839b3; Mini: review the fix commits)
```

**R1-1 needs a choice.** Pick the fix that stays inside the client and the existing contract (`download_failed`, `install_failed`, `start_failed`, `checksum_mismatch` and whatever else the contract's outcome enum holds): for example, after the swap the client compares the new exe's own stamp with the target and, on a mismatch, rolls back, blocks that target and reports it with an existing outcome. Record it as "My ruling, not yet confirmed". If no existing outcome fits honestly, stop and report the options rather than inventing a contract value.

The P3s (R1-5 … R1-10) go to the follow-up list. You may fold in **R1-5** (tests for unpinned guards: Enabled only for stamped Windows release builds, `Jar = nil`, the 5-minute retry after `waiting`, update.js's `dev` fallback) and the **R1-10** README warning if they are small; leave R1-6, R1-7, R1-8 and R1-9 alone and say so.

## How to work

1. Load skills and say so: `leorna` (fix-pass role; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `authorized-write-safety`. A skill's "spawn a subagent" steps are run by the main session, not you.
2. Verify each finding yourself first (`receiving-code-review`), using the reviewer's probes. Push back with evidence if one is wrong.
3. Fix test-first: a failing test for each, then the fix. Keep AC1–AC7 green by name; AC3 and AC7 and the guard tests must stay meaningful. Mutation-prove the new guards (overlay under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; a no-mutation control first, setup failures INVALID, a test running its own nested `go build` on a disk copy; each run in a new folder under `.../client-fix-1/`).
4. **Run the whole `selfupdate` package natively on Windows** from its own folder (cgo-free: `CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go test -mod=vendor -c`, run through WSL interop), and the `desktop` package natively with cgo per `leorna` `references/gates.md`; zero `--- FAIL`.
5. Gates on your final head: client `make check` (short real `TMPDIR` at `~/.cache/86bcxnymy-cfx1/tmp`), `node --test scripts/*-ui.test.cjs` (keep `~/.local/bin` on PATH for node), `PYTHONDONTWRITEBYTECODE=1 python3 -m unittest scripts/test_release.py`, `make lint audit` (CI's golangci-lint), `GOOS=windows go vet ./selfupdate/`, the contract `cmp`, AC1–AC7 by name with `-v` against your control-plane binary. Known outside the story: `make audit` fails on base and head with GO-2026-6859 (attribute it on base). Postgres: `leorna-test-pg` with **your own databases named `*_test`**; never drop one you didn't create. Logs with real exit codes in `.../client-fix-1/`.
6. Commit as `fix(86bcxnymy): …`. Identity comes from `~/.gitconfig`'s includeIf; never override it, no AI attribution or session lines, never commit `CLAUDE.md`. No `.github/` change. Stop at `ready-for-next-review`: no push, PR, merge or post.
7. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- Never send a server domain, URL or tenant ID anywhere; never print tokens. Never write into Justin's real `~/.codex` or `~/.claude`; the client runs in a scratch HOME.
- Anything else you find: list it in `found_else` (one line each, with evidence and severity); don't fix it.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the cap above.

## Return

`{status: ready-for-next-review|stopped, summary, dispositions[{id, action: fixed|pushed-back|deferred, commit, evidence}], rulings[], worktree, last_commit, control_plane_head_used, contract_changed: false, ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
