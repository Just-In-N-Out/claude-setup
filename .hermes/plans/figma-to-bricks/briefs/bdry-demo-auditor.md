# BLIND AC AUDITOR (read only, time-boxed): bdry-demo (B-Dry's home page as one Bricks paste for a demo)

You are a fresh auditor (**Opus 5.5, xhigh**). **Time box: 25 minutes** (Justin's demo is due by about 11:50).
Independently prove the approved acceptance criteria. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/` except `plan-approved.md`, the deliverable files the
plan names (`bdry-home-demo.json`, `shots/`, `PASTE-STEPS.md`, `gaps.json`, `WHAT-STAYS-OUT.md`) and your own `auditor/`
folder (never `builder/`, `fixer-*`, `review-*`, `verifier*`, `checks/`, `planner/`, `follow-ups.md`,
`plan-approved-v*`). Source and tests are read-only; commit nothing; start no agents. **Never load bdryswi.com** in any
way, B-Dry staging or any live site; no logins; never write to any WordPress site. Never stop a Chrome you didn't
start; touch nothing under `~/Downloads`. A reviewer runs at the same time: keep to your folder.

## The only inputs
- Approved plan (amended A1–A2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/plan-approved.md`
  (AC1–AC11; AC11 live: `not_run`). Each AC's check is a script named in the plan; the scripts hard-code the folder
  `evidence/bdry-demo/checks/` — run them through a `node --import` preload whose load hook redirects that one constant
  to your `auditor/` folder (check the replaced text occurs exactly once), so no other agent's logs are touched.
- Head `4721410d0692813053d1688dc72a7ac50574bee1` (branch `bdry-demo-fix1`), base `e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`.
  "Old code" for AC1–AC8 is the earlier paste the plan starts from (run the checks against it where they take a paste);
  AC9 and AC10 are guards (`base_exempt`, with a reason).

## Work
In your own worktree: `git checkout --detach 4721410d0692813053d1688dc72a7ac50574bee1`. Read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the blind auditor procedure and
the `ac.json` format at the top of `scripts/ac-check.sh`). Run every AC's check on head and on the start file; one log
per AC (`HEAD=<sha>` … `EXIT=`). Then prove the look yourself beyond the checks: draw the paste with the repo's
renderer at two widths of your own choosing and compare each section with the capture the plan names; and run the
sweep (`demo-fit.ts --sweep`) and compare with what `gaps.json` names (every place over 4 px named, honestly). Write
`auditor/ac.json`, self-check by copying it and its logs to a scratch folder and running `ac-check.sh` (`--base
e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`, no `--reviews`).

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bda/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by its profile path's
PIDs); shoot each page alone; run Chrome chains in the background and wait with bounded loops. Put
`/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH. Script files for multi-step commands; `git -C
<absolute path>`. Use `tail -n 3`. One final report; no interim hand-backs.

## Report
`{verdict, head, base, findings[], ac_status[{ac,accepted,test,screenshot,evidence}], sweep (count over 4 px vs
gaps.json), found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. End with `MAIN SESSION: check and save these
skill_lessons now.`
