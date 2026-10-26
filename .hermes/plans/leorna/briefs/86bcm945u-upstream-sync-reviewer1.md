# REVIEWER 1 brief (review only): Leorna story 86bcm945u "upstream-sync" (Full pipeline)

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent that has never seen this code or build. First of two full reviews (`review-fix-cadence`: review 1 → fixer → review 2 of the corrected code → fixer → verifier).

## Your role

You are the first independent **REVIEWER** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". **Report only:** change no source, make no commit, push nothing. Restore anything you touch. Leave the builder's worktree exactly as you found it: committed and clean, no untracked files (a later script fails on any).

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna` (its review rules and hard rules).
2. `engineering-best-practices`.
3. `requesting-code-review` and `code-review-practice`. **Skip** `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you *are* the fresh reviewer, and you can't spawn agents.
4. `mutation-testing-discipline` (your mutation checks).
5. `security-best-practices` (third-party content read from the network; git subprocesses; an HTML admin page) and `multi-tenant-auth-management` (the admin-only page).

## What to review

- Repo: `~/Leorna/leorna-control-plane`, branch `feat/86bcm945u-upstream-sync`
- Builder's worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync`
- **Base** `6e74ced843642439d1dac9f25673440fb0f285f5` (merge-base with origin/main). **Head** `9e31271d8ae8a242c7a802a1e34135a256e6eeb0`. 15 commits, 36 files.
- Review `git diff 6e74ced..9e31271` (the whole story) against:
  - the approved plan `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md` (read-only; its ACs AC1–AC7, Justin's answers, tasks, Gates, Definition of Done);
  - the `leorna` skill's rules and the repo's `AGENTS.md`.
- **Run the gates yourself and try mutations. Don't trust summaries**, including the builder's notes below. Do your runs in your own detached worktree at head (e.g. `git -C ~/Leorna/leorna-control-plane worktree add --detach ~/.hermes/cache/scratch/86bcm945u-review1/head 9e31271`), with your own Postgres database whose name ends in `_test`. Remove that worktree when you're done. Never share or drop another agent's database.
- Gates: `make check` (bind CI's golangci-lint version by absolute path, as the `leorna` skill says), `bash ./scripts/test-module-add.sh`, and each AC's own command from the plan, including AC2 with `LEORNA_TEST_DATABASE_URL` and AC7 with `LEORNA_TEST_UPSTREAM_NETWORK=1` (a skipped AC test counts as not run).

### Look hard at

- **Untrusted upstream:** git invocation (argument lists, `--end-of-options`, the protocol allowlist, environment scrubbing), path traversal and name guards on import/accept, symlinks, size and entry caps, refusing unknown formats.
- **Never overwriting Leorna adaptations:** the `diff` / `import` / `accept` behaviour, the version bump, `content.lock.json` and checksum stability (the 8 shipped checksums must not change).
- **The admin page:** admin-only (member → 403, signed out → sign-in), output escaping, no data from other tenants, wiring in `cmd/control-plane/main.go`.
- **Notices and installer:** `THIRD_PARTY_NOTICES.md` matches the embedded record; the Windows launcher really carries the notice; `--notices` works.
- **Tests:** each AC's test is real, named as the plan says, fails on base and passes on head. Happy path plus at least one failure case per the Definition of Done. Mutations of the guards are killed.
- **Evidence:** the builder's folder `~/.hermes/plans/leorna/evidence/86bcm945u/` has one screenshot per AC (see `INVENTORY.md`). Check each one shows what it claims, comes from head `9e31271`, and shows no server domain, real host in a URL bar, tenant ID, token, email or password. Read its gate logs' exit codes. Don't edit these files.
- **Scope:** no `.github/` change, no OpenAPI change, no migration, nothing outside the plan's files unless a ruling explains it.

### The builder's rulings ("My ruling, not yet confirmed"): judge each

1. The transform signature is `Transform(kind, name, raw)`, because the plan requires the skill-name-equals-folder check but its signature had no folder parameter.
2. AC2's main screenshot is the built control-plane binary in dev mode on 127.0.0.1, with a throwaway `_test` database, opened through `/dev/login`. The plan's handler-response rendering is kept as a fixture shot plus `.html` files. In dev mode a signed-out visit goes to `/dev/login`; the production redirect is proven by the AC2 test.
3. It added `ac2/ac3/ac4-test-run.png` terminal captures alongside the plan's UI and demo shots.
4. Hardening the plan didn't ask for: the report quotes upstream paths with control characters or whitespace (with a test), and git subprocesses drop `GIT_DIR` and the other repository-location variables.
5. Three behaviours the plan left open:
   - `accept` refuses a skill root that now has supporting files, matching `import`;
   - `accept` refuses an item whose source names a different upstream;
   - `diff` shows one row per tracked item, so two items imported from the same path both appear.
6. Symlink skipping is tested with a `parseTree` unit test and a real symlink in the git test, not in `TestRootsGroupUpstreamPaths` (Tree has no file mode).
7. The AC3/AC4 demos build the tool from head and run it from scratch.
8. The builder's own note: `write.go` and its unit tests landed in the same step, not test-first. Its mutation M8-v2 is meant to prove the containment test can fail.

### Already known (don't re-report as new)

Missing server Go-module licences in `THIRD_PARTY_NOTICES.md`; library items copied into tenant packs lose source and licence; the card's typos (`scripts/skill-lint.js`, `v0.6.13`); the installer version picking up a `portal-dist-*` tag (`scripts/dist.sh`); `cmd/launcher/README.md` not mentioning `--notices`. Mark one only if this story made it worse.

## Where you write

Only in `~/.hermes/plans/leorna/evidence/86bcm945u/review1/` (logs, mutation receipts, your report as `review1.md`) and your scratch folder. Nothing in the repo.

## Rules

- Write nothing to ClickUp, push nothing, touch no server. Never put a server domain, URL, tenant ID or token in your report.
- **Other problems outside this story:** list each in `found_else` (one line, evidence, severity), not as findings.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

- `verdict`: `clean` or `findings`
- `findings[{id, severity: critical|major|minor|nit, introduced: true|false, claim, evidence (file:line, command and output)}]`
- `ac_status[{ac, accepted: true|false, test, screenshot, evidence}]` for AC1–AC7
- `rulings[{n, verdict: agree|disagree, why}]`
- `defect_loop_skills[]`, `found_else[]`, `skill_lessons[]`

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
