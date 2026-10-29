# AC AUDITOR 2 (blind, read only) — leorna-control-plane, story 86bcm902a "One-click quick start (starter pack → team → sync)"

Role: the blind AC AUDITOR. Prove, on your own, that every acceptance criterion of the approved plan holds on the head commit and fails on the base commit, and write `auditor/ac.json`. You work only from the approved plan and the code. **Change no source:** no edits, commits, pushes or posts in the worktree; write only inside your own folder.

## Your inputs (and only these)
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm902a/plan-approved.md` (read-only). Its "Acceptance criteria", "AC tests", "Per-AC proof" and "Evidence capture on this desktop (E1–E4)" sections tell you what each AC means and how it can be shown.
- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902a-quick-start`, branch `feat/86bcm902a-quick-start`.
- **Head:** `bb79ec683832542bca271307b7a3fb31085664d0` (the head of open PR #101). **Base:** `b65f797ff6cdc56a802dfaf417b0adec96463317` (`git merge-base HEAD origin/main`, GitHub `main`). The branch merged `main` in, so judge only this story's own change: `git diff b65f797...HEAD`.
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm902a/auditor/` (the main session created it empty). Every receipt you cite must be inside it.

**Stay blind.** Under `~/.hermes/plans/leorna/evidence/86bcm902a/`, open nothing but `plan-approved.md` and your own `auditor/` folder: not `verifier/`, `archive-9a9bdec/`, `finisher2/`, `review1/`, `review2/`, `review-*/`, `history-*`, `builder-tools/`, `fix1-tools/`, `fix2-tools/`, `EVIDENCE.md`, `INVENTORY.md`, the PNGs or logs in the folder's root, or any other file there. Don't read PR #101's body or comments either. Don't read other `86bcm902a` briefs or the working plan `~/.hermes/plans/leorna/86bcm902a-quick-start.md` (only the approved copy). Make your own logs, screenshots and capture code. The code at head may differ in detail from the plan's design sketches (fixes landed after review); judge each AC by its words and its named test.

## The acceptance criteria (from the approved plan; none is live, so prove all five)
- AC1: Given a fresh install, when I finish setup, then the quick start offers role-based starter packs — `TestQuickStartAC1FinishingSetupOffersRoleStarterPacksWithPostgres`
- AC2: Given I choose a pack and a team, then the assignment is created and engineers' next sync delivers it — `TestQuickStartAC2ChosenPackAssignedAndDeliveredOnNextSyncWithPostgres`
- AC3: Given the quick start, then it can be skipped and resumed later — `TestQuickStartAC3SkipThenResumeLaterWithPostgres`
- AC4 (proposed, approved): a quick-start request that is invalid or not allowed is refused with a clear status and writes nothing, and one company's quick start never shows or changes another's — `TestQuickStartAC4RefusedRequestsWriteNothingWithPostgres`
- AC5 (proposed, approved): a fresh install (empty database, auto setup) goes from first sign-in, picking the Backend starter pack and naming a new team, to an engineer's first sync with the pack's files — `TestQuickStartAC5FreshInstallEndToEndWithPostgres`
- Read each AC's full wording in the plan; the lines above are short forms.

## What to do
Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC work; you are the auditor of step 3) exactly:
1. Check the worktree is clean at the head (`git status --porcelain --untracked-files=all` empty).
2. For each AC: read its named test and judge whether it really checks the AC's words (every clause); where a clause looks unexercised, confirm with a read-only `go test -overlay` mutant that the AC test fails without the code that clause depends on, reading the line it failed on (assign each `file_test.go:NN:` line to the `=== RUN` block it follows, as `ac-verification.md` says; a test with no pass/fail event is NOT-RUN).
3. Run each AC's test alone on head with the recipe (`HEAD=` first line, verbose output, `EXIT=` last line) → `auditor/ac<n>-<head7>.log`.
4. Run the same test on base in a separate detached copy at `b65f797` with head's version of that AC's test file(s) copied in (only the Go test files the recipe allows) → `auditor/ac<n>-base-b65f797.log`. It must fail there (its own fail line or a build failure of the new code), not a setup failure or a missing file.
5. One screenshot per AC, taken by you, in `auditor/`. AC1, AC2 and AC3 are visible in the admin console: capture the real console from a server you build at head on your own demo database (the plan's evidence-capture section describes how): AC1 the quick start offering the role starter packs after setup; AC2 the result of choosing a pack and a team (the done page or the team's assignment, naming the pack); AC3 the skipped state and the way to resume it. AC4 and AC5 may be rendered pages of your own head logs (label them as local renderings). Inspect every image before citing it; nothing private on screen (no real server domain, URL bar, tenant ID, token or email; a `.invalid` placeholder name is fine).
6. Write `auditor/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with `"head"` = the full head SHA above. Self-check it while staying blind: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base b65f797ff6cdc56a802dfaf417b0adec96463317 --plan ~/.hermes/plans/leorna/evidence/86bcm902a/plan-approved.md <evidence>/auditor/ac.json <scratch copy>/ac.json`, fix any format slip, delete the copy.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `<scratchpad>/86bcm902a-auditor2/` (`mkdir` without `-p`) for small files, and a fresh `~/.cache/86bcm902a-auditor2/` on the real disk for `TMPDIR`, detached copies, binaries and Chrome's `--user-data-dir`. Not `/tmp` for big files (a small shared tmpfs; a WSL restart wipes it). Remove only those folders, by their literal absolute paths, at the end.
- **Toolchain:** Go 1.27.3 in `~/.local/leorna-toolchain/go` (read-only); make and gcc from apt. PATH per command only.
- **Postgres:** `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; it was `127.0.0.1:55432`; user `leorna`, password `ci-only-password`; `LEORNA_TEST_DATABASE_URL=postgres://leorna:ci-only-password@127.0.0.1:<port>/<db>?sslmode=disable`). Create and later drop your own `leorna_86bcm902a_auditor2_test`, `leorna_86bcm902a_auditor2_base_test` and a demo database for the screenshots (names ending in `_test`). Never touch any other database or the `leorna-pg` container on 5432. If Docker stops answering (a WSL restart), stop and report; don't restart Docker Desktop yourself.
- **Detached copies:** `git -C <worktree> worktree add --detach ~/.cache/86bcm902a-auditor2/<name> <sha>`, removed with `git worktree remove --force <that exact path>`. **Never run `git worktree prune`** (it drops other stories' entries).
- **Chrome for Testing:** the Chrome paragraph of `ac-verification.md` (path, `LD_LIBRARY_PATH`, flags, `env -u DISPLAY -u WAYLAND_DISPLAY`, judging output by bytes and PNG magic, killing only your own Chrome PIDs). After a submit that redirects, mark the old page (`window.__beforeSubmit = true`) and wait for a loaded page without the mark before the screenshot: waiting for an element both pages share can capture the old page.
- **Starting a server:** `setsid --fork sh -c 'echo $$ >pidfile; exec "$BIN"' >log 2>&1 </dev/null` (a backgrounded `cd && setsid …&` holds the Bash tool and `$!` names the wrong process). On this desktop `date +%3N` prints 9 digits: use python3 for millisecond timestamps.
- Sibling stories run in other sessions in this repo (86bcm901r and others): never touch their worktrees, branches, databases or evidence. Never run `make fmt-fix`/`make workspace` from the main checkout. Never write outside `auditor/` and your scratch.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Skills
Load, in this order, with the Skill tool, and say so in your first steps: `leorna` (AC auditor; skip its Step 1 load), `engineering-best-practices`. Any skill step that says "spawn a subagent" is the main session's job.

## Rules
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", head: "<full head sha>", base: "b65f797…", ac_status[{ac, accepted, test, screenshot, evidence}], ac_json: "<path>", self_check: "<ac-check.sh last line>", findings[{id, severity, claim, evidence}], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
