---
name: importer-native-structure
description: "Justin (2026-11-09) wants the website importer's paste to have the Figma plugin's native Bricks structure (Section/Container/Block, Heading, Rich Text, Button, Image), not \"div div div\""
metadata:
  node_type: memory
  type: project
  originSessionId: a492f614-99ad-4c9d-89a6-3356eed047b1
  modified: 2026-11-09T16:58:52.737Z
---

Justin, 2026-11-09, looking at Bricks' Structure panel after pasting bdryswi.com (three bare "Div" roots): "I want the structure to work like the plug-in when we copy it from Figma to Bricks—how the buttons are laid out, the area stuff we did. I don't want it to be all div div div."

**Why:** the code method (Justin's 2026-11-04 "actual code" choice) copies the site's own elements, so Bricks shows divs everywhere; he edits pages in Bricks and wants the same editable structure the Figma route emits (repo CLAUDE.md "Output style … editable structure first").

**How to apply:** importer jobs aim for native Bricks elements (Section > Container > Block, Heading with tag, Rich Text, Button with icon, Image, Icon, Nestables, purpose-named classes) while keeping the site's look; planned as its own job inside staging-fit's split. Related: [[importer-test-steps]], [[importer-whole-page-paste]], [[website-importer-paused]].
