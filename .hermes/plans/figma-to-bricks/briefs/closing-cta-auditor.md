# BLIND AC AUDITOR (read only): closing-cta → section rhythm (FigmaToBricksV2)

Prove the approved acceptance criteria yourself. You have never seen a builder, reviewer, fixer or verifier report, and
you stay blind:
- never open another role's report, evidence folder or brief;
- don't read the ledger (`.superpowers/sdd/`) or HANDOFF for earlier verdicts.

Source and tests are read only. Commit nothing, don't start other agents, and never edit skills or memory.

## Your only inputs
- **Approved plan (read only):** `/home/justin/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`.
  It already includes the user's later answers: its "Amendments" list at the top says what changed and why.
- **Worktree:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta`, branch `worktree-closing-cta`.
- **Head:** `3a4ecf72a3fa38ccaff76fbedda222fefc7de928`.
- **Base:** `5e2f98bff77fa1d214b7d76968a54a6dafa32ca6`, the merge-base with `main`. Local `main` has moved on since; don't
  use it.
- Confirm the worktree is clean at that head and the merge-base matches before you start.
- **Your own evidence folder only:** `/home/justin/.hermes/plans/figma-to-bricks/evidence/closing-cta/auditor/`.

## Skills (load first, say so in one line each)
1. Project skill: Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its
   `references/rules-summary.md` first. It isn't linked into ~/.claude/skills.
2. `engineering-best-practices`.
3. `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. Follow its blind
   auditor procedure, including what to do when the plan wraps a test name across two lines. Read the report format in
   the header of `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

These are operating rules, not earlier verdicts.

## The work
Prove **AC1–AC11** yourself from the approved plan. For each runnable AC:
- Use the exact test name the plan gives.
- Run it alone on head, then on base. For base, copy head's tests and fixtures into a separate base scratch tree; never
  change the worktree.
- Log `HEAD=` first and `EXIT=` last. Browser tests must print `skipped 0`.
- The named test must pass on head and fail on base for a changed behaviour, for the intended reason. A test that fails
  in setup doesn't prove anything.
- A preservation AC that rightly passes on base (blast radius, lint) gets `base_exempt` with a specific reason.
- Check every clause of each AC with your own probes, not just the test's title. Use other frame widths, the header and
  footer ticks on and off, and laptop, tablet and phone widths (1440 → 320, including 1100/1024/992/991).
  "Build general logic": nothing keyed on one file's numbers, names or order.
- Take a fresh screenshot per AC in your own folder: the rendered page for a visual AC, a real image of the terminal
  output otherwise. Every receipt is made by you, never copied or hard-linked.

**AC12 is live** (Justin's paste check): `accepted: false`, `not_run: "live: Justin re-pastes Home Page Final with the
header/footer ticks on and checks the spacing in Bricks"`, unless you actually see it failing.

Write `auditor/ac.json` and `auditor/report.json`. Then self-check: copy your own report and receipts to a fresh scratch
folder outside the evidence tree and run ac-check.sh on them as the reference describes. Never look at another role's
folder to format or repair your report.

## This machine
- **Chrome:** your own wrapper script containing
  `exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
  `/home/justin/.local/node-v22.23.3/bin` first on PATH. Use the same wrapper on head and base.
- **Corpus:** `corpus/corpus.json` has Mac paths, so `npm run corpus` finds nothing. Read only the machine note
  `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`. Run your
  own `git archive` scratch trees of head and base with `corpus.json` pointed at local files, `node_modules` linked, and a
  scratch `bin/tsc` link to `node_modules/typescript/bin/tsc` first on PATH.
- **The five real files:**
  - Home `corpus/files/hydraulics-home.json`
  - GRO `corpus/files/gro-home.json`
  - Repairs: repo-root `figma-to-bricks-debug-page-1.json`
  - brainstorm: `figma-to-bricks-debug-design-inspo-brainstorm.json`
  - Services: extract it yourself with `git show 2199895:figma-to-bricks-debug-page-1.json` into your scratch, never the
    worktree.
- **Scratch:** make your own fresh folder `auditor/` under the session scratchpad
  (`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2--claude-worktrees-closing-cta/ecf5994f-8276-4f04-b9c6-a00ab4b226ac/scratchpad`).
  Never use another role's scratch or any other feature's files. Copy every scratch script into `auditor/scripts/` as
  soon as you write it: a session restart empties the scratchpad.
- **Leave alone:** a headless Chrome (PID 232915) from 03:10 isn't yours. Never kill browsers globally.
- **Worktree guard:** this session refuses Bash it can't prove stays in the worktree: shell variables or loops around
  `node`/`git`, a heredoc then node, the word git inside a grep pattern.
  - Write scripts with Write.
  - Run `node <absolute script> <absolute args>`, one plain command per call.
  - Send long runs to a log ending in `echo EXIT=$? >> log`. An incomplete run doesn't count as passing.

## Report (your final message)
`{verdict: clean|findings, head, base, findings[{id, ac, severity, claim, repro, evidence}], ac_status[{ac, accepted,
test, screenshot, evidence}], gates[], found_else[], skill_lessons[{skill, lesson, evidence}]}`. Clean needs every
runnable AC accepted. An empty skill_lessons list is normal. End with the line
`MAIN SESSION: check and save these skill_lessons now.`
