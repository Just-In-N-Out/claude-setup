# BUILDER — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: BUILDER, a fresh agent. Build the approved plan test-first and stop at `ready-for-review` (or `blocked-on-justin`, below). Don't redesign.

## Read first
- The approved plan: `~/.hermes/plans/leorna/86bcm901a-agent-definitions.md`. Its read-only copy `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md` is what the AC check reads. Don't edit either one.
- The plan's **"Justin's answers (2026-10-28)"** section: he approved the plan with every ⭐ answer (A a, B a, C a, D a). Build exactly that.
- Tasks T0–T15, Live run (AC5), Risks and the Completion contract are your instructions.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (BUILDER role; do its Step 1 context load), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the `--version` guard, the AC2 decision rules and the AC3 tripwire), `security-best-practices` (third-party content, importer file and lock writes).

## Execution order: Justin is away (main session, resource routing only)
Justin hasn't done his part of question D yet: Docker Desktop WSL integration for Ubuntu, and `sudo apt-get install -y make`. As of 2026-10-28 14:40 this desktop has no `go`, `make`, `golangci-lint`, `govulncheck` or `psql`, and `docker` prints "could not be found in this WSL 2 distro". So:
1. **T0** in full: fetch over HTTPS through gh, check against the GitHub SHA, `git merge --ff-only origin/main` in the main checkout (its `main` is already at `1ee7157`), create the worktree, then confirm `main` = `origin/main` = worktree HEAD = BASE.
2. **T0b steps 1–4 and 6 now**, without waiting: Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 into `~/.local/leorna-toolchain`, checksums checked, plus the Chrome probe.
   - Other sessions on this desktop may install into the same folder, so wrap the install in `flock ~/.local/leorna-toolchain.lock`.
   - Reuse the folder when it already holds the exact versions. Never delete or overwrite someone else's install.
   - Use a task-local PATH only.
3. **T2–T7 and T9–T12 next.** These need only Go (and gitleaks for AC4).
   - Write T8's test file before T9, as planned. Its RED and GREEN runs need Postgres: observe its RED later on a detached BASE copy holding only that test file, and its GREEN on head, once Postgres exists. Record both.
4. Then check `command -v make` and `docker ps`.
   - **Both work:** do T0b step 5 (reuse `leorna-test-pg` if it exists; your own `leorna_86bcm901a*_test` databases only), then T1, the T8 runs, T13 and T14, and stop at T15 `ready-for-review`.
   - **Either is missing:** stop with status **`blocked-on-justin`**. Report everything committed so far, every AC test's head result, exactly what's left, and the two steps Justin must do. Don't wait or poll for him.

## Boundaries
- Work only in `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions` on branch `feat/86bcm901a-agent-definitions`. In the main checkout, only T0's fetch and ff-only merge are allowed; never check out another branch there.
- Never touch other stories' worktrees, branches, test databases or evidence folders: 86bcm901b (prompts), 86bcm901j (MCP templates), 86bcm901w (create pack; its worktree exists too), or any other.
- Never push, open a PR, post to ClickUp, or write to Justin's real `~/.claude` or `~/.codex`. Don't run Claude Code for AC5: prepare the kit only.
- Commits: plain `git commit -m "…"` with the repo's identity (`Justin Issa <justin@leorna.com>`). No `-c user.*`, no `--author`, and no `Co-Authored-By` or any AI attribution line. Never commit `CLAUDE.md`; add it to `.git/info/exclude` if one exists.
- The plan's Go code was never compiled. Fix mechanical slips (imports, typos, a helper's real signature) and list each one in your report. If something would change behaviour, a test's meaning, an AC or a decision, stop and report: the plan goes back to a planner.
- Scratch: `$S` = `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-builder/`. Create it with `mkdir` (no `-p`) so it fails if it exists, and remove only that folder. The scratchpad is shared with other agents.
- Evidence goes to `~/.hermes/plans/leorna/evidence/86bcm901a/`: one test and one screenshot per automated AC (terminal or log rendered with Chrome for Testing), plus head and base logs per `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. Open every PNG before you cite it. No secrets, DB passwords or URLs may be visible.
- Wait for long commands in the foreground (a bounded `node -e` poll on the log; foreground `sleep` is refused). Ending your turn to wait counts as finishing.

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- Status: `ready-for-review` or `blocked-on-justin`.
- BASE and head SHAs; `git diff --stat BASE..HEAD`; the commit list.
- Every gate with its exit code and log path.
- Per AC: the head and base result, plus the screenshot path.
- Mutation results; the AC5 kit path; what's owed; any mechanical plan fixes.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
