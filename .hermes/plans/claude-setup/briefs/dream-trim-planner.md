# PLANNER brief: dream-trim [claude-setup], Mini pipeline

You are the PLANNER for the claude-setup job "dream-trim". Write a short plan Justin will approve. Build nothing: no worktree, branch, edit or commit. The only file you write is the plan.

Mini mode: load only what this touches, finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## Skills to load first (Skill tool), and say so in one line each
`engineering-best-practices`, then `implementation-planning`. Context to read (Read tool, sections only): `~/.claude/CLAUDE.md` ("Keep skills lean", Setup Sync), `~/.claude/setup/sync.sh` header and `manifest.txt`.

## The request, rewritten
Before a new scheduled "dream pass" job starts adding lessons to Justin's skills, four files must be trimmed once, because they are at or over their size limit and nothing more fits:

| File | Bytes now |
|---|---|
| `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` | 105,514 (Hermes' limit is 100,000 characters) |
| `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` | 99,018 |
| `~/.hermes/skills/software-development/leorna/SKILL.md` | 73,219 (48,209 two weeks ago) |
| `~/.claude/project-docs/figma-to-bricks/CLAUDE.md` | 95,069 |

Agreed approach, two passes:
1. **Move, don't reword.** Whole sections go into the skill's `references/` folder with a pointer line left behind. Nothing is lost.
2. **Then merge duplicates.** This pass rewrites text, so Justin sees its diff before it goes live.

## What the plan must settle
- A target size per file, with room left for new lessons (propose numbers; put them in `questions` if you see a real choice).
- Which sections move and which stay: what every agent needs on every load stays in the main file. Use each file's own headings; measure section sizes with a script rather than reading the files whole.
- Where moved text from the project `CLAUDE.md` goes (it has no `references/` folder; it is a copy that `sync.sh links` puts into the project repo). Options and a recommendation.
- Everything that points at these files by section name or path, so nothing breaks: `~/.claude/CLAUDE.md`, other skills, briefs, hooks, `feature-dispatch/scripts/*.sh`, `~/.codex`. Find them with grep and list them.
- A lossless check for pass 1: a script proves every moved line still exists verbatim in a `references/` file and the pointer is in place.
- That safety rules (push, authorship, approval, guards, merge policy) are never reworded or dropped in pass 2.
- How it lands: these are live files other sessions load and edit all day (about 40 commits a day touch the skills), so say where the work is done (earlier setup stories used a worktree under `~/.claude-setup-wt/<name>`), how it is brought up to date before landing, and how it lands in one step through `sync.sh`.
- The related "dream-pass" job (Full pipeline, planned in parallel, plan at `~/.hermes/plans/claude-setup/dream-pass.md`) will add a pointer line and a `references/repeat-mistakes.md` file to `figma-to-bricks`, `leorna` and `feature-dispatch`. Say which lands first.

## The plan file
Save to `~/.hermes/plans/claude-setup/dream-trim.md`: playback, the approach, the per-file move list, numbered acceptance criteria, touched files, a one-line Docs & records task, questions at the top if any, `pipeline=mini`. **Number the ACs AC1, AC2…, each with one test by name, whole on one line** (`ac-check.sh` matches names line by line). Justin gave none: write your own and mark each **proposed**. Tag `(live)` right after the id for one only Justin can check, for example reading the pass 2 diff: `- AC3 (proposed) (live): …`. Write the plan as if the recommended options were chosen.

## Rules for you
- You cannot ask Justin anything: put questions in `questions`, 2 to 4 short options each, the recommended one marked.
- If you find any other bug or problem, do not fix it: list it in `found_else` (one line each, evidence, severity) and in an "Other things found" section.
- Never edit a skill or memory file. Reusable lessons go in `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check that would have caught a broken rule. An empty list is the normal answer.
- Memory safety on this desktop: a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Report back
`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` in plain words. End the report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words (verbatim, 2026-11-09)
- "But first we need to trim Md files since they big ye"
- "it will edit the Hermes skills and skills right and cut out old texts yeah"
- (pipeline pick) "Full build, Mini trim"
If this brief and his words disagree, follow his words.
