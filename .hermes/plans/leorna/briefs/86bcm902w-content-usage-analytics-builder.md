
# BUILDER — leorna-control-plane + leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: BUILDER (Full pipeline). Build the approved plan test-first in both repos and stop at `ready-for-review`. Don't re-plan.

## The approved plan
- Plan: `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md`. The read-only approved copy, which `ac-check.sh` reads, is `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md`. Never edit the approved copy.
- Approved by Justin 2026-10-29: **go** with every ⭐ answer:
  - Q1 a: item uses reach the server through an explicit import command (`cmd/import-content-usage`), like today's Codex import. No automatic upload after Sync, no desktop button (that is Yan's 86bcnuxce).
  - Q2 a: only items the last Sync installed may leave the engineer's machine; the client checks this before sending. Personal skill or command names never leave.
  - Q3 a: an item in several packs shows its full count in every pack holding it; the page says pack totals can overlap.
  - Q4 a: query tests run against a disposable ClickHouse container from CI's pinned image (plan T0.5).
- ACs, all approved (AC1–AC3 are the card's; AC4 and AC5 were proposed and approved with the plan):
  - AC1: spike write-up documents per tool whether item usage is detectable. Test `TestContentUsageAC1SpikeMatchesSupportTable`.
  - AC2: supported tools → item usage counts shown per pack and item. Test `TestContentUsageAC2CountsPerPackAndItemWithPostgres`.
  - AC3: unsupported tools → the UI states usage is not measurable there. Test `TestContentUsageAC3NotMeasurableIsStated`.
  - AC4 (proposed, approved): admin-only and tenant-isolated; uploads count for the signed-in user and tenant. Test `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres`.
  - AC5 (proposed, approved): an upload carries only item identifiers; anything else → 400, nothing stored. Test `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres`.
- No AC is `(live)`. All five named tests are control-plane tests; the client tests are supporting receipts (plan "Supporting receipts" and "Two-repo verification mechanics").

## The ask, and Justin's words
Admins see which skills, agents and prompts engineers actually use: a per-tool spike write-up, then counts per pack and per item on an admin-only "Content usage" page, with "Not measurable" (never "0") wherever a tool or kind can't be measured. The client detects uses in an explicitly chosen transcript, keeps only items the last Sync installed, and sends identifiers only.

> Justin's words (story pick): "Okay, go to ClickUp, you're gonna send it to do. There are two user stories this will have. Let's do the content usage analytics for this one."
> Justin's words (approval): "Yeah, just go with the recommended star options."

## Where to work
- Follow the plan's task T0 exactly. Both main checkouts must still be at the plan's bases (control plane `b65f797ff6cdc56a802dfaf417b0adec96463317`, client `f105e27814b6efbec67059687963e722933acec2`). If GitHub `main` moved in either repo, stop and report rather than re-basing yourself.
- Worktrees, both on branch `feat/86bcm902w-content-usage-analytics`:
  - `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics`
  - `~/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics`
  All code changes and commits happen only there. Never switch a main checkout's branch.
- Never touch other stories' worktrees under `.claude/worktrees/`, their branches, test databases or evidence folders. Siblings in flight: 86bcm901z (customise a shipped item, another session), 86bcm902a (PR #101), 86bcm901r (local branch). Stay within this plan's files; the finisher resolves shared files (`delivery/stories.json`, `internal/web/handler.go`, root `README.md`) at hand-over.
- Data stores (approved scope, nothing wider):
  - Postgres: only your own `_test` databases in `leorna-test-pg` (plan T0.4: `leorna_86bcm902w_builder_test`, `leorna_86bcm902w_base_test`). Read the port with `docker port leorna-test-pg 5432`; never use `leorna-pg`.
  - ClickHouse (Q4 a): pull exactly the pinned image in T0.5 and run the one container `leorna-test-ch-86bcm902w` on `127.0.0.1:18123`. Leave it running at `ready-for-review` (reviewers and the verifier reuse it; the finisher removes it at hand-over). No other containers, images or volumes.
- Real tool homes: never read or write Justin's real `~/.claude`, `~/.codex` or `~/.cursor`. The env-gated real Claude Code test (T10.3) runs only with an isolated HOME and `CLAUDE_CONFIG_DIR` in `t.TempDir()` against the fake model API, as the plan says. Transcripts in evidence are synthetic (T12), never real.
- Commits: `feat(86bcm902w): …` in each repo, authored by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or set GIT_AUTHOR/COMMITTER variables, and add no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.

## Skills (load them first and say so)
1. `leorna`, BUILDER role (steps 2–5 and 4b; skip Step 1's full context load beyond what the plan's T0 needs).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each code change. If a test fails unexpectedly or a gate gets worse, use `systematic-debugging` and don't patch around it.
4. `mutation-testing-discipline` for the admin, tenant and ingest guards (plan T10.4, mutants M1–M10 and C1–C5).
5. Specialists the plan's `## Skills` section names: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations` (the last two end with "Mandatory Validation and Agent Defect Loop": you are its implementation agent; the main session runs the problem-finder and verifier, because you can't start agents).

