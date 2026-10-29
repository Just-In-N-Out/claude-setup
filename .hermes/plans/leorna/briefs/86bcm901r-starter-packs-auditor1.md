# AC AUDITOR brief (blind, read only): 86bcm901r-starter-packs [leorna]

**Role:** AC AUDITOR for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). You are a fresh agent. Your one job: **prove every acceptance criterion yourself, from scratch**, following `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC work and its recipes; read it in full first). Your report is compared line by line with an independent one by a script; any disagreement counts as not accepted.

**You work blind.** You get only: the approved plan, the worktree, the head SHA, the base commit and your own folder. **Do not open, list, search or cite anything else in `~/.hermes/plans/leorna/evidence/86bcm901r/`** (other roles' folders and top-level files are there; looking at them breaks the audit), nor any brief other than this one, nor other agents' transcripts. Take your own screenshots and run your own checks.

**Source is read only:** no commit, push, merge or file edit in the worktree; restore anything you touch. You write only into **`~/.hermes/plans/leorna/evidence/86bcm901r/auditor/`** (create it fresh with `mkdir`, no `-p`; stop and report if it already exists).

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Screenshots use `ac-verification.md`'s WSL method (a log rendered in a `<pre>` page, captured with Chrome for Testing).

## Your inputs (all of them)

- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (read-only copy; the ACs, their test names and commands are on its AC lines; its T7 explains each AC's evidence and the dev-binary page capture).
- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs` (branch `feat/86bcm901r-starter-packs`). First confirm HEAD is the head below and `git status --porcelain` is empty; if not, stop and report.
- **Head:** `398af64906adc26726f79cae81ce4d00355b7092`.
- **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`.
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901r/auditor/`.

## What to prove

For each AC in the plan (AC1, AC2, AC3, AC5 test-backed; AC4 is tagged `(live)`):
1. Read the AC and its named test in the source. Decide for yourself whether the test really proves every clause of the AC; where a clause looks unexercised, check it with a mutant (`go test -overlay`, read only, never the story worktree; `ac-verification.md` explains how) and read the line it fails on.
2. Run the test **by its own name** on head from the worktree (`go test -v -count=1 -run '^<Name>$' <pkg>`; `go test` alone is safe there), saving `auditor/ac<n>-<head7>.log` with first line `HEAD=<sha>` and last line `EXIT=<code>`.
3. Run it on base in a **separate detached worktree** at `6c1709e` with head's AC test file copied in (plus the test files of any package the story creates that it imports, and nothing else), saving `auditor/ac<n>-base-<base7>.log`; it must fail to build or fail there.
4. One screenshot per AC in `auditor/`, taken by you: AC1 a real capture of the Content library page's Starter packs section from a binary **you build at the head** on a **fresh database of your own** (dev mode; the recipe is in the memory note `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md`, search "admin console screenshots work": `LEORNA_DEV_MODE=1`, `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`, `/dev/login?next=<encoded page>`); AC2, AC3, AC5 a rendered capture of your own log. Inspect each image (tall ones in bands ≤ 1,300 px); no URL bar, domain, tenant ID, token or email may show.
5. AC4 `(live)`: you can't run it. Record `"accepted": false, "not_run": "live: needs Justin's own server installed from this branch and his desktop app"`.

Write **`auditor/ac.json`** in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Every receipt it cites must be inside `auditor/` (no links, no copies of other folders' files). Before handing back, self-check it blind as `ac-verification.md` says: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base 6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f --plan ~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md <your auditor/ac.json> <scratch>/ac.json`, read its last line, then delete the copy.

## Database, scratch, siblings

- **Databases:** your own only, `leorna_86bcm901r_audit1_test`, `leorna_86bcm901r_audit1_base_test` and a demo one (e.g. `leorna_86bcm901r_audit1_demo_test`), in the `leorna-test-pg` container (port via `docker port leorna-test-pg 5432/tcp`; `psql` through `docker exec`). The password never goes on a command line or into a log. Never another database, never `leorna-pg`. Drop all of yours at the end.
- **Tools:** the Go toolchain is in `~/.local/leorna-toolchain` (Go 1.27.3; not on the default PATH: use a task-local PATH).
- **Scratch:** everything (detached copies, TMPDIR, GOTMPDIR, caches, binaries, Chrome profiles) in `~/.cache/86bcm901r-audit1/`, made fresh with `mkdir` (no `-p`). Nothing big on `/tmp` (a small shared RAM disk). At the end remove your detached worktrees with `git worktree remove`, stop any server you started by its verified PID, and `rm -r /home/justin/.cache/86bcm901r-audit1` by that literal path.
- Never touch another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait (that counts as finishing); poll its log in the foreground in waits under 3 minutes each.

## Skills to load first (say so in your first steps)

1. `leorna` (read its rules; skip its Step 1 context load).
2. `engineering-best-practices`.
Then read `ac-verification.md` in full. Any "spawn a subagent" step in a skill is the main session's job, not yours.

## Rules

- You can't ask Justin anything.
- If you find a bug or problem, list it in `found_else` (one line each, evidence, severity); don't fix anything.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{verdict: clean|findings, head, base, ac_status[{ac, accepted, test, screenshot, evidence, not_run}], ac_json, ac_check_self_test, found_else[], skill_lessons[]}`. `verdict`, `head`, `ac_status` and `ac_json` are required. `clean` means every AC except the live AC4 is accepted with your own receipts. Plain words.
