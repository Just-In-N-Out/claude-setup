# FIXER brief (bring main in, round 3): 86bcm928e custom integrations (Leorna, leorna-control-plane)

**Role:** FIXER (a fresh general-purpose agent, Opus 5.5 high): bring GitHub main into the PR branch so PR #129 is no longer BEHIND, and prove the story still holds on the merged head. Stop at `ready-for-next-review`. **No push** (a fresh delta review comes first; the main session pushes), no PR edit, no ClickUp write. Start no agents.

## State
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, head `31d007e577e922963ab3a669cd1bf5b60f085405` (pushed; PR #129 open, `mergeStateStatus: BEHIND`). Previous main `d3e7391…`; ALL ACCEPTED on `57b7e9b`; `31d007e` is the reviewed PR-number record commit.
- GitHub main is now `659b832a5ed10d0318c49f7f34c2c61425be2b16` (#127, v0.2.0 release notes: `.github/release-notes/v0.2.0.md`, `README.md`, `docs/deploy/release-pipeline.md`, `scripts/release.py`, `scripts/test_release.py`). `origin/main` is fetched; `git merge-tree --write-tree --name-only HEAD origin/main` printed tree `2ccf5f8940649aab4a9ef9184fc603c7581aaa10` with no conflicts. Check it yourself; if main moved again, use the new tip and say so.
- Siblings still open: #128 (client self-update) and #113, so main may move again; per Justin's standing rule, this bring-in gets gates + AC tests by name and a delta review, not a new verifier/auditor.
- Plan (read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`. Evidence folder: `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/bring-main-3/` (create it). Scratch `~/.cache/928e-bring-main-3/` (`mkdir` without `-p`).

## Skills (say so in one line)
`leorna` (step 7: bring-in checks for a conflict-free merge; release notes: grep #127's `v0.2.0.md` and README for anything this story's merge makes stale or should be listed in — report, don't edit main's notes), `engineering-best-practices`, `git-commit-rules`. Read `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## What to do
1. Fetch main over HTTPS through gh (URL written out); `git merge` it (never rebase). If anything conflicts, stop and report. Commit `merge: bring main (<short sha>) into feat/86bcm928e-custom-integrations`; plain `git commit`, no author flags, no AI attribution lines.
2. Prove the merge is git's clean result: `git merge-tree --write-tree <parent1> <parent2>` equals `<merge>^{tree}`; no duplicate migration version; `gitleaks git <main>..HEAD`.
3. Gates on the merged head with **Go 1.27.4** (`~/.local/leorna-toolchain/go1.27.4/bin` first on PATH, then `~/.local/leorna-toolchain/bin`), serially, in a detached copy, own Postgres (`928e-bm3-pg`, `--memory 1g`, `mirror.gcr.io/library/postgres:18.6-alpine3.23`, db ending `_test`, bounded `docker exec … pg_isready -h 127.0.0.1` wait), removed at the end: `make check` (rerun on a load-only `internal/web` 10-minute timeout before judging), `test-module-add`, `python3 -m unittest scripts/test_release.py` (main changed it), `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, Postgres no-skip `-timeout 1800s`, no-DB `go test ./internal/web/ ./cmd/control-plane/`, authors on branch-only commits, attribution lines. One `label EXIT=<rc>` line each into `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/gates-<sha7>.txt`, rendered as `gates-<sha7>.png`.
4. AC1–AC3 by name on the merged head into `bring-main-3/ac<n>-<sha7>.log` (first line `HEAD=`, last `EXIT=`).
5. Leave the worktree clean.

## Rules
- Never push, rebase, force or run `git worktree prune`; remove your detached copies with `git worktree remove --force <path>`.
- earlyoom: for SIGTERM/143/137/"Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Never run your own tests alongside `make check`.
- Don't end your turn to wait for a background command; foreground polls under 170 s.
- Other bugs: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section; never edit skills or memory. An empty list is normal.

## Report
`{status: ready-for-next-review|stopped, main_sha, merge_sha, new_head, merge_proofs{tree_equal, dup_check, gitleaks}, release_notes_check, gates[{label, exit}], ac_tests[{ac, test, log, result}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
