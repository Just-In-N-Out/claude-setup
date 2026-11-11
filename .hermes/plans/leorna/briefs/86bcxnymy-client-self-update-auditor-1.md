# AC AUDITOR brief: 86bcxnymy, auditor round 1 (blind)

**Role:** AC AUDITOR (read only, blind) for Leorna story `86bcxnymy` (Client self-update to the admin-approved version, with staged rollout). **Model:** Opus 5.5, effort xhigh. You are fresh and blind: you get only the approved plan, the code and your own folder. Don't open any other folder of the evidence tree (no `verifier/`, no `review-*`, no `builder*`, no `*fix*`, no `control-plane/`, no `follow-ups.md`), any brief other than this one, or any report; prove every AC yourself.

## What you get

- **Approved plan** (the contract, read-only): `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/plan-approved.md`. ACs AC1–AC8; AC8 is `(live)`. Read "Two-repo verification mechanics" and "Host prerequisites" in it.
- **Client** (the repo every AC's named test lives in): worktree `~/Leorna/leorna-client/.claude/worktrees/86bcxnymy-client-self-update`, head **`76ed828f75a4e5e44f65fa021a5b35755e36b996`**, base **`a7839b3af664efcfa59eb1ed3fe276ec1262a4de`**.
- **Control plane** (the server the end-to-end ACs AC1, AC2, AC4, AC5 run against): worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcxnymy-client-self-update`, head **`54c8f1ae6fcd7a6e88630a69e8840366d34d188b`**. Build its binary yourself from your own detached copy of that head; a `vcs.modified=false` stamp doesn't prove a binary is unmutated, so never reuse a binary anyone else built.
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/auditor/` (write only there), and your own scratch at `~/.cache/86bcxnymy-aud1/` (`TMPDIR` there, short and real).

## What to do

1. Load skills and say so: `leorna` (auditor/verifier role; memory folder `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`), `engineering-best-practices`.
2. Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` ("Folders and the run recipe" and step 3, AC AUDITOR) exactly; `ac.json`'s format is at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Before judging, run `git log -p a7839b3..76ed828 -- <each AC's named test files>` and read every assertion against the plan's AC text.
3. For each of AC1–AC7: run its named test on the client head (`HEAD=` first line, `EXIT=` last; a `command` per row) and on the base in a separate copy with head's test files and the new packages' test files the AC imports, so it fails there. AC1, AC2, AC4, AC5 run against your control-plane binary with the plan's environment variables, in your own Postgres databases named `*_test` in `leorna-test-pg` (start it if Exited; never drop one you didn't create). AC7 runs natively on Windows through WSL interop (`leorna` `references/gates.md` has the recipe). For a clause the test seems not to exercise, prove it with a one-line overlay mutant the test must kill (under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, a no-mutation control first).
4. Take your own screenshot per AC (the real console page for AC1, AC2, AC4 from the page HTML the test saves; a terminal capture of the run for the others), with nothing drawn on the image (no banner, test name, SHA or note) and no URL bar, domain, tenant ID, token or email visible. AC8 (live) gets `"accepted": false, "not_run": "live: <why>"`.
5. Write `auditor/ac.json` and self-check it with `ac-check.sh` on a copy outside the evidence tree, without `--reviews` (blind: you never read reviews).
6. Change nothing in either story worktree. Remove your detached copies with `git worktree remove --force <own path>` (never a repo-wide prune) and drop only your own databases.
7. Long waits: poll in the foreground in steps under 3 minutes (`timeout 170 bash -c 'until <check>; do sleep 5; done'` with the Bash `timeout` above it); a bare `sleep` is refused; don't end your turn to wait.

## Rules

- Never push, post or touch ClickUp. Never send a server domain, URL or tenant ID anywhere; never print tokens. Never write into Justin's real `~/.codex` or `~/.claude`; the client runs in a scratch HOME.
- Anything else you find: `found_else` (one line each, with evidence and severity).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result; if killed, say so, find what grew, and rerun under the cap above.

## Return

`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
