# AC AUDITOR brief, round 2: 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: AC AUDITOR (blind; a fresh general-purpose agent on Opus 5.5, xhigh effort). Source read-only: change no source, commit nothing, restore anything you touch. Start no other agents. You get only what is below. **Don't open any other folder of the evidence tree** (not `verifier/`, `verifier-2/`, `auditor/`, `review-*/`, `fix-*/`, `main-merge/`, `build/`, `finisher/`, nor the root receipts) and don't read any other agent's report: your proof must be your own.

- Approved plan (the contract, read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Its numbered ACs are AC1–AC5; each AC line names its test. The plan names migration 000032; other stories took 000032–000034 on main, so the story's migration is now **000035**. Read every 000032 in the plan as 000035.
- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update` (repo leorna-control-plane).
- Head: `6517bb18d5ac95ce9f546d9ad992248e081c1d37`. Base commit: `de4da6232114b9ee7107d3e2858481a488ed6165` (GitHub main, merged into the branch).
- Your folder (write only here): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/auditor-2/` (create it).

## Your job
Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` whole (the AC work, folders, run recipe and what counts for a clause a supporting test proves) and the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Follow `ac-verification.md` where this brief is silent. Then, on your own:
1. For every AC, decide from the plan what proves it, and read its test against every clause of the AC line. For a clause the AC's own test doesn't exercise, prove it with a `go test -overlay` mutant (memory-capped) that the test kills, reading the line it failed on, or handle it as `ac-verification.md` says.
2. Run each AC's own test on head (`auditor-2/ac<n>-6517bb1.log`, first line `HEAD=<sha>`, last `EXIT=<rc>`) and on the base commit in a separate detached copy with head's test files (`auditor-2/ac<n>-base-de4da62.log`). The base must fail on its own line or a build/import failure of the new code; `[setup failed]`, a missing test or "no tests" don't count. Label any base-tree additions (for example head's new package) on the log's second line.
3. Take your own screenshot per AC (a real console capture through headless Chrome against a local server with fixtures, or a terminal capture of the run rendered in Chrome on WSL with the recipe in `ac-verification.md`). Images show the result only: nothing drawn on them. Check each image for domains, URL bars, tenant IDs, tokens and emails.
4. AC5 is tagged `(live)`: `"accepted": false, "not_run": "live: owed to Justin"`.
5. Write `auditor-2/ac.json` with a `command` per row, then self-check it as `ac-verification.md` says (copy into your own scratch, run `ac-check.sh` without `--reviews`, delete the copy).

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (auditor/verifier AC rules), `engineering-best-practices`, `mutation-testing-discipline`.

## Rules
- Go toolchain: `~/.local/leorna-tools/` holds the CI-pinned binaries (go is go1.27.4); use them by absolute path with `GOTOOLCHAIN=local`.
- Postgres: your own capped container (`xnyk-audit2-pg`, `--memory 1g`, CI's pinned image from `.github/workflows/ci.yml`, a database ending in `_test`). Wait for it with TCP `docker exec <c> pg_isready -h 127.0.0.1` in a loop that **fails** when its bound (3 minutes) runs out. Never use anyone else's container. Stop and remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command dying with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Scratch: your own `~/.cache/86bcxnykn-audit2/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths (Chrome: `~/.cache/xa2/{t,u}`). Remove detached copies by their own path with `git worktree remove --force`, never `git worktree prune`. Before handing back, gitleaks-scan your folder.
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes, the Bash `timeout` above each bound.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, ac_status[{ac, accepted, test, screenshot, evidence}], findings[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
