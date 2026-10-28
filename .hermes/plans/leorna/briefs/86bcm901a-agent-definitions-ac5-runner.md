# AC5 LIVE RUNNER — leorna-control-plane, story 86bcm901a "Curate agent definitions"

Role: AC5 LIVE RUNNER, a fresh agent. Justin asked (2026-10-28, "can't you run it?") for the live AC5 to be run for him instead of by hand: "one live run per agent in Claude Code". Run each of the 4 agents once in real Claude Code, non-interactively under Justin's normal login, and capture proof. Justin judges the result from your receipts. Don't change the story's code or branch.

## Read first
- The kit: `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/CHECKLIST.md`. It has the steps, the prompts, the "Pass" line for each step, and the three rules. Your run follows it, with the non-interactive changes below.
- The approved plan's AC5 section and its "Justin's answers" choice C a: `~/.hermes/plans/leorna/evidence/86bcm901a/plan-approved.md`. Read only.
- `ac5-live/agents.sha256`: before you run, check that the 4 agent copies still match it.

## Skills (load with the Skill tool and say so in your first steps)
`leorna` (do its Step 1 context load), `engineering-best-practices`.

## How to run
1. **Keep the kit untouched.** Copy the sample project with `cp -a` (it holds a git repo with a deliberate **uncommitted** change, which must survive the copy) to `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/run-agent/sample-project/`. Create `run-agent/` with `mkdir`, no `-p`; if it already exists, stop and report. In the copy:
   - check `git status` shows the uncommitted `paginate/paginate.go` change;
   - check `sha256sum .claude/agents/*.md` matches the second half of `agents.sha256`.
2. **Check the CLI first.** Use `claude --version` and `claude --help` to confirm the real flags before you rely on them: `-p`, `--setting-sources`, `--output-format stream-json`, `--verbose`, `--allowedTools`, `--disallowedTools`, `--permission-mode`.
   - If `claude` refuses to start inside another Claude Code session, run it under `env -u CLAUDECODE` and say so.
   - Never use `--dangerously-skip-permissions` or `bypassPermissions`.
3. **Settings for every run:**
   - Start it from the copy's folder, with `--setting-sources project` so Justin's user hooks and settings don't fire, and `--output-format stream-json --verbose`.
   - Save each run's full stream as `run-agent/<step>.stream.jsonl`.
   - Tools follow the checklist's rules. Allow only:
     - read-only tools: Read, Grep, Glob;
     - `Bash` limited to `git diff`, `git status`, `git log`, `ls` and `cat`;
     - the subagent tool, whatever this version calls it (`Agent` or `Task`).
   - Explicitly disallow `Bash(npx:*)`, `Bash(npm:*)`, WebFetch and WebSearch.
   - For test-engineer only, also allow Edit and Write inside the copy (for example `--permission-mode acceptEdits`, run from the copy's folder).
   - Bound each run with a timeout of about 15 minutes, waiting in the foreground (a `node -e` poll; foreground `sleep` is refused).
4. **Agent list (checklist step 2):** `/agents` is interactive, so prove it a different way. Use the stream's init/system event, which lists the agents loaded for the session, or `claude agents` if this version has it. All 4 must appear as project agents: code-reviewer, security-auditor, test-engineer and web-performance-auditor.
5. **Checklist steps 3–6:** use the exact prompts, each in its own `claude -p` run, and append "Show its report exactly as it wrote it." to each prompt.
   - For each step, prove two things:
     - **(a)** The named agent really ran: the stream has a subagent tool call whose agent/subagent type is that agent's name.
     - **(b)** The step's **Pass** line holds, checked against the agent's own report text in the stream (the subagent's result), not only the main reply.
   - Extract each agent's report to `run-agent/<step>-report.md`.
   - Note every tool call that was denied (for example an `npx` attempt). A denied `npx` isn't a fail; web-performance-auditor's scorecard must still say "not measured".
   - "Build verified: no" is expected, because `go` isn't on the normal PATH.
6. **One screenshot per step:** `ac5-agents-list.png`, `ac5-code-reviewer.png`, `ac5-security-auditor.png`, `ac5-test-engineer.png`, `ac5-web-performance-auditor.png`, all in `run-agent/`.
   - Each one shows the command, the proof line(s) for (a), and the agent's report. Render it as a `<pre>` page with Chrome for Testing, following `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and run under `env -u DISPLAY -u WAYLAND_DISPLAY`.
   - Open every PNG. No token, password, email address or server URL may be visible. If the stream holds an account email or org name, leave it out of the screenshots and redact it in the saved `.jsonl` copies.
7. **Write `run-agent/RESULT.md`:** per step, PASS or FAIL against the checklist's Pass and Fail lines, with the evidence lines, the Claude Code version, the model each run used, the exact command lines, and the denied tool calls. Write `FAIL` plainly if an agent didn't run or its report ignores its format. Never smooth a result over.

## Boundaries
- Write only inside `~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/run-agent/`, plus small scratch in `/tmp/claude-1000/-home-justin-Leorna/6a5cb64a-ef1e-4913-b9a6-0011ebf1675e/scratchpad/86bcm901a-ac5-runner/` (`mkdir`, no `-p`; remove it at the end).
- Justin approved the normal Claude Code session files that `claude` writes under `~/.claude/projects/` and its project-trust record. Don't write anything else in `~/.claude` or `~/.codex`: no agents, settings, hooks or memory, and nothing in `~/.claude/agents`.
- Don't touch the story worktree, its branch or the main checkout; the accepted head stays `9c13e02`. Don't touch other stories' worktrees, branches, DBs or evidence.
- Never push, open a PR or post to ClickUp.
- Run each step once. If a run fails for an environment reason (for example the nested-session refusal or a flag name), fix the command and rerun that step, keeping the failed stream as `<step>.failed-<n>.stream.jsonl`. Don't rerun a step that ran properly just to get a better answer.

## Rules for every role
- If you find any other bug or problem, don't fix it or fold it in. List it in `found_else`, one line each, with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.

## Report (final message)
- `verdict`: `pass` (all 5 steps PASS) or `fail`, with each failed step and why.
- Per step: PASS/FAIL, the proof line that the named agent ran, the Pass-line evidence, and the screenshot path.
- The Claude Code version, the model, the commands, and the denied tool calls.
- The path of `RESULT.md`.
- `found_else[]` and `skill_lessons[]`.
- End with `MAIN SESSION: check and save these skill_lessons now.`
