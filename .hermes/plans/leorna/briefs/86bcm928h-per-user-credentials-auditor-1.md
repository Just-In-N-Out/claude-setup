# AC AUDITOR brief, round 1: Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, blind **AC AUDITOR**. You are an Opus 5.5 agent at effort high, and source is read-only for you.
- Prove every acceptance criterion of the approved plan yourself, on the given head.
- You get only the inputs below. Don't read any other agent's evidence, reports, reviews or summaries: not `verifier/`, not `review-*`, not `*-report.md`, not `builder-report.md`.
- Write only into your own folder `~/.hermes/plans/leorna/evidence/86bcm928h/auditor/`.
- Change no source and commit nothing.
- Scratch goes in `~/.cache/86bcm928h-auditor/`, a short real-disk path (not `/tmp`). Remove it at the end.

## Inputs (only these)
- **Approved plan, the contract:** `~/.hermes/plans/leorna/evidence/86bcm928h/plan-approved.md`. Its ACs are AC1–AC8, each with its test names, and AC8 is `(live)`.
- **Worktree:** `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`, repo `leorna-client`.
- **Head:** `1f985964ba53c8f6fe91a93a8e9ed7bd30c072a2`. If HEAD differs, stop and report it.
- **Base:** `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`.
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm928h/auditor/`.

## Skills (say so in your first steps)
- `leorna` (the hard rules)
- `engineering-best-practices`
- Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`: the folders and run recipe, then Steps → AC AUDITOR. Follow it exactly:
  - The run recipe on head.
  - The base run, in a separate detached copy with head's test files. The test must pass on head and fail on base.
  - One screenshot per AC, taken by you.
  - `auditor/ac.json` in the format at the top of `scripts/ac-check.sh`.
  - The blind self-check without `--reviews`.

## The work
- For each AC, check that its test really proves the AC's words: read the test against the AC line, not just its exit code. Then run it on head and on base, with a log per run.
- **Screenshots:**
  - Take one screenshot per AC yourself.
  - The ACs with a panel (AC1, AC4, AC7) get a real UI capture of the shipped `cmd/leorna-client/frontend/dist/` page, driven as the plan describes. The others get a rendered terminal capture of the run, showing the command, output and `EXIT=` line.
  - On this WSL desktop, use Chrome for Testing with the flags in ac-verification.md. A page that calls `window.scrollTo` paints blank, so hide the other content and label it on the image instead.
- **AC8 (live):** owed to Justin. Record `"accepted": false, "not_run": "live: <why>"`.
- **Native Windows tests** (AC6, and the AC2/AC3 Windows tests):
  - Cross-build with `CGO_ENABLED=1 GOOS=windows CC='<zig> cc -target x86_64-windows-gnu'` (Zig is under `~/.local/leorna-tools`).
  - Run them through WSL interop with the package folder as cwd and `LEORNA_TEST_SECURE_STORE=1`.
  - **Run native `application` test binaries one at a time, never two at once:** a Windows test uses one fixed Credential Manager key, so parallel runs delete each other's entry.
  - Use test credentials only, deleted after each run. `cmdkey /list` must show no "Leorna Client" entry afterwards.
  - Never launch a real tool with a token, and never change the execution policy or PATH.

## Tools and environment
- **Toolchain:** it's off PATH. Use `~/.local/leorna-tools/go/bin` (go1.27.3) first on a task-local PATH, and echo the version.
- **TMPDIR:** owned and short, under `~/.cache/86bcm928h-auditor/`.
- **Never print** a token, a server domain or URL, or a tenant ID. Don't push or write to ClickUp.
- **Memory runaway:** a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as pass or fail. If it was, rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 …`.
- **Long waits:** don't end your turn to wait. Use `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` calls with the Bash timeout at 175000.

## found_else and skill_lessons
- If you find any other problem, list it in `found_else` with evidence and severity.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`).
  - `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind, what it checks and where it runs.
  - An empty list is the normal answer.

## Return
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
