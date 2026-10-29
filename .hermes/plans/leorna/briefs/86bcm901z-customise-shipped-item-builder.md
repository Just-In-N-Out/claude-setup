
# BUILDER — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: BUILDER (Full pipeline). Build the approved plan test-first and stop at `ready-for-review`. Don't re-plan.

## The approved plan
- Plan: `~/.hermes/plans/leorna/86bcm901z-customise-shipped-item.md`. The read-only approved copy, which `ac-check.sh` reads, is `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md`. Never edit the approved copy.
- Approved by Justin 2026-10-29 with every ⭐ (the plan's `## Justin's answers` section):
  - Q1-A: a variant has its own name (prefilled `<name>-custom`); every pack path works on it unchanged.
  - Q2-A: Merge is a three-way line merge; conflicts are resolved in a text box (`internal/textdiff`).
  - Q3-A: Ignore records that upstream version only; a newer release brings the notice back.
  - Q4-A: the admin edits the description and main text; supporting files follow upstream.
- All four ACs are approved; none is `(live)`:
  - AC1: customise a library item → a tenant-owned variant linked to the upstream item + version. Test `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`.
  - AC2: a newer upstream version → the admin sees an "update available" notice with a diff and can merge or ignore. Test `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`.
  - AC3: a variant is used in packs exactly like a library item. Test `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`.
  - AC4 (proposed, approved): refused variant requests write nothing and stay inside the tenant. Test `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`.

## The ask, and Justin's words
Let an admin make a company-owned copy ("variant") of a shipped skill, agent or prompt. The variant remembers which library item and version it came from. When a newer version ships, the admin console shows "update available" with a diff, and the admin can merge it in or ignore it. In packs a variant is picked, ordered, assigned and synced exactly like a library item. Screenshots must come from the real admin console as the plan's evidence section (E0–E4) says: the item page before and after Customise, the variant page with its lineage, the notice and diff, after merge, after ignore, the conflict resolver, and the variant inside a pack. Look at every capture yourself and check that it really shows what its AC claims before you count it.

> Justin's words (story pick): "Okay, go to ClickUp and you should see there are two user stories in To Do: customize the shipped item and content usage analytics. Let's do the customized shipped item user story."
> Justin's words (approval): "Just go with the recommended and the star one for each."

## Where to work
- Follow the plan's task B0 exactly, its stop conditions included: check and fast-forward the main checkout's `main`, then create the worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item` on branch `feat/86bcm901z-customise-shipped-item` from the base `b65f797ff6cdc56a802dfaf417b0adec96463317` (or the new `origin/main` if B0 allows it). All code changes and commits happen only in that worktree. Another session may fetch or fast-forward the same main checkout at the same moment: on a git lock error, wait a few seconds and retry once; never delete a lock file.
- Search code with `git grep` inside your worktree; a recursive `grep -r` from the main checkout also reads sibling worktrees.
- Never switch the main checkout's branch. Never touch other stories' worktrees under `.claude/worktrees/`, their branches, their test databases or their evidence folders. Your databases are your own `leorna_86bcm901z_*_test` ones in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; it was 127.0.0.1:55432); never use `leorna-pg` on 5432. Never run a repo-wide `git worktree prune`; remove only your own detached copies with `git worktree remove --force <own path>`.
- The client repo `~/Leorna/leorna-client` is read-only. The plan changes the control plane only; the OpenAPI change is description-only plus `make generate` (plan D9, task B11).
- **Siblings in flight:** PR #101 (86bcm902a quick start, open) and the local branch `feat/86bcm901r-starter-packs` (no PR) both add a migration `000025` too and edit `internal/web/library.go`. Keep your migration as the plan says (25, unless B0 step 2 finds main moved) and don't read or wait for their branches. The finisher resolves it at hand-over (whichever merges later renumbers). Stay within this plan's files.
- Commits: `feat(86bcm901z): …`, authored by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or set GIT_AUTHOR/COMMITTER variables, and add no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.

## Skills (load them first with the Skill tool and say so)
1. `leorna`, BUILDER role (steps 2–5 and 4b; skip Step 1's full context load beyond what the plan's B0 needs).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each code change. If a test fails unexpectedly or a gate gets worse, use `systematic-debugging` and don't patch around it.
4. `mutation-testing-discipline` for the guards listed in the plan's "Mutation checks" section (task B14).
5. Specialists the plan's `## Skills` section names: `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard` and `backend-data-migrations` (both end with "Mandatory Validation and Agent Defect Loop": you are their implementation agent; the main session runs the problem-finder and verifier, because you can't start agents).

## Gates and evidence
- Run the plan's gates (task B15): `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable `_test` DB, `bash ./scripts/test-module-add.sh`, the admin-console UI tests, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, and gitleaks. Confirm Postgres tests really ran (the `leorna` skill's `go test -json` rule: no skip naming `LEORNA_TEST_DATABASE_URL`).
- Evidence goes in `~/.hermes/plans/leorna/evidence/86bcm901z/` (not in its `verifier/` or `auditor/` subfolders, and never touching `plan-approved.md`): the before-state captures (E0) before any code change, one screenshot per AC, per-head gate logs `gates-<sha7>.txt`, and an `INVENTORY.md` mapping each AC → test → log → screenshot, plus a "Builder rulings" section.
- Before any capture leaves this machine it must show no server domain, URL bar, tenant ID, token or email (headless Chrome with no browser frame; still look at each image).
- Scratch: keep it in your own fresh `<scratchpad>/86bcm901z-builder/` folder (`mkdir` without `-p`, so it fails if it exists) and remove only that folder by its literal absolute path. `/tmp` is a small shared RAM tmpfs here: Go `TMPDIR`, Chrome profiles, built binaries and the base copy go in `~/.cache/86bcm901z-builder/`.
- Leave the worktree committed and clean (`git status --porcelain` empty), because `ac-check.sh` fails any untracked file.

## Rulings and stopping
- You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in INVENTORY.md's "Builder rulings". If the plan is wrong or missing a decision that can't be settled safely within its files, stop with `status: stopped` and list the options; never redesign.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait for one: poll its log in the foreground in waits of under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem along the way, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{name, status: ready-for-review|stopped, summary, rulings[], worktree, branch, base, last_commit, shots[], gates[{gate, exit, log}], ac_evidence[{ac, test, log, screenshot}], defect_loop_skills[], found_else[], stop_reason, skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
