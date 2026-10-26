# FINISHER brief (hand-over): Leorna story 86bcm945u "upstream-sync" (Full pipeline)

Dispatched 2026-10-24. Model: Opus 5.5, effort xhigh. A fresh agent.

**Verified clean under the recorded acceptance contract: run only the project's finish step.** `ac-check.sh` printed `ALL ACCEPTED: 7 of 7 ACs on 73edc52` (verifier and blind auditor agreed; base `6e74ced`). There are no `(live)` ACs, so nothing is owed to Justin for acceptance.

## Your role

You are the **FINISHER** for ClickUp card `86bcm945u`, "Upstream content sync + licence attribution". Do the `leorna` skill's hand-over: steps 5 and 6, plus step 4b's finisher evidence work. **Never push, never open a PR, never write to ClickUp, never touch a server.** Justin is away. He asked for the pipeline to run through to the hand-over, and publishing waits for his own "push", "make a PR" or "post".

**Change nothing in the repo.** The accepted head is `73edc52`, and any new commit would void the acceptance. If you find something that truly needs a code change, stop with `status: stopped` and describe it; don't commit.

## Skills to load first (with the Skill tool), in this order, and say so in your first steps

1. `leorna` (FINISHER role: step 4b finisher evidence, step 5 stop-and-show, step 6 hand-over; and its topic notes `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md`, plus `~/Leorna/leorna-control-plane/delivery/README.md`, under `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`).
2. `engineering-best-practices`.
3. `git-commit-rules` (read-only checks of authorship and branch state).

## Inputs

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync`, branch `feat/86bcm945u-upstream-sync`, **head `73edc52abd4608923428ff7590dc3259abc60129`**, base `6e74ced843642439d1dac9f25673440fb0f285f5` (= `origin/main` when last fetched). 21 commits, all `Justin Issa <justin@leorna.com>`, not pushed.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md` (Justin's answers: Q1–Q5 all A; AC6/AC7 approved; his standing "keep it going" grant).
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcm945u/`:
  - `INVENTORY.md`, with the builder, Fix 1 and Fix 2 sections;
  - the builder's screenshots and logs, taken on `9e31271`;
  - gate logs on `73edc52`: `gates-73edc52.txt` / `.json`, `story-tests-73edc52.txt`;
  - `review1/review1.md`, `review2/review2.md`, `fix1/`, `fix2/`;
  - `verifier/` and `auditor/`, each with its own AC logs and screenshots on `73edc52`, plus `ac.json`.

## What to produce (all in `~/.hermes/plans/leorna/evidence/86bcm945u/handover/`)

1. **Stop and show** (`leorna` step 5): `git diff --stat origin/main..HEAD` (or `6e74ced..HEAD` if `origin/main` moved; say which), the key hunks, the gate results from the logs (open each one and read its exit code), and the `.github/` path list (must be empty).
2. **PR text** (`pr-text.md`) in Christian's plain style: a Summary paragraph, one line per file or area, a Test Plan with results on `73edc52`, and a short Assumptions list. As a control-plane PR it also needs the ClickUp link, security / migration / rollback notes, and an Evidence block (head SHA; the "Go quality gates" check and the Actions run URL are **not run yet**, because nothing is pushed; say so, never invent them). The Test Plan lists only checks that actually ran on `73edc52`, per the logs.
3. **Review prompt** (`review-prompt.md`): a self-contained prompt for a fresh agent, in the format of `review-prompt-for-agent.md`.
4. **Team message** (`team-message.md`): drafted per `story-done-team-message.md`, marked "send after merge".
5. **ClickUp evidence draft** (`clickup-comment.md`), per `clickup-evidence.md`: the closing comment with WHAT WAS DONE and WHAT WAS VERIFIED, an AC → test → result table for AC1–AC7, gates, CI (not run, not pushed), and NOT VERIFIED (CI, plus anything genuinely unexecuted). Then the attachment list.
6. **Attachments** (`upload/` plus `attachments.md`): **one screenshot per AC, taken on the final head `73edc52`.** Justin asked for a photo for every AC for the card.
   - Use a screenshot from `verifier/` or `auditor/`, or retake one, rather than the builder's `9e31271` captures.
   - Copy each chosen PNG into `upload/` as `ac<n>-<what>.png`, and name its source file in `attachments.md`.
   - Look at every image before it goes in. No server domain, real host in a URL bar, tenant ID, token, device code, email or password may be visible.
   - Add the redacted, upload-safe gate log for `73edc52` if you include a log. Grep every text attachment for DB URLs, emails and tokens.
   - **Exclude:** `plan-approved.md`, the original `gates-9e31271-acs-and-checks.txt`, `fix1/gates*.sh` and `fix2/gates.sh`, and anything else with a DB URL or email.
7. **Rulings for Justin** (`rulings.md`): every "My ruling, not yet confirmed", one line each with where it's recorded. Reviews agreed with all of them:
   - the builder's 8 (in its section of `INVENTORY.md`);
   - fixer 1's 6 (Fix 1 section and `fix1/`);
   - fixer 2's 3 (Fix 2 section and `fix2/`).
8. **Other things found** (`found-else.md`), one line each with severity:
   - **Planner:**
     - server Go-module licences missing from `THIRD_PARTY_NOTICES.md` (medium);
     - library items copied into tenant packs lose source and licence (medium);
     - card typos `scripts/skill-lint.js` → `scripts/lib/skill-lint.js` and `v0.6.13` → tag `0.6.13` (low).
   - **Builder:**
     - the installer version picks up an unrelated `portal-dist-*` tag in `scripts/dist.sh` (low);
     - `cmd/launcher/README.md` doesn't mention `--notices` (low).
   - **Verifier:** the Mac's disk was nearly full and a concurrent `go clean -cache` broke a gate run (host).
   - **Auditor:** the AC3 test fixtures don't exercise "each item against its own recorded commit"; the clause is covered by `TestDiffUsesEachTrackedItemsOwnCommit` (low).
   - **Follow-up cards to suggest:**
     - per-file attribution for synced files (Justin's Q5 A);
     - 901v's item view showing the source block.
9. **Docs & records:** follow the plan's Docs & records task, as far as it can be done without committing or pushing. Don't add `delivery/stories.json` yet: that comes after a PR exists. List what is still owed after a PR or merge.

## Rules

- No push, PR, ClickUp write, server work, commit or `.github/workflows/*` change. Leave the worktree clean at `73edc52`.
- Never put a server domain, URL, tenant ID or token in any hand-over file.
- Use `perl -pi`, not `sed -i`, for any redaction (BSD sed), then grep to confirm.
- **Other problems:** list in `found_else`.
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## What to return

`{status: ready|stopped, summary, head, diff_stat, gates (command → exit → log), handover_dir, pr_text_path, review_prompt_path, team_message_path, clickup_comment_path, attachments[{file, source, checked}], rulings_for_justin[], found_else[], owed_after_pr[], skill_lessons[]}`.

`ready` means the reviews, independent verification and every AC check are complete, and the hand-over files exist. CI not having run (because nothing was pushed) is listed under NOT VERIFIED, not hidden.

End the report with this exact line:
`MAIN SESSION: check and save these skill_lessons now.`
