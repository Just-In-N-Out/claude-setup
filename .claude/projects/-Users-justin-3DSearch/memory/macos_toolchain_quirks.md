---
name: macos-toolchain-quirks
description: "On Justin's Mac, brew is blocked by an untrusted mongodb tap and headless Chrome hangs under the shell sandbox; use a scratchpad venv + xhtml2pdf for PDFs"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 6d64c557-d120-4903-85ee-03ec9e382c95
  modified: 2026-07-31T08:50:20.929Z
---

Environment gotchas on Justin's MacBook (observed 2026-07-31):

- **Homebrew is unusable** until fixed: every `brew install` aborts with `Error: Refusing to load formula mongodb/brew/mongodb-database-tools from untrusted tap mongodb/brew`. Fix is `brew trust mongodb/brew` or `brew untap mongodb/brew` — a user decision; don't run it unasked. This also means no pandoc/poppler/weasyprint via brew.
- **Headless Chrome hangs indefinitely** when launched from the sandboxed shell (`--headless --print-to-pdf` never returns, even with `--no-sandbox --disable-crashpad`). Don't burn time on it.
- **Working PDF pipeline**: python3 venv in the session scratchpad → `pip install markdown xhtml2pdf` → markdown→HTML→`pisa.CreatePDF`. Caveat: base-14 Helvetica only covers cp1252 — strip/replace `→ ⌘ ◇ ∈ −` (U+2212) or they render as boxes. Verify output with pypdf text extraction + `sips -s format png file.pdf` (renders page 1 only; poppler/pdftoppm unavailable).

**Why:** rediscovering each of these cost real time.
**How to apply:** reach straight for the venv+xhtml2pdf path for any md→PDF task; mention the brew tap issue to Justin if a brew install is ever needed.
