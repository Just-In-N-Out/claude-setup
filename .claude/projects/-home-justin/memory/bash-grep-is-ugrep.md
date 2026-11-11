---
name: bash-grep-is-ugrep
description: "In Claude Code's Bash tool on the desktop, grep runs ugrep and find runs bfs (no relative dates); use /usr/bin/grep and /usr/bin/find"
metadata:
  node_type: memory
  type: reference
  originSessionId: e126e11b-3efb-4c0a-ba28-710cd6032a81
  modified: 2026-11-11T19:13:16.429Z
---

In the Bash tool on the Windows desktop (WSL), `grep` is a shell function that calls ugrep, not GNU grep (`type grep` shows the function; GNU grep 3.12 is at `/usr/bin/grep`).

Patterns with large bounded repeats fail there: `grep -o '.\{0,3000\}x.\{0,3000\}'` gives `ugrep: error: error at position 81` (also seen as "exceeds complexity limits"). Small bounds like `\{0,200\}` work.

For context snippets around a match in big files (transcripts, logs), call `/usr/bin/grep` or use a short Python script.

`command grep` only works where the shell itself runs it. Under `xargs`, `find -exec` or `systemd-run` there is no program called `command`, the call fails, and with `2>/dev/null` the empty result reads as "no matches": use `/usr/bin/grep` there (pipeline-token-diet reviewer 1, 2026-11-10: a search printed nothing, the same search with `/usr/bin/grep` printed 22 hits). Related: [[jq-regex-quadratic]].

`find` is the same trap: in the Bash tool it runs bfs, which rejects relative dates (`-newermt '-2 days'` / `'2 days ago'` → "Invalid timestamp"). With `2>/dev/null` it prints nothing, so a "changed recently?" test reads every folder as old. Use `/usr/bin/find` with an ISO date (`-newermt "$(date -d '2 days ago' +%FT%T)"`). A separate `bash script.sh` gets GNU find, so only inline Bash-tool commands are affected (storage cleanup, 2026-11-11: a pass marked today's in-use agent caches as safe to delete; caught before deleting anything).

Proven 2026-11-09: reported by the dream-pass trial extractor (two failed calls) and reproduced in the main session.
