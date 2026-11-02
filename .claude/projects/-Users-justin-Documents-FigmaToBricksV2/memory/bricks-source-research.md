---
name: bricks-source-research
description: "How to find a Bricks element's real shape without Justin's copy (GPL source on GitHub, his sites' assets, schema); which Bricks version each site runs (2026-11-02)"
metadata:
  node_type: memory
  type: reference
  originSessionId: 8e80bfe0-369d-4e32-84a6-8d63e5215658
  modified: 2026-11-02T19:26:16.620Z
---

**Finding a Bricks element's shape without Justin's sample** (djtrees-phone-menu researcher, 2026-11-02, after Justin
said "tell number 2 to do research and to find it"): public GPL copies of Bricks' PHP are on GitHub (`gh search code
'Element_<Name>'`), up to 2.2 as of 2026-11. Prove they hold for his version by comparing the minified JS functions
and element CSS byte for byte with his live site's public theme assets (`/wp-content/themes/bricks/assets/...`), and
the control keys with academy.bricksbuilder.io's resolved schema; a Wayback `id_` snapshot from before a release shows
what live sites printed then. The Nav (Nestable) candidate built this way:
`~/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu/research/` (63 checks pass). Justin's own copy (and the
live round trip) still beats a researched candidate.

**Bricks versions by site (2026-11-02):** darksalmon (his main site, the `reference/bricks/` baseline) 2.3.9; DJ Trees
staging 2.4.4; B-Dry staging 2.4.2; khaki-finch 2.4.1. 2.4.x wraps settings selectors in `:where()` and has a newer
nav JS. Related: [[site-and-team]], [[reading-the-live-site]].
