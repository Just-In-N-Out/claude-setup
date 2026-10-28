---
name: bdry-home-copy
description: "bdryswi.com home page → B-Dry Bricks site (bdry.staging.growithgro.com, Home id 14): first paste on the clipboard 2026-10-26; slider-autoplay and flip-cards features building, headline-marker and photo-hotspots later"
metadata:
  node_type: memory
  type: project
  originSessionId: 3a0d874a-6f6c-4ea9-8614-1bbe2049f45f
  modified: 2026-10-28T13:30:21.519Z
---

On 2026-10-26 Justin asked for bdryswi.com's home page (WordPress.com + Elementor) as a Bricks paste for the new
B-Dry site `bdry.staging.growithgro.com` (WP user `Justin_GRO`; Home is page 14). This is not the All Type hydraulics
site ([[old-site-gallery]] is that one). The new site's header is not fixed, so the paste needs no `site-header-room`
spacer. It already has global classes named `section`, `container`, `h1`, `h2`, `h3`, `h4`, `text1`,
`cta-btn-orange`…: the paste's own classes must use other names (prefix `home-`).

**Done:** the photos are in that site's Media as AVIFs. 13 were reused: flags 94/92/93, hotspot photo 98, Fee
promotion 103, bee 105, hero slides 30/27/28, concrete 119, crawl-space flip front = 30, truck 89, map 64. 17 were
uploaded as `home-01…17-image.avif` (ids 132–148, each described "AVIF of <source URL>"). The source's alt text is set
on 132, 94, 92, 93, 98 and 105. alttext.ai wasn't needed. The capture of the source page is in
`~/.hermes/plans/figma-to-bricks/evidence/bdry-source/`.

**Icons:** the 6 flip-box line icons are SVG media 149–154 (`home-icon-01…06-image.svg`, white fill baked in); this site accepts SVG uploads over REST.

**First paste (2026-10-26):** built by hand in the session scratchpad (`tools/build.cjs` + `build2.cjs`), 188 elements, classes `home-grow`, `home-text`, `home-fade-in(-up/-left)`, `home-bg-top`; copy at `C:\Users\Admin\Downloads\home-paste.json`. No Code element, so no code signatures; the site has no page cache. A slide's own custom CSS can't use its `#brxe-` id (Splide renames slide ids): use a class.

**Justin's choices:** "Plugin features first". The slider autoplay, the "60 Years" circle drawing itself, the 6 flip
boxes and the photo hotspots stay still in the first paste; each becomes a plugin feature (worktrees `slider-autoplay`,
`headline-marker`, `flip-cards`, `photo-hotspots`; planner briefs in `~/.hermes/plans/figma-to-bricks/briefs/`). On 2026-10-26 Justin narrowed it to two now (slider + flip boxes, "for usage reasons"); the circle and the dots come later. The slider plan is approved (auto-go) and its builder waits on Justin's Bricks slider sample before its emit task. For the hotspot dots: a card next to the dot on
hover/tap. For "Schedule Your Inspection Today!": Justin will make a Bricks popup and name it.

**Status 2026-10-28:** flip-cards merged as build 2026-10-28.1. The paste with the v2 fixes is
`evidence/bdry-paste/home-paste-v2.json`. Justin paused everything and handed the other three features to three Codex
chats, one each. Their prompts are in `C:\Users\Admin\Downloads\codex-prompts\` (they give each feature's head and
next step). Before continuing any of them here, check `git log` in its worktree: Codex may have moved it on or merged
it.

**How to apply:** after Justin pastes, read the live Home fresh and compare it with the source shots; once each
feature merges, rebuild those parts of the paste exactly as the plugin emits them. The headline-marker and
photo-hotspots planners re-dispatch from their briefs when Justin asks.
