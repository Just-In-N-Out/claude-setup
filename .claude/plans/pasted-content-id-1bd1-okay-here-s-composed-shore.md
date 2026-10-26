# Website-building rules for Figma to Bricks: research and plan

## Context

The director pointed at W3Schools' *HTML5 semantic elements* and W3C's *WCAG*. The ask is not legal compliance. It is
the **technical rules for building a website**: which HTML element each part of a page should be, how text and layers
are ordered and nested, and how a page stays usable by keyboard, screen reader, zoom and search engines. Every page
the plugin builds should follow those rules **and still look exactly like the Figma design**.

Today's output is visually faithful but structurally flat:
- every section is a `<section>`, with no `nav`, lists or `button`;
- heading levels come from font size alone (40px and up → h1, so a 48px "250+" stat is an h1);
- clickable things are `<a>`, often `href="#"`;
- alt text is the raw layer name and is only sent to the media library;
- icon-only links have no name;
- only "more than one H1" is checked.

### Decisions made (2026-10-02)
- **The design breaks a rule** (faint text, small tap target, tiny text): **warn, keep the look**. The panel lists each
  problem (where it is, which rule, how to fix it in Figma) with a **Show** button that selects the layer. Colours and
  sizes are never changed.
- **Things the rules need that Figma never shows** are added where mouse and touch users never see them:
  - the focus ring appears on keyboard focus only (`:focus-visible`);
  - motion fallbacks apply only under `prefers-reduced-motion`;
  - a pause control for endless motion appears only when tabbed to.

  *Skip link:* Bricks already outputs one (`.skip-link` → `#brx-content`), so the plugin adds none and only checks
  nothing covers it.
- **Alt text**: Figma annotation, then saved text, then a descriptive layer name. After that, the panel lists every
  remaining photo with a text box and a "decorative" tick.
- **Pop-ups and dropdowns** move from hidden checkboxes and radios to the browser's built-in `popover` + `popovertarget`
  (no script; all browsers since 2024). This is the **last phase**, after a Bricks test page proves the attributes
  survive. Component states stay on radios, and the phone menu stays on Bricks' Toggle. This amends the CLAUDE.md
  interaction decision, so update CLAUDE.md when it lands.

---

## The rulebook (research)

Sources:
- W3Schools semantic elements
- WHATWG HTML (content models)
- MDN headings
- W3C WAI tutorials (page structure, headings, menus, images)
- WAI-ARIA Authoring Practices
- WCAG 2.2 Understanding docs
- Google Search Central SEO starter guide
- web.dev (Core Web Vitals, layout shift, lazy loading)
- Bricks Academy (element schema, accessibility, release notes)

### Already handled by Bricks and WordPress (the plugin must not duplicate them)
| Rule | Who |
|---|---|
| One `<main>` | Bricks wraps content in `<main id="brx-content">`. **The plugin never emits `main`.** |
| Skip link (WCAG 2.4.1) | Bricks adds "Skip to main content" automatically. |
| Page header and footer | Bricks Header/Footer templates. HTML forbids `header`/`footer` inside `header`/`footer`, so the plugin emits neither. Instead, the checklist says to paste the top bar and footer into those templates. |
| `<html lang>`, `<title>`, meta description | WordPress, listed in the panel's "before you publish" checklist |
| Image `width`/`height` (no layout shift) | WordPress/Bricks, from the media item |

### 1. Semantic elements (W3Schools list, checked against WHATWG)
| Element | Rule | Plugin rule (from structure; an annotation overrides) |
|---|---|---|
| `nav` | Major link blocks only; each nav needs a distinct `aria-label`; `ul > li > a` | Top bar link row (`navOf`), footer link groups of 3+ short links |
| `ul`/`ol` + `li` | Repeated items are a list | Nav links. Later, rows and grids of 3+ alike siblings |
| `section` | Themed group | Page sections, as today |
| `figure`/`figcaption` | Photo and its caption | A photo with one small text directly under it (optional, later) |
| `details`/`summary` | Disclosure | Already used for FAQs |
| `button` vs `a` | `a` goes somewhere; a button does something | A destination gives `a`; open/close gives button (popover phase); **no destination gives no fake `#`** |
| `article`, `aside`, `time`, `mark`, `address` | — | Only from an annotation. They can't be detected reliably. |

