# Brief: PLANNER (revision) for figma-to-bricks feature "closing-cta" (Full pipeline): scope widened

You are the PLANNER. Justin widened the scope of an approved plan after its build started. Revise the plan; don't build anything.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/closing-cta` (branch `worktree-closing-cta`, base 5e2f98b). Work only there; never edit the main folder.
- The plan: `docs/plans/2026-10-28-closing-cta.md` in the worktree (committed by the builder). Revise it in place (keep the file name; update the title). Don't commit; the next builder does. Make no code change.
- The first approved copy (read only, for reference): `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/plan-approved.md`.
- Your probes go in `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/planner-revise/`. The first planner's probes are in `../planner/`.
- The teammate's screenshot: `~/.hermes/plans/figma-to-bricks/shots/closing-cta-report.png`.

## Build state when the scope changed
- Branch head `9f88233` (source last changed at `1ec8475`). Built, mutation-proved (8/8) and committed: Tasks 0–2 = **Part 1** (AC1–AC3, `understand/designs.ts` `keepBeside`/`besideLeft`, `SectionInfo.marginBottom`, the style.ts margin line, space.ramp stepping the bottom margin; tests `test/unit/understand-site-gaps.test.ts`; fixture `test/fixtures/closing-cta.ts` `closingPage`, `pairClosingPage`). `npm run check` green on 1ec8475 (unit 2382 pass, 60 skipped for Mac corpus paths).
- Task 3 (the closing-CTA recogniser) was in progress, **reverted, not committed**, kept in `~/.hermes/plans/figma-to-bricks/evidence/closing-cta/builder/task3-wip/` (`tracked.patch`, `closing.ts`, `lines.ts`, `understand-closing.test.ts`, 7/7 green). Reuse what still fits (e.g. `style/lines.ts` `unlined`, `IRNode.noLine`, the `widgets.ts` `pillMiddle` export) and say so.
- Base replays of the 5 files × 4 tick settings: `../builder/base/`. Before shots: `../builder/shots/before` (Home ticked) and `before-off`.
- Builder rulings (not yet confirmed): keepBeside notes carry the paired-design prefix; the header/footer gaps are measured only inside one selected frame.
- Builder findings: `ctaLike` alone takes a painted form field for a pill (use markCtas's whole predicate incl. `pillMiddle`); a section made only of a Figma Line gets a 1px border on all four sides (existing; relevant to the divider rule: decide it).
- Chrome on this desktop needed the CPU/CSS wrapper (`--disable-software-rasterizer`); the default profile stalled.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (PLANNER role; `references/rules-summary.md` first; only the worktree CLAUDE.md sections you need, via grep + offset/limit). Note its lines on section rhythm (frame padding + wrapper Container + inset card) and on blast radius.
2. `engineering-best-practices`, 3. `implementation-planning` (Skill tool).

## What changed (Justin, 2026-10-28)
After the plan's message ("only the last heading+buttons section before the footer gets: no line above, the page's section space above, the same under its buttons; every other line and gap stays as drawn") Justin asked "this also fixes the spacing … between pages, right?", was told the gaps between the other sections stay as drawn, and answered:

> "Do it for every section, like in the photo. Make sure the spacing is good, including the gap between sections. Also apply it to every call-to-action button, not just the closing one."

So the new Part 2 ("section rhythm", every design):
1. **Every section, like in the photo:** the photo's three changes (no divider line between sections, no doubled/oversized space above a section's words, enough space under its buttons) apply to every section, not just the closing one.
2. **Good spacing between sections:** the space between one section's words and the next section's words is the page's section space everywhere (one rhythm read from the page, not a constant), never doubled by a free gap stacked on padding, stepping down on tablets and phones as the space ramp does today.
3. **Every call to action:** any section or band that ends with call-to-action buttons (`markCtas`) gets the page's section space under its buttons; every heading + buttons band anywhere on the page gets it above and below (the closing one is just one case).

Part 1 (the space next to a left-out footer/header is kept) stays as approved.

