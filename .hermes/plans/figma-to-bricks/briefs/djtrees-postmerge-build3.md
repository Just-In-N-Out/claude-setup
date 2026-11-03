# Role: POST-MERGE FINISHER — DJ Trees Build 2026-11-02.3 (merge-train cars 3–6)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-postmerge-common.md` first and follow it, for FOUR jobs
in one commit. Root has fast-forwarded `main` to the car 6 head `f425e79c52eef094b94033ad96fbbae0705d8a50` (check
`git rev-parse main` equals it and the tracked status is clean; if not, stop and report).

| car | job | plan / ledger | HANDOFF heading placeholder | paste check |
|---|---|---|---|---|
| 3 | djtrees-strip-edge | `2026-11-02-djtrees-strip-edge` | "build <merge>" | 3cu |
| 4 | djtrees-top-align | `2026-11-02-djtrees-top-align` | no build in the heading: add "build <BUILD>; " before "3cn owed" | 3cn |
| 5 | djtrees-faint-picture | `2026-11-02-djtrees-faint-picture` | "build <finisher>" | 3cv |
| 6 | djtrees-panel-edge | `2026-11-02-djtrees-panel-edge` | "build set at the merge" | 3cj |

- BUILD: read `src/shared/build.ts` (it should be `2026-11-02.2`) and set the next free one (expected `2026-11-02.3`).
- Move all four ledgers (`git mv .superpowers/sdd/<plan>/progress.md docs/plans/<plan>-ledger.md`); fill all four
  HANDOFF headings with the new build. Also fill any "build <merge>"/"<finisher>"/"set at the merge" placeholder those
  four sections carry in their End-of-run check list entries (3cu, 3cn, 3cv, 3cj).
- Commit message: `Build <BUILD>: DJ Trees strip edge, top-aligned pairs, faded pictures, panel edge (djtrees-strip-edge, djtrees-top-align, djtrees-faint-picture, djtrees-panel-edge)`.
- Push main. `origin/main` must equal main.

## CLAUDE.md (main folder; never staged)

Status: set `Current build \`<BUILD>\``, and add at the top of the feature list, one line each (shorten if needed, keep
the paste check):
- `**<BUILD> djtrees-strip-edge:** a carousel strip Figma leaves unclipped runs its cards on to the window's right edge
  from 992 up, its first card where drawn. Paste check **3cu**.`
- `**<BUILD> djtrees-top-align:** label/value pairs stacked as label over value line up at the top once a value wraps.
  Paste check **3cn**.`
- `**<BUILD> djtrees-faint-picture:** a picture shown from its own file keeps its fill's opacity (the FAQ tree is
  faint again). Paste check **3cv**.`
- `**<BUILD> djtrees-panel-edge:** a panel drawn against a section's side reaches the window's side on screens wider
  than 1440; its words stay in place. Paste check **3cj**.`

Decisions (section "Decisions the user made"): in the **Sideways scrolling** block, add one sub-bullet: `**A strip
Figma leaves unclipped runs on to the window's edge** (DJ Trees designer note 12, 2026-11-02; the planner's ⭐ answers
under Justin's "whatever the planner agent recommends", not yet confirmed): from 992 up its cards run on to the
window's right edge with the first card where drawn and scrolling stops at the page margin; this replaces 30.7's "the
track stays clipped at its own box" (HANDOFF "DJ Trees services strip").` Under **On screens wider than the design**,
add: `**A panel against a section's side reaches the window's side** (DJ Trees designer note 1, 2026-11-02, ⭐ answers
not yet confirmed): above the Container's width its colour, drawing or grouped photo continues to the window's edge;
words and buttons stay in the Container.` Nothing else.

Also: the Status's "Paste checks owed" line needs no change. Return as djtrees-postmerge-common.md says.
