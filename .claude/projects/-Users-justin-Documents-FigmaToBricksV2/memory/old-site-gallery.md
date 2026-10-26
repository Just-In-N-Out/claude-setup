---
name: old-site-gallery
description: "The client's old Elementor site and the Gallery page paste (2026-10-23) whose 38 photos still load from the old domain"
metadata:
  node_type: memory
  type: project
  originSessionId: a8135949-0238-4602-bd14-d891c995aaa9
  modified: 2026-10-23T19:38:17.824Z
---

The client's current public site is `alltypehydrauliccylinder.com` (WordPress + Elementor). The new Bricks site
([[site-and-team]]) is meant to replace it. On 2026-10-23 Justin asked for that site's /gallery/ photos only (the new
site has its own header and footer). They went on the clipboard as a hand-built Bricks paste: the plugin's
`site-header-room` spacer, copied from a `--site=header` replay, then a Section and a `site-container` Container holding a Div. The
Div is a CSS-columns masonry (3 / 2 at ≤991 / 1 at ≤478, 16px gaps) of 38 Image elements set to
`{url, external: true, filename}`.

**Why it matters:** the photos are **hotlinked from the old domain** and aren't in the new site's Media library. If
the old site goes away or the domain moves to the new site, the Gallery photos break. The fix is to upload them to
Media and rebuild the paste with their ids.

**How to apply:** before a domain switch, or when the Gallery shows broken photos, check that this was done. The new
site's header is `position: fixed` (88px at 1440, 109px at 390), so a paste with no spacer starts hidden under it.
