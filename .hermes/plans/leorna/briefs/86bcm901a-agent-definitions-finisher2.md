# FINISHER (AC5 update) — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: FINISHER, a fresh agent. Justin accepted AC5 on 2026-10-28. Update the hand-over drafts so they say AC5 is verified. Change only the drafts: no code, no commits. **Never push, open a PR, post to ClickUp or merge.**

## Facts
- Story head `9c13e02c1e6b111d6b33bd415371ac53c025d81b` on `feat/86bcm901a-agent-definitions`, which is unchanged and clean. BASE and GitHub `main` were `1ee7157` at hand-over.
- `ac-check.sh` on `9c13e02` said: `READY FOR THE USER: 4 of 5 ACs proven on 9c13e02; live ACs owed to the user: AC5`.
- AC5 (live), "one live run per agent in Claude Code":
  - At Justin's request ("can't you run it?"), an AC5 runner agent ran it with headless `claude -p`: Claude Code 2.1.312, his login, `--setting-sources project`, in a copy of the kit's sample project.
  - Results: `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/run-agent/RESULT.md` (verdict pass, 5 of 5 steps), with screenshots `run-agent/ac5-*.png`.
  - Justin accepted it: "Yeah, sure, I accept it." The record is `ac5-live/ACCEPTED.md`.
  - The deviations he saw before accepting are in RESULT.md and ACCEPTED.md.
- Hand-over pack: `~/.hermes/plans/leorna/evidence/86bcm901a/hand-over/`. Start from `INDEX.md`, then `pr-text.md` (a copy of `~/.hermes/cache/scratch/leorna-pr-86bcm901a-agent-definitions.md`), `clickup-evidence.md`, `review-prompt.md`, `team-message.md` and `stop-and-show.md`.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (FINISHER role; read `clickup-evidence.md` and `review-prompt-for-agent.md` in the notes for the formats), `engineering-best-practices`.

## Tasks
1. **PR text** (both copies, kept identical):
   - In the Test Plan, AC5 becomes verified. Say how in one or two plain lines: run headless in Claude Code 2.1.312 by an agent at Justin's request, all 4 agents ran with their own report formats, and Justin accepted it on 2026-10-28.
   - Remove "AC5 owed" from Assumptions. Add one short line on how AC5 was run and its one caveat: Justin's global CLAUDE.md loads even in project-only mode, so three reports end with extra pipeline lines.
   - Leave everything else as it is.
2. **ClickUp evidence draft** (`clickup-evidence.md`):
   - The AC5 row becomes VERIFIED, with its evidence named.
   - Remove the "NOT VERIFIED / owed" wording.
   - Add the 5 AC5 screenshots to the attach list. Open each one first and confirm there's no URL bar, server domain, tenant, token, password or email (RESULT.md says there are none; check it yourself).
   - Never list the Claude Code session transcripts under `~/.claude/projects/`: they hold Justin's email addresses.
3. **Review prompt and team message:** if either one mentions AC5 as owed, update it.
4. **`INDEX.md`:** add the AC5 run (RESULT.md, ACCEPTED.md, screenshots) and note that the drafts were updated after acceptance.
5. **Story status** in the drafts, in `leorna` FINISHER terms: `ready` for "make a PR". Every AC is accepted on `9c13e02`: AC1–AC4 by the verifier, the blind auditor and `ac-check.sh`, and AC5 by Justin. Hosted CI runs only once the PR exists.

## Boundaries
- Write only in `~/.hermes/plans/leorna/evidence/86bcm901a/hand-over/` and to the PR-text file `~/.hermes/cache/scratch/leorna-pr-86bcm901a-agent-definitions.md`. Don't edit `ac5-live/` files or anything else in the evidence folder.
- Don't touch the story worktree, any branch, other stories, or `~/.claude`/`~/.codex`.
- No server domain, URL, tenant ID or token in any text. The only links allowed are the ClickUp card and public GitHub links.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status.
- Each file you changed, with a one-line summary of the change.
- The final attach list for ClickUp.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
