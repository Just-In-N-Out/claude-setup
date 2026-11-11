# The four parity jobs (each planner reads parity-planners-common.md first, then its own section)

## importer-parity (Full) — the website importer builds what the Figma plugin builds
Plan `~/.hermes/plans/figma-to-bricks/importer-parity.md`; evidence `…/evidence/importer-parity/planner/`. Gaps 1, 3, 4, 5,
8 and "Button style" of the audit, for every scanned site: (a) the site's accessibility names (aria-label, role, title,
tabindex, alt on linked icons) kept, as the plugin writes them (`emit/elements.ts:157-170`, `emit/cta-names.ts`); (b) a
site menu as Bricks Nav (Nestable) with its Toggle, from `reference/bricks/nav-nested.json` and the plugin's
`emit/nav.ts` (reuse, don't fork) — site-no-div's deferred "site-nav", and how it meets site-menu's Offcanvas and
site-menu-motion's slide; (c) Bricks Form (`form-basic.json`, `form-schema.json`, the plugin's `emit/form.ts`; what a
site form posts to — ⭐ recommend a Bricks form that emails like the plugin's, the site's action named) and Bricks Video
(`video-schema.json`, `emit/video.ts`) instead of Code; (d) Divider, Accordion and Slider on non-Elementor sites by
structure (`<hr>`, `<details>`/ARIA accordion patterns, a scroll-snap or known slider library's markup) as the plugin
finds them; (e) Bricks settings instead of custom CSS for border, radius, shadow, position, overflow, flex-item, and hover
as Bricks `:hover` controls (`emit/states.ts`), only where printed CSS stays identical (computed-style diff, as
site-shared-styles proves); (f) a painted Button gets `style: "primary"` (or the closest Bricks style) as ExampleBricks,
with the look kept 1:1 (site-native-structure chose no Style: say what changes). Split into milestones if large; each
importer paste looks the same at every width (`site:check`, Bricks 2.4.2 and 2.3.9); Figma replays byte-identical.

## plugin-parity (Full) — the Figma plugin builds what the importer will build
Plan `~/.hermes/plans/figma-to-bricks/plugin-parity.md`; evidence `…/evidence/plugin-parity/planner/`. Gaps 2, 6, 10 and
site-no-div's divergence: (a) shared classes for text, buttons, boxes and layouts from what elements draw, even when the
designer made no Figma text styles (GRO: 0 typography classes), reusing site-shared-styles' grouping rule where it fits
the plugin's pipeline (style stage makes the class, only `adapt/rules/` writes breakpoint styles; text styles from Figma
keep their names); (b) a Structure-panel label on every Section and Block a designer didn't name (by role/first words, as
site-no-div's labels); (c) Blocks instead of Divs where a Div is only a frame (`understand/node.ts:25,126`) — keep a Div
only where Bricks needs it (pictures inlined as backgrounds, per CLAUDE.md) and say why; (d) the sticky header gets the
`overflow-x: clip` guard site-sticky-header proved (prove first with a plugin paste under `html, body { overflow-x:
hidden }`: the audit's gap 10 is a suspicion); (e) Offcanvas/pop-ups now that `reference/bricks/offcanvas.json` exists —
⭐ recommend a separate later job unless small. Desktop exact at the design width; corpus no worse; every change to
Figma replays named and justified (this job changes them on purpose: the plan says which pastes move and how).

## shared-palette (Mini) — one colour, one palette name, from both tools
Plan `~/.hermes/plans/figma-to-bricks/shared-palette.md`; evidence `…/evidence/shared-palette/planner/`. The plugin names
palette colours after Figma or `color-<hex>` in "<file> (Figma)" (`normalise/colors.ts:87-97`, `emit/palette.ts`); the
importer (site-shared-styles) plans `--home-<hex>` in "home (bdryswi.com)": the same blue pasted from both becomes two
palette colours. Settle one naming both use (⭐ recommend one site-wide palette keyed by hex, Figma's own colour names kept
as labels), how a second paste on the same site reuses an existing palette colour instead of adding one, and Bricks' import
behaviour for an existing id (read Bricks' code: `bricks-source-research` memory, assets.php L742-871). Small: if it can't
be done without changing site-shared-styles' plan, say so — it may fold into that job's build as an amendment.

## bricks-icons (Mini; escalate to Full if big) — icons as Bricks' Icon element on both sides
Plan `~/.hermes/plans/figma-to-bricks/bricks-icons.md`; evidence `…/evidence/bricks-icons/planner/`. ExampleBricks has 10
Icon elements; neither tool emits one (the plugin draws icons as SVG/pictures; the importer keeps an Elementor icon widget
as page code). There is **no Icon sample** in `reference/bricks/` (`README.md`): find the Icon element's shape in
ExampleBricks (repo root, one Bricks 2.3.9 copy per line) and Bricks' GPL source (memory `bricks-source-research`) —
never from memory; an SVG icon (from the media library or inline `svg` setting) vs an icon-font icon (Font Awesome,
Ionicons, Themify, which Bricks ships); which icons qualify (a drawn single-colour vector at icon size; a site's `<i
class="fa…">` or inline svg); colour and size as Icon controls; hover. ⭐ recommend the SVG route if icon fonts can't match
the drawing 1:1. If no reliable shape can be proven, say what sample Justin must copy (one Icon element) and stop at that.
