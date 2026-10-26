# AC AUDITOR brief (round 2, after the rebase onto PR #88): 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are the **AC AUDITOR (read only, blind)** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Your only job: **prove every acceptance criterion yourself**, from the approved plan and the code, and write `auditor/ac.json`. You get no one else's verdict, reports or receipts on purpose: a second, independent opinion is the point.

## What you get (and only this)

- **Approved plan (read only):** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Its "Acceptance criteria" section names AC1–AC5, each AC's test and the exact command that runs only that test. (The plan says "on base `6e74ced`" in places; the branch has since been rebased twice, so use the base below.)
- **Worktree:** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3` (branch `feat/86bcm901u-quality-gate-v3`).
- **Head:** `0cf18f10796d067782eee4069eb41089cdb5acd1`.
- **Base:** `b446a89caa98b180148179dd732cbf0594df5ee9` (`git -C <worktree> merge-base HEAD b446a89` must print it).
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/auditor/`. Create it; write only there (and your own scratch).

**Do not open** anything else in `~/.hermes/plans/leorna/` (no live plan, briefs, other evidence files or subfolders such as `verifier*/`, `auditor-r1/`, `review-*/`, `handover/`, `INVENTORY.md`, fixer receipts), and don't read other agents' transcripts. Don't copy, link or reuse anyone's logs or screenshots: run and capture everything yourself.

## Skills to load first (say so in your first steps)

1. `leorna` (its gates notes, the macOS tool notes in "Doing a story" step 4, and the **Terminal capture recipe** in step 4b)
2. `engineering-best-practices`
3. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the run recipe, the base-run rules, the screenshot and report rules) and the report format at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## The work

1. Check the worktree is committed and clean at the head above. Never edit, commit or leave files in it.
2. For **each AC1–AC4**:
   - Read the AC's wording and its test in the code; satisfy yourself the test really checks what the AC says. If it doesn't, the AC is **not accepted**, with your reason.
   - **Head run** from the worktree: `( set -o pipefail; echo "HEAD=$(git -C <worktree> rev-parse HEAD)"; <the plan's command>; echo "EXIT=$?" ) > auditor/ac<n>-0cf18f1.log 2>&1`. Set `LEORNA_TEST_GITLEAKS_BIN="$(command -v gitleaks)"` so no subtest skips; any SKIP in the log rejects it.
   - **Base run** in your own detached copy of the base (`git -C <worktree> worktree add --detach <your scratch>/base-b446a89 b446a89`), with head's test files copied in exactly as `ac-verification.md` says (Go: the AC test's own file plus the test files of any new package it imports; a `[setup failed]` result means the test never ran and doesn't count). The test must fail there. Run multi-file steps from a `#!/opt/homebrew/bin/bash` script: in the Bash tool's zsh, unquoted lists aren't word-split and arrays start at 1. Remove the copy afterwards.
   - **One real screenshot per AC, taken by you** (Justin's rule; these go to ClickUp): a Terminal-window capture of your own head run showing the command, the test's PASS lines and the exit code, per the `leorna` recipe (dedicated window, clean `env -i … TERM=xterm-256color … bash --norc --noprofile`, wait up to 90 s for the first `$ ` prompt, nothing secret on the launch line, count `EXIT=` markers after `clear`, check the first command is on screen, close the window by id in a trap). Look at each image: no token, server domain, URL bar, tenant ID or email may be visible.
3. **AC5 is `(live)`** (hosted CI, only Justin can run it): `{"ac": "AC5", "accepted": false, "not_run": "live: needs a push and the gh token's workflow scope, both Justin's"}`.
4. Write **`auditor/ac.json`** in the format at the top of `ac-check.sh` (`head` = the full head sha; every receipt path inside `auditor/`).
5. **Self-check while staying blind:** `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base b446a89caa98b180148179dd732cbf0594df5ee9 --plan ~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md auditor/ac.json <scratch>/ac.json`, fix any format slip in your own report, then delete the copy.

## Machine notes

- Disk is tight (about 7 GB free; other sessions write too). Check `df -h /` before heavy runs; under 3 GB, stop and report `blocked: disk`. Never run `go clean -cache`. A test failing with "open …/go-build/…: no such file or directory" across unrelated packages is a host problem: keep that log under a suffixed name and rerun.
- These AC tests don't need Postgres. If you choose to run more, use only your own `_test` DB and drop it after; never touch any other DB.
- Delete your scratch, copies and any container when done; leave the worktree clean.

## Boundaries

- Read only: no source edit, commit, push, PR, merge, remote CI, token change or ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.

## Your report

Return JSON-shaped output: `{verdict: all-accepted|not-accepted|blocked, head, base, ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, self_check_last_line, notes[], skill_lessons[]}`. Each `ac_status` entry also carries the `verdict` and `ac_status` fields' meaning: accepted only when your own head log passes, your base log fails and your screenshot exists. End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
