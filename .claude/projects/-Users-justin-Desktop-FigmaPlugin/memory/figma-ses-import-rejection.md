---
name: figma-ses-import-rejection
description: "Figma's plugin sandbox (SES) refuses to load code.js if any text, even a comment, looks like an import expression or HTML comment"
metadata:
  node_type: memory
  type: project
  originSessionId: 53e85b1e-271a-44d5-a6c7-815e8d5b7c29
  modified: 2026-09-25T20:36:00.165Z
---

Figma runs plugin code in a Hardened JavaScript (SES) sandbox that scans the raw source before running it. The pattern `import` followed by `(`, `//` or `/*` (whitespace and newlines allowed in between), or `<!--` / `-->`, anywhere in code.js (comments and strings included) makes the whole plugin fail to open with "SyntaxError: possible import expression rejected around line 1". The user only sees the toast "An error occurred while running this plugin".

**Why:** Build 2026-09-26.7 broke the plugin because a comment line ended with the word "import" and the next line began with `//`. Node, acorn and QuickJS all loaded the file fine, so ordinary syntax checks missed it.

**How to apply:** Never end a comment line with the word "import" and avoid "import (" in comments and strings. tests/smoke.test.js guards this, so run `node tests/run.js` after edits. When the user reports that the plugin "won't open", ask for the DevTools Console lines first (Figma desktop: Plugins → Development → Show/Hide console).
