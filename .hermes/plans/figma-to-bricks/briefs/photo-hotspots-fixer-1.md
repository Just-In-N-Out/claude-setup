# FIXER 1 — photo-hotspots (FigmaToBricksV2)

Fix the valid findings of reviewer 1 on `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`
(branch `worktree-photo-hotspots`, head b8ecf1b, built on flip-cards at 388191d: your diff and base comparisons use 388191d). The approved plan's read-only copy:
`~/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`. The review with its probes:
`~/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/reviewer-1/` (read its probes before fixing).

## Role and skills
FIXER. Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review` (verify each finding before fixing;
push back with evidence on any you find invalid), `test-driven-development` (a failing test first for every fix),
`mutation-testing-discipline` (run any harness detached with a marker file naming the mutated file; a session restart
kills its process group), `git-commit-rules`.

## Findings to verify and fix (test first, one commit each; the reviewer's verdict was request-changes)
- **F1 (high):** dots grouped (Cmd+G) or wrapped in a plain frame inside the photo: the wrapper becomes the box, flows
  relative, the photo keeps its min height and no aspect-ratio, and the dots drift 7–10% on phones. Treat an unpainted,
  unclipped, unlinked wrapper whose layers are all placed as transparent (climb to the box holding the photo; pin the
  wrapper by share or hoist its layers); the real photo takes its shape. Add fixture option `grouped: "GROUP" | "FRAME"`
  to the AC4 and AC5 tests (AC5 is not accepted until this holds).
- **F2 (medium):** a hotspot photo as a hero's beside-media: `heroOf` → `heroButtons` hides every dot label on phones
  and copies them into the Phone buttons band. Exclude the hotspot layers from `hero.ctas`/`headerCtas`; test a hero
  pair whose media is the hotspot photo (labels keep showing; the hero's own CTA is still copied).
- **F3 (medium):** the unclip rule turns a rounded photo's corners square whenever any card is open. Unclip only for
  cards drawn past the photo (e.g. a `hotspot-past` class in the `:has()`), give the photo's picture/cover children
  `border-radius: inherit`; Chrome check of the corner with an inside card and a hanging card open.
- **F4 (medium):** a non-link trigger is a role-less div with tabindex, so its aria-label is ignored (WCAG 4.1.2): add
  `role="button"` next to `tabindex` (the marquee's `_attributes` role survived a live paste); assert it in AC4.
- **F5 (low):** a pulse-marked layer with its own Figma Motion keeps a useless `pulse` class and gets no note (R10): skip
  the class and write the note.
- **F6 (low):** dots straight in a free-drawn section are refused with a note but still stay absolute: skip the
  stay-placed exclusion for a page root's direct children (or reword the note); add a free-drawn-section case to AC3.
- **F7 (low):** a hotspot photo under a linked ancestor nests interactive content and drops card links: refuse hotspots
  under a linked ancestor, with a note; test it.
- **F8 (low):** surviving mutants M2–M6 (card min height only where Figma fixes it; a trigger's overhang in the clamp;
  the missing-offset guard; the dimmed-background note; `holdsLayer`): one fixture case each; compute AC6's wait per
  transition (the Instant run waits 600ms where 300ms is the limit). Re-run the mutants, record each kill.
- **F9 (low):** the grace holds only visibility, so opacity blinks out while the pointer crosses the gap (Instant,
  reduced motion): delay opacity by the grace too; sample opacity during the crossing in AC6.
- **F10 (low):** a card hanging below the photo inside a phone-slider copy is cut by Splide's track: record it as a
  limit in HANDOFF (or keep cards inside the slide vertically on phones if small).
- **My ruling for you to apply:** a trigger that covers its whole box keeps cover (100%/100%) instead of its px height,
  so it never hangs below a shrunk photo; test it.
- Evidence: `~/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/reviewer-1/` (probes/, mutant-M*.txt, shots).

## Gates after the fixes
`npm run check` (0 fail); the hotspots browser file alone with `skipped 0`; the full browser suite compared by test name with
main's; replays of hydraulics, GRO, debug-page-1 (a scratch copy) and brainstorm byte-identical to 388191d (bricks.json and warnings.txt); the corpus-skipped unit tests in
scratch git-archive trees (memory note `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`).
`export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Run gates in the foreground. Keep every changed file
under ~300 lines. Update HANDOFF, the ledger and the plan copy for any changed ruling.

## Rules
Commit to the branch (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump
BUILD, never edit the main folder, never bare `git stash`. Other features are building or in review in their own worktrees (flip-cards, your base, has moved on in review: don't rebase onto it; the finisher does at merge); don't touch them.

## Report
Return `{name, status: ready-for-review|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, found_else[], skill_lessons[{skill, lesson, evidence}]}` and end with
`MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.

Paste check id stays 3bp. Long gates: write the log with an end marker (`echo EXIT=$? >> log`) and wait with
`until grep -q '^EXIT=' log; do sleep 2; done`; a foreground call is moved to the background after ~180s.
