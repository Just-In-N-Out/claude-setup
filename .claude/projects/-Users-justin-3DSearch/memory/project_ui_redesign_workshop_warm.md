---
name: project-ui-redesign-workshop-warm
description: "\"Workshop Warm\" UI redesign IMPLEMENTED and committed (1f11bba on ui_feature1, 2026-06-11); design tokens + feature list here"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8b56ba1e-9e1f-46a5-b95c-9fcb54c15821
---

IMPLEMENTED and committed: 1f11bba on branch ui_feature1 (2026-06-11), not yet pushed/merged to main as of then. Beyond the re-theme it includes: Storefront layout (static sticky header, no scroll-snap, /browse standalone), animated homepage with studio cards, redesigned search results (sort dropdown, source filter chips, live progress strip, skeletons), rebuilt model detail panel (sticky action card, clickable tags), ⌘K command palette, My Bench (localStorage saves at /bench), and 3D spin-on-hover card previews. Vite proxy: host dev → localhost:8080; docker-compose sets VITE_API_TARGET=http://web:8000.

**Approved design — "Workshop Warm":**
- Light default: bg #FAF6EF cream, surface #FFFFFF, border #E7DECF, ink #2B2926, muted #8A8175, primary orange #E8590C (hover #C74A08), green #2F6F4F, amber #F2B705
- Dark variant behind 🌙 toggle (persisted localStorage, default light): bg #211E1A, surface #2B2722, border #3D372E, text #F2EDE4, orange #FF7A33, green #5BA37D
- Fonts: Bricolage Grotesque (headings) + Nunito (body)
- Homepage hero: "Front Counter" — centered "Find your next print." + pill search + category chips + trending row
- De-vibe: remove cyan→purple gradients, glows, neon grid; logo solid orange; keep old CSS var names with remapped values (--cyan-accent→orange, --purple-accent→amber)
- User also wants: intuitive/easy UI with micro-delights (press squish, card lift, friendly empty states)

**Artifacts:**
- Full implementation plan: /Users/justin/.claude/plans/ok-here-is-the-jaunty-moth.md
- Visual mockups (user-approved): /Users/justin/3DSearch/.superpowers/brainstorm/63867-1781047809/content/ (style-directions.html, hero-layout.html, design-summary.html)
