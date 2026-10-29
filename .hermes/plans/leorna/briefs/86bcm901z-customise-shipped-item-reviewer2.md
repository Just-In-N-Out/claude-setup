
# REVIEWER 2 (review only) — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: round 2 of the review loop (Full pipeline: round 2 is a **full** review of the whole story from the base, not only the fix). You are a fresh agent and never saw the build, review 1 or the fix. Report only: change no source. The loop's mechanics are in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (read "The reviewer's duties" and "Records"); the severity scale is in `review-fix-cadence`.

## What to review
- Worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item`
- Branch: `feat/86bcm901z-customise-shipped-item`
- Base (`from`): `b65f797ff6cdc56a802dfaf417b0adec96463317`
- Head to review: `b53497825caa4802b142c4844e4edab1e814cfef` (16 commits: the builder's 14 up to `99382cc`, then fixer 1's `c5bd6be` and `b534978`)
- Confirm the worktree is still at that head before you start, and name the head you reviewed.
- Review `git diff b65f797...b534978` against the approved plan `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md` (read-only; its "Justin's answers" section records the approved choices) and the `leorna` skill's rules.
- Earlier round: `~/.hermes/plans/leorna/evidence/86bcm901z/review-1/review.json` (R1-1 P2, R1-2 P3, R1-3 P3) and the fixer's answer to each in `~/.hermes/plans/leorna/evidence/86bcm901z/fix-1/dispositions.md` (R1-1 fixed in `c5bd6be` + `b534978`; R1-2 and R1-3 left for the follow-up list and the finisher). Judge whether R1-1's fix holds and covers the whole class (any automatic edit Customise makes to a variant's text). If a finding is the same defect as an earlier one, set `repeats` and, when you have one, `new_fact`. Don't re-raise R1-2 or R1-3 unless you have a new fact.
- The builder's and fixer's records are in `~/.hermes/plans/leorna/evidence/86bcm901z/` (`INVENTORY.md` with the builder's 9 rulings and the "Fixer 1" section with its 2 rulings, gate logs `gates-b534978.txt`, `pg-b534978-summary.txt`, `mutations-99382cc.txt`, `fix-1/mutations-b534978.txt`, screenshots). Treat them as claims to check, not facts: run the gates yourself, try mutations, don't trust summaries.

## The approved story (for judging scope)
Approved by Justin 2026-10-29 with every ⭐ answer: Q1 A (a variant has its own name, prefilled `<name>-custom`; every pack path works on it unchanged), Q2 A (Merge is a three-way line merge; lines only the company changed and lines only upstream changed are both kept; conflicts resolved in a text box), Q3 A (Ignore records that upstream version only; a newer release brings the notice back), Q4 A (the admin edits description and main text; supporting files follow upstream).
- AC1: Given a library item, when I customise it, then a tenant-owned variant is created linked to the upstream item + version. Test `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`.
- AC2: Given a newer upstream version, then the admin sees an 'update available' notice with a diff and can merge or ignore. Test `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`.
- AC3: Given a variant, then it is used in packs exactly like a library item. Test `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`.
- AC4 (proposed, approved): refused variant requests write nothing and stay inside the tenant. Test `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`.
- No AC is `(live)`. Control plane only; no client change.

## Skills (load them first and say so)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `review-fix-cadence` (severity scale), `mutation-testing-discipline` for your mutation checks, plus the specialists: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`. The last two end with "Mandatory Validation and Agent Defect Loop": you are its independent problem-finder. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Areas the plan names (not a limit)
- **Tenant isolation and auth:** the tenant key in every variant query and in the pack builder's id lookup (`loadCatalogItems`), the admin re-check on every write, CSRF, member 403, signed-out redirect, and another company's variant id answered exactly like an unknown id.
- **Lineage and versions:** the upstream link and version stored on create; "update available" (the newest same-kind, same-name row, compared number by number, not the base row and not the ignored version); expected-version and expected-upstream checks against stale writes; `ON DELETE RESTRICT` on the upstream row.
- **`internal/textdiff`, merge, ignore and the resolver:** correctness on real edits (agents, skills and prompts), conflict markers, the bounds, what is saved and what is refused, and that a resolution still holding conflict markers is refused.
- **The secret gate and the bounded preview:** every save runs the item editor's gate; a suspected secret is never echoed back; tenant text is rendered only through the bounded renderers.
- **Packs and sync (AC3):** a variant goes through the same create, add, move, remove, assign and sync paths as a library item, and pack versions copy its content.
- **Migration 25:** up and down, the round-trip lists, existing rows unchanged.
- **Contract:** description-only OpenAPI change, regenerated code matches, no client regeneration needed.
- **AC tests:** every AC test fails on base only because `internal/variant` doesn't exist there. That proves the tests are new, not that each one checks its whole AC: check that each test exercises every clause of its AC (mutate the code a clause rests on with `go test -overlay` and see the AC test fail on the right line).
- **Screenshots:** each one shows its claimed state and no domain, URL bar, tenant ID, token or email.
- The builder's 9 rulings and fixer 1's 2 rulings in `INVENTORY.md`: each is a fair reading of the plan, or a finding.

## Gates you run yourself
- `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm901z_review2_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never the builder's `leorna_86bcm901z_test`), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (under `~/.local/leorna-toolchain`), and each AC test by name. Confirm the Postgres tests really ran (the `leorna` skill's `go test -json` rule). Gitleaks must be on PATH (`/usr/local/bin/gitleaks`, and `LEORNA_TEST_GITLEAKS_BIN`).

## Your records (the referee's input)
- Write `~/.hermes/plans/leorna/evidence/86bcm901z/review-2/review.json` (`"round": 2, "scope": "full", "from": "b65f797ff6cdc56a802dfaf417b0adec96463317", "head": "<head you reviewed>"`) with your findings (an empty list when clean). Ids `R2-<k>`. Every P0–P2 has a concrete real-use `scenario` of 5+ words.
- Self-check before handing back: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item --base b65f797ff6cdc56a802dfaf417b0adec96463317 ~/.hermes/plans/leorna/evidence/86bcm901z`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## Boundaries
- Change nothing in the worktree: no edits, commits, pushes, merges or ClickUp writes. Run mutations only with `go test -overlay` or in your own detached copy (`git -C <worktree> worktree add --detach ~/.cache/86bcm901z-review2/mut <head>`), and remove it with `git worktree remove --force` on that exact path. **Never run `git worktree prune`** (it drops other stories' entries).
- Write only in `~/.hermes/plans/leorna/evidence/86bcm901z/review-2/` (your `review.json`, logs and probes; create it) and your own scratch. Scratch: a fresh `<scratchpad>/86bcm901z-review2/` (`mkdir` without `-p`) for small files; `/tmp` is a small shared RAM tmpfs, so Go `TMPDIR`, binaries, Chrome profiles and the mutation copy go in `~/.cache/86bcm901z-review2/`. Remove only those folders, by their literal absolute paths, and drop your DB at the end.
- Never touch other stories' worktrees, branches, DBs or evidence (another session is running 86bcm902w on the same repo). No other containers.
- A Claude Code foreground command moves to the background at its Bash `timeout` (default 120 s) and in any case after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused), with `timeout` set above the poll's bound.

## Rules for every role
- If you find any other bug or problem outside this story's diff, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, findings[{id, severity: P0|P1|P2|P3, file_line, claim, scenario, evidence, suggested_fix, repeats, new_fact}], earlier_findings[{id, status: closed|open, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{gate, exit, log}], review_json, self_check, defect_loop_skills[], found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
