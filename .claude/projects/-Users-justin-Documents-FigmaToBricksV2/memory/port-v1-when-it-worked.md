---
name: port-v1-when-it-worked
description: "When the user says v1 handled something, port v1's approach instead of designing new UI or asking questions"
metadata:
  node_type: memory
  type: feedback
  originSessionId: dfef7378-8cc0-42a5-af3a-b9c1d1362d1b
  modified: 2026-10-20T00:07:56.681Z
---

When the user remembers that v1 (`~/Desktop/figmaplugin`) handled a feature, read how v1 did it and port that approach
(as general v2 logic). Don't propose a new panel feature, and don't open an AskUserQuestion about alternatives.

**Why:** On 2026-10-19 (hero video black), I planned a new panel "Videos" box with uploads and asked two questions. The
user rejected the questions, re-sent the bug report, then said "hey just do what v1 did". v1's way was an address in the
layer name or its Open link.

**How to apply:**
- Look in `~/Desktop/figmaplugin/code.js` first.
- Carry over v1's rules, keeping v2's architecture: structure first, names as a hint.
- Say plainly what the user must do in Figma, such as renaming a layer.
- Use rulings, not questions, for small gaps. See [[run-without-stopping]] and [[v2-rewrite]].
