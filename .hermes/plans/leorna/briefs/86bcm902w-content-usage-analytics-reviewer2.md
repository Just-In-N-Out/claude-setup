
# REVIEWER 2 (review only) — leorna-control-plane + leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: round 2 of the review loop (Full pipeline: round 2 is again a **full** review of the whole story from base, in **both** repos). You are a fresh agent: you never saw the build, review 1 or the fix. Report only: change no source. The loop's mechanics are in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (read "The reviewer's duties" and "Records"); the severity scale is in `review-fix-cadence`.

## What to review
| | Control plane | Client |
|---|---|---|
| Worktree | `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics` | `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics` |
| Branch | `feat/86bcm902w-content-usage-analytics` | `feat/86bcm902w-content-usage-analytics` |
| Base (`from`) | `b65f797ff6cdc56a802dfaf417b0adec96463317` | `f105e27814b6efbec67059687963e722933acec2` |
| Head to review | `de5fbe0755a41e0528815ef3b72509aeadb20c3c` (12 commits: the build plus fixer 1's 088af45, 7eb18e4, de5fbe0) | `db3e6b0f76652088c11fafa8c3c54509f62116f7` (6 commits, unchanged since review 1; mostly regenerated `api/controlplane.gen.go`) |

- Confirm each worktree is still at that head before you start, and name the heads you reviewed.
- Review `git diff <base>...<head>` in each repo against the approved plan `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md` (read-only; its "Justin's answers" section records the approved choices) and the `leorna` skill's rules.
- The builder's records are in `~/.hermes/plans/leorna/evidence/86bcm902w/` (`INVENTORY.md` with its 10 "Builder rulings" and the "Fixer 1" section, gate logs, mutation receipts `mutants-*.txt` and `harness/`, screenshots, `demo-*.log`). Treat them as claims to check, not facts: run the gates yourself, try mutations, don't trust summaries.

## Earlier rounds
- Review 1 (full, at cp `e184d9b` and client `db3e6b0`): `~/.hermes/plans/leorna/evidence/86bcm902w/review-1/review.json` and `…/client/review-1/review.json`, with its probes and logs in those folders. Referee: control plane REVIEW AGAIN on R1-1 (P2); client MOVE ON. Its P3s (R1-2, R1-3, R1-4, R1-5) are on the follow-up list (`…/86bcm902w/follow-ups.md`); raise one again only with a new fact or a higher severity, and then set `repeats`.
- **R1-1 (P2)** said `contentPacks` kept the newest-created version per pack name across the tenant's versions and the shared seed, so a later starter-pack seed release replaced the tenant's edited pack on the page. **Justin's decision (2026-10-29): "Company's own pack wins"**: for each pack name, show the tenant's newest version; show the shared seed's newest version only when the tenant has no version of that name. This amends plan D7's pack-row rule (recorded in the working plan `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md`, section "Justin's answer after review 1"); judge the fix against that rule, not D7's old wording.
- Fixer 1's answer: **fixed** in 088af45 (code + tests), 7eb18e4 (docs), de5fbe0 (test helper), with `TestContentUsageCompanyPackWinsOverSharedSeedWithPostgres` and `TestContentUsageChoosesTheCompanyVersionOfEachPack`; dispositions, probes, RED/GREEN logs and mutants in `~/.hermes/plans/leorna/evidence/86bcm902w/fix-1/`. Its rulings F1-a (the page also skips another company's version) and F1-b (page strings unchanged) are in `INVENTORY.md`. Judge whether the fix holds; if it doesn't, raise it again with `repeats: "R1-1"` and a `new_fact`.

