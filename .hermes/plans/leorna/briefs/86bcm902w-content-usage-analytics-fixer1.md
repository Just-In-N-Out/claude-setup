
# FIXER 1 — leorna-control-plane, story 86bcm902w "Content usage analytics (which items get used)"

Role: the fixer after review 1 (`review-fix-cadence`: review 1 → **you** → review 2, a full fresh review of both repos → … until the referee says MOVE ON → verifier → blind auditor). Verify the P2 finding below, fix it test-first, commit, and stop at `ready-for-next-review`. No release, no hand-over.

## Where
- Control-plane worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics`, branch `feat/86bcm902w-content-usage-analytics`, base `b65f797ff6cdc56a802dfaf417b0adec96463317`. Reviewed head **`e184d9b58d70f3312eaac568aca0520cd90bb90e`**: confirm the worktree is at that head and clean before you start.
- **The client worktree is out of scope this round:** review 1 found it clean (MOVE ON at `db3e6b0`). Read it if you need to, but don't change or commit anything there; a client change would need its own review.
- Approved plan (read-only, never edit): `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md`. Working plan: `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md`; its section "Justin's answer after review 1" records the rule below.
- Review 1's evidence: `~/.hermes/plans/leorna/evidence/86bcm902w/review-1/` (`review.json`, `probe-seed-release_test.go.txt` (the probe that proves R1-1 against real Postgres and ClickHouse), gate logs). Reuse the reviewer's probe to prove the fix; copy what you need, don't edit that folder.
- The builder's records: `~/.hermes/plans/leorna/evidence/86bcm902w/INVENTORY.md` (with "Builder rulings"), `mutants-e184d9b.txt`, `harness/`.

## Skills (load them first with the Skill tool and say so)
`leorna` (fixer rules), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `multi-tenant-auth-management` (tenant versus shared seed rows), `git-commit-rules`.

## The finding to fix (referee output, verbatim)
```
R1-1  P2  internal/web/content_usage.go:75-81  contentPacks keeps the newest-created version per pack name across the tenant's versions and the shared seed base, so a later starter-pack seed release replaces the tenant's own edited starter pack on the page (the edit keeps the name 'Leorna starter pack'; EnsureSeedBase inserts each new seed release with created_at = now at startup)
```
Reviewer's scenario: an admin adds a company skill to the Leorna starter pack with the item editor. After the next control-plane upgrade ships a new starter-pack seed, the content usage page shows the shared seed as that pack (its items, 0 uses) and the company skill as "Not in a current pack", while the tenant's projects still use the edited pack. Probe evidence: after the edit the page shows `Leorna starter pack | v2026… | 7 | 1 | 1`; after a newer seed version is inserted the way `EnsureSeedBase` does it, `Leorna starter pack | 9.9.9-review1 | 6 | 0 | 0` and company-skill "Not in a current pack". AC2's fixture never loads the seed (builder ruling 10), which is why the tests missed it.

## Justin's decision for the fix (2026-10-29)
Justin picked **"Company's own pack wins"**: for each pack name, the page shows the **tenant's newest version**; the shared seed version shows **only when the tenant has no version of that name**. Don't derive pack rows from project assignments. This amends plan D7's pack-row rule only; the ACs and their test names are unchanged.

## How to work
- Verify the finding first (`receiving-code-review`): reproduce it with the reviewer's probe on `e184d9b`. If it doesn't reproduce, push back with evidence and stop.
- Then a failing Postgres test that loads the seed base with `EnsureSeedBase`, makes a tenant edit of the starter pack (adding an item), inserts a newer seed version the way `EnsureSeedBase` does, and asserts the page's pack row is the tenant's edited version with its items and counts, and the added item is not "Not in a current pack". Also cover: a tenant with no edit still sees the seed's newest version, and another tenant's edit never affects this tenant's row. Then fix.
- Prove the new rule with mutation (`mutation-testing-discipline`): at least "seed always wins", "newest by created_at regardless of owner" (the old rule) and "drop the tenant filter on the tenant's versions" must each be killed. Re-run the builder's control-plane mutants M1–M11 (from `harness/`) on the new head and record the results.
- Update any doc or page text that states the old rule (the metric README, the page's explanation, the spike write-up if it mentions it) so docs and code agree. Note in `INVENTORY.md` that builder ruling 4 (tie on equal creation time) is superseded or still applies, and why.
- AC test names stay exactly as the approved plan names them; add subtests or new tests as needed.
- Commits: `fix(86bcm902w): …`, small and often, by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or GIT_AUTHOR/COMMITTER variables; no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.
- The review-1 P3 findings (R1-2, R1-3) are **not** part of this fix: they go to the follow-up list. Don't change them.

## Gates and evidence
- Re-run on the final head: `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable `_test` DB `leorna_86bcm902w_fix1_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never another role's DB) and `LEORNA_TEST_CLICKHOUSE_URL` on the running `leorna-test-ch-86bcm902w` container at `127.0.0.1:18123` (reuse it; never stop or remove it), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, gitleaks on the story range, each AC test by name, and the `go test -json` check that Postgres and ClickHouse tests really ran.
- Evidence: per-head logs `gates-leorna-control-plane-<sha7>.txt` and `ac<n>-<sha7>.log` in `~/.hermes/plans/leorna/evidence/86bcm902w/`, plus your dispositions and probes in `~/.hermes/plans/leorna/evidence/86bcm902w/fix-1/` (create it; `dispositions.md` with R1-1's verdict, test, commit and evidence, and `mutants-<sha7>.txt`). Never write in `review-*`, `client/`, `verifier/` or `auditor/`, and never touch `plan-approved.md`. Re-capture a screenshot only if your fix changes what that page shows for the demo data, with the builder's recipe; keep any old one only as clearly named history and look at each new image yourself (no domain, URL bar, tenant ID, token or email). Update `INVENTORY.md` (AC map, rulings, which head each file comes from).
- Scratch: a fresh `<scratchpad>/86bcm902w-fix1/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries, Chrome profiles and mutation copies in `~/.cache/86bcm902w-fix1/`. Mutation copies are detached worktrees removed with `git worktree remove --force` on their exact path. **Never run `git worktree prune`.** Remove only your own folders, by literal absolute path, and drop your DB at the end. Leave the worktree committed and clean.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).
- You can't ask Justin anything. On a real trade-off, rule and write "My ruling, not yet confirmed" in `rulings[]` and INVENTORY.md. If the fix would need a design change beyond Justin's rule above, stop with `status: stopped` and list the options.

## Rules for every role
- If you find any other bug or problem outside this finding, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-next-review|stopped, summary, reviewed_head, new_head, client_head_unchanged: true|false, dispositions[{id, verdict: fixed|pushed-back, test, commit, evidence}], rulings[], gates[{gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], mutations{killed[], survived[], not_run[]}, shots[], found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
