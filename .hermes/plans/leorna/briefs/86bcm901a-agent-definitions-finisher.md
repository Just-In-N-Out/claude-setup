# FINISHER — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FINISHER, a fresh agent. Do the `leorna` skill's "Doing a story" steps 5 and 6: stop and show, then the hand-over. Also map the overlap with the sibling stories and trial-resolve it, as Justin asked: "Resolve those conflicts at hand-over". **Never push, open a PR, post to ClickUp or merge.** Justin gives those words himself.

## Where things stand (checked by the main session, 2026-10-28)
- Worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- HEAD `9c13e02c1e6b111d6b33bd415371ac53c025d81b`, BASE `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`. There are 11 commits, all by `Justin Issa <justin@leorna.com>`.
- `ac-check.sh` on this head: `READY FOR THE USER: 4 of 5 ACs proven on 9c13e02; live ACs owed to the user: AC5`. AC1–AC4 are accepted by both the verifier and the blind auditor. **AC5 (live)**, one live run per agent in Claude Code, is owed to Justin, with the kit in `$EV/ac5-live/CHECKLIST.md`.
- **This head is the accepted one. Don't commit to the branch.** If you find something that truly needs a commit, stop and report it. Any new head would have to go through verifier → auditor → ac-check again.
- Fresh fetch at hand-over time: GitHub `main` = `origin/main` = `1ee7157`. Nothing has landed since the base, so merging into main is clean, and the main checkout's `main` is at `1ee7157`.
- Sibling branches (local refs: read them, never check them out or touch their worktrees, DBs or evidence). `git merge-tree --write-tree --name-only feat/86bcm901a-agent-definitions <sibling>` conflicts as follows:
  - `feat/86bcm901b-prompts-collection` @ `63afe55` (prompts): `cmd/library-upstream/main.go`, `delivery/stories.json`, `internal/library/README.md`, `internal/library/curation.go`, `internal/library/curation/curation.json`, `internal/library/upstream/importer.go`.
  - `feat/86bcm901j-mcp-templates` @ `f368af2` (MCP templates): `delivery/stories.json` and `internal/library/README.md` (`content.lock.json` auto-merges).
  - `feat/86bcm901w-create-pack` @ `e90cec8`: `delivery/stories.json`.
  - Open PR #94 `feat/86bcm9021-create-item-templates`: not checked yet.
- `$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a/`. The receipts there:
  - `verifier/` and `auditor/` (their `ac.json` and logs);
  - `verifier/gates-9c13e02.txt` (every gate EXIT=0 on this head);
  - `reviews/review-1-0ab7e6f.md` and `reviews/review-2-6ae5218.md`;
  - the builder's and fixers' sections in `$EV/README.md`;
  - the AC screenshots.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FINISHER role; do its Step 1 context load, then read `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `clickup-evidence.md`, `story-done-team-message.md` and `~/Leorna/leorna-control-plane/delivery/README.md`), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `github` (read-only `gh` calls).

## Tasks
1. **Recheck main.**
   - Fetch `main` over HTTPS through gh (the `leorna` skill's step 7.1 command), then compare `git rev-parse origin/main` with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`.
   - **If main moved past `1ee7157`, stop before anything else.** Report what landed and the `git merge-tree` result against the new main. The main session decides the next step with Justin.
   - **If main is unchanged,** go on to task 2.
