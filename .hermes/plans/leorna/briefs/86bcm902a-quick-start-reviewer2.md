
# REVIEWER 2 (review only) — leorna-control-plane, story 86bcm902a "One-click quick start (starter pack → team → sync)"

Role: the second fresh full reviewer of the Full pipeline (`review-fix-cadence`: review 1 → fixer 1 → **review 2 of the corrected candidate** → fixer → verifier → blind auditor). You never saw the build, review 1 or the fix. Report only: change nothing.

## What to review
- Worktree: `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start`, branch `feat/86bcm902a-quick-start`.
- Base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (= GitHub `main`). Reviewed head **`707a4c09f8c9e79388756e4ea83694e1d12d1752`** (14 commits). Confirm the worktree is still at that head and clean before you start, and name the head you reviewed in your report.
- **Review the whole feature** (`git diff 6c1709e...707a4c0`) against the approved plan `~/.hermes/plans/leorna/evidence/86bcm902a/plan-approved.md` (read-only) and the `leorna` skill's rules, **and the fix delta** `git diff 7b45d43..707a4c0` (6 `fix(86bcm902a)` commits) against review 1's findings: is each finding really closed, and did a fix break anything?
- Review 1's report is in `~/.hermes/plans/leorna/evidence/86bcm902a/review1/` (its logs, probes, mutation record and trial merges; the report text itself is summarised below). The builder's and fixer's records are `INVENTORY.md` (with "Builder rulings" and the fixer's rulings), `EVIDENCE.md`, `fix1-tools/`, `mutations-707a4c0.txt`, gate logs and screenshots in `~/.hermes/plans/leorna/evidence/86bcm902a/`. Treat all of them as claims to check: run the gates yourself, try mutations, don't trust summaries. Review 1's probe file no longer compiles against 707a4c0 (`PackMaker.Packs` was removed); write your own probes.

## The approved story (for judging scope)
Approved 2026-10-29 under Justin's away grant, every ⭐: Q1-A (a stand-in list of 86bcm901r's four proposed role packs in `internal/onboarding/starters.go`, each company pack created on pick through 901w's `CreatePack`), Q2-A (`quick_starts` table, migration 000024), Q3-A (pick a team or name a new one), Q4-A (agent-recorded fresh-install demo). No AC is `(live)`.
- AC1: fresh install, finish setup → the quick start offers role-based starter packs. Test `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres`.
- AC2: choose a pack and a team → the assignment is created and engineers' next sync delivers it. Test `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres`.
- AC3: the quick start can be skipped and resumed later. Test `TestQuickStartAC3SkipThenResumeLaterWithPostgres`.
- AC4 (proposed, approved): invalid or not-allowed requests are refused and write nothing; one company never sees or changes another's quick start. Test `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres`.
- AC5 (proposed, approved): fresh install end to end, first sign-in → Backend pack + new team → an engineer's first sync gets the pack's files, recorded on the real binary. Test `TestQuickStartAC5FreshInstallEndToEndWithPostgres`.

## Review 1 (on 7b45d43) in short, and what fixer 1 says it did (on 707a4c0)
Review 1: no critical or major; AC1–AC5 accepted; 3 minor + 6 nits.
- F1 (minor) client disconnect mid-pick left a new team with no pack; retry 409. Fixer: lock, `setupState` and `Apply` now run on `context.WithTimeout(context.WithoutCancel(r.Context()), 30s)`; test `TestQuickStartPickFinishesWhenTheBrowserGoesAwayWithPostgres`; README/comment corrected.
- F2 (minor) pack reuse matched names wider than the `lower(btrim(name))` index (`ſ`), with no notice. Fixer: `CreatePack` first, only on `pack.ErrNameTaken` read the clashing pack by the index's rule (`PackByName` on `QuickStartStore`); the done sentence says when an existing pack was reused; tests `TestQuickStartDoneSaysWhatThePickDidWithPostgres` and store subtest `pack_by_name_matches_like_the_pack_name_index`.
- F3 (minor) no test pinned the role mapping. Fixer: `TestStartersPinTheRoleMapping` with literals.
- F4 lock test didn't prove the lock → AC4 subtest `busy_setup_lock`. F5 → AC4 `member` requires `ADMIN_REQUIRED` on all 3 routes; tenant FK pinned. F6 busy lock → `?notice=busy` redirect. F7 → "X (version N) was made the default pack for Y". F8 → `.starter .meta { display: block }` (no Go test, screenshot only). F9 → evidence captions in INVENTORY.md.
- Track B ruling (main session, away grant): the stand-in's fourth pack is renamed to 901r's "Secure coding (regulated) starter pack".
- Fixer's own rulings, **not yet confirmed — judge each:** (3) migration 000024 was **edited in place** to add `pack_number` and `pack_reused` columns (done_shape now requires `pack_number`) instead of a new 000025, because the branch is unmerged and was applied only to throwaway DBs; (4) `PackByName` sits on `QuickStartStore`, not 901w's `BuilderStore`, and `PackMaker` lost `Packs`; (5) done-sentence wording, the 30 s timeout, the `?notice=` pattern, no Go test for the CSS change.

