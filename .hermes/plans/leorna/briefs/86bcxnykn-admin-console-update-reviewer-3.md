# REVIEWER brief, round 3 (main bring-in): 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: REVIEWER (a fresh general-purpose agent on Opus 5.5, high effort). Report only: change no source, commit nothing, restore anything you touch. Start no other agents.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`. **Head: `6517bb18d5ac95ce9f546d9ad992248e081c1d37`.** Last reviewed head (round 2, clean): `b9f1804631fbf6ffc20d0d0d6e0e103d67dff627`. Story base: `4ef14efb46da789aec30fad1e5a988d8770140e2`. GitHub main brought in: `de4da62` (through `62c6d7d`).
- Approved plan (read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. ACs AC1–AC5 (AC5 live, owed to Justin).
- Your folder (write only here): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/review-3/`. Write `review-3/review.json` in the format the referee reads: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh` (read its header) and `feature-dispatch/references/review-loop.md`. Record `head` as the full SHA above and the scope as the commits `b9f1804..6517bb1`.
- Deferred P3s: `follow-ups.md` in the evidence root. Don't re-raise them.
- The fixer's receipts (read them, but prove claims yourself): `main-merge/` (merge-verify.txt, gates-6517bb1.txt, migration-000035-6517bb1.txt, toolchain.txt, the AC logs, red-ac3-schema-number-835fb91.log).

## What to review: only `b9f1804..6517bb1` and what it touches
Commits: `c7595c0` merge of main 62c6d7d (hand-resolved: `delivery/stories.json`, `internal/audit/README.md`, `internal/store/postgres/store_test.go`, `internal/web/handler.go`); `835fb91` renumber 000032 → 000035; `28eb08b` AC3 test reads the newest schema version from the embedded migrations instead of the hardcoded 32; `a5ec79c` comments naming the release-notes function instead of a line number; `6517bb1` clean merge of main de4da62.

Check, following the `leorna` skill's bring-in checks (SKILL.md, the long merge line in step 7) and `code-review-practice`:
1. The merges: files differing from both parents equal the both-sides set; one-sided files equal their side; the hand-resolved lines are the exact union (stories.json entry appended last with every earlier entry unchanged by value; store_test.go migration and drop lists; handler.go nav); the story's own patch survived; `6517bb1`'s tree equals `git merge-tree --write-tree` of its parents.
2. The renumber: no duplicate version (`ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` empty); SQL bytes unchanged; the down still drops only this story's table; nothing else in the tree still names 000032 or version 32 for this story (grep strings in tests, docs, README, the plan-named runbook and PR text at `~/.hermes/cache/scratch/leorna-pr-86bcxnykn-admin-console-update.md`, which will need the new number at "make a PR": report it as a record to update, not a code finding).
3. `28eb08b` must not narrow AC3's test: read the diff against the plan's AC3 line; check the new expression can still fail (an overlay mutant under the memory cap that the test kills).
4. Interactions with what main brought in: new routes vs `/admin/updates` (build the handler: `go test -count=1 ./internal/web/` with no DB URL); OIDC SSO's admin/session changes vs this story's admin-only + CSRF checks on the two new operations and the page; audit action lists; the v0.2.0 release notes from #127/#130 vs the release feed's digest parsing (`DigestFromNotes`; the fixer reported a P3 about a duplicated `Control-plane image: ` line, judge it yourself); OpenAPI still additive only against main.
5. Grep the tree for this card ID next to until/once/later, and siblings' "once 86bcxnykn…" wording.

Severity rules: as in `~/.claude/CLAUDE.md` pipeline step 5 (P0–P3; a P0–P2 needs a concrete real-use scenario).

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `backend-data-migrations`, `api-contract-drift-guard`, `security-best-practices`, `multi-tenant-auth-management`, `mutation-testing-discipline`.
Read before starting: `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Rules
- Go tools: `~/.local/leorna-tools/go/bin/go` (now go1.27.4) by absolute path, `GOTOOLCHAIN=local`.
- Postgres if needed: your own capped container (`xnyk-review3-pg`, `--memory 1g`, CI's pinned image, a database ending in `_test`); wait with TCP `docker exec <c> pg_isready -h 127.0.0.1` in a loop that fails when its 3-minute bound runs out. Stop and remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`; check earlyoom before reading a killed command as a result. Mutants under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Scratch: your own `~/.cache/86bcxnykn-review3/`, created fresh with `mkdir` (no `-p`). Never `git worktree prune`.
- Don't end your turn to wait for a background command; bounded foreground polls under 3 minutes.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{verdict: clean|findings, findings[{id, severity, file, line, claim, scenario, evidence}], ac_status[{ac, accepted, test, evidence}], records_to_update[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
