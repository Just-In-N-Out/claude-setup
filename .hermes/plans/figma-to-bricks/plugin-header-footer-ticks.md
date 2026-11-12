# plugin-header-footer-ticks (Mini, a bug): the header and footer boxes read backwards

Planner: Fable 5.2 high, 2026-11-11, on `main` at Build 2026-11-11.5 (`11f07742`). The builder copies this file to
`docs/plans/2026-11-11-plugin-header-footer-ticks.md`.
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/planner/` (called `<planner>` below).

## Playback

1. Justin said that when a person tells the Figma plugin not to include the header or the footer, the paste still holds
   them; asked what he saw, he chose "Both off, both pasted".
2. Proven: the plugin does what the two boxes say, but the boxes are worded as a fact about the site ("My site already
   has its header"), so an **empty** box means "keep the page's header in the paste". With both boxes empty, both stay.
   And right after a person unticks both, the panel's own line says "every page you convert from it leaves these out".
3. The fix is in the panel's words only: each box says what it does, the line under the boxes says what the next paste
   will do, and every note names a box by the words on it. No paste changes by a byte.

## Questions (⭐ = what the builder takes under the standing auto-go)

- **Q1. What should a box mean?**
  - **A ⭐: a tick still means "leave it out"** (as today, and as every Figma file already saved), but the words say so:
    "Leave the header out of the paste (my site already has its own; the page starts below it)" and "Leave the footer
    out of the paste (my site already has its own)". The line under the boxes always says what the next paste will do.
  - B: flip the boxes to "Include the page's header" / "Include the page's footer", ticked in a new file, untick to
    leave out. It matches "untick to not include", but every file ticked so far would then show its boxes empty, and
    it reverses how the 2026-10-20 decision is shown. Reply **B** and this plan gets a short re-plan (same files).
- **Q2. Were your boxes empty or ticked when both stayed?** ⭐ Taken as **empty** (your answer "Both off"). If they were
  **ticked** and both still pasted, that is a different bug (the plugin didn't recognise that page's header and footer
  as a header and footer): press "Save debug file" on that page and send it; it gets its own job. The builder's first
  task checks the debug file if it has arrived by then.
- **Q3. Your own check afterwards** ⭐ is with both boxes **ticked** (they now read "Leave the … out of the paste").
  The brief's wording "with both ticks off" can't be met under A: an empty box keeps the part, on purpose (2026-10-23).

## Root cause (evidence)

1. **An empty box keeps the part, by design.** `src/ui/index.html:96-97`: the boxes read "My site already has its
   header (left out; …)" / "My site already has its footer (left out)", both empty in a new file
   (`src/core/normalise/site.ts:6` `NO_SITE`). `src/core/understand/leave-out.ts:23-39` (header) and `:42-54` (footer):
   ticked, the part leaves the paste; unticked, it stays and a note says so (Justin's own rule of 2026-10-23, the
   comment at `leave-out.ts:1-5`). No code path lets an empty box leave anything out.
2. **Reproduced on every real file here.** `<planner>/ticks-matrix.log` (script `ticks-matrix.ts`): hydraulics, GRO,
   Repairs, brainstorm and Services, each converted at the four box states. Both empty: header and footer are in the
   paste on all five (brainstorm has no header bar of its own: `none`). Both ticked: both leave on four of five (697 →
   537 elements on hydraulics); brainstorm's header stays as `kept` with its note (the known bug: a nav drawn inside
   the hero).
3. **The box reaches the conversion.** `src/ui/site-box.ts:67-72` posts `saveSite` on every change;
   `src/plugin/main.ts:50-51` saves it in the Figma file (`src/plugin/site.ts:11-18`); the next Convert reads the file
   again (`src/plugin/extract/snapshot.ts:79-94` → `src/core/normalise/normalise.ts:352` `parseSite`); the panel copies
   only the new result (`src/ui/main.ts:461-473` puts "still converting" on the clipboard first; `:222-226` copies the
   new paste). No cached paste, no stale setting. `<planner>/panel-path.log` drives the real `siteBox` and the plugin's
   real `saveSite` end to end: tick both → `left`/`left`; untick both → `included`/`included`.
4. **The panel's own words mislead on exactly this path.** `src/ui/site.ts:7` `SITE_KEPT` = "Kept in this Figma file:
   every page you convert from it leaves these out.", shown after **every** save whatever the boxes are
   (`src/ui/site-box.ts:84`). `<planner>/panel-path.log`, step "untick siteFooter": with both boxes empty the line
   reads "…leaves these out", and the Convert that follows pastes both. The box label itself leads with a fact
   ("My site already has its header"), the action only in brackets; a person who wants the header out but whose site
   has no header yet, or who reads the box as "the header", leaves it empty.
5. **What is already right, and stays:** after a Convert with a part still in the paste, the line under the boxes is
   red and names the box to tick (`src/ui/site.ts:35-38`); a ticked part that isn't found always gets a note with the
   reason (every not-found return carries one: `site-header.ts:131,152,171`, `site-footer.ts:98`) and a red line
   (`site.ts:40`). So "ticked but not found" is never silent.
6. **What the report can't tell us:** the question Justin answered offered only "off" choices (it assumed unticking
   means "don't include"), so "Both off" may also mean "both set to be left out" (ticked). On the five real files that
   case leaves both out except brainstorm's header. Q2 and Task 1 cover it.

## The fix (general: the panel's words, for every file; no conversion change)

The exact edits are proven on a scratch copy of the base: `<planner>/prototype.py` applies them (each anchor must match
once), `<planner>/prototype.diff` is the result.

1. **One name for each box** — `src/core/normalise/site.ts`, after `NO_SITE`:
   ```ts
   // The words on each box in the panel (ui/index.html): every line and note names a box as the person reads it
   export const tickName = (part: "header" | "footer"): string => `Leave the ${part} out of the paste`;
   ```
2. **The boxes** — `src/ui/index.html:96-97`:
   ```html
   <label class="check"><input type="checkbox" id="siteHeader" disabled> <span>Leave the header out of the paste (my site already has its own; the page starts below it)</span></label>
   <label class="check"><input type="checkbox" id="siteFooter" disabled> <span>Leave the footer out of the paste (my site already has its own)</span></label>
   ```
3. **The line under the boxes says what the next paste does** — `src/ui/site.ts`: `SITE_KEPT` goes; in its place
   ```ts
   const SITE_PARTS = ["header", "footer"] as const;
   // What every page converted from the file does with its header and footer, as the boxes stand (Justin, 2026-11-11:
   // with both boxes empty the line said "leaves these out" and the paste held both)
   export function ticksText(site: SiteParts): string {
     const out = SITE_PARTS.filter((p) => site[p]);
     const stay = SITE_PARTS.filter((p) => !site[p]);
     if (!out.length) return "Every page you convert from this file keeps its header and footer in the paste. Tick a box to leave that part out.";
     if (!stay.length) return "Every page you convert from this file leaves its header and footer out: your site's own show instead.";
     return `Every page you convert from this file leaves its ${out[0]} out and keeps its ${stay[0]} in the paste.`;
   }

   // after a save: the error, or that the file keeps the boxes and what they do
   export const siteSavedText = (error: string | null, site: SiteParts): string => error ?? `Kept in this Figma file. ${ticksText(site)}`;
   ```
   with `import { tickName, type SiteParts } from "../core/normalise/site.ts";`, and in `partsText` the box names come
   from `tickName`: ``included.map((p) => `"${tickName(p)}"`)`` (the rest of that red line is unchanged).
4. **`src/ui/site-box.ts`**: import `ticksText`; in `opened`, after `show(site);` and before `take();`:
   ```ts
   // before any Convert: what the boxes, as the file keeps them, do to the next paste
   said = { text: ticksText(site), kind: "muted" };
   paste(undefined);
   ```
   and in `saved`: `error ?? note ?? siteSavedText(null, site)`.
5. **The notes** — `src/core/understand/leave-out.ts`: `import { tickName, type SiteParts } from "../normalise/site.ts";`,
   `keptNote` starts ``"${tickName(part)}" is ticked, but…`` and `includedNote` ends ``tick "${tickName(part)}" and
   Convert again``. `src/core/understand/header-bar.ts:35` `menuNote` ends ``or tick "${tickName("header")}"`` (import
   `tickName` from `../normalise/site.ts`).
6. **Comments that name the boxes by the old words** (`src/ui/site.ts:1`, `src/plugin/site.ts:1`,
   `src/core/understand/site-footer.ts:1`, `src/core/understand/room.ts:3-4`, and `tools/replay.ts:3`,
   `tools/snap.ts:4`): the new words. The words test fails on any file under `src/` that still says them.

Not changed: what a tick does, what a file keeps (`{"header":…,"footer":…}`), the ticks remembered per WordPress site,
the red line and notes' meaning, the conversion. Warnings aren't part of the paste, so every paste is byte for byte as
before (the byte test below: 32 pastes).

**Size:** nine files under `src/` change, but six of them by one line of wording or a comment; the logic is `ui/site.ts`
(one function) and `ui/site-box.ts` (three lines). That is still a Mini job: the builder's "more than ~3 source files"
escalation doesn't apply to these named wording edits. A change to what a tick does, or Q1 B, is not this plan.

## Acceptance criteria (all proposed)

- AC1 (proposed): given a Figma file whose boxes are both empty (never ticked, or unticked again), the line under the boxes says, before any Convert and after each change, that pages keep their header and footer in the paste and that ticking a box leaves that part out, and never says anything is left out; with one box ticked it names the part left out and the part kept; with both ticked it says both are left out. Test: `the line under the boxes says what the next paste does with the header and footer, for each of the four states` (`test/unit/ui-site-box-line.test.ts`).
- AC2 (proposed): each box starts with what it does ("Leave the header out of the paste", "Leave the footer out of the paste") followed by the reason in brackets, the red line after a Convert and the "includes the page's header/footer" notes name the box to tick by those same words, and no file under `src/` still says "My site already has its". Test: `each box is named by the action it does, and every note names it by the words on it` (`test/unit/ui-site-tick-words.test.ts`).
- AC3 (proposed): by the panel's own path (the box's change, the `saveSite` message, the plugin's save in the Figma file, the file's ticks read as the next conversion's `site`), ticking both boxes leaves the header and the footer out of the paste, unticking both puts both back with the very paste a never-ticked file gives, and the boxes shown always equal what the file keeps. Test: `the boxes reach the conversion: ticked leaves the part out, empty keeps it, by the panel's own path` (`test/unit/ui-site-box-path.test.ts`).
- AC4 (proposed): a ticked part the page doesn't show as a header or footer is never left in the paste silently: for the header and for the footer the paste's result is `kept`, a note names the box by its words and says why, and the line under the boxes is red and points at the notes. Test: `a ticked part the page doesn't show as one is never left in silently: the red line and a note with the reason, for the header and the footer` (`test/unit/ui-site-tick-words.test.ts`).
- AC5 (proposed): no paste changes: the repo's four real Figma files and the four tick fixtures, each at the four box states (32 pastes), are byte for byte the base tree's. Test: `the ticks' new words change no paste: every payload at the four tick states is byte for byte the base tree's` (`test/unit/site-ticks-base.test.ts`, named only: `F2B_BASE_TREE`).
- AC6 (proposed) (live): Justin opens the same Figma page with this build, ticks both boxes (now "Leave the header out of the paste" and "Leave the footer out of the paste"), converts, pastes on darksalmon, and neither the page's header nor its footer is in the paste; with both boxes empty the line under them says the paste keeps both. Test: `Justin's own check on darksalmon: both boxes ticked, neither header nor footer in the paste (paste check id set at the merge)`.

Proof on the plan's exact test files (`<planner>/tests/`, copied into scratch trees of the base and of the prototype):
- On the base (`<planner>/red-on-base.log`): the tests of the first, second and fourth criteria fail by their
  assertions (the line reads "Kept in this Figma file."; the label doesn't start with the action; no note names the
  box by its words). The third criterion's test passes on the base: it is a pin of the path that already works, so it
  begins green and stays green (said here so nobody invents a red for it).
- On the prototype (`<planner>/green-on-prototype.log`, `<planner>/green-words-and-bytes.log`): all four pass, and the
  byte test passes against the base tree with 32 pastes compared.

## Touched files

- Source: `src/core/normalise/site.ts`, `src/ui/index.html`, `src/ui/site.ts`, `src/ui/site-box.ts`,
  `src/core/understand/leave-out.ts`, `src/core/understand/header-bar.ts`; comments only: `src/plugin/site.ts`,
  `src/core/understand/site-footer.ts`, `src/core/understand/room.ts`, `tools/replay.ts`, `tools/snap.ts`.
- New tests: `test/fixtures/site-box.ts`, `test/unit/ui-site-box-line.test.ts`, `test/unit/ui-site-tick-words.test.ts`,
  `test/unit/ui-site-box-path.test.ts`, `test/unit/site-ticks-base.test.ts` (ready in `<planner>/tests/`).
- Tests that pin the old words (expected strings only: put the box's new name in; never loosen an assertion):
  PINNED_LIST
- Docs: `docs/HANDOFF.md`, the ledger.

## Tasks (one commit each, `npm run check` green at each commit from Task 3 on)

1. **The debug-file gate.** If the orchestrator's brief names a debug file from Justin, run
   `node <planner>/ticks-matrix.ts <worktree> <that file>` and read its first line ("the file's own saved ticks").
   Saved ticks `{"header":true,"footer":true}` with a header or footer still `kept` at "header=ON footer=ON": stop with
   `status: stopped`, `stop_reason: escalate` (a recognition bug on that page: its own job, with the file). Anything
   else (no file, or saved ticks off/none): go on. Record the log in the ledger either way.
2. **Red.** Copy `<planner>/tests/test/fixtures/site-box.ts` and the three unit tests `ui-site-box-line`,
   `ui-site-tick-words`, `ui-site-box-path` into the worktree as they are. Run
   `node --test test/unit/ui-site-box-line.test.ts test/unit/ui-site-tick-words.test.ts test/unit/ui-site-box-path.test.ts`:
   3 fail by assertion, 1 passes, as in `red-on-base.log`. Commit the tests with the fix in Task 3 (a red commit breaks
   "each commit green").
3. **Green.** Make the edits of "The fix" 1–6 (by hand or `python3 <planner>/prototype.py <worktree>`, then the
   `room.ts` comment by hand as the diff shows). The three test files pass (4 tests). Update the pinned words in the
   existing tests listed above, then `npm run check`. Compare failures by name with the base
   (`<planner>/suite-base.log`): no test may fail that passes there. Commit.
4. **The byte test.** Copy `<planner>/tests/test/unit/site-ticks-base.test.ts` in. Make the base tree
   (`git archive <base> | tar -x -C <scratch>`, `node_modules` linked to the main folder's) and run
   `F2B_BASE_TREE=<scratch> node --test test/unit/site-ticks-base.test.ts`: 1 pass, 0 skipped. Without the variable it
   skips (a story pin, never in the default run). Commit.
5. **The panel in Chrome.** Update `test/browser/panel.test.ts` (the line that expects the old box name, near :218) and
   any other browser test or fixture in the list; run `test/browser/panel.test.ts` with `CHROME_PATH` set (`skipped 0`).
   Take the screenshots: the panel with both boxes empty (the new line), both ticked, one ticked, and after a Convert
   with a ticked part not found (red line and note); a terminal capture for the path test and the byte test.
6. **Gates.** `npm run check`; `npm run corpus` (on this machine measure the two repo corpus files directly: replay at
   the four box states gives the same element counts as `<planner>/ticks-matrix.log`). Stop at `ready-for-review`.
7. **Docs & records (one line):** a HANDOFF section "The header and footer boxes say what they do" (the report, the
   cause, the new words, Q1–Q3 ⭐ not yet confirmed, the paste check for the live criterion at the top of the
   End-of-run check list, the open case of Q2) plus the ledger; the merge finisher's CLAUDE.md lines (Status; the
   boxes' new words wherever CLAUDE.md quotes the old ones) and the same rename in the project skill's
   `project-decisions.md` → "The site's own header and footer" go to the main session.

## Overlaps and risks

- **bricks-icons M1** (building: `emit/elements.ts`, `understand/understand.ts`) and **plugin-parity** (Figma side):
  this job touches neither file. It shares only test files that quote a header/footer note; a rebase conflict there is
  a one-line wording merge.
- HANDOFF's older sections and paste checks (3bj, 3bl, 3bm, 3bq…) quote the old box words; they are history and stay.
  The new HANDOFF section says the boxes were renamed on 2026-11-11.
- Justin knows the boxes by their old words: the reason stays in each label ("my site already has its own"), and the
  meaning of a tick doesn't change, so his saved files and habits keep working.
- If Q2 turns out "ticked": this job still ships (the words were wrong on their own), and the recognition bug needs
  his debug file.

## Completion and report

Builder: `ready-for-review` with the head SHA, the test tally by name against the base, the screenshots, `found_else`,
and `skill_lessons[{skill, lesson, evidence, enforce}]`. Estimate: 45–75 minutes of building, one review.
