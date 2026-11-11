# AC AUDITOR brief, round 3 (PR #33 final head): Leorna story 86bcm928h-per-user-credentials

**Role:** a fresh, blind AC AUDITOR. Opus 5.5 at effort xhigh. Source is read-only.

Every rule in the round-2 auditor brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-auditor-2.md`. That covers blindness, the no-banner images, the panel-height note, quoted env, the load note and the blind self-check. It in turn points to round 1: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-auditor-1.md`. Read both. Only what this file says differently overrides them.

## What's different in round 3
- **Head:** `eef72c761ad616f50409c1e985e97e039936a772`. It is PR #33's pushed head. If HEAD differs, stop and report it.
- **Base:** `3f4bad71b3f4cce6b387d167228db167c57c7148` = GitHub main = `git merge-base HEAD origin/main`.
  - The base run happens in a separate detached copy with head's test files.
  - The test must pass on head and fail on base.
  - If you add a detached worktree, deregister only your own with `git worktree remove --force <path>`. Never run `git worktree prune`.
- **Toolchain:** Go 1.27.4 from `~/.local/leorna-toolchain/go1.27.4/bin`, first on a task-local PATH, with `GOTOOLCHAIN=local`. Echo `go version`.
- **Blindness:** also don't read `verifier/`, `verifier-0af4471/`, `auditor-0af4471/`, `review-6/`, `review-7/`, `fixer-5/` or `finisher-pr/`.
- **Write only into** `~/.hermes/plans/leorna/evidence/86bcm928h/auditor/`. It is a new, empty folder you create. Scratch goes in `~/.cache/86bcm928h-auditor-3/`, removed at the end.
- **Terminal captures:**
  - Write every note in a log on its own `# ` line, and echo each `$ <command>` bare.
  - Leave the `HEAD=` stamp, wrapper lines and `# ` lines off the rendered page.
  - The image shows the command, its output and `EXIT=`, nothing else.
- **AC8:** Justin said not to mention it in anything that goes out.
  - In `auditor/ac.json`, keep AC8 as `"accepted": false, "not_run": "live: <why>"`, because `ac-check.sh` reads the plan's AC list.
  - Never put AC8 on an image.

## Return
Same schema as round 1. End with `MAIN SESSION: check and save these skill_lessons now.`
