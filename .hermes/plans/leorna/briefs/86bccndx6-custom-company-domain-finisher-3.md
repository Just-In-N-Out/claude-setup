# FINISHER 3 — 86bccndx6 custom company domain (refresh the hand-over for e6ea3d7)

Role: finisher. `ac-check.sh` on the reviewed head printed `READY FOR THE USER: 5 of 6 ACs proven on e6ea3d7; live ACs owed to the user: AC4` (saved in `<evidence>/ac-check-e6ea3d7.txt`). Finisher 2 wrote the hand-over for 44817ca; since then main moved to 9fce72d (PR #114), was merged in at e6ea3d7 (`bring-main-2/`), and Justin asked for the full recheck: review-11, verifier 6 and blind auditor 4 are all clean on e6ea3d7. Update the existing hand-over and drafts for e6ea3d7; read and edit them, don't start over. Do the local Leorna hand-over only, naming AC4 as owed to Justin. No nested agents.

**Never** push, open a PR, merge, post or change anything in ClickUp (comments, status, attachments), upload evidence, change CI, touch Scaleway/DNS/any cloud account, or bring main in. Don't change the reviewed head: if the hand-over needs a commit to the branch, stop and report instead.

## Load these skills first
`leorna` (its hand-over, evidence and shared-notes sections), `engineering-best-practices`, `git-commit-rules`, `github` (for the PR description shape only). Follow the repo's `AGENTS.md`.

## Pins
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain` (not pushed; no PR).
- Accepted head `e6ea3d7f0ec1082be6330a2405835c637de5d6cb`; base `9fce72dee016b21e3d8db50225ca6aeccd542fc1` (= local `main` = `origin/main`, PR #114; main was merged into the branch at e4cb538 and again at e6ea3d7).
- Approved plan `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md`. Evidence root `~/.hermes/plans/leorna/evidence/86bccndx6`.
- Final records: `verifier/ac.json` (verifier 6, clean) and `auditor/ac.json` (blind auditor 4, clean), `review-11/review.json` (clean); `bring-main-2/` and its `justin.json`. History: reviews 1–10, fixers `fix-1`..`fix-8`, `bring-main-1/`, archived `verifier-*`/`auditor-*` folders, Justin's decisions in `review-2/justin.json` and `review-6/justin.json`, and `follow-ups.md`. Justin also said on 2026-11-08 the IAM key/policy leak (R4-6) is "not a problem" (quota raised).
- The current `handover.md` and `finisher/` drafts were written for 44817ca (plus a short main-session addendum about e6ea3d7 at the end of `handover.md`); fold that addendum into the body.

## Do
1. Confirm the worktree HEAD is e6ea3d7 and `git status --porcelain` is empty (untracked included), and that `git rev-parse main origin/main` still equal 9fce72d. If main moved, stop and report (don't bring it in).
2. Update `<evidence>/handover.md` for e6ea3d7: problem and result, branch/base/head/diff stat, the commits since the old hand-over and why (add the #114 bring-in, its test-level interaction with this story's `discoveryHost`, and the full recheck), per-AC evidence (verifier 6's and auditor 4's logs and screenshots), gates actually run on this head (review-11, verifier 6 and auditor 4 each ran the unchanged `make check` green), limitations, rollback/recovery, and the open follow-ups from `follow-ups.md` (grouped, P3 only).
3. Refresh the drafts in `finisher/` for e6ea3d7 (move the 44817ca versions to `finisher/superseded-44817ca/`): `pr-description.md`, `team-message.md`, `clickup-evidence-draft.md`, `independent-review-prompt.md`. Keep the old ones' private-data rules: no real server addresses, tenant names, tokens or emails.
4. Refresh the AC4 live operator checklist (`finisher/live-operator-checklist.md` and `live-manifest.template.json`) for e6ea3d7 (`source_sha`, the launcher build step); keep the steps from `delivery/custom-company-domain.md` at this head, the exact fields Justin must fill, and mark anything unknown. Real target details go in a mode-600 private file outside the repo and evidence.
5. The evidence screenshots from the AC tests are JPEG bytes under `.png` names (follow-up A3-1): in the ClickUp draft, point to the verifier's and auditor's converted real PNGs.
6. Update the dated 86bccndx6 status line you or finisher 2 added in the shared `leorna-workflow.md` notes for e6ea3d7. The "never edit skills or memory" rule below covers skill lessons only; this story-status line is allowed.
7. Run gitleaks over the files you wrote, and remove any scratch you made.

## Report
- The files you wrote (full paths), the confirmed head/status/main SHAs, and the exact AC4 steps Justin owes.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or lessons yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
