# POST-MERGE VERIFIER — 86bccndx6 custom company domain, on main d9c6aa8

Role: fresh, read-only AC verifier. You never saw the build. 86bccndx6 merged into main in PR #115 (`dadba89`, 2026-11-09 00:56 UTC). Since then main moved 25 commits to `d9c6aa8e7f8afb2d4dbbc1946dba467d50f7be08` (PRs #116–#120). Justin asked on 2026-11-09: "rerun AC and verification as branch moved". Prove every AC of the approved plan **on current main** and check that nothing merged since broke the story. Don't edit product code or tests, commit, push, open PRs, post to ClickUp, or touch Scaleway, DNS or any cloud account. No nested agents.

## Pins
- Head: `main` = `origin/main` = `d9c6aa8e7f8afb2d4dbbc1946dba467d50f7be08`. Old code (base): `9fce72dee016b21e3d8db50225ca6aeccd542fc1` (main just before the story merged; the story's last reviewed head was `e6ea3d7`).
- Make your own detached checkout: `git -C /home/justin/Leorna/leorna-control-plane worktree add --detach ~/.cache/86bccndx6-postmerge-verifier/wt d9c6aa8` (and an archive or second detached checkout of `9fce72d` for base runs). Remove both with `git worktree remove` at the end. Never use or change the main checkout's files or the old story worktree.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (AC1–AC6; AC4 is `(live)`).
- Your folder: `~/.hermes/plans/leorna/evidence/86bccndx6/postmerge-d9c6aa8/verifier/` (new); record `…/verifier/ac.json`. Scratch: `~/.cache/86bccndx6-postmerge-verifier/`.
- Context only, not your proof: the pre-merge records `verifier/ac.json` (verifier 6) and `auditor/ac.json` (auditor 4) on e6ea3d7, `ac-check-e6ea3d7.txt`, `follow-ups.md`, and their mutant folders (re-apply those mutants against d9c6aa8 by rebuilding them from their diffs).

## Load these skills and references first
`leorna`, `engineering-best-practices`, `adversarial-verification-loop`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `mutation-testing-discipline`. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full (ac.json format, base runs, screenshots, self-check). Follow the repo's `AGENTS.md`.

## ACs (exact named tests)
AC1 `TestCustomDomainRegistrationShowsCNAME`, AC2 `TestCustomDomainActivationPreservesGeneratedAccess`, AC3 `TestCustomDomainFailureKeepsGeneratedAccess`, AC4 (live) `TestCustomDomainLiveClientDiscovery` (no live target or grant exists: `not_run` with a true live reason; the local rehearsal in `rehearsal/` is supporting only, never a pass), AC5 `TestCustomDomainGuardsAndRetry`, AC6 `TestCustomDomainResumeAndRecovery`.
For each: run it on d9c6aa8 (receipt starts `HEAD=<sha>`, keeps the test's own output and true exit) and on base 9fce72d with the head's test-only files (types-only new-package file plus base-behaviour shims as `ac-verification.md` says, so it fails on its own line); read every assertion against its clause (`git log -p 9fce72d..d9c6aa8 -- <AC test files>`: check no later PR narrowed or rewrote them); take your own screenshots (real UI, or a rendered log for non-visual ACs; real PNGs).

## What changed since the merge (check each against the story)
`git log --oneline dadba89..d9c6aa8` and `git diff dadba89 d9c6aa8 -- internal/installer internal/launcher cmd/launcher internal/web`:
- #118 (86bd0dtjd) reuse Scaleway IAM keys instead of minting each run (`internal/launcher/reusekey.go`, `resume.go`, `internal/cloud/scaleway`): does resume still preserve a verified custom domain, and does `VerifyConfiguredPair`/the domain manager still get the right project-scoped credentials?
- #120 (86bd0e9kx) installer reuses existing Scaleway databases: does `redeployExisting`/resume keep the story's custom/generated URL pair and the old-server check?
- #119 (86bcm9284) predefined integration tiles, incl. `9b61ff0 fix: serve the tiles test's desktop API on its canonical host` and new `internal/web/predefined_tiles_test.go`: does anything weaken `requireClient`'s host binding, `/.well-known/leorna`, or the generated-host redirect?
- #116/#117 (86bcryh0w managed config drift): any interaction with the story's routes or env.
Probe any real interaction with an overlay mutant (wrong host / dropped URL pair → the relevant test must fail). Re-apply the earlier verifier/auditor mutants against d9c6aa8 and compare outcomes with verifier 6's (`verifier/mutants/`) and auditor 4's (`auditor/mutants/`).

## Gates on d9c6aa8
Focused packages (`./internal/installer/... ./internal/launcher/... ./cmd/launcher/... ./internal/web/...`), the DB packages via `go test -json` with per-test skip accounting (own Postgres `_test` DB, wait with `docker exec <c> pg_isready -h 127.0.0.1`; ClickHouse with CI's service env from `.github/workflows/ci.yml`), the unchanged `make check` with CI's linter and govulncheck bound by absolute path (`tofu` on PATH: check `command -v tofu`, copy an existing `~/.cache/*/bin/tofu` if downloads are refused, confirm `--- PASS` not SKIP; GitHub and the OpenTofu registry answering first), `make secrets library-check build`, `python3 -m unittest scripts/test_release.py`, `bash ./scripts/test-module-add.sh` (in your own checkout, serially). main's push CI on d9c6aa8 is supporting only (`gh run list --branch main`).

## Environment
WSL desktop: heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for `-race`); export env vars, never `--setenv`. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading 137/143/"Killed" as a result. If Docker Desktop crashes, stop and report; never restart it or WSL. Don't touch `leorna-pg` or `ndx6-preview-*`; remove containers you start. Don't use `pkill -f`. Use `tail -n N`.

## Report
- `verdict` (clean / not clean / environment-blocked) and `ac_status` per AC, matching `ac.json`, with head log, base log and screenshot each.
- What #116–#120 changed that touches the story, and the probe results; any genuine source finding (P0–P3, file:line, real-use scenario) separate from environment limits.
- Gate results with commands and output tails.
- Run your own `ac-check.sh` self-check on a copy (without `--reviews`) and quote its last line.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons the skill doesn't already say (empty is normal). `enforce` is `none` or a one-line check proposal. Never edit skills or lessons yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
