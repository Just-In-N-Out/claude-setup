
# AC AUDITOR (blind, read only) — leorna-control-plane, story 86bcm901z "Customise a shipped item (company variant)"

Role: the blind AC AUDITOR. Prove, on your own, that every acceptance criterion of the approved plan holds on the head commit and fails on the base commit, and write `auditor/ac.json`. You work only from the approved plan and the code. **Change no source:** no edits, commits, pushes or posts in the worktree; write only inside your own folder.

## Your inputs (and only these)
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md` (read-only). Its "Acceptance criteria", "Design", "Tests" (per-AC detail), "Tasks" (the B0 common-environment block) and "Evidence capture on this desktop (E0–E4)" sections tell you what each AC means and how it can be shown. Justin's later decisions changed no AC and no AC test name.
- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901z-customise-shipped-item`, branch `feat/86bcm901z-customise-shipped-item`. **Head:** `4904333a8fe0def527ad32603e115f2499c6cef8`. **Base:** `b65f797ff6cdc56a802dfaf417b0adec96463317` (`git merge-base HEAD origin/main`; GitHub `main` has since moved on with other stories' merges, which are not part of this check: use this base).
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901z/auditor/` (exists, empty). Every receipt you cite must be inside it.

**Stay blind.** Under `~/.hermes/plans/leorna/evidence/86bcm901z/`, open nothing but `plan-approved.md` and your own `auditor/` folder: not `verifier/`, `review-*`, `fix-*`, `INVENTORY.md`, `follow-ups.md`, the PNGs, logs or text files in the folder's root, or any other file there. Don't read any `86bcm901z` brief, the working plan `~/.hermes/plans/leorna/86bcm901z-customise-shipped-item.md` or other roles' scratch. Make your own logs, screenshots and probes.

## The acceptance criteria (from the approved plan; none is live, so prove all four; all named tests are control-plane tests in `internal/web`)
- AC1: Given a library item, when I customise it, then a tenant-owned variant is created linked to the upstream item + version — `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`
- AC2: Given a newer upstream version, then the admin sees an 'update available' notice with a diff and can merge or ignore — `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`
- AC3: Given a variant, then it is used in packs exactly like a library item — `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`
- AC4 (proposed, approved): refused variant requests write nothing and stay inside the tenant — `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`
- Read each AC's full wording in the plan; the lines above are short forms (AC4's full line lists every refusal case, the no-echo rule for a suspected secret and tenant isolation).

## What to do
Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC work; you are the auditor of step 3) exactly:
1. Check the worktree is clean at its head (`git status --porcelain --untracked-files=all` empty), before and after.
2. For each AC: read its named test and judge whether it really checks the AC's words (every clause); where a clause looks unexercised, confirm with a read-only `go test -overlay` mutant that the AC test fails without the code that clause depends on, reading the line it failed on.
3. Run each AC's test alone on head with the recipe (`HEAD=` first line, verbose output, `EXIT=` last line) → `auditor/ac<n>-4904333.log`.
4. Run the same test on base in a separate detached copy at `b65f797` with head's version of that AC's test file(s) copied in (plus the test files of packages the story creates that the test imports) → `auditor/ac<n>-base-b65f797.log`. It must fail there (its own fail line or a build failure of the new code), not a setup failure or a missing file.
5. One screenshot per AC, taken by you, in `auditor/`. AC1–AC3 are visible in the admin console: capture the real pages from a control-plane server you build at head on your own demo database (the customised variant with its upstream item and version; the "update available" notice with its diff and the Merge/Ignore controls, which needs a newer upstream version: the plan's E-section describes a "release B" binary built from a detached copy with one item's version bumped, never committed; a variant inside a pack). AC4: a real refusal page or a rendered page of your own test log ending at `EXIT=`. Look at each image yourself: no domain, URL bar, tenant ID, token or email.
6. Write `auditor/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with `"head": "4904333a8fe0def527ad32603e115f2499c6cef8"`. Self-check it while staying blind: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base b65f797ff6cdc56a802dfaf417b0adec96463317 --plan ~/.hermes/plans/leorna/evidence/86bcm901z/plan-approved.md <evidence>/auditor/ac.json <scratch copy>/ac.json` (no `--reviews`), then delete the copy.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `<scratchpad>/86bcm901z-auditor/` (`mkdir` without `-p`) for small files, and a fresh `~/.cache/86bcm901z-auditor/` on the real disk for `TMPDIR`, detached copies, binaries and Chrome's `--user-data-dir`. Not `/tmp` for big files (a small shared tmpfs). Never write temp files beside anything outside your own folders. Remove only those folders, by their literal absolute paths, at the end.
- **Toolchain:** Go, golangci-lint and govulncheck in `~/.local/leorna-toolchain` (read-only); make and gcc from apt. PATH per command only, and **keep `/usr/local/bin` on any PATH you narrow**: gitleaks 8.30.1 lives only there (also set `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`), and without it the variant and item-editor Postgres tests fail with 503 "secret scanner unavailable" (an environment failure, not the story).
- **Postgres:** `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; the plan's B0 block shows how the URL is built, with the password read from the container). Create and later drop your own `leorna_86bcm901z_auditor_test`, `leorna_86bcm901z_auditor_base_test` and a demo database for the screenshots (names ending in `_test`). Never touch any other database or the `leorna-pg` container.
- **Fixture tokens** must be fake; print byte counts or booleans, never a token, and gitleaks-scan your folder before handing back.
- **Detached copies:** `git -C <worktree> worktree add --detach ~/.cache/86bcm901z-auditor/<name> <sha>`, removed with `git worktree remove --force <that exact path>`. **Never run `git worktree prune`** (it drops other stories' entries).
- **Chrome for Testing:** the Chrome paragraph of `ac-verification.md` (path, `LD_LIBRARY_PATH`, flags, `env -u DISPLAY -u WAYLAND_DISPLAY`, judging output by bytes and PNG magic, killing only your own Chrome PIDs); chromedp recipes are in the `leorna` skill's 4b Builder line. The server's CSP blocks inline scripts, so capture a tall section with chromedp's element screenshot.
- **Starting a server:** `setsid --fork sh -c 'echo $$ >pidfile; exec "$BIN"' >log 2>&1 </dev/null`. On this desktop `date +%3N` prints 9 digits: use python3 for millisecond timestamps.
- Sibling stories run in other sessions in this repo: never touch their worktrees, branches, databases or evidence. Never write outside `auditor/` and your scratch.
- A Claude Code foreground command moves to the background at its Bash `timeout` (default 120 s) and in any case after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused), with `timeout` set above the poll's bound.

## Skills
Load, in this order, with the Skill tool, and say so in your first steps: `leorna` (AC auditor; skip its Step 1 load), `engineering-best-practices`. Any skill step that says "spawn a subagent" is the main session's job.

## Rules
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", head: "4904333…", base: "b65f797…", ac_status[{ac, accepted, test, screenshot, evidence}], ac_json: "<path>", self_check: "<ac-check.sh last line>", findings[{id, severity, claim, evidence}], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