## The approved story (for judging scope)
Approved by Justin 2026-10-29 with every ⭐ answer: Q1 a (explicit import command, no automatic upload after Sync), Q2 a (only items the last Sync installed leave the machine; the client checks), Q3 a (an item in several packs shows its full count in each; the page says totals overlap), Q4 a (disposable ClickHouse container from CI's pinned image).
- AC1: Given a spike, then we document per tool whether item usage can be detected from transcripts. Test `TestContentUsageAC1SpikeMatchesSupportTable`.
- AC2: Given supported tools, then item usage counts are shown per pack and item. Test `TestContentUsageAC2CountsPerPackAndItemWithPostgres`.
- AC3: Given unsupported tools, then the UI states that usage is not measurable there. Test `TestContentUsageAC3NotMeasurableIsStated`.
- AC4 (proposed, approved): admin-only page, tenant-isolated, uploads counted for the signed-in user and tenant. Test `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres`.
- AC5 (proposed, approved): an upload carries only item identifiers; anything else → 400, nothing stored. Test `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres`.
- No AC is `(live)`. All five named tests are control-plane tests; the client tests are supporting receipts (plan "Supporting receipts" and "Two-repo verification mechanics").

## Skills (load them first and say so)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `review-fix-cadence` (severity scale), `mutation-testing-discipline` for your mutation checks, plus the specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. The last two end with "Mandatory Validation and Agent Defect Loop": you are its independent problem-finder. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Points to look at in particular (not a limit)
- **Privacy:** nothing but identifiers leaves the engineer's machine. Only items the last successful Sync installed are sent (Q2 a); no transcript text, prompt arguments, paths or personal skill names, in the request or the command's stdout.
- **Detectors** against real transcript shapes: Claude Code (`Skill` tool calls; typed `/name` only in genuine user lines whose `cwd` is the synced project; copies in `api-request-blob` lines and assistant text excluded), Codex (first `.agents/skills/<name>/SKILL.md` read per session), Cursor refused. Check the spike write-up's claims against the tools themselves where you can (installed binaries, public docs), read-only.
- **Ingest:** whole-batch validation before any write; `DisallowUnknownFields`; tenant and user taken from the session, never the body; the 1,000 limit; empty batch; the effect of dropping `minItems` from `events` on old clients and the Codex importer; ruling 5 (400 vs 503 order).
- **Storage and query:** `item_uses_v1` (ReplacingMergeTree, `CREATE TABLE IF NOT EXISTS`), the dedup key and replay, `FINAL`, the tenant parameter, period bounds, newest pack version (ruling 4), counts per pack and per item, and "Not measurable" (never 0) for unmeasured cells.
- **Auth:** admin-only page and query (route guard and store guard), member 403, signed-out redirect, other tenant sees nothing.
- **Client desktop DB:** `OpenReadOnly` with `mode=ro` and no migration; stale selection (ruling 7).
- **Import command:** loopback-only `http`, the `-server` path rule (ruling 8), `-project` default (ruling 3), errors and exit codes.
- **Contract:** additive change, both repos regenerated, the client's full spec copy (it also brings the 901w/901y pack types), `cmp` with the control plane's spec.
- **AC tests:** each fails on base for the right reason and proves its whole AC, not one clause. AC2 and AC4 were written after the code and started green: check their old-code failure yourself.
- **Screenshots:** check each one shows its claimed state (counts per pack and per item; "Not measurable" text, not 0) and shows no domain, URL bar, tenant ID, token or email.
- The builder's 10 rulings and fixer 1's rulings in `INVENTORY.md`: each is a fair reading of the plan (and Justin's R1-1 rule), or a finding.
- **R1-1's fix:** the company-first rule with the real `EnsureSeedBase`, a tenant edit and a newer seed; a tenant with no edit; another tenant's edit; ties; and anything else that picks a pack's version on the page.

## Gates you run yourself
- Control plane: `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm902w_review2_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never another role's DB) and `LEORNA_TEST_CLICKHOUSE_URL` pointing at the running `leorna-test-ch-86bcm902w` container on `127.0.0.1:18123` (form in the plan's T0.5 and the builder's gate log; reuse it, never stop or remove it), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (under `~/.local/leorna-toolchain`), and each AC test by name. Confirm the Postgres and ClickHouse tests really ran (the `leorna` skill's `go test -json` rule).
- Client: `make check` with a real, non-symlinked `TMPDIR`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's golangci-lint first on PATH, and the client tests the plan lists as supporting receipts.

## Your records (the referee's input)
- Write `~/.hermes/plans/leorna/evidence/86bcm902w/review-2/review.json` for the control plane (`"round": 2, "scope": "full", "from": "b65f797ff6cdc56a802dfaf417b0adec96463317", "head": "<cp head you reviewed>"`) and `~/.hermes/plans/leorna/evidence/86bcm902w/client/review-2/review.json` for the client (`"round": 2, "scope": "full", "from": "f105e27814b6efbec67059687963e722933acec2"`, `"head": "<client head you reviewed>"`), each with that repo's findings (an empty list when clean). Ids `R2-<k>` are unique across both files; a finding that is the same defect as a review-1 finding sets `repeats` (and `new_fact` when you have one). Every P0–P2 has a concrete real-use `scenario` of 5+ words.
- Self-check both before handing back:
  - `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics --base b65f797ff6cdc56a802dfaf417b0adec96463317 ~/.hermes/plans/leorna/evidence/86bcm902w`
  - `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics --base f105e27814b6efbec67059687963e722933acec2 ~/.hermes/plans/leorna/evidence/86bcm902w/client`
  Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## Boundaries
- Change nothing in either worktree: no edits, commits, pushes, merges or ClickUp writes. Run mutations only in your own detached copies (`git -C <worktree> worktree add --detach ~/.cache/86bcm902w-review2/mut-<repo> <head>`), and remove each with `git worktree remove --force` on that exact path. **Never run `git worktree prune`** (it drops other stories' entries).
- Write only in `~/.hermes/plans/leorna/evidence/86bcm902w/review-2/` and `…/client/review-2/` (your `review.json`, logs and probes; create them) and your own scratch. Scratch: a fresh `<scratchpad>/86bcm902w-review2/` (`mkdir` without `-p`) for small files; `/tmp` is a small shared RAM tmpfs, so Go `TMPDIR`, binaries, Chrome profiles and the mutation copies go in `~/.cache/86bcm902w-review2/`. Remove only those folders, by their literal absolute paths, and drop your DB at the end.
- Never read or write Justin's real `~/.claude`, `~/.codex` or `~/.cursor` beyond read-only checks of installed tool binaries; any real-tool run uses an isolated HOME, as the plan's T10.3 does.
- Never touch other stories' worktrees, branches, DBs or evidence. No other containers.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem outside this story's diff, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_heads{control_plane, client}, r1_1_fix_holds: true|false, findings[{id, repo, severity: P0|P1|P2|P3, file_line, claim, scenario, repeats, new_fact, evidence, suggested_fix}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{repo, gate, exit, log}], review_json{control_plane, client}, self_check{control_plane, client}, defect_loop_skills[], found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
