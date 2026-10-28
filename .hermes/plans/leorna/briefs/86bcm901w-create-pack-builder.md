
# BUILDER — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: BUILDER (Full pipeline). Build the approved plan; don't re-plan.

## Inputs
- **Approved plan:** `~/.hermes/plans/leorna/86bcm901w-create-pack.md` (read-only copy: `~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md`). Read "Justin's answers (2026-10-28)" right under its questions first.
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, clean at base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`, no commits yet.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901w/` (the plan's `$EVID`). Write only there and in your own scratch folder; never inside `verifier/` or `auditor/`.

## Justin's go and answers
Justin approved the plan on 2026-10-28 with every ⭐ answer, before stepping away. His words: "Okay, look, I'm gonna go shower, so just keep this running, okay? Just go with the recommended stuff the agent says, alright?"
- Q1 → A: pack names unique per company, ignoring case (409).
- Q2 → A: only packs made in the library get versions 1, 2, …
- Q3 → A: Justin turns on Docker's WSL integration and runs `sudo apt-get install -y make`; you install Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 into `~/.local/leorna-toolchain/` exactly as B0.3 says (under its `flock`, checksum-checked, reusing what a sibling already installed).
- ACs: AC1–AC3 (card) and AC4 (proposed), approved. None is live.

## What to do now (the environment is not ready yet)
At approval, Justin's two Q3 steps were not done: `docker` is only the Windows stub ("could not be found in this WSL 2 distro"), and there's no `make`. You can't run `sudo` and must not work around these two (no user-space Postgres, no `make` from a downloaded package): the approved route is Justin's.

1. Do B0.1 (worktree check), B0.2 (HTTPS fetch through gh; follow the plan if `main` moved), B0.3 (tool installs, except stop-on-`make`, see below) and B0.5 (Chrome check). Write `tools.txt` as B0.3 says.
2. Check `command -v make` and `docker version`. **If both work** (Justin may have done them meanwhile), continue the plan in order from B0.4 to B12 and stop at `ready-for-review`.
3. **If either is missing:** build **B1 and B2 only**, test-first with plain `go test` in `internal/pack` (no `make`, no database), one commit per task with its RED and GREEN logs in `$EVID`. Don't start B3 or later. Then stop with `status: stopped`, `stop_reason: "blocked: make, docker"` (name only what is still missing), the last commit and what B0 installed.
4. When unblocked later (you may be continued with a message), B0.6 (base baseline) and B0.7 (before-screenshot of `/admin/library`) run from a **detached copy at `BASE`**, never from the worktree, since B1/B2's commits are already there. Then carry on from B3.

## Skills
Load, in this order, and say so in your first steps: `leorna` (BUILDER role; skip its Step 1 load, the plan did it), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`, `security-best-practices` (its Go reference, as the plan's Skills table says), `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. The last two end with a Mandatory Validation and Agent Defect Loop: their independent finder and verifier are run by the main session as the reviewers and verifier, so you don't start agents. Any skill step that says "spawn a subagent" or "independent reviewer" is the main session's job.

## Rules
- **Never** push, open a PR, merge, or post to ClickUp. Commits only, on `feat/86bcm901w-create-pack`, as `feat(86bcm901w): …`. Let git use the repo's identity (`Justin Issa <justin@leorna.com>`): no `-c user.*`, no `--author`, no AI attribution lines. Never stage a `CLAUDE.md`.
- **Sibling stories** 86bcm901a, 86bcm901b, 86bcm901j run in other sessions in this repo: never touch `.claude/worktrees/86bcm901{a,b,j}-*`, their branches, their `leorna_86bcm901{a,b,j}_*` databases or their evidence folders. Use only `leorna_86bcm901w_test` and `leorna_86bcm901w_base_test`. The shared `leorna-test-pg` container and `~/.local/leorna-toolchain/` are reused, never removed or reinstalled over a sibling's matching version. Stay within this plan's files; whoever merges second rebases.
- **Shell:** use absolute paths (`git -C "$WT" …`), not `cd` into other repos. Never use bare `git stash`/`git stash pop` (the stash stack is shared with every worktree). Don't edit `~/.bashrc` or any global PATH; set PATH per command as the plan's variables block does.
- **No CI changes:** nothing under `.github/`.
- **Rulings:** you can't ask Justin anything. On a real trade-off, make the ruling, write it down as "My ruling, not yet confirmed" in `rulings[]` and in your own section of `$EVID/INVENTORY.md`. If it can't be decided safely, or the plan is wrong or missing a decision, stop with `status: stopped` and list the options; don't redesign.
- **Out of steps:** commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit.
- **Evidence:** one screenshot per AC as the plan's E1–E3 say (real admin-console captures where the AC is visible; a rendered log page otherwise), and per-head gate logs `gates-<sha7>.txt` with `EXIT=` lines. A before-screenshot comes from the untouched base copy. A missing capture stays owed and named; never stage one.
- **Scratch:** keep all scratch in a fresh `<scratchpad>/86bcm901w-builder/` (`mkdir` without `-p`, so it fails if it exists) and remove only that folder. `<scratchpad>` is this session's scratchpad: `/tmp/claude-1000/-home-justin-Leorna/c8a927b5-84b2-4b8a-835c-246c9f835a01/scratchpad`.
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.

## Output (your final message)
`{name: "86bcm901w-create-pack", status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, commits[], gates[{name, exit, log}], ac_status[{ac, test, red_log, green_log, screenshot}], shots[], defect_loop_skills[], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