## Gates and evidence
- Run the plan's gates (T12) on the final head of each repo:
  - control plane: `make check` with `LEORNA_TEST_DATABASE_URL` (your own `_test` DB) and `LEORNA_TEST_CLICKHOUSE_URL` (your container), `bash ./scripts/test-module-add.sh`, the admin-console UI tests, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (checked absolute paths under `~/.local/leorna-toolchain`), and gitleaks. Confirm Postgres and ClickHouse tests really ran (the `leorna` skill's `go test -json` rule: no skip naming `LEORNA_TEST_DATABASE_URL` or `LEORNA_TEST_CLICKHOUSE_URL`);
  - client: `make check` with a real, non-symlinked `TMPDIR`, `node --test scripts/*-ui.test.cjs`, `make lint audit` with CI's golangci-lint first on PATH; the client's contract check and contract-kind test after copying the spec (the client copy lagged by the 901w/901y pack operations: expect their generated types too).
  - Base baselines in detached worktrees with their own `_base_test` DB (T0.6), first, because the client gates have no recorded run on WSL yet.
- Evidence goes in `~/.hermes/plans/leorna/evidence/86bcm902w/` (not in its `verifier/`, `auditor/`, `review-*` or `client/` subfolders): the before-state capture (`ac2-empty-before.png`) before any visible change, one screenshot per AC as the plan names them (`ac1-spike-table.png`, `ac2-per-pack-after.png`, `ac2-per-item-after.png`, `ac3-not-measurable.png`, `ac4-guards-terminal.png`, `ac5-ingest-terminal.png`), per-head gate logs `gates-<repo>-<sha7>.txt`, `mutants-<sha7>.txt`, and an `INVENTORY.md` mapping each AC → test → log → screenshot with the head of each file, plus a "Builder rulings" section. Look at every capture yourself and check it shows the claimed state (counts visible per pack and per item; "Not measurable" text, not "0", in the unsupported cells).
- Before any capture leaves this machine it must show no server domain, URL bar, tenant ID, token or email.
- Scratch: keep it in your own fresh `<scratchpad>/86bcm902w-builder/` folder (`mkdir` without `-p`, so it fails if it exists) and remove only that folder by its literal absolute path. `/tmp` is a small shared RAM tmpfs here: Go `TMPDIR`, Chrome profiles, built binaries and the base copies go in `~/.cache/86bcm902w-builder/`.
- Leave both worktrees committed and clean (`git status --porcelain` empty), because `ac-check.sh` fails any untracked file.

## Rulings and stopping
- You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in INVENTORY.md's "Builder rulings". If the plan is wrong or missing a decision that can't be settled safely within its files, stop with `status: stopped` and list the options; never redesign.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming both worktrees and last commits.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait for one: poll its log in the foreground in waits of under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-review|stopped, summary, rulings[], worktrees{control_plane, client}, branch, bases{control_plane, client}, last_commits{control_plane, client}, shots[], gates[{repo, gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], defect_loop_skills[], found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
