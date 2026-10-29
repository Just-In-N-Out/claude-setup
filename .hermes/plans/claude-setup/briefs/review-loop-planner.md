# Brief: PLANNER, story `review-loop` (pipeline size: your recommendation)

## Role
You are the **planner** for Justin's setup story `review-loop`. You write the plan only. You do **not**:
- edit `~/.claude/*`, hooks, `settings.json`, skills, scripts or the setup repo;
- push, or start other agents.

Investigate read-only, run small probes in a temp folder, and write the plan file.

**Live guards since 2026-10-29.** `git-guard.sh` checks every Bash call, and the global git hooks (`~/.claude/githooks`) check every commit. A deny is the guard working; don't work around it. Probe git behaviour through a script file in a temp `HOME`.

## Skills to load first
- `engineering-best-practices`
- `implementation-planning`

There's no project skill: this is Justin's own setup.

Read as a guide:
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`, `references/mini-pipeline.md` and `references/ac-verification.md`;
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` and its test `ac-check.test.sh`;
- the `review-fix-cadence` skill (`~/.hermes/skills/software-development/review-fix-cadence/`);
- the "Bugs and Stories" pipeline in `~/.claude/CLAUDE.md`;
- the last two setup stories' plans, `~/.hermes/plans/claude-setup/harness-guards.md` and `codex-parity.md`, for how setup stories are built, tested and merged (worktree `~/.claude-setup-wt/<name>`, evidence `~/.hermes/plans/claude-setup/evidence/<name>/`, `ac-check.sh --repo/--base`).

## Justin's request (2026-10-28 / 29), as agreed in conversation
**Problem.** The pipeline does exactly two review rounds (reviewer → fixer, reviewer → fixer) and then stops reviewing. Code from later fix rounds gets only AC checks from the verifier and auditor, never a fresh review. In story `harness-guards`, the code from fix rounds 2–4 went unreviewed until the main session added a third review by hand. A fixer also found two real bugs by luck. Justin: *"I want to keep it looping until there are no bug errors found and all acceptance criteria are met."* Later: *"help out a ton, but isn't going to be infinite."*

**The rule** (written today as the memory note `~/.claude/projects/-home-justin/memory/review-loop-until-clean.md`; read it):
- review → fix repeats until a fresh reviewer's review is **clean**;
- **clean** means no P0, P1 or P2 finding;
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work;
- **P2:** a bug a real person or agent could plausibly hit, including realistic edge cases (inputs, configs, git operations, macOS and WSL), anything that breaks an AC or the UI, or a test that can't fail;
- **P3:** cosmetic, docs, a hole only a deliberate evasion would hit, or a setup none of Justin's machines has. P3s go on the story's follow-up list.
- **Brakes, so it always ends:**
  - (a) every P0–P2 finding must name a concrete real-use scenario, and with no scenario it is P3;
  - (b) review 3 onward covers only the fix commits since the last review and what they touch;
  - (c) if a round finds no fewer P0–P2 findings than the round before, stop and ask Justin;
  - (d) the same finding twice with no new fact → ask Justin.
  - There's no fixed round cap.
- **Order:** verifier → blind auditor → `ac-check.sh` only after a clean review. Any fix after that (a NOT ACCEPTED round or a verifier finding) gets a fresh review of that fix before re-verifying.

**What to build** (three parts, all in this story):
1. **Rule text.** Write the rule into:
   - `~/.claude/CLAUDE.md` pipeline steps 5–6;
   - feature-dispatch `SKILL.md` (Full) and `references/mini-pipeline.md` (Mini: decide how the loop applies there; recommend);
   - the `review-fix-cadence` skill and `ac-verification.md`.

   Codex picks it up through the generated `~/.codex/AGENTS.md`; never edit that file. Also check the codex `pipeline-*.toml` roles.

   feature-dispatch `SKILL.md` is about 98,157 characters, against Hermes' 100,000 limit. Plan to move a section into `references/` rather than append.

   Once the rule is in CLAUDE.md, the memory note becomes a duplicate. Plan to delete it or shrink it to a pointer.
