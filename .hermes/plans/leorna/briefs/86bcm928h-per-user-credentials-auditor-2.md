# AC AUDITOR brief, round 2: Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, blind **AC AUDITOR**. You are an Opus 5.5 agent at effort xhigh, and source is read-only for you.

Every rule in the round-1 auditor brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-auditor-1.md`. Read it first. It covers the skills, the work, screenshots, AC8, the native Windows rules, tools, earlyoom, long waits, found_else, skill_lessons and the return schema. It is overridden only where this file says something different.

## What's different in round 2
- **Head:** `0af447184c884a7e6d74efb4fb98909143e8d2d3`. If HEAD differs, stop and report it.
- **Base:** `a7839b3af664efcfa59eb1ed3fe276ec1262a4de`, GitHub main, which equals `git merge-base HEAD origin/main`.
  - The base run happens in a separate detached copy of a7839b3 with head's test files. The test must pass on head and fail on base.
  - If you add a detached worktree, deregister only your own with `git worktree remove --force <path>`. Never run `git worktree prune`.
- **Inputs, only these:**
  - the approved plan `~/.hermes/plans/leorna/evidence/86bcm928h/plan-approved.md`
  - the worktree `/home/justin/Leorna/leorna-client/.claude/worktrees/86bcm928h-per-user-credentials`
  - the head and base above
  - your folder
- **Blindness:** don't read any other agent's evidence, reports, reviews or summaries. That covers:
  - `verifier/`, `verifier-1f98596/` and `auditor-1f98596/`
  - `review-*`, `*-report.md`, `bring-main-3/`, `fixer-4/` and `gates-*.txt`
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/auditor/`. It is a new, empty folder you create. The scratch folder is `~/.cache/86bcm928h-auditor-2/`, removed at the end.
- **No banner on evidence images** (Justin, 2026-11-10; `ac-verification.md`): an image shows only the result. Never put an explanatory label, header or caption on it. That rules out:
  - "local rendering", "not the app window", "rendering"
  - test or helper names in a banner, "stub bridge", "other panels hidden"
  - head SHAs, "elided", redaction notes

  Say how an image was made in its `.log` or receipt, never on the image.
  - A terminal capture shows the command, output and `EXIT=` line only.
  - A UI capture (AC1, AC4, AC7) shows the panel only.
  - The round-1 brief's "label it on the image" no longer applies. To show a panel, hide the other content and say so in the receipt.
  - Take a panel's height in a window shorter than the content (e.g. `--window-size=900,300`): Leorna's `body` has `min-height:100vh`.
- **Earlyoom check:** `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`
- **Mutation and overlay runs:** quote env assignments (`env "PATH=$PATH" …`).
- **Load on the machine:** a 1 s timing test in `application` (`TestSyncEngineCancellationAfterSuccessPersistsPartialAndReturnsCause`) can fail when the machine is busy. If it fails, rerun it with nothing else of yours running before you judge it.
- **The blind self-check** is the same as round 1: copy the files to scratch and run `ac-check.sh` without `--reviews`. Record its last line.

## Return
Same schema as round 1: `{verdict, findings[], ac_status[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
