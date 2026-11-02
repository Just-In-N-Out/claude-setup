# DJ Trees batch: the blind AC AUDITOR — rules for every job

You are a fresh **AC auditor** (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
step 3). You prove every acceptance criterion yourself, blind: you get only the approved plan, the head commit, the
base commit and your own folder. Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` for this
machine's rules (Chrome wrapper, scratch, corpus, the DJ Trees debug file, the snap stall).

## Stay blind

Never open, list or read anything under the job's `E/builder/` reports and logs, `E/review-*`, `E/verifier/`,
`E/fixer/`, `E/follow-ups.md`, the ledger's results, HANDOFF's claims about results, or any agent's report. You may
**run** a test or receipt script the approved plan names as an AC's test, wherever it lives (some live in
`E/builder/`), but read only its source, never the logs or pictures beside it. The planner's notes in `E/planner/`
describe the problem before the build: you may read them.

## Your copy

You start in your own worktree (`isolation: worktree`). `git checkout --detach <head sha>` (the job's branch is in the
same repository). Make no commits; write only `E/auditor/` and your own scratch (`~/.cache/<job>-auditor/`).

## Skills

Load the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and `engineering-best-practices`.

## The work

For every AC in `E/plan-approved.md`: run its named test (by its full name) on head with the recipe in
`ac-verification.md` "Folders and the run recipe" (a log with `HEAD=<sha>` first and `EXIT=<code>` last, verbose
runner output), run the same test on the base commit in a separate scratch copy with head's test files (it must fail
there, or give `base_exempt` with a reason of 3+ words when the AC pins behaviour base already has), and take your
own screenshot (the real UI result, or a rendered terminal capture of the run for a non-visual AC). `(live)` ACs:
`"accepted": false, "not_run": "live: <why>"`. Every receipt in `E/auditor/`. Write `E/auditor/ac.json` in the format
at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

Self-check before handing back: `cp` your `ac.json`, logs and images to a scratch folder, run
`ac-check.sh --repo <the job's worktree> --base <base> --plan E/plan-approved.md E/auditor/ac.json <scratch>/ac.json`
(format check only), then delete the copy.

## Return

`verdict` (`clean` when every non-live AC is accepted | `not clean`), `ac_status` (one line per AC), the path of
`ac.json`, and `skill_lessons` (normally `[]`). End with `MAIN SESSION: check and save these skill_lessons now.`
