
# BUILDER — leorna-control-plane, story 86bcm902a "One-click quick start (starter pack → team → sync)"

Role: BUILDER (Full pipeline). Build the approved plan test-first and stop at `ready-for-review`. Don't re-plan.

## The approved plan
- Plan: `~/.hermes/plans/leorna/86bcm902a-quick-start.md`. The read-only approved copy, which `ac-check.sh` reads, is `~/.hermes/plans/leorna/evidence/86bcm902a/plan-approved.md`. Never edit the approved copy.
- Approved 2026-10-29 under Justin's away grant ("just keep everything going and follow what the recommended agent says"): **go** with every ⭐ (the plan's `## Justin's answers` section):
  - Q1-A: a stand-in list of 86bcm901r's four proposed role packs in `internal/onboarding/starters.go`, each company pack created on pick through 901w's `CreatePack`. The plan's Flag line stands: 901r keeps its own ACs; build none of them here.
  - Q2-A: one `quick_starts` row per company (migration 24).
  - Q3-A: pick an existing team or type a new team's name.
  - Q4-A: you record AC5 locally as a numbered screenshot series plus logs from the real binary on an empty database.
- All five ACs are approved; none is `(live)`:
  - AC1: fresh install, finish setup → the quick start offers role-based starter packs. Test `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres`.
  - AC2: choose a pack and a team → the assignment is created and engineers' next sync delivers it. Test `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres`.
  - AC3: the quick start can be skipped and resumed later. Test `TestQuickStartAC3SkipThenResumeLaterWithPostgres`.
  - AC4 (proposed, approved): invalid or not-allowed requests are refused and write nothing; no cross-company view or change. Test `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres`.
  - AC5 (proposed, approved): fresh install end to end, from first sign-in to an engineer's first sync with the Backend pack's files, recorded by you. Test `TestQuickStartAC5FreshInstallEndToEndWithPostgres`.

## The ask, and Justin's words
After a new admin finishes setup on a fresh install, offer role-based starter packs; the admin picks one and a team (or names a new one), and the quick start makes that pack the team's default, so the team's engineers get it on their next sync. The admin can skip and resume later. Screenshots must come from the real admin console: the starter-pack offer, the team pick, the created assignment, the skip and the resume, and AC5's fresh-install series, as the plan's evidence section (E1–E4) says. Look at every capture yourself and check that it really shows what its AC claims before you count it.

> Justin's words: "One-click quick startI want you to go into ClickUp and pick out this user story.I won't be on my laptop, so just keep everything going and follow what the recommended agent says."

## Where to work
- Follow the plan's task B0 exactly (its stop conditions included): check and fast-forward the main checkout's `main`, then create the worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start` on branch `feat/86bcm902a-quick-start` from the base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (or the new `origin/main` if B0 allows it). All code changes and commits happen only in that worktree. Another session's builder (86bcm901y) may fetch or fast-forward the same main checkout at the same moment: on a git lock error, wait a few seconds and retry once; never delete a lock file.
- Search code with `git grep` inside your worktree; a recursive `grep -r` from the main checkout also reads sibling worktrees.
- Never switch the main checkout's branch. Never touch other stories' worktrees under `.claude/worktrees/`, their branches, their test databases or their evidence folders. Your databases are your own `_test` ones in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; it was 127.0.0.1:55432); never use `leorna-pg` on 5432.
- The client repo `~/Leorna/leorna-client` is read-only. The plan changes the control plane only; no OpenAPI change.
- **Sibling in flight:** 86bcm901y "Remove and reorder items in a pack version" is being built right now by another session on `feat/86bcm901y-remove-reorder`, from the same base. It probably adds its own migration `000024` too. Keep your migration as the plan says (24); don't renumber now and don't read or wait for its branch. The finisher resolves it at hand-over (whichever merges second renumbers). Stay within this plan's files.
- Commits: `feat(86bcm902a): …`, authored by the repo's configured identity (`Justin Issa <justin@leorna.com>` via `~/.gitconfig`'s includeIf). Never pass `-c user.*`, `--author` or set GIT_AUTHOR/COMMITTER variables, and add no AI attribution or Co-Authored-By lines. Never push, open a PR, post to ClickUp or merge.

## Skills (load them first with the Skill tool and say so)
1. `leorna`, BUILDER role (steps 2–5 and 4b; skip Step 1's full context load beyond what the plan's B0 needs).
2. `engineering-best-practices`.
3. `test-driven-development`: a failing test before each code change. If a test fails unexpectedly or a gate gets worse, use `systematic-debugging` and don't patch around it.
4. `mutation-testing-discipline` for the permission, CSRF and tenant guards (the plan's task B5, its 12 mutants).
5. Specialists the plan's `## Skills` section names: `security-best-practices`, `multi-tenant-auth-management`, `backend-data-migrations` (ends with "Mandatory Validation and Agent Defect Loop": you are its implementation agent; the main session runs the problem-finder and verifier, because you can't start agents).

