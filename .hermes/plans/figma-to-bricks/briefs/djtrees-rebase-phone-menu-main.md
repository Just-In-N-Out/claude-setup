# Role: REBASER — djtrees-phone-menu onto the new main (after the importer's merges)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-rebase-common.md` first and follow it (djtrees-common.md:
machine rules, fonts as `data:` URLs with a load check, ticks as a JSON string, bounded mutation runs, named tests need
their `ok` line, never end your turn to wait).

- **Job head:** `408f51c5748491ed165d1321790cf717f00b4e32` (fixer 2: the test renderer now prints a linked Image as Bricks
  does, `<a id class="brxe-image … tag"><img>`; tests run both picture modes; A3 duplicate aspect-ratio). Its own commits
  sit on DJ car 11 `5a5beeb294a9d2f052d5c11a6095df49fd2c4f94`: `5a5beeb..408f51c` (the phone-menu job, 16 + 2 commits).
- **Target:** local `main` = `9212c477…` ("Build 2026-11-02.5": DJ Build .4 `6cfd3e6` + the website importer's wave 1,
  web panel, address box and tiers). Check `git rev-parse main` starts with `9212c477`.
- `git rebase --onto <main> 5a5beeb 408f51c`, then create local branch `train-phone-menu-2` at the new head (work
  detached; never leave a `train-*` branch checked out).
- **Expected overlaps with the importer's code:** `test/browser/render.ts` (fixer 2 changed the linked-Image markup: any
  importer test or web page render that uses it must still pass; if one encoded the old markup, judge it by Bricks' real
  markup and say so), `test/browser/chrome.ts`, `src/core/adapt/rules/index.ts` (keep every rule; `navigation.menu`
  last after `navigationWrap` as before), `src/core/emit/*`, `reference/bricks/README.md`, `docs/HANDOFF.md` (phone-menu
  section on top; keep every section and check-list entry, the importer's 3cx/3cy included; 3ck stays 3ck). Merge by
  meaning; never weaken an approved AC test of either side. If two approved ACs contradict, stop and report the pair.
- **Gates against main:** `npm run check` by name; every phone-menu AC test by name (`ok`, `# pass` ≥ 1, browser
  `skipped 0`), both picture modes; the AC8 DJ Trees receipt (WordPress and inline, ticks off and on; 390 logo ≈40px at
  x16; 991 ≈53px with FREE ESTIMATE beside the ☰); the blast-radius witness (switch off = main byte for byte); 0 rule
  collisions on the six real files; the WHOLE browser suite and the importer's own tests (`test/web` and any web-panel
  tests) on head vs main by name — no test that passes on main may fail on head.
- Write `E/rebase/` (move the old one to `E/rebase-pre-main2/` first): `conflicts.md`, logs, replay diff vs main, the
  value-by-value check that the job's change equals its pre-move change (explain every difference).

E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu`.

## Return

Old head, new head (full SHA), branch, target (full SHA), pure or not, conflicts and resolutions, gates (by name), then
`found_else` and `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
