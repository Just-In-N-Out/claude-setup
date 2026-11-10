---
name: importer-media-upload
description: "Justin (2026-11-10) wants a scanned page's pictures uploaded to his WordPress media library from the command line, like the plugin does; agents still never run an upload against his site"
metadata:
  node_type: memory
  type: project
  originSessionId: a492f614-99ad-4c9d-89a6-3356eed047b1
  modified: 2026-11-10T10:07:38.373Z
---

Justin, 2026-11-10, after asking how alt text is handled for a scanned page (on `npm run site` pictures stay on the old site's addresses, the old site's alt text in each Image's Custom alt text): "Can we make them upload to my Wordpress media library like how it is in the plugin?" Asked where, he chose **"From the command line"** over "In the Figma panel" (my recommendation) and "Both", and the **Full** pipeline. Job name: `site-media-upload` (plan: `~/.hermes/plans/figma-to-bricks/site-media-upload.md`).

**Why:** he pastes scanned pages from `npm run site`, and wants the pictures and their alt text in his own Media library as with Figma designs, not hotlinked from the old site.

**How to apply:** this is the one tool allowed to write to WordPress, and only when **he** runs it with his own Application Password. His rule "Never write to any WordPress site; GET/read only, and ask me before using any login" still binds every agent and every other tool: agents test the upload only against a local WordPress stand-in, never hold or see his password, and never run it against his staging or any live site (the live check is his). The password must never reach a file, the paste, a log or a command-line argument. Related: [[importer-test-steps]], [[importer-whole-page-paste]], [[site-and-team]].
