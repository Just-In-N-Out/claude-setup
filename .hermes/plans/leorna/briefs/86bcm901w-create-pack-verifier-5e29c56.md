
# VERIFIER (read only) on the new head 5e29c56 — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: a fresh, read-only VERIFIER. You never saw the build. The story was verified and accepted on `8a50486`, and PR #96 is open with that head; one local commit since then records the PR number. Justin asked for the verifier, the blind auditor and the AC check to run again on the new head before it is pushed. **Change no source:** no edits, commits, pushes or posts; write only inside your own folder.

## Inputs
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`, local head **`5e29c56efdf91dd2643ba326dc9bf62f0264cb46`** (clean, not pushed). `origin/feat/86bcm901w-create-pack` and PR #96 are at `8a5048694d40ee975c7b3c276ca1b8af521cae5d`. **Base** = `git merge-base HEAD origin/main` = **`1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`** (= GitHub `main` at dispatch).
- **The delta** `8a50486..5e29c56` is one commit, `chore(86bcm901w): record PR #96 in stories.json`, changing one line of `delivery/stories.json` (`[]` → `[96]`). Confirm that yourself (`git diff --stat`, the file's JSON by value: every other entry unchanged).
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md` (read-only).
- **Acceptance criteria** (approved; **none is live**, so prove all four, none `not_run`):
  - AC1: Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items — `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`
  - AC2: Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set — `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`
  - AC3: Given a save, then a change-audit record is written (actor, action, diff) — `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`
  - AC4 (proposed, approved): refused saves are refused with a clear status and write nothing — `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`
- **Earlier record** (read if useful; prove things yourself): the previous verifier's run on `8a50486` (`~/.hermes/plans/leorna/evidence/86bcm901w/verifier/`, clean, 39/39 mutants), review 1 and 2 with both fix passes (`review1/`, `fixer1/`, `review2/`, `fixer2/`), the PR agent's gates on `8a50486` (`pr/`), and CI run 40787263343 on `8a50486` (all three jobs green).

## What to do
1. **Delta check:** prove `8a50486..5e29c56` changes only that one `stories.json` line, every earlier entry is unchanged by value, the commit's author and committer are `Justin Issa <justin@leorna.com>` with no AI attribution lines, and no `.github/` or `CLAUDE.md` path appears in `1ee7157...5e29c56`.
2. **Gates, yourself, in a detached copy at `5e29c56`** (removed at the end): `make check`, `bash ./scripts/test-module-add.sh`, the `go test -json` Postgres stream read per test (accepted skips only: the two ClickHouse subtests of `TestTeamsAPIWithPostgres`, and with no `-run` also `TestEvidenceThirdPartyContentPage` "LEORNA_EVIDENCE_DIR is not set" and `TestProvisionManagedPostgresLive` "SCW_LIVE=1 not set"; any skip naming `LEORNA_TEST_DATABASE_URL` fails), the story gate `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, gitleaks on `1ee7157..5e29c56`. Run `python3 scripts/check-story-shippable.py 86bcm901w` and report what it says (BLOCKED is expected while #96, #95 and #97 are open); it's information, not a gate.
3. **AC proof** — follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → VERIFIER exactly, in **`~/.hermes/plans/leorna/evidence/86bcm901w/verifier-5e29c56/`** (exists, empty):
   - each AC's named test alone on head with the recipe → `ac<n>-5e29c56.log`;
   - the same test on base `1ee7157` in a separate detached copy with head's version of the AC test file copied in → `ac<n>-base-1ee7157.log` (must fail or fail to build on the new code, not a setup failure);
   - one screenshot per AC, taken by you in this run: real admin-console captures for AC1–AC3 from a server you build at `5e29c56` on your own demo database; AC4 may be a rendered page of your own head log. Inspect every image (tall ones in bands; Read scales them to ~2000 px high); nothing private on screen.
   - write `verifier-5e29c56/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` with `"head": "5e29c56efdf91dd2643ba326dc9bf62f0264cb46"`; every receipt it cites must be inside `verifier-5e29c56/`. Self-check while staying blind: `cp` (not `ln`) your report and receipts to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base 1ee7157f5dfeb24ddf2df7e3bb5363833385d50d --plan ~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md <evidence>/verifier-5e29c56/ac.json <scratch copy>/ac.json`, fix any slip, delete the copy.
4. `verdict: clean` only if the delta is as stated, every gate passes and all four ACs are accepted on `5e29c56`. A full mutation re-run isn't needed for a records-only delta; say whether any production or test file changed.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `~/.cache/86bcm901w-verifier-2/` on the real disk (`mkdir` without `-p`) for `TMPDIR`, detached copies, caches and Chrome's `--user-data-dir`; remove only that folder at the end. Not `/tmp`.
- **Toolchain:** Go 1.27.3, golangci-lint 2.14.0, govulncheck v1.7.0 in `~/.local/leorna-toolchain` (read-only; bind the linters through `GOLANGCI_LINT=`/`GOVULNCHECK=`); gitleaks 8.30.1 at `/usr/local/bin`; make and gcc from apt. PATH per command only.
- **Postgres:** `leorna-test-pg` on `127.0.0.1:55432` (user `leorna`, password `ci-only-password`). Create and later drop your own `leorna_86bcm901w_verifier2_test`, `leorna_86bcm901w_verifier2_base_test` and a demo database. Never touch any other database or the `leorna-pg` container on 5432. Plain `docker` works. If Docker stops answering (a WSL restart), stop and report.
- **Chrome for Testing:** the Chrome paragraph of `ac-verification.md`. With chromedp, after a submit that redirects, poll `chromedp.Evaluate` (ignoring errors while the page navigates) until content only the new page has is there and `document.readyState == 'complete'`.
- Sibling stories (86bcm901a #97, 86bcm901b #95, 86bcm901j, Yan's #94): never touch their worktrees, branches, databases or evidence. Never run `make fmt-fix`/`make workspace` from the main checkout. Never write in `auditor-5e29c56/` or edit other roles' files. Never push, fetch-and-reset, or touch PR #96.

## Skills
Load, in this order, and say so in your first steps: `leorna` (VERIFIER role; skip its Step 1 load), `engineering-best-practices`, `api-contract-drift-guard`, `backend-data-migrations`. Any skill step that says "spawn a subagent" is the main session's job.

## Rules
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", head: "5e29c56…", base: "1ee7157…", delta_check, findings[{id, severity, claim, evidence}], gates[{name, exit, log}], story_shippable, ac_status[{ac, accepted, test, screenshot, evidence}], ac_json: "<path>", self_check: "<ac-check.sh last line>", found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
