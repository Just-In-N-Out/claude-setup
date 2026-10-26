# google-font-range-policy — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release build: **2026-10-21.21** (`dc6713d`, pushed); conversion check **3au owed**, no paste check owed.

**None of these edits landed.** The first `patch` (edit 2, the font-weight rule) was denied by the protected-file guard
("write to protected agent-instruction file(s) (CLAUDE.md) was denied by the user"); it was not retried or routed
around (no terminal/execute_code/main-chat route). Main CLAUDE.md was re-read under the merge lock and still says
`.12`. Older pending files (.13 … .20, e.g. `google-font-hardening-`, `pill-clip-claude-md-pending.md`) remain
untouched and apply first; this file does not supersede them. Rename to `-applied.md` only after every edit below lands.

## Edit 1 — "Start here", new bullet directly after the **Checks** bullet (apply after older pending Start-here edits)

```
- **Google font ranges (21.21, google-font-range-policy):** Google's answer is pasted only as the design's whole-number
  weights: a range face becomes one face per requested weight it covers (same file and subsets, only the weight value
  changes), `normal`/`bold` become 400/700, single-number faces stay byte-for-byte; a range missing the design's weight,
  an unreadable/escaped/commented weight, `!important` or a range/word written inside a comment is left out and stays
  missing. `supplied` lists only pasted faces. Defensive: Google answers the plugin's discrete requests discretely.
  Fresh review R1–R5 fixed test-first. check 1805 + 6 performance; browser 173/173; corpus and debug replay
  byte-identical to main .20. HANDOFF "Google font ranges pasted as the design's weights"; conversion check **3au**
  owed, **no paste check owed**. Duplicate loading still HELD.
```

## Edit 2 — "Where things stand", rule "Font weights in a paste are single whole hundreds" (around line 1017–1020)

Replace

```
  (header, footer, Theme Style). Never write a weight range or a non-number weight in a paste.
```

with

```
  (header, footer, Theme Style). Never write a weight range or a non-number weight in a paste. Google's own answer
  obeys this too (build 21.21, `ui/google-faces.ts`): a range face is pasted once per design weight it covers (same
  file/subsets, only the weight value changed), `normal`/`bold` as 400/700, single-number faces byte-for-byte; a range
  missing the design's weight, an unreadable/escaped/commented weight or a raw-text range in a comment is left out and
  stays missing. `supplied` names only pasted faces.
```

## Edit 3 — build line, LAST (only after all older pending build-line edits through .20 have landed)

```
-**Current build `2026-10-21.20`.**
+**Current build `2026-10-21.21`.**
```
