# MAIN-MERGE 2 brief (fixer role): 86bcxnykn, bring main 297e2de into PR #131

Role: FIXER doing a main merge (a fresh general-purpose agent on Opus 5.5, high effort). PR #131 (`feat/86bcxnykn-admin-console-update`, head `71ef43aad5f437ee2b9a16b293bb192343317fc3`, CI green) went CONFLICTING after #113 (86bcx2a33, GitHub MCP 4.0.0 library item) merged into main as `297e2de631f03e28c45e346789d6cb26e2b925ee`. Justin wants to merge #131. Bring main in, run every gate and AC test, commit. **Don't push** (the main session pushes after a fresh review). Never merge into main, never write to ClickUp, never change `.github/workflows/*`, leave `deploy/local/` alone. Start no other agents.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`. `origin/main` is already fetched at `297e2de` (re-check with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`; if it moved, fetch with the `leorna` HTTPS recipe and merge the newer one).
- Approved plan (read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md` (its 000032 is now 000035). Evidence root `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`; write only in `main-merge-2/`.
- The previous bring-in brief, for the full method and rules (follow them; toolchain go1.27.4 is already installed): `/home/justin/.hermes/plans/leorna/briefs/86bcxnykn-admin-console-update-mainmerge.md`.

## Known
- `git merge-tree --write-tree --name-only HEAD origin/main`: only `delivery/stories.json` conflicts. Main `de4da62..297e2de` brought #113 (6 commits: github-mcp 4.0.0 in starter seed 1.3.0, the GitHub tile's server match, fixtures, its stories.json record). No migrations, no `go.mod`/`go.work` change.

## Do
1. `git merge origin/main` with message `merge: bring main (297e2de) into feat/86bcxnykn-admin-console-update`. Resolve `stories.json` mechanically (main's file unchanged, this story's entry, with `prs` `[131]`, appended last as text; prove every main entry equal by value and in order).
2. Do the `leorna` skill's bring-in checks (SKILL.md step 7, the long merge line): files differing from both parents = the both-sides set; one-sided files equal their side; the story's patch survived; no duplicate migration versions; grep for stale until/once wording on either card ID; when #113 adds rows of a kind the story reads, probe; build the handler (`go test -count=1 ./internal/web/` with no DB URL).
3. Run every gate on the new head (`make check` in full incl. audit, the Postgres no-skip `go test -json` run with `-timeout 1800s` in your own capped container `xnyk-merge2-pg`, test-module-add, test_release, test_story_shippable, tofu golden test not skipped, gitleaks incl. the both-sides files, the 000035 real-binary up/down proof against main `297e2de`'s binary). `python3 scripts/check-story-shippable.py 86bcxnykn` should print only the two open-PR BLOCKED lines. Save to `main-merge-2/gates-<head7>.txt`.
4. Run the four AC tests by name on the new head: `main-merge-2/ac<n>-<head7>.log` (first line `HEAD=<sha>`, last `EXIT=<rc>`).
5. Commit with the repo identity; no AI attribution; no `CLAUDE.md`.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (fixer rules), `engineering-best-practices`, `receiving-code-review`, `backend-data-migrations`, `git-commit-rules`.
Read before starting: `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Rules
As in the previous bring-in brief: capped Postgres with a TCP wait loop that fails at 3 minutes; earlyoom check before reading a killed command; mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`; scratch `~/.cache/86bcxnykn-mainmerge2/` created fresh with `mkdir` (no `-p`); never `git worktree prune`; bounded foreground polls under 3 minutes; no real Scaleway, GitHub or ClickUp writes; never print tokens, domains or tenant IDs. Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; an empty list is normal.

## Return
`{status: ready-for-review|stopped, head, merge_commit, conflicts_resolved[], merge_checks, gates, ac_runs[{ac, log, exit}], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
