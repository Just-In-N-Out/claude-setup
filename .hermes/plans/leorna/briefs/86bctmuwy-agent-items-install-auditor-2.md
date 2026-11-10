# AC AUDITOR brief, round 2 (head after bringing main in and fix rounds 3–4): 86bctmuwy-agent-items-install (Leorna, leorna-client)

**Role:** fresh, blind, read-only AC AUDITOR. Prove every acceptance criterion yourself. Change no source, commit nothing; write only into `~/.hermes/plans/leorna/evidence/86bctmuwy/auditor-2/` (create it). All scratch in your own fresh folder `~/.cache/86bctmuwy-auditor-2/` (`mkdir` without `-p`), including TMPDIR, Chrome profiles and built binaries (not `/tmp`, a small shared RAM disk).
**Model/effort:** Opus 5.5, xhigh.

**Blind:** you get only the inputs below. Do not open, list or read anything else under `~/.hermes/plans/leorna/evidence/86bctmuwy/` (not `verifier/`, `verifier-2/`, `auditor/`, `builder/`, `bring-main-1/`, `review-*`, `fixer-*`, screenshots or summaries), nor the plan briefs folder, nor other agents' `~/.cache/86bctmuwy-*` folders. Take your own screenshots and run your own checks.

## Inputs
- Approved plan (read-only; ACs AC1–AC13 are the contract): `~/.hermes/plans/leorna/evidence/86bctmuwy/plan-approved.md`
- Worktree: `/home/justin/Leorna/leorna-client/.claude/worktrees/86bctmuwy-agent-items-install`
- Head: `9e2d1cb48fafd600d666c00145ddf4f7e1532aa8`
- Base: `f3bc96061c74510b4cd9f7a7ee0a14890f087441` (`git merge-base HEAD origin/main`)
- Your folder: `~/.hermes/plans/leorna/evidence/86bctmuwy/auditor-2/`

AC13 is `(live)` (Justin's Cursor editor check): mark it `"accepted": false, "not_run": "live: <why>"`.

## Skills to load (say so in your first steps)
`leorna`, `engineering-best-practices`. Then follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` → "Folders and the run recipe" and Steps → AC AUDITOR exactly (that guide is a skill reference, allowed to read).

## What to do
1. For every AC1–AC12: run only that AC's named test (the plan names each) on head, writing `auditor-2/ac<n>-9e2d1cb.log` with the `HEAD=` first line and `EXIT=` last line, and on base in a separate detached copy (never the worktree) with head's test files, writing `auditor-2/ac<n>-base-f3bc960.log`. Pass on head (its own pass line, no skip); fail on base (its own fail line, or a build failure of the new code). Go: copy head's AC test files plus the test files of any package the story creates that the test imports.
2. Before judging an AC, `git -C <worktree> log -p f3bc960..HEAD -- <its test files>` and read each assertion against the approved AC text. For any clause the test seems not to exercise, prove it with your own `go test -overlay` mutant (read the line it fails on; a mutant that doesn't build is not a kill).
3. Real-tool ACs: AC4 with `LEORNA_TEST_CLAUDE_BIN` (real Claude Code), AC5 with `LEORNA_TEST_CODEX_BIN` (real Codex), AC12 with `LEORNA_TEST_CURSOR_BIN=/home/justin/.local/share/cursor-agent/versions/2026.11.05-86047df/cursor-agent`; exact commands in the plan's Gates section. A skip is not a pass.
4. One screenshot per AC of your own head log, rendered as `ac-verification.md` describes for the WSL desktop (Chrome for Testing `~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer`, under `env -u DISPLAY -u WAYLAND_DISPLAY`, height from the page). Check PNG magic bytes, look at each, check `EXIT=` is on it. No email, URL, token or tenant ID visible.
5. Write `auditor-2/ac.json` in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Blind self-check: copy (`cp`, not `ln`) your `ac.json`, logs and images to a scratch folder and run `ac-check.sh --repo <worktree> --base f3bc96061c74510b4cd9f7a7ee0a14890f087441 --plan <plan-approved.md> auditor-2/ac.json <scratch>/ac.json` (your own `ac.json` first, the scratch copy second) (no `--reviews`), then remove the copy.

## Rules
- Isolation: every test/probe uses throwaway HOME, USERPROFILE, CODEX_HOME, CLAUDE_CONFIG_DIR, XDG_CONFIG_HOME, CURSOR_CONFIG_DIR, CURSOR_DATA_DIR. Never touch the real `~/.claude`, `~/.codex`, `~/.cursor` or `~/.config/cursor`; after a HOME switch write paths in full (`/home/justin/...`).
- The worktree must stay clean and at head.
- WSL PATH holds entries with spaces (`/mnt/c/Program Files/...`): export PATH in scripts; EXIT=127 is an invocation error.
- Go mutants: keep variables used (`(x == y || true)`), or the build fails "declared and not used" and it is not a kill.
- AC4's real Claude Code log's init line can list the user's own skill names: on a rendered screenshot, shorten lines over ~500 characters and say so on the page.
- WSL can restart and leave 0-byte files; check sizes and `EXIT=` lines before trusting any file.
- Memory (WSL desktop): SIGTERM / 143 / 137 / "Killed" may be earlyoom — check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`; mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000); don't end your turn to wait.
- Other bugs: `found_else`.
- **skill_lessons:** If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{verdict: clean|findings, ac_status[{ac, accepted, test, screenshot, evidence}], findings[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
