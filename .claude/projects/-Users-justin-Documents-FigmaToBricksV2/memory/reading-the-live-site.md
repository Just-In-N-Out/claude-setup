---
name: reading-the-live-site
description: "How to read the user's live WordPress pages fresh (LiteSpeed cache) and tell which paste/build made them"
metadata:
  node_type: memory
  type: reference
  originSessionId: 1d702495-4ff2-4399-9c95-592d0cda02f6
  modified: 2026-10-23T20:11:25.862Z
---

The live site (see [[site-and-team]]) sits behind LiteSpeed: a plain `curl` of a page can come back
`x-litespeed-cache: hit`, an old copy. Add a random query (`?f2b=$RANDOM`) to get `miss`, the page as now saved.

- Pages, ids and save times: `/wp-json/wp/v2/pages?per_page=100&_fields=id,slug,link,modified,title` (public; times
  are GMT on this site).
- Content is between `id="brx-content"` and `id="brx-footer"`; the site's header template is `#brx-header`.
- A paste made with "My site already has its header" ticked starts with `section.site-header-room`; none means the
  tick didn't reach that conversion.
- List each section's first words and its top-level children before judging. On 2026-10-23 Home's second section
  held a whole Services page (its header, list and footer). I first called it two pastes stacked, which was wrong: a
  fresh paste into an emptied page gave the same section. The Figma frame itself held the other page, so ask for its
  Layers panel before blaming pastes.
- A page's element CSS (sizes, padding, positions by `#brxe-<id>`) is in
  `/wp-content/uploads/bricks/css/post-<page id>.min.css?ver=…` (the page links it as `bricks-post-<id>-css`). With
  the HTML it rebuilds the Figma structure well enough for generic fixtures when Justin can't send a debug file
  (2026-10-23, the Contact map).
- Chrome over CDP (`test/browser/chrome.ts` `launchChrome`) can load the live URL at 390/600/900/1440 for
  screenshots; a pasted header 73px tall hid behind the 88px fixed site header at 1440 but showed below it narrower.
