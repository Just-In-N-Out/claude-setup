
# REVIEWER 3 (review only) — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: round 3 of the review loop, a **delta** review: only the fix commits since review 2's head and what they touch. You are a fresh agent and never saw the build, the earlier reviews or the fixes. Report only: change no source. The loop's mechanics are in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (read "Rounds and scope", "The reviewer's duties" and "Records"); the severity scale is in `review-fix-cadence`.

## What to review
- Worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item`, branch `feat/86bcm901z-customise-shipped-item`, story base `b65f797ff6cdc56a802dfaf417b0adec96463317`.
- Range (`from`): review 2's head `b53497825caa4802b142c4844e4edab1e814cfef` → head to review `08c09b883b1817adf9ae773b7afcf697397b03f2` (2 commits, 8 files):
  - `1e9e8fe` fix(86bcm901z): clear all typed text when a variant save holds a suspected secret (R2-1)
  - `08c09b8` fix(86bcm901z): clear all typed text when the item editor finds a suspected secret (Justin's added task)
- Confirm the worktree is still at that head and clean before you start, and name the head you reviewed.
- Review `git diff b534978..08c09b8` and the code those commits touch, against the approved plan `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md` (read-only) and the working plan's section "Justin's answers after review 2" in `~/.hermes/plans/leorna/86bcm901z-customise-shipped-item.md`. Anything outside the fix commits and what they touch that you notice is P3.
- Earlier rounds, in `~/.hermes/plans/leorna/evidence/86bcm901z/`: `review-1/review.json`, `fix-1/dispositions.md`, `review-2/review.json`, `review-2/justin.json`, `fix-2/dispositions.md`. Judge whether R2-1's fix holds and covers the class (a suspected secret in any typed field, whichever field the scanner names first). If a finding is the same defect as an earlier one, set `repeats` and, when you have one, `new_fact`. Don't re-raise the open P3s (R1-2, R1-3, R2-2) unless you have a new fact.
- The fixer's records: `fix-2/` (probes, `mutations-08c09b8.txt`), per-head gate logs `gates-08c09b8.txt`, `pg-08c09b8-summary.txt`, `ac*-08c09b8.log`, and the "Fixer 2" section of `INVENTORY.md` with its 5 rulings. Treat them as claims to check, not facts: run the gates yourself, try mutations, don't trust summaries. Use three trees per probe (base `b65f797`, review 2's head `b534978` and head `08c09b8`) to tell a regression this fix caused from base behaviour.

## Justin's decisions after review 2 (2026-10-29)
Justin's words: "R2-1: Keep going (Recommended). Item editor secret echo: Fold into this fix."
- R2-1 fixed (the loop continues).
- Added scope: the existing item editor (`internal/web/item_create.go`, and its edit mode in `pack_versions.go` `editItemSave`, per fixer 2's ruling 2) had the same defect; fixed in its own last commit. Done means no 422 secret refusal from the item editor or the variant pages shows any part of the token, whichever field holds it. No AC changes.
- **Pending with Justin while you review:** fixer 2's ruling 3. A secret refusal now clears every supporting file's text, so an admin who re-enters only the description and body and saves gets empty supporting files (`fix-2/probe-empty-file-08c09b8.log`). Judge it on its merits like any other behaviour of these commits (its real-use scenario and severity); the main session asks Justin which fix he wants at the same time.

## The approved ACs (for judging regressions)
- AC1: `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`
- AC2: `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`
- AC3: `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`
- AC4 (proposed, approved): refused variant requests write nothing, a suspected secret is never echoed back, and one company never sees, changes or packs another's variant. `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`
- No AC is `(live)`.

## Skills (load them first and say so)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `review-fix-cadence` (severity scale), `mutation-testing-discipline` for your mutation checks, `security-best-practices`, `multi-tenant-auth-management`. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Gates you run yourself
- `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm901z_review3_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never the builder's `leorna_86bcm901z_test`), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 bound through `GOLANGCI_LINT=`/`GOVULNCHECK=` (under `~/.local/leorna-toolchain`), and each AC test by name. Confirm the Postgres tests really ran (the `leorna` skill's `go test -json` rule). Gitleaks must be on PATH (`/usr/local/bin/gitleaks`, and `LEORNA_TEST_GITLEAKS_BIN`).

## Your records (the referee's input)
- Write `~/.hermes/plans/leorna/evidence/86bcm901z/review-3/review.json` (`"round": 3, "scope": "delta", "from": "b53497825caa4802b142c4844e4edab1e814cfef", "head": "<head you reviewed>"`) with your findings (an empty list when clean). Ids `R3-<k>`. Every P0–P2 has a concrete real-use `scenario` of 5+ words.
- Self-check before handing back: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item --base b65f797ff6cdc56a802dfaf417b0adec96463317 ~/.hermes/plans/leorna/evidence/86bcm901z`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## Boundaries
- Change nothing in the worktree: no edits, commits, pushes, merges or ClickUp writes. Run mutations only with `go test -overlay` or in your own detached copies (`git -C <worktree> worktree add --detach ~/.cache/86bcm901z-review3/<name> <sha>`), and remove each with `git worktree remove --force` on that exact path. **Never run `git worktree prune`** (it drops other stories' entries).
- Write only in `~/.hermes/plans/leorna/evidence/86bcm901z/review-3/` (your `review.json`, logs and probes; create it) and your own scratch. Fixture tokens must be fake; print byte counts or booleans, never a token, and gitleaks-scan your folder before handing back. Scratch: a fresh `<scratchpad>/86bcm901z-review3/` (`mkdir` without `-p`) for small files; `/tmp` is a small shared RAM tmpfs, so Go `TMPDIR`, binaries, Chrome profiles and the detached copies go in `~/.cache/86bcm901z-review3/`. Remove only those folders, by their literal absolute paths, and drop your DB at the end.
- Never touch other stories' worktrees, branches, DBs or evidence (another session is running 86bcm902w on the same repo). No other containers.
- A Claude Code foreground command moves to the background at its Bash `timeout` (default 120 s) and in any case after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused), with `timeout` set above the poll's bound.

## Rules for every role
- If you find any other bug or problem outside the fix commits, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, findings[{id, severity: P0|P1|P2|P3, file_line, claim, scenario, evidence, suggested_fix, repeats, new_fact}], earlier_findings[{id, status: closed|open, evidence}], rulings_judged[{ruling, fair: true|false, why}], ac_status[{ac, accepted, test, screenshot, evidence}], gates[{gate, exit, log}], review_json, self_check, found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
