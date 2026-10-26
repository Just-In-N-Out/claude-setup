---
name: site-and-team
description: "The user's live WordPress site, its plugins, the team's tools (WPForms Pro), and the two steps every paste with code or CSS needs"
metadata:
  node_type: memory
  type: reference
  originSessionId: 1e370f6b-aca5-47e8-af66-adb1306ab0e1
  modified: 2026-10-19T20:10:35.368Z
---

The user's site (2026-10-19): `darksalmon-badger-335429.hostingersite.com`.
- **Host and plugins:** Hostinger, WordPress + Bricks. Plugins: LiteSpeed Cache, WP Mail SMTP (forces the From email),
  Yoast, WPForms Pro, AltText.ai, WPCode, Code Snippets.
- **Pages:** the contact page and the services page ("Services Page Final", with the parts inventory list).
- **The team uses WPForms Pro** for forms. The contact page's "Need a Repair" form is WPForms form id **559**, placed with
  a Bricks Shortcode element and styled by `reference/wpforms/need-a-repair-559.css`, pasted in Bricks → Settings →
  Custom code → Custom CSS (it worked).

After every paste:
- If it holds JavaScript (searchable lists, card arrows): Bricks → Settings → Custom code → **Regenerate code
  signatures**, or the code doesn't run.
- After any CSS change: the LiteSpeed icon (diamond) in the WP admin bar → **Purge All**, or the old page shows.

**How to apply:** include these two steps whenever telling the user to test a paste on the live site. See [[user-workflow]].