## Gates and evidence
- Run the plan's gates (its `## Gates` section): `make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable `_test` DB, `bash ./scripts/test-module-add.sh`, the admin-console UI tests, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, and gitleaks. Confirm Postgres tests really ran (the `leorna` skill's `go test -json` rule: no skip naming `LEORNA_TEST_DATABASE_URL`).
- Evidence goes in `~/.hermes/plans/leorna/evidence/86bcm902a/` (not in its `verifier/` or `auditor/` subfolders, and never touching `plan-approved.md`): the before-state capture before any code change, one screenshot per AC, AC5's numbered fresh-install series, per-head gate logs `gates-<sha7>.txt`, and an `INVENTORY.md` mapping each AC → test → log → screenshot, plus a "Builder rulings" section.
- Before any capture leaves this machine it must show no server domain, URL bar, tenant ID, token or email (headless Chrome with no browser frame; still look at each image).
- Scratch: keep it in your own fresh `<scratchpad>/86bcm902a-builder/` folder (`mkdir` without `-p`, so it fails if it exists) and remove only that folder by its literal absolute path. `/tmp` is a small shared RAM tmpfs here: Go `TMPDIR`, Chrome profiles, built binaries and the base copy go in `~/.cache/86bcm902a-builder/`.
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

## RESUME after a machine crash (2026-10-29, main session)
The first builder ran only 30 seconds (10:04:58–10:05:27 UTC: skill loads, plan read, B0 start) before the WSL machine crashed and restarted (back about 12:20 UTC). Files written in those last seconds came back **0 bytes**. You start fresh from this brief; the main checkout, `main` (`6c1709e`), the plan and the approved copy are intact (`git fsck --connectivity-only` passes; only dangling trees).

Broken leftovers you must clear first, as task B0's first step, and only after checking them:
1. `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start/`: every file in it is 0 bytes, `.git` included, so git says "invalid gitfile format". Check with `find <that dir> -type f ! -size 0` (must print nothing). If anything non-empty is there, stop and report instead of deleting.
2. `~/Leorna/leorna-control-plane/.git/worktrees/86bcm902a-quick-start/` (its `HEAD`, `gitdir`, `commondir`, `ORIG_HEAD`, `logs/HEAD` are 0 bytes).
3. The branch ref `.git/refs/heads/feat/86bcm902a-quick-start` and its reflog `.git/logs/refs/heads/feat/86bcm902a-quick-start` (0 bytes; git prints "ignoring broken ref").
4. `~/.cache/86bcm902a-builder/` (holds only an empty `tmp/` from the first run) and the empty `~/.hermes/plans/leorna/evidence/86bcm902a/tools.txt`. Never touch `plan-approved.md`.
5. `.git/FETCH_HEAD` is also 0 bytes; the next fetch rewrites it, leave it.

Remove each by its literal absolute path (`rm -r /home/justin/...`; Claude Code refuses `rm -rf $VAR`), try `git update-ref -d refs/heads/feat/86bcm902a-quick-start` before removing the ref file by hand, then run `git -C ~/Leorna/leorna-control-plane worktree prune -v`, and confirm: `git worktree list` doesn't name 86bcm902a, `git branch --list 'feat/86bcm902a*'` prints nothing and no warning, `git fsck --connectivity-only` exits 0. Then carry on with B0 as written. Touch nothing else under `.git/`, and leave 86bcm901y's worktree and `~/.cache/86bcm901y-builder/` alone (another session's story).

The session scratchpad on `/tmp` was emptied by the restart: make your scratch folder fresh.
