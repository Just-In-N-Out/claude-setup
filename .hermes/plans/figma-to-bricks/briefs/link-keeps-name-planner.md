# Role: planner (Mini): link-keeps-name — a folded wrapper's aria-label never renames a link that has its own words

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site. Read-only on `~/Downloads` (Justin's scan: the read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Plain `git`, each command alone (no `git -C` the main folder from a worktree; no git piped into another command); scratch under `~/.cache/lkn-pl/`.

Load `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`. Read the repo's `CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`), above all the standard at the top of "Decisions the user made" and "A website paste keeps the site's accessibility names" (importer-parity). Mini pipeline (`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`).

## Base
Main **38a9ec1b** (Build 2026-11-15.7). Other jobs in flight change nearby importer code: fewer-kept-boxes (folds wrapper boxes; branch `fewer-kept-boxes-on-main7`), short-class-names, site-sticky-cards (`site-sticky-cards-on-main7`), clean-values (`clean-values-build`). Read fewer-kept-boxes' plan (`~/.hermes/plans/figma-to-bricks/evidence/fewer-kept-boxes/plan-approved.md`) and name every shared file and what this job assumes from it.

## What Justin decided (2026-11-16)
HANDOFF line ~917 (importer-parity auditor 4): "a folded wrapper's `aria-label` renames its link (the site reads the link 'Read more', the paste 'Wrapper name'): keep that?" Justin chose **"Link keeps its words"**: when the importer folds a wrapper box that carries its own `aria-label` (or `aria-labelledby`/`title` naming) into the link it holds, a link with its own accessible words (visible text, an img alt, its own aria-label) keeps them as its name; the wrapper's label goes onto the link only when the link has no name of its own (an icon-only link). WCAG 2.5.3 (label in name) is the reason.

## The plan must settle
1. Where the fold carries a wrapper's names onto its child today (the importer-parity names code: `src/web/read/code.ts` KEEPS/KEPT, the fold rules, `test/unit/site-names.test.ts`), and the general rule: what counts as "the link has a name of its own" (computed from what the paste holds, never a site string), for links, buttons and any other named element the fold reaches.
2. What happens to the wrapper's label when the link keeps its words (dropped, with one note line naming it; never a second hidden copy).
3. Numbered ACs (AC1…) with one test each, generic fixtures (never B-Dry strings), B-Dry's scan as a count check (how many links change name, offline), a pin that every other paste is byte for byte main's, and one `(live)` AC for Justin only if a live look adds something.
4. Questions at the top with ⭐ answers (standing auto-go: the ⭐ answers are taken).
Write `/home/justin/Documents/FigmaToBricksV2/docs/plans/2026-11-16-link-keeps-name.md` is not possible from here: write the plan to `/home/justin/.hermes/plans/figma-to-bricks/link-keeps-name.md` (the builder copies it into `docs/plans/`).

## Report (as text)
The plan path, the ACs one line each (mark proposed and `(live)`), the questions with ⭐ answers, the shared files, `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
