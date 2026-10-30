
# AC AUDITOR on the PR heads (blind, read only) — leorna-control-plane + leorna-client, story 86bcm902w "Content usage analytics (which items get used)"

Role: the blind AC AUDITOR. Prove, on your own, that every acceptance criterion of the approved plan holds on the head commit and fails on the base commit, and write `auditor-pr/ac.json`. You work only from the approved plan and the code. **Change no source:** no edits, commits, pushes or posts in either worktree; write only inside your own folder.

## Your inputs (and only these)
- **Approved plan:** `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md` (read-only). Its "Acceptance criteria" and "Per-AC detail" sections (with the "Common environment" block), "Supporting receipts", "Two-repo verification mechanics" and task T12 ("Gates and evidence capture") tell you what each AC means and how it can be shown.
- **Justin's decisions after go (design, not AC changes; they replace the plan's D7 wording on which pack rows show; ACs and test names are unchanged):** (1) "Company's own pack wins": for each pack name the page shows the company's newest version, and a shared version only when the company has none of that name; (2) "Hide replaced packs": a shared pack that a newer release replaced (even under a new name) gets no row; (3) "Keep your rule": every current shared starter pack shows as a row, assigned or not. GitHub `main` now includes PR #101 (quick start) and PR #102 (role starter packs, shared pack versions), which this branch has merged in.
- **Control-plane worktree** (the AC repo): `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics`, branch `feat/86bcm902w-content-usage-analytics`. This is **PR #103**. **Head:** `b4acb2f82016990587371a46279c88f416152c42` (check `gh pr view 103 -R LeornaAI/leorna-control-plane --json headRefOid`). **Base:** `8aa32a1f68fadacb8b0514566dd465ff14b883b9` (`git merge-base HEAD origin/main` = GitHub `main`).
- **Client worktree** (supporting receipts only): `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm902w-content-usage-analytics`, same branch = **PR #23**. **Head:** `cf3df7f8cb2af1a6d0a2ef42a6e08b1387ca7f20`. **Base:** `f105e27814b6efbec67059687963e722933acec2`.
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm902w/auditor-pr/` (exists, empty). Every receipt you cite must be inside it.

**Stay blind.** Under `~/.hermes/plans/leorna/evidence/86bcm902w/`, open nothing but `plan-approved.md` and your own `auditor-pr/` folder: not `verifier/`, `verifier-pr/`, `auditor/`, `review-*`, `client/`, `fix-*`, `pr/`, `harness/`, `INVENTORY.md`, `follow-ups.md`, the PNGs or logs in the folder's root, or any other file there. Don't read any `86bcm902w` brief, `~/.hermes/plans/leorna/86bcm902w-handover/`, the PR bodies' Test Plan claims as evidence, the working plan `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md` or other roles' scratch. Make your own logs, screenshots and probes.

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
3. Run each AC's test alone on head with the recipe (`HEAD=` first line, verbose output, `EXIT=` last line) → `auditor-pr/ac<n>-b4acb2f.log`.
4. Run the same test on base in a separate detached copy at `8aa32a1` with head's version of that AC's test file(s) copied in (plus the test files of packages the story creates that the test imports) → `auditor-pr/ac<n>-base-8aa32a1.log`. It must fail there (its own fail line or a build failure of the new code), not a setup failure or a missing file.
5. One screenshot per AC, taken by you, in `auditor-pr/`. AC2 and AC3 are visible on the admin page: capture the real page from a control-plane server you build at head on your own demo database (it loads the shipped seed and starter packs at startup), after real uploads of item uses (counts per pack and per item under Justin's pack-row rules; "Not measurable" text in the unmeasured cells, never 0). AC1: a local rendering of the spike write-up's per-tool table. AC4 and AC5: rendered pages of your own test logs, ending at `EXIT=`. Look at each image yourself: no domain, URL bar, tenant ID, token or email.
6. Supporting receipts on the client head `cf3df7f`: run the plan's supporting client tests and both `cmp` checks it names (golden upload body, OpenAPI spec), and name the client head `cf3df7f` in your AC2 and AC5 `evidence` lines.
7. Write `auditor-pr/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, with `"head": "b4acb2f82016990587371a46279c88f416152c42"`. Self-check it while staying blind: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <control-plane worktree> --base 8aa32a1f68fadacb8b0514566dd465ff14b883b9 --plan ~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md <evidence>/auditor-pr/ac.json <scratch copy>/ac.json` (no `--reviews`), then delete the copy.

## How to run things (this desktop is WSL Ubuntu)
- **Scratch:** a fresh `<scratchpad>/86bcm902w-auditorpr/` (`mkdir` without `-p`) for small files, and a fresh `~/.cache/86bcm902w-auditorpr/` on the real disk for `TMPDIR`, detached copies, binaries and Chrome's `--user-data-dir`. Not `/tmp` for big files (a small shared tmpfs). Remove only those folders, by their literal absolute paths, at the end.
- **Toolchain:** Go, golangci-lint and govulncheck in `~/.local/leorna-toolchain` (read-only); make and gcc from apt. PATH per command only, and **keep `/usr/local/bin` on any PATH you narrow**: gitleaks lives only there, and without it item-editor Postgres tests fail with 503 "secret scanner unavailable" (an environment failure, not the story).
- **Postgres:** `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; the plan's "Common environment" block shows how the URL is built, with the password read from the container). Create and later drop your own `leorna_86bcm902w_auditorpr_test`, `leorna_86bcm902w_auditorpr_base_test` and a demo database for the screenshots (names ending in `_test`). Never touch any other database or the `leorna-pg` container.
- **ClickHouse:** the running `leorna-test-ch-86bcm902w` container at `127.0.0.1:18123` (connection form in the plan's T0.5 and "Common environment"). Use it; never stop or remove it, and start no other containers.
- **Detached copies:** `git -C <worktree> worktree add --detach ~/.cache/86bcm902w-auditorpr/<name> <sha>`, removed with `git worktree remove --force <that exact path>`. **Never run `git worktree prune`** (it drops other stories' entries).
- **Chrome for Testing:** the Chrome paragraph of `ac-verification.md` (path, `LD_LIBRARY_PATH`, flags, `env -u DISPLAY -u WAYLAND_DISPLAY`, judging output by bytes and PNG magic, killing only your own Chrome PIDs). The server's CSP blocks inline scripts, so capture a tall section with chromedp's element screenshot.
- **Starting a server:** `setsid --fork sh -c 'echo $$ >pidfile; exec "$BIN"' >log 2>&1 </dev/null`. On this desktop `date +%3N` prints 9 digits: use python3 for millisecond timestamps.
- **Real tool homes:** never read or write Justin's real `~/.claude`, `~/.codex` or `~/.cursor` beyond read-only checks of installed binaries; any real-tool run uses an isolated HOME.
- Sibling stories run in other sessions in these repos: never touch their worktrees, branches, databases or evidence. Never write outside `auditor-pr/` and your scratch.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Skills
Load, in this order, with the Skill tool, and say so in your first steps: `leorna` (AC auditor; skip its Step 1 load), `engineering-best-practices`. Any skill step that says "spawn a subagent" is the main session's job.

## Rules
- If you find any other bug or problem along the way, don't fix it. List it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.
- You can't ask Justin anything and can't start agents.

## Output (your final message)
`{verdict: "clean" | "findings", head: "b4acb2f…", base: "8aa32a1…", client_head: "cf3df7f…", ac_status[{ac, accepted, test, screenshot, evidence}], ac_json: "<path>", self_check: "<ac-check.sh last line>", findings[{id, severity, claim, evidence}], found_else[], skill_lessons[]}`, then end with `MAIN SESSION: check and save these skill_lessons now.`
