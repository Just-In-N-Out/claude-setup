---
name: bdry-home-copy
description: "bdryswi.com home page → B-Dry Bricks site (bdry.staging.growithgro.com, Home id 14): first paste on the clipboard 2026-10-26; autoplay released28.3 with live check3bo owed; local page-artifact status below"
metadata:
  node_type: memory
  type: project
  originSessionId: 3a0d874a-6f6c-4ea9-8614-1bbe2049f45f
  modified: 2026-10-30T03:14:28.583Z
---

On 2026-10-26 Justin asked for bdryswi.com's home page (WordPress.com + Elementor) as a Bricks paste for the new
B-Dry site `bdry.staging.growithgro.com` (WP user `Justin_GRO`; page 14 is the team's own hand-built Home with placeholder FAQ text; our pastes go on /homev2/, page 155). This is not the All Type hydraulics
site ([[old-site-gallery]] is that one). The new site's header is not fixed, so the paste needs no `site-header-room`
spacer. It already has global classes named `section`, `container`, `h1`, `h2`, `h3`, `h4`, `text1`,
`cta-btn-orange`, and on Home `flip-box`, `flip-inner`, `flip-front`, `flip-back`, `circle`, `line`, `horizontal`,
`text-blue`, `yellow-h2`: the paste's own classes must use other names (prefix `home-`; the plugin's flip classes
become `home-flip-*`).

**Done:** the photos are in that site's Media as AVIFs. 13 were reused: flags 94/92/93, hotspot photo 98, Fee
promotion 103, bee 105, hero slides 30/27/28, concrete 119, crawl-space flip front = 30, truck 89, map 64. 17 were
uploaded as `home-01…17-image.avif` (ids 132–148, each described "AVIF of <source URL>"). The source's alt text is set
on 132, 94, 92, 93, 98 and 105. alttext.ai wasn't needed. The capture of the source page is in
`~/.hermes/plans/figma-to-bricks/evidence/bdry-source/`.

**Icons:** the 6 flip-box line icons are SVG media 149–154 (`home-icon-01…06-image.svg`, white fill baked in); this site accepts SVG uploads over REST.

**First paste (2026-10-26):** built by hand in the session scratchpad (`tools/build.cjs` + `build2.cjs`), 188 elements, classes `home-grow`, `home-text`, `home-fade-in(-up/-left)`, `home-bg-top`; copy at `C:\Users\Admin\Downloads\home-paste.json`. No Code element, so no code signatures; the site has no page cache. A slide's own custom CSS can't use its `#brxe-` id (Splide renames slide ids): use a class.

**Justin's choices:** "Plugin features first". The slider autoplay, the "60 Years" circle drawing itself, the 6 flip
boxes and the photo hotspots stay still in the first paste; each becomes a plugin feature (worktrees `slider-autoplay`,
`headline-marker`, `flip-cards`, `photo-hotspots`; planner briefs in `~/.hermes/plans/figma-to-bricks/briefs/`). On 2026-10-26 Justin narrowed it to two now (slider + flip boxes, "for usage reasons"); the circle and the dots come later. The slider sample gate was lifted on2026-10-27 in favour of documented evidence; installed-Bricks proof remains owed. For the hotspot dots: a card next to the dot on
hover/tap. For "Schedule Your Inspection Today!": Justin will make a Bricks popup and name it.