### 2. Headings and text order
- Text that **looks** like a heading must be one (WCAG 1.3.1). Big text that isn't one (stats, prices, button labels,
  long lead paragraphs) must not be.
- One `h1`, no skipped levels, and the level never chosen for size: h1 for the page title, h2 for section titles, h3 for card titles.
- Several paragraphs are separate `<p>`s.
- **DOM order is reading order** (WCAG 1.3.2, 2.4.3). Screen readers and the Tab key follow it.

### 3. Nesting rules (WHATWG)
- `a` and `button` may not contain `a`, `button`, `label`, `details`, inputs or `tabindex`.
- `label` may not contain another `label` or a second control.
- `p` holds text only.
- `ul` children are `li`.

### 4. WCAG 2.2 AA rules a converter controls
| Rule | Today | Phase |
|---|---|---|
| 1.1.1 Alt text and icon-link names | Raw layer name; icon links unnamed | 3, 4 |
| 1.3.1 Structure in markup | Mostly missing | 3, 5 |
| 1.3.2 / 2.4.3 Reading and focus order | Absolute layers follow Figma's paint order | 3 |
| 1.4.3 Contrast 4.5:1 (3:1 for ≥24px or ≥18.66px bold) | Not checked | 1 (warn) |
| 1.4.5 Images of text | Mask groups and maps flatten text silently | 1 (warn), and the words go into alt |
| 1.4.12 Text spacing | Text boxes already grow (`_heightMin`); only clipping boxes are fixed | 1 (warn where text can be cut) |
| 2.1.1 Keyboard | Hover-only dropdowns can't be reached | 2 |
| 2.2.2 Pause, stop, hide | Marquees, autoplay and loops can't be paused | 1 (warn), 2 |
| 2.3.3 Reduced motion (best practice) | Gaps: accordion, hover transitions, background video | 2 |
| 2.4.4 Link purpose | `#` links, nameless links | 1, 3 |
| 2.4.7 Focus visible | Only labels have a ring; strokes drawn as `outline` hide the browser's ring | 2 |
| 2.4.11 Focus not obscured | Per-anchor `scroll-margin-top` only | 2 |
| 2.5.8 Target size 24×24 or spacing | 44px tap areas on touch screens only | 1 (warn) |
| 4.1.2 Name, role, value | Checkbox pop-ups announce as "checkbox" | 6 |

### 5. Search and speed (Google, web.dev)
- Descriptive alt, real text instead of text in images, and link text that names the target.
- Unique title and meta description (WordPress checklist).
- Core Web Vitals targets: LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1.
- Never lazy-load first-screen photos. Give the main one `fetchpriority="high"`.

### Deliberately not done
- **rem font sizes.** WCAG doesn't need them, and Bricks sites may set `html{font-size:62.5%}`, which would make them wrong.
- **Auto-fixing colours or sizes.**
- **A "compliant" badge.** The plugin reports what it checked, never "compliant".

---

## Implementation

**Architecture.**
- **New tags and attributes go in post-passes on the finished element tree, never during the build.**
  `wireTriggers` (code.js:4874), `wireToggle`, `wireOverlays` and `addDropdown` treat any `settings.tag` as "already a
  link" and would stop wiring clicks.
- New calls in `convertRun` (code.js:8067), after `raiseOpenDropdowns` (8180) and before `finalizeCss` (8181):
  ```
  await readStyleNames(ctx)       // style-name lookup moved out of resolveClasses (6939–6950), which keeps only classes
  semanticPass(ctx, elements)     // annotations, heading outline, nav, link names, alt, loading, paragraphs
  nestingPass(ctx, elements)      // HTML content-model checks and repairs
  a11yCssPass(ctx, elements)      // focus ring, scroll-padding, reduced-motion sweep, video poster, pause control
  auditPass(ctx, elements)        // contrast, target size, clipping, motion, headings, links → ctx.findings
  ```
