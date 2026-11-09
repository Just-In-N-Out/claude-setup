# FINISHER (PR) — 86bccndx6 custom company domain: push, open the PR, post to ClickUp

Role: finisher for the publish step. Justin said on 2026-11-08: "yeah push and post clickup / create pr" (`<evidence>/finisher/justin-publish.json`). Per the `leorna` skill, each word authorizes only itself: **push** the branch, **make a PR** (push + open), **post** (the ClickUp comment plus attachments). All three are authorized. **Not** authorized: merging, closing or editing other PRs, changing the card's status unless the skill's PR step says so, or touching Scaleway/DNS/any cloud account. No nested agents.

## Load these skills first
`leorna` (Doing a story → step 7 "make a PR", its references `stop-and-show-diff.md`, `clickup-evidence.md`, `story-done-team-message.md`, and the Git/ClickUp/privacy rules), `git-commit-rules`, `github`, `engineering-best-practices`. Follow the repo's `AGENTS.md` and `~/.claude/CLAUDE.md` (Leorna pushes go through the Leorna account only: SSH alias `git@github-leorna:LeornaAI/leorna-control-plane.git`; if the key is locked, the HTTPS `gh` fallback written out in full; never `gh auth switch`, never change a remote or credential helper; if a push would go as `Just-In-N-Out`, stop).

## Pins
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain` (not yet on GitHub), accepted head `e6ea3d7f0ec1082be6330a2405835c637de5d6cb`, base `main` = `origin/main` = `9fce72dee016b21e3d8db50225ca6aeccd542fc1`.
- `ac-check-e6ea3d7.txt`: READY FOR THE USER, AC4 owed (live, no test domain; local rehearsal only, `rehearsal/`).
- Hand-over and drafts (finisher 3, for e6ea3d7): `<evidence>/handover.md`, `finisher/pr-description.md`, `finisher/clickup-evidence-draft.md`, `finisher/team-message.md`, `finisher/independent-review-prompt.md`. Evidence root `~/.hermes/plans/leorna/evidence/86bccndx6`.
- Open PR #113 (`feat/86bcx2a33-github-mcp-current`) touches `delivery/stories.json` and `internal/web/prompt_publish_test.go`, which this branch also changes.

## Do, in this order
1. **Freshness:** `git fetch` (Leorna account) and confirm `origin/main` is still `9fce72d` and the worktree is clean at `e6ea3d7`. If main moved, stop and report (don't bring it in).
2. **Gates on e6ea3d7, per the skill's step 7:** re-run the full gates, including the ones not yet run on this head: the docker image build, Trivy, Helm lint/template, the Windows cross-build. The unchanged `make check` (tofu on PATH, GitHub and the OpenTofu registry answering) passed on e6ea3d7 three times, in review-11, verifier 6 and auditor 4; rerun it only if the skill's step 7 requires it. Save every log in `<evidence>/pr/`. If a gate fails on the branch's code, stop and report before pushing.
3. **Update the delivery status text** only if the skill's PR step says the branch's `delivery/` records must say "in review" before the PR. Follow-up R/BM notes say `delivery/custom-company-domain.md:3` and `stories.json` still say review is pending. If that needs a commit, make it (`docs(86bccndx6): …`, Leorna identity, no AI trailer, never stage CLAUDE.md) and report the new head: the main session will then have it reviewed before the verifier step.
4. **Push** the branch through the Leorna account. Fetch back so `origin/feat/86bccndx6-custom-company-domain` matches.
5. **Open the PR** against `main` with `gh pr create`, using `finisher/pr-description.md` updated with the gate results from step 2 and the head each check ran on. AC4 must be named as owed (live, needs a test domain; local rehearsal passed, supporting only). End the PR description with the attribution line `🤖 Generated with [Claude Code](https://claude.com/claude-code)` unless the `leorna` skill says PRs carry no AI attribution, in which case follow the skill. Note PR #113's overlap in the PR's notes.
6. **Watch CI** on the PR to completion (the `github` skill). Report each check's result honestly. A failing check is reported with its log tail; don't change code to make it pass.
7. **Post to ClickUp** card 86bccndx6 as the skill's `clickup-evidence.md` says: the comment from `finisher/clickup-evidence-draft.md`, updated with the PR link and the CI results, plus the attachments it lists (only the verifier's and auditor's converted real PNGs and the rehearsal screenshot; never the AC tests' own JPEG-as-`.png` captures; nothing with a real server address, tenant ID, email or token). Check the connected ClickUp account is Justin's Leorna one first, as the skill says. Change the card's status only if the skill's PR step tells you to.
8. Update the dated 86bccndx6 status line in the shared `leorna-workflow.md` notes with the PR number and URL, as the skill says (this is allowed; the "never edit" rule below covers skill lessons only).

## Environment
This is the Windows desktop (WSL): heavy runs go under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (6G for the `-race` suite or image builds if needed); export env vars, never `--setenv` (logs echo the command line). Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading a 137/143/"Killed" as a result. If Docker Desktop crashes, stop and report; never restart it or WSL. Don't touch `leorna-pg` or `ndx6-preview-*`; remove containers you start. Don't use `pkill -f`.

## Report
- The gate results (commands, output tails), the pushed head SHA and how it was pushed (which account), the PR number and URL, each CI check's result, the ClickUp comment link and attachments, and the notes line you updated.
- `ac_status` per AC on the pushed head (AC4 `not_run`, live owed).
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or lessons yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
