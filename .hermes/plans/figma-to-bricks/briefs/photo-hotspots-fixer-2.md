# FIXER 2 — photo-hotspots (FigmaToBricksV2)

Fix the valid findings of reviewer 2 (verdict: approve-with-fixes) on
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots` (branch `worktree-photo-hotspots`, head 2bd4c2a,
built on flip-cards at 388191d: your diff and base comparisons use 388191d). Approved plan (read-only):
`~/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`. Review, probes and mutants:
`~/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/reviewer-2/` (read render1.txt, bp.txt, bleed.txt,
mutants-summary.txt and the probe scripts first). The first fix pass: `evidence/photo-hotspots/fixer-1/` and HANDOFF.

## Role and skills
FIXER. Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review` (verify each finding first; push
back with evidence on any invalid one), `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`.

## Findings (test first, one commit each)
- **F1 (medium):** a hotspot photo drawn as a picture layer with flowing words on it collapses on phones (min height
  dropped from 767 down, no aspect-ratio): the dots sit outside it, and `isolation: isolate` traps the card's z-index.
  Give every hotspot photo its drawn ratio as a floor (`aspect-ratio: W / H`, height auto, no `min-height: 0`), or have
  unpin treat a box whose cover layer is a photo like a photo-painted one; check the card still shows above the
  photo. Add `{ withWords: true, photoLayer: true }` to AC5's variants.
- **F2 (medium):** unclipping the photo for a card shows everything the photo crops (a photo layer drawn bigger than its
  frame spills on every side while a card shows). Keep the photo's own layers clipped while it unclips for its cards
  (e.g. `clip-path: inset(<the layer's overhang as % of itself> round <radius>)` on each non-hotspot placed or cover
  child, exact at every width; this can replace `border-radius: inherit`), or another approach you prove. Add a
  bleeding-layer variant to AC6's corner and outside-the-photo checks (elementFromPoint just outside the photo, at
  rest and with a card open).
- **F3 (low, tests):** the surviving mutants OPEN-SOME, CLIPS, OPACITY, HOVER-WRAP, PULSE-WRAP, CORNERS-ANY,
  COMPOSE-PLACED, SHOWCASE-STILL, HERO-CARDS, LEFT, PULSE-INNER: one generic fixture case each (a wrapper with a dot and
  a legend; clipping, 50%-opacity, hovered and pulse-marked wrappers; a 32px+ Button in a hero photo's card; a card
  holding photo cards; a rounded clipping photo whose trigger and card keep their own corners; a pulse mark in a
  left-out site header; a section marked pulse). SHOW-ALL and LOOKS-OVERLAY are likely equivalent: confirm or test.
  Re-run the mutants and record each kill.
- **F4 (low):** a card holding a hover-hotspot photo can be linked whole by the plugin's page-link pass
  (`normalise/page-links.ts` `allowed()` ignores overlays), so every dot is refused. Count `n.overlay` like `n.clicks`
  in `allowed` (both `around` and `every(target)`); test.
- **Records:** extend HANDOFF's F10 limit: any clipping frame around the photo (a rounded card, a clipping section) cuts
  a hanging card, not only the phone slider. Note the reviewer's R10 prediction (a pulse mark on a CTA or a product
  photo meets the plugin's own animations) and the generic `pulse` class name as follow-ups; don't rename it (AC9).

## Gates
`npm run check` (0 fail); the hotspots browser file alone (`skipped 0`); the full browser suite by name against 388191d's;
replays of hydraulics, GRO, debug-page-1 (scratch copy) and brainstorm with bricks.json and warnings.txt byte-identical to
388191d; the corpus-skipped unit tests in scratch git-archive trees (memory `corpus-paths-on-desktop.md`).
`export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Long gates: log with `echo EXIT=$? >> log`, wait with
`until grep -q '^EXIT=' log; do sleep 2; done`. Source files under ~300 lines. Update HANDOFF, the plan copy and the
ledger for every changed ruling.
**Scratch:** work only in `<scratchpad>/photo-hotspots-fixer-2/`, created fresh with `mkdir` (no `-p`); never extract
into a folder you didn't create (other features' agents share the scratchpad). Copy probes that prove something into
your evidence folder at once.

## Rules
Commit (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump BUILD, never
edit the main folder, never bare `git stash`, don't rebase onto flip-cards (the finisher does at merge). Other features
are in their own worktrees; don't touch them. Justin is away: when unsure, take the recommended option and record it as
"My ruling, not yet confirmed"; when you don't know how, research it and implement your best rather than stopping.

## Report
Return `{name, status: ready-for-verify|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, ac_status[{ac, accepted, test, evidence}], found_else[], skill_lessons[{skill, lesson, evidence}]}`
and end with `MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.
