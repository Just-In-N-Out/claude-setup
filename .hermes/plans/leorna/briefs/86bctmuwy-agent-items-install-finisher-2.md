# FINISHER brief 2 (hand-over refresh after bringing main in): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FINISHER, hand-over only (the `leorna` skill, Doing a story → step 6, plus step 5 "stop and show"). **No push, no PR, no ClickUp write, no merge** — Justin says "push" / "make a PR" / "post" himself later. **No new commits on the branch:** head `9e2d1cb48fafd600d666c00145ddf4f7e1532aa8` is the verified head; any commit would need a fresh review and re-verification. If something seems to need a code or test change, stop and report it instead.
**Model/effort:** Opus 5.5, high.
- WSL can restart and leave 0-byte files; check sizes and `EXIT=` lines before citing any file.

## Verified state
- Story: ClickUp 86bctmuwy, "Install Agent items into local Claude Code, Codex and Cursor tool directories".
- Worktree `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`, branch `feat/86bctmuwy-agent-items-install`, head `9e2d1cb`. Not pushed. Original base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`. GitHub main `f3bc96061c74510b4cd9f7a7ee0a14890f087441` (PR #30 managed config drift report and restore, PR #31 predefined integration tiles) was brought in by merge `1fa24d9` on 2026-11-09, so the base is now `f3bc960` (`git merge-base HEAD origin/main`).
- Pipeline: Full. Rounds 1–3 as before (clean at 5ed2103, verifier 1 and auditor 1 accepted 5ed2103). Then:
  - bring-main-1: merge `1fa24d9` plus fix `f6f957b`, because #30's restore called `finishRun` with the old signature;
  - review-4 (2 P2: R4-1 restore refused a whole tool, R4-2 drift report flipped to clean);
  - fixer 3, implementing Justin's decision 9 "Report + skip": `e34c8e8`, `44df083`, `556dba9`;
  - review-5 (1 P2, R5-1: a user's file at a path Leorna removed was read as Leorna's);
  - fixer 4, implementing decision 10 "Record removals": `9e2d1cb`;
  - review-6 clean, MOVE ON;
  - verifier 2 (Fable 5.2 high) clean;
  - blind auditor 2 (Opus 5.5 xhigh) clean.
  - `ac-check.sh --reviews` printed **`READY FOR THE USER: 12 of 13 ACs proven on 9e2d1cb; live ACs owed to the user: AC13`**.
- **AC13 (live) is owed to Justin:** he opens the Cursor editor and checks the synced agent shows in its subagent list. Steps: `~/.hermes/plans/leorna/evidence/86bctmuwy/builder/ac13-steps.txt` (update its head line to `9e2d1cb`; it must include the description case `Reviews a release: risks & "blockers"` from review finding R1-4).
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/`.
  - **Current receipts:** `verifier-2/` and `auditor-2/`, each with `ac.json`, per-AC head logs on `9e2d1cb`, base logs on `f3bc960` and PNGs.
  - **Superseded** (they cite older heads; don't use them as Test Plan results): the older `verifier/` and `auditor/` (for `5ed2103`).
  - Also: `bring-main-1/`, `builder/`, `fixer-1..4/`, `review-1..6/`, `follow-ups.md`, `finisher/` (your earlier hand-over, to refresh). Plan: `~/.hermes/plans/leorna/86bctmuwy-agent-items-install.md`.
- Justin's decisions: 1A 2A 3A 4A 5A; 6 = add AC12 (real Cursor CLI); 7a Cursor agents in `~/.cursor/agents`; 8a Cursor description one plain line, multi-line skipped. Decisions 9 and 10 are in the working plan, and his records are `bring-main-1/justin.json` and `review-5/justin.json`.
- Main's own bugs, found while reviewing how this story meets #30 and logged in `~/.hermes/plans/leorna/found-else.md` (2026-11-09 entries): restoring one tool takes the other tools off automatic updates; the Codex/Cursor restore baseline isn't bounded by the selection; a failed Restore's tool status. They belong in the PR as notes about #30, named by PR number, not as this story's work.
- Follow-ups to list (from `follow-ups.md`, including the 2026-11-09 entries: R5-2, R5-3, R6-1, R6-2, R6-3, the auditor's AC12 name gap): F1 control plane still says agents aren't installed; F2 nativewrite replaces unrecorded files at other kinds' paths; F7 Cursor reads `.claude/agents` and keeps quotes (tools names break); F8 re-run AC12 against `~/.cursor/agents` if a future CLI reads it; P3s R1-4, R2-2, R2-3, R3-1; auditor P3 (AC12 test doesn't assert the parsed name); T8 wording.

## Skills to load (say so in your first steps)
`leorna` (FINISHER, hand-over), `engineering-best-practices`, `git-commit-rules`. Read the shared memory notes `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md` and `leorna-workflow.md` (memory folder: `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/` or the `-home-justin-` one — use the real one, check for a symlink).

## Deliverables
Refresh your earlier hand-over files in place (same paths). Say in the PR text that main was brought in at `f3bc960`, and describe decisions 9 and 10 as part of the change. Per `leorna`, the ClickUp evidence is posted only after the PR is merged, so mark the draft that way.
1. **Stop and show:** `git diff --stat origin/main...HEAD` (three dots), key hunks summary, `git diff --name-only origin/main...HEAD -- .github` (must be empty), authorship check of the branch's own commits (`git log --format='%an <%ae>' HEAD ^origin/main` all `Justin Issa <justin@leorna.com>` — report it as "1 identity, Leorna OK", never print the address in evidence), no commit body matching `^co-authored-by:|generated with|noreply@anthropic|🤖` (case-insensitive). Re-fetch GitHub main over HTTPS through gh (leorna skill step 7.1) and report whether main moved since `f3bc960`; if it did, run `git merge-tree --write-tree --name-only HEAD origin/main` and report clean/conflicts. **Do not merge main in or rebase** — just report.
2. **PR text** in Christian's plain style (Summary paragraph, one line per file/area, Test Plan with only results run on head 9e2d1cb by verifier 2 and auditor 2 — cite their logs — and a short Assumptions list incl. CI gaps: AC4/AC5/AC12 real-tool tests skip in CI unless the `LEORNA_TEST_*_BIN` vars are set). Name other stories by title/PR number, never bare card IDs. Save to `~/.hermes/cache/scratch/leorna-pr-86bctmuwy-agent-items-install.md` (body only, no `Title:` line; put the proposed title `feat(86bctmuwy): …` in your report).
3. **Review prompt** for a fresh agent, in the `review-prompt-for-agent.md` format, saved to `~/.hermes/cache/scratch/leorna-review-prompt-86bctmuwy.md`.
4. **ClickUp evidence draft** per `clickup-evidence.md`: closing comment text (WHAT WAS DONE / WHAT WAS VERIFIED with an AC → test → result table, gates, CI run = not yet (not pushed), AC13 NOT VERIFIED / owed to Justin) and the attachment list: one PNG per AC (images only, never .log/.txt; prefer the verifier's or auditor's per-AC PNGs plus the builder's real UI captures where they show more, e.g. `ac6-sync-panel-warnings.png`), a gates screenshot. Open every log you cite and read its `EXIT=`; inspect every PNG visually for emails, URLs, tokens, tenant IDs, home paths with the username where avoidable. Save the draft to `~/.hermes/cache/scratch/leorna-clickup-86bctmuwy.md`. **Don't upload or post.**
5. **Records** (the `skill_lessons` rule covers skills and lessons only; this dated story-status line in the shared notes is part of your job): update `leorna-workflow.md` with a dated status line for this story (branch, head, not pushed, ac-check result, AC13 owed, follow-ups), following the note's own style; update `ac13-steps.txt` head. Add `CLAUDE.md` to the worktree's `.git/info/exclude` if it exists and isn't there.

## Rules
- Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor` (beyond editing the memory notes named above).
- Don't run the full gates again (the verified receipts stand); a command you do run that dies with SIGTERM/143/137 may be earlyoom — check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`.
- WSL PATH has entries with spaces: export PATH in scripts.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: code-reviewed; live acceptance pending (AC13), head_sha, main_moved{now, merge_tree}, diff_stat, github_paths, authorship, pr_title, pr_text_path, review_prompt_path, clickup_draft_path, attachments[], records_updated[], found_else[], skill_lessons[]}` plus the PR text and ClickUp comment inline (short), ending with `MAIN SESSION: check and save these skill_lessons now.`
