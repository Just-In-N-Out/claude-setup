# PR-RECORD brief (fixer role): 86bcxnykn, record PR #131 in delivery/stories.json

Role: FIXER (a fresh general-purpose agent on Opus 5.5, high effort). Justin said "make a PR" on 2026-11-12; PR #131 is open on `LeornaAI/leorna-control-plane` from `feat/86bcxnykn-admin-console-update`, head `6517bb18d5ac95ce9f546d9ad992248e081c1d37`. Your job is the `leorna` skill's step 7.8 record commit only. **Don't push** (the main session pushes after a fresh review). Never merge, never write to ClickUp, never change `.github/workflows/*`. Start no other agents.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`.
- Evidence folder (write only here): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/pr-record/` (create it).

## Do
1. Right before committing, check `gh pr view 131 -R LeornaAI/leorna-control-plane --json state,headRefOid` is OPEN at `6517bb1` (if merged, stop and report).
2. In `delivery/stories.json`, this story's entry (last) gets PR 131 in its `prs` for `leorna-control-plane`, plus any status/"in review" wording the house pattern uses. Follow how sibling stories recorded their PRs: `git show b389a45` (86bcxnymy, "record PRs #128 …"), `git show 31d007e` (86bcm928e, "record PR #129"), `git show 6eeeb26` (86bcm928p, "record PR #126"). Edit as text, keep every other entry byte-identical. Also grep the tree for any other place that story records name the PR (e.g. `delivery/README.md` rules) and follow it.
3. Prove it: main's entries equal by value and in order with this story's last; `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` from the repo root passes; `python3 scripts/check-story-shippable.py 86bcxnykn` prints only the expected PR-state BLOCKED lines for an open PR ("not merged into main" and "open follow-up references this story", two per open PR). Save the outputs to `pr-record/checks.txt`.
4. Commit as `feat(86bcxnykn): record PR #131` with the repo's identity (never override author), no AI attribution lines, never stage `CLAUDE.md`.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna`, `engineering-best-practices`, `git-commit-rules`, `github` (read-only gh calls).

## Rules
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`.
- Scratch: your own `~/.cache/86bcxnykn-prrecord/`, created fresh with `mkdir` (no `-p`).
- Don't end your turn to wait for a background command.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: ready-for-review|stopped, head, commit, diff, checks, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
