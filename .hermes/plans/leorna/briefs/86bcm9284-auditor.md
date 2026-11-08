# Brief: 86bcm9284 AC auditor (blind)

**Role:** a fresh, read-only AC AUDITOR for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). You prove every acceptance criterion yourself from the approved plan and the code. Change no source, commit nothing, push nothing, write nothing to ClickUp. Do not open any other evidence folder under `~/.hermes/plans/leorna/evidence/86bcm9284/` besides your own, and don't read any report or review there: the point is an independent second proof.

**You get only:**
- Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md`
- Worktree (leorna-control-plane): `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`
- Head: `beb53581bc18ab4d1a61a3a74b2330cd4110f228`
- Base: `f0a326b83aae9d181e4f6681645685ae4b1fff91`
- Your folder: `~/.hermes/plans/leorna/evidence/86bcm9284/auditor/` (create it). Every receipt you cite lives here, made by you.
- Scratch: a fresh `~/.cache/86bcm9284-auditor/` (create it with `mkdir`, not `-p`; never `/tmp`, a 7.9 GB RAM tmpfs shared by every session). Put `TMPDIR`, Chrome profiles, binaries, detached copies and Postgres data there, and remove only that folder, by its literal absolute path, at the end. Own Postgres container on a free loopback port with your own `_test` DB; never `leorna-pg` or a sibling's.

## Skills to load (Skill tool)
`leorna` (hard rules and the gate/DB-skip rules; also read `leorna-control-plane-workflow.md`), `engineering-best-practices`. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow its run recipe, and the ac.json format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Toolchain: `~/.local/leorna-toolchain` (CI versions), task-local PATH.

## What to do
1. Read the plan's ACs and their named tests. AC tags in the plan are authoritative (`(live)`, done, characterization notes). Before judging an AC, run `git log -p <base>..HEAD -- <its test files>` and read every assertion against the AC text: is the test as wide as the AC?
2. For each AC, run its named test on head and on base (a separate detached copy with head's test files, never in the worktree), per the recipe: `HEAD=` first line, `EXIT=` last. An AC the plan says passes on base by design takes `base_exempt` with a reason, after you've run it on base. In that case, also prove the test can fail, with your own mutant (e.g. `go test -overlay`), as a supporting receipt.
3. An AC tagged `(live)` that only Justin can complete gets `"accepted": false, "not_run": "live: <why>"`, but run its agent-side test anyway and keep the receipts.
4. One screenshot per AC, taken by you: a real capture of the visible result where there is one (the plan says which), otherwise a terminal-style capture of the run showing command, output and `EXIT=`. Check that no URL bar, token, email or tenant ID is visible.
5. Write `auditor/ac.json` (head = the head above). Self-check it blind: `cp` your ac.json and receipts into scratch and run `ac-check.sh --repo <worktree> --base <base> --plan <plan-approved.md> <your ac.json> <scratch copy>/ac.json`, without `--reviews`.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
`verdict`, `ac_status` per AC (accepted / not_accepted with reason / not_run live), the ac.json path and its self-check last line, any AC whose test is narrower than its text, and skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