- The result adds `findings`, `images` (the alt list) and `checklist` beside the existing `warnings`.
- An internal `opts.semantics` (default on) turns all of it off, so tests can prove the pixels are identical.

### Phase 0: Groundwork (output unchanged)
- **Findings model.**
  - A `RULES` table next to `NOTES` (code.js:90), each entry `{title, level, wcag, category, fix}`.
  - `finding(ctx, rule, node, data)` next to `note()` (201) records `{rule, level, wcag, message, where, nodeIds, fix}`.
    Synthetic cut ids map to their parent, and state-copy ids map to `origId`.
  - `note()` also records node ids, so old notes become clickable.
  - `buildWarnings` (7070) **still returns strings** (one summary per rule), so `replay.js` `warnings.txt`,
    `snap.js` `report.txt` and existing tests keep working.
- **Panel** (`ui.html`):
  - A `#findings` area after `#warnings` (line 84), grouped into `<details>`: Accessibility, Structure & search,
    Speed, Conversion notes.
  - Each row has the WCAG number, how to fix it in Figma, and **Show**. Show posts `{type:"select", ids}` →
    `getNodeByIdAsync` → `setCurrentPageAsync` if needed → `selection` + `viewport.scrollAndZoomIntoView`.
  - A "Before you publish" checklist: language and title in WordPress, meta description, top bar and footer into
    Bricks Header/Footer templates, H1 when only sections were pasted.
- **Annotations.**
  - `annotationsOf(ctx, node)` reads `node.annotations` in try/catch, falling back to the main component's layer for
    instances.
  - `parseAnnotations` accepts only lines that are exactly a keyword:
    `h1…h6 | p | not heading | alt: … | decorative | label: … | nav[: name] | list | button | link | lang: … | ignore`.
  - Add `annotations` and plugin data to `DUMP_PROPS` (8227) and `dumpNode`, with stubs in `replay.js`, so debug files
    replay them.
- **Renderer fidelity.** `tests/tools/render.js` must honour `tag`/`customTag`/`_attributes`/`altText`/`loading`, set
  `<html lang>`, and use Bricks' real base CSS instead of the blanket `h1…p{margin:0}` (line 116), which hides margin leaks.
- **Bricks test page.** A small JSON built from fixtures. The user pastes it into their Bricks site and we read the
  front-end source to confirm:
  - Block/Div `tag` `nav`/`ul`/`li`/`figure`;
  - Basic Text tags and custom `li`/`figcaption`;
  - `_attributes` (`aria-label`, `aria-hidden`, `fetchpriority`, `tabindex`, boolean `popover`/`popovertarget`)
    reaching the right tag;
  - Image `altText` and whether `""` gives `alt=""`;
  - Image `loading`;
  - Button `tag:"button"` and its default browser styling;
  - the skip link's z-index against the sticky header (100) and pop-ups (9999);
  - Bricks' own `:focus-visible` style.

  Also check in Figma that `node.annotations` is readable in Design mode, and whether `setPluginData` works on
  instance sublayers.

### Phase 1: Audit (warnings only, the look untouched)
`auditPass` writes findings and nothing else.
1. **Contrast 1.4.3.**
   - `textBackdrop(ctx, node)` walks up the Figma ancestors and the siblings painted beneath the text. It composites them
     with the existing `paintOver` (6625) and `paintAt` (7739), and checks each text colour with the existing
     `contrast()` (7728). No rounding.
   - Gradients are checked at the centre and corners, and the worst value counts.
   - Large text is ≥24px, or ≥18.66px at weight 700+. With phone adaptation on, it is checked again at the phone size.
   - Text over a photo or a blend mode gets an info finding: "check by eye".
