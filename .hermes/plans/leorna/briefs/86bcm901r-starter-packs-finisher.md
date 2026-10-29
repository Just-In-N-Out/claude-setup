# FINISHER brief (hand-over): 86bcm901r-starter-packs [leorna]

**Role:** FINISHER for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). The story is **verified under the recorded acceptance contract**: run **only the project's finish step**, the `leorna` hand-over (Doing a story → steps 5 and 6, plus 4b's evidence reconciliation). **Never push, open a PR, merge, or post to ClickUp**: Justin says "push", "make a PR" and "post" himself, each word authorizing only itself.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac.

## Where things stand

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`, **local only** (never pushed; no PR).
- **Accepted head:** `398af64906adc26726f79cae81ce4d00355b7092`. **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (GitHub `main` at every check so far).
- **`ac-check.sh` result on `398af64`** (verifier + blind auditor): `READY FOR THE USER: 4 of 5 ACs proven on 398af64; live ACs owed to the user: AC4`. AC1, AC2, AC3, AC5 ACCEPTED; AC4 NOT VERIFIED (live: Justin checks it).
- **Do not move the head.** No commit, rebase or merge on the branch in this pass: the acceptance is pinned to `398af64`. If you find anything that needs a source or test change, stop with `status: stopped` and describe it; don't fix it. Your writes go to the evidence folder, the hand-over files and the memory notes only.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (approved 2026-10-29 under Justin's away grant, every ⭐: Q1–Q6 A). Its "Notes for later roles" → Finisher, "Docs & records", "Follow-ups" and "Risks" sections list what the hand-over must carry.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901r/` (top level = builder/fixers' files, plain names mean `398af64`; `INVENTORY.md`; `reviewer1/`, `fixer1/`, `reviewer2/`, `fixer2/`, `verifier/`, `auditor/`). Put the hand-over pack in `hand-over/` there.

## Pipeline history (for the PR text and evidence draft)

Builder (`aa57092`) → reviewer 1: F1–F7, none critical/major → fixer 1 (`08dac8d`): F1–F5, F7 fixed, F6 declined → reviewer 2: R2-1 minor, R2-2 nit, every fixer-1 disposition and ruling agreed → fixer 2 (`398af64`): both fixed → verifier: **clean**, every finding closed by its own mutant, nits N1, N2 → blind auditor: **clean** → `ac-check.sh`: READY FOR THE USER.

**Rulings "not yet confirmed" (Justin hasn't seen them; list each under the PR's Assumptions, plain words):**
- Builder: AC2 reads desktop responses past the test helper's 64 KiB cap (16 MiB bound); AC2 compares each served item with the shipped library item; AC5 also forces a failure at the last pack (proves one transaction); the lock-wait test uses its own pool and `application_name`; the Starter packs table keeps Kind and Version on one line (CSS); a README clause about the AC2 comparison.
- Fixer 1: F4 adds `StarterLoadResult.Older` (an older binary is logged at info, not as "bump library.json"); F5 a rename is released like an item change (next library release); F3 the advice reads "restart the control plane to retry".
- Fixer 2: the role is capped at 32 characters (so `starter-<role>-<n>` fits the 50-character version id to version 999,999,999); a version that fails the load's own check stops with `check <role> version <n>` and no restart advice; migration 24 was edited in place (never on main or GitHub).
- ⭐ answers that touched a recorded decision (flag them): **Q1 A** adjusted the card's "to confirm" mapping (`/plan` ships as `/planning`; prompts' required skills added); **Q4 A** left the old single starter seed unchanged again (follow-up for 86bcm902a or its own card).

**Follow-ups (Assumptions / follow-up list):** F6 move `main.go`'s startup loads into a tested helper (wiring is proven by the real binary, and the verifier's mutant binaries); N2 the library page loads each starter item's full body and files just to show kind, name and version (small, admin only); the pre-existing doubled wording "pack pack version is invalid: invalid organization request" (`internal/pack/pack.go:191-194, 261-262`); nothing forces a `library.json` bump when an item changes, so a forgotten bump holds starter updates with a warning; the Pack Assignments dropdown grows with every new starter version (hide superseded ones); agents install in no tool yet and prompts are skipped in Codex (page and AC4 checklist say so); govulncheck's informational "1 vulnerability in modules you require, but your code doesn't appear to call" predates this branch (`go.mod`/`go.sum` untouched); the seed refresh (Q4).

**Fix N1 (evidence only, not source):** `ac4-live/CHECKLIST.md` says a database that ran the earlier migration 24 "keeps the old 64-character check". The verifier proved it actually refuses to start with `migration 24 checksum mismatch` (`verifier/migration24-validation-398af64.log`). Correct that sentence; the "use a fresh database" advice stays.

## What to produce (the `leorna` skill's steps 5, 6 and 4b; read `$MEM/stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md` and `~/Leorna/leorna-control-plane/delivery/README.md` first)

