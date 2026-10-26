# hero-media-row — PLANNER brief (Figma to Bricks V2)

You are the **PLANNER** for the Figma plugin feature **hero-media-row**. Write a plan Justin will approve. Do not build anything: no worktree, no branch, no code, no commits.

## The ask (rewritten)

**Bug:** a page hero laid out as **text on the left, media on the right** stays side by side on desktop, but from **tablet portrait (Bricks ≤ 991px)** down the media box drops **below** the text and spans the full width. That makes the hero very tall and loses the design.

**Expected:** at **tablet portrait (≤ 991px)** and **mobile landscape (≤ 767px)** the hero keeps the desktop arrangement: text column on the left, media column on the right, on the same row. Justin did not mention mobile portrait (≤ 478px); treat whether phones still stack as an open question (recommended: phones in portrait still stack, because a ~375px screen is too narrow for two columns, but measure and decide with evidence).

**Done looks like:** pasted into Bricks, the hero at 990, 768 and 600-ish widths shows the text left and the media right on one row, with nothing clipped, no sideways scrolling, and the text still readable (no one-word-per-line heading). Desktop and laptop widths are unchanged. The fix must be **general logic** (detect the pattern from structure: a two-column row of a text stack + a media/picture box), never keyed to this page's layer names, texts, IDs or pixel values.

## The screenshots (described; images are attached too)

1. **Desktop (Bricks base breakpoint, canvas 1571px wide).** Service page hero on Justin's All Type Hydraulic site, "Remanufactured Hydraulic Cylinders". Background is a dark grayscale photo of a Terex dump truck. **Left column:** breadcrumb (HOME > SERVICES > REMANUFACTURED HYDRAULIC CYLINDERS), yellow eyebrow "SERVICE 02", a large white two-line H1 "REMANUFACTURED HYDRAULIC CYLINDERS", a paragraph, then a row of two pill buttons (yellow "CALL US NOW ↗" and outlined "EMERGENCY CALL 24/7" with a phone icon). **Right column:** a thin-bordered, rounded media frame holding a transparent cut-out picture of an orange hydraulic cylinder. Text and media are side by side. **This is correct.**
2. **Tablet portrait (Bricks ≤ 991px, canvas 990px).** Same hero. The text now spans the full width (H1 on one line), and the **media frame drops below the buttons**, stretched to the full content width, with the cylinder picture centred in a large mostly-empty box. **This is the bug.**

## Where to look (pointers, not conclusions)

- The stacking decision for rows at the tablet/phone tiers lives in the adapt stage (`src/core/adapt/rules/`, and whatever decides when a row turns into a column). Find the exact rule and condition that stacks this row at ≤ 991px, with file/line evidence, and compare it with rows that stay on one line at tablet (the difference is usually the cause).
- `CLAUDE.md` may hold an earlier decision of Justin's about when two-column rows stack at tablet. If the fix changes one of his decisions, say so plainly in the plan and make it a question.
- This design was used by the merged feature **hero-photo-blend** (build 2026-10-21.24, paste check 3ax, "Remanufactured Hydraulic Cylinders"). Its plan `~/.hermes/plans/figma-to-bricks/hero-photo-blend.md` and evidence folder may tell you which corpus or debug file holds this hero. Also check the user's debug JSON in the main folder (read only; copy it to scratch before replaying).
- Reproduce with the renderer at the paste's real widths (990, 768, 600, 480 and the phone widths), not Figma's frame width.

## Rules from the project skill you must honour in the plan

- Any change to phone padding, floors or widths: measure in Chrome at **375, 360 and 320** too.
- Any change to margins, gaps or nudges: also measure laptop widths **1366/1300/1200/1100/1024/992** and compare each changed row's right edge with main's.
- Measure pictures cut off by their section, and text clipping, at every tier you change.
- List existing tests that pin the current "stacks at tablet" behaviour as files the builder may edit.
- End with a **Docs & records** task (plan copy, ledger, HANDOFF with the paste check owed — take the next free number on main at merge time, BUILD bump, main `CLAUDE.md` "Start here"/"Where things stand" after merge, and any new `CLAUDE.md` rule).
- Add a `## Skills` section naming the specialist skills the build needs (e.g. `frontend-ui-repair`) and mark any that carry the Agent Defect Loop (`grep -l 'Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md`).

## Other open features in the same project (name file overlaps)

These are live in another chat; say for each whether your fix touches the same source or test files, so the dispatcher can order the builds:

- **found-layout** (reviewing) — touches `src/core/adapt/rules/nudge.ts`, `src/core/style/place.ts`, `src/core/style/style.ts` or `sizing.ts`, `src/core/adapt/rules/upright.ts`; read-only for it: `space.ts`, `rows.ts`, `shapes.ts`, `layout.ts`, `least.ts`. Its latest commit is about "from tablets down a row still on one line counts…", which may be closely related — read its plan `found-layout.md` (Touches and Overlaps sections only).
- **found-tiles** (reviewing), **found-list-head** (queued) — layout areas too; check their plans' Touches sections.
- **W-B** (held decision, not a feature): the wrapped-row least / grid reading-width policy, which changes the hydraulics Bento grid from 2 to 3 columns on tablet. Say if your fix depends on or collides with it.

Disk is tight (about 6 GiB free): don't clone or archive large trees; scratch replays only.

## Also in scope (Justin, 2026-10-22: "Fix them as part of the job")

These two are **part of this feature now**, not `found_else`. Give each its own root cause (file/line evidence), its own test-first tasks and its own before/after checks, and keep the fix general (from structure, never this page's names/texts/pixels):

2. **Tablet header (≤ 991px, canvas 990px):** the phone number "(800) 457-3160" wraps onto three lines and the "SCHEDULE NOW ↗" pill wraps onto two lines, and the **logo is missing** (find whether it's hidden, shrunk to nothing or pushed off the left edge). Expected: logo visible, phone number on one line, pill label on one line, nav still fitting (if everything can't fit on one line at 990, say what should give way and make it a question).
3. **Desktop breadcrumb:** the middle crumb "SERVICES" sits higher than "HOME" and the current-page crumb. Expected: all crumbs and the ">" separators share one baseline.

Header and breadcrumb may touch different pipeline parts (phone/CTA classes, nav, text runs) than the hero row. Name each part's files in Touches, check overlaps with the open features for each, and resize the job if it grew (say the size in the plan). If one part needs a decision of Justin's, make it a question rather than dropping it.

If you find any other bug along the way, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.

## Output

- Save the plan to `~/.hermes/plans/figma-to-bricks/hero-media-row.md`. Self-contained: playback, root cause with file/line evidence, approach, tasks (test first), tests (with the widths above), choices you made, risks, Touches (exact allowlist), Overlaps, Docs & records.
- Put the **open questions section at the top**, right after the title. Each question gets 2–4 short options (A, B, C…, under ~60 characters each), the recommended one marked ⭐. Write the plan as if the ⭐ options were chosen, so "go" needs no re-plan.
- Answer in plain words for a reader on a phone. You can't ask Justin anything: questions go in `questions`.

## Justin's words (verbatim)

> okay you can see here how the media of the image on desktop is good but when it comes to tablet and mobile landscape, you can see how the media of the header goes down. I want it to stay all on the same line. I want it to be like the desktop version, where the media is to the right of the text on the left. This is for Figma to Bricks V2.

If this rewrite and his words disagree, follow his words.
