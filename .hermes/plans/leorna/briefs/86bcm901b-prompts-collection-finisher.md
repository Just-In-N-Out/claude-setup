# FINISHER brief: 86bcm901b-prompts-collection [leorna]

**Role:** FINISHER (hand-over) for the Leorna story "86bcm901b-prompts-collection" (ClickUp "Curate the reusable prompts collection"), Full pipeline. Run only the project's finish step, the `leorna` skill's "Doing a story" steps 5–6 (stop and show, hand-over pack), plus the sibling-conflict work below. **Never push, open a PR, merge, or write to ClickUp**: Justin says "push", "make a PR" or "post" himself, and each word authorizes only itself.

**Status going in:** verified under the recorded acceptance contract on head **`63afe554f42e593b545741e453a59d560c49cb22`** (base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`). `ac-check.sh` result: **<filled in by the main session at dispatch>**. AC1–AC4 accepted; **AC5 (live) owed to Justin**: he runs /review and /spec in Claude Code (`~/.hermes/plans/leorna/evidence/86bcm901b/ac5-checklist.md`). The hosted CI step "Check content library quality" stays NOT VERIFIED until a PR exists.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FINISHER role; Step 1 context load, plus the finishing notes it names: `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md`, and `~/Leorna/leorna-control-plane/delivery/README.md`).
2. `engineering-best-practices`.
3. `git-commit-rules`.
4. `receiving-code-review` (only if you find something to fix; see Boundaries).

## Inputs

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection`, branch `feat/86bcm901b-prompts-collection`, 15 commits on `1ee7157`.
- **Plan:** `/home/justin/.hermes/plans/leorna/86bcm901b-prompts-collection.md` (approved copy `evidence/86bcm901b/plan-approved.md`), with "Justin's answers (2026-10-28)": every ⭐ (Q1 A `requires` in item.json, Q2 A `planning`, Q3 A all 9 now, Q4 A user-space PostgreSQL) and two main-session rulings under his away grant (Review 1 F4, Review 2 R2-2: notes and examples claim only what the body says and what was verified). Its Risks table holds the sibling-overlap resolution rules; its "Docs & records" task (B13) lists the records.
- **Evidence and history:** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/` (builder `INVENTORY.md`, `EVIDENCE.md`; `review-1/report.md`, `fix-1/report.md`, `review-2/report.md`, `fix-2/report.md`; `verifier/`, `auditor/`) and `/home/justin/.hermes/plans/leorna/evidence/86bcm901b-intake/` (verifier report, ac-check result). Out-of-scope items found along the way: `~/.hermes/plans/leorna/found-else.md` (entries tagged 86bcm901b).

## 1. Sibling conflicts (Justin: "Resolve those conflicts at hand-over")

Other sessions are working in this repo on **86bcm901a** (agent definitions), **86bcm901j** (MCP templates) and **86bcm901w** (pack builder). Never touch their worktrees, branches, databases or evidence; read their branches only.

1. Fetch GitHub `main` (fetch only; over HTTPS through `gh` if SSH is locked) and compare with `1ee7157`.
2. **If GitHub `main` has not moved:** there is nothing to merge yet. With read-only `git merge-tree --write-tree --name-only` against each sibling branch head (local or `origin/feat/86bcm901a-*`, `feat/86bcm901j-*`, `feat/86bcm901w-*`), list the files that would conflict. For each file, write the resolution in the hand-over: keep both sides' fields and flags in shared Go files; `delivery/stories.json`: take main's file and append this story's entry last, as text (the `leorna` skill's step 7.2 rule); `library.json`: the second to merge takes the next minor; `content.lock.json`: keep every line, compare by value; README and `curation.json`: keep both sections. Put the short version in the PR text's Assumptions.
3. **If GitHub `main` moved** (a sibling merged): merge `origin/main` into this branch (a merge commit, no rebase or force), resolving every conflict with the rules above so both stories' meaning is kept. Then re-run the full gates and AC1–AC4 on the new head, commit, and **stop with `status: head-changed`**, the new head SHA, the conflict list and how each was resolved. The main session then re-runs verifier → auditor → `ac-check.sh` on the new head before the hand-over continues. Don't do the hand-over pack on a head that hasn't been re-verified.

## 2. Evidence for the final head (`leorna` step 4b, `clickup-evidence.md`)

- The builder's screenshots show `78f13a7`. Re-capture **one screenshot per AC on `63afe55`** into the evidence folder (`ac1-third-party-content-63afe55.png` from the real admin page; `ac2-render-63afe55.png`, `ac3-requires-63afe55.png`, `ac4-gate-63afe55.png` as terminal captures of the AC runs; plus `gates-63afe55.png`). Use the builder's method (`EVIDENCE.md`, `builder-tools/`) and this desktop's Chrome recipe in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`.
- **AC1 needs a fresh database:** the builder's `leorna_86bcm901b_demo_test` loaded `78f13a7` and will refuse later heads at startup (`ErrChangedWithoutVersionBump` for `prompt/ship`, `build`, `constraints`, `webperf` 1.0.0). Create `leorna_86bcm901b_final_demo_test`, load `63afe55` into it, capture, then drop it. Leave the builder's databases alone.
- Inspect every image yourself before listing it: no URL bar, server domain, tenant ID, token, DB URL, password or email. Never attach a `.log`/`.txt` to the ClickUp draft: attach a screenshot of the log instead.
- Reconcile the AC → test → result → artifact inventory (in your own section of `INVENTORY.md`), naming what is owed (AC5 screenshots `ac5-review.png`, `ac5-spec.png` from Justin; hosted CI).

## 3. Hand-over pack (`leorna` steps 5–6)

Return all of this in your final message (and write the long texts as files in `~/.hermes/cache/scratch/leorna-pr-86bcm901b-prompts-collection.md` etc. if they're long):
- `git diff --stat 1ee7157..HEAD`, the key hunks, the gate results with exit codes, and `git diff --name-only 1ee7157...HEAD -- .github` (must be empty).
- **PR text** in Christian's plain style: Summary paragraph, one line per file/area, Test Plan with results (only what ran on this exact head), Assumptions (sibling conflicts, `requires` read by 901w later, Codex skipped, `/planning` name, AC5 owed, hosted CI not yet run, the follow-ups). Control-plane extras: ClickUp link, security/migration/rollback notes, an Evidence block (head SHA, required check "Go quality gates", Actions run URL to fill in after a PR). Before writing Assumptions, grep sibling PR texts (`~/.hermes/cache/scratch/leorna-pr-*.md`) and open PRs for this card's ID.
- **Review prompt** for a fresh agent, in `review-prompt-for-agent.md`'s format.
- **ClickUp evidence draft** per `clickup-evidence.md`: WHAT WAS DONE / WHAT WAS VERIFIED with an AC → test → result table, gates, CI (NOT VERIFIED until a PR), the live AC5 (owed to Justin), and the list of image files to attach.
- **Team message** draft (`story-done-team-message.md`), to send only after merge.
- **Records:** the plan's "Docs & records" task (B13). Commit any repo record it still needs on the branch (`docs(86bcm901b): …`). Don't edit memory notes yourself: return a ready-to-paste dated status line for `leorna-workflow.md` (branch, head, not pushed, no PR, AC5 owed, sibling conflicts) and the main session applies it.
- `steps_for_justin`: AC5 live check; "push" / "make a PR" / "post" when he wants them; stop the story's PostgreSQL and delete `~/.cache/leorna-86bcm901b/` when the story is done.

## Boundaries

- No product change in this pass. If you find a real defect, don't fix it: stop with `status: stopped` and the evidence, so it goes back through a fixer and re-verification. A records-only commit is fine; after it, report the new head and confirm `git diff --name-only 63afe55..HEAD` lists only record files.
- Let git use the repo identity (`Justin Issa <justin@leorna.com>`); never `-c user.*`, `--author` or AI attribution lines. Never commit a `CLAUDE.md`. The worktree must end clean.
- **Environment:** `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`; PostgreSQL 18.6 on 127.0.0.1:55400 (`pg/pg.env`, `pg/password`); databases only `leorna_86bcm901b_final_*_test`, dropped after; never print the password or a DB URL.
- **Shell gotcha:** `grep` here is Claude Code's ugrep wrapper (skips gitignored and binary files; bounded repeats fail): use `command grep`.
- Never touch the main checkout at `~/Leorna/leorna-control-plane` beyond a fetch.
- Scratch: `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-finisher/`, created fresh with `mkdir` (no `-p`); never touch other folders there; remove yours at the end.
- You can't ask Justin anything and can't start other agents. Rulings: "My ruling, not yet confirmed" in `rulings[]` and your `INVENTORY.md` section.
- Claude Code refuses report files from subagents: return the report as your final message (PR text and drafts may be files in `~/.hermes/cache/scratch/`).
- Other bugs: `found_else`. Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` (an empty list is normal) and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{status: ready|head-changed|stopped, summary, head, base, main_moved, sibling_conflicts[{sibling, files[], resolution}], diff_stat, gates[{name, exit}], shots[], evidence_inventory, evidence_owed[], pr_text_path, review_prompt_path, clickup_draft_path, team_message_path, workflow_status_line, steps_for_justin[], rulings[], stop_reason, found_else[], skill_lessons[]}`.
