---
name: importer-test-steps
description: "When giving Justin steps to test an importer paste of an Elementor site (bdryswi.com), use --elementor; the plain route drops site scripts so the FAQ stays still"
metadata:
  node_type: memory
  type: feedback
  originSessionId: a492f614-99ad-4c9d-89a6-3356eed047b1
  modified: 2026-11-09T10:12:38.234Z
---

When handing Justin `npm run site` steps for an Elementor-built site (bdryswi.com, B-Dry), include `--elementor`.

**Why:** 2026-11-09 I told him to leave `--elementor` off; his staging paste then had a dead FAQ ("Some stuff do not work, like the faq") because the plain code route drops the site's scripts and only the Elementor step makes the FAQ a Bricks Accordion. He also saw tablet/phone looking bad on the plain route although `site:check` said ≤2 px — an open question (our renderer vs real Bricks) to investigate with his screenshots, not to dismiss.

**How to apply:** test steps = capture → `site:check --all` → `npm run site -- <capture> <out> --elementor` → `clip.exe < <out>/page.json` per part → LiteSpeed Purge All. Say plainly which fixes each route carries. Related: [[importer-whole-page-paste]], [[deliverable-first]].