1. **Stop and show:** `git diff --stat 6c1709e...398af64` (three dots), the key hunks, `git diff --name-only 6c1709e...398af64` with no `.github/` path, the gate results from the verifier's and auditor's `gates-398af64.txt` (open each log and read its exit code before citing it).
2. **Integration check (read only):** GitHub `main` now (`gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`); if it moved, `gh api …/compare/6c1709e...<sha>` file list against this branch's files, and `git merge-tree --write-tree --name-only` against it after a read-only HTTPS fetch through gh (`leorna` step 7.1's command). Open sibling PRs (`gh pr list -R LeornaAI/leorna-control-plane --state open`): for PR #98 (86bcm901j) fetch `pull/98/head` read-only and check `git rev-parse FETCH_HEAD` equals `gh pr view 98 --json headRefOid` before trusting it, then `git merge-tree` this head against it and against main (the plan expects conflicts in `delivery/stories.json` and `internal/library/README.md`; say how each resolves per `leorna` step 7.2). Never touch the main checkout or another story's worktree.
3. **PR text** in Christian's plain style, body only (no `Title:` line; give the title separately as `feat(86bcm901r): role-based starter packs`): a Summary paragraph, one line per file/area, a Test Plan with what ran on which head (name `398af64`; only receipts that exist), Assumptions (the rulings, flags and follow-ups above), the ClickUp link, security, migration and rollback notes (migration 24 up/down, the fix-forward case, the checksum behaviour), and an Evidence block (head SHA; CI run "not yet: branch not pushed"). Grep sibling PR texts (`~/.hermes/cache/scratch/leorna-pr-*.md`) and open PRs for `86bcm901r` first: siblings may have recorded follow-ups this story triggers or closes (e.g. 86bcm901b's "each pack that holds a prompt holds its requires"). Save it to `~/.hermes/cache/scratch/leorna-pr-86bcm901r-starter-packs.md` and a copy in `hand-over/pr-body.md`.
4. **Review prompt** for a fresh agent, in the format of `review-prompt-for-agent.md` → `hand-over/review-prompt.md`.
5. **ClickUp evidence draft** (`clickup-evidence.md` format) → `hand-over/clickup-comment.md`: WHAT WAS DONE / WHAT WAS VERIFIED with an AC → test → result table, gates, CI (not yet), the live run (AC4 NOT VERIFIED, owed to Justin), and the list of **image** files to attach (one per AC from the verifier's or auditor's own folders or the top level, plus a gates image; never a `.txt` or `.log`). Open every image you list (bands ≤ 1,300 px for tall ones) and grep its text source for emails, URLs, domains, tenant IDs and tokens; nothing private may show. Upload nothing.
6. **Team message** (`story-done-team-message.md`) → `hand-over/team-message.md`, marked "send after merge".
7. **AC4 for Justin** → `hand-over/ac4-steps.md`: the checklist's steps in short form (his own test server installed from `feat/86bcm901r-starter-packs` at `398af64` in local image mode on a fresh database, desktop app from client `main` ≥ `f105e27`, a throwaway project because Sync writes into his real `~/.agents/skills` and `~/.cursor`).
8. **Records:** reconcile `INVENTORY.md` (AC → test → receipt → image, per head; planned filenames are not evidence), and add the story's state to `$MEM/leorna-workflow.md` (branch, head `398af64`, not pushed, no PR, READY FOR THE USER on 2026-10-29, AC4 owed, follow-ups) as a dated status line, plus `MEMORY.md`'s one-liner if its summary changes. `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`. Don't edit skills.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FINISHER role; skip its Step 1 full context load; read the topic notes named above).
2. `engineering-best-practices`.
3. `receiving-code-review` (to reconcile every finding's disposition in the PR text) and `git-commit-rules` (read-only here: no commits in this pass).
4. `github` (for the read-only `gh` checks).

## Rules

- Scratch: `~/.cache/86bcm901r-finisher/` for any fetch or merge-tree work trees, made fresh with `mkdir` (no `-p`); nothing big on `/tmp`. Remove it at the end by its literal path. No databases needed; don't create any.
- You can't ask Justin anything.
- Never write server domains, URLs, tenant IDs or tokens into the PR text, comment or team message.
- If you find any other bug or problem, list it in `found_else` (one line each, evidence, severity); don't fix it.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory rule file for it: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{name, status: ready|stopped, stage, summary, head, base, diff_stat, github_main, integration[{against, result, conflicts[]}], pr_title, pr_body_path, review_prompt_path, clickup_comment_path, attachments[], team_message_path, ac4_steps_path, steps_for_justin[], follow_ups[], records_updated[], found_else[], skill_lessons[]}`. `status`, `stage` and `summary` are required. `stage` names exactly where the story stands (e.g. "verified locally; AC4 live owed; not pushed"). Plain words.
