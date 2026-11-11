# AC AUDITOR brief, round 1: 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: AC AUDITOR (blind; a fresh general-purpose agent on Opus 5.5, xhigh effort). Source read-only: change no source, commit nothing, restore anything you touch. Start no other agents. You get only what is below. **Don't open any other folder of the evidence tree** (not `verifier/`, `review-*/`, `fix-*/`, `build/`, nor the builder's root receipts) and don't read any other agent's report: your proof must be your own.

- Approved plan (the contract, read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Its numbered ACs are AC1–AC5; each AC line names its test.
- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update` (repo leorna-control-plane).
- Head: `b9f1804631fbf6ffc20d0d0d6e0e103d67dff627`. Base commit: `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Your folder (write only here): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/auditor/`.

## Your job
Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` whole (the AC work, folders and run recipe) and the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Then, on your own:
1. For every AC, decide from the plan what proves it, and read its test against every clause of the AC line. If a clause isn't exercised by the test, prove it yourself with a `go test -overlay` mutant (memory-capped) that the AC's test kills, reading the line it failed on; if you can't, the AC isn't accepted.
2. Run each AC's own test on head (`auditor/ac<n>-b9f1804.log`, first line `HEAD=<sha>`, last `EXIT=<rc>`) and on the base commit in a separate detached copy with head's test files (`auditor/ac<n>-base-4ef14ef.log`). The base must fail on its own line or a build/import failure of the new code; `[setup failed]`, a missing test or "no tests" don't count. Label any base-tree additions (for example head's new package) on the log's second line.
3. Take your own screenshot per AC (a real console capture through headless Chrome against a local server with fixtures, or a terminal capture of the run rendered in Chrome on WSL with the recipe in `ac-verification.md`). Images show the result only: nothing drawn on them. Check each image for domains, URL bars, tenant IDs, tokens and emails.
4. AC5 is tagged `(live)`: `"accepted": false, "not_run": "live: owed to Justin"`.
5. Write `auditor/ac.json` with a `command` per row, then self-check it as `ac-verification.md` says (copy into your own scratch, run `ac-check.sh` without `--reviews`, delete the copy).

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (auditor/verifier AC rules), `engineering-best-practices`, `mutation-testing-discipline`.

## Rules
- Postgres: your own capped container (`xnyk-audit1-pg`, `--memory 1g`, CI's pinned image from `.github/workflows/ci.yml`, a database ending in `_test`). Wait for it with TCP `docker exec <c> pg_isready -h 127.0.0.1` in a loop that **fails** when its bound (3 minutes) runs out: under load the init takes about 2 minutes. Never use anyone else's container. Stop and remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command dying with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Scratch: your own `~/.cache/86bcxnykn-audit1/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths (Chrome: `~/.cache/xa1/{t,u}`). Remove detached copies by their own path with `git worktree remove --force`, never `git worktree prune`. Before handing back, gitleaks-scan your folder.
- Go toolchain: `~/.local/leorna-tools/` holds the CI-pinned binaries; use them by absolute path.
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes, the Bash `timeout` above each bound.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, ac_status[{ac, accepted, test, screenshot, evidence}], findings[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
