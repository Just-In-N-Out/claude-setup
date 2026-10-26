# FINISHER brief: 86bcm9019-curate-skills [leorna], hand-over only

**Role:** fresh FINISHER for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). It was **verified clean under the recorded acceptance contract**. **Run only the project's finish step:** the `leorna` skill's "Doing a story" step 5 (stop and show) and step 6 (hand-over).

**Never push, open a PR, merge, post to ClickUp, or change the card.** Justin says "push", "make a PR" or "post" himself, and each word authorizes only itself.

## Skills to load first (say so in your first steps)

1. `leorna`, FINISHER role. Read its notes `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md` and `clickup-evidence.md` in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`, plus `~/Leorna/leorna-control-plane/delivery/README.md`.
2. `engineering-best-practices`.
3. `git-commit-rules`, only to check authorship. You should make **no commit**.

## The accepted candidate

- Worktree: `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills` (no upstream; nothing pushed).
- **Accepted head: `eab394045b08df247acb23b3a85f109bf02d1a4c`** (25 commits). **Base: `57783506979ae1d721b8ed9539f2b3193ed992c7`** (origin/main; confirm GitHub main with `git ls-remote` over HTTPS through gh, without fetching, and report if it moved).
- **Acceptance:** `ac-check.sh` printed `READY FOR THE USER: 5 of 6 ACs proven on eab3940; live ACs owed to the user: AC6`. That came from verifier 2 (`evidence/86bcm9019/verifier/ac.json`) and the blind auditor (`evidence/86bcm9019/auditor/ac.json`).
- **Don't change the head.** If anything seems to need a commit, stop and report it: a new commit voids the acceptance.

## Inputs to read

- Working plan: `~/.hermes/plans/leorna/86bcm9019-curate-skills.md`. Read its `## Justin's answers`: all ⭐ A–H, plus the R1-4, `npx vercel`, R2-1, `npx tsc` and V2-1 rulings, and the Acceptance line. Approved copy: `evidence/86bcm9019/plan-approved.md`.
- Evidence, all under `~/.hermes/plans/leorna/evidence/86bcm9019/`:
  - `builder/`, `review-1/`, `fix-1/`, `review-2/` (its `review-2.json`), `fix-2/`, `fix-3/`;
  - `verifier/` (gate log `gates-eab3940.txt` and AC1–AC5 screenshots on `eab3940`);
  - `auditor/` (AC1–AC5 screenshots on `eab3940`);
  - `ac6-install/` and `ac6-checklist.md`.
- Things found during the story, out of scope: `~/.hermes/plans/leorna/found-else.md`, the 2026-10-25 lines tagged 86bcm9019.

## What to produce (in `~/.hermes/plans/leorna/evidence/86bcm9019/handover/`)

1. **`stop-and-show.md`:**
   - `git diff --stat 5778350..eab3940`, plus the key hunks summarised: the gate change, the review record and `library-upstream adaptation`, the imports, the 3 adaptations and the demo skills;
   - the gate results on `eab3940`, from verifier 2's `gates-eab3940.txt` (open the log and read its exit codes before citing it);
   - `git diff --name-only 5778350...eab3940 -- .github`, which must be empty;
   - authors only `Justin Issa <justin@leorna.com>`, no AI lines.
2. **`pr-text.md`:** Christian's plain style:
   - **Summary:** a paragraph, then one line per file or area;
   - **Test Plan:** only what ran on `eab3940`, with results, and the env-gated network tests named;
   - **Assumptions:** a short list. Before writing it, grep the sibling PR texts `~/.hermes/cache/scratch/leorna-pr-*.md` and the open PRs for this card's ID (`gh pr list -R LeornaAI/leorna-control-plane --search 86bcm9019 --state open`). The Assumptions must name:
     - **V2-1:** the follow-up on the shipping-and-launch note, per Justin's ruling;
     - the `gitCommand` env pass-through (945u);
     - the unpinned `npx` in the `github-mcp` mcp_template;
     - the replaced demo skills staying in the seed and in existing catalogs (86bcm901r);
     - the upstream agent `code-reviewer` name clash for 86bcm901a;
     - the ADR 0002 Tier-2 evals revisit now being due;
     - an upstream issue for `npx lhci` / `npx migrate-check` as a possible next step, which is Justin's call;
     - that the card's "quality-gate CI run" happens only on the PR;
   - **Control-plane extras:** the ClickUp link, security, migration (none) and rollback notes, and an Evidence block with the head SHA. Mark the check "Go quality gates" and the Actions run URL as **pending until "make a PR"**.
3. **`review-prompt.md`:** a self-contained review prompt for a fresh agent, in the `review-prompt-for-agent.md` format.
4. **`clickup-comment.md` + `attachments.md`:**
   - the closing-comment draft in the `clickup-evidence.md` format: WHAT WAS DONE / WHAT WAS VERIFIED, with an AC → test → result table for AC1–AC5 on `eab3940`; the gates; the CI run as NOT VERIFIED (pending the PR); **AC6 NOT VERIFIED, owed to Justin**;
   - the attachment list: **images only, never `.log`/`.txt`**. For each AC1–AC5 pick the verifier's or the auditor's `eab3940` screenshot, plus a screenshot of the gate log. If no gate-log image exists on `eab3940`, take a real Terminal capture of `verifier/gates-eab3940.txt` being displayed (the command, the pass lines, the `EXIT=` line), following the `leorna` terminal capture recipe. Save it into `handover/`, check `CGSSessionScreenIsLocked` first, and if the screen is locked, list the image as owed rather than faking it;
   - **inspect every image visually:** no server domain, URL bar, tenant ID, token or email may be visible.
5. **`team-message.md`:** the short "story done" message in the `story-done-team-message.md` format, to send after merge.
6. **`ac6-for-justin.md`:** one short page of numbered steps from `ac6-checklist.md` for Justin's live AC6 check (3 skills × Claude Code, Codex, Cursor):
   - which rendered folder to copy where, and how to remove it afterwards;
   - the prompt to try in each tool;
   - what "passes" looks like;
   - the screenshot names to save (`ac6-claude-code.png`, `ac6-codex.png`, `ac6-cursor.png`);
   - the `~/.claude/skills/test-driven-development` name-clash warning.

   Don't copy anything into his real tool homes yourself.
7. **`README.md`** in `handover/`: the AC inventory (AC → test → result → image), what's owed to Justin and in what order, and the remaining stage, in plain words. The order: AC6 live check → "make a PR" (gates rerun on the exact head, push, PR, then the `stories.json` PR number as a separate later commit) → hosted CI run → he merges → `check-story-shippable.py 86bcm9019` → team message → "post" the ClickUp evidence.

## Rules

- Read-only on the repo: no commit, no push, no PR, no ClickUp write. Write only into `handover/`. Keep scratch in the scratchpad's `finisher-86bcm9019/` subfolder and remove only that.
- Never put a server domain, URL, tenant ID or token in any hand-over file.
- Your status: `ready` only if nothing is owed. Here AC6 is owed, so return `status: "code-verified; live AC6 and PR/CI pending"`.
- If you find a problem, list it in `found_else`. If you learn something reusable, don't edit skills or memory: list it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section. An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{status, head, base, github_main, handover_files[], ac_inventory[{ac, test, result, image}],
 owed_to_justin[], images_inspected, found_else[], skill_lessons[]}
```
