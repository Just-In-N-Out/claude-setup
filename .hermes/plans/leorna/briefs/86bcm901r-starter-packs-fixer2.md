# FIXER 2 brief: 86bcm901r-starter-packs [leorna]

**Role:** FIXER 2 (finisher role, the last fix pass of the review cadence) for the Leorna story "86bcm901r-starter-packs" (ClickUp **86bcm901r "Role-based starter packs"**). Act on reviewer 2's findings: verify each one, fix the valid ones test-first, push back with evidence on the rest, commit, and stop at **`ready-for-verify`**. A fresh read-only verifier, then a blind AC auditor, check your head next. No hand-over, push, PR, merge or ClickUp post.

**Machine:** Justin's Windows desktop (WSL Ubuntu, `/home/justin`), not the Mac. Mac-only recipes in the skills don't apply; screenshots use the method in the plan's T7 and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (a log rendered in a `<pre>` page and captured with Chrome for Testing).

## Where

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs`, branch `feat/86bcm901r-starter-packs`. Check first that HEAD is `08dac8dbe49e662662b67184ef91cebde7c7e159` (reviewer 2's reviewed head) and `git status --porcelain` is empty; if not, stop and report.
- **Base:** `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`. GitHub `main` was still `6c1709e` at reviewer 2's check. Don't rebase or merge main in this pass.
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` (approved 2026-10-29 under Justin's away grant, every ⭐: Q1–Q6 A). The plan is the contract; don't redesign.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901r/` (`INVENTORY.md` with the builder's and fixer 1's sections; `reviewer1/`, `fixer1/`, `reviewer2/` are read only for you). Put your receipts in a new `fixer2/` subfolder and add your section to `INVENTORY.md`.

## History in one paragraph

Reviewer 1 (on `aa57092`) found F1–F7, all minor or nit. Fixer 1 fixed F1–F5 and F7 in 7 commits (`c545b40`…`08dac8d`) and declined F6 (the `main.go` wiring test, a follow-up). Reviewer 2 (on `08dac8d`) agreed with every disposition and with fixer 1's three rulings (F4's `Older` field, F5's rename-as-change, F3's "restart the control plane to retry" wording), accepted AC1, AC2, AC3 and AC5, killed 13 of its 14 mutants, and found the two items below.

## Reviewer 2's findings (verbatim)

- **R2-1 (minor, introduced): a long role passes every check but stops startup.** The definition check (`validSlug` in `StarterPack.Validate`) and migration 24's `starter_role` CHECK both allow up to 64 characters, but the version id `starter-<role>-<n>` must fit pack versions' 50-character limit (`internal/pack/pack.go:40`, `maxVersionRunes=50`; migration 15's version CHECK). A 42-character role passed `ParseStarterPacks` and `ResolveStarterPack` (what `TestEmbeddedStarterPacksResolveAgainstTheShippedLibrary` checks), then the startup load failed with `pack pack version is invalid: invalid organization request`. That error is not `ErrStarterLoad` and names neither the role nor the step: the raw validation error comes back from `insertStarterVersionTx` (`internal/store/postgres/starter_packs.go:123-125`). A 40-character role works only until its 10th version (51 characters). No shipped role is affected (longest 15). The plan's Risks section says the CI test catches a broken definitions file first; it doesn't catch this. *Evidence:* `reviewer2/probes-08dac8d.txt` (probe P2, `TestReview2ProbeLongStarterRole`: 52-character id; 0 rows left). Code: `internal/library/starter.go:97`, `migrations/000024_starter_packs.up.sql:7`, `internal/pack/starter.go:21`, `internal/pack/pack.go:40`, `internal/store/postgres/starter_packs.go:123-125`. *Suggested fix:* cap the role at 32 characters in `StarterPack.Validate` and in migration 24's CHECK (migration 24 isn't on main yet), and wrap `insertStarterVersionTx`'s Validate error with `starterLoadError` naming the role and number. *Suggested tests:* `ParseStarterPacks` refuses a 33-character role; `TestStarterColumnsAreOnlyOnSharedVersionsWithPostgres` refuses 33 via `pack_versions_starter_role_check` and accepts 32; the shipped-definitions test validates `pack.NewPackVersion{Version: pack.StarterVersionID(role, 1)}` for each role.
- **R2-2 (nit, introduced): no test pins which name the catalog shows.** Mutant V14 (`Name: definition.Name` in `starterSectionFor`, `internal/web/starter_packs.go:62`) passes AC1, AC2 and every other test. F5's design relies on the catalog and Pack Assignments showing the same stored name; with V14 a held rename shows the new name on the catalog and the old one on Pack Assignments. *Evidence:* `reviewer2/mutants-review2.txt` / `.json`, V14 SURVIVED. *Suggested test:* a web test that calls `SetStarterPacks` with a definition whose name differs from the stored version's name and checks the Starter packs article's `<h3>` shows the stored name.
- **AC4 checklist nit (for whoever moves the head):** `ac4-live/CHECKLIST.md` still names `aa57092` as the head. Reviewer 2 confirmed its file lists (Claude Code 26, Codex 21, Cursor 26) and warnings match head's AC2 output. Update it to name your final head, and re-check the lists if your changes alter them.

Found elsewhere, **not** for this pass (pre-existing, nit): `internal/pack/pack.go:191-194, 261-262` produce the doubled wording "pack pack version is invalid: invalid organization request". Leave it; the finisher lists it as a follow-up.

## How to decide and fix

- Follow `receiving-code-review`: reproduce each finding first (re-run reviewer 2's probe P2 and mutant V14 by overlay; their sources are in `reviewer2/`). Fix the valid ones **test-first**: each new or stronger test fails on `08dac8d` (or kills V14 / reproduces P2's failure), then passes. Push back with evidence on anything you judge wrong.
- R2-1's exact cap is your call within the design: 32 is the reviewer's suggestion; any cap must keep `starter-<role>-<n>` within 50 characters for every number the store can reach (or the load must refuse cleanly before that). Record the choice as "My ruling, not yet confirmed". Editing migration 24 in place is fine because it isn't on `main` or any release; say so in your report, and make sure `TestMigrationRoundTrip` and fixer 1's F1 cases (which pin the 64/65 bound today) are updated to the new bound. Your own test databases get fresh schemas per test; if any database of yours already applied the old migration 24, recreate it.
- Keep the fix inside this story's files and the plan's design: no API, OpenAPI, `.github/`, setup-wizard or `internal/pack/pack.go` wording change. Update `internal/pack/README.md` / `internal/library/README.md` if a fix changes what they say (e.g. the role length).
- Prove each guard with its mutant (`mutation-testing-discipline`): a cap-dropped mutant, the unwrapped-error mutant and V14 must each die on the intended test's own assertion line. Re-run any earlier mutant whose test you changed (F1's R4/R5, V11/V12).
- Commits: `feat(86bcm901r): …` / `test(86bcm901r): …` / `docs(86bcm901r): …`, git's own identity (`Justin Issa <justin@leorna.com>`; never override the author), no AI attribution lines, never `CLAUDE.md`.

## Evidence and gates on your final head

- Re-run every AC test by name on your final head and refresh its log and screenshot at the top level of the evidence folder (logs start `HEAD=<sha>`, end `EXIT=<code>`; images must show the new head). Rename the `08dac8d` versions with a `-08dac8d` suffix first, so plain names always mean the newest head. AC1's screenshot: if the page HTML is unchanged, re-capture it from a binary built at your head on a fresh database anyway, so its provenance is the final head. Record a base run for every AC test you changed (separate detached worktree at `6c1709e`, only that AC's test files plus test files of new packages it imports copied in; it must still fail to build or fail).
- Gates on the final head, in a **detached copy** at that SHA: `make check` with CI's tools bound by absolute path (`~/.local/leorna-toolchain`: Go 1.27.3, `GOLANGCI_LINT`, `GOVULNCHECK`; task-local PATH), `bash ./scripts/test-module-add.sh`, and the Postgres skip check from a `go test -json` stream (`leorna` step 4). Save `gates-<sha7>.txt` + `.png`; read each log's exit code before citing it.
- The worktree must end committed and clean (`git status --porcelain` empty).
- **Database:** your own, `leorna_86bcm901r_fix2_test` (plus `leorna_86bcm901r_fix2_base_test` and a demo one for AC1, e.g. `leorna_86bcm901r_fix2_demo_test`), in `leorna-test-pg` only; password never on a command line or in a log; never another role's or a sibling's database, never `leorna-pg`. Drop the base and demo ones when done.
- **Scratch:** everything in `~/.cache/86bcm901r-fix2/`, made fresh with `mkdir` (no `-p`); nothing big on `/tmp` (a small shared RAM disk). At the end remove your detached worktrees with `git worktree remove`, then `rm -r /home/justin/.cache/86bcm901r-fix2` by that literal path. Stop any server you started, by its verified PID.
- Siblings: PR #98 (86bcm901j) is open. Never touch another story's worktree, branch, database or evidence folder.
- Long commands: a foreground Bash command moves to the background after about 180 s. Don't end your turn to wait; poll its log in the foreground in waits under 3 minutes each.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FINISHER role for a fix pass; skip its Step 1 full context load; read `$MEM/leorna-control-plane-workflow.md` for test recipes, `$MEM` = `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory`).
2. `engineering-best-practices`.
3. `receiving-code-review`, `test-driven-development`, `git-commit-rules`.
4. `mutation-testing-discipline`, `backend-data-migrations` (R2-1 edits migration 24; its Agent Defect Loop is run by the main session: you are the fix step), `security-best-practices`, `multi-tenant-auth-management`.

## Rules

- You can't ask Justin anything. If a fix needs his decision (a scope, permission or AC wording change), stop with `status: stopped` and the options.
- If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON: `{name, status: ready-for-verify|stopped, summary, reviewed_head, head, base, commits[], dispositions[{id, verdict: fixed|declined|deferred, why, test, evidence}], rulings[], ac_evidence[{ac, test, head_log, base_log, screenshot}], ac_status[{ac, accepted, test, screenshot, evidence, not_run}], gates[{gate, log, exit}], mutants[{id, result, evidence}], stop_reason, found_else[], skill_lessons[]}`. `status`, `summary`, `head` and `dispositions` are required. Plain words.
