# BRING MAIN IN 1 — 86bccndx6 custom company domain

Role: fixer that brings the updated `main` into the story branch. Justin said on 2026-11-08: "ok main is updated do your routine and all make sure it is all good". That is his OK to merge main into this branch, locally only. Don't push, open PRs, post to ClickUp, or touch Scaleway or any cloud account. No nested agents.

## Load these skills first
`leorna` (its "bring main in" / merge-tree guidance in `SKILL.md`, around the paragraph starting "`git merge-tree --write-tree --name-only HEAD origin/main` exits 0", is your procedure; skip the Step 1 context load beyond what you need), `engineering-best-practices`, `git-commit-rules`, `api-contract-drift-guard` (the OpenAPI spec and the generated contracts conflict), `backend-data-migrations` if migrations collide. Follow the repo's `AGENTS.md`.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `9c6f2b2bc6965cc1627f5445fe4bc3dde85d3ffa` (clean), story base `3aa979df41568c9039007f66d7f32193e66a8533`.
- `main` = `origin/main` = `f0a326b` (Merge PR #112), already fetched; the main checkout's local `main` already equals it. 33 commits since the story base.
- Files both sides changed (expect conflicts): `README.md`, `cmd/control-plane/main.go`, `contracts/control-plane.openapi.yaml`, `delivery/stories.json`, `internal/config/runtime_test.go`, `internal/web/README.md`, `internal/web/handler.go`, `packages/contracts/controlplane.gen.go`.
- Approved plan (AC1–AC6): `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Don't change ACs.
- Your evidence goes in `~/.hermes/plans/leorna/evidence/86bccndx6/bring-main-1/`.

## Do
1. Check `git rev-parse origin/main` is still `f0a326b…`. If main has moved again, use the new tip and say so.
2. `git merge origin/main` on the branch (a merge commit, `merge(86bccndx6): bring main f0a326b into custom company domain`; no rebase, no author overrides, no AI co-author lines, never stage CLAUDE.md). Resolve each conflict keeping both sides' meaning: `delivery/stories.json` as the skill says (main's file unchanged, this story's entry appended last as text); regenerate `packages/contracts/controlplane.gen.go` from the merged spec with the repo's generator rather than hand-merging it; check for a duplicated migration number.
3. Prove the merge as the skill says: one-side files equal that side's blob, the story's own patch survived, no file changed that neither side touched, and list each hand-resolved file with what you chose and why. Check whether anything main brought in (e.g. a new route, a Host/Origin rule, the release pipeline, integrations catalog) interacts with the custom-domain code: `requireClient` host binding, `/.well-known/leorna`, the generated-host redirect, `LEORNA_PUBLIC_BASE_URL`.
4. If a conflict needs a real product decision (not mechanics), stop and report it instead of guessing.

## Gates on the merged head
Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the AC1–AC6 tests by name (AC4 stays skip-gated), the DB packages against a Postgres/ClickHouse test container, `make check` (`make audit` failed on the old base with GO-2026-6865; say whether main fixed it), `make secrets library-check build`, and gitleaks over the hand-resolved files from the merged tree. This is the Windows desktop (WSL): run heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G is fine for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a test result. Remove any containers you start.

## Report
- New head SHA, the merge's two parents, `git status --porcelain` (must be clean), the hand-resolved files with your choices, the merge proofs, gate results with output tails, and anything main changed that a reviewer should look at.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
