
# AC AUDITOR on the PR head (blind, read only) — leorna-control-plane, story 86bcm901y "Remove and reorder items in a pack version"

Role: the blind AC AUDITOR. Prove, on your own, that every acceptance criterion of the approved plan holds on the head commit of PR #99 and fails on the base commit, and write `auditor-pr/ac.json`. You work only from the approved plan and the code. **Change no source:** no edits, commits, pushes, PR edits or posts in the worktree; write only inside your own folder.

## Your inputs (and only these)
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901y/plan-approved.md` (read-only). Its "Acceptance criteria", "AC tests", per-AC old-code checks and evidence-capture sections tell you what each AC means and how it can be shown.
- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901y-remove-reorder`, branch `feat/86bcm901y-remove-reorder`.
- **Head:** `008c6124af3f58bbae9bd580b86c7c50cf8ffc29`. **Base:** `dd006b79f9908976e853c57489032bd5d9d471df` (`git merge-base HEAD origin/main`; GitHub `main`).
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901y/auditor-pr/` (create it). Every receipt you cite must be inside it.

**Stay blind.** Under `~/.hermes/plans/leorna/evidence/86bcm901y/`, open nothing but `plan-approved.md` and your own `auditor-pr/` folder: not `verifier/`, `verifier-pr/`, `auditor/`, `review1/`, `review2/`, `fixer1/`, `fixer2/`, `fixer3/`, `EVIDENCE.md`, `INVENTORY.md`, the PNGs or logs in the folder's root, or any other file there. Don't read any `86bcm901y` brief other than this one, the working plan `~/.hermes/plans/leorna/86bcm901y-remove-reorder.md`, the hand-over drafts or the PR's text. Make your own logs, screenshots and capture code.

## The acceptance criteria (from the approved plan; none is live, so prove all four)
- AC1: Given a pack version, when I remove an item, then a new version is saved without it and audited — `TestPackItemsAC1RemoveSavesNewVersionWithoutTheItemAndAuditsWithPostgres`
- AC2: Given a removal, when engineers next sync, then the item's files are removed from their tools (or flagged) consistently with the lockfile — `TestPackItemsAC2RemovedItemLeavesTheNextSyncLockfileWithPostgres`
- AC3 (Justin): Given a pack version, when I reorder its items (Move up / Move down in the console, or `order` in the API), then a new version is saved in the new order, audited, and syncing the same files as its parent — `TestPackItemsAC3ReorderSavesNewVersionInTheNewOrderAndAuditsWithPostgres`
- AC4 (proposed, approved): a remove or reorder that is invalid or not allowed is refused and writes nothing — `TestPackItemsAC4RefusedRemovesAndReordersWriteNothingWithPostgres`
- Read each AC's full wording in the plan; the lines above are short forms.

Justin asked that the screenshots **show items being reordered and removed** in the real admin console. So your AC1 and AC3 screenshots are real console captures: the pack's item list before and after a Remove (the item visibly gone, the version number up by one), and before and after a Move up or Move down (the order visibly changed). Cite the "after" capture in `ac.json` and keep the "before" next to it in `auditor-pr/`.

## What to do
Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC work; you are the auditor of step 3) exactly:
1. Check the worktree is clean at the head.
2. For each AC: read its named test and judge whether it really checks the AC's words (every clause); where a clause looks unexercised, confirm with a read-only `go test -overlay` mutant that the AC test fails without the code that clause depends on.
3. Run each AC's test alone on head with the recipe (`HEAD=` first line, verbose output, `EXIT=` last line) → `auditor-pr/ac<n>-008c612.log`.
4. Run the same test on base in a separate detached copy at `dd006b7` with head's version of that AC's test file(s) copied in (only the Go test files the recipe allows) → `auditor-pr/ac<n>-base-dd006b7.log`. It must fail there (its own fail line or a build failure of the new code), not a setup failure or a missing file.
5. One screenshot per AC, taken by you, in `auditor-pr/`: AC1 and AC3 as described above, from a server you build at head on your own demo database (the plan's evidence-capture section describes how); AC2 and AC4 may be rendered pages of your own head logs. Inspect every image before citing it; nothing private on screen (no server domain, URL bar, tenant ID, token or email).
6. Write `auditor-pr/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with `"head": "008c6124af3f58bbae9bd580b86c7c50cf8ffc29"`. Self-check it while staying blind: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base dd006b79f9908976e853c57489032bd5d9d471df --plan ~/.hermes/plans/leorna/evidence/86bcm901y/plan-approved.md <evidence>/auditor-pr/ac.json <scratch copy>/ac.json`, fix any format slip, delete the copy.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `<scratchpad>/86bcm901y-auditor-pr/` (`mkdir` without `-p`) for small files, and a fresh `~/.cache/86bcm901y-auditor-pr/` on the real disk for `TMPDIR`, detached copies, binaries and Chrome's `--user-data-dir`. Not `/tmp` for big files (a small shared tmpfs; a WSL restart wipes it). Remove only those folders, by their literal absolute paths, at the end.
- **Toolchain:** Go 1.27.3 in `~/.local/leorna-toolchain/go` (read-only); make and gcc from apt. PATH per command only.
- **Postgres:** `leorna-test-pg` on `127.0.0.1:55432` (read the port with `docker port leorna-test-pg 5432`; user `leorna`, password `ci-only-password`; `LEORNA_TEST_DATABASE_URL=postgres://leorna:ci-only-password@127.0.0.1:55432/<db>?sslmode=disable`). Create and later drop your own `leorna_86bcm901y_apr_test`, `leorna_86bcm901y_apr_base_test` and a demo database for the screenshots (names ending in `_test`). Never touch any other database or the `leorna-pg` container on 5432. If Docker stops answering (a WSL restart), stop and report; don't restart Docker Desktop yourself.
- **Detached copies:** `git -C <worktree> worktree add --detach ~/.cache/86bcm901y-auditor-pr/<name> <sha>`, removed with `git worktree remove --force <that exact path>`. **Never run `git worktree prune`** (it drops other stories' entries).
- **Chrome for Testing:** the Chrome paragraph of `ac-verification.md` (path, `LD_LIBRARY_PATH`, flags, `env -u DISPLAY -u WAYLAND_DISPLAY`, judging output by bytes and PNG magic, killing only your own Chrome PIDs). With chromedp, after a submit that redirects, poll with `chromedp.Evaluate` (ignoring errors while the page navigates) until content only the new page has is there and `document.readyState == 'complete'`; `WaitVisible` on an element both pages share can match the old page.
- Sibling stories run in other sessions in this repo (86bcm902a, 86bcm901r and others): never touch their worktrees, branches, databases or evidence. Never run `make fmt-fix`/`make workspace` from the main checkout. Never write outside `auditor-pr/` and your scratch.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Skills
Load, in this order, and say so in your first steps: `leorna` (AC auditor; skip its Step 1 load), `engineering-best-practices`. Any skill step that says "spawn a subagent" is the main session's job.

## Rules
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", head: "008c612…", base: "dd006b7…", ac_status[{ac, accepted, test, screenshot, evidence}], ac_json: "<path>", self_check: "<ac-check.sh last line>", findings[{id, severity, claim, evidence}], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
