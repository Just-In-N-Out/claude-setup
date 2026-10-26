# FigmaToBricksV2 rules summary (read first; open CLAUDE.md only for sections you touch)

`~/Documents/FigmaToBricksV2/CLAUDE.md` (~98 KB, not in git) wins on conflict. Current state (build, open items, known failures): its **Start here**; finishers update it + "Where things stand" after a merge. Process: `figma-to-bricks` skill.

## Project and pipeline
- Figma plugin: **any** Figma design → Bricks 2.3.9 paste. Rewrite of v1 (`~/Desktop/figmaplugin`, read-only rules source). Spec `docs/specs/2026-10-06-v2-design.md` (read before architecture changes); target `ExampleBricks`.
- `extract → normalise → understand → style → adapt → emit`: extract `src/plugin/extract/` (only caller of `figma.*`) → Snapshot (= debug file); normalise `src/core/normalise/` → Scene; understand `src/core/understand/` → IR; style `src/core/style/`; adapt `src/core/adapt/` (`layout.ts` plan, `rules/`, order in `rules/index.ts`); emit `src/core/emit/` (`payloadProblems` refuses bad output). Panel `src/ui/` (browser APIs via `env.ts`).

## Hard rules
- **General logic only.** Fix the rule, not the instance. Never key on a layer name, ID, text, pixel value, colour, font or section order from the file shown (or corpus files); detect from structure (auto layout, constraints, fills, relative sizes, repetition, clipping); names are a hint at most. Handle variations or fall back safely; add a generic fixture test. Unavoidable special case: explain and ask first; it must detect a condition any file could have.
- **Architecture:** `src/core/` pure, runs in Node on a Snapshot. No stage edits an earlier stage's output, no element changes type, nothing converted twice. CSS typed (`{bp,state,part,decls,origin}`) until emit serialises once; never regex CSS; Bricks control key where one exists, else one `_cssCustom` per element.
- **Only `adapt/rules/` writes breakpoint styles**, each declaration naming its rule; same node+bp+property from two rules fails unless one lists the other in `overrides` (and runs after). One rule per file with a `decision` line; sizes from `PageFacts`, widths from `ctx.layout`, never computed. Write only bp changes, never desktop (except `fluid` tier: `clamp()` exact at design width). Shared behaviour = one purpose-named class. Phone-only copies made only in `understand/phone.ts`. Drawn phone designs run only `fits`/`shows` rules.
- Breakpoints/media/gutters only in `src/shared/breakpoints.ts`. **Deterministic ids**: same snapshot = byte-identical payload; plugin convert = `npm run replay`. Files under ~300 lines, single purpose.
- **Never name another element's id in custom CSS or a script** (Bricks renames ids on paste): use marker classes.
- **SES sandbox** refuses the bundle when `import` is followed by `(`, `//`, `/*`, or `<!--`/`-->` appears anywhere, comments too. Never end a comment line with "import".
- **Tests:** `node --test` on `.ts`: erasable TS only (no `enum`, `namespace`, parameter properties). Prove a new test fails without the fix (`git checkout HEAD~1 -- <fix files>`, then back).
- **Bricks emitters only from `reference/bricks/*.json` samples**, never memory. Owed samples (Nav Nestable, Tabs, Dropdown, Offcanvas+Toggle, Interaction, `popover` Div): wait, don't guess. Anything not in `reference/bricks/` needs a paste round trip first.
- **Bricks facts:** paste `sourceUrl` = site address or pictures go grey; Blocks get `width:100%` (left+right needs `_width:"auto"`); `_direction/_rowGap/_columnGap/_flexWrap`/grid keys only on section/container/block/div, else `_flexDirection`/`_gap`; never `_alignSelf:"stretch"`; Flex basis in px; `[class*=brxe-]{max-width:100%}`; Bricks wraps blocks ≤767px; unattached WP uploads own `/<name>/`, so uploads end `-image`/`-video` and no link is a picture/video file.
- **Git:** branches stay local; never commit CLAUDE.md (check `git diff --cached --name-only`) or the debug JSON. Plain `git commit -m`, author `Justin <issajustin04@gmail.com>`, no override or AI lines. Push `main` only, as Just-In-N-Out via the repo's credential helper; never switch the gh account (Justin-Leorna) or touch remote/helper. One feature per worktree; no bare `git stash`; in a copy never bump BUILD or edit the main folder/copy's CLAUDE.md. Merge `--ff-only`, never force; then bump BUILD, `npm run build`, commit "Build <BUILD>: <feature>", push.
- **Before merge (rebased):** `npm run check` + `test:browser` + `corpus`; a browser failure also on main is named as follow-up, never skipped.
- **Corpus: no file or width worse.** Main already has "Worse than v1" items (count in Start here), so exit code isn't the gate: save report + pastes before Task 1, compare lint, scores (±0.002 noise) and that list at close; no new item. Re-record baseline when the lint changes.
- **Milestone:** plan in `docs/plans/` → test-first with ledger → corpus before/after → one opus review (`git diff main...HEAD`) → one test-first fix pass → ledger to `docs/plans/`, HANDOFF + paste check → report rulings. "Fixed" = user file replayed at every width + lint + corpus.
- **User:** play the problem back in numbered plain words first; ask before trade-offs; "do what v1 did" = port v1, no questions; one screen action at a time; never guess "Waiting on the user" items.

