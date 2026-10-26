# Brief: PLANNER for figma-to-bricks feature "faq-answer-space" (Mini pipeline)

You are the PLANNER for one feature of the Figma → Bricks plugin. Write a plan Justin will approve; don't build anything.

## Where
- Worktree (your copy, branch `worktree-faq-answer-space`, made from local `main` at cd9c1c9): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/faq-answer-space`. Work only there. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`.
- Write the plan to `docs/plans/2026-10-26-faq-answer-space.md` in the worktree (this repo keeps its plans in git). Don't commit it: the builder does. Make no code change.
- Evidence folder for later roles: `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/`.
- Justin's screenshot: `~/.hermes/plans/figma-to-bricks/shots/faq-answer-space-report.png` (open it with Read).

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the PLANNER role. Read its `references/rules-summary.md` first; then only the sections of the worktree's `CLAUDE.md` you need (always "Start here" and "Decisions the user made"; find sections with grep, read with offset/limit; never the whole file).
2. `engineering-best-practices` (Skill tool).
3. `implementation-planning` (Skill tool).
4. `systematic-debugging` (Skill tool): this is a bug report; prove the root cause with file:line evidence before planning the fix.

**Mini mode:** load the project skill and only the code and docs sections this touches; skip the full Step 1 context load; finish within about 15 steps. Keep the plan short (playback, root cause with file:line evidence, the fix, numbered ACs with one named test each, touched files, Docs & records task, questions at the top). If this turns out bigger or riskier than a Mini job (more than ~3 source files, a design decision, a change to how every accordion is built), say so in `summary` and recommend Full.

## The ask (rewritten)
Justin's screenshot shows an FAQ on his live site (dark card, Bricks accordion). The first item, "HOW DOES THE CORE EXCHANGE PROGRAM WORK?", is open (its round yellow icon shows ×). Its answer is a paragraph of light grey text; the answer's last line, "your machine is down for hours, not weeks." (underlined in purple in the screenshot to point at it), sits almost right on the thin divider line that separates it from the next question ("WHAT BRANDS OF HYDRAULIC CYLINDERS DO YOU REPAIR?", closed, + icon). There is hardly any space between the end of the answer and the divider. His request, written over the screenshot: "Can we add more space under the FAQ when it's open? Under the answer."

So: when an FAQ item is open, there should be clear space between the end of its answer and the divider / next question. It must be a general fix for every FAQ the plugin builds (any design, any designer), not this one page.

To find:
- Which page this is on the live site (https://darksalmon-badger-335429.hostingersite.com/, read it with `?f2b=<random>` to get past LiteSpeed; never log in or change anything). Likely Core Exchanges, Home or Services. Read the open item's real CSS: the answer's padding/margin, the item's padding, where the divider is drawn, and what Bricks' own accordion CSS adds or removes.
- What Figma draws: is there space under the answer in the design's open state (variant / open item), and does the plugin drop it? Check the repo's debug files and corpus files that hold an FAQ (`corpus/files/hydraulics-home.json`, the repo-root `figma-to-bricks-debug-page-1.json` (Repairs page), git history saves such as `git show 2199895:figma-to-bricks-debug-page-1.json` (Services page), `corpus/files/gro-home.json`). Name which file you measured.
- The root cause, with file:line evidence: e.g. the answer's bottom padding lost in `understand/accordion.ts` / the style or emit of `accordion-nested`, Bricks' accordion content CSS, `space.ramp` trimming it, or the design itself drawing no space (then it is a rule change: say so plainly, and what the general rule would be, e.g. an open answer's bottom space equals the drawn space between the question and the answer).
- Whether phones and tablets need the same space (only `src/core/adapt/rules/` writes breakpoint styles).

## Checks on this machine (important)
This is the Linux desktop (WSL). `corpus/corpus.json` lists Mac paths (`/Users/justin/...`), so `npm run corpus` finds **no** files here and measures nothing. v1's three corpus files (design, final-design, page-1) aren't on this machine. Plan the corpus checks on the files that exist: `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, the repo-root `figma-to-bricks-debug-page-1.json` and `figma-to-bricks-debug-design-inspo-brainstorm.json`, via `npm run replay` / `npm run snap` directly (before vs after: which elements change, lint no worse at every width). Don't plan a fix of corpus.json in this feature.

## Another feature in flight
`label-floor` (worktree `.claude/worktrees/label-floor`, planning: a minimum text size for pill labels and "Learn more" links; likely `style/typography.ts`, `normalise/label-box.ts`, `adapt/rules/label.ts`, `adapt/layout.ts`). Say in `overlaps` whether this fix touches the same files, so they can be built side by side or one after the other.

## ACs
The request has no ACs: write your own, marked **proposed**, each with one named test (a `node --test` test whose name starts with its AC id, e.g. `AC1 open FAQ answer keeps space under it`, so a verifier can run it alone with `--test-name-pattern`). Cover at least: an open FAQ item shows clear space under its answer before the divider / next item (in the payload and in the browser renderer at the design width); the same at tablet and phone widths; closed items and the question rows unchanged; FAQs on the other corpus files no worse (lint no worse at every width); every other part of the pastes byte-identical. Tag `(live)` right after the id for any AC only Justin can check, e.g. `- AC5 (proposed) (live): after re-pasting the page, the open answer has space under it on the live site`.

## Rules
- You can't ask Justin anything. Put questions at the top of the plan, each with 2–4 lettered options under about 60 characters, the recommended one marked ⭐, and write the plan as if the ⭐ options were chosen (his standing auto-go for this repo starts the builder right after the plan message). Ask only what is truly his to decide (e.g. how much space if Figma draws none); the rest you decide as rulings.
- End the plan with a **Docs & records** task naming every file the build and finish will update (plan, ledger, HANDOFF, BUILD at merge, main folder CLAUDE.md "Start here").
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report. An empty list is the normal answer: list only what a future task needs that the skill doesn't already say.
- Plain words: Justin reads short messages.

## Return (your final message)
JSON-like report: `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` (only `plan_path` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
Screenshot of the open FAQ item, with the answer's last line underlined, and the text: "Can we add more space under the FAQ when it's open? Under the answer."
Justin: "fix this ok?" Pipeline: "Mini (Recommended)".
