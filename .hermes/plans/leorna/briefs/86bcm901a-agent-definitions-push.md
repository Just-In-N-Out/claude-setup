# FINISHER ("push") — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FINISHER, a fresh agent. On 2026-10-28 Justin said "push" ("Yeah, okay, push them" / "If everything goes well, push it"), on the condition that the round-3 auditor and `ac-check.sh` pass on `829fa9c`. They passed, and the main session dispatched you only after that.

You are approved to:
- push the branch to update PR #97;
- refresh PR #97's description.

You are not approved to:
- merge;
- post to ClickUp;
- make any commit.

## Facts
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- **Head to push:** `829fa9cb4d0a64ee03e132ebba9de95870b9fb41`. It has `9c13e02` as an ancestor, so this is a fast-forward push and never a force-push.
- **Commits it adds to PR #97:**
  - `6ae305e`: merge after #95 (86bcm901b), which resolved 6 conflicts and set library 0.7.0;
  - `55abda3`: records PR #97 in `delivery/stories.json`;
  - `829fa9c`: merge after #94 (86bcm9021), with no conflicts.
- **PR #97 now:** `https://github.com/LeornaAI/leorna-control-plane/pull/97`. GitHub has head `9c13e02`, mergeable `CONFLICTING`.
- **Main:** `origin/main` = GitHub main = `da8a4b0` (merge of #94) at the last fetch. `git merge-base 829fa9c origin/main` = `da8a4b0`.
- **Acceptance on `829fa9c`:**
  - round-3 verifier: clean;
  - round-3 blind auditor: clean;
  - `ac-check.sh`: READY FOR THE USER (AC1–AC4 accepted);
  - AC5: Justin accepted it on `9c13e02`, and the agent bodies are byte-identical at `829fa9c`.
- **Gates on `829fa9c`, all exit 0:**
  - `~/.hermes/plans/leorna/evidence/86bcm901a/gates-829fa9c.txt`, from the merge fixer;
  - `~/.hermes/plans/leorna/evidence/86bcm901a/verifier/gates-829fa9c/SUMMARY.txt`, which includes a `--no-cache` image build and the packaged-scanner check.
- **PR text:** `~/.hermes/cache/scratch/leorna-pr-86bcm901a-agent-definitions.md`, copied at `~/.hermes/plans/leorna/evidence/86bcm901a/hand-over/pr-text.md`. It is stale: it says library 0.6.0, head `9c13e02` and base `1ee7157`, and that #94 "still merges cleanly".

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FINISHER role, step 7; do its Step 1 context load), `git-commit-rules`, `github`.

## Steps
1. **Re-fetch main** over HTTPS through gh (`leorna` step 7.1), then compare `git rev-parse origin/main` with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`.
   - If main has moved past `da8a4b0`, **stop before pushing** and report what landed, with the `git merge-tree` result. A new head would need another verify round.
2. **Pre-flight.**
   - HEAD is `829fa9c` and `git status --porcelain --ignored` is empty.
   - `git merge-tree --write-tree HEAD origin/main` exits 0.
   - Every commit in `da8a4b0..HEAD` is authored and committed by `Justin Issa <justin@leorna.com>`, with no AI attribution lines.
   - `git diff --name-only origin/main...HEAD -- .github/` is empty, and no `CLAUDE.md` is tracked.
   - `gh api user --jq .login` is `Justin-Leorna`.
   - Don't re-run the full gates: this exact head was gated and verified twice, as listed under Facts. Cite those receipts.
3. **Update the PR text** (both copies, kept identical: no `Title:` line, body only).
   - Head is `829fa9c`, base/main is `da8a4b0`, and the library is **0.7.0**.
   - Say in one short paragraph that main was brought in twice:
     - after #95, resolving 6 conflicts in `main.go`, `importer.go`, `curation.go`, `curation.json`, the README and `stories.json`, keeping both stories;
     - after #94, with no conflicts.
   - The Test Plan lists the gates and AC acceptance on `829fa9c`: round-3 verifier, round-3 auditor, `ac-check`, and the AC5 body-hash carry-over.
   - Include 901b's and #94's tests passing on this head, and the `--no-cache` image build with packaged gitleaks 8.30.1.
   - Remove "#94 still merges cleanly". Keep the open sibling note about #96 (901w, `stories.json` only).
   - The Evidence block gets the head SHA, the "Go quality gates" check and the new Actions run URL (fill it in after CI starts).
   - The only links allowed are GitHub and ClickUp, with no server domain, tenant or token.
4. **Push** with `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-control-plane.git feat/86bcm901a-agent-definitions:refs/heads/feat/86bcm901a-agent-definitions`.
   - No `--force` and no `--force-with-lease`. If the push is rejected as non-fast-forward, stop and report.
   - Fetch it back into `refs/remotes/origin/feat/86bcm901a-agent-definitions`, and check that `git rev-parse HEAD origin/feat/86bcm901a-agent-definitions` both give `829fa9c`.
5. **Update PR #97's body:** `gh pr edit 97 -R LeornaAI/leorna-control-plane --body-file <PR text>`. Don't change the title, labels, reviewers or draft state.
6. **Wait for CI**, in polls under 170 s each (a foreground Bash call is moved to the background after 180 s), up to about 25 minutes.
   - Read back with `gh pr view 97 --json headRefOid,mergeable,mergeStateStatus,state` and `gh pr checks 97`.
   - Add the Actions run URL to the Evidence block (`gh pr edit` again, and in the scratch copy).
   - If a check fails, read `gh run view --log-failed` and report the cause. Don't fix anything: any fix is a new head.
7. **Don't merge, don't post and make no commits.**

## Boundaries
- Never touch other stories' worktrees, branches, PRs or evidence, or the main checkout.
- Never run `gh auth switch`, and never change a remote URL or credential helper.
- Write only the two PR-text copies, plus a receipt folder `~/.hermes/plans/leorna/evidence/86bcm901a/push-829fa9c/` (preflight, push, CI) and small scratch in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-push/` (`mkdir`, no `-p`; remove it at the end).

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status: `pushed, CI <result>` or `stopped`, and why.
- PR #97's URL; the head SHA on GitHub; mergeable and merge state; every CI check with its result and run URL.
- The fresh `origin/main` SHA.
- A summary of what changed in the PR text.
- The exact notes text for the main session to put in `leorna-workflow.md`.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
