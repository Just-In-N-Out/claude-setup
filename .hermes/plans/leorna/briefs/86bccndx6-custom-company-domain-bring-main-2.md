# BRING MAIN IN 2 — 86bccndx6 custom company domain

Role: fixer that brings the updated `main` into the story branch after the story reached `READY FOR THE USER` (`ac-check-44817ca.txt`). Justin said on 2026-11-08: "ok i want you to recheck real quick as main has moved". That is his OK to merge main into this branch and recheck, locally only. Don't push, open PRs, post to ClickUp, or touch Scaleway or any cloud account. No nested agents.

Per Justin's standing rule for a story that already passed the verifier, the blind auditor and `ac-check.sh` (memory note `leorna-no-reverify-while-main-moves`), this bring-in runs the gates and each AC test by name on the new head; no new verifier or auditor follows unless you find a real code conflict or an interaction with the story's code. If you do, stop and report it.

## Load these skills first
`leorna` (its "bring main in" / merge-tree guidance in `SKILL.md`, around the paragraph starting "`git merge-tree --write-tree --name-only HEAD origin/main` exits 0", is your procedure; skip the Step 1 context load beyond what you need), `engineering-best-practices`, `git-commit-rules`. Follow the repo's `AGENTS.md`.

## Where
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `44817ca1a5a10dd3f184f1550b7e131202ed31c6` (clean), current merge base `f0a326b83aae9d181e4f6681645685ae4b1fff91`.
- `main` = `origin/main` = `9fce72dee016b21e3d8db50225ca6aeccd542fc1` (Merge PR #114, 86bcm928t integration governance and usage; 5 commits since f0a326b), already fetched; the main checkout's local `main` was fast-forwarded to it.
- Main's merge-tree shows one conflict, `delivery/stories.json` (the usual append conflict). It's the only file both sides changed.
- Approved plan (AC1–AC6): `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Don't change ACs.
- Your evidence goes in `~/.hermes/plans/leorna/evidence/86bccndx6/bring-main-2/` (`bring-main-1/` shows the shape).

## Do
1. Check `git rev-parse origin/main` is still `9fce72d…`; if main moved again, use the new tip and say so.
2. `git merge origin/main` on the branch (commit `merge(86bccndx6): bring main 9fce72d into custom company domain`; no rebase, no author overrides, no AI co-author lines, never stage CLAUDE.md). Resolve `delivery/stories.json` as the skill says: main's file unchanged, this story's entry appended last as text, every earlier entry unchanged by value.
3. Prove the merge as the skill says (one-side files equal that side's blob, the story's own patch survived, no file outside the both-sides set differs from both parents, no duplicate migration numbers).
4. Check whether #114's code meets the story's: its new Content usage and integration-governance pages and routes under the generated-host redirect (`internal/web/custom_domain_browser.go`, GET-only, query dropped), `requireClient`'s host binding, `/.well-known/leorna` and `LEORNA_PUBLIC_BASE_URL`. If anything interacts, stop and report instead of guessing.

## Gates on the merged head
The AC1–AC6 tests by name (AC4 stays skip-gated), the focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the DB packages via `go test -json` with per-test skip accounting (own Postgres `_test` DB; the WSL desktop has no host `pg_isready`, so use `docker exec <container> pg_isready -h 127.0.0.1`; ClickHouse with CI's service env from `.github/workflows/ci.yml`), then the unchanged `make check` with CI's linter and govulncheck bound by absolute path, `make secrets library-check build`, `python3 -m unittest scripts/test_release.py` and `bash ./scripts/test-module-add.sh` (serially with make). `make check` needs `tofu` on your run's PATH (`TestGoldenHCLPassesTofuValidate` skips silently without it: check `command -v tofu`, confirm `--- PASS` with a verbose run), plus GitHub and the OpenTofu registry: curl `https://github.com/scaleway/terraform-provider-scaleway/releases/download/v2.91.0/terraform-provider-scaleway_2.91.0_SHA256SUMS` and `https://registry.opentofu.org/v1/providers/scaleway/scaleway/versions` for several clean 200s first. The machine is shared: under heavy load a single ClickHouse test can fail with "metric store unavailable"; rerun it alone under `-race`, then the unchanged gate, and report every run. This is the Windows desktop (WSL): heavy runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the full `-race` suite). If something dies with 137/143, SIGTERM or "Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first. If Docker Desktop crashes (`/var/run/docker.sock` gone), never restart it or WSL: report the Docker-backed gates as environment-blocked. Don't touch `leorna-pg` or `ndx6-preview-*`; remove containers you start. Don't use `pkill -f`.

## Report
- New head SHA, the merge's two parents, `git status --porcelain` (must be clean), how `stories.json` was resolved, the merge proofs, what #114 changed that touches the story (or "nothing"), gate results with output tails, `ac_status` per AC.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). This rule covers skills and lessons; never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