**Status 2026-10-28:** flip-cards merged as build 2026-10-28.1. The paste with the v2 fixes is
`evidence/bdry-paste/home-paste-v2.json`. Justin paused everything and handed the other three features to three Codex
chats, one each. Their prompts are in `C:\Users\Admin\Downloads\codex-prompts\` (they give each feature's head and
next step). Before continuing any of them here, check `git log` in its worktree: Codex may have moved it on or merged
it.

**Capture coverage (checked 2026-10-29):** `tree-*.json` walks only the page (Elementor post 9, ending at the FAQ). The header template (32), the footer template (35: "Schedule A Consultation", the 5 contact steps, "Customer Reviews") and the popups (27 = the ☰ menu; 1453/1458/1542/1731) were missed because the walk stopped at post 9 (they are in the rendered page at every width), so v1–v3 never had them. The page has 34 device-only boxes (`elementor-hidden-*`) and an active laptop breakpoint (1025–1366): 15 show at 1440/1920, 25 at 1200/1366 (the phone-style service cards, not the flip boxes), 18 at 768–1024, 21 at ≤767, so B-Dry comparisons need 1200 or 1366 too (website-importer probe1, `hidden.json`). Staging: header template = post 11 (hand-built in September, logo media 23, not plugin output), footer template = post 41, `/` is the blog list (no front page set), the v3 paste is on homev2 (page 155). The reviews are a Trustindex widget (`cdn.trustindex.io/loader.js?0ba3c27414da21862f7681d05e9`): it loads only after a first mouse move, key, wheel or touch (headless captures must move the mouse), renders on any origin and stops sliding under reduced motion. It slides by `scrollLeft` on an `overflow:hidden` wrapper, not by transform, so a freeze that only stops transforms and slider APIs leaves it on a random card (web-compare noise floor). Headless: `loader.js` arrives ~3s after load, then waits for the first input, fills its place only within 300px of the window and pauses under the pointer: keep moving the mouse with it in view until `.ti-review-item` shows, then rest the mouse off it. bdryswi.com's Roboto 600 face (served from growithgro1.wpcomstaging.com) fails to load, so captured 600-weight text uses fallback metrics. **Since the evening of 2026-10-29 (after a day of agent probes) bdryswi.com answers automated Chrome with a "Checking your browser…" bot page** (its sitemap still reads by plain GET). Hiding the automation flag is refused as bot-check circumvention, so live captures of it are owed to Justin (allow-list the capture or pause the check); agents stop loading it until he does.

**How to apply:** after Justin pastes, read the live Home fresh and compare it with the source shots; once each
feature merges, rebuild those parts of the paste exactly as the plugin emits them. The headline-marker and
photo-hotspots planners re-dispatch from their briefs when Justin asks.

## Slider autoplay closeout — 2026-10-28

Plugin feature released as build `2026-10-28.3` (build979c5b3, pushed records5e2f98b). Justin's sample gate was
lifted: documented Bricks2.4.3 keys were authorized, installed Bricks2.3.9 proof remains live check **3bo**.
His full-wait choice gives the B-Dry hero interval7500/speed2500; three Block slides, source-colour arrows25
(phone24), no dots, gap0, hover/focus pause. This feature's code and push are complete.

New local slider-only paste copy of the v2 base:
`~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/finisher-closeout/home-paste-slider-autoplay.json`.
SHA256 `f342ff5d017e78e9196a6b488d1a8eb1293a9bd6e750f9aa53ef671e4517139a`; 191 elements, original non-hero
content/links/media/classes retained. Structural and geometry checks pass at 13 widths. Final motion/screenshots remain held after a fresh
independent finisher repeated the failure, including an approved escalated blank control: 75 timer ticks,
zero animation frames, frozen CSS timeline and screenshot timeouts on Node 22.23.3 / Chrome 156.0.8078.47.
No capture-freezing policy ran; the underlying cause is unresolved. Renderer proof needs a working control
before it can continue. Treat this unchanged file as a draft, not a visually verified paste. Diagnostics:
`~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/finisher-artifact-proof/report.json`. No live-site write, clipboard replacement or Windows
Downloads overwrite occurred. Preserve any later headline/photo-hotspot updates when combining page artifacts.

## v3 paste — 2026-10-29 (current)

`evidence/bdry-paste/v3/home-paste-v3.json` (sha256 `8c77a931…`, 233 elements): v2 plus the plugin's own output
(main build 28.5) for the hero slider playing by itself, the 6 flip boxes (back: blueprint media 138, a white Button
to the service page) and the 3 photo dots opening cards (words from popups 1458/1453/1542; the dots beat). Nothing else
changed from v2. The plugin's arrow clearance was left out (it pushed v2's heading onto a third line at 390). Chrome
motion was seen; Bricks/iPhone live checks 3bo/3bn/3bp owed. Scripts in `v3/scripts/` (`build-v3.ts`). Supersedes v2
and the slider-only draft.

The `bdry-source/tree-*.json` captures recorded lazy Elementor images unloaded at 767/390 (24px tall, e.g. the Fee picture): a live re-measure must scroll each image into view, set loading=eager and wait for load. Justin's live pages for checks: https://bdryswi.com/ and https://bdry.staging.growithgro.com/homev2/?bricks_preview=1793276386 (our paste is on /homev2/, page 155; his combined header+Home paste is Downloads/bdry-home-with-header.json = header-v1 + v4).

**Trustindex reviews (site-reviews planner, 2026-11-09):** bdryswi.com's reviews are Trustindex's hosted loader (`cdn.trustindex.io/loader.js?<id>`) in an Elementor HTML widget (`f414ab0`); the loader replaces its own `<script>` with `div.ti-widget` + a style, so the live DOM keeps no `script[src]` — read the served HTML to find it. B-Dry staging has no Trustindex plugin.

**bdryswi.com's own heading fonts are broken on the live site** (site-fonts-match planner, 2026-11-11): Elementor's Roboto 600 and
ADLaM Display files point at `growithgro1.wpcomstaging.com` (HTTP 403), so its headings, buttons and menu show the system sans-serif
(Arial/Helvetica); Roboto 400/500/700 come from the accessibility-onetap plugin's files. A paste with real Google Roboto therefore
looks "different" from the official page (Justin noticed it). site-fonts-match ⭐ A copies what visitors see (with a note).
