# Brief: PLANNER for figma-to-bricks feature "label-floor" (Mini pipeline)

You are the PLANNER for one feature of the Figma → Bricks plugin. Write a plan Justin will approve; don't build anything.

## Where
- Worktree (your copy, branch `worktree-label-floor`, made from local `main` at cd9c1c9): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor`. Work only there. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`.
- Write the plan to `docs/plans/2026-10-26-label-floor.md` in the worktree (this repo keeps its plans in git). Don't commit it: the builder does. Make no code change.
- Evidence folder for later roles: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/`.

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the PLANNER role. Read its `references/rules-summary.md` first; then only the sections of the worktree's `CLAUDE.md` you need (always "Start here" and "Decisions the user made" → "Website rules"; find sections with grep, read with offset/limit; never the whole file).
2. `engineering-best-practices` (Skill tool).
3. `implementation-planning` (Skill tool).

**Mini mode:** load the project skill and only the code and docs sections this touches; skip the full Step 1 context load. Keep the plan short (playback, cause, the fix, numbered ACs with one named test each, touched files, Docs & records task, questions at the top). If this turns out bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## The ask (rewritten)
On the All Type Hydraulics homepage (live: https://darksalmon-badger-335429.hostingersite.com/, read it with `?f2b=<random>` to get past LiteSpeed; never log in or change anything), each service card has a row of tags in outlined pills ("SEALS", "HONING", "10,000 PSI") and a "LEARN MORE ↗" link under them. A teammate, Sai Varsha, asked: "What's the size of these fonts? It just looks too tiny. Can we make them a little bigger please?"

What the main session found (read from the live page, 2026-10-26):
- The tags are Text elements with class `saira-condensed-medium-upper-11` (`font-size: 11px; font-weight: 500; line-height: 1.545; letter-spacing: 0.04em; uppercase`) inside a `brxe-div` pill.
- "Learn More" is a Text with class `saira-condensed-semibold-upper-13` (`13px; 600; line-height 1.55; 0.04em; uppercase`) beside a 45×45 arrow `<img>`, inside a `brxe-div` in a `brxe-block`.
- These are Figma's own sizes: the plugin copied the design exactly. So this is a change of rule, not a bug.

**Justin's decision:** the plugin enforces a minimum text size, but **only** for:
1. **words inside a pill** (a rounded, pill-shaped box hugging a short label: tags, badges, chips, pill buttons): at least **13px**;
2. **"Learn more"-style links** (short action words that link on, often with an arrow: "Learn more", "Read more", "View all", "Explore…"): at least **15px**.

Text the design already draws at or above the minimum stays as drawn. Every other text keeps Figma's size, as today. This narrows the standing "Website rules" decision ("the design breaks a rule (tiny text): never recolour or resize") for these two kinds only: record that change in the plan and in the Docs & records task (CLAUDE.md "Decisions the user made").

It must be general (every design, any designer): recognise pills and action links from structure and properties (shape, corner radius vs height, a box hugging one short label, link/arrow detection the plugin already has), never from this file's names, words, sizes or colours. Existing recognisers worth reading first: `normalise/label-box.ts` (button shapes), `understand/widgets.ts` (Buttons, `markCtas`), `normalise/page-words.ts` + `normalise/page-links.ts` + `normalise/arrow-shape.ts` ("Learn more", arrows), `style/typography.ts` (font classes, named by family/weight/case/size), `style/tracking.ts`, `adapt/least.ts` + `adapt/rules/label.ts` (one-line button labels), the type scale in `PageFacts`, and whatever adapt rule shrinks type on phones (the minimum must hold at every breakpoint, phones included).

Things the plan must settle:
- **Where it is decided** without breaking the pipeline rule "no stage edits an earlier stage's output": which stage records "this text is a pill label / an action link", and which sets the size.
- **The typography class:** today the class name carries the size (`…-upper-11`). After the change, what class does a pill label get, so the name never lies and pastes stay deterministic? Also the live site already holds `saira-condensed-medium-upper-11` at 11px: say what Bricks does on re-paste when a pasted class has the same name but other settings (read `reference/bricks/README.md` and CLAUDE.md "No 'Import classes' dialog on later pastes (19.12)"), and pick the option that needs no clicks from Justin and doesn't change other elements using the 11px class.
- **Layout effects:** a bigger label makes its pill wider (padding stays as drawn); a pill with a fixed width from Figma must grow or the words overflow; rows of pills may wrap; the layout plan (`adapt/layout.ts`) and one-line rules must count the new size; letter-spacing's trailing margin (`style/tracking.ts`); line height keeps its ratio.
- Breakpoints: does the floor need a rule in `src/core/adapt/rules/` (only rules write breakpoint styles), or does setting the base size suffice because nothing scales these texts down?

## Checks on this machine (important)
This is the Linux desktop (WSL). `corpus/corpus.json` lists Mac paths (`/Users/justin/...`), so `npm run corpus` finds **no** files here and measures nothing. v1's three corpus files (design, final-design, page-1) aren't on this machine. Plan the corpus checks on the files that exist: `corpus/files/hydraulics-home.json` (this homepage, an older save; the cards with tags and Learn More should be in it: confirm), `corpus/files/gro-home.json`, the repo-root `figma-to-bricks-debug-page-1.json` (Repairs page) and `figma-to-bricks-debug-design-inspo-brainstorm.json`, via `npm run replay` / `npm run snap` directly (before vs after: which elements' sizes change, lint no worse at every width). Don't plan a fix of corpus.json in this feature: put it in `found_else`.

## ACs
The request has no ACs: write your own, marked **proposed**, each with one named test. Cover at least: pill labels under 13px go to 13px at every width; action links under 15px go to 15px; text at or above stays; non-pill, non-link small text (e.g. a © line, captions) unchanged; pills grow and nothing overflows or clips (lint no worse) on the available corpus files; pastes otherwise byte-identical; the re-paste on the live site needs no class dialog clicks (or the plan says exactly what Justin will see). Tag `(live)` right after the id for any AC only Justin can check (e.g. `- AC7 (proposed) (live): after re-pasting the homepage, the tags read 13px and Learn More 15px on the live page`).

## Rules
- You can't ask Justin anything. Put questions at the top of the plan, each with 2–4 lettered options under about 60 characters, the recommended one marked ⭐, and write the plan as if the ⭐ options were chosen (his standing auto-go starts the builder right after the plan message).
- End the plan with a **Docs & records** task naming every file the build and finish will update (plan, ledger, HANDOFF, BUILD at merge, main folder CLAUDE.md "Start here" + the Website-rules decision line).
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report. An empty list is the normal answer.
- Plain words: Justin reads short messages.

## Return (your final message)
JSON-like report: `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` (only `plan_path` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
Sai Varsha (screenshot of a homepage card: pills "SEALS", "HONING", "10,000 PSI", then "LEARN MORE ↗"): "What's the size of these fonts? It just looks too tiny 😅. Can we make them a little bigger please?"
Justin: "Well i want something like this but when it comes to learn more or if they are in that pill form." Chosen: "Pills 13px, links 15px". Pipeline: "lets do mini".
