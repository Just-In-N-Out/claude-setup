# Role: reviewer, round 1 (Mini, time-boxed: the one review plus the verifier's AC work; report only): bdry-demo

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit
nothing, start no agents. **Time box: finish in 35 minutes** (Justin's whole job must be done by about 11:50). Report
only bugs that would show when Justin pastes this into Bricks on B-Dry staging and shows it to his manager (a section
that looks wrong at one of the four sizes, a broken picture, a paste Bricks refuses or mangles, a step in his paste
instructions that is wrong); everything else is P3. **Never load bdryswi.com** in any way, B-Dry staging or any live
site (the checks' Chrome reaches only 127.0.0.1 and Google Fonts); no logins; never write to any WordPress site. Other
agents and Justin run Chrome on this machine: never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

## What the job is
A demo, not a plugin change: B-Dry's whole home page (header, page, footer) as **one Bricks paste** that looks like
bdryswi.com on desktop, tablet (≤1024 as Elementor does), phone sideways (≤767) and phone upright (≤478), with pictures
at bdryswi.com's own addresses, built by a script (`build-demo.ts`) from an earlier hand-built paste, for Justin to
paste into B-Dry staging (Bricks 2.4.2) and show his manager. Justin's answers: one paste for all sizes; build from the
saved copy on this PC; the old site's pictures; done in 2–2.5 h.

## Inputs
- Approved plan (read-only; amended — read its Amendments list: AC3–AC6 are measured against the 2026-11-04 capture's
  boxes, not the older saved page): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/plan-approved.md`
  (AC1–AC11; AC11 live: mark it `not_run`, owed). Each AC's check is a script named in the plan.
- Branch `bdry-demo-build`, head `340a8d64f43977790f4be40ea2eb9c19c0bec4dd`, base main
  `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`. In your own worktree: `git checkout --detach
  340a8d64f43977790f4be40ea2eb9c19c0bec4dd`, confirm HEAD and a clean status. The scripts live in
  `test/demo/bdry-home/`.
- The deliverable: `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/` (`bdry-home-demo.json`,
  `shots/`, `PASTE-STEPS.md`, `gaps.json`, `WHAT-STAYS-OUT.md`, `checks/`, `builder/` — read, don't trust).

## Check (do each yourself; keep to the box)
1. **Run every AC's check yourself** on head (AC1–AC10) and write the verifier's `ac.json` (below): one log per AC
   starting `HEAD=<sha>` and ending `EXIT=`. The "old code" for this job is the start file (the earlier paste): run
   AC1–AC8's checks against it where the check takes a paste (the builder shows AC1 and AC2 fail there) — that is this
   job's RED; AC9 and AC10 are `base_exempt` (guards), with a reason.
2. **Look at it as Justin's manager will:** open the side-by-side pictures at 1440, 1024, 768, 390 and the 22 section
   pictures; draw the paste yourself in the repo's renderer (as the checks do) and compare with the capture's boxes at
   two widths of your own choosing (not the checks' seven). Anything visibly wrong — a missing picture, overlapping
   words, a button that looks different, a footer column out of place — is a finding with the width and section.
3. **The paste in Bricks:** the paste file is valid for Bricks 2.4.2 (`payloadProblems` clean; element shapes as
   `reference/bricks/*.json`); no element names another's id; the Code elements (reviews strip, footer map) are named
   in the steps with "Regenerate code signatures"; the `figure` margin the builder set to 0 (unverified live: say what
   it risks); pictures are bdryswi.com addresses with no media id, so Bricks won't swap them for the grey placeholder.
4. **`PASTE-STEPS.md`:** plain numbered steps, one action each, correct for B-Dry staging (the toggle names the builder
   wrote from memory are marked as such); `WHAT-STAYS-OUT.md` true.
5. **Nothing of the plugin moved:** `git diff e16d3d1e..HEAD --stat` touches only `test/demo/bdry-home/` and
   `docs/plans/`.

## Write
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/review-1/review.json` (round 1; `head` the full SHA),
  then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
  worktree> --base e16d3d1ea2c752bac7e405ce00bfc25accbc8de9 /home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo`
  (exit 2 means your file is wrong);
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/verifier/ac.json` (the format at the top of
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`; read
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`), self-checked with
  `ac-check.sh` on a copy (`--base e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`, no `--reviews`).
Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Load
`requesting-code-review` and `code-review-practice`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bdr/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by its profile path's
PIDs; never `pkill -f`); shoot each page alone. A worktree's `node_modules` may lack `.bin` (put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH). A piped, chained or redirected git command, a
heredoc or a shell function may be refused: write such steps to a script file and run `bash <file>`; `git -C <absolute
path>`. Use `tail -n 3`. Waits under 115 s. Send one final report; no interim hand-backs.

## Report (as text; only the two json files and logs are written)
Findings one line each (id, severity, file:line or section@width, claim, what Justin's manager would see) or "none";
per AC: the check, head result, start-file result; `verdict`; `ac_status`; then `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
