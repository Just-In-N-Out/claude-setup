---
name: no-silent-format-fallback
description: User wants photos as AVIF and prefers the run to stop with an explanation over quietly uploading another format
metadata:
  node_type: memory
  type: feedback
  originSessionId: bbd21d69-4f44-4c57-848e-3ffe63b18277
  modified: 2026-09-30T16:30:14.111Z
---

When AVIF is chosen, the user wants every photo in any design uploaded as .avif, including cut-outs, rounded corners and soft-edged photos (only logos, icons and flat graphics stay PNG/SVG), and if the site or browser can't do AVIF the plugin must stop and say why rather than fall back to WebP or the original.

**Why:** Asked twice for AVIF even after being told WebP was simpler, and picked "Stop and tell me" over "Fall back to WebP" (2026-09-30). After build .3 left 22 photos as placeholders in Figma they said "No place holders i want .avif": placeholders are a last resort, so the encoder has to work where the plugin actually runs.

**How to apply:** For image-format features, don't add silent fallbacks to another format; surface a clear message (what failed, how to fix, which setting to switch). See [[avif-encoder-in-figma]].
