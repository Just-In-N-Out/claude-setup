---
name: bricks-pro-standard
description: "Justin's standard for every paste (2026-11-13) — both tools build it like a skilled Bricks builder by hand, easy for a Bricks pro to change; written in CLAUDE.md's Decisions"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 67456e97-9f8e-4083-928f-7bcdbe7e3240
  modified: 2026-11-13T23:21:52.323Z
---

Every paste, from the Figma plugin and from the website importer alike, must look like a skilled Bricks builder made it
by hand: Section → Container → Blocks, Bricks' own elements, labelled boxes, shared purpose-named classes for repeated
looks, settings before custom CSS, palette colours, Bricks' own behaviour before Code, editable content in fields; looks
stay true (exact wins over clean). The six points are in the repo `CLAUDE.md`, top of "Decisions the user made".

**Why:** Justin, 2026-11-13: "make it easy for someone who is really good at Bricks to come in and do changes to a site
… as if someone manually built it with Bricks, with logic in regards to classes, containers and everything", and
"write it so all agents know what I am talking about".

**How to apply:** every planner brief cites the standard and asks the plan to say how its output meets it; every reviewer
and auditor brief asks "would a Bricks pro find this logical and easy to change?". Class names: a short site prefix
(`bd-heading-1`), replacing the 2026-11-07 `<page>__` rule (my recommendation, which he asked for). Related:
[[importer-native-structure]], [[plugin-first]].
