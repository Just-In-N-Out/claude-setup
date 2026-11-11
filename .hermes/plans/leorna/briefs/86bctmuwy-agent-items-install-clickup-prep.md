# FINISHER brief (ClickUp evidence ready to post): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** FINISHER. Get the ClickUp closing evidence ready, so the main session can post it the moment PR #32 is merged. Justin said "push pr and clickup". Per `leorna` 7.9 and `clickup-evidence.md`, the post waits for the merge. **Do not post, upload or write anything to ClickUp. No commits, no push.**
**Model/effort:** Opus 5.5, high.

## State
- [PR #32](https://github.com/LeornaAI/leorna-client/pull/32) is open at head `d42aa5875d2bb6290ff048cc3a1ae592f65d67b0`, with CI run 42794713875 all green. Not merged yet.
- Draft: `/home/justin/.hermes/cache/scratch/leorna-clickup-86bctmuwy.md`. It still has placeholders for the merge date, merge SHA and CI line. Two things in it are still open:
  - the auditor-3 captures haven't been checked visually;
  - the gates image `pr-2/gates-d42aa58.png` hasn't been rendered.
- Evidence: `~/.hermes/plans/leorna/evidence/86bctmuwy/` (`auditor-3/`, `verifier-3/`, `pr-2/`, `fixer-5/`, `builder/`, `fixer-3/`).

## Skills to load (say so in your first steps)
`leorna`, `engineering-best-practices`. Read the shared notes `clickup-evidence.md` and `story-done-team-message.md` in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/` (use the real folder, which may be behind a symlink).

## What to do
1. Render `pr-2/gates-d42aa58.png` from the `pr-2/` gate logs, as `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` describes for the WSL desktop. Check its PNG magic bytes and that the `EXIT=` lines show.
2. Open **every** attachment the draft lists and look at it, in bands if it's tall. Each must show what its row claims, with no email, URL, token, tenant ID, the user's skill names, or a home path that shows the username where that can be avoided. Re-render any that fail, from the same log, and say so. Images only: never `.log` or `.txt`.
3. Open each log the draft cites and read its `EXIT=` line.
4. Make the draft final, apart from the merge facts:
   - The attachment list gives exact paths, one PNG per AC plus the gates image.
   - Mark exactly three placeholders: `<MERGE_DATE>`, `<MERGE_SHA>` and `<MAIN_CI>`. `<MAIN_CI>` is the result of main's CI run on the merge commit, if one exists by posting time; otherwise the PR's CI run 42794713875.
   - AC13 is NOT VERIFIED and owed to Justin.
   - Write a short "how to post" block at the end of the draft, for the main session: the ClickUp card ID `86bctmuwy`, the order (the comment first, then each attachment), and the exact file list.
5. Keep a copy of the final draft in `~/.hermes/plans/leorna/evidence/86bctmuwy/finisher/clickup-evidence.md`.

## Rules
- Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor`, beyond reading the memory notes named above.
- WSL PATH holds entries with spaces: export PATH in scripts.
- WSL can restart and leave 0-byte files: check sizes before citing anything.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and in a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{status: ready-to-post|blocked, draft_path, attachments[{path, inspected, issue}], placeholders[], rerendered[], found_else[], skill_lessons[]}`, plus the comment text inline. End with `MAIN SESSION: check and save these skill_lessons now.`
