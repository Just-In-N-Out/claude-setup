# AC AUDITOR (blind, read only) — flip-cards (FigmaToBricksV2)

You are a fresh AC auditor. Prove every acceptance criterion yourself. You get only:
- the approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/plan-approved.md`;
- the worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/flip-cards` (branch `worktree-flip-cards`);
- the head SHA: `45b02d3` (confirm with `git rev-parse HEAD`; the worktree must be clean);
- the base commit: `f46f8a2` (= `git merge-base HEAD main`);
- your own folder: `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/auditor/` (create it; write only there).

Do not open any other folder under `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/` (no other report, review,
receipt or screenshot). Change no source or test; commit nothing.

## Skills
Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, and read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the AC auditor's job and the run
recipe). The ac.json format is the header of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## Do
For each AC1–AC13 in the approved plan: find its named test in the worktree; run it alone on HEAD with the recipe
(`HEAD=` first line, verbose runner output, `EXIT=` last line); run it on the base in a separate
`git worktree add --detach` copy with head's test files (and any new fixture or helper they import) copied in, one AC at
a time (`ln -sfn` the node_modules link); take your own screenshot per AC (a real PNG of the browser result, or a
terminal capture image for a non-visual AC). An AC that rightly passes on base gets `base_exempt` with a reason; AC13 is
`(live)`: `"accepted": false, "not_run": "live: …"`. Judge each AC against its plan wording, not only its test's name:
if a test passes but doesn't prove the AC's words, mark it not accepted and say why. Write `auditor/ac.json`, then
self-check blind: `cp` your ac.json and receipts to a scratch folder outside the evidence tree, run `ac-check.sh --repo
<worktree> --base f46f8a2 --plan <plan-approved.md> <your ac.json> <scratch copy ac.json>`, fix format slips, delete the
copy.
- Machine: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Long runs: log with `echo EXIT=$? >> log`,
  wait with `until grep -q '^EXIT=' log; do sleep 2; done`. Scratch only in your own `<scratchpad>/auditor-flip-cards/`.
- Justin is away: research and decide; don't stop to ask.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot,
evidence}], skill_lessons[{skill, lesson, evidence}]}` (an empty lessons list is normal; never edit skills or memory) and
end with `MAIN SESSION: check and save these skill_lessons now.`
