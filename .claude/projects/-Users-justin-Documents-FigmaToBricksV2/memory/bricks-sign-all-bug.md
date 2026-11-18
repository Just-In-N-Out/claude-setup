---
name: bricks-sign-all-bug
description: "A pasted Code element (reviews slider, drawer wave) showing another element's content = Bricks 2.4.2 \"Sign all\" bug; how to spot and fix it, and the safe signing routine"
metadata:
  node_type: memory
  type: project
  originSessionId: 67456e97-9f8e-4083-928f-7bcdbe7e3240
  modified: 2026-11-18T14:36:25.361Z
---

**Symptom (2026-11-18, B-Dry staging home):** the footer's Trustindex reviews slider didn't show on the live page, and a small orange × sat under "Customer Reviews". Earlier the same bug put the drawer's wave in the wrong Code element (wave-code, 2026-11-16).

**Cause:** the importer's paste was right (`footer.json`'s Code element "Widget" held the Trustindex loader). Bricks 2.4.2's editor "Sign all" window wrote another Code element's content into it: the drawer's eicon-close SVG, with that element's class `home__open-5__svg-awhi`. This is a Bricks bug, not a merge regression.

**How to spot it cheaply:** compare the Code element in the scan's paste file (`~/Downloads/<scan>/footer.json`, `settings.code`) with what the live page prints in that Section (Justin pastes the HTML from the page source). Different content or classes means the Sign all bug.

**Fix that worked:**
1. In Bricks, Structure → the Code element ("Widget").
2. Remove the foreign class.
3. Paste the original code back in. For the B-Dry reviews that is `<script defer async src='https://cdn.trustindex.io/loader.js?0ba3c27414da21862f7681d05e9'></script>`, with Execute code on.
4. Save, and close the Sign all window without pressing it.
5. Bricks → Settings → Custom code → Regenerate code signatures, once.
6. Check in a private window with `?f2b=<n>`.

B-Dry staging has no LiteSpeed (only Object Cache). Justin confirmed it worked.

**Why:** Justin asked to remember this "in case we get this issue again".

**How to apply:** after every paste, tell him never to press Sign all and to sign from Settings instead. When a pasted widget is missing or wrong, check the paste file against the live page before starting any job. Related: [[bdry-home-copy]], [[site-and-team]].