2. **Target size 2.5.8.** Links, buttons, labels and summaries under 24×24 on desktop whose 24px circle touches another
   target. Links inside a sentence are exempt.
3. **Text that can be cut off 1.4.12.** Text inside a fixed-height `overflow: hidden` box, or text Figma truncates.
4. **Images of text 1.4.5.** A flattened asset (mask group, embed) containing visible text.
5. **Motion over 5 s 2.2.2.** Marquees, autoplay, looping motion and background video.
6. **Links.** `#` links ("this button links nowhere", from the `buttonLink` fallback at 3362) and links with no name.
7. **Headings.** No h1 although the page top was pasted; more than one h1; skipped levels (only explicit layer names or
   annotations can cause them); empty or overly long headings.
8. **Info.** Text under 12px.

### Phase 2: Invisible additions
- **Focus ring.** One rule per section and floating holder:
  `%ID% :is(a[href],button,summary,[tabindex]:not([tabindex='-1'])):focus-visible { outline: 2px solid <ring>; outline-offset: 2px }`.
  - Specificity 1-2-1 beats stroke outlines (`strokeStyles` 920), `:hover` and `outline:none` resets.
  - Ring colour: `#111` or `#fff`, whichever contrasts more with the section background. On photos and gradients it is
    two-tone, with `box-shadow: 0 0 0 4px` in the other colour.
  - Inside clipping parents the ring uses a negative offset.
  - The `currentColor` ring of `labelControl` (4816) uses the same colour.
- **Sticky header.** Replace the per-anchor `scroll-margin-top` (4039) with `html{scroll-padding-top:H}`. This covers
  both jump links and keyboard focus.
- **Reduced-motion sweep.** Every transition or animation without a reduced-motion rule gets `none` under
  `prefers-reduced-motion: reduce` (accordion 5539/5568, hover transitions 3523/3547, menu dimmer). State-carrying
  0s animations are skipped. A background video hides and shows its poster.
- **Keyboard opens hover dropdowns.** `.D:hover > %ID%` gains `.D:focus-within > %ID%` (5253). A trigger that can't
  take focus gets `tabindex=0`.
- **Pause control.** For marquees, autoplay and loops: a visually hidden checkbox that appears only on keyboard focus,
  like a skip link. Its label reads "Pause animation" and it sets `animation-play-state: paused` via `:has()`.
  There is no hover-pause, so mouse users see exactly the Figma motion.

### Phase 3: Structure with no pixel change
- **Heading outline** `headingOutline(ctx, elements)`:
  - **Candidates:** text elements in DOM order, excluding:
    - lists;
    - text in buttons, CTAs and nav links;
    - stats and prices;
    - text over 150 characters or of 2 or more sentences;
    - kickers (a short text right above a bigger heading).
  - **Heading-like** means either:
    - size ≥ 1.2 × the page's body size (the most common size, weighted by characters); or
    - a bold title directly above a lighter paragraph (card titles, WCAG 1.3.1).
  - **Overrides:** annotation → layer name `h1–h6` (existing `namedTag`) → text style name.
  - **Levels:** sizes within 10% form a tier, and a stack assigns levels, so they never skip and alike card titles match.
  - **H1:** exactly one, the largest first-screen heading (`FIRST_SCREEN` 3878) outside the top bar. It is set only when
    the paste contains the page top (page mode, a split page frame, a detected nav row, or `heroOf`). Otherwise the
    largest heading becomes h2 and the checklist says so.
  - **Copies and pop-ups:** state, slider and dropdown copies reuse the tag of the same Figma layer. Pop-ups start at h2.
  - **Margins:** pixel mode is already safe (per-text `_margin: 0` at 3138, section `RESET_SELECTOR` at 83). In other
    modes a retagged text gets the same 0-3-0 `margin:0` neutraliser.
  - **Breakpoints:** `tag` is already shared across breakpoints (`SKIP_KEYS` 7097).
