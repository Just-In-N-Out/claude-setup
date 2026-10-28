
# AC AUDITOR (blind, read only) on head 5e29c56 — leorna-control-plane, story 86bcm901w "Create a pack by picking library items"

Role: the blind AC AUDITOR. Prove, on your own, that every acceptance criterion of the approved plan holds on the head commit and fails on the base commit, and write `auditor-5e29c56/ac.json`. You work only from the approved plan and the code. **Change no source:** no edits, commits, pushes or posts; write only inside your own folder.

## Your inputs (and only these)
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md` (read-only). Its "Acceptance criteria", "AC tests", "Per-AC proof" and "Evidence capture on this desktop (E1–E3)" sections tell you what each AC means and how it can be shown. (Its E1 demo-server recipe names port 5432; that port belongs to an unrelated container. Use `leorna-test-pg` on 55432, below.)
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901w-create-pack`, branch `feat/86bcm901w-create-pack`.
- **Head:** `5e29c56efdf91dd2643ba326dc9bf62f0264cb46` (local; not pushed). **Base:** `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (`git merge-base HEAD origin/main`).
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901w/auditor-5e29c56/` (exists, empty). Every receipt you cite must be inside it.

**Stay blind.** Under `~/.hermes/plans/leorna/evidence/86bcm901w/`, open nothing but `plan-approved.md` and your own `auditor-5e29c56/` folder: not `verifier/`, `verifier-5e29c56/`, `auditor/`, `review1/`, `review2/`, `fixer1/`, `fixer2/`, `pr/`, `EVIDENCE.md`, `INVENTORY.md` or any other file there, and no file anywhere that a memory note says came from another role. Don't read other `86bcm901w` briefs or the PR's text. Make your own logs, screenshots and capture code.

## The acceptance criteria (from the approved plan; none is live, so prove all four)
- AC1: Given selected library items, when I name and save, then a new pack (version 1) is created with exactly those items — `TestPackBuilderAC1NewPackVersion1HasExactlyTheTickedItemsWithPostgres`
- AC2: Given an existing pack, when I add or remove library items, then a new immutable version is saved with ParentVersion set — `TestPackBuilderAC2AddRemoveSavesImmutableVersionWithParentWithPostgres`
- AC3: Given a save, then a change-audit record is written (actor, action, diff) — `TestPackBuilderAC3EverySaveWritesAuditRecordWithPostgres`
- AC4 (proposed, approved by Justin): refused saves are refused with a clear status and write nothing — `TestPackBuilderAC4RefusedSavesWriteNothingWithPostgres`

## What to do
Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC work; you are the auditor of step 3) exactly:
1. Check the worktree is clean at the head.
2. For each AC: read its named test and judge whether it really checks the AC's words (every clause); where a clause looks unexercised, confirm with a read-only `go test -overlay` mutant that the AC test fails without the code that clause depends on.
3. Run each AC's test alone on head with the recipe (`HEAD=` first line, verbose output, `EXIT=` last line) → `auditor-5e29c56/ac<n>-5e29c56.log`.
4. Run the same test on base in a separate detached copy at `1ee7157` with head's version of that AC's test file(s) copied in (only the Go test files the recipe allows) → `auditor-5e29c56/ac<n>-base-1ee7157.log`. It must fail there (its own fail line or a build failure of the new code), not a setup failure or a missing file.
5. One screenshot per AC, taken by you, in `auditor-5e29c56/`: AC1–AC3 have a visible result in the admin console (the saved pack at version 1 with exactly the ticked items, version 2 from version 1, the pack's audit history with actor, action and diff); capture the real pages from a server you build at head on your own demo database. AC4 may be a rendered page of your own head log. Inspect every image before citing it (tall ones in bands; Read scales them to ~2000 px high); nothing private on screen (no server domain, token or email).
6. Write `auditor-5e29c56/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with `"head": "5e29c56efdf91dd2643ba326dc9bf62f0264cb46"`. Self-check it while staying blind: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base 1ee7157f5dfeb24ddf2df7e3bb5363833385d50d --plan ~/.hermes/plans/leorna/evidence/86bcm901w/plan-approved.md <evidence>/auditor-5e29c56/ac.json <scratch copy>/ac.json`, fix any format slip, delete the copy.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `~/.cache/86bcm901w-auditor-2/` on the real disk (`mkdir` without `-p`) for `TMPDIR`, detached copies, caches and Chrome's `--user-data-dir`; remove only that folder at the end. Not `/tmp`.
- **Toolchain:** Go 1.27.3 in `~/.local/leorna-toolchain/go` (read-only); make and gcc from apt. PATH per command only.
- **Postgres:** `leorna-test-pg` on `127.0.0.1:55432` (user `leorna`, password `ci-only-password`; `LEORNA_TEST_DATABASE_URL=postgres://leorna:ci-only-password@127.0.0.1:55432/<db>?sslmode=disable`). Create and later drop your own `leorna_86bcm901w_auditor2_test`, `leorna_86bcm901w_auditor2_base_test` and a demo database ending in `_test`. Never touch any other database or the `leorna-pg` container on 5432. Plain `docker …` works. If Docker stops answering (a WSL restart), stop and report.
- **Chrome for Testing:** the Chrome paragraph of `ac-verification.md`. With chromedp, after a submit that redirects, poll with `chromedp.Evaluate` (ignoring errors while the page navigates) until content only the new page has is there and `document.readyState == 'complete'`. The console's CSP blocks in-page `fetch()`; check what a save stored through your demo DB with `docker exec … psql`.
- Sibling stories and PRs (86bcm901a #97, 86bcm901b #95, 86bcm901j, Yan's #94): never touch their worktrees, branches, databases or evidence. Never run `make fmt-fix`/`make workspace` from the main checkout. Never push or touch PR #96. Never write outside `auditor-5e29c56/` and your scratch.

## Skills
Load, in this order, and say so in your first steps: `leorna` (AC auditor; skip its Step 1 load), `engineering-best-practices`. Any skill step that says "spawn a subagent" is the main session's job.

## Rules
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer. If you must wait on a long command, wait in the foreground (a bounded poll), don't end your turn to wait.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", head: "5e29c56…", base: "1ee7157…", ac_status[{ac, accepted, test, screenshot, evidence}], ac_json: "<path>", self_check: "<ac-check.sh last line>", findings[{id, severity, claim, evidence}], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
