# FINISHER brief: Leorna story 86bcm928h-per-user-credentials (hand-over only)

**Role:** FINISHER. You are a fresh agent: Opus 5.5, effort high.

The story is verified under its recorded acceptance contract. Run only the project's finish step, which is the Leorna **hand-over** (`leorna` skill → "Doing a story" steps 5 and 6, and FINISHER).

**Justin's standing instruction for this story:** hand-over only. **No push, no PR, no ClickUp post** until he says. Never merge.

## State
- **Story:** "Per-user credentials for integrations on the engineer's laptop" (ClickUp 86bcm928h), repo `leorna-client`.
- **Worktree:** `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`
- **Branch:** `feat/86bcm928h-per-user-credentials`
- **Accepted head:** `1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2`
- **Base:** `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`
- **`ac-check.sh --reviews` on 1f98596:** `READY FOR THE USER: 7 of 8 ACs proven on 1f98596; live ACs owed to the user: AC8`. Reviews: `CLEAN: review-3 at 1f98596 is clean`.
- **AC8 (live)** is owed to Justin. It needs a clean Windows VM, his real GitHub token, and 86bcm927y's GitHub tile on a test server once 927y is merged (Q4 A). The checklist is in the plan's "Live AC8 checklist". It stays **NOT VERIFIED / acceptance-blocking** until he runs it.
- **Evidence folder:** `~/.hermes/plans/leorna/evidence/86bcm928h/`
  - `plan-approved.md`
  - `builder-report.md`, `fixer-1-report.md`, `fixer-2-report.md`
  - `review-1..3/` (`review.json` + `report.md`)
  - `verifier/` (`ac.json`, AC logs and screenshots, `gates/`, `mutants/`)
  - `auditor/` (`ac.json`, AC logs, 7 PNGs, `mutants/`)
  - `follow-ups.md`: P3s from all rounds
  - per-head gate logs `gates-<sha7>.txt`
- **Plan:** `~/.hermes/plans/leorna/86bcm928h-per-user-credentials.md`. Its Docs & records task is your list.
- **Found items log:** `~/.hermes/plans/leorna/found-else.md`, under the 86bcm928h headings.

## Don't move the accepted head
**Make no commits to the branch.** Any commit, even records-only, would need a fresh review, verifier and auditor round.

The plan's `PROJECT_MEMORY.md` progress line is the only repo record the finisher owns. **Draft it** in your report and in the PR text's notes; it is committed at the "make a PR" step, when the gates and PR-head verification re-run anyway. README.md, application/README.md, GLOSSARY.md and SECURITY.md were already updated in the build and fix commits. Check they match head and list any gap as a follow-up. Don't fix it.

## Skills (say so in your first steps)
- `leorna` (FINISHER; read `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `clickup-evidence.md` and `story-done-team-message.md` from its memory folder)
- `engineering-best-practices`
- `git-commit-rules` (read-only use here)
- `receiving-code-review` is not needed: there are no open P0–P2 findings.

## The hand-over (leorna steps 5–6)
1. **Stop and show:**
   - `git diff --stat origin/main...HEAD` (three dots) and the key hunks.
   - The `.github/` path list from `git diff --name-only origin/main...HEAD`. It must be empty.
   - Authors: only `Justin Issa <justin@leorna.com>`, with no AI attribution lines.
   - The gate results on 1f98596. Cite the verifier's `verifier/gates/` logs and `gates-1f98596.txt`, opening each and reading its recorded exit code.
2. **Integration check, read-only:**
   - Fetch GitHub `main` over HTTPS through gh (leorna step 7.1 command, URL written out) and record its SHA.
   - Run `git merge-tree --write-tree --name-only HEAD origin/main`.
   - Trial-merge each open sibling client PR and the sibling worktree `86bctmuwy-agent-items-install` (`git merge-tree`). Watch for a duplicate SQLite migration 9 and `application/sync.go`/README overlaps.
   - Report conflicts. Don't resolve them.
3. **PR text** in Christian's plain style: a Summary paragraph, one line per file/area, a Test Plan with results naming the head they ran on, and a short Assumptions list. Write the body only, with no Title line, to `~/.hermes/cache/scratch/leorna-pr-86bcm928h-per-user-credentials.md`.
   - Name AC8 as owed live.
   - Note under Assumptions that review changed the Windows launch from the plan's PowerShell route to each tool's own absolute `.exe`.
   - Note the tool install locations covered and not covered (Volta, fnm, nvm-windows 2 shim mode).
   - Note the P3 follow-ups.
   - Grep sibling PR texts `~/.hermes/cache/scratch/leorna-pr-*.md` and open PRs for this card's ID before writing Assumptions. Name other stories by PR number or title, never by bare card ID.
   - Create `~/.hermes/cache/scratch/` if it doesn't exist.
4. **Review prompt:** a self-contained prompt for a fresh agent, in the `review-prompt-for-agent.md` format, saved next to the PR text.
5. **ClickUp evidence draft** in the `clickup-evidence.md` format:
   - The closing comment: WHAT WAS DONE / WHAT WAS VERIFIED, with an AC → test → result table, the gates and NOT VERIFIED AC8.
   - The list of image files to attach, one per AC from `auditor/` or `verifier/`. Images only, never `.log`/`.txt`.
   - Visually inspect every image you list. No server domain or URL, tenant ID, token, email or git credential target may be visible.
   - Draft only: **don't upload**.
6. **Team message draft** (`story-done-team-message.md` format), marked "send after merge".
7. **Records:** add a dated status line for 86bcm928h to `leorna-workflow.md` in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`. Record the branch, head 1f98596, not pushed, no PR, READY FOR THE USER with AC8 owed, and the follow-ups path. Keep it small and set the frontmatter `modified:`. No other memory edits.

## Rules
- Never push, open a PR, merge, or write to ClickUp. Never change `.github/`. Never override author metadata.
- Never print a token, a server domain or URL, or a tenant ID.
- **Memory runaway:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it.
- **found_else / skill_lessons:**
  - If you find any other problem, list it in `found_else` with evidence and severity.
  - If you learn something reusable, don't edit any skill. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`).
  - `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind, what it checks and where it runs.
  - An empty list is the normal answer.

## Return
`{status: "code-reviewed; live acceptance pending (AC8)", head_sha, diff_stat, github_paths, authors_ok, gates[{name, exit, log}], integration{github_main_sha, merge_tree, siblings[]}, pr_text_path, review_prompt_path, clickup_draft{comment_path, attachments[]}, team_message_path, project_memory_line, records_updated[], follow_ups[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
