---
name: bricks-source-research
description: "How to find a Bricks element's real shape without Justin's copy (GPL source on GitHub, his sites' assets, schema); which Bricks version each site runs (2026-11-02)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 8e80bfe0-369d-4e32-84a6-8d63e5215658
  modified: 2026-11-03T09:58:15.540Z
---

**Finding a Bricks element's shape without Justin's sample** (djtrees-phone-menu researcher, 2026-11-02, after Justin
said "tell number 2 to do research and to find it"): public GPL copies of Bricks' PHP are on GitHub (`gh search code
'Element_<Name>'`), up to 2.2 as of 2026-11 (`saqib6571/bricksbuilder` is 2.2; `sinanisler/bricks-temp-repo` is 1.9.6.1, too old).
From a worktree agent, fetch one file per plain call (`gh api repos/<r>/contents/<p> -H "Accept: application/vnd.github.raw" > <scratch file>`); a loop or pipe is refused. Prove they hold for his version by comparing the minified JS functions
and element CSS byte for byte with his live site's public theme assets (`/wp-content/themes/bricks/assets/...`), and
the control keys with academy.bricksbuilder.io's resolved schema; a Wayback `id_` snapshot from before a release shows
what live sites printed then. The Nav (Nestable) candidate built this way:
`~/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu/research/` (63 checks pass). Justin's own copy (and the
live round trip) still beats a researched candidate. Bricks' per-element CSS (`a.brxe-image`, `:where(.brxe-image).tag`,
…) is in each page's `wp-content/uploads/bricks/css/post-<id>.min.css` inside `@layer bricks` (same on 2.3.9 and
2.4.4), not in `frontend-light-layer.min.css` (phone-menu fixer 2, 2026-11-03). That file does hold the generic
rules, e.g. `:where(p){margin-block:0 1.2em}` zeroed on `p:last-of-type`, which the repo renderer's `p{margin:0}`
lacked; Rich Text (`text`) has no Link to or tag control, Basic Text does (rich-text planner, 2026-11-04).

**Bricks versions by site (2026-11-02):** darksalmon (his main site, the `reference/bricks/` baseline) 2.3.9; DJ Trees
staging 2.4.4; B-Dry staging 2.4.2; khaki-finch 2.4.1. 2.4.x wraps settings selectors in `:where()` and has a newer
nav JS. Related: [[site-and-team]], [[reading-the-live-site]].
Rich Text (`text`) prints its words through `Helpers::parse_editor_content` (helpers.php:2732-2803, text.php:85): it strips one outer `<p>`, then runs wptexturize (curly quotes, en dashes, ×, …), wpautop (`<br>\s*<br>` becomes a paragraph break) and do_shortcode; Basic Text prints raw (text-basic.php:79-111). The repo renderer doesn't model it (rich-text review 1, 2026-11-04).

**Bricks Image link shape (native-structure review 1, 2026-11-09):** Bricks' schema (`image.json` 2.4.4) and `image.php` 2.2 make an Image's `link` a select (lightbox | attachment | media | url) with the address in a separate `url` link setting; the plugin writes `link: {type, url}` on Images, which DJ staging 2.4.4 prints with `href`. Unproven on B-Dry staging 2.4.2: a copied linked Image from Justin would settle it (wanted with the Button, Divider and Offcanvas samples).

**From Bricks 2.2's `includes/assets.php`** (site-shared-styles planner, 2026-11-11; saved in
`~/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/planner/bricks-2.2/`): a global class's control CSS is
generated once per element name that carries it, in the order classes are first met (L1012-1068); a colour setting whose
id the site's palette holds prints the palette's `var(--name)`, otherwise its own raw, so `var(--name, #hex)` falls back
before the palette is imported (L845-871); a palette colour `{raw: var(--x), light}` prints `:root{--x: light}`
(L742-834). **The Colors import on 2.4.2** is readable offline in B-Dry staging's saved builder script (`~/.hermes/plans/figma-to-bricks/evidence/site-faq/planner/staging/builder-main-2.4.2.min.js`; search `<name>:function`): `importPalettes` refuses only an existing palette **name**, adds the palette under a new id with the colours' ids as given, and never checks a colour's id or variable against other palettes (so an imported id the site has leaves two colours with one id; the later `:root` var wins); `addColor` by hand refuses a variable name any palette or Global Variable has; a palette colour has no label field (shared-palette planner, `evidence/shared-palette/planner/bricks-import-2.4.2.txt`). The Background control: see media-clickable (L1971-2108).

**More from Bricks 2.2's source** (importer-parity planner, 2026-11-11; `evidence/importer-parity/planner/bricks-2.2/`):
Theme Style button rules out-weigh any class (`:root .bricks-button[class*="primary"]` 0,3,0, `…:not(.outline)` 0,4,0, and
the default background rule 0,4,0 repaints a Button with no Style too). Border control: `border: 0` for four zero widths,
`border: W style colour` for four equal widths with a style, else per side; Box shadow prints `transparent` with no colour
(assets.php L2111-2337). `_attributes` print on the root and replace same-named ones (base.php L1905-1930); the link control
prints rel, title, ariaLabel (L2352-2368); a Toggle-offcanvas Interaction adds tabindex, aria-expanded and aria-label "Open"
only where none is set (interactions.php L640-651). A Nav items child is wrapped in `li.menu-item` only when its HTML
doesn't start with `<li` (container.php `maybe_wrap_nav_link`); `mobileMenu: "never"` prints no mobile-menu CSS.

**Icon element** (bricks-icons planner, 2026-11-11; 2.2 `icon.php`, `base.php` render_icon L4135-4238): prints an SVG only when
`icon.svg.id` names a media file; inlines the file's `<svg>`, drops the root id and inserts its own id and classes at a
fixed offset, so the file must start `<svg ` with no id or class on the root; `icon.width/height/fill/stroke` print as CSS
on the root (assets.php L2596-2640), fill or stroke adds class `fill`/`stroke` (`svg.fill *{fill:inherit}`). Icon CSS
`.brxe-icon{font-size:60px}svg.brxe-icon{font-size:inherit}` is the same in 2.2 and live 2.3.9. Samples with Icons:
`reference/bricks/staff-card.json`, `card-row-and-phone-slider.json`.
