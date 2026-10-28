# AC AUDITOR brief: 86bcm901b-prompts-collection [leorna]

**Role:** blind AC AUDITOR (source read-only) for the Leorna story "86bcm901b-prompts-collection" (ClickUp "Curate the reusable prompts collection"). You are fresh and independent: prove every acceptance criterion yourself, from the approved plan and the code alone. A script then compares your report with another agent's that you never see; any disagreement means not accepted, so be exact, not generous.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac.

## Skills to load first (say so in your first steps)

1. `leorna` (Step 1 context load for the control plane).
2. `engineering-best-practices`.

Then read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the run recipe, base runs, screenshots, the report format and the self-check) and the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. You play the AUDITOR there, and you use the same run recipe the verifier part describes.

## Your inputs: only these

- **Approved plan:** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/plan-approved.md` (read-only). Its "Acceptance criteria" section names AC1–AC5, one test per AC and the exact command that runs only that test. AC5 is tagged `(live)`.
- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection` (branch `feat/86bcm901b-prompts-collection`).
- **Head:** `63afe554f42e593b545741e453a59d560c49cb22`. **Base:** `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- **Your folder:** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/auditor/` (create it).

**Blindness rule:** in `~/.hermes/plans/leorna/evidence/86bcm901b/` read only `plan-approved.md` and your own `auditor/`. Don't open anything else there (no `verifier/`, `review-*`, `fix-*`, builder logs, screenshots, `INVENTORY.md`, `EVIDENCE.md`, `ac5-*`), nor `~/.hermes/plans/leorna/evidence/86bcm901b-intake/`, `~/.hermes/plans/leorna/briefs/`, `~/.hermes/plans/leorna/found-else.md` or the live plan `~/.hermes/plans/leorna/86bcm901b-prompts-collection.md`. Don't read other agents' transcripts. The repo itself (code, tests, README, git history) is yours to read.

## Your job

For each of AC1–AC4:
1. Read the AC's plan line and its test, and judge whether the test really checks every clause of the AC. Where a clause seems unexercised, prove it with a read-only `go test -overlay` mutant of the code it depends on (never edit a source file).
2. Run the AC's own command on head, from the worktree, per the recipe (log `auditor/ac<n>-63afe55.log`: first line `HEAD=…`, verbose output, last line `EXIT=…`). AC4's command needs `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`.
3. Run it on base in a separate detached copy with only head's version of that AC's test file copied in, one AC at a time (log `auditor/ac<n>-base-1ee7157.log`). It must fail there by its own assertion or a build failure of the new code. A missing test file, missing package or setup failure doesn't count.
4. Take one screenshot of your own run (`auditor/ac<n>-auditor-63afe55.png`): render your log in a `<pre>` page and screenshot it with this desktop's Chrome recipe in `ac-verification.md` (Chrome for Testing, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, and `env -u DISPLAY -u WAYLAND_DISPLAY`). Kill only Chrome processes with your own `--user-data-dir`, filtering out shells as that line says. Look at each image: the command, the pass line and `EXIT=` are on screen, and no URL, secret or email shows.

AC5 (live) gets `"accepted": false, "not_run": "live: Justin runs /review and /spec in Claude Code"`.

Then write `auditor/ac.json` in the `ac-check.sh` format (`head` = the full head SHA; every receipt inside `auditor/`). Self-check it as `ac-verification.md` says: `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `ac-check.sh --repo <worktree> --base 1ee7157f5dfeb24ddf2df7e3bb5363833385d50d --plan <plan-approved.md> <your ac.json> <scratch copy>/ac.json`, read its last line, then delete the copy.

## How to run things

- **Toolchain:** no system Go, make, gcc or Postgres here. Use the story's user-space environment read-only: `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local`. Don't change anything under `~/.cache/leorna-86bcm901b/`. If an AC test needs Postgres, the story's PostgreSQL 18.6 runs on 127.0.0.1:55400 (`~/.cache/leorna-86bcm901b/pg/pg.env`, password in `pg/password`): create only databases named `leorna_86bcm901b_auditor_*_test` and drop them afterwards; never print the password or a DB URL.
- **Worktrees:** `git -C <worktree> worktree add --detach <your scratch>/base 1ee7157` and `git worktree remove` when done. The story worktree must stay clean at `63afe55` (`git status --porcelain --untracked-files=all` empty); `go test` there is fine.
- **Siblings:** other sessions are working in this repo on 86bcm901a, 86bcm901j and 86bcm901w. Never touch their worktrees, branches, databases or evidence.
- **Shell gotcha:** in this Bash tool `grep` is a function running Claude Code's ugrep: it skips gitignored and binary files, and bounded repeats like `.\{0,200\}` fail. Use `command grep`.
- **Scratch:** `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-auditor-1/`, created fresh with `mkdir` (no `-p`). The scratchpad is shared: never read or touch other folders there, and remove yours at the end.
- No commit, push, PR, merge or ClickUp write. Claude Code refuses report files from subagents, so return your report as your final message; `ac.json`, logs and images are receipts. If writing `ac.json` is refused, say so and include its full content in your final message.

## Rules

- You can't ask Justin anything, and you can't start other agents.
- Other bugs: `found_else` (one line each, evidence, severity).
- Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section (an empty list is the normal answer), and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{verdict: clean|findings, head, base, ac_status[{ac, accepted, test, log, base_log, screenshot, evidence, not_run?}], clause_checks[{ac, clause, how_proven}], ac_json, ac_check_selftest, found_else[], skill_lessons[]}`.
