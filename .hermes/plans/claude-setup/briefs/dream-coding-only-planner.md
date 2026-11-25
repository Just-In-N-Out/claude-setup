# PLANNER brief: dream-coding-only [claude-setup], Mini pipeline

You are the PLANNER for the claude-setup job "dream-coding-only". Write a short plan Justin will approve. Build nothing: no worktree, branch, edit or commit. The only file you write is the plan.

Mini mode: load only what this touches, finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## Skills to load first (Skill tool), and say so in one line each
`engineering-best-practices`, then `implementation-planning`. Context (Read tool, the sections you need only): `~/.claude/dream/DREAM.md` (the rules file; sections on sources, the bar, and helpers), `~/.claude/CLAUDE.md` "Dream Pass" section, the dream code under `~/.claude/dream/` (`bin/dream`, `lib/dreamlib/*.py`, `prompts/`, `conf/`, `tests/`). The approved plan of the dream build is `~/.hermes/plans/claude-setup/dream-pass.md` (read its "Justin's answers" section, not all of it).

## The request, rewritten
The dream pass (built 2026-11-10, installed in dry-run on this Windows desktop, timer off) should read **only sessions that are about coding**: code, agents, tools, tests, this Claude/Hermes setup, the pipeline. Sessions that are mostly about something else (example: the resume/career chat, session `5080910a-9445-46fa-ad7e-bf7e748286b6`, saved in `~/.claude/projects/-home-justin/`, the same folder as the setup sessions) are skipped whole.

Justin's choices (2026-11-25):
- **Per session**, not per message: a session that is mostly not about coding is skipped entirely. He knows a coding lesson inside a mixed session is lost with this choice.
- **This desktop only**: unchanged. The dream already reads only session files on this disk (all under `/home/justin`); the Mac's sessions are never here. No change for this part, but say in the plan where the code already guarantees it and add an AC that proves it if no test does.
- Folder-based filtering was rejected: setup and dream work is saved in the home-folder project too.

## Evidence from the first dry run (2026-11-25, run folder `~/.cache/dream/20261125-173709/`)
- It read 8 sessions; the only one with findings was the career session `5080910a` (6 findings from the helper, 3 passed the bar, all 3 already saved in memory; the other 3 went to `justin-list.md` as questions). That is the case this story must stop.
- `would-log-entry.md`, `copy/_dream/findings.json`, `map.tsv` and the `digest-*.md` files there show what the helper saw. Read them; don't rerun the dream.
- It also reported a format error: session `67456e97-9f8e-4083-928f-7bcdbe7e3240` line 34021 is not valid JSON (likely a broken line left after a PC freeze). Not this story: list it under "Other things found" with a recommendation.

## What the plan must settle
- **Who decides "about coding" and when.** Options include: the session helper returns a verdict (`coding: true/false` with a one-line reason) before or with its findings; a cheap separate classify call on the digest; a script rule. Weigh cost (each run is Opus 5.5 xhigh, about $2 a run now), and recommend one.
- **What a skipped session does to the markers and the log:** its marker should still move to the end so it is never read again; the log line for it says "skipped: not about coding (<reason>)". Say what happens if the session later grows coding content (a resumed session): is only the new part judged?
- **A safe default when unsure.** Say which way it leans and why (Justin's per-session choice: skipping a mixed session is accepted).
- **Review findings** (the backfill from evidence folders) are coding by definition; confirm they are untouched.
- **What it means for `justin-list.md`** items already raised from non-coding sessions: none exist on the live file yet (the dry run did not write), so no clean-up, but confirm.
- `DREAM.md` and the `~/.claude/CLAUDE.md` "Dream Pass" section gain one line each saying the dream reads only coding sessions on this desktop. Watch the CLAUDE.md byte budget (36,000; `conf/budgets.tsv`).
- Tests: the dream has a test suite (`tests/run.sh`, `tests/regression.sh`, a fake claude in `tests/fake-claude`). Name the tests, including one with a non-coding fixture session and one with a mixed fixture, and a mutation the tests must kill.
- How it lands: earlier setup stories worked in a worktree under `~/.claude-setup-wt/<name>` of the bare repo `~/.claude-setup.git` and landed through `sync.sh` under its lock with `--ff-only`. Say the same or better.

## The plan file
Save to `~/.hermes/plans/claude-setup/dream-coding-only.md`: playback, the approach, numbered acceptance criteria, touched files, a one-line Docs & records task, questions at the top if any, `pipeline=mini`. **Number the ACs AC1, AC2…, each with one test by name, whole on one line** (`ac-check.sh` matches names line by line). Justin gave none: write your own and mark each **proposed**. Tag `(live)` right after the id for one only Justin can check, for example him running the next dry run and seeing the career session skipped: `- AC5 (proposed) (live): …`. Write the plan as if the recommended options were chosen.

## Rules for you
- You cannot ask Justin anything: put questions in `questions`, 2 to 4 short options each, the recommended one marked.
- If you find any other bug or problem, do not fix it: list it in `found_else` (one line each, evidence, severity) and in an "Other things found" section.
- Never edit a skill or memory file. Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check that would have caught a broken rule. An empty list is the normal answer.
- Never copy keys, tokens or passwords into any file. Quote Justin's typed words only.
- Memory safety on this desktop: a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. In the Bash tool `grep` is ugrep; use `/usr/bin/grep`.

## Report back
`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` in plain words. End the report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words (verbatim, 2026-11-25)
- "i want it to read only the messages that have to do with codinf and that are on this laptop"
- (answers) machine: "This desktop only"; coding test: "Per session"; pipeline: "Mini"
If this brief and his words disagree, follow his words.
