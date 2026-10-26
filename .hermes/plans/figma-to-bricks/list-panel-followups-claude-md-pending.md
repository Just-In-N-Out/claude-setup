# list-panel-followups — exact main CLAUDE.md edits pending

Target: `/Users/justin/Documents/FigmaToBricksV2/CLAUDE.md`
Release build: **2026-10-21.22** (`5e32aec`, pushed); panel check **3av owed** (Figma only, no paste).

**None of these edits landed, and none was attempted.** Main CLAUDE.md, read under the merge lock, still says
`Current build 2026-10-21.12`; the older pending files (.13 … .21, e.g. `pill-clip-`, `google-font-range-policy-`)
are unapplied after protected-file denials. Landing this .22 entry ahead of them would make CLAUDE.md skip builds
silently, so it is saved here to apply **after** them, in build order. No terminal/execute_code/main-chat route was
used. Rename to `-applied.md` only after both edits land.

## Edit 1 — "Start here", new bullet directly after the **Checks** bullet (after the older pending Start-here bullets)

```
- **List panel follow-ups (21.22, list-panel-followups):** a list row's action keeps its drawn words when the
  spreadsheet has columns nothing drawn matches (Q1A); Remove / Remove PDFs say what they took out (PDFs "kept" only
  when the file still holds some after the earlier saves' answers); PDF pickers follow the WordPress connection, and a
  pick belongs to the site/user/Application Password it started on (a failed test or edited login stops it like
  Cancel; only the latest Test connection of unchanged settings connects); Cancel upload never aborts the file sending
  (it settles into the PDF record, same bytes never POST twice); tab-separated files read (separators counted outside
  quoted header cells; ties comma, semicolon, tab). UTF-16 Excel "Unicode Text" not read (found-else). Lists wiring in
  `src/ui/list-box.ts`. Fresh review F1–F5 fixed test-first. check 1837 + 6 performance; browser 186/187 (snap
  Chrome-start timeout under load, snap alone 3/3); corpus and debug replays byte-identical to main .21. Deferred:
  large-CSV warning (Q5B), multi-list policy (Q6C), main.ts Stage 2+. HANDOFF "List panel follow-ups"; panel check
  **3av** owed, Figma only, no paste.
```

## Edit 2 — "Start here" build line (send last)

Replace the current-build line (whatever older pending files set it to, e.g. `**Current build `2026-10-21.21`.**`) with

```
**Current build `2026-10-21.22`.**
```

and in the **Checks** bullet, the counts become: `npm run check` 1837/1837 unit/rule plus 6/6 serial performance;
browser 187 tests, 186 pass with one `snap` Chrome-start timeout under load (`snap.test.ts` alone 3/3).

No new "Where things stand" rule: the panel rules this feature follows are already in the skill's
`references/panel-validation.md` (connection freshness, multi-file ownership, authoritative removal state, quoted
headers).