## Tools
- `check` typecheck+build+unit; `test` unit only; `test:browser` Chrome suite (panel tests).
- `replay -- <debug> <out>`: bricks.json, warnings, renders.
- `snap -- <debug> <out> [widths] [--sides] [--detail] [--placeholders]`: paste rendered at 390/768/1024/1440/design, section heights vs Figma, lint, shots; `--sides` Figma-vs-built per section.
- `corpus`: v2 over corpus vs v1 baseline.
- `node tools/trace.ts <debug> <id>… | --layer "<name|id>"`: element origins. `node tools/inspect.ts <debug> [out]`: summary + pictures. `wraps`: one-line texts that wrap.

## Decisions the user made (binding; ask before reversing)
- Native Bricks interactive elements; CSS only for hover/motion. Hover exactly as Figma (tap on phones); motion on scroll-in; never invent motion (except CTAs, photo cards, marquees).
- CTAs (Button ≥32px or painted pill; not row-of-3 tags or menu links): no Figma hover; lift 3px, fade in, hand cursor; colours as drawn.
- Photo cards (2+, any kind) and zigzag listing rows: photo zoom 110% + one glare on hover; cards fade in; Figma hover dropped.
- Logo marquee: loops right at 60px/s, keeps moving under the mouse, one line everywhere.
- Sideways-scroll frames scroll with snap; card arrows glide to the next card.
- Navigate → `/slug-of-frame-name/`; Home… → `/`.
- Tablet: 3, 5… alike cards/grid cells stay one row (≥160px); phone landscape one row (≥120px); portrait stacks.
- States show the variant's look; instances keep only real content.
- CSS hover only where exact (flat colours, outlines, radii, shadows, uniform text style); else states.
- Placed layers follow constraints; default Left in the right half keeps its right distance.
- Stacking keeps Figma order: content z ≤1; hovered component `isolation:isolate`; floating 50/90/100/9999.
- One Container per section, 1440 max (wider designs too), gutters 64/36/16, bps 991/767/478; margin content exact at design width.
- Boxes drawn the same height stay so (row stretch), words at top; alike boxes share smallest bottom padding.
- Wider screens: content centred; full-width art reaches edges; section photo keeps size, edges fade to section colour.
- Buttons by shape alone (painted box, one short centred label).
- Pictures default "inside the JSON" (Divs with CSS background), or to WordPress.
- Drawn phone frame beside desktop: two copies swapped at 767, phone exact; one frame → automatic phones.
- Desktop exact at design width, fluid below; the phone rules and free-floating decoration choices are in CLAUDE.md.
- Website rules never change the look; only invisible extras; never emit `main`/`header`/`footer`/skip link.
- Open: hover component inside a link on phones — ask first.
- Picture descriptions in panel (`f2b-alts`, to WP); alttext.ai writes photo alts; key never in file/paste; no AVIF to it.
- Figma colours → palette file for Style Manager → Colors.
- Forms → Bricks Form by email; team uses WPForms Pro; "Forms become" option waits.
- Every number/email shown is a link; Call/Email buttons take the nearest; none → unlinked, named.
- Page links: whole card; arrows read from drawing; actions never; with WP connected, to the site page named alike.
- A link never opens a picture; plugin moves only its own uploads off link addresses.
- Site header/footer: two panel ticks; header room measured by script.
- Fonts → WordPress Font Library. Hero video: v1's way (address in name/Open link) + WP Media lookup by exact name.
- Lists: "In the page" + CSV in panel; tablets one line per record, phones cards.
- AVIF never falls back silently. Phone slider `height:"auto"`, never `autoHeight`; phone sliders are copies.
- Output: editable structure first (Bricks settings, purpose-named classes, native elements, shallow tree).
- Deferred unless asked: tablet designs, audit list, masks, timer loops.

## Live site and files
- `darksalmon-badger-335429.hostingersite.com` (Hostinger; LiteSpeed, WP Mail SMTP, Yoast, WPForms Pro, AltText.ai): agents read only.
- After a paste with code: Bricks → Settings → Custom code → **Regenerate code signatures**; after CSS: **LiteSpeed → Purge All**.
- Debug files: check `build` + root frame name. Repo-root `figma-to-bricks-debug-page-1.json` on disk ≠ git's: never edit/commit; replay a scratch copy.

## Always open CLAUDE.md for these (the summary squeezes them)
- Phones, tablets, breakpoints, drawn phone designs, phone decorations: the full 'Decisions the user made'.
- Links (page links, call links, card arrows, link-never-a-picture), pictures (upload, alt text, AVIF/WebP, sizing), CTAs, marquees, lists, colours, fonts: the 'Where things stand' entry for that feature.
- Any Bricks element or key not in `reference/bricks/`: the unverified-features list under 'Working in this repo'.
- Website rules stay binding: WCAG 2.2 AA (focus-visible, pause controls, headings from structure, alt text), valid HTML5, SEO. Check the wording in CLAUDE.md before touching them.

## CLAUDE.md section map (`##` only; search bold labels)
- **Build general logic** / **Architecture rules**: full text of the rules above.
- **Start here**: status, latest features, live site, user's files, waiting on user, known bugs, how the user works, **Where things stand** (per feature: code paths, rulings).
- **Working in this repo**: git, **Several agents** (Finish 1–7), checks, BUILD, SES, Bricks facts, **How each milestone runs**, gotchas.
- **Debugging a user's design**: tools, lint, corpus, phone checks.
- **Decisions the user made**: full wording.
- History: `docs/HANDOFF.md` (search the feature heading; paste checks) and `docs/plans/`.