2. **The round referee: a new script,** a review-round counterpart to `ac-check.sh`.
   - **Input:** each reviewer's structured findings (define the format, e.g. `<evidence>/review-<n>/review.json` with the head reviewed, and findings with id, severity, scenario, file_line). The previous rounds' files give it the history.
   - **Output, as the last line:** one of `REVIEW AGAIN` (with the P0–P2 list to fix), `MOVE ON` (clean, so the verifier runs next) or `ASK JUSTIN` (with the reason).
   - **The brakes are applied mechanically:**
     - a P0–P2 finding with no scenario is treated as P3;
     - a round with no fewer P0–P2 than the last → ask;
     - the same finding id or fingerprint twice with no new fact → ask.
   - Decide how "the same finding" is matched. Recommend one way.
3. **`ac-check.sh`: reviewed-head check.** It refuses acceptance when the head has commits not covered by a clean review, i.e. the last `MOVE ON` review's head is not the accepted head, or the commits after it weren't reviewed. Design how it learns this, e.g. from the review records. Keep `ac-check.sh`'s existing behaviour and tests green.

**Out of scope** (Justin passed on it): a runner that resumes the loop by itself, a per-story budget, receipts.

## Facts and lessons from the last story to use
- **Regression AC:** before writing an "existing suites pass" AC, run those suites on the base and record the tally in the plan. In harness-guards, an older story-time pin already failed on base.
- **Pins:** keep story-time pins ("file unchanged since base", exact file counts) out of a suite's default run; make them run only when named.
- **Moving `main`:** the setup repo's `main` moves every few minutes from other sessions' `sync.sh` commits. For harness-guards, Justin allowed a final base-only rebase to merge without another verifier/auditor round (the "Setup repo" line in feature-dispatch's merge policy). Put a question in the plan, "Reuse that base-only merge rule for this story?", with your recommendation.
- **Desktop environment:**
  - `/tmp` is a shared 7.9 GB RAM tmpfs, so agents point `TMPDIR` at `~/.cache/<story>-<role>/`;
  - the git hooks skip repos inside `$TMPDIR` and system temp folders;
  - coreutils are uutils (use `tail -n N`, and give `touch -d` an explicit offset);
  - in the Bash tool, `grep` is ugrep, so use `command grep`.

## Pre-approval
Justin pre-approved this story: *"make a plan agent and then go for it."* The plan is approved with your recommended option on every question, Full vs Mini included, so write it as if the recommended options were chosen. The main session still lists the ACs and any `(live)` ACs to him.

## Requirements for the plan
- **File:** save it to `~/.hermes/plans/claude-setup/review-loop.md`.
- **Order:** open questions right after the title, each option lettered with the recommended one marked ⭐.
- **Contents:**
  - playback;
  - approach;
  - **numbered ACs AC1, AC2…, marked proposed**, each with one named test, whole on one line, and `(live)` right after the id for one only Justin can check;
  - tasks, touched files and risks;
  - a **Docs & records** task.
- **Tests:**
  - bash suites printing numbered TAP, like the existing hook and ac-check suites;
  - never touching real repos or the real global config;
  - working on macOS (BSD tools, `/bin/bash` 3.2) and Ubuntu on WSL.
- **Hard cases the ACs must include:**
  - the referee on clean, P2-with-scenario, P2-without-scenario, no-progress and repeat-finding inputs;
  - `ac-check.sh` refusing an unreviewed head, and accepting a head covered by a clean review;
  - every existing `ac-check.test.sh` case still passing;
  - the docs naming the rule in each place;
  - feature-dispatch under 100,000 characters.

## Other things found
If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section of the plan.

## Skill lessons
List reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]`. Never edit skills or memory yourself.
- `enforce` is `none`, or a one-line proposal for a hook, test or lint check that would have caught the problem.
- An empty list is normal.

If you list any, end with `MAIN SESSION: check and save these skill_lessons now.`

## Output
Answer in plain words. Return `{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], found_else[], skill_lessons[]}`. Only `plan_path` and `summary` are required.
