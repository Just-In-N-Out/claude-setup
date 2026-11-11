# FINISHER brief ("make a PR"): 86bcm928e, custom integrations defined by the admin

Role: FINISHER (a fresh general-purpose agent on Opus 5.5, high effort). Justin said "push pr" / "after done create a pr" on 2026-11-11: push the branch and open the PR, following the `leorna` skill's Doing a story → step 7 exactly. **Never merge. No ClickUp write** (the post waits for the merge and Justin's "post"). Start no other agents.

## State (verified by the main session)
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`, head **`57b7e9b6c087741c4e4316cdcdba5b00d30710fb`**, GitHub main **`d3e7391c23c2518d95f11fbe77e26baeb568bb86`** (merged in by `c8bbe58`, so `merge-base HEAD origin/main` = main). Not pushed yet; no PR yet.
- `ac-check.sh --reviews` on `57b7e9b` printed:
```
AC1  ACCEPTED
AC2  ACCEPTED
AC3  ACCEPTED
REVIEWS  CLEAN: review-4 at 57b7e9b is clean
ALL ACCEPTED: 3 of 3 ACs on 57b7e9b
```
- History for the PR text: review 1 (Fable, full) 3 P2 fixed in `94fa2ee`; review 2 (Opus, full) clean; auditor 1 rejected AC2's untestable cross-tenant clause, fixed in `0a45d39`; review 3 clean; main `d3e7391` brought in by merge `c8bbe58` (migration renumbered `000032` → `000033_integration_custom_tiles` because #125 took 32; conflicts with #126 resolved keeping both); Justin-approved fixes `c423592` (the edit POST moved to `/admin/integrations/custom/{tileID}/edit` because it clashed with #126's `POST /admin/integrations/{tileID}/test` and panicked at startup; new DB-free `TestRoutesBuildWithoutPatternClash`) and `57b7e9b` ("Test connection" now works on a company's custom tiles, tenant-scoped); review 4 (delta) clean; verifier 3 and blind auditor 3 clean on `57b7e9b`.
- Gates on `57b7e9b` (verifier 3, this session, Go 1.27.4): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/verifier/gates-57b7e9b.txt` and `verifier/gates/SUMMARY.txt` — `make check` EXIT=0 (audit passes on 1.27.4; earlier runs timed out in `internal/web` only from desktop load), `test-module-add` 0, `test_release` OK, Postgres no-skip 0, no-DB web/cmd no panic, contracts-check 0, authors OK, no attribution lines, gitleaks clean, migration 000033 up/down proof with main's binary. Also `bring-main-2/` fixer gates on the same head.
- Approved plan (read-only, with Justin's answers incl. 2026-11-11): `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/plan-approved.md`. Follow-ups: `evidence/86bcm928e/follow-ups.md`.
- Earlier hand-over drafts (for `0a45d39`, now outdated): PR text `~/.hermes/cache/scratch/leorna-pr-86bcm928e-custom-integrations.md`, `evidence/86bcm928e/finisher/` (review-prompt.md, team-message.md, clickup-evidence.md, gates-0a45d39.png).

## What to do (`leorna` step 7, sub-steps 1–8)
1. Fetch main over HTTPS through gh (URL written out). If GitHub main has moved past `d3e7391`, **stop** with `status: stopped` and report what landed (a new bring-in needs its own review round). Check HEAD is still `57b7e9b`.
2. Pre-flight (step 7.2): clean `git status`; branch-only authors (`git log --format='%an <%ae>' HEAD ^4ef14ef ^origin/main`) Justin's Leorna identity, never printing the address; no attribution lines; no `.github/` or contract path; `git merge-base HEAD origin/main` = origin/main; no duplicate migration version.
3. Gates (step 7.3): the head and main are exactly what verifier 3 gated this session (check both SHAs); cite its `gates-57b7e9b.txt` in the Test Plan. If either SHA differs, stop instead.
4. Rewrite the PR text for `57b7e9b` at `~/.hermes/cache/scratch/leorna-pr-86bcm928e-custom-integrations.md` (body only, no title line, plain style per step 6): Summary and per-area lines including the two 2026-11-11 fixes; Test Plan with only results recorded on `57b7e9b` and "main `d3e7391` brought in"; Assumptions (Justin's answers 1A–5A and the 2026-11-11 ones, the add-only `gate.ServerCredential` in `internal/library/gate/` the plan listed as not touched, the change inside #126's connection tester, rulings for Justin to confirm); security notes; migration 000033 and rollback notes (main's binary refuses to start while 33 is applied; run the down file and delete version row 33 first); ClickUp link [the card](https://app.clickup.com/t/86bcm928e); Evidence block. Name other stories by PR number or title, never by bare card ID. Grep open PRs and sibling PR texts for this card's ID first. gitleaks the file.
5. Push (step 7.6) with the inline gh credential helper and the URL written out: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm928e-custom-integrations:refs/heads/feat/86bcm928e-custom-integrations`; fetch it back into `refs/remotes/origin/feat/86bcm928e-custom-integrations`, set upstream, check `git rev-parse HEAD origin/<branch>` match. If the push would go as any account other than `Justin-Leorna`, stop.
6. Open the PR (step 7.7): `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm928e-custom-integrations --state all` must be empty; `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm928e-custom-integrations --title "feat(86bcm928e): custom integrations defined by the admin" --body-file <file>`; read back `gh pr view <n> --json number,url,state,isDraft,headRefOid,mergeable,mergeStateStatus` (`BEHIND` = main moved: report it). Record the PR in `leorna-workflow.md` (one dated status line: allowed; the "never edit skills or memory" rule covers skills and lessons only).
7. PR-number record (step 7.8): add the PR number to this story's `delivery/stories.json` entry (and any "in review" wording the step names) in **one small commit** on the branch (`chore(86bcm928e): record PR #<n>` or the repo's usual form; plain `git commit -m`, no author flags, no AI attribution lines). Check it by value (main's entries unchanged and in order, this story's last) and with `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` and `python3 scripts/check-story-shippable.py 86bcm928e` (expect only the PR-state BLOCKED lines while open). **Do not push this commit**: it needs a fresh delta review first, which the main session runs. Stop there with `status: pr-open-record-commit-unpushed`.
8. Refresh the hand-over drafts in `evidence/86bcm928e/finisher/` for `57b7e9b` and the PR number: review prompt (`review-prompt-for-agent.md` format), team message, ClickUp evidence draft (WHAT WAS DONE, AC → test → result table, gates, CI "<to fill after merge>"; images only: pick the best per AC from `verifier/ui/`, `auditor/` and the evidence root, plus `verifier/gates-57b7e9b.png`; open every image and check none shows a domain, URL bar, tenant ID, token or email). The post waits for the merge and Justin's "post".

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (FINISHER, step 7), `engineering-best-practices`, `git-commit-rules`, `github`.

## Rules
- Never merge, force-push, rebase, run `gh auth switch`, change a remote or credential helper, or run `git worktree prune`. Push only the branch named above.
- Never put server domains, URLs, tenant IDs or tokens in any PR text or draft. Don't write key-shaped example values whole.
- Memory (WSL desktop): check earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`) before reading any killed command as a result.
- Scratch: your own `~/.cache/928e-pr-finisher/`, created fresh with `mkdir` (no `-p`).
- Don't end your turn to wait for a background command; foreground polls under 3 minutes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory yourself apart from the one status line; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: pr-open-record-commit-unpushed|stopped, pr{number, url, state, headRefOid, mergeStateStatus}, pushed_head, record_commit{sha, checks}, github_main, preflight, pr_text_path, ci_first_head, review_prompt, team_message, clickup_comment, clickup_attachments[], records_changed[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
