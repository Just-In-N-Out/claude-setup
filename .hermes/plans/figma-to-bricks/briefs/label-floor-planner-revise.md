# Brief: PLANNER (revise mode) for figma-to-bricks feature "label-floor" (now Full pipeline)

Revise the existing plan with Justin's new answer. Don't build anything.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`; plan committed at 8c1f083, code complete at df8ee55, HEAD b49d6f7 adds HANDOFF). Work only there; never edit the main folder.
- Plan to revise in place: `docs/plans/2026-10-26-label-floor.md` (leave the edit uncommitted; the builder commits it).
- Evidence so far: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/` (builder ledger copy `builder/ledger-copy.md`, corpus before/after in `corpus/`, the per-label Chrome measurement script `corpus/spill.ts`, `corpus/gro-grown-labels-{before,after}.txt`, `corpus/gro-diff.txt`) and shots in `~/.hermes/plans/figma-to-bricks/shots/label-floor/` (`{before,after}-gro-nav-{1440,1300,1200}.png`, `{before,after}-gro-hero-{1440,1300}.png`, hydraulics cards).
- Worktree ledger: `.superpowers/sdd/2026-10-26-label-floor/progress.md`.

## Skills (load first, say so in one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, PLANNER role; its `references/rules-summary.md`; only the worktree `CLAUDE.md` sections you need), `engineering-best-practices`, `implementation-planning`, plus `systematic-debugging` for the GRO overflow's cause.

**Revise mode:** read the existing plan and the builder's ledger first, then only the code and docs the change touches (the spacing code below). Skip the full Step 1 load. Anything still unchecked becomes a builder task ("check X first").

## What happened
The Mini build (AC1–AC8) works on Justin's hydraulics homepage: tags 11 → 13px, "Learn More" / "Call Us Now" 13 → 15px, classes byte-identical, lint no worse, Repairs/inspo/Services byte-identical. The builder stopped (escalate to Full) because of GRO (`corpus/files/gro-home.json`, drawn without auto layout, 1440 wide), where rows are exactly as wide as their drawn items:
- the header's "LET'S GRO" pill (11 → 13px) makes the nav row overflow: at 1440 the pill runs 13px past its row; at 1300 the menu's last link "INSIGHTS" wraps under "WORK"; at 1300 and 1200 "LET'S GRO" breaks onto two lines;
- the hero's "Let's GRO / See our work" row wraps from 1439 down (hero 35–62px taller); at 1440 "See our work" runs 54px past its 332px fixed-width row.
- The lint is identical at every width (it has no check for a label wrapping inside its pill or an item running past a fixed-width row); only the per-label Chrome measurement (`corpus/spill.ts`) shows it.
- The builder's diagnosis: GRO's laptop spacing (fluid gap clamps and % nudges from `space.ramp`/nudges) comes from drawn widths, not from `adapt/least.ts`, so a grown label overflows its row and flex shrinks its neighbours. Confirm or correct this with file:line evidence.

## Justin's decision (2026-10-26)
Asked "how should tight rows be handled?", he chose **"Space gives way"**: in a row drawn exactly as wide as its items, the gap next to a grown label shrinks by what the label grew, so the row keeps its drawn width and stays on one line, from the design width down through the laptop widths (1440, 1366, 1300, 1280, 1200, 1100, 1024, 992) and on tablets wherever main kept that row on one line. Hydraulics stays as the current build has it. It must be general (any free-drawn design), never keyed to GRO.

Plan it:
- Which space gives way, and where it's decided (respect the pipeline: no stage edits an earlier stage's output; only `src/core/adapt/rules/` writes breakpoint styles; rules read widths from the layout plan `ctx.layout`). Gaps, % nudges, margins: say which, in what order, and how the growth amount reaches the place that writes the space (e.g. recorded by style, read by the layout plan).
- What happens when the space isn't enough (⭐ a safe fallback you choose, e.g. take the rest from the nearest gap in the same row, or let the label keep its drawn size there; never a sideways scroll, never a wrap main didn't have).
- Fixed-width rows that aren't pills (GRO hero's 332px row): the growth comes out of the row's own gap/space first; say what the row does if it has none.
- Keep main's (and the current build's) exact output wherever there was no overflow: hydraulics, Repairs, inspo, Services must stay as the current HEAD has them.
- Add the missing check: a browser test (and a corpus measurement) that, for every grown label, counts its lines and checks it stays inside every ancestor up to its section at every width, including 1440/1366/1300/1280/1200/1100/1024/992 and 768/480/390/375/360/320.

## ACs
Keep AC1–AC9 as approved (don't renumber or reword them; the approved copy is the contract). Add new ones, numbered on from AC10, each with one named test, marked as Justin's decision (not proposed: he chose it), e.g.:
- AC10: in a row drawn exactly as wide as its items, a grown label's row keeps its drawn width and one line at every width from the design width down to 992 (and on tablets where main kept one line); the gap next to it shrinks by the growth. Generic fixture, unit + browser test.
- AC11: GRO's header and hero: every grown label and its row neighbours have the same line count as main at every width listed above, and nothing runs past its row or section (spill measurement before/after).
- AC12: rows that had room keep the current build's output (hydraulics, Repairs, inspo, Services: byte-identical to b49d6f7 apart from changes this part proves necessary, each named).
Adjust as the code demands; keep each AC one testable sentence with a named test.

## Checks on this machine
- `npm run corpus` measures nothing here (Mac paths in `corpus/corpus.json`): measure the five files directly with replay/snap, as the builder did.
- Chrome works here via `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. The browser baseline at main on this machine is 349/362 with 12 font-environment failures (names in `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`): compare by test name, not count.

## Rules
- You can't ask Justin anything. Questions go at the top of the plan (lettered options under ~60 chars, ⭐ on your recommendation), written as if ⭐ were chosen: his standing auto-go starts the builder right after the plan message.
- Record his answer under `## Justin's answers (2026-10-26)` in the plan, and mark the pipeline Full.
- Update the plan's touched files, risks, and the **Docs & records** task (HANDOFF section and paste check 3bl gain the GRO-style rows; CLAUDE.md lines).
- Other bugs: `found_else`, don't fold in. Reusable lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; an empty list is normal).
- Plain words.

## Return (your final message)
`{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], new_acs[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
Question: "In designs drawn without auto layout (GRO), a row is exactly as wide as what it holds, so a bigger pill pushes into its neighbours on laptop screens … How should that be handled?" His pick: "Space gives way (Recommended): in a row drawn exactly as wide as its items, the gap next to a grown label shrinks by what the label grew, so the row keeps its width and stays on one line. … moves to the Full pipeline."
