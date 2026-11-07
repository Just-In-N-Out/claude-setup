---
name: jq-regex-quadratic
description: "jq 1.8.1 global regex (scan/splits/gsub/match \"g\") is quadratic in string length; --arg fails above 128 KB"
metadata:
  node_type: memory
  type: reference
  originSessionId: a9335c8b-35f9-4848-b6b7-031b4326a629
  modified: 2026-11-07T15:37:27.497Z
---

jq 1.8.1's global regex functions (`scan`, `splits`, `match` with "g", `gsub`) slow down with the square of the string length: scan 75 KB 222 ms, 150 KB 802 ms; `splits` on 305 KB took 22 s. A single `test()` stays linear. Any hook or script running them over user text (a pasted prompt) must cut the input to a window first. `jq --arg` fails above 128 KB (argv limit per argument): pass large text with `--rawfile`.

**Why:** measured on the desktop 2026-11-07 by the cortexos-memory-hook fixer (R1-1); a 300 KB paste took 58 s before the fix.
**How to apply:** briefs and reviews of shell hooks that parse prompts with jq ([[hook-payload-cwd-drift]]).
