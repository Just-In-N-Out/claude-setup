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

**How to apply:** test steps = capture → `site:check --all` → `npm run site -- <capture> <out> --elementor` → give him ONE paste: join header, page and footer (`content` concatenated in that order, `globalClasses` deduped by id; ids were unique, shared classes identical) into `<out>/whole.json` and `clip.exe` it (2026-11-09: three separate clipboard copies confused him, "it is only copying the header") → Regenerate code signatures → LiteSpeed Purge All. `npm run site` has no one-file output yet (offered as a job). Say plainly which fixes each route carries. Related: [[importer-whole-page-paste]], [[deliverable-first]].

**Staging is the judge (2026-11-09):** Justin's B-Dry staging paste (`bdry.staging.growithgro.com/homev2/`, public) showed what our renderer missed: the ☰ menu, hero slider, FAQ open look and Trustindex reviews don't work (site scripts not copied), and tablet/phone look "clumped" in the Bricks editor at 100% but fine zoomed out (a duplicate header, all slides stacked, phone buttons losing colour). He wants: paste once, neat at every size, interactive parts working; "whatever else you find, obviously fix it". Job staging-fit (Full) measures staging read-only against his scan.

**His 2026-11-09 capture is partial at 768–991** (`/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`: read without styles there, e.g. no `box-sizing`): fold and Div counts measured on it under-report (20 "its holder pads" refusals vs 5 on a full stand-in capture; 535 Divs of 1024 elements with native structure). Judge fold rules on a stand-in capture, and expect his re-capture after staging-fit-capture to fold more.

**Since Build 2026-11-14.3** he can also scan, preview, copy and upload from the local app: `npm run importer` (same commands underneath, pastes byte for byte).
