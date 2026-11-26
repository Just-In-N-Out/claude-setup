---
name: leorna-shorts-structure
description: "How Justin wants Leorna demo shorts structured; use a senior's short as inspiration, never a template copy"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 51bd1f8e-43d3-4a53-a378-0bbfa5b778bc
  modified: 2026-11-26T15:15:02.592Z
---

Leorna shorts open with the problem, implied rather than stated, then show the product.

Inspiration is a senior's `~/Downloads/short4-one-tile-two-thousand-laptops.mp4`, given 2026-11-26. It has:
- a "MONDAY · 9:02 AM" ticket counter with complaint bubbles
- "THE OLD WAY" step cards with a stamp
- a teal "...or" pivot
- boxed teal captions and a fake browser bar
- a laptop grid, then a callback to zero, then a teal "L" end card

**Don't copy that template.** Justin's verdict on a version built that way (Short 2 v4): "It's like copy-paste as the short that I linked to you. I need to be a bit more different." Each short needs its own concept and our own look:
- the earlier gradient pill captions (#3ad6f0 → #9b8cff)
- **the original Leorna end card**: the gradient logo square plus a gradient "Leorna." (the `card-end.png` style from `cards2.mjs`). He explicitly wants that logo kept, not the senior's teal "L".

**How to apply:** take only the idea of a problem-first cold open, and invent visuals that fit the feature (e.g. three AI terminals giving conflicting answers). Avoid that short's signature elements. Keep clips at 1× with dissolves ([[demo-video-toolchain-mac]]).

**Flow (Justin, 2026-11-26, on v6):** "they're choppy. In between the transitions, they're choppy", and Short 1 "cuts off" at the end. What I found by measuring, and changed in v7 (he has not yet confirmed v7 fixes it):
- product sections ran far longer than their narration (up to 12 s of screen recording with no voice): trim each section to its voice line plus about 1 s
- dips to black between sections, and jump cuts between punch-in framings: use crossfades only, and one continuous eased camera per section
- cuts ignored the music: snap every cut to the beat grid, start the voice about 0.15 s into the crossfade
- the end-card chord died within a second: let it ring, hold the logo about 2 s after the voice, fade picture and sound together

**How to apply:** build with `build3.py`, `clips3.py` and `music5.py` (copies in `~/Movies/Leorna/build-scripts-v7/`; the scratchpad originals can be wiped).