## Points to look at in particular (not a limit)
- F1's fix: is a detached 30 s context safe (the work can't run forever, the lock is always released, no goroutine leak, nothing assumes the request is still alive, e.g. writing the response)? What does a resubmit after a browser-gone pick show (the fixer notes the done sentence plus a 409 alert together)?
- F2's fix: race between `CreatePack` failing on `ErrNameTaken` and `PackByName` (the clashing pack renamed or deleted in between), tenant scoping of `PackByName`, the `pack_reused`/`pack_number` columns' constraints and audit.
- Ruling 3: is editing an unmerged migration in place acceptable here, and is the down migration still right?
- Everything review 1 already covered still holds after the fix: routes `requireSession(requireAdmin)`, CSRF, 4 KiB form bound, tenant scoping, escaping, audit diffs without names, no API contract change.
- Each AC test fails on base for the right reason and proves its whole AC; screenshots re-captured on 707a4c0 show what INVENTORY.md says, and none shows a real domain, URL bar, tenant ID, token or email (`demo.leorna.invalid` is an accepted reserved placeholder).
- **Integration (short):** the open decision on how 902a meets 86bcm901r is Justin's (the working plan's last section); don't redo review 1's analysis. Only re-check that, at 707a4c0, merging with 901r (`feat/86bcm901r-starter-packs`, read it only through git) and 901y (`feat/86bcm901y-remove-reorder`) still conflicts only in `delivery/stories.json` plus the duplicated migration 000024 (`ls internal/store/postgres/migrations | grep '\.up\.sql$' | cut -d_ -f1 | sort | uniq -d` on a trial tree), and that the renamed pack now matches 901r's name exactly. Use each branch's current head and name it.

## Gates you run yourself
`make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm902a_review2_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg` on 5432, never another role's DB), `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, gitleaks on the story range, and each AC test by name. Confirm the Postgres tests really ran (the `leorna` skill's `go test -json` rule: no skip naming `LEORNA_TEST_DATABASE_URL`). Mutants: re-run a sample of the fixer's (F1a/F1b, F2a–F2j, F6a/F6b, R4, R5*) plus your own; grade a test with no pass/fail event as NOT-RUN, never SURVIVED.

## Skills (load them first with the Skill tool and say so)
`leorna` (reviewer rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `mutation-testing-discipline`, `security-best-practices`, `multi-tenant-auth-management`, `backend-data-migrations` (ends with "Mandatory Validation and Agent Defect Loop": you are its independent problem-finder), and `api-contract-drift-guard` only to confirm there is still no contract change. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Boundaries
- Change nothing in the worktree: no edits, commits, pushes, merges or ClickUp writes. Run mutations and trial merges only in your own detached copies under `~/.cache/86bcm902a-review2/` (`git -C <worktree> worktree add --detach <path> <sha>`), each removed with `git worktree remove --force` on its exact path. **Never run `git worktree prune`.**
- Write only in `~/.hermes/plans/leorna/evidence/86bcm902a/review2/` (create it) and your own scratch: a fresh `<scratchpad>/86bcm902a-review2/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries and Chrome profiles in `~/.cache/86bcm902a-review2/` (`/tmp` is a small shared RAM tmpfs). Remove only those folders, by their literal absolute paths, and drop your DB at the end.
- Never touch other stories' worktrees, branches, DBs or evidence. The client repo `~/Leorna/leorna-client` is read-only.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused). On this desktop `date +%3N` prints 9 digits: use python3 for millisecond timestamps. Keep receipts on disk as you go (the machine crashed once today).

## Rules for every role
- If you find any other bug or problem outside this story's diff, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, review1_closure[{id, closed: yes|no|partly, evidence}], findings[{id, severity: critical|major|minor|nit, introduced: yes|no, claim, evidence, suggested_fix}], rulings_review[{ruling, agree: yes|no, why}], ac_status[{ac, accepted, test, screenshot, evidence}], integration{heads, conflicts, duplicate_migrations, name_match}, gates[{gate, exit, log}], defect_loop_skills[], found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
