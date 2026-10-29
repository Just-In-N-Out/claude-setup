# Brief: REVIEWER 1 (full round), story `review-loop`

## Role
You are the fresh, full **reviewer 1** for Justin's setup story `review-loop`. You never saw the build. You **only report**:
- no source changes, no commits, no auto-fixes;
- no other agents;
- never write the live `~/.claude`, `~/.hermes`, `~/.hermes/skills-library`, global git config, `~/.claude-setup.git` refs or GitHub.

Write only into `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/`.

**Live guards.** `git-guard.sh` checks every Bash call, and the global git hooks check every commit. A deny is the guard working. Probe git through a script file in a temp `HOME`.

**This story builds the review loop, and its own reviews already run under it.** Your round's findings go into a `review.json` that the story's own referee reads. The main session then runs the referee to decide what happens next.

## Skills to load first (say so in your first steps)
1. `engineering-best-practices`
2. `requesting-code-review`: skip its "independent reviewer subagent" and auto-fix steps.
3. `code-review-practice`
4. `mutation-testing-discipline`

## What to review
- **Worktree:** `/home/justin/.claude-setup-wt/review-loop`, branch `review-loop`. It is a linked worktree of the setup repo `~/.claude-setup.git` (work tree `$HOME`).
- **Candidate head:** `d3f220f77c9966c5880c779c3411dcdea65950dd`. **Base:** `691651c1e942896f42f4e64ed547a1a2a121ef3c`. Review all of `git diff 691651c...d3f220f`.
- **Before you start,** confirm HEAD is `d3f220f` and that `git status --porcelain --untracked-files=all` is empty. If either fails, stop.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/review-loop/plan-approved.md` (read-only). Justin pre-approved every ⭐ option. ACs AC1–AC18; AC18 is `(live)`, on Justin's Mac.

### The builder's departures from the plan's prototype (rule on each: valid, or a finding)
1. Usage errors print `error: usage: …`.
2. `justin.json` `words` must contain a non-space character.
3. The pure-rebase check compares `git diff-tree -p --full-index | git patch-id --verbatim` in `--topo-order`.
4. Tabs and newlines in `file_line`/`claim` print as spaces.
5. A reviewed head with no shared history with HEAD gives REVIEW AGAIN.
6. An earlier round whose `review.json` isn't an object exits 2.
7. `ac-check.sh --reviews ""` exits 2. The usage line is unchanged.
8. Extra docs edits: the Mini wording in feature-dispatch `SKILL.md` line 29 and leorna `SKILL.md` line 84, and the `MEMORY.md` index line removed.

### Focus areas
- **AC truth:** does each test prove every clause of its AC?
- **The referee's decisions against the agreed rule.** Read `references/review-loop.md` in the worktree and `~/.claude/projects/-home-justin/memory/review-loop-until-clean.md`.
  - Could it say MOVE ON when a P0–P2 remains, or when commits are unreviewed?
  - Could it loop forever, or ask Justin when it shouldn't?
  - Does it handle realistic records: several rounds, `delta` scope after a rebase, `justin.json`, missing fields?
- **The `ac-check.sh --reviews` gate.**
  - Can a head pass without a clean review covering it?
  - Is the output without `--reviews` really unchanged?
  - Does the canonical command in every doc carry `--reviews`?
- **The docs.**
  - CLAUDE.md, feature-dispatch (Full and Mini), `review-fix-cadence`, `ac-verification.md`, the leorna skill and the Codex roles state the same rule, with no contradictions left.
  - The Phase 3b shortcuts are removed (Q9).
  - Moving sections to `references/` lost no rule.
  - feature-dispatch is under 100,000 characters.
- **Both machines:** macOS `/bin/bash` 3.2, BSD tools and jq 1.6; Ubuntu on WSL. Run the suites again as `PATH=/usr/bin:/bin /bin/bash`.

## Severity (Justin's rule; every P0–P2 needs a concrete real-use scenario of 5+ words, otherwise it is P3)
- **P0/P1:** the gate or referee lets unreviewed or still-buggy code through, a false AC, a wrong ASK or REVIEW AGAIN that would stall every story, or a broken existing suite.
- **P2:** a bug a real reviewer, fixer or orchestrator could plausibly hit, including realistic edge cases, or a test that can't fail.
- **P3:** cosmetic, docs wording, deliberate-only, or a setup none of Justin's machines has.

## How
- Run on head:
  - `bash .hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh` (offline), also as `PATH=/usr/bin:/bin /bin/bash`;
  - the named runs `ac11_ac_check_existing_cases_pass` and `ac17_existing_suites_pass`.
- Probe the referee and gate yourself with hand-made record sets in a temp folder. Do mutation checks in a copy outside the worktree (`git clone -q ~/.claude-setup.git ~/.cache/review-loop-reviewer1/c && git -C … checkout -q --detach d3f220f`).
- Don't treat the builder's evidence as proof.

## Your round record (required)
Write `~/.hermes/plans/claude-setup/evidence/review-loop/review-1/review.json` in the format of the worktree's `references/review-loop.md`:
- round 1;
- scope `full`;
- `from` = base, `head` = `d3f220f…`;
- findings with id `R1-<k>`, severity, `file_line`, `claim` and `scenario`.

Then self-check it with the worktree's referee and save its output as `review-1/referee.txt`:
`bash ~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base 691651c1e942896f42f4e64ed547a1a2a121ef3c ~/.hermes/plans/claude-setup/evidence/review-loop`

## Scratch and the desktop
- Keep scratch in your own `<scratchpad>/review-loop-reviewer1/` folder (fresh `mkdir`). Remove it by its literal path.
- Put `TMPDIR` and anything large in `~/.cache/review-loop-reviewer1/`.
- **Gotchas:**
  - In the Bash tool, `grep` is ugrep, so use `command grep`.
  - Use `tail -n N`.
  - Never `pkill -f`.

## Output (final message)
- `verdict`: `clean` (no P0–P2) or `changes-needed`.
- `findings[{id, severity, file_line, scenario, claim, evidence, fix}]`.
- `p3[]`.
- `departures[{n, ruling, why}]`.
- `ac_status[{ac, accepted, test, evidence}]` for AC1–AC18. AC18: `accepted: false, not_run: "live: …"`.
- `referee_last_line`.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`. An empty list is normal.

If you list any lessons, end with `MAIN SESSION: check and save these skill_lessons now.`