- **Navigation.**
  - `makeNav` (1820) records its row. The smallest box holding every link gets `tag:"nav"` plus `aria-label`
    ("Main" or from the annotation), never the `display:contents` menu panel (1886).
  - Footer link groups (`isFooter` 6324) become navs labelled by their heading.
- **Names for icon-only links and buttons.** An `aria-label` from, in order:
  1. the annotation;
  2. the cleaned layer name ("icon/instagram" → "Instagram");
  3. the link target (host brand, "Email" for `mailto:`, "Phone" for `tel:`).

  Otherwise it is an error finding plus a box in the Phase 4 list. The icon inside gets `aria-hidden`.
- **Images.**
  - `altInfo` replaces `altFor` (673). Order: annotation → saved text → a descriptive layer name (not `DEFAULT_NAME`,
    `GENERIC_NAME`, file or camera names like `IMG_1234`/`photo-15…`/`@2x`, or a lone word like image/bg/hero) → none.
  - Content photos get `settings.altText`; decorative ones get `""` and `aria-hidden`.
  - A flattened layer with text gets those words as its alt.
  - First-screen photos get `loading:"eager"`, and the largest gets `fetchpriority="high"`. A CSS-background hero gets
    an info finding instead.
- **Paragraphs.** A text with 2+ paragraphs becomes an outer `div` holding `<p style="margin:0…">` instead of
  `<span style="display:block">` (`textHtml` ~2957/2985).
- **Reading order.**
  - Applies in `convertChildren` before the absolute loop (6061) and to `addGroup` members (6107).
  - It is a topological sort: a pair keeps Figma's paint order when they overlap (plus 2px, plus 22px for small
    links), share a row band with different horizontal constraints, or either has motion, a hover move or a
    z-index. Among the rest, the next in `readingOrder` (2418) goes first.
  - Pairs that don't overlap can't change pixels.
  - Skipped in breakpoint mode (`ctx.noCut`), and for auto-layout absolute badges.
- **`nestingPass`.** `renderedTag(el)` works out each element's real HTML tag, then the tree is walked:
  - `a`/`button` with interactive content inside: the outer real link wins. An inner link box becomes a div, an inline
    `<a>` becomes a `<span>` with the same style, a stray `tapControl` input (called without a `linkDepth` check at
    4888/4970/5231) is removed, and an inner label is dropped with a note.
  - An outer `#` around a `details`: drop the outer link.
  - Nested labels: move the label's own input first (`labelControl` 4812), which fixes the outer label toggling the
    inner radio.
  - Duplicate `_cssId`s, or a tag `a` without a link: strip them.

  Every repair becomes a "fixed" finding with the layer path.

### Phase 4: Alt-text panel
- The result's `images` list (`nodeId, hash, elIds, name, alt, source, decorative`) is grouped by layer. Icon-link
  names use the same list.
- The panel's "Photos without alt text (N)" shows a thumbnail (from the asset bytes), the layer name, a text box, a
  **Decorative** tick and **Show**. **Apply & copy** patches `altText` in the last payload (`handleResult` ~1199)
  without reconverting, then copies.
- Saved per layer with `setPluginData("f2b", …)`, so it travels with the Figma file. The fallback is
  `figma.clientStorage` keyed by image hash (view-only files, instance sublayers). The next conversion reads it.
- WordPress: when every use of a media item shares the alt, update it with `POST wp/v2/media/{id}` `{alt_text}`
  (same call as ui.html ~538). The element's `altText` always wins, which fixes a cached image reused with another alt.

### Phase 5: Lists and figures (after the Bricks test page)
- Nav and footer link groups become `ul`/`li`, using `wrapInBox` (4847) for link boxes.
- Rows and grids of 3+ alike siblings (same main component or same structure) become lists.
- Neutralise `list-style`/margin/padding (add `list-style:none` to `RESET_DECLS`, and use the 0-3-0 neutraliser
  elsewhere).
