
# AC AUDITOR (blind, read only) — leorna-control-plane + leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: the blind AC AUDITOR. Prove, on your own, that every acceptance criterion of the approved plan holds on the head commit and fails on the base commit, and write `auditor/ac.json`. You work only from the approved plan and the code. **Change no source:** no edits, commits, pushes or posts in either worktree; write only inside your own folder.

## Your inputs (and only these)
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md` (read-only). Its "Acceptance criteria" and "Per-AC detail" sections (with the "Common environment" block), "Supporting receipts", "Two-repo verification mechanics" and task T12 ("Gates and evidence capture") tell you what each AC means and how it can be shown.
- **Justin's decision after go (not an AC change):** for each pack name, the content usage page shows the **company's own newest version**, and the shared seed's newest version only when the company has no version of that name ("Company's own pack wins", 2026-10-29). This replaces the plan's D7 wording on which version a pack row shows; the ACs and test names are unchanged.
- **Control-plane worktree** (the AC repo): `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics`, branch `feat/86bcm902w-content-usage-analytics`. **Head:** `de5fbe0755a41e0528815ef3b72509aeadb20c3c`. **Base:** `b65f797ff6cdc56a802dfaf417b0adec96463317` (`git merge-base HEAD origin/main`; GitHub `main` has since moved on with another story's merge, which is not part of this check: use this base).
- **Client worktree** (supporting receipts only): `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics`, same branch. **Head:** `db3e6b0f76652088c11fafa8c3c54509f62116f7`. **Base:** `f105e27814b6efbec67059687963e722933acec2`.
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm902w/auditor/` (exists, empty). Every receipt you cite must be inside it.

**Stay blind.** Under `~/.hermes/plans/leorna/evidence/86bcm902w/`, open nothing but `plan-approved.md` and your own `auditor/` folder: not `verifier/`, `review-*`, `client/`, `fix-1/`, `harness/`, `INVENTORY.md`, `follow-ups.md`, the PNGs or logs in the folder's root, or any other file there. Don't read any `86bcm902w` brief, the working plan `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md` or other roles' scratch. Make your own logs, screenshots and probes.

## The acceptance criteria (from the approved plan; none is live, so prove all five; all named tests are control-plane tests)
- AC1: Given a spike, then we document per tool whether item usage can be detected from transcripts — `TestContentUsageAC1SpikeMatchesSupportTable`
- AC2: Given supported tools, then item usage counts are shown per pack and item — `TestContentUsageAC2CountsPerPackAndItemWithPostgres`
- AC3: Given unsupported tools, then the UI states that usage is not measurable there — `TestContentUsageAC3NotMeasurableIsStated`
- AC4 (proposed, approved): only the tenant's admins can open the page, another tenant sees none of the uses, and uploads count for the signed-in user and tenant — `TestContentUsageAC4AdminOnlyAndTenantIsolatedWithPostgres`
- AC5 (proposed, approved): an upload carries only item identifiers; anything else gets 400 and nothing is stored — `TestContentUsageAC5IngestAcceptsOnlyItemIdentifiersWithPostgres`
- Read each AC's full wording in the plan; the lines above are short forms.

