---
name: bdry-home-copy
description: "bdryswi.com home page → B-Dry Bricks site (bdry.staging.growithgro.com, Home id 14): photos done 2026-10-26, paste not built yet, 4 plugin animation features planned"
metadata:
  node_type: memory
  type: project
  originSessionId: 3a0d874a-6f6c-4ea9-8614-1bbe2049f45f
  modified: 2026-10-26T19:46:01.613Z
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

**Justin's choices:** "Plugin features first". The slider autoplay, the "60 Years" circle drawing itself, the 6 flip
boxes and the photo hotspots stay still in the first paste; each becomes a plugin feature (worktrees `slider-autoplay`,
`headline-marker`, `flip-cards`, `photo-hotspots`; planner briefs in `~/.hermes/plans/figma-to-bricks/briefs/`). The
planners were stopped at the usage limit before writing plans. For the hotspot dots: a card next to the dot on
hover/tap. For "Schedule Your Inspection Today!": Justin will make a Bricks popup and name it.

**How to apply:** resume by building the paste: the scroll fade-ins as the plugin's motion CSS, the accordion as
`accordion-nested`, and the buttons' hover grow. Then re-dispatch the 4 planners from their briefs.
