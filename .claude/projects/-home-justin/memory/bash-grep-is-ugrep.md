---
name: bash-grep-is-ugrep
description: "In Claude Code's Bash tool on the desktop, grep is a shell function that runs ugrep; large bounded repeats fail, use /usr/bin/grep"
metadata:
  node_type: memory
  type: reference
  originSessionId: e126e11b-3efb-4c0a-ba28-710cd6032a81
  modified: 2026-11-10T02:52:56.641Z
---

In the Bash tool on the Windows desktop (WSL), `grep` is a shell function that calls ugrep, not GNU grep (`type grep` shows the function; GNU grep 3.12 is at `/usr/bin/grep`).

Patterns with large bounded repeats fail there: `grep -o '.\{0,3000\}x.\{0,3000\}'` gives `ugrep: error: error at position 81` (also seen as "exceeds complexity limits"). Small bounds like `\{0,200\}` work.

For context snippets around a match in big files (transcripts, logs), call `/usr/bin/grep` or use a short Python script. Related: [[jq-regex-quadratic]].

Proven 2026-11-09: reported by the dream-pass trial extractor (two failed calls) and reproduced in the main session.
