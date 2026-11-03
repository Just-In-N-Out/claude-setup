# Role: POST-MERGE FINISHER — DJ Trees Build .4 (merge-train cars 7–11; the phone menu, car 12, is NOT in this build)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-postmerge-common.md` first and follow it, for FIVE jobs
in one commit. Root has fast-forwarded `main` to the car 11 head (your prompt names it; check `git rev-parse main`
equals it and the tracked status is clean; if not, stop and report).

| car | job | plan / ledger (`docs/plans/<plan>.md`, `.superpowers/sdd/<plan>/progress.md`) | paste check |
|---|---|---|---|
| 7 | djtrees-stack-gaps | `2026-11-02-djtrees-stack-gaps` | 3cr |
| 8 | djtrees-stack-lines | `2026-11-02-djtrees-stack-lines` | 3co |
| 9 | djtrees-step-sides | `2026-11-02-djtrees-step-sides` | 3cp |
| 10 | djtrees-side-art | `2026-11-02-djtrees-side-art` | 3cm |
| 11 | djtrees-faq-art | `2026-11-02-djtrees-faq-art` | 3cs |

- BUILD: read `src/shared/build.ts` and set the next free one (expected `2026-11-02.4`; the build string keeps the
  feature-batch date even after midnight, as the series does — if `2026-11-03.x` is already used, take its next).
- Move all five ledgers (`git mv`); fill every build placeholder in the five HANDOFF sections' headings and check-list
  entries ("build <at merge>", "build set at the merge", "<merge>", "<finisher>", or a heading with no build: add
  "build <BUILD>; " before "3c? owed"). No placeholder may remain (`grep -nE 'build <|set at the merge'`).
- HANDOFF small edits from the follow-ups (one line each, in the job's section): faq-art: F1 (faded pictures at full
  strength) is now fixed by djtrees-faint-picture (Build .3), and check 3cs's "after djtrees-faint-picture is merged
  too" is met; side-art: check 3cm's step about trees at full strength is out of date (faint-picture merged); stack-gaps/stack-lines: the merged
  rule (on an across tier each lower point keeps its own top, outer sides keep the row's ends; stack-gaps' AC2 and AC3
  narrowed for flat-colour lines on upright phones, where stack-lines' gap 0 and each point's own top apply).
- Commit message: `Build <BUILD>: DJ Trees divided rows, side art, FAQ tree (djtrees-stack-gaps, djtrees-stack-lines, djtrees-step-sides, djtrees-side-art, djtrees-faq-art)`.
- `npm run build`, check the bundle carries BUILD, push main; `origin/main` must equal main.

## CLAUDE.md (main folder; never staged)

Re-read it just before editing. Status: set the current build, and add one short line per job at the top of the
feature list with its paste check (3cr, 3co, 3cp, 3cm, 3cs). Each job's plan has a "Docs & records" (or similar)
section naming its CLAUDE.md lines: use those, shortened to one or two lines each, under "Decisions the user made",
marked "(DJ Trees designer note N, 2026-11-02; the planner's ⭐ answers under Justin's 'whatever the planner agent
recommends', not yet confirmed)". In particular:
- the phone rule "Section intro on phones … a row split by its items' own divider lines loses the lines once it wraps …"
  is REPLACED by the stack-lines/stack-gaps/step-sides rule (stacked points get a line between each pair like the
  designer's dividers, midway; their space; steps under a line line up) — say it replaces the old wording;
- side art / FAQ art: faint art over or near a section's heading moves beside the heading once the layout stacks
  (smaller, under the words where nothing is painted between); a frozen section's top space steps down.
Nothing about the phone menu (not merged in this build). Nothing else. If writing CLAUDE.md is refused, save exactly those lines to
`~/.hermes/plans/figma-to-bricks/djtrees-build4-claude-md-pending.md`.

Return as djtrees-postmerge-common.md says.
