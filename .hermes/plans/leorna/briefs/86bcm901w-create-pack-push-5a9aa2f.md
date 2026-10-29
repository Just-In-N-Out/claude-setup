
# FINISHER (push the merged head to PR #96) — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: the FINISHER for the `leorna` skill's step 7 on an existing PR. Push the accepted merged head to PR #96, update the PR text to name that head, wait for CI and report whether #96 is ready for Justin to merge. **Never merge.** No ClickUp writes, no team message.

## Justin's words (2026-10-28)
> Okay, what I want you to do is fix the merge conflict with 97 and main, or with PR #96. Then run verifications, run editors, run all that stuff so we can officially merge this.

The main session told him it would push the merged head to #96 once `ac-check.sh` said ALL ACCEPTED; he answered "ok great then we are chilling". That is the go for this push.

## State
- **Repo:** `LeornaAI/leorna-control-plane`. **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, local head **`5a9aa2f6c4c219234b49d9f9bd17e83942790437`** (clean): the merge commit `merge(86bcm901w): bring main in after #95, #94 and #97` on top of `5e29c56` (`chore(86bcm901w): record PR #96 in stories.json`). PR #96 and `origin/feat/86bcm901w-create-pack` are at `8a50486`, so this push is a fast-forward (no force).
- **Base:** GitHub `main` = **`a8d14654fd5f93a6cdfb8858a091e1ae7f43d9ad`** (#97's merge). All siblings (#94, #95, #97) are merged.
- **Accepted on `5a9aa2f`:** `ac-check.sh --base a8d1465 … verifier-5a9aa2f/ac.json auditor-5a9aa2f/ac.json` printed `ALL ACCEPTED: 4 of 4 ACs on 5a9aa2f`. Evidence (cite paths, don't copy content you haven't read):
  - bring-main-in fixer: `~/.hermes/plans/leorna/evidence/86bcm901w/mainin/` (`merge-proof.md`, gates, mutants on both `handler.go` hunks);
  - verifier: `…/verifier-5a9aa2f/` (`SUMMARY-gates-5a9aa2f.txt`, `merge-check-5a9aa2f.txt`, `ac.json`, `ac<n>-5a9aa2f.log`, `ac<n>-base-a8d1465.log`, AC1–AC3 console screenshots, AC4 log page): `make check` 0, `test-module-add.sh` 0, Postgres stream 287 pass / 0 fail / accepted skips only, story gate 0, gitleaks 0 (git range + dir on the both-sides files);
  - blind auditor: `…/auditor-5a9aa2f/` (`ac.json`, logs, 4 screenshots, 20 overlay mutants all killed by the AC tests' own assertions).
  The gates ran twice on this exact head (fixer and verifier); don't run them again locally — CI re-runs them on the pushed head.
- **gh:** active account must be `Justin-Leorna` (check `gh auth status`). Never run `gh auth switch`, never change a remote URL or credential helper config. If any push or `gh` call would act as `Just-In-N-Out`, stop and report.
- **PR text:** `~/.hermes/plans/leorna/86bcm901w-handover/pr.md` (same as `~/.hermes/cache/scratch/leorna-pr-86bcm901w-create-pack.md`); first line `Title: …`, the rest is the body. Read the live body first (`gh pr view 96 --json body`) and keep anything Justin or GitHub added.

## Steps
1. **Fetch** GitHub `main` over HTTPS through gh: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`. If `origin/main` is no longer `a8d1465`, **stop and report** (no push).
2. **Pre-flight:** `git status --porcelain --untracked-files=all` empty; `git rev-parse HEAD` = `5a9aa2f…`; `git merge-base --is-ancestor 8a50486 HEAD` (fast-forward); `git merge-tree --write-tree --name-only HEAD origin/main` exits 0 with no conflicts; every author and committer in `a8d1465..HEAD` is `Justin Issa <justin@leorna.com>` with no AI attribution lines; no `CLAUDE.md` tracked; `git diff --name-only a8d1465...HEAD -- .github/` empty.
3. **Update the PR text** in `pr.md` and the scratch copy: the Test Plan and Evidence name head `5a9aa2f` and say what ran on it (the fixer's and verifier's gates, both AC reports, the `ac-check.sh` line, CI pending until pushed); the old `8a50486` results stay only as history if useful. Replace any now-stale "conflicts with #94/#95/#97" or "until #… merges" wording with one line: main was merged in after #95, #94 and #97 (`handler.go`: kept both the pack-builder and item-builder wiring; `stories.json`: this story's entry appended last). No server domain, URL, tenant ID, token or email in the text.
4. **Push** as `Justin-Leorna`, fast-forward only: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm901w-create-pack:refs/heads/feat/86bcm901w-create-pack` (never `--force`). Fetch it back into `refs/remotes/origin/feat/86bcm901w-create-pack` the same way and check `git rev-parse HEAD origin/feat/86bcm901w-create-pack` match.
5. **PR:** `gh pr edit 96 -R LeornaAI/leorna-control-plane --body-file <body without the Title line>`. Read back `gh pr view 96 --json number,url,state,isDraft,headRefOid,mergeable,mergeStateStatus,author` (`headRefOid` = `5a9aa2f…`, author `Justin-Leorna`). Wait in the foreground for CI (a bounded poll, up to about 25 minutes): report each check's result and the Actions run URL, and fill them into the PR body's Evidence block with one more `gh pr edit`. `mergeable` must come back `MERGEABLE` (poll; GitHub computes it lazily). A CI failure: report the failing step's log lines; don't fix anything.
6. **After CI:** list open PRs again (`gh pr list -R LeornaAI/leorna-control-plane --state open`) and re-check `origin/main` — if main moved while CI ran, report it (don't merge it in). Run `python3 scripts/check-story-shippable.py 86bcm901w` from the worktree and report what it says (BLOCKED only because #96 is unmerged is expected).
7. Stop with status `ready-to-merge` (CI green, MERGEABLE, head `5a9aa2f`) or `stopped` with the reason.

## How to run things (this desktop is WSL Ubuntu)
- Scratch, if any: a fresh `~/.cache/86bcm901w-push/` (`mkdir` without `-p`), removed at the end. Not `/tmp`.
- Never touch sibling worktrees, branches, databases or evidence; never run `make fmt-fix`/`make workspace` from the main checkout; never touch `leorna-pg` on 5432.

## Skills
Load, in this order, and say so in your first steps: `leorna` (FINISHER role, step 7; skip its Step 1 load), `git-commit-rules`, `github`.

## Rules
- Never merge a PR, never force-push, never push any branch but `feat/86bcm901w-create-pack`. No ClickUp writes, no team message.
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{name: "86bcm901w-create-pack", status: "ready-to-merge" | "stopped", pr: {number, url, state, author, headRefOid, mergeable, mergeStateStatus}, ci[{check, result, url}], pushed_head, origin_main_after_ci, open_prs_after_ci, story_shippable, stop_reason, found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
