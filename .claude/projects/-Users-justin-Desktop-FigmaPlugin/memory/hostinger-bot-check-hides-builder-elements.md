---
name: hostinger-bot-check-hides-builder-elements
description: "On khaki-finch (Hostinger, Bricks 2.4.1) server-rendered elements such as the phone slider silently vanish from the builder canvas when the host's bot challenge answers a render request; the slider JSON itself is fine"
metadata:
  node_type: memory
  type: project
  originSessionId: 9b163290-ad62-4f75-b785-b7d0593a8295
  modified: 2026-09-28T16:11:20.124Z
---

Diagnosed 28 Sep 2026. The plugin's "Phone slider" (slider-nested) on khaki-finch-126327.hostingersite.com showed in the
structure panel but took zero space on the canvas at the phone breakpoint. The slider JSON was byte-identical to a page
where it works; the front end renders the same slides fine (headless Chrome repro). Bricks draws a PHP-rendered element
only after its `render_element` request (REST, fallback admin-ajax) returns JSON; a non-JSON reply hits the error path
and the element is never created in the DOM (`iframe.min.js`: `getHTML` -> `setHTML` never runs). Slides sit in a
`.brx-nestable-children` wrapper that builder.css hides until the shell arrives.

The host answers bursts with LiteSpeed "Bot Verification" (reCAPTCHA, `lsrecaptcha-form`) and Hostinger's "Checking your
browser before accessing" challenge; I got the captcha on `/wp-json/` and on 7 of 8 parallel homepage loads. A paste of
a photo page fires one render request per server-rendered element (slider + every `image`, including the invisible
placehold.co zoom icons), so heavy pages trip the challenge while text-card pages do not.

Confirmed 28 Sep 2026 from the user's DevTools console: ~200 `admin-ajax.php` POSTs (Bricks' fallback after the REST
render failed) answered `403 Forbidden`; the canvas showed nothing for the slider. Reloading the builder (Cmd+R) cleared the 403s and the
slider appeared, so a stale session/nonce (or a temporary host block) was the trigger, not the JSON.

**Why:** don't keep changing slider settings (`height`, `autoHeight`, `_display`) for this symptom; they were never the
cause. See [[bricks-slider-auto-height-collapse]] for the one real settings fix.

**How to apply:** ask for DevTools Network on `render_element`/`admin-ajax.php` (HTML titled "Bot Verification" or
"Checking your browser" instead of JSON) or a console `SyntaxError: Unexpected token '<'`. Fixes are on the host (tune or
whitelist LiteSpeed reCAPTCHA / Hostinger bot protection) or by pasting fewer server-rendered elements at once; reloading
the builder after the block clears redraws everything.
