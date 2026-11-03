# Role: POST-MERGE FINISHER — DJ Trees phone menu (her 12th note), one job

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-postmerge-common.md` first and follow it. Root has
fast-forwarded `main` to the phone-menu head (your prompt names it; check `git rev-parse main` equals it and the tracked
status is clean; if not, stop and report).

- Job: djtrees-phone-menu; plan/ledger `2026-11-02-djtrees-phone-menu`; paste check **3ck** (DJ Trees staging runs
  Bricks 2.4.4; the renderer follows 2.3.9).
- BUILD: read `src/shared/build.ts` (the importer made `2026-11-02.5`; it may have merged again) and set the next free.
- `git mv` the ledger; fill the phone-menu HANDOFF heading's and 3ck entry's build placeholders. Add one line in its
  section: on main the panel's action pill is centred from 767 down by `cta.center` (Build .2), and a bar captured from
  a website gets no phone menu (the importer's `site.tiers` keeps the site's own phone layout).
- Commit `Build <BUILD>: DJ Trees phone menu (djtrees-phone-menu)`; `npm run build` (check the bundle carries BUILD);
  push main; `origin/main` must equal main.

## CLAUDE.md (main folder; never staged; re-read just before editing — the importer session edits it too)

- Status: set the current build; add at the top of the feature list: `**<BUILD> djtrees-phone-menu:** a bar proven to
  be the site's menu folds into Bricks' Nav (Nestable) where it no longer fits: logo left and smaller, ☰ right, a panel
  from the right with the links and the bar's action; a frosted bar keeps its blur. Paste check **3ck** (DJ staging,
  real iPhone).`
- Decisions, under the phone rule "**Menu:** a panel sliding in from the right …": add `**The phone menu is Bricks' Nav
  (Nestable)** (DJ Trees designer note 2, 2026-11-02/03; the planner's ⭐ answers under Justin's "whatever the planner
  agent recommends", not yet confirmed): a bar the plugin proves is the site's navigation folds where its row no longer
  keeps one line; a bar that fits everywhere gets no ☰; a captured site's bar keeps the site's own layout; a frosted
  bar's blur moves to its ::before; built on a researched Nav sample (reference/bricks/nav-nested.json) until Justin's
  own copy replaces it.`
- In "Waiting on the user → Bricks samples": note that a Nav (Nestable) sample was researched (Bricks' code + live
  sites) and his own copy is still wanted to replace it.
- In "Working in this repo", one line: `**Bricks prints a linked Image as its link** (<a id class="brxe-image … tag">
  <img>, a.brxe-image{display:inline-block}); test/browser/render.ts follows it since 2026-11-03 — browser receipts
  that measure a linkable picture run both picture modes.`
Nothing else. If writing CLAUDE.md is refused, save exactly those lines to
`~/.hermes/plans/figma-to-bricks/djtrees-phone-menu-claude-md-pending.md`.

Return as djtrees-postmerge-common.md says.
