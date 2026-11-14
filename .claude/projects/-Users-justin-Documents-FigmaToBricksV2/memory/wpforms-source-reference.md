---
name: wpforms-source-reference
description: Where to read WPForms' code (Lite zip on wordpress.org) and the facts read there — import file shape, read-only forms list route, theme CSS variables
metadata:
  type: reference
---

WPForms' code is readable from the **Lite zip on wordpress.org** (2.0.4 read 2026-11-13; no PHP or Docker on the desktop to run it).
- Import file = JSON list of form data; WPForms → Tools → Import gives a **new form id** and keeps field ids (`.json` name, needs `unfiltered_html`).
- `GET /wp-json/wpforms/v1/forms` lists forms read-only (titles cut at 47 characters).
- A shortcode form prints its own `settings.themes` as CSS variables on `#wpforms-<id>` (modern markup + "Base and form theme styling" only).
- The front end prints `data-field-id` on each field box; Lite's CSS lacks the Smart phone picker's CSS (Pro only).
Evidence: `~/.hermes/plans/figma-to-bricks/evidence/forms-wpforms/planner/wpforms-source-lines.txt`. Related: [[bricks-source-research]], [[site-and-team]].

- WPForms full stylesheet resets every descendant (`div.wpforms-container-full *{visibility:visible…}`): a part hidden with `visibility: hidden` still shows its children (the required mark); hide it with `display: none` or hide the part and its descendants (forms-wpforms builder, 2026-11-14).
