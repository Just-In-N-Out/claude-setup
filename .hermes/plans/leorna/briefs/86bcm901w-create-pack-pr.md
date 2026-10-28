
# PR AGENT ("make a PR") — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: the FINISHER for the `leorna` skill's Doing a story → step 7 ("make a PR"): re-run the gates on the exact head, push the branch, open the PR, then record its number in `delivery/stories.json` as a local commit and stop. **Never merge.** No ClickUp writes.

## Justin's words (2026-10-28)
> Okay, here's the thing. I want you to make the PR, put it on GitHub, and tell me which file it is or what repo it is. We may have to rerun verifications, auditors, and AC checks on the new head, all right.

The main session reads this as "make a PR". The `stories.json` PR-number commit is a new head: it stays **local and unpushed** until the main session has re-run the verifier, the blind auditor and `ac-check.sh` on it; you'll then be resumed to push it.

## State
- **Repo:** `LeornaAI/leorna-control-plane` (GitHub). **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, head **`8a5048694d40ee975c7b3c276ca1b8af521cae5d`** (clean, 18 commits, not pushed; no PR exists for this branch). Base **`1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`** = GitHub `main` (checked by the main session just now).
- **Accepted:** `ac-check.sh` printed `ALL ACCEPTED: 4 of 4 ACs on 8a50486` (verifier and blind auditor). No AC is live.
- **gh:** active account `Justin-Leorna` (checked). Never run `gh auth switch`, never change a remote URL or credential helper config. If any push or `gh` call would act as `Just-In-N-Out`, stop and report.
- **Open sibling PRs:** #94 (`feat/86bcm9021-create-item-templates`, Yan) and #95 (`feat/86bcm901b-prompts-collection`, opened by another session for 86bcm901b). Local siblings not yet pushed: `feat/86bcm901a-agent-definitions`, `feat/86bcm901j-mcp-templates`. The hand-over's integration check (`~/.hermes/plans/leorna/86bcm901w-handover/integration.md`) found: vs #94 one `internal/web/handler.go` struct-field hunk (keep both `packBuilder` and `itemBuilder`); vs 901a/901b/901j only `delivery/stories.json`.
- **PR text:** `~/.hermes/plans/leorna/86bcm901w-handover/pr.md` (same as `~/.hermes/cache/scratch/leorna-pr-86bcm901w-create-pack.md`). Its first line is `Title: feat(86bcm901w): create a pack by picking library items`: use that as `--title` and the rest as the body.

## Steps (the `leorna` skill, step 7, in order)
1. **Fetch** GitHub `main` over HTTPS through gh: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`. Record `git rev-parse origin/main`. If it moved past `1ee7157`, stop and report (a main move needs Justin's "bring main in" OK and a re-verification).
2. **Pre-flight:** `git status --porcelain --untracked-files=all` empty; every author and committer in `1ee7157..HEAD` is `Justin Issa <justin@leorna.com>` with no AI attribution lines; `git diff --name-only 1ee7157...HEAD -- .github/` empty; no `CLAUDE.md` in the diff; `git merge-tree --write-tree --name-only HEAD origin/main` exits 0. Re-run merge-tree against #95's head (fetch `pull/95/head` read-only into `FETCH_HEAD` and check `git rev-parse FETCH_HEAD` equals `gh pr view 95 --json headRefOid`) and #94's head the same way; record the conflicts for the PR text and report. Sibling conflicts don't block opening this PR.
3. **Re-run the gates on `8a50486`** in a detached copy (never the story worktree; `leorna` step 4): `make check` with CI's pinned linters bound by absolute path (`GOLANGCI_LINT=`/`GOVULNCHECK=` from `~/.local/leorna-toolchain/bin`), `bash ./scripts/test-module-add.sh`, the `go test -json` Postgres stream read per test, the story gate `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, gitleaks on `1ee7157..HEAD`. One `SUMMARY.txt` with a `label EXIT=<rc>` line per gate. Logs to `~/.hermes/plans/leorna/evidence/86bcm901w/pr/` (create it). Any non-zero gate: stop and report, don't push.
4. **Update the PR text's Test Plan and Evidence block** with this run (head SHA, your logs; CI pending until pushed) in `pr.md` and the scratch copy; the Test Plan lists only what ran on `8a50486`. Add the #95 conflict note (only `delivery/stories.json`) beside the #94 one under Assumptions if it isn't there.
5. **Push** as `Justin-Leorna`: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm901w-create-pack:refs/heads/feat/86bcm901w-create-pack`. Fetch it back into `refs/remotes/origin/feat/86bcm901w-create-pack` the same way, `git branch --set-upstream-to=origin/feat/86bcm901w-create-pack`, and check `git rev-parse HEAD origin/feat/86bcm901w-create-pack` match.
6. **Open the PR:** `gh pr list -R LeornaAI/leorna-control-plane --head feat/86bcm901w-create-pack --state all` must be empty (never a duplicate). Then `gh pr create -R LeornaAI/leorna-control-plane --base main --head feat/86bcm901w-create-pack --title "<the title>" --body-file <body file without the Title line>`. Read it back: `gh pr view <n> -R LeornaAI/leorna-control-plane --json number,url,state,isDraft,headRefOid,mergeable,author` (author must be `Justin-Leorna`, `headRefOid` = `8a50486…`) and `gh pr checks <n>`. Wait in the foreground for CI (a bounded poll, up to about 20 minutes); report each check's result and the Actions run URL, and fill them into the PR body's Evidence block with `gh pr edit <n> --body-file`. A CI failure: report it with the failing step's log lines; don't fix anything.
7. **Record the PR number** (step 7.8): add it to this story's entry in `delivery/stories.json` as a small commit on the same branch (`chore(86bcm901w): record PR #<n> in stories.json`, the repo's identity, no AI attribution). Edit as text so every earlier entry stays unchanged by value; check with `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` from the repo root and `python3 scripts/check-story-shippable.py 86bcm901w` (read what it says while the PR is open). **Don't push this commit.** Report its SHA.
8. Stop with status `pr-open` and the new local head.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `~/.cache/86bcm901w-pr/` on the real disk (`mkdir` without `-p`) for `TMPDIR`, the detached copy and caches; remove only that folder at the end. Not `/tmp`.
- **Toolchain:** Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0 in `~/.local/leorna-toolchain` (read-only); gitleaks 8.30.1 at `/usr/local/bin`; make and gcc from apt. PATH per command only.
- **Postgres:** `leorna-test-pg` on `127.0.0.1:55432` (user `leorna`, password `ci-only-password`); your own `leorna_86bcm901w_pr_test`, dropped at the end. Never touch any other database or the `leorna-pg` container on 5432. Plain `docker` works. If Docker stops answering (a WSL restart), stop and report.
- Sibling stories: never touch their worktrees, branches (beyond read-only fetches of PR heads), databases or evidence. Never run `make fmt-fix`/`make workspace` from the main checkout.

## Skills
Load, in this order, and say so in your first steps: `leorna` (FINISHER role, step 7 "make a PR"; skip its Step 1 load), `engineering-best-practices`, `git-commit-rules`, `github`.

## Rules
- Never merge a PR, never force-push, never push any branch but `feat/86bcm901w-create-pack`, never push the step-7 commit. No ClickUp writes, no team message.
- Never write a server domain, URL, tenant ID or token into the PR text.
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{name: "86bcm901w-create-pack", status: "pr-open" | "stopped", pr: {number, url, state, author, headRefOid, mergeable}, ci[{check, result, url}], gates[{name, exit, log}], pushed_head, local_head_after_stories_commit, sibling_conflicts[{pr, files}], stop_reason, found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