- Optional `figure`/`figcaption` for a photo plus caption, neutralising the browser's figure margin.

### Phase 6: Popover (last; needs the Bricks proof)
- Centred and corner pop-ups (`addOverlays` 5321) and click dropdowns (`addDropdown` 5241) get `popover`
  (`auto` when "close on click outside", else `manual`). Their openers become `tag:"button"` with `popovertarget`, and
  closers get `popovertargetaction="hide"`.
- `::backdrop` replaces the dimmer; scroll lock uses `html:has(:popover-open)`; entry uses `@starting-style` +
  `allow-discrete`.
- Button default styles are neutralised (appearance, background, border, padding, font, colour, alignment).
- Timed pop-ups, component states and the Bricks Toggle menu are unchanged.
- Update CLAUDE.md's interaction and stacking decisions to match.

**Every phase:**
- bump `PLUGIN_BUILD` (code.js:25, currently `2026-10-01.10`, so re-read it first);
- add to CLAUDE.md's "Decisions" the four decisions above, and the "never emit main/header/footer, never a second
  skip link" rule.

---

## Verification
- **`node tests/run.js`** passes. Add tests built from generic fixtures in `tests/fixtures.js`:
  - `tests/semantics.test.js`:
    - **Heading tiers:** 56/40/24/16 gives h1/h2/h3; a sections-only paste has no h1; a long 24px lead stays `p`; a 48px
      "250+" stays `p`; an 18px bold card title above body text is a heading; a kicker is `p`; an annotation wins;
      copies match; a breakpoint merge keeps one tag.
    - **Other structure:** nav tag and label; icon-link names from the layer, then from the host; alt precedence and
      decorative; eager first-screen loading.
    - **Reading order:** a heading listed later but higher on the page comes first; overlapping pairs keep Figma's order.
  - `tests/audit.test.js`:
    - **Contrast:** #999 on white is about 2.84 (error); #767676 is about 4.54 (pass); 4.49 is not rounded up; text on a
      photo gives info; large text is re-checked at its phone size.
    - **Other checks:** 2.5.8 spacing; clipped text; a mask with text; a marquee; a `#` button.
  - **Nesting:** an input inside a link is removed; an inline `<a>` in a linked card becomes a `<span>` with the same
    style; nested labels have their own input first; `_cssId`s are unique.
  - **CSS:** the ring rule and its colour; reduced-motion overrides; the timed pop-up is untouched; `scroll-padding-top`
    is set.
  - **Pixel-invariance test:** fixtures converted with `semantics:false` and `true` may differ only in `tag`,
    `customTag`, heading↔text-basic, `_attributes`, `altText`, `loading`, the moved input index, and CSS from an
    allowlist (`:focus-visible`, `prefers-reduced-motion`, neutralisers, `scroll-padding`).
  - `debug.test.js`: annotations and plugin data round-trip. `ui.test.js`: findings render, **Show** posts `select`,
    **Apply** patches `altText` without reconverting, and the WordPress alt update is sent.
  - `smoke.test.js` still guards the SES rules (no `<!--`/`-->`, no `import(`).
- **Replay** `figma-to-bricks-debug-design.json` and the user's latest debug file with `tests/tools/replay.js`. Diff
  against the previous build: only the allowed keys may change.
- **Screenshots** with `tests/tools/snap.js` at 1440/768/375, with and without the passes: identical pixels. Focus rings
  only appear when tabbing.
- **Browser checks** (headless Chrome over CDP, per CLAUDE.md):
  - press Tab through the page: focus order follows reading order, every stop shows a ring, and nothing is hidden under
    the sticky header;
  - emulate `prefers-reduced-motion`: nothing animates;
  - run axe-core on the rendered page if it can be loaded;
  - check the heading list and landmarks from the accessibility tree.
- **Real Bricks:** the Phase 0 test page on the user's site (view the front-end source), and later one real converted page.
