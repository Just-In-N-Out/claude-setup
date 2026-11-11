---
name: no-banner-on-evidence-images
description: "Evidence screenshots (ClickUp, PRs) show only the result, with no explanatory banner, label or note about how the image was made"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e3537075-7b25-4c2b-a45d-3e318d6f86d8
  modified: 2026-11-11T01:00:43.117Z
---

Evidence images show the result only. Never put a banner, header, caption or note on the image itself. That rules out:
- "Local rendering, not the app window"
- test or helper names (`TestZZFixer3DumpRestorePreview`)
- "stub bridge" or "shipped index.html, sync.js and style.css"
- head SHAs, or "other panels hidden"
- "page-only edits", "home path shown as ~", "N lines elided"

How an image was made goes in the local receipt or log, never on the picture that goes to ClickUp.

**Why:** on 2026-11-10 Justin sent a crop of the posted 86bctmuwy Restore preview image (`restore-preview-agent-warning-556dba9.png`), which had exactly such a banner, and said: "for future sessions make sure it does not mention this or say this".

**How to apply:**
- Write this rule into every builder, fixer, verifier, auditor and finisher brief that renders an image.
- Before anything is posted, a finisher checks every attachment for such text, and re-renders the image without it.
- The rule is in `feature-dispatch/references/ac-verification.md` ("No banner on evidence images").

Related: [[claude-code-headless-agent-runs]], [[lead-status-with-story-name]]
