# BUILDER brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **BUILDER** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent; this brief and the plan are your whole context.

**The plan is approved. Build it; don't re-plan.** Plan: `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md` (read-only approved copy: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`; never edit that copy). It holds the design, the code, tasks T0–T10, the AC → test map, gates, mutations, evidence and Docs & records. If the plan turns out wrong or is missing a decision you can't make safely, stop with `status: stopped`, say what's wrong and list the options. Don't redesign on your own.

## 1. Skills to load first (say so in your first steps)

Load each with the Skill tool, in this order (the plan's `## Skills` → Builder line, plus commit rules):
1. `leorna`: the **BUILDER** role (Doing a story, steps 2–5 and 4b), with its Step 1 context load. Stop at `ready-for-review`.
2. `engineering-best-practices`
3. `test-driven-development`: a failing test before each change.
4. `mutation-testing-discipline`: the declared-tool and secret-scan guards (the plan's mutation list).
5. `security-best-practices`: `exec` without a shell, temp files, nothing secret in logs.
6. `api-contract-drift-guard` and `backend-data-migrations`: both end with the Agent Defect Loop; confirm an empty contract diff and no migration, and report them in `defect_loop_skills[]`.
7. `git-commit-rules`: before your first commit.

A loaded skill's "spawn a subagent / independent reviewer" step is run by the main session, not you. You can't start agents.

## 2. Justin's answers (2026-10-24)

Justin said **go**: the plan as written plus every ⭐ answer.
- **Q1-A:** agent items pass as "skipped" with the reason.
- **Q2-A:** render warnings pass and are listed in the report; errors, empty output for a listed tool and unparseable files fail.
- **Q3-A:** copy the client's transformers into `internal/library/render`, pinned byte-for-byte to the client's goldens with a `SOURCE.md` hash list.
- **Q4-A:** add `github.com/BurntSushi/toml` v1.6.0 to parse Codex's rendered `config.toml`.
- **Q5-A:** port prompt rendering now behind a local `kindPrompt`; T7 only if PR #85 is on `origin/main` before you finish.
- **ACs approved:** AC1–AC3 (card), AC4 (proposed, approved), AC5 (proposed, **live**: hosted CI, owed to Justin; you don't run it).

Justin's words: "go". Earlier today: "Make sure that you're taking photos for each acceptance criterion."

## 3. Screenshots: one per AC (Justin's rule; they go to ClickUp)

- Follow plan **T9** exactly, and capture as each check runs, not at the end. Retake on the final head if the output changes.
- **AC1–AC4 each get a real screenshot.** These ACs have nothing visual, so use a real Terminal-window capture of the actual run showing the command, output and exit code (the `leorna` skill's terminal capture recipe: dedicated window, clean `bash --norc --noprofile`, wait for the `$ ` prompt, `screencapture -x -o -l <window id>`). Keep each run's log and a `.json` receipt holding its exit code.
- **The Markdown report (AC3)** also gets a real local rendering (offline, as the `leorna` skill describes), labelled a local rendering.
- **The before-state capture** (`before-main-accepts-broken-item.png`, plan T0) comes before your first code change.
- **AC5 is live:** no screenshot from you. Name it as owed to Justin.
- A staged screenshot of an unrun check never counts. Look at every screenshot yourself before listing it: no token, server domain, URL bar, tenant ID or email may be visible.
- Paths: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (`ac<n>-<what>-<sha7>.png`, `gates-<sha7>.txt` + `.json`, mutations log, `INVENTORY.md` mapping AC → test → log → screenshot). Write only in that folder's root. Never write into its `verifier/` or `auditor/` subfolders, and never edit `plan-approved.md`.

## 4. Names, base and gates

- Branch `feat/86bcm901u-quality-gate-v3`, worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, created from a freshly fetched `origin/main` exactly as plan T0 says (planned on `6e74ced`; follow T0's rule if it moved). No upstream.
- Commits `feat(86bcm901u): …` / `docs(86bcm901u): …`. Never override the author: before the first commit and at the end, `git log -1 --pretty=format:'%an <%ae>'` must be `Justin Issa <justin@leorna.com>`. No `Co-Authored-By` or AI attribution lines in any commit. Never commit a `CLAUDE.md`.
- Own test DB `leorna_86bcm901u_v3_test` (T0). Never use, share or drop another story's DB.
- Gates exactly as the plan's T10 and Gates sections say (CI's golangci-lint 2.14.0 first on PATH, `make check` with Postgres, `bash ./scripts/test-module-add.sh`, story gitleaks, `make library-check`, govulncheck v1.7.0). Run them on your final head and save each log with its exit code. If a gate fails for a reason outside the branch, reproduce it on the base and record it; don't fix it here.
- When you stop, the worktree must be **committed and clean** (no untracked files): the AC check script rejects anything else. Keep scratch outside the worktree (`~/.hermes/cache/scratch/86bcm901u-v3/`).

## 5. Boundaries

- **CI exception (story-only, Justin 2026-10-22, memory `no-ci-changes.md`):** you may change `.github/workflows/ci.yml` only as plan T6 says (one added step and one env block). No existing step is removed, reordered or weakened, and the gitleaks command stays unchanged.
- No push, PR, merge, remote CI run, credential or token-scope change, ClickUp write, comment or status change.
- Don't touch: local `main`; the earlier attempts (`feat/86bcm901u-content-quality-gate`, `feat/86bcm901u-quality-gate-v2`, every other `86bcm901u-*` worktree, plan, brief or evidence folder, and `leorna_86bcm901u*` DBs other than yours); the `86bcm9016-prompt-kind` and `86bcm901v-*` worktrees and their DBs; the real client checkout (clone into scratch per T0); `deploy/local/`.
- Never print tokens; never write a server domain, URL or tenant ID.
- **You can't ask Justin anything, and he is away (away grant, 2026-10-24: "keep it going throughout the pipeline and go with the recommendation; if it does not have a recommendation make it create one").** On a real trade-off, pick the option you recommend, apply it and write it down as "My ruling (away grant), not yet confirmed" with the reason. Stop with `status: stopped` only when every option would break a boundary in this section or change the approved ACs; then list the options **with your recommended one marked**, so the main session can apply it.
- **Low on steps:** commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and the last commit.
- **Found something else?** Don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer; list only what a future task needs that the skill doesn't already say, and only what you actually proved.

## 6. Your report

Return JSON-shaped output: `{name, status: ready-for-review|stopped, summary, base, last_commit, worktree, commits[], rulings[], steps_for_justin[], stop_reason, gates[{name, log, exit_code}], ac_evidence[{ac, test, log, screenshot}], shots[], mutations, defect_loop_skills[], found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