## Things the revised plan must settle (questions with ⭐, plan written as if ⭐)
- **Divider lines:** which lines go. ⭐ = every full-width divider line on a section's top or bottom edge between two sections (the kind in the photo: Home's 1px faint lines under each section), and a line drawn as its own layer between sections; lines inside a section (FAQ item rules, card outlines, table rules, a box's full outline, a header bar's own bottom line if the header is kept) stay. Offer B = keep the lines, change only spacing.
- **What "the page's section space" is** when every section uses it (the first plan's Q1 A was "the section above's own space"; that no longer works for every pair). Read it from the page (e.g. the space most content sections share, frame padding + wrapper Container + inset card counted once per section); say what Home, Services, Repairs, GRO and brainstorm get.
- **Which sections keep their own spacing:** the hero (its drawn height and padding, e.g. Home's 150), sections with their own background/photo (their inner padding vs the gap outside them), full-bleed photo/map bands, marquees and strips, sections that touch on purpose (a band butting the next band, the hero data strip under the hero), the header spacer, drawn phone designs. Pick ⭐ answers that keep designs that look right today from getting worse.
- **Free-drawn pages (GRO, no auto layout):** overlaps, art hanging between sections, negative gaps: what the rule does there (⭐ likely: only gaps larger than the section space shrink; touching/overlapping sections untouched; name every GRO change).
- **Where it is decided** without breaking "no stage edits an earlier stage's output", and which adapt rule steps it (only `src/core/adapt/rules/` writes breakpoint styles; rules read `PageFacts`).
- How the already-built Part 1 combines with it.

## Blast radius (required)
This now changes most designs. For each of the five real files (Home `corpus/files/hydraulics-home.json`, GRO `corpus/files/gro-home.json`, Repairs repo-root `figma-to-bricks-debug-page-1.json`, brainstorm `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services `git show 2199895:figma-to-bricks-debug-page-1.json` extracted to your evidence folder, never the worktree), ticks off and header+footer ticked: list every section whose line or spacing changes, with before → after numbers at 1440 (or the design width), 768 and 390. Probe with a scratch script importing the copy's `src/core` (see the skill's blast-radius line). Say which files stay byte-identical, if any, and which test fixtures/golden payloads change (`convert-sample.json` and other pinned outputs: list them under Touches as files the builder may update, with why).

## This machine
Same as before: `npm run corpus` measures nothing here (Mac paths); never edit `corpus.json` in the worktree; `CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b` (CPU profile `--disable-software-rasterizer` if Chrome stalls; memory note `corpus-paths-on-desktop.md`). The worktree guard refuses Bash it can't prove stays in the worktree: write scratch scripts with Write and run `node <absolute script> <absolute args>`, one plain command per call.

## ACs
Keep the already-built Part 1 ACs (AC1–AC3) and their tests unchanged if the builder finished them. Replace Part 2's ACs with new ones (numbered on from there, all **proposed**, one named test each). Cover at least: no section divider lines between sections (and the inside-section lines kept); the space between every two adjacent sections' words equals the page's section space ±1px at 15 widths in Chrome (1440 → 320), never doubled; every section ending with CTA buttons has the section space under them; the kept-spacing exceptions (hero, painted bands, touching sections, marquee, strips) unchanged; GRO free-drawn behaviour as ruled; Home's whole page in Chrome at 1728/1440/990/768/390 (lines gone, gaps even); lint no worse on the five files at 390/768/1024/1440/design plus 1100–1366 and 375/360/320; one `(live)` AC: after re-pasting Home, every section is evenly spaced with no lines between them and space under every button row (`- ACn (proposed) (live): …`).

## Rules
- You can't ask Justin anything. Questions at the top, each with 2–4 lettered options under about 60 characters, ⭐ on the recommended one, plan written as if ⭐ were chosen (his standing auto-go starts the builder after the plan message).
- Keep the **Docs & records** task (plan, ledger, HANDOFF with paste check, BUILD at merge, main CLAUDE.md "Status" line + a "Decisions the user made" → "Layout" line for the section-rhythm rule, which narrows "the design stays as drawn").
- Other bugs: `found_else` + "Other things found", don't fold in. Reusable lessons: `skill_lessons[{skill, lesson, evidence}]` only (never edit skills or memory); empty is normal.
- Plain words: Justin reads short messages.

## Return (your final message)
`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], acs[], live_acs[], blast_radius[], risks[], touches[], overlaps, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
Teammate (screenshot): "Can we remove the line on the top, reduce the spacing on the top, and add more spacing below the buttons in this section?" Justin: "Lets do this." / "make them general changes for any other website." / "this also fixes the spacing … The spacing between pages, right?" / "Do it for every section, like in the photo. Make sure the spacing is good, including the gap between sections. Also apply it to every call-to-action button, not just the closing one."
