# 86bcm901v-catalog-browser-v2: Library catalog browser, fresh start (all-Opus pipeline)

## Context

Justin wants ClickUp story [Library catalog browser](https://app.clickup.com/t/86bcm901v) (control plane, PI-2, p1-high, size M) done through the Full pipeline, **every role a fresh Opus 5.5 xhigh agent**. Its only dependency, [Content library format + loader](https://app.clickup.com/t/86bcm9018), is complete. The card shows "in verification" because an earlier Hermes attempt exists. That attempt has 12 local commits on `feat/86bcm901v-library-catalog-browser` and is stuck after 3 fix rounds on one open P2 in the Markdown preview.

Card ACs:
- **AC1:** open the library in the admin console, then filter by kind, category, tag and supported tool, and search by text.
- **AC2:** open an item, then see its description, example, version, supported tools and a rendered preview.
- **AC3:** with 200+ items, filtering stays under 300 ms server time.

Verify: a UI integration test plus a manual demo. DoD: unit and integration tests (happy path + 1 failure), OpenAPI updated if the API is touched, lint/format/CI green, demoable in isolation, a README note.

### Justin's decisions (2026-10-23, this session)
- **Fresh start v2, planner blind.** The old branch, its 5 worktrees, plans, briefs and evidence stay untouched as a backup, marked superseded. The new branch is `feat/86bcm901v-catalog-browser-v2`.
- **Same story rules as 901u-v2:**
  - keep looping fixer → fresh verifier until AC1–AC3 are all accepted on one head, with no round cap;
  - one screenshot per AC (uploaded only when he says "post");
  - stop and ask only for a decision that's his, or after a round with no progress.
- **Add a finish hook.** It's a SubagentStop gate, so every agent's report carries `skill_lessons` (Part B).
- **Make all-Opus the default in the skills**, for every story and repo. The screenshot-per-AC rule and the loop-until-accepted rule also go into the skills (Part C).
- **No CI exception** for this story. No push, PR, merge, ClickUp write or card status change unless he says the word.
- **Autonomous grant (Justin, 2026-10-23, before sleeping): "whatever the plan says just keep going ok go with the recommendation".**
  - **Scope:** this plan as written, plus the blind planner's story plan. Every ⭐ recommended answer to the planner's questions counts as Justin's answer. That covers Parts B, C and D and the whole pipeline, from builder to finisher hand-over.
  - **I record each auto-accepted answer** in the plan copy and in every brief, marked "accepted via the 2026-10-23 recommendation grant".
  - **Ends at:** the finisher hand-over (ready, or the exact remaining stage).
  - **Holds instead of guessing:** a choice with no ⭐ option, or one that needs a permission, a credential or an AC change. Its dependent work stops there and is recorded for his morning. Independent work continues.
  - **Not covered:** push, PR, merge, ClickUp post or status, Justin's servers, cloud, real `~/.claude`/`~/.codex` tool-home writes, CI edits.

## Part A — Pipeline (Opus 5.5, effort xhigh; each role a new background agent, one at a time)

| # | Role | Agent | Works in | Stops at |
|---|---|---|---|---|
| 1 | PLANNER | Plan agent, blind, read-only (**running now**) | — | plan (Story plan below) |
| 2 | **BUILDER** | general-purpose | `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v2` | `ready-for-review` |
| 3 | **REVIEWER 1** | general-purpose, never saw the build | its own detached worktree `…/86bcm901v-v2-review-r1` at the builder head | report only |
| 4 | FIXER 1 | general-purpose; skipped if review 1 is clean | builder worktree | `ready-for-next-review` |
| 5 | **REVIEWER 2** | fresh; reviews all of `origin/main...HEAD` plus the fix delta, carrying report 1 | `…/86bcm901v-v2-review-r2` | report only |
| 6 | FIXER 2 | fresh; skipped if clean | builder worktree | `ready-for-verify` |
| 7 | **VERIFIER** | fresh, read-only; re-runs the gates and the loop skills' validation, closes each finding, rules **accepted / not accepted per AC** | `…/86bcm901v-v2-verify-rN` | `clean` with every AC accepted, or `findings` |
| 8 | FINISHER | fresh; hand-over only | builder worktree | diff stat, PR text, review prompt, team message, ClickUp evidence draft with every AC screenshot |

**Setup I do after approval:**
1. Fetch over HTTPS through gh: `git -C ~/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`
2. Branch straight from the fresh `origin/main` into the worktree. This is the same commit an updated `main` would have, and it leaves the shared checkout alone, which another session is using for 901u-v2: `git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm901v-catalog-browser-v2 .claude/worktrees/86bcm901v-catalog-browser-v2 origin/main`
3. Read back the head, `git status`, and that `user.email` resolves to `justin@leorna.com`.
4. Copy this plan to `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v2.md`, and create `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v2/`.

**Loop until every AC is accepted:**
- Each reviewer and each verifier returns `ac_status[{ac, accepted, test, screenshot, evidence}]` for AC1–AC3.
- If any AC is not accepted, or a critical or major finding is open, another fresh FIXER runs, then a fresh VERIFIER.
- Each new reopening of the same defect class gets a class-level fix brief (`feature-dispatch` lines 227–228).
- I stop and ask Justin only for a decision that's his, or when a round makes no progress (the same finding with no new fact).
- "Accepted" means local acceptance. Hosted CI stays **NOT VERIFIED until "make a PR"**.

**Rules for every role:**
- **Briefs:** each one is saved at `~/.hermes/plans/leorna/briefs/86bcm901v-catalog-browser-v2-<role>.md`. The dispatch says "read it first". Reviewer findings go into the next brief from the result message.
- **Skills, in order:** every role loads `leorna`, then `engineering-best-practices`, then the role's list:
  - planner: `implementation-planning` plus the control-plane specialists;
  - builder: `test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`, plus the frontend skills the plan names (unlinked Hermes skills are Read from `~/.hermes/skills/codex-imports/<name>/SKILL.md`);
  - reviewers: `requesting-code-review`, `code-review-practice`, `mutation-testing-discipline`; they skip the skills' "spawn a reviewer" and auto-fix steps;
  - fixers and finisher: `receiving-code-review`, `git-commit-rules`, `test-driven-development`;
  - verifier: the plan's loop skills (those with `^## Mandatory Validation and Agent Defect Loop`).

  I check each transcript for real Skill calls with a small `grep -o` over the output file, never by reading it whole.
- **Every brief carries:**
  - never push, open a PR, merge, post or change ClickUp;
  - never touch the old `86bcm901v-library-catalog-browser` branch or worktrees, or the 901u/9016 worktrees;
  - use your own `_test` database and never drop a sibling's;
  - no CI edits;
  - one screenshot per AC under the evidence folder;
  - `found_else[]` and `skill_lessons[]`.
- **Another session is building 901u-v2 in parallel:** it shares the control-plane repo and the `leorna-test-pg` container, and nothing else. Never stop or redirect its agents.

**After each agent finishes (my intake routine):**
1. Verify its claims: the head SHA and `git log`, the files changed, gate logs with their exit codes, screenshots opened and looked at, and the Skill calls in the transcript.
2. **skill_lessons:** check each lesson, reproducing it when that's cheap. Save the valid ones as a small edit to the named `SKILL.md` or as a memory note, drop duplicates and story-only facts, and tell Justin in one line what was saved.
3. Write `found_else` to `~/.hermes/plans/leorna/found-else.md` and relay it.
4. Add a dated status line in `leorna-workflow.md` → "Start here".
5. Write the next role's brief.

## Part B — SubagentStop finish hook (test-first)

Facts confirmed in the official hooks docs (code.claude.com/docs/en/hooks):
- SubagentStop input has `stop_hook_active`, `agent_id`, `agent_type`, `agent_transcript_path` and `last_assistant_message`.
- `{"decision":"block","reason":…}` keeps the subagent running, with the reason as its next instruction.
- SubagentStop cannot inject context into the parent. PostToolUse on `Agent` can, but a background agent's tool call returns at launch, so it can't serve as the reminder.
- That is why the reminder travels inside the agent's own final report.

1. **RED:** write `~/.claude/hooks/tests/subagent-lessons-gate.test.sh` in the style of `skill-review-nudge.test.sh` (same `fire`/`ok`/`fail` helpers). Run it while the script is missing, and every case fails. The cases:
   - a final message without `skill_lessons` → `decision: block`, and the reason names `skill_lessons`, "do not edit" and the last-line reminder;
   - `skill_lessons: []` → silent, exit 0;
   - a `## Skill lessons` heading → silent;
   - `stop_hook_active: true` → silent, so an agent is sent back once at most;
   - `agent_type` in the skip list (default `statusline-setup`) → silent;
   - other events (Stop, PostToolUse) → silent;
   - invalid JSON, a missing `last_assistant_message`, or a missing session → silent, exit 0.
2. **GREEN:** write `~/.claude/hooks/subagent-lessons-gate.sh`. It uses jq and exits 0 silently on bad input, so it can never break a session. The block reason says: "Before you finish, restate your complete final report, then add a 'Skill lessons' section with `skill_lessons[{skill, lesson, evidence, enforce}]` (`skill_lessons: []` if none). Do not edit any skill or memory file. End with the line: `MAIN SESSION: check and save these skill_lessons now.`" The report is restated because the parent only receives the last message.
3. Run both test files: the new one, plus the 16 existing nudge cases, which must be unchanged.
4. **Wire it:** load `update-config`, back up `~/.claude/settings.json` to the scratchpad, add `"SubagentStop": [{"hooks":[{"type":"command","command":"~/.claude/hooks/subagent-lessons-gate.sh","timeout":10}]}]`, and read the file back.
5. **Live check:** a throwaway Explore agent (haiku) gets a one-line task and an instruction not to add any sections. Pass means its final report comes back with a Skill lessons section and the MAIN SESSION line. If hooks only load after a restart, I say so and fall back to the brief line until then.
6. Do this before the BUILDER starts, so every pipeline role is gated.

## Part C — Skill docs: all-Opus default + screenshot per AC + loop until accepted

First copy the files to `<scratchpad>/skill-backup-20261023/`. Then make small edits in each skill's own style, with dated notes that mark older lines superseded in place rather than rewriting history. Read each file back after the edit.

- **`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`:**
  - "Which model runs which agent": add a 2026-10-23 rule and set every row of the table to Opus 5.5 xhigh. The two reviewers become two fresh Opus agents in order.
  - Replace "Opus designs, Sol builds" with "Opus designs and builds; Sol 6.1 only as a substitute Justin approves when Claude is at its limit, never silently".
  - Add one line saying older Sol-builder wording in the skill is superseded.
  - Defect loop (line 227): replace "After 3 rounds, ask" with "loop fixer → fresh verifier until every AC is accepted on one head (`ac_status[]`), no round cap; ask only for Justin's decision or a no-progress round". Add `ac_status[]` to the verifier and reviewer output schemas.
- **`feature-dispatch/references/mini-pipeline.md`:** the builder and finisher rows become Opus 5.5 xhigh.
- **`~/.hermes/skills/software-development/review-fix-cadence/SKILL.md`:**
  - the default cadence becomes "Opus plan → go → Opus build → fresh Opus review 1 → Opus fix → fresh Opus review 2 → Opus fix → fresh Opus verifier, looping until every AC is accepted → hand-over";
  - "Sol fix" becomes "fresh Opus fixer" in steps 2 and 5 and in line 60.
- **`~/.claude/skills/leorna/SKILL.md`:**
  - "Models by role" (line 85) and Mini (line 84): all roles Opus 5.5 xhigh (2026-10-23), with Sol only as an approved substitute.
  - "Skills per role": add the `skill_lessons` line and say that the SubagentStop hook enforces it.
  - Step 4b, builder: one screenshot per AC; an AC with nothing visual gets a real terminal capture of its run with the command, output and exit code. This matches `clickup-evidence.md`.
  - FINISHER and VERIFIER: loop until every AC is accepted.
- **`~/.claude/CLAUDE.md` line 46:** add "enforced at agent finish by `subagent-lessons-gate.sh`".

## Part D — Memory (shared Leorna folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`)
- **`leorna-workflow.md`:**
  - a status line on "Agent models by role": all-Opus default, 2026-10-23;
  - a new "Start here" line for 901v-v2, saying the old attempt is superseded and untouched;
  - the PI-2 note that 901v's "in verification" comes from the old attempt.
- **`periodic-skill-review.md`:** add the SubagentStop gate, its test file and the live-check result.
- **`MEMORY.md`:** update the one-liners for both notes.

## Story plan (Opus 5.5 xhigh planner, blind; base `origin/main` 57c7fc1)

_Pending: the planner is still running. When it returns, I save its full plan, with each ⭐ answer auto-accepted under the grant above, to `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v2.md`, and I check it before dispatching the builder:_
- _every AC has a named test and a screenshot;_
- _every task has RED/GREEN commands;_
- _no CI edits;_
- _the loop skills are listed;_
- _no step needs a permission the grant excludes._

_If the plan fails that check, a fresh Opus planner corrects it (no redesign by me) before the build starts._

## Verification
- **Part B:** both hook test files pass in full. The settings file is read back. The live Explore-agent check shows the gate sent the agent back with the lessons and the MAIN SESSION line.
- **Part C/D:** each skill and memory edit is read back. `grep -n -i "sol 6.1"` on the edited lines shows only "substitute" or "superseded" wording.
- **Story:** each AC maps to a passing test and a screenshot on one head. Logs show `make check`, a separate `go test -v` Postgres run, `bash ./scripts/test-module-add.sh` and lint with CI's golangci-lint, each with its exit code. The verifier returns `clean` with AC1–AC3 accepted. The finisher returns the hand-over package. Nothing is pushed or posted.

## Forecast
These are low-confidence wall-clock ranges:

| Step | Estimate |
|---|---|
| Part B | 20–35 min |
| Part C/D | 20–30 min |
| Builder | 60–120 min |
| Each reviewer | 25–45 min |
| Each fixer | 20–40 min |
| Verifier | 30–45 min |
| Finisher | 15–25 min |

The whole story takes about 4–7 h through the first clean verifier. Extra loop rounds add about 1 h each.
