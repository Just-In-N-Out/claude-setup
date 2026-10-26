# 86bcm9019-curate-skills [leorna]: orchestration plan

## Context

The card is [Curate the skills collection](https://app.clickup.com/t/86bcm9019): PI-2, E10 Content Library, Size L, p1-high, assigned to Justin, status "to do". It asks for:
- an import of all 25 skills from addyosmani/agent-skills (MIT, v0.6.13, commit `aeac41d4d005`) into the Leorna content library;
- a review of each skill (owner named), with Leorna adaptations recorded as diffs against upstream;
- a security and Windows review of bundled scripts (`idea-refine.sh`);
- a pass through the content quality gate for Claude Code, Codex and Cursor;
- replacement of the 3 demo skills.

ClickUp shows all four dependencies complete: 86bcm9018 loader, 86bcm901u quality gate, 86bcm945q multi-file items, 86bcm945u upstream sync and licence. The card already has 5 ACs; they aren't numbered yet. The card says "Repo: content" and leaves the exact repo to the planner.

**Pipeline: Full** (Justin picked it 2026-10-25). Every role is a fresh `general-purpose` agent with `model: "opus"` and `effort: "xhigh"`. The main session only orchestrates: it writes briefs, dispatches agents, shows results, records answers and runs `ac-check.sh`.

## Steps the main session runs after this plan is approved

1. **Write the planner brief** to `~/.hermes/plans/leorna/briefs/86bcm9019-curate-skills-planner.md`, then dispatch the PLANNER, which runs in the background. The brief contains:
   - Its role (PLANNER, plan only: no worktree, branch, code or commit) and the skills it loads, in order: `leorna` (in PLANNER role, which includes the Step 1 context load), `engineering-best-practices`, `implementation-planning`, plus whichever specialists it judges necessary (for example `security-best-practices` for the script review, or `api-contract-drift-guard` if OpenAPI changes).
   - The card text verbatim, with Justin's words below it ("Ok need to do this user story it is on clickup Curate the skills collection").
   - The output path `~/.hermes/plans/leorna/86bcm9019-curate-skills.md`. The plan must contain:
     - questions at the top, lettered, with ⭐ on the recommended option;
     - the card's 5 ACs numbered AC1–AC5, each with one named test. Any added AC is marked **proposed**, and `(live)` goes right after the id for anything only Justin can check (the card's Verify includes a "manual check of 3 sampled skills in each tool");
     - tasks, touched files, risks, and evidence capture per AC (`ac<n>-*.png`, `gates-<sha7>.txt`);
     - a **Docs & records** task.
   - Routing facts it must verify itself, not trust:
     - the dependencies show complete in ClickUp, but the notes say 901u's PR #90 was still open on 2026-10-24. Check what is actually on `origin/main` in each repo before planning on top of it;
     - say which repo or repos the "content" library lives in;
     - check overlap with sibling cards 86bcm901b (prompts collection, to do) and 86bcm901r (starter packs, which depend on this card).
   - The standard lines: `found_else`, the `skill_lessons[{skill, lesson, evidence}]` rule (never edit skills or memory), and the report ending with `MAIN SESSION: check and save these skill_lessons now.` if lessons are listed.
   - Output schema: `{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}`.
2. **When the planner returns:**
   - check that the plan has numbered ACs (if not, it goes back to the planner);
   - check and save any skill lessons;
   - show Justin the questions, at most 3 one-line facts, any proposed ACs and every `(live)` AC;
   - **stop until "go"**.
3. **On "go":** `mkdir -p ~/.hermes/plans/leorna/evidence/86bcm9019 && install -m 444 <plan> <evidence>/plan-approved.md`. Then:
   - BUILDER on `feat/86bcm9019-<desc>` from updated main: test-first, one test and one screenshot per AC, stops at `ready-for-review`;
   - fresh reviewer 1 → fixer → fresh reviewer 2 → fixer (`review-fix-cadence`);
   - VERIFIER → blind AC AUDITOR → `ac-check.sh`, looping until `ALL ACCEPTED` or `READY FOR THE USER`;
   - FINISHER hand-over per `leorna`: diff, PR text, review prompt, ClickUp evidence draft. It never pushes, never posts, never merges.

Every brief is saved under `~/.hermes/plans/leorna/briefs/86bcm9019-curate-skills-<role>.md` before its dispatch.

## Verification

- The plan file exists, has AC1–AC5 with named tests, and has its questions at the top. The main session checks this before showing it to Justin.
- The final gate is `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base <merge-base with origin/main> --plan <evidence>/plan-approved.md <evidence>/verifier/ac.json <evidence>/auditor/ac.json`. Its last line decides the finish.
