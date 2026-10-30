
# REVIEWER 6 (review only) — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)", PR #105

Role: round 6 of the review loop, a **delta** review of the second bring-main-in merge, `03319a0..caf5d96`, and what it touches. You are a fresh agent and never saw the build, the earlier reviews or the fixes. Report only: change no source. The loop's mechanics are in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (read "Rounds and scope", "The reviewer's duties" and "Records"); the severity scale is in `review-fix-cadence`.

## What to review
- Worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item`, branch `feat/86bcm901z-customise-shipped-item`, pushed as **PR #105** (open; Justin merges it, never you). Story base `b65f797ff6cdc56a802dfaf417b0adec96463317`.
- Range (`from`): review 5's clean head `03319a0ee8c85d22c7038244599d98e0701bf24f` → head to review **`caf5d9659953cbab3e6141eddd4193762f96aeff`**: `Merge branch 'main' into feat/86bcm901z-customise-shipped-item` (parents `03319a0` + GitHub main `9135f4e`, which adds PR #104 "many packs overview"). The finisher reports a clean merge (no conflict; the 7 files both sides changed all equal `git merge-file -p`), tree `ddf88fc` equal to its prediction and to GitHub's test merge.
- Confirm the worktree is at that head and clean before you start, and name the head you reviewed.
- **What matters:** that the merge is really clean (no hand edits, no evil merge, the story's patch survived, no duplicated migration version, `delivery/stories.json` by value) and **semantic integration** of this story with #104: #104 changed `internal/web/pack_versions.go`, `internal/web/handler.go`, `cmd/control-plane/main.go`, pack READMEs and added a packs overview page. Check that variants (company copies of library items) behave correctly in #104's code paths (the overview, pack versions, anything that lists or resolves pack items by kind/name or by library id) and that #104's tests still hold with this story's code. Anything outside the merge and what it touches is P3.
- The finisher's records (claims to check, not facts): `~/.hermes/plans/leorna/evidence/86bcm901z/pr/` (`SUMMARY-caf5d96.txt`, `merge-proof-caf5d96.log`, `preflight-caf5d96.log`, gate and AC logs `*-caf5d96.log`, `pg-summary-caf5d96.txt`, `startup-probe-caf5d96.log`, `scripts/*-pr2.*.txt`) and the 2026-10-30 sections of `~/.hermes/plans/leorna/86bcm901z-handover/integration.md`. Run the gates yourself, try mutations, don't trust summaries.
- Earlier rounds, in `~/.hermes/plans/leorna/evidence/86bcm901z/`: `review-1/` … `review-5/`, `fix-1/` … `fix-3/`, `follow-ups.md`. If a finding is the same defect as an earlier one, set `repeats` and, when you have one, `new_fact`. Don't re-raise the open P3s unless you have a new fact.

## The approved ACs (for judging regressions)
- AC1: `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`
- AC2: `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`
- AC3: `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`
- AC4 (proposed, approved): `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`
- No AC is `(live)`. Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md`.

## Skills (load them first and say so)
`leorna` (reviewer rules; step 7.2's merge proofs), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `review-fix-cadence` (severity scale), `mutation-testing-discipline`, `multi-tenant-auth-management`. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Gates you run yourself
- `make check` on `caf5d96` in a detached copy with `LEORNA_TEST_DATABASE_URL` on your own fresh disposable DB `leorna_86bcm901z_review6_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never the builder's `leorna_86bcm901z_test`), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (under `~/.local/leorna-toolchain`), the story-shippable unittest, each AC test by name, and #104's own tests. Confirm the Postgres tests really ran (the `leorna` skill's `go test -json` rule, including its accepted ClickHouse skips). Keep `/usr/local/bin` on any PATH you narrow and set `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`.

## Your records (the referee's input)
- Write `~/.hermes/plans/leorna/evidence/86bcm901z/review-6/review.json` (`"round": 6, "scope": "delta", "from": "03319a0ee8c85d22c7038244599d98e0701bf24f", "head": "<head you reviewed>"`) with your findings (an empty list when clean). Ids `R6-<k>`. Every P0–P2 has a concrete real-use `scenario` of 5+ words.
- Self-check before handing back: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item --base "$(git -C /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item merge-base HEAD origin/main)" ~/.hermes/plans/leorna/evidence/86bcm901z`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## Boundaries
- Change nothing in the worktree: no edits, commits, pushes, merges, PR comments or ClickUp writes. Run mutations only with `go test -overlay` or in your own detached copies (`git -C <worktree> worktree add --detach ~/.cache/86bcm901z-review6/<name> <sha>`), each removed with `git worktree remove --force` on that exact path. **Never run `git worktree prune`.** Read-only `gh` calls are fine; prefer `gh api` over fetching into the shared `FETCH_HEAD`.
- Write only in `~/.hermes/plans/leorna/evidence/86bcm901z/review-6/` (create it) and your own scratch: a fresh `<scratchpad>/86bcm901z-review6/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries, Chrome profiles and detached copies in `~/.cache/86bcm901z-review6/` (`/tmp` is a small shared RAM tmpfs). Never write temp files beside other roles' files. Recreate your disposable DB before each migration mutant. Fixture tokens must be fake; print byte counts or booleans, never a token; gitleaks-scan your folder before handing back. Remove only your own folders, by literal absolute path, and drop your DB at the end.
- Never touch other stories' worktrees, branches, DBs or evidence. No other containers.
- A Claude Code foreground command moves to the background at its Bash `timeout` (default 120 s) and in any case after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused), with `timeout` set above the poll's bound.

## Rules for every role
- If you find any other bug or problem outside the merge, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, findings[{id, severity: P0|P1|P2|P3, file_line, claim, scenario, evidence, suggested_fix, repeats, new_fact}], merge_checks{clean_merge, evil_merge, patch_survived, migrations_dup, stories_json, semantic_integration_104}, ac_status[{ac, accepted, test, screenshot, evidence}], gates[{gate, exit, log}], review_json, self_check, found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
