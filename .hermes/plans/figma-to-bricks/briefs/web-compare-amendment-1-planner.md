# Planner brief: web-compare, plan amendment 1 (rethink how content is matched)

**Role:** planner (fresh Opus 5.5, xhigh). You write a plan amendment; you build nothing.

**Skills:** load `engineering-best-practices` and `implementation-planning` with the Skill tool; read the project skill
with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its
`references/live-site-reading.md` and `references/testing-pitfalls.md` (the page-compare oracle line records every
round's lesson).

## Why

`web-compare` (J0 of the website importer) is the compare tool every later importer job is judged by. Its text
matching (`test/web/lib/align.ts`, `measure-content.ts`) pairs blocks between two differently built pages. Review rounds
3, 4 and 5 each found a new hole in that pairing, and each fix opened a nearby case:
- R3: mid-line inline-blocks;
- R4: block-level boxes inside a box;
- R5: a whole column replacing the exact pairs inside it, so a button 40px off goes unreported, plus lines beside a list or button row.

Asked how to handle it, **Justin chose "Rethink the matching"** (2026-10-30): re-plan how the tool matches content
between two pages so the cycle ends. For example, compare each word's own position directly, the way every reviewer's
ground truth already checks it (every word's Range rect within 1px on both pages). That is a direction, not a ruling:
you decide the design, with evidence.

## Read first

- The approved plan (the contract, AC1–AC11): `~/.hermes/plans/figma-to-bricks/evidence/web-compare/plan-approved.md`.
- Every review and answer: `evidence/web-compare/review-1/` … `review-5/` (`review.json`, `referee.txt`,
  `justin.json`), `fixer-1/` … `fixer-4/answers.md`, the rulings R9–R22 in the ledger, the HANDOFF section.
- **Every probe set the reviewers and fixers built.** This is the regression corpus your design must pass, both
  directions (same look = no finding; each real change = the right finding at the right element), judged against the
  word-by-word ground truth:
  - round 1: `review-1/logs/`;
  - round 2: `review-2/probes/` and `logs/`;
  - round 3 (J1–J9): `review-3/probes/`;
  - round 4 (K1–K8): `review-4/probes/`;
  - round 5 (C1–C5, D1–D5): `review-5/probes/`;
  - the fixers' F1–F11 and their truth scripts: `fixer-3/`, `fixer-4/`.
- The code as it is now: check it out (below), especially `test/web/lib/align.ts`, `measure-content.ts`,
  `measure-layout.ts`, `diff.ts`, `noise`, and how findings feed the report and noise file.

## Where you work

Your agent worktree starts at `main` (other sessions moved it). Put your copy on the story's head without rebasing:
`git checkout --detach c69ef1896fd4140c313e50b3cfdde82fda83d528` then `git switch -c web-compare-rethink`. Write the
amendment into `docs/plans/2026-10-29-web-compare.md` as a section "Amendment 1: matching" (keep everything else) and
commit it on that branch (plain `git commit -m`, no author override, no AI lines, no CLAUDE.md staged). Don't push,
don't bump `BUILD`, don't edit CLAUDE.md, never bare `git stash`. Probes and spikes go in
`~/.hermes/plans/figma-to-bricks/evidence/web-compare/amendment-1/planner/`. A small spike that proves the design on
the hardest probes is welcome (in evidence, not committed).

## The amendment must have

- Playback in plain words, then questions with options and a ⭐ answer at the top. Justin is around: the builder
  takes the ⭐ answers unless he says stop.
- The design: what is matched (words, blocks, pictures), how pairs are formed between differently built pages, what
  each finding is reported against (the element that changed, once), and how the noise file and the timing table keep
  working. Name what it replaces in today's code and what it keeps.
- **Numbered acceptance criteria** continuing the plan's (AC12, AC13…), each with one named test, marked **proposed**.
  At least:
  - every earlier probe passes against the ground truth, both directions;
  - AC1–AC11 still hold;
  - no false finding on the live plugin-made home at the 16 widths (noise file aside);
  - a cost bound per compare.
- Tasks a fresh builder can do test-first, owned files, risks, and what's deliberately left as a named limit.
- General logic only; `src/` stays untouched.
- **bdryswi.com serves a bot-check page to automated Chrome: don't load it.** Live reads only of the plugin-made Bricks
  site `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and `https://www.letsgro.ai/`, GET
  only.
- **This machine (WSL):** `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`;
  Chrome wrapper `~/.hermes/plans/figma-to-bricks/evidence/web-compare/planner/scripts/chrome-cpu.sh` as `CHROME_PATH`.

## Report back

Branch, commit SHA, the design in five lines, the questions with ⭐, the new ACs one line each, then
`skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check proposal;
empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
