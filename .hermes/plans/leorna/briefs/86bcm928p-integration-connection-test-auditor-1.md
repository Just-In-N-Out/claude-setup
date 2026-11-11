# AC AUDITOR brief, round 1: 86bcm928p connection test for integrations (Leorna, leorna-control-plane)

**Role:** fresh, blind, read-only AC AUDITOR. Prove every acceptance criterion yourself. Change no source and commit nothing. Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/auditor/` (create it). Keep all scratch in your own fresh folder `~/.cache/86bcm928p-auditor/` (`mkdir` without `-p`), including TMPDIR, Chrome profiles, built binaries and base copies. Never use `/tmp`, which is a small shared RAM disk.
**Model/effort:** Opus 5.5, xhigh.

**You are blind:** you get only the inputs below. Do not open, list or read anything else under `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/` (not `verifier/`, `builder/`, `review-*`, `intake/`, `follow-ups.md`, the PNGs in the evidence root, or any summary). Don't read the plan briefs folder or other agents' `~/.cache/86bcm928p-*` folders. Take your own screenshots and run your own checks.

## Inputs
- Approved plan (read only; its ACs are the contract): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test` (repo `leorna-control-plane`)
- Head: `9da16b86ca2607a1242b745019fa23cf893a02df`
- Base: `4ef14efb46da789aec30fad1e5a988d8770140e2` (the story base)
- Your folder: `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/auditor/`

The plan names two ACs (AC1, AC2), each with one named Go test in `internal/web`, and no `(live)` AC. Read the plan's ACs, Tests, "Old-code behaviour" and evidence task yourself.

## Skills to load (say so in your first steps)
`leorna`, `engineering-best-practices`, `mutation-testing-discipline`. Then follow `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` exactly: "Folders and the run recipe", then Steps → AC AUDITOR. That guide is a skill reference, so you may read it.

## What to do
1. **Every AC:** run only that AC's named test on head, writing `auditor/ac<n>-9da16b8.log` with a `HEAD=` first line and an `EXIT=` last line. Run it on base in a separate detached copy (never the worktree), with head's AC test file plus the new package the test imports, writing `auditor/ac<n>-base-4ef14ef.log`.
   - It must pass on head: its own pass line, all subtests, no skip.
   - It must fail on base: its own fail line, or a build failure of the new code. A base copy with the plan's one-function shim is labelled in the log's second line.
   - Postgres: use your own Postgres container or your own `_test` database. The containers `928p-builder-pg` and `928p-builder-ch` are running and may be used with your own database name; their connection settings are in `~/.cache/86bcm928p-builder/env.sh` and its pg env file (0600; never print the password). Drop what you create.
   - Record each row's exact `command`.
2. **Before judging an AC,** run `git -C <worktree> log -p 4ef14ef..HEAD -- <its test files>` and read each assertion against the approved AC text. For any clause the test seems not to exercise, prove it with your own `go test -overlay` mutant: read the line it fails on. A mutant that doesn't build is not a kill. A mutant whose call is refused and does nothing is not a mutant: print the call's error once before you grade a survivor.
3. **One screenshot per AC, your own** (`auditor/ac<n>-<what>.png`). Prefer the real page: the plan's opt-in browser test writes real pictures of the Test result. Run it from your own scratch copy of head (`git -C <wt> archive <sha> | tar -x -C <scratch>`) into your own folder. Otherwise render your head log as a page with Chrome for Testing, as `ac-verification.md` describes for the WSL desktop.
   - **No banner on evidence images** (Justin, 2026-11-10): the image shows the result only, with no caption, label or note about how it was made.
   - Check the PNG magic bytes and look at each image. No email, server domain, token or tenant ID may be visible.
4. **`auditor/ac.json`:** write it in the format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Blind self-check: copy (`cp`, not `ln`) your `ac.json`, logs and images to a scratch folder and run `ac-check.sh --repo /home/justin/Leorna/86bcm928p-integration-connection-test --base 4ef14efb46da789aec30fad1e5a988d8770140e2 --plan /home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md /home/justin/.hermes/plans/leorna/evidence/86bcm928p/auditor/ac.json <scratch>/ac.json` (your own `ac.json` first, the scratch copy second, no `--reviews`). Then remove the copy.

## Rules
- The worktree must stay clean (`git status --porcelain --untracked-files=all` empty) and at head. Don't run a repo-wide `git worktree prune`; remove only your own detached copies with `git worktree remove --force <own path>`.
- Tests must not reach the real internet.
- Go mutants: keep variables used (`(x == y || true)`), or the build fails with "declared and not used", which is not a kill.
- WSL PATH has entries with spaces (`/mnt/c/Program Files/...`): export PATH in scripts. EXIT=127 is an invocation error. Toolchain: `~/.local/leorna-toolchain`.
- WSL can restart and leave 0-byte files: check sizes and `EXIT=` lines before you trust any file.
- Memory (WSL desktop): SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`. Run mutants and heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Long commands: `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` (Bash timeout 175000). Don't end your turn to wait.
- Other bugs: `found_else`.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.

## Report (as text)
`{verdict: clean|findings, ac_status[{ac, accepted, test, screenshot, evidence}], findings[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
