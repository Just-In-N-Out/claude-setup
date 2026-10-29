# AC AUDITOR brief (blind, read only, round 3): 86bcm901r-starter-packs [leorna]

**Role:** AC AUDITOR for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). You are a fresh agent. Your one job: **prove every acceptance criterion yourself, from scratch**, following `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC work and its recipes; read it in full first). Your report is compared line by line with an independent one by a script; any disagreement counts as not accepted.

**You work blind.** You get only: the approved plan, the worktree, the head SHA, the base commit and your own folder. **Do not open, list, search or cite anything else in `~/.hermes/plans/leorna/evidence/86bcm901r/`** (other roles' folders and top-level files are there; looking at them breaks the audit), nor any brief other than this one, nor other agents' transcripts. Take your own screenshots and run your own checks. The plan names AC4's check files in `~/.hermes/plans/leorna/86bcm901r-ac4/` (outside the evidence folder): you may read and run those, read only. Don't open `~/.hermes/plans/leorna/86bcm901r-ac4-spike/` (the planner's trial receipts).

**Source is read only:** no commit, push, merge or file edit in the worktree; restore anything you touch. You write only into **`~/.hermes/plans/leorna/evidence/86bcm901r/auditor-1aa8ca3/`** (create it fresh with `mkdir`, no `-p`; stop and report if it already exists).

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Screenshots of logs use `ac-verification.md`'s WSL method.

## Your inputs (all of them)

- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (read-only copy). Read its top (status and Amendments: AC4 was amended on 2026-10-29 to an agent-run check, approved by Justin), the AC lines with their test names and commands, T7 (each AC's evidence, the dev-binary page capture, and "AC4's check").
- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs` (branch `feat/86bcm901r-starter-packs`). First confirm HEAD is the head below and `git status --porcelain` is empty; if not, stop and report.
- **Head:** `1aa8ca3107d1a0dbde3da57737ae7ac2e8182e4c`.
- **Base:** `e2254e0100a482b9201edf9b96f01936e4486d44` (GitHub `main`, the merge base). Where the plan says "migration 24", read this story's migration as it is named in the worktree now (`000026_starter_packs`: other stories took 24 and 25 on `main`).
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901r/auditor-1aa8ca3/`.

## What to prove

For each AC in the plan (AC1–AC5; none is live any more):
1. Read the AC and its named test or check. Decide for yourself whether it really proves every clause of the AC; where a clause looks unexercised, check it with a mutant (`go test -overlay`, read only, never the story worktree; `ac-verification.md` explains how) and read the line it fails on.
2. **Go tests (AC1, AC2, AC3, AC5):** run each **by its own name** on head from the worktree (`go test -v -count=1 -run '^<Name>$' <pkg>`; `go test` alone is safe there), saving `auditor-1aa8ca3/ac<n>-1aa8ca3.log` with first line `HEAD=<sha>` and last line `EXIT=<code>`. Then on base in a **separate detached worktree** at `e2254e0` with head's AC test file copied in (plus the test files of any package the story creates that it imports, and nothing else), saving `auditor-1aa8ca3/ac<n>-base-e2254e0.log`; it must fail to build or fail there.
3. **AC4 (agent-run check `ac4_starter_pack_desktop_sync`):** run the plan's command (`bash ~/.hermes/plans/leorna/86bcm901r-ac4/run.sh …`) on a checkout of head and on a checkout of base, each with its own new work folder, out folder and database. **Before the first run, read `run.sh` and `client-sync.go` yourself and confirm the client can't write into the real `/home/justin`** (`~/.claude`, `~/.agents`, `~/.cursor`, `~/.codex`, `~/.config/Leorna`): every client path must resolve inside the work folder, and the real-home fingerprint must run. If you find a way it could write there, stop and report; don't run it. Head must print `ok 1`, base `not ok 1`, each on its own lines. Check every clause of the AC line yourself against the run's output, not only the `ok` line. Name the logs like the Go ACs (`ac4-1aa8ca3.log`, `ac4-base-e2254e0.log`).
4. One screenshot per AC in your folder, taken by you: AC1 a real capture of the Content library page's Starter packs section from a binary **you build at the head** on a **fresh database of your own** (dev mode; the recipe is in the memory note `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md`, search "admin console screenshots work"); AC2, AC3, AC5 a rendered capture of your own log; AC4 the check's own captures from your run. Inspect each image (tall ones in bands ≤ 1,300 px); no URL bar, domain, tenant ID, token or email may show.

Write **`auditor-1aa8ca3/ac.json`** in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with each AC's `test` exactly as the plan names it. Every receipt it cites must be inside your folder (no links, no copies of other folders' files). Before handing back, self-check it blind as `ac-verification.md` says: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base e2254e0100a482b9201edf9b96f01936e4486d44 --plan ~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md <your ac.json> <scratch>/ac.json`, read its last line, then delete the copy.

## Database, scratch, siblings

- **Databases:** your own only, prefix `leorna_86bcm901r_audit3_`, ending `_test` (e.g. `…_audit3_test`, `…_audit3_base_test`, `…_audit3_demo_test`, `…_audit3_ac4_test`, `…_audit3_ac4_base_test`), in the `leorna-test-pg` container (port via `docker port leorna-test-pg 5432/tcp`; `psql` through `docker exec`). The password never goes on a command line or into a log. Never another database, never `leorna-pg`. Drop all of yours at the end.
- **Tools:** the Go toolchain is in `~/.local/leorna-toolchain` (Go 1.27.3; not on the default PATH: use a task-local PATH).
- **Scratch:** everything (detached copies, TMPDIR, GOTMPDIR, caches, binaries, Chrome profiles, AC4 work folders) in `~/.cache/86bcm901r-audit3/`, made fresh with `mkdir` (no `-p`). Nothing big on `/tmp`. At the end remove your detached worktrees with `git worktree remove`, stop any server you started by its verified PID, and `rm -r /home/justin/.cache/86bcm901r-audit3` by that literal path.
- Never touch the main checkout or another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Skills to load first (say so in your first steps)

1. `leorna` (read its rules; skip its Step 1 context load).
2. `engineering-best-practices`.
Then read `ac-verification.md` in full. Any "spawn a subagent" step in a skill is the main session's job, not yours.

## Rules

- You can't ask Justin anything.
- If you find a bug or problem, list it in `found_else` (one line each, evidence, severity P0–P3); don't fix anything.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{verdict: clean|findings, head, base, ac_status[{ac, accepted, test, screenshot, evidence, not_run}], ac_json, ac_check_self_test, ac4_home_isolation, found_else[], skill_lessons[]}`. `verdict`, `head`, `ac_status` and `ac_json` are required. `clean` means every AC (AC1–AC5) is accepted with your own receipts. Plain words.
