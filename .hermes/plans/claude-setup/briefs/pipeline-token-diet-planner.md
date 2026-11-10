# Brief: planner — pipeline-token-diet (Mini pipeline, no card)

**Role:** PLANNER. You write a plan file only. No edits to skills, scripts, hooks, CLAUDE.md or memory. You don't start other agents.

**Skills to load first (Skill tool):** `engineering-best-practices`, `implementation-planning`. (No project skill exists for the setup repo.)

## What Justin asked (2026-11-10)

"We need to restructure the pipeline because it is burning a lot of tokens / due to usage limits." Asked which cuts are allowed, he picked all of them and added: **"just do a like total analysis and then see ok and then we will decide."**

So the main deliverable is a **measured, total analysis of where the pipeline's tokens go, plus priced options**. Justin picks from the options at plan approval. Don't pick for him: recommend, show the numbers, and put the choices as questions at the top of the plan.

All four kinds of cut are on the table:
1. Fewer agents per story (e.g. one AC proof instead of verifier + auditor, one full review instead of two, no re-verify after a pure rebase, one finisher instead of two).
2. Cheaper models / lower effort per role (now: planner, reviewers, verifier Fable 5.2 high; builder, fixers, auditor Opus 5.5 xhigh; finisher Opus 5.5 high). Fable and Opus share one Claude subscription limit.
3. Lighter briefs and skill loads (what each role must read before it starts).
4. Anything else the measurement shows (main-session orchestration overhead, hooks that send reports back, repeated gate runs, screenshots, CLAUDE.md size loaded into every agent, loops with no round cap).

## The pipeline as it is

- `~/.claude/CLAUDE.md` (30 KB): first section "Bugs and Stories: You Are the Orchestrator" and "Skills to Load While Coding".
- `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/`: `SKILL.md` (74 KB), `references/` (`mini-pipeline.md`, `review-loop.md`, `ac-verification.md` 32 KB, `model-routing.md`, `usage-and-cost.md`, others), `scripts/review-check.sh`, `scripts/ac-check.sh` and their `.test.sh` files.
- Role skills linked in `~/.claude/skills` → `~/.hermes/skills/software-development/` and `codex-imports/`.
- Hooks in `~/.claude/hooks/` (`subagent-ac-gate.sh`, `subagent-lessons-gate.sh`, `subagent-handback-gate.sh`, `skill-review-nudge.sh`, `orchestrator-guard.sh`) and `~/.claude/settings.json`.
- Codex shares the setup: `~/.codex/AGENTS.md` is generated from CLAUDE.md (`~/.claude/setup/codex/`).
- Past stories' briefs, plans and evidence: `~/.hermes/plans/<project>/` (e.g. `claude-setup/`, `leorna/`, FigmaToBricksV2's folder).

## The analysis to do (evidence, not estimates)

Measure from the real transcripts: `~/.claude/projects/*/<session>.jsonl` and the subagent transcripts beside them (find where this Claude Code version keeps them, e.g. `<session>/subagents/*.jsonl`). Each assistant line carries `message.model` and `message.usage` (`input_tokens`, `cache_creation_input_tokens`, `cache_read_input_tokens`, `output_tokens`). Write a small script in your scratch folder (`~/.cache/pipeline-token-diet-planner/`), keep it, and name it in the plan so the numbers can be rerun.

For the last 5–10 pipeline stories (pick ones since the 2026-11-09 model change where they exist, older ones as a second group), report:
- tokens per story, split by role (planner, builder, each reviewer round, fixers, verifier, auditor, finishers, main session) and by model, with input / cache-write / cache-read / output shown apart;
- number of agents and rounds per story (review rounds, verifier rounds, ac-check rounds), and what triggered the extra rounds;
- for a typical agent of each role: tokens spent before its first useful action (skill loads, CLAUDE.md, brief, reference files), versus the work itself;
- the main session's own share (orchestration turns, pasted reports, hook send-backs);
- the top 5 single biggest costs, whatever they are.

Map each agent to its role from its brief/prompt text and the briefs folder. Where a number can't be measured, say so plainly; don't guess. Subscription limits weight models differently; if you can't find the real weighting, show raw tokens per model and say the weighting is unknown.

Then, for each candidate cut: what it changes, the measured saving (tokens and % of a typical story), what protection is lost (name the past incident a rule exists for: the *Why* notes in CLAUDE.md and the skill, e.g. harness-guards 2026-10-28 unreviewed fix rounds), and which files change. Finish with 2–3 packaged options (e.g. light / medium / deep cut) and your recommendation.

## The plan file

Write `~/.hermes/plans/claude-setup/pipeline-token-diet.md`:
- questions for Justin at the top (the choices he must make), each with your recommendation;
- one-line playback;
- the analysis (tables; keep prose short) and the packaged options;
- **numbered acceptance criteria AC1, AC2…**, each marked **proposed**, one named test each, written for your recommended option and noting which ACs change under the other options. Tag `(live)` right after the id for an AC only Justin can check (`- AC3 (proposed) (live): …`). Changed scripts keep passing their `.test.sh`; rule text changes need a checkable AC too (e.g. a grep/consistency check that CLAUDE.md, `mini-pipeline.md`, `model-routing.md` and the scripts agree);
- tasks a fresh builder with no context could follow, touched files, a one-line docs & records task (setup sync, regenerating `~/.codex/AGENTS.md`).

Mini mode: short plan, the analysis is the bulk of the work. If the restructure turns out bigger or riskier than a Mini job, say so in your summary and recommend Full.

## Rules for every agent

- **Memory runaways (Windows desktop):** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result; if it was, say so in the report and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Transcripts are big: stream them (one `jq -c` pass per file or Python line by line), never load them all at once.
- Known traps here: `grep` in the Bash tool is ugrep (use `/usr/bin/grep` for big bounded repeats); jq `scan`/`gsub` are quadratic on big strings and `--arg` caps at 128 KB (use `--rawfile`).
- Don't print transcript contents in your report: numbers and file paths only.
- **skill_lessons:** list reusable lessons (a gotcha, an approach that worked after one failed, a skill step that was wrong or missing) as `skill_lessons[{skill, lesson, evidence, enforce}]`; `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is the normal answer. Never edit skills or memory yourself.

## Report back

The plan path, a 10-line summary (biggest costs, the options with their savings, your recommendation, open questions), the script path, `skill_lessons`, and end with the line:
`MAIN SESSION: check and save these skill_lessons now.`
