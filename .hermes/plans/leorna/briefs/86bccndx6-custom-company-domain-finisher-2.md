# FINISHER 2 — 86bccndx6 custom company domain (local Leorna hand-over)

Role: finisher. `ac-check.sh` on the reviewed head printed `READY FOR THE USER: 5 of 6 ACs proven on 44817ca; live ACs owed to the user: AC4` (saved in `<evidence>/ac-check-44817ca.txt`). Do the local Leorna hand-over only, naming AC4 as owed to Justin. No nested agents.

**Never** push, open a PR, merge, post or change anything in ClickUp (comments, status, attachments), upload evidence, change CI, touch Scaleway/DNS/any cloud account, or bring main in. Don't change the reviewed head: if the hand-over needs a commit to the branch, stop and report instead.

## Load these skills first
`leorna` (its hand-over, evidence and shared-notes sections), `engineering-best-practices`, `git-commit-rules`, `github` (for the PR description shape only). Follow the repo's `AGENTS.md`.

## Pins
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain` (not pushed; no PR).
- Accepted head `44817ca1a5a10dd3f184f1550b7e131202ed31c6`; base `f0a326b83aae9d181e4f6681645685ae4b1fff91` (= local `main` = `origin/main`, PR #112; main was merged into the branch at e4cb538).
- Approved plan `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Evidence root `~/.hermes/plans/leorna/evidence/86bccndx6`.
- Final records: `verifier/ac.json` (verifier 5, clean) and `auditor/ac.json` (blind auditor 3, clean), `review-10/review.json` (clean). History: reviews 1–10, fixers `fix-1`..`fix-8`, `bring-main-1/`, archived `verifier-*`/`auditor-*` folders, Justin's decisions in `review-2/justin.json` and `review-6/justin.json`, and `follow-ups.md`. Justin also said on 2026-11-08 the IAM key/policy leak (R4-6) is "not a problem" (quota raised).
- The previous finisher's hand-over (`handover.md`, `finisher/`) was written for 19cbf79 and is now stale.

## Do
1. Confirm the worktree HEAD is 44817ca and `git status --porcelain` is empty (untracked included), and that `git rev-parse main origin/main` still equal f0a326b. If main moved, stop and report (don't bring it in).
2. Rewrite `<evidence>/handover.md` for 44817ca: problem and result, branch/base/head/diff stat, the commits since the old hand-over and why (reviews 4–10, the main merge, the verifier/auditor test-strengthening rounds), per-AC evidence (the final verifier's and auditor's logs and screenshots), gates actually run on this head (review-10, verifier 5 and auditor 3 each ran the unchanged `make check` green), limitations, rollback/recovery, and the open follow-ups from `follow-ups.md` (grouped, P3 only).
3. Refresh the drafts in `finisher/` for this head: `pr-description.md`, `team-message.md`, `clickup-evidence-draft.md`, `independent-review-prompt.md`. Keep the old ones' private-data rules: no real server addresses, tenant names, tokens or emails.
4. Refresh the AC4 live operator checklist (`finisher/live-operator-checklist.md` and `live-manifest.template.json`) for 44817ca: fix-3 changed the live manifest (it now needs `image_digest` as `sha256:<64 hex>`, taken with `docker inspect … | cut -d@ -f2`, and the provider key needs registry read access); include the steps from `delivery/custom-company-domain.md` at this head, the exact fields Justin must fill, and mark anything unknown. Real target details go in a mode-600 private file outside the repo and evidence.
5. The evidence screenshots from the AC tests are JPEG bytes under `.png` names (follow-up A3-1): in the ClickUp draft, point to the verifier's and auditor's converted real PNGs.
6. Update the Leorna shared notes the `leorna` skill names for a hand-over (status of 86bccndx6), if the skill says to.
7. Run gitleaks over the files you wrote, and remove any scratch you made.

## Report
- The files you wrote (full paths), the confirmed head/status/main SHAs, and the exact AC4 steps Justin owes.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
