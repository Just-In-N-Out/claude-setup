# Brief: PLANNER for figma-to-bricks feature "closing-cta" (Full pipeline)

You are the PLANNER for one feature of the Figma → Bricks plugin. Write a plan Justin will approve; don't build anything.

## Where
- Worktree (your copy, branch `worktree-closing-cta`, made from local `main` at 5e2f98b, build 2026-10-28.3): `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta`. Work only there. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`.
- Write the plan to `docs/plans/2026-10-28-closing-cta.md` in the worktree (this repo keeps its plans in git). Don't commit it: the builder does. Make no code change.
- Evidence folder for later roles: `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/`.
- The teammate's screenshot: `~/.hermes/plans/figma-to-bricks/shots/closing-cta-report.png` (open it with Read).

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the PLANNER role (Full: its whole Step 1 context load). Read its `references/rules-summary.md` first; then only the sections of the worktree's `CLAUDE.md` you need (find sections with grep, read with offset/limit; never the whole file). Always: "Status", "Build general logic", "Architecture rules", "Decisions the user made" → "Layout" and "Website rules", and the site-parts lines (header/footer ticks).
2. `engineering-best-practices` (Skill tool).
3. `implementation-planning` (Skill tool).
4. `systematic-debugging` (Skill tool): part 1 below is a bug; prove its root cause with file:line evidence before planning the fix.

## The ask (rewritten)
On the All Type Hydraulics homepage (live: https://darksalmon-badger-335429.hostingersite.com/, read it with `?f2b=<random>` to get past LiteSpeed; never log in or change anything), a teammate looked at the last section before the site's footer ("ALL MAJOR BRANDS" / "WE REPAIR & RE-MANUFACTURE ALL MAJOR BRANDS." / buttons "CALL US NOW ↗" and "EMERGENCY CALL 24/7") and asked: "Can we remove the line on the top, reduce the spacing on the top, and add more spacing below the buttons in this section?"

Justin then said: "these are mostly general changes, right? She talks about the buttons and the divider, so make them general changes for any other website."

### What the main session found (verify; don't trust blindly)
Source: `corpus/files/hydraulics-home.json` (the saved "Home Page Final", 1728 wide). The root frame has no auto layout; full-width section frames are stacked:
- "FAQ" frame: y 4135 → 4917, vertical auto layout, padding 120/120, **bottom stroke only** (1px, white at 10%). Every full-width section on this page (Hero data, Marquee, Info cards, Services bento, Gallery, FAQ) has the same bottom stroke: it is the design's divider between sections.
- "Brands / closing" frame: y 5081 → 5418 (x 64, width 1600: not full width), vertical auto layout, padding 0, **no fills, no strokes**. Children: `div.idx` (the eyebrow "ALL MAJOR BRANDS"), `h2`, `p.sub`, `div.row` (horizontal, gap 14, padding-top 17, two buttons).
- So Figma draws: FAQ's own 120px bottom space, its 1px line, a **164px free gap**, the closing section, then a **126px free gap** before the footer frame ("Frame", y 5544, 966 tall, padding-top 80).

Converted with the panel's ticks as on Justin's site (`snapshot.site = JSON.stringify({header:true, footer:true})`, `convert(snapshot, {inlinePictures:false})`):
- FAQ section `sygfun`: `_border` bottom 1px `rgba(255,255,255,0.1)`; `_padding` top/bottom `clamp(84px, calc(35.48px + 4.891vw), 120px)`, tablet_portrait 84, mobile_portrait 64.
- Brands section `ingsrz`: `_padding.top` `clamp(96px, calc(4.35px + 9.239vw), 164px)` (tablet 96, phone 64), **`_padding.bottom` "0"**.
- With `{header:true, footer:false}` the same section gets `_padding.bottom` `clamp(88px, calc(36.78px + 5.163vw), 126px)`. **So leaving Figma's footer out drops the space drawn above it**: the last section's buttons end flush against the site's footer. Look at `src/core/understand/leave-out.ts` (`designOf`: builds every section, leaves the parts out, then spaces the rest) and wherever a free gap between sections becomes padding.

### Justin's decisions (asked 2026-10-28)
1. **Bug fix, every design:** the space a design draws above a footer the plugin leaves out is kept (it must not vanish with the footer). Same for a header left out, if the same loss happens there: check and say.
2. **A new general rule, scope "Closing CTA only"** (Justin chose it over "every CTA band" and "every section"). It applies to the **closing call-to-action section**: the last content section before the footer, whose content is just a heading (optionally an eyebrow and a line of text) with buttons, and **no background of its own** (no fill, picture, stroke, shadow). For that section only:
   - **no divider line above it**: the line the section before it draws at its bottom (or the closing section's own top line) is not drawn;
   - **normal section space above it**: the empty space between the previous section's words and the closing section's first words is the page's normal section space, not doubled by the free gap. On Home: the FAQ keeps its own 120px bottom space and the closing section adds 0 on top, so 120px on computers (84 tablets, 64 phones), as the FAQ steps;
   - **normal section space under its buttons**: the page's section space below it (on Home 120 / 84 / 64, like the FAQ's bottom).
   Every other divider and gap in every design stays as drawn.
3. Justin chose "Page rhythm" for the numbers: 120 above and 120 below on computers, stepping down like every other section.

**Reference output:** the main session hand-edited the Home paste to this result (only those two elements changed): `~/.hermes/plans/figma-to-bricks/evidence/home-paste-media/brands-spacing/All-Type-Home-Brands-Spacing.json` (receipt and the edit script beside it). The FAQ section lost `_border`; Brands got `_padding` top "0" (tablet 0, phone 0) and bottom the FAQ's own values (clamp … 120px, tablet 84, phone 64). The plugin's paste after this feature should look the same at every width (exact keys may differ; say where and why).

### Must be general (CLAUDE.md "Build general logic, never one-file fixes")
Recognise the closing CTA from structure and properties only (its place as the last section before the footer, the footer recognition `understand/site-footer.ts`, CTA/Button recognition `understand/widgets.ts` `markCtas`, headings, paint), never from this file's names ("Brands / closing", `div.idx`), words, colours or pixel values. Think about the variations: a closing CTA that is full width or not; with or without a free gap above/below; a design drawn with auto layout (no free gaps); a closing section with a background or a photo (not a match: keeps its line and space); a closing form or card row (not a match); the footer kept (tick off) vs left out vs no footer drawn at all; the previous section having its own bottom line vs the closing section having a top line; a drawn phone design beside the desktop one; GRO-style free-drawn pages.

### Things the plan must settle
- **Where each part is decided** without breaking "no stage edits an earlier stage's output": which stage marks the closing CTA, which drops the divider (the line is a stroke on the *previous* section: say how that stays legal), which sets the space, and which adapt rule (only `src/core/adapt/rules/` writes breakpoint styles) steps it down. Rules read sizes from `PageFacts`.
- **What "the page's normal section space" is**, read from the page (not a constant): e.g. the section padding most sections share, or the space ramp's section step. Put it as a question with ⭐ if there's a real choice.
- **Whether the closing CTA rule applies when the footer is kept** (tick off) and when no footer is drawn (the site's footer follows anyway). Question with ⭐.
- **The bug fix's exact behaviour** (the drawn gap above a left-out footer becomes the last section's bottom space, stepped like any section space) and how it combines with rule 2 for a closing CTA.
- Effects on the other files the machine has (below): list every element whose paste changes.

## Checks on this machine (important)
This is the Linux desktop (WSL). `corpus/corpus.json` lists Mac paths, so `npm run corpus` finds no files here and measures nothing, and `npm run check` silently skips corpus tests. Plan checks on the files that exist, via `npm run replay` / `npm run snap` directly, before vs after: `corpus/files/hydraulics-home.json` (Home), `corpus/files/gro-home.json`, the repo-root `figma-to-bricks-debug-page-1.json` (Repairs page) and `figma-to-bricks-debug-design-inspo-brainstorm.json`, each with the ticks off and with header+footer ticked. For un-skipping corpus tests, a scratch `git archive` tree with only `corpus/corpus.json` re-pointed to local files (never edit corpus.json in the worktree). Browser tests need `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`; a browser test run counts only when its output says `skipped 0`, and the full suite has known font-environment failures: compare by test name against base 5e2f98b. Don't plan a fix of corpus.json in this feature: put it in `found_else`.

## ACs
The request has no ACs: write your own, marked **proposed**, numbered AC1, AC2…, each with one named test. Cover at least: the space above a left-out footer is kept (generic fixture, ticks on vs off); a closing CTA loses the divider above it; its top space is the page's section space (not doubled) and its bottom space the page's section space, at every breakpoint; a closing section with its own background, a form, a card row, or a non-last CTA band keeps today's output; designs without a closing CTA give byte-identical pastes (name which corpus pastes must stay byte-identical, ticks on and off); Home's paste matches the reference hand-edit's look at 1728, 1440, 990, 768 and 390; lint no worse on every available file. Tag `(live)` right after the id for any AC only Justin can check (e.g. `- AC9 (proposed) (live): after re-pasting Home, no line above "ALL MAJOR BRANDS", 120px above it and 120px under its buttons before the site's footer`).

## Rules
- You can't ask Justin anything. Put questions at the top of the plan, each with 2–4 lettered options under about 60 characters, the recommended one marked ⭐, and write the plan as if the ⭐ options were chosen (his standing auto-go starts the builder right after the plan message).
- End the plan with a **Docs & records** task naming every file the build and finish will update (plan, ledger, HANDOFF, BUILD at merge, main folder CLAUDE.md "Status" line + a new "Decisions the user made" line for the closing-CTA rule).
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report. An empty list is the normal answer.
- Plain words: Justin reads short messages.

## Return (your final message)
JSON-like report: `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], acs[], live_acs[], risks[], touches[], overlaps, found_else[], skill_lessons[]}` (only `plan_path` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
Teammate (screenshot of the closing section): "Can we remove the line on the top, reduce the spacing on the top, and add more spacing below the buttons in this section?"
Justin: "Lets do this." Chose "Page rhythm (120 above, 120 under, stepping down)" and "Paste now + plugin fix". Then: "these are mostly general changes, right? She talks about the buttons and the divider, so make them general changes for any other website." Chose "Closing CTA only" and "Full" pipeline.
