---
name: figma-sandbox-globals
description: "The conversion runs in Figma's sandbox without browser globals like URL, so Node tests and replay can pass while the real plugin misbehaves; how to tell"
metadata:
  node_type: memory
  type: project
  originSessionId: c4e5e145-294c-4d74-ae34-5c5b77589535
  modified: 2026-10-23T05:41:06.126Z
---

`src/core` and `src/plugin` run in Figma's plugin sandbox, which has only JavaScript built-ins plus `figma`,
`console`, timers and `fetch` (Figma's typings). It has no `URL`, `URLSearchParams` or `TextDecoder`. A
`new URL(...)` inside a `try` fails quietly in Figma but works in Node, so unit tests, replay and corpus all pass. On
2026-10-22, PDF buttons got no `download` or new tab in Justin's real pastes (`isPdfAddress` was always false), though
every test was green.

**Why:** I first blamed a stale open panel, wrongly, and had Justin re-paste for nothing.

**How to apply:** when a live paste lacks something replay shows, read the panel's copy (`pbpaste` right after
Convert) and diff it with `npm run replay` on the same design before suspecting Bricks or the panel. Then suspect a
browser-only global in sandbox code. A Bricks copy-back separates Bricks from the plugin. See [[site-and-team]].