2. **Step 5, stop and show:**
   - `git diff --stat origin/main..HEAD` and the key hunks;
   - `git diff --name-only origin/main...HEAD -- .github/`, which must be empty;
   - the commit authors, with no AI attribution lines;
   - no tracked `CLAUDE.md`;
   - the gate results on `9c13e02` (cite `verifier/gates-9c13e02.txt` and its logs; don't re-run the full gates).
3. **The overlap map and trial resolution** ("resolve those conflicts at hand-over"):
   - **PR #94:** check whether it conflicts too.
     - Read its file list with `gh pr view 94 -R LeornaAI/leorna-control-plane --json files,headRefOid` or `gh pr diff 94 --name-only`.
     - If any file overlaps, run the same `merge-tree` check against its head. Fetch that head read-only through `pull/94/head` into `FETCH_HEAD`; never create or move a branch.
   - **For each sibling and #94:** list the conflicting files, explain why each conflicts (what both sides changed), and give a step-by-step resolution recipe for whichever story merges second.
     - **`delivery/stories.json`:** take main's file as it is, append this story's entry last as text, then check every earlier entry is unchanged by value (per the `leorna` skill).
     - **`internal/library/README.md`:** keep both stories' sections.
   - **901b trial merge:** the code files need a real trial merge.
     - Create a detached scratch worktree at `9c13e02`: `git worktree add --detach ~/.cache/86bcm901a-finisher/trial-901b 9c13e02`. Then run `git merge --no-commit --no-ff 63afe55` inside it. This writes nothing to any branch.
     - Resolve every conflict, keeping both stories' meaning: this story's `--version` flag, agents and demo decisions, plus 901b's prompts.
     - Then run `go build ./...`, `go vet ./...` and `go test ./internal/library/... ./cmd/library-upstream/... ./cmd/library-gate/...` there (task-local toolchain PATH, `TMPDIR` under `~/.cache/86bcm901a-finisher/`). Record each exit code.
     - Save the resolved diff of each conflicted file as `$EV/hand-over/merge-with-901b-63afe55.patch`, with notes in `$EV/hand-over/merge-notes.md` (one section per sibling and #94).
     - Then `git merge --abort` and `git worktree remove --force` the copy.
     - Do a trial merge with 901j only if its README conflict isn't obviously mechanical.
     - Label every recipe with the sibling SHA it was made from: those branches are still moving.
   - **Also record for the siblings**, from review 1's R1-8:
     - this is the first time the seed and the library share a kind and name with different content (seed `agent/code-reviewer@1.0.0` vs library `@2.0.0`); 86bcm901w and 86bcm901r should know;
     - the catalog shows "Supported tools: Claude Code, Codex, Cursor" for agents that no tool installs yet. That was approved, and the plan carries the follow-up.
4. **Step 6, the hand-over**, following the formats in the notes:
   - **PR text:**
     - Christian's plain style: a Summary paragraph, one line per file or area, a Test Plan with results, short Assumptions.
     - The control plane also needs:
       - the ClickUp link to card 86bcm901a;
       - security, migration and rollback notes;
       - an Evidence block with the head SHA, the "Go quality gates" check, and the Actions run as "not yet: no PR".
     - Before writing Assumptions, grep sibling PR texts in `~/.hermes/cache/scratch/leorna-pr-*.md` (if the folder exists) and the open PRs for this card's ID.
     - Assumptions must also name:
       - AC5 owed;
       - AC3's "skipped everywhere": no tool installs agents at client `f105e27`;
       - R1-6, R2-2 and the govulncheck FYI (one vulnerability in a required module, not called; outside this story).
     - Write it to `~/.hermes/cache/scratch/leorna-pr-86bcm901a-agent-definitions.md` (create the folder if it's missing) and copy it to `$EV/hand-over/pr-text.md`.
   - **Review prompt:** a self-contained prompt for a fresh agent, in the format in `review-prompt-for-agent.md`. Save it as `$EV/hand-over/review-prompt.md`.
   - **ClickUp evidence draft:** the format in `clickup-evidence.md`.
     - WHAT WAS DONE / WHAT WAS VERIFIED, with an AC → test → result table.
     - The gates; the CI run as "after PR".
     - **AC5 as NOT VERIFIED (owed to Justin).**
     - The list of files to attach: pick the screenshots, open each one, and confirm no URL, password or token shows.
     - Save it as `$EV/hand-over/clickup-evidence.md`.
   - **Notes update:** don't edit memory yourself. Return the exact text for the main session to add to `leorna-workflow.md` and `leorna-control-plane-workflow.md`: story state, head, what's owed, and the overlap map.
5. **Write `$EV/hand-over/INDEX.md`** listing every hand-over file.

## Boundaries
- Write only to:
  - `$EV/hand-over/`;
  - the PR-text file;
  - `~/.cache/86bcm901a-finisher/` (`mkdir`, no `-p`), removed at the end;
  - small scratch in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-finisher/` (`mkdir`, no `-p`), removed at the end.
  `/tmp` is a small shared tmpfs: keep big things off it.
- **The story worktree stays as it is:** HEAD `9c13e02`, and `git status --porcelain --ignored` empty at the end.
- **Never touch:**
  - other stories' worktrees, branches, DBs or evidence (reading their refs with `git merge-tree`/`git show`/`git diff` is fine);
  - the main checkout's branch;
  - Justin's real `~/.claude` or `~/.codex`.
- **Never:** push, open a PR, post to ClickUp, merge, change a ClickUp status, or run Claude Code for AC5.
- **No server domain, URL, tenant ID or token** in any hand-over text. The only URLs allowed are GitHub's public repo and PR links and the ClickUp card link.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status, using the `leorna` FINISHER wording: `code-reviewed; live acceptance pending (AC5)`, unless something stopped you.
- The fresh `origin/main` SHA; the diff stat; the `.github/` check.
- The overlap map: per sibling and #94, the files, the recipe, and the trial-merge results with exit codes.
- The paths of the PR text, review prompt, ClickUp evidence draft and `INDEX.md`, plus the PR title you propose.
- The notes-update text for the main session.
- What Justin owes and the words he can give next: "push", "make a PR", "post".
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
