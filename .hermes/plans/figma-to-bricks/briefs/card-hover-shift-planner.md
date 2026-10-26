# PLANNER brief: card-hover-shift [Figma]

## Role and skills

You are the **PLANNER** for the FigmaToBricksV2 feature `card-hover-shift`. Write a plan Justin will approve; build nothing.

Load these skills in this order and say so in your first steps:

1. `skill_view('figma-to-bricks')`, then follow it in the **PLANNER** role (its Step 1 context load: rules-summary first, then only the CLAUDE.md sections you need, never the whole file).
2. `engineering-best-practices`. Where they differ, the project skill and Justin's rules win.
3. `implementation-planning` and `systematic-debugging`. This is a bug, so find the root cause with evidence before you plan a fix.
4. `frontend-ui-repair`, the specialist skill for UI bugs. It carries the Agent Defect Loop. The main chat runs that loop as pipeline roles; you can't spawn agents, so skip any "spawn a subagent" steps.

Make no worktree, branch, code change or commit. Always pass `workdir` to terminal commands.

## The bug (rewritten)

**Where:** the "MORE SERVICES / EXPLORE WHAT ELSE WE DO." section. It holds a 2×2 grid of service cards that link to pages. Each card is one row:

- a small yellow label on the left ("Service 01", "Service 03", …);
- an uppercase title in the middle ("HYDRAULIC CYLINDER REPAIRS", "CORE EXCHANGES", …);
- a small ↗ arrow icon at the top right.

An outlined "ALL SERVICES ↗" pill sits to the right of the heading.

**What he sees:** at tablet width (Bricks builder preview "Tablet portrait (<= 991px)", 990px wide), hovering a card plays its hover animation, but the card's content jumps:

- The title drops off the label's line onto a new line below "Service 03".
- The title now sits on, or spills past, the card's bottom edge.
- The ↗ arrow disappears.

Unhovered cards keep the normal one-row layout. Justin says the same happens on phones too (on phones, a tap triggers the hover).

**Expected:** the hover animation plays, and the label, title and arrow stay exactly where they were, on one line, at tablet and phone widths. That matches the unhovered card and desktop.

**Screenshots** (attached as images; paths below):

1. `/Users/justin/Library/Application Support/Hermes/composer-images/image_113701.png`: the section in its normal state. All four cards are on one row each.
2. `/Users/justin/Library/Application Support/Hermes/composer-images/image_757c22.png`: the Bricks builder at 990px (Tablet portrait). The "Service 03 / CORE EXCHANGES" card is hovered. The title has dropped to a second line at the card's bottom edge, and the arrow is gone. The other three cards are fine.

**Done:** the plan names the root cause with file/line evidence and fixes it with general logic (no keying on this design's names, text or pixels). The fix must keep the hovered card's layout identical to the unhovered one at every width: the 990/768/600/480 tablet steps, 390/375/360/320 phones, and the 1024–1366 laptop widths. Desktop must stay unchanged.

**Slips fixed:** he wrote "tablet animations and checking for iPhone" (= at tablet and phone sizes) and "hyperlinks" (= these linked service cards).

## Where to look (hints only, not findings)

- Find out whether the debug JSON (`figma-to-bricks-debug-page-1.json` in the main folder; copy it to scratch, never edit it) contains this section. If not, search `corpus/` and the HANDOFF for a services/"More services" design. If it is in neither, reproduce with a generic fixture and say so in the plan.
- Compare the card's Figma hover variant with its default variant: layout, gap, padding, sizes, arrow position and visibility. Then compare what CSS the plugin emits for `:hover` versus the base at the tablet/phone breakpoints. A hover rule that sets a layout property, or one that restores a desktop value, can undo a tablet override. Bricks cascades tablet → landscape → portrait, so check the breakpoint/state collision rules in `adapt/rules/`.
- Reproduce in Chrome with the renderer at the paste's real widths, with the card forced into its hover state. Measure the label, title and arrow rects hovered versus unhovered.

## Plan requirements

- Save the plan to `~/.hermes/plans/figma-to-bricks/card-hover-shift.md`. It must be self-contained:
  - the request played back in numbered plain words;
  - the root cause with evidence;
  - approach, tasks, tests, your choices, risks, and the pipeline parts and files it touches.
- Put **open questions** at the top, right after the title. Give each question 2–4 lettered options (each under about 60 characters) and mark the recommended one ⭐. Write the plan as if the ⭐ options were chosen, so "go" needs no re-plan.
- Recommend a **size**: small bug (ChatGPT Sol 6.1) or in-between (Opus 5.5 medium), using feature-dispatch's size rules.
- **Before/after pictures** at tablet and phone widths in hover state belong in the builder's tasks.
- End with a **Docs & records** task:
  - plan copy to `docs/plans/<date>-card-hover-shift.md`;
  - ledger to `docs/plans/<plan>-ledger.md`;
  - `docs/HANDOFF.md` updated with the paste check owed (take the next free number on main at merge time);
  - `BUILD` bumped;
  - main `CLAUDE.md` "Start here" / "Where things stand" updated by the finisher;
  - any new `CLAUDE.md` rule.
- **Overlaps:** other Figma features are open now. `found-layout` is in review (tablet rows staying on one line; worktree `.claude/worktrees/found-layout`). `found-tiles` is in review (`.claude/worktrees/found-tiles`). `found-contacts` and `found-gates` are finishing. `found-list-head` is queued. Check their plans in `~/.hermes/plans/figma-to-bricks/` and `git -C <worktree> diff --name-only main...HEAD`. Say whether this fix shares files with any of them, so it can build in parallel or wait.
- List existing tests that assert the behaviour you'd change, as files the builder may edit.
- If you find any other bug, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- Write in plain words for a quick reader. You can't ask Justin anything; put questions in `questions`.

## Justin's words

> okay I have an issue. As you can see here, for the tablet animations and checking for iPhone and all that, whenever someone hovers over those hyperlinks or something for the animation to happen, you can see how the text moves down. It doesn't stay there. Is it possible that we can fix this error or no?
>
> this is for figmabuircksv2
