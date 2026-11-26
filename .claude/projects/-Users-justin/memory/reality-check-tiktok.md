---
name: reality-check-tiktok
description: "Justin's TikTok page for young men (\"Reality Check\"): agreed angle, episode files and the frame-by-frame render method"
metadata:
  node_type: memory
  type: project
  originSessionId: 6cad5e62-bb6a-4880-9fd5-21c8949ef0b6
  modified: 2026-11-26T16:32:26.345Z
---

Started 2026-11-26. Justin asked for a TikTok page "influencing young men" with black pill content. Claude declined to promote the ideology; Justin picked the **reality-check angle** in the question that followed: take a black pill claim young men see online, show where it comes from, check it against the research, end on what the evidence says. Format he picked: vertical short, 45-60 s. "Reality Check" is Claude's working title, not a name Justin chose. Personal project, not Leorna: no Leorna logo or end card.

Episode 1 (the 80/20 rule): `~/Movies/RealityCheck/ep01-80-20-rule-v1.mp4`; source, script and checked citations in `~/Movies/RealityCheck/ep01/` (`script.md` lists each claim with the quoted source line and ideas held back for later episodes).

**How to apply:** a new episode reuses `ep01/` (copy the folder, change `lines.json` and the scenes in `video.html`). Kinetic-text shorts need no screen recording: `tts.py` makes one Kokoro clip per line plus `timeline.json`, `segs.py` finds the pauses, and `render.js` seeks paused Web Animations to each frame time, screenshots at 30 fps and pipes JPEGs into ffmpeg, so text lands exactly on the voice. Check every number against the source text before it goes on screen (PDFs: PDFKit through `osascript -l JavaScript`, since `pdftoppm` isn't installed). Toolchain gotchas: [[demo-video-toolchain-mac]].