## What to do
Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC work; you are the auditor of step 3) exactly:
1. Check both worktrees are clean at their heads (`git status --porcelain --untracked-files=all` empty), before and after.
2. For each AC: read its named test and judge whether it really checks the AC's words (every clause); where a clause looks unexercised, confirm with a read-only `go test -overlay` mutant that the AC test fails without the code that clause depends on, reading the line it failed on.
3. Run each AC's test alone on head with the recipe (`HEAD=` first line, verbose output, `EXIT=` last line) → `auditor/ac<n>-de5fbe0.log`.
4. Run the same test on base in a separate detached copy at `b65f797` with head's version of that AC's test file(s) copied in (plus the test files of packages the story creates that the test imports) → `auditor/ac<n>-base-b65f797.log`. It must fail there (its own fail line or a build failure of the new code), not a setup failure or a missing file.
5. One screenshot per AC, taken by you, in `auditor/`. AC2 and AC3 are visible on the admin page: capture the real page from a control-plane server you build at head on your own demo database, after real uploads of item uses (counts per pack and per item; "Not measurable" text in the unmeasured cells, never 0). AC1: a local rendering of the spike write-up's per-tool table. AC4 and AC5: rendered pages of your own test logs, ending at `EXIT=`. Look at each image yourself: no domain, URL bar, tenant ID, token or email.
6. Supporting receipts on the client head `db3e6b0`: run the plan's supporting client tests and both `cmp` checks it names (golden upload body, OpenAPI spec), and name the client head in your AC2 and AC5 `evidence` lines.
7. Write `auditor/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with `"head": "de5fbe0755a41e0528815ef3b72509aeadb20c3c"`. Self-check it while staying blind: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <control-plane worktree> --base b65f797ff6cdc56a802dfaf417b0adec96463317 --plan ~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md <evidence>/auditor/ac.json <scratch copy>/ac.json` (no `--reviews`), then delete the copy.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `<scratchpad>/86bcm902w-auditor/` (`mkdir` without `-p`) for small files, and a fresh `~/.cache/86bcm902w-auditor/` on the real disk for `TMPDIR`, detached copies, binaries and Chrome's `--user-data-dir`. Not `/tmp` for big files (a small shared tmpfs). Remove only those folders, by their literal absolute paths, at the end.
- **Toolchain:** Go, golangci-lint and govulncheck in `~/.local/leorna-toolchain` (read-only); make and gcc from apt. PATH per command only, and **keep `/usr/local/bin` on any PATH you narrow**: gitleaks lives only there, and without it item-editor Postgres tests fail with 503 "secret scanner unavailable" (an environment failure, not the story).
- **Postgres:** `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; the plan's "Common environment" block shows how the URL is built, with the password read from the container). Create and later drop your own `leorna_86bcm902w_auditor_test`, `leorna_86bcm902w_auditor_base_test` and a demo database for the screenshots (names ending in `_test`). Never touch any other database or the `leorna-pg` container.
- **ClickHouse:** the running `leorna-test-ch-86bcm902w` container at `127.0.0.1:18123` (connection form in the plan's T0.5 and "Common environment"). Use it; never stop or remove it, and start no other containers.
- **Detached copies:** `git -C <worktree> worktree add --detach ~/.cache/86bcm902w-auditor/<name> <sha>`, removed with `git worktree remove --force <that exact path>`. **Never run `git worktree prune`** (it drops other stories' entries).
- **Chrome for Testing:** the Chrome paragraph of `ac-verification.md` (path, `LD_LIBRARY_PATH`, flags, `env -u DISPLAY -u WAYLAND_DISPLAY`, judging output by bytes and PNG magic, killing only your own Chrome PIDs). The server's CSP blocks inline scripts, so capture a tall section with chromedp's element screenshot.
- **Starting a server:** `setsid --fork sh -c 'echo $$ >pidfile; exec "$BIN"' >log 2>&1 </dev/null`. On this desktop `date +%3N` prints 9 digits: use python3 for millisecond timestamps.
- **Real tool homes:** never read or write Justin's real `~/.claude`, `~/.codex` or `~/.cursor` beyond read-only checks of installed binaries; any real-tool run uses an isolated HOME.
- Sibling stories run in other sessions in these repos: never touch their worktrees, branches, databases or evidence. Never write outside `auditor/` and your scratch.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Skills
Load, in this order, with the Skill tool, and say so in your first steps: `leorna` (AC auditor; skip its Step 1 load), `engineering-best-practices`. Any skill step that says "spawn a subagent" is the main session's job.

## Rules
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", head: "de5fbe0…", base: "b65f797…", client_head: "db3e6b0…", ac_status[{ac, accepted, test, screenshot, evidence}], ac_json: "<path>", self_check: "<ac-check.sh last line>", findings[{id, severity, claim, evidence}], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
