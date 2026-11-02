---
name: tool-escape-quirk
description: In Write/Edit tool parameters backslash-u escapes for a space and for invisible characters (U+200B-200D, U+2060, U+FEFF) and U+2028/2029 land as raw characters; use backslash-x escapes or code points
metadata:
  node_type: memory
  type: feedback
  originSessionId: c4e5e145-294c-4d74-ae34-5c5b77589535
  modified: 2026-10-31T04:50:38.942Z
---

A backslash-u escape for the space character (u plus 0020), typed in a Write or Edit tool parameter, lands in the
file as a literal space. The same text in `old_string` also matches a space. The backslash-u escapes for NUL and DEL,
and every backslash-x escape, are written as typed. zsh's `echo` also turns these escapes into characters. So write
regex ranges with backslash-x escapes (x00 to x20), and check the bytes with `od -c`. The backslash-u escapes for the
invisible characters (U+200B–U+200D, U+2060, U+FEFF) and the line/paragraph separators U+2028/U+2029 (djtrees-phone-headline builder, 2026-11-02: write `String.fromCharCode(0x2028)`) also land as the raw characters (web-compare amendment-1 builder,
2026-10-31: a regex class read back as bytes 342 200 213): build such classes from code points (`String.fromCharCode`).

**Why:** on 2026-10-23 `src/core/model/url.ts` got a literal space where its control-character range should end. It
behaved the same but read like a typo, and it broke a mutation hook that matched the source text. This is the same
kind of problem as CLAUDE.md's shell quirk for U+2028/U+2029.

**How to apply:** prefer backslash-x escapes in code written through the tools, and check the bytes when an escape
matters.
