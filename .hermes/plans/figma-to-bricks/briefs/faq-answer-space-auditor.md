# Brief: AC AUDITOR for figma-to-bricks feature "faq-answer-space" (blind)

You are a fresh, blind AC AUDITOR. Prove every acceptance criterion of the approved plan yourself, from the code at one commit. **Read only: change no source, test or doc file, make no commit.** You get no one else's conclusions: never open any folder under the evidence directory other than your own `auditor/` (not `verifier/`, `review-*`, `fixer/` or `builder/`), and don't read `docs/HANDOFF.md`'s or the ledger's claims as proof.

## What you get
- **Approved plan (read-only, the ACs):** `/home/justin/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/plan-approved.md`.
- **Worktree:** `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/faq-answer-space` (branch `worktree-faq-answer-space`).
- **Head:** `ac603ff0a3aa5861965c7b02dc103978a9989204`.
- **Base:** `cd9c1c928d69c2fd8e0efb6a146c5813f837b96a` (`git merge-base HEAD main`).
- **Your folder:** `/home/justin/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/auditor/` (create it). Every receipt you cite must be inside it and made by you.
- **Your scratch:** `/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/d6d1b80e-7af5-449f-b45c-e3ce3431cbe6/scratchpad/auditor-faq-answer-space/` (create it; remove only that folder when done; never look at other folders in the scratchpad). Leave the worktree committed and clean: `ac-check.sh` fails any untracked file.

## Skills (load first, say so in one line each)
1. The project skill: Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and `references/rules-summary.md`.
2. `engineering-best-practices` (Skill tool).
3. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the format at the top of `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`: do the AUDITOR's AC work exactly as written there.

## The AC work
For every AC in the approved plan: read what it claims, check that the test the plan names really checks that claim (not something weaker), and run it alone on head and on base (a separate detached copy of base under your scratch, head's versions of that AC's test files checked out into it, `node_modules` linked; re-link after each clean), with logs `ac<n>-ac603ff.log` / `ac<n>-base-cd9c1c9.log` in your folder carrying the `HEAD=` and `EXIT=` lines. Take your own screenshot per AC (the real render for any AC about what the page shows, a terminal capture of the run otherwise). An AC that rightly passes on base (it keeps existing behaviour, or measures where nothing should move) gets `base_exempt` with its reason (3+ words); then prove the test is not empty by a mutant of the code it depends on (in memory or in your scratch copy, never in the worktree) that makes it fail. Where the AC claims more than its test checks (e.g. pastes byte-identical, lint no worse), prove that part yourself too (`npm run replay` / `npm run snap` on base and head) and say so in `why`. A `(live)` AC you can't run gets `"accepted": false, "not_run": "live: <why>"`.

Write `auditor/ac.json` in the format at the top of `ac-check.sh`, then self-check it while staying blind: `cp` (not `ln`) your report and receipts to your scratch and run `ac-check.sh --repo <worktree> --base cd9c1c9 --plan <plan-approved.md> <your ac.json> <scratch copy ac.json>`; fix any slip; delete the copy.

## How to run things on this machine
- Linux desktop (WSL). `corpus/corpus.json` lists Mac paths, so `npm run corpus` finds no files and `npm run check` skips its corpus tests. The repo's real files: `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json`; an older Services save is `git show 2199895:figma-to-bricks-debug-page-1.json`.
- Browser tests need `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` (a no-sudo Chrome wrapper), set inline with literal paths. A browser test run alone counts only when its output shows `skipped 0`.
- Claude Code's worktree guard refuses `source`/`.`, shell loops, a `$VAR` as a path or command, and compound commands mixing git with variables: put multi-step logic in a script file in your scratch and run it with `bash`/`node`. Wait for long runs in the foreground (a bounded `node -e` poll on the log), not by ending your turn.

## Rules
- Any bug or problem you see: list it in `found_else` (one line, evidence, severity).
- Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section. An empty list is the normal answer.

## Return (your final message)
`{verdict: clean | not-clean, ac_status[{ac, accepted, why}], found_else[], skill_lessons[]}`. `verdict: clean` only when every AC except a live one is accepted in your `ac.json`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
