---
name: old-site-gallery
description: "The client's old Elementor site and the Gallery page paste: 38 photos, rebuilt 2026-10-26 as AVIFs in the new site's Media (ids 837–874) with alt text"
metadata:
  node_type: memory
  type: project
  originSessionId: a8135949-0238-4602-bd14-d891c995aaa9
  modified: 2026-10-26T10:00:00.000Z
---

The client's current public site is `alltypehydrauliccylinder.com` (WordPress + Elementor). The new Bricks site
([[site-and-team]]) is meant to replace it. On 2026-10-23 Justin asked for that site's /gallery/ photos only (the new
site has its own header and footer). They went on the clipboard as a hand-built Bricks paste: the plugin's
`site-header-room` spacer, copied from a `--site=header` replay, then a Section (#141619, padding 96/64/48) and a
`site-container` Container holding a Div. The Div is a CSS-columns masonry (3 / 2 at ≤991 / 1 at ≤478, 16px gaps) of
38 Image elements. That first paste hotlinked the photos from the old domain (`{url, external: true}`).

**2026-10-26: rebuilt as AVIF.** Justin asked for the same page with AVIF photos, uploaded by me, with alt text from
his alttext.ai key. The 38 photos are now in the new site's Media as `gallery-01-image.avif` … `gallery-38-image.avif`
(ids 837–874, page order), each with alttext.ai alt text in WordPress's alt field. The new paste uses their Media ids
(`sourceUrl` = the site, so Bricks keeps them) and the plugin's `focus-ring`/`site-container` classes (same ids, so no
class dialog). A copy is at `C:\Users\Admin\Downloads\gallery-avif-paste.json` on the Windows desktop.

**How to apply:** if the Gallery page still shows `alltypehydrauliccylinder.com` photos, Justin hasn't pasted the
AVIF version yet; the old domain going away would break them. The new site's header is `position: fixed` (88px at
1440, 109px at 390), so a paste with no spacer starts hidden under it.
