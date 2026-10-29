# AC AUDITOR (round 3) — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: AC AUDITOR, a fresh agent working blind. **Source read-only:** never edit, commit, stage, stash or reset anything in the worktree. Prove every acceptance criterion yourself, on head and on base, from the approved plan alone, and write your own report.

## What you get (and nothing else)
- **Approved plan (read-only):** `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md`. It has the ACs, each AC's named test and the command that runs it. Never edit it.
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`, branch `feat/86bcm901a-agent-definitions`.
- **Head:** `829fa9cb4d0a64ee03e132ebba9de95870b9fb41`. Before you start, check HEAD is that and `git status --porcelain --ignored` is empty; if not, stop and report.
- **Base:** `da8a4b08a841d9d4db4266abea1f937e5abc8cba`, which is `git merge-base HEAD origin/main` and also GitHub main (the merge of PR #94, another story). The branch brought main in at `6ae305e` (after PR #95) and again at `829fa9c` (after PR #94).
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901a/auditor/`. Create it and write only there. Every receipt your `ac.json` cites must be inside it.

**Blindness rule:** don't open, list or read anything else under `~/.hermes/plans/leorna/evidence/86bcm901a/` besides `plan-approved.md` and your own `auditor/` folder. That covers the verifier's folder, reviews, other roles' logs and screenshots, and README files. The one exception is AC5's kit, below. Don't read other briefs in `~/.hermes/plans/leorna/briefs/` either. Take your own screenshots and run your own checks.

## Rules for the AC work
Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` exactly. It covers:
- the run recipe on head and base;
- the Go base-copy rules (copy in only the test files that AC's test needs, so base prints a real `--- FAIL` or `[build failed]`, never `[setup failed]`);
- the screenshot recipe for this WSL desktop;
- the `ac.json` format (also at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`);
- the blind self-check before you hand back.

## Acceptance criteria
Use the plan's exact test names and commands.
- **AC1–AC4:** each has one named Go test in the plan.
  - Prove each one passes on head: its own pass line, EXIT=0, and no skip.
  - Prove each one fails on base for a real reason.
  - For any AC clause the test seems not to exercise, confirm the test catches a break of it with a `go test -overlay` mutant, run in your own copy and never in the worktree.
  - AC4 needs `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`. A skip counts as a reject.
- **AC5 (live):** "one live run per agent in Claude Code".
  - Justin already ran and accepted it, on an earlier head (`9c13e02`).
  - Report it as `"accepted": false, "not_run": "live: accepted by Justin on 9c13e02; agent bodies byte-identical at 829fa9c"`, but only after you prove that claim yourself.
    - Hash each `internal/library/content/items/agent/*/body.md` with `git show 829fa9c:<path> | sha256sum`.
    - Compare the hashes with `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/agents.sha256`.
    - Read Justin's record, `ac5-live/ACCEPTED.md`.
    - These two files are the only other evidence paths you may open. If any hash differs, say so plainly.
  - Don't run Claude Code.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (do its Step 1 context load, then act as the AC auditor described in `ac-verification.md`), `engineering-best-practices`.

## Environment
- **Toolchain:** task-local `PATH=$HOME/.local/leorna-toolchain/go/bin:$HOME/.local/leorna-toolchain/bin:$PATH`. Never change the global PATH.
- **Disk:** `/tmp` is a small tmpfs shared by every session.
  - `TMPDIR`, detached copies and big caches go in `~/.cache/86bcm901a-auditor3/` (`mkdir`, no `-p`).
  - Small scratch goes in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-auditor3/` (`mkdir`, no `-p`).
  - Remove both at the end, and only those. Remove any `git worktree add` copy with `git worktree remove --force`.
- **Postgres:** if you need it (the AC tests above shouldn't):
  - Reuse the running `leorna-test-pg` and read its port with `docker port leorna-test-pg 5432`. Never touch `leorna-pg` on 5432.
  - Use only your own `leorna_86bcm901a_auditor3*_test` DBs, and drop them at the end.
  - Never print a URL or password.
- **Screenshots:** Chrome for Testing as `ac-verification.md` says, run under `env -u DISPLAY -u WAYLAND_DISPLAY`. Open every PNG; no password, token or DB URL may be visible.
- **Long commands:** a foreground Bash call is moved to the background after 180 s, so split long waits into polls under 170 s each (a bounded `node -e` loop re-reading the log). Ending your turn to wait counts as finishing.

## Boundaries
- Never touch other stories' worktrees, branches, DBs or evidence folders: 86bcm901b, 86bcm901j, 86bcm901w or any other.
- Never push, open a PR, post to ClickUp, or write to Justin's real `~/.claude` or `~/.codex`.
- At the end, HEAD must still be `829fa9c` and `git status --porcelain --ignored` must be empty.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- `verdict`: `clean` when AC1–AC4 are accepted on `829fa9c` (AC5 `not_run` live); otherwise `not_clean` with each reason.
- `ac_status[]`: per AC, its status, test, head log, base log and screenshot paths, plus any clause mutants.
- The path of `auditor/ac.json` and the last line of your blind self-check.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
