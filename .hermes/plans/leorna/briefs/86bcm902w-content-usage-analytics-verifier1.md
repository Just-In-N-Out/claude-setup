
# VERIFIER (read only) — leorna-control-plane + leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: the fresh, read-only verifier of the Full pipeline (Agent Defect Loop verifier, after review 1 → fixer 1 → review 2, which was clean in both repos). You never saw the build, the reviews or the fix. Change no source. If you're clean, a blind AC auditor runs next and `ac-check.sh` compares your `ac.json` with the auditor's.

## What to verify
| | Control plane (the `ac-check.sh` repo) | Client (supporting receipts) |
|---|---|---|
| Worktree | `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics` | `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics` |
| Head | **`de5fbe0755a41e0528815ef3b72509aeadb20c3c`** | **`db3e6b0f76652088c11fafa8c3c54509f62116f7`** |
| Base (`git -C <worktree> merge-base HEAD origin/main`) | **`b65f797ff6cdc56a802dfaf417b0adec96463317`** | **`f105e27814b6efbec67059687963e722933acec2`** |

- Confirm both worktrees are at those heads and clean (`git status --porcelain --untracked-files=all` empty) before and after.
- Control-plane GitHub `main` has moved to `e2254e0` (PR #101, story 86bcm902a, merged). It overlaps this story only in `README.md`, `delivery/stories.json` and `internal/web/handler.go`; bringing main in is the finisher's job at "make a PR", with Justin's OK. **Verify against base `b65f797`, not the new main**, and don't return `integration-required` for this.
- Approved plan, read-only, the only AC source: `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md`. Justin later amended one design rule after review 1 (not an AC): for each pack name, the page shows the **tenant's newest version**, and the shared seed's newest version only when the tenant has no version of that name ("Company's own pack wins"; recorded in the working plan `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md`, section "Justin's answer after review 1"). Judge pack rows by that rule.
- The history to check is closed (as claims, not facts):
  - review 1: `~/.hermes/plans/leorna/evidence/86bcm902w/review-1/` and `…/client/review-1/` (`review.json`, probes, logs);
  - fixer 1: `…/86bcm902w/fix-1/` (`dispositions.md`, probes, RED/GREEN logs, `mutants-de5fbe0.txt`);
  - review 2: `…/86bcm902w/review-2/` and `…/client/review-2/`;
  - the builder's and fixer's records: `…/86bcm902w/INVENTORY.md` (10 builder rulings, fixer 1 rulings F1-a and F1-b), `mutants-*.txt`, `harness/`.

### Findings and their claimed closure
- **R1-1 (P2, review 1 on e184d9b):** `contentPacks` kept the newest-created version per pack name across tenant and seed, so a later starter-pack seed release replaced the tenant's edited pack on the page. Claimed closed by fixer 1 (088af45, 7eb18e4, de5fbe0) with `TestContentUsageCompanyPackWinsOverSharedSeedWithPostgres` and `TestContentUsageChoosesTheCompanyVersionOfEachPack`; review 2 found it holds. Confirm it yourself, and look for regressions the fix caused.
- All other review findings are P3 and on the follow-up list (`…/86bcm902w/follow-ups.md`): don't re-judge them, but report anything worse you find.

## The approved ACs (none is `(live)`; all named tests are control-plane tests)
- AC1: Given a spike, then we document per tool whether item usage can be detected from transcripts. Test `TestContentUsageAC1SpikeMatchesSupportTable`.
- AC2: Given supported tools, then item usage counts are shown per pack and item. Test `TestContentUsageAC2CountsPerPackAndItemWithPostgres`.
- AC3: Given unsupported tools, then the UI states that usage is not measurable there. Test `TestContentUsageAC3NotMeasurableIsStated`.
- AC4 (proposed, approved): admin-only page, tenant-isolated, uploads counted for the signed-in user and tenant. Test `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres`.
- AC5 (proposed, approved): an upload carries only item identifiers; anything else → 400, nothing stored. Test `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres`.

## Skills (load them first with the Skill tool and say so)
`leorna` (VERIFIER role), `engineering-best-practices`, `mutation-testing-discipline`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` and `backend-data-migrations` (both end with "Mandatory Validation and Agent Defect Loop": you are their loop verifier; re-run their Required Validation Gates). Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow its VERIFIER part, its folders and run recipe exactly.

## What to do
1. **Gates on the heads:**
   - Control plane `de5fbe0`: `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm902w_verify1_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never another role's DB) and `LEORNA_TEST_CLICKHOUSE_URL` on the running `leorna-test-ch-86bcm902w` container at `127.0.0.1:18123` (form in the plan's T0.5; reuse it, never stop or remove it), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, gitleaks on the story range, and the `go test -json` check that the Postgres and ClickHouse tests really ran.
   - **Keep `/usr/local/bin` on any PATH you narrow:** gitleaks 8.30.1 lives only there on this desktop, and without it 6 item-editor Postgres tests fail with 503 "secret scanner unavailable" (an environment failure; review 2 hit it by copying the plan's "Common environment" PATH).
   - Client `db3e6b0`: `make check` with a real, non-symlinked `TMPDIR`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's golangci-lint first on PATH, the plan's supporting client tests, and both `cmp` checks (golden upload body, OpenAPI spec). Name the client head in your `ac.json` evidence lines.
2. **Closure:** confirm R1-1 is closed on `de5fbe0` (reuse review 1's seed-release probe from its `_test.go` log prefixes, not a name search) and look for regressions the fix caused. Use mutations in your own detached copy (or `go test -overlay`) where a claim rests on a test.
3. **The AC work** from `ac-verification.md`: run each AC's test alone on head and on the base commit (a separate detached copy with only that AC's test files from head, plus the test files of packages the story creates that the test imports), write `ac<n>-de5fbe0.log` / `ac<n>-base-b65f797.log` and one screenshot per AC into your own folder (a real UI capture for AC2 and AC3; the rendered spike table for AC1; a terminal-log capture for AC4 and AC5), and write `~/.hermes/plans/leorna/evidence/86bcm902w/verifier/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Self-check it blind as `ac-verification.md` says (copy to scratch, run `ac-check.sh --repo <cp worktree> --base b65f797ff6cdc56a802dfaf417b0adec96463317 --plan <evidence>/plan-approved.md <your copy> <your copy>` without `--reviews`, then delete the copy).
4. `verdict: clean` requires every AC accepted on `de5fbe0` with its test and screenshot, client supporting receipts green on `db3e6b0`, and no open P0–P2 finding. Otherwise `verdict: findings`.

## Boundaries
- Read only: change no source, commit nothing, push nothing, post nothing. Mutations, base runs and captures only in your own detached copies under `~/.cache/86bcm902w-verify1/` (`git -C <worktree> worktree add --detach <path> <sha>`), each removed with `git worktree remove --force` on its exact path. **Never run `git worktree prune`.**
- Write only in `~/.hermes/plans/leorna/evidence/86bcm902w/verifier/` (create it) and your own scratch: a fresh `<scratchpad>/86bcm902w-verify1/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries, Chrome profiles in `~/.cache/86bcm902w-verify1/` (`/tmp` is a small shared RAM tmpfs). Never write into `auditor/`, `review-*`, `client/`, `fix-1/` or the builder's files, and never touch `plan-approved.md`. Remove only your own folders, by literal absolute path, and drop your DB at the end.
- Never read or write Justin's real `~/.claude`, `~/.codex` or `~/.cursor` beyond read-only checks of installed tool binaries; any real-tool run uses an isolated HOME.
- Never touch other stories' worktrees, branches, DBs or evidence. No other containers.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused). Keep receipts on disk as you go.

## Rules for every role
- If you find any other bug or problem outside this story's diff, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, verified_heads{control_plane, client}, base{control_plane, client}, findings[{id, severity: P0|P1|P2|P3, claim, evidence}], closure[{id, closed, evidence}], rulings_review[{ruling, agree, why}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{repo, gate, exit, log}], ac_json, self_check, defect_loop_skills[], found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
