# Role: reviewer (round 2, Mini delta, time-boxed) + verifier's AC work: bdry-demo

You are a fresh reviewer (**Opus 5.5, high**). Review only: change no source or test, commit nothing, start no agents.
**Time box: 25 minutes** (Justin's demo is due by about 11:50). Report only what Justin or his manager would see when he
pastes this into Bricks on B-Dry staging; everything else is P3. **Never load bdryswi.com** in any way, B-Dry staging or
any live site; no logins; never write to any WordPress site. Never stop a Chrome you didn't start; touch nothing under
`~/Downloads`. A blind auditor runs at the same time on its own: keep to your folders.

## What happened
bdry-demo (B-Dry's home as one Bricks paste for a demo; plan amended A1–A2:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/plan-approved.md`, AC1–AC11, AC11 live). Review 1
(`evidence/bdry-demo/review-1/review.json`) found R1-1 (P2): within 4 px only at the 7 checked widths (FAQ −177 px at
478, −111 at 991, −110 at 1366, …). Fixer 1 (branch `bdry-demo-fix1`, head `4721410d0692813053d1688dc72a7ac50574bee1`,
on `340a8d64`) added a sweep mode (47 widths) to `demo-fit.ts`, fixed the FAQ (mascot 100% up to 512 px; accordion
349 px max on phones; question rows on laptops), Fee Construction (padding by percentage), the red-flags heading on
tablets, kept the footer map's style, scoped the header's sticky CSS to the pasted header (it now sticks like the site's),
and named the 34 places still over 4 px in `gaps.json` (very wide screens 1920/2560; the narrowest phones 320–361;
others), with `PASTE-STEPS.md` step 14 and `WHAT-STAYS-OUT.md` saying so.

## Check (your scope: `git diff 340a8d64..4721410d` and what it touches)
1. Run the sweep (`demo-fit.ts --sweep`) and AC1–AC10's checks yourself on head, logs to your own folder (the scripts
   hard-code `evidence/bdry-demo/checks/`: run them through a `node --import` preload that redirects that one constant to
   `evidence/bdry-demo/verifier/`, as review 1 did, so the builder's and auditor's logs are untouched); write
   `verifier/ac.json` (each AC log `HEAD=<sha>` … `EXIT=`; AC1–AC8's "old code" is the start file as review 1 ran it;
   AC9, AC10 `base_exempt`), self-checked with `ac-check.sh` on a copy (`--base e16d3d1ea2c752bac7e405ce00bfc25accbc8de9`).
2. Did the fixes break anything visible: the sticky header (does it cover content at the top, on phones, under Bricks'
   admin bar; is the page's first section still visible below it), the FAQ at 1440/768/390, the footer map. Look at the
   rebuilt side-by-side pictures at 1440, 768 and 390 and your own drawing at 991 and 1366.
3. `gaps.json`, `PASTE-STEPS.md` and `WHAT-STAYS-OUT.md` are true to your sweep.
4. Nothing of the plugin moved (`git diff e16d3d1e..HEAD --stat`: only `test/demo/bdry-home/` and `docs/plans/`).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo/review-2/review.json` (round 2, a delta from `340a8d64`;
`head` the full SHA), self-checked with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh
--repo <your worktree> --base e16d3d1ea2c752bac7e405ce00bfc25accbc8de9 /home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-demo`;
and `verifier/ac.json` as above. Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first; load
`requesting-code-review` and `code-review-practice`.

## Machine
In your own worktree: `git checkout --detach 4721410d0692813053d1688dc72a7ac50574bee1`. Node
`/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bdr2/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by its profile path's
PIDs); shoot each page alone; run Chrome chains in the background and wait with bounded loops (a foreground `timeout`
can orphan Chrome). Put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on PATH. Script files for
multi-step commands; `git -C <absolute path>`. Use `tail -n 3`. One final report; no interim hand-backs.

## Report (as text)
Findings one line each (id, severity, section@width, what Justin's manager would see) or "none"; the sweep's count;
per AC: head and start-file results; `verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]`
(empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
