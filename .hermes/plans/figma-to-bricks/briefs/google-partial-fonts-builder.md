# Brief: BUILDER for figma-to-bricks feature "google-partial-fonts" (B8)

Build the approved plan at `~/.hermes/plans/figma-to-bricks/google-partial-fonts.md` (no questions; Justin said go). Model: Sol 6.1 high.

## Found item this closes
In `~/.hermes/plans/figma-to-bricks/found-else.md`, "Low-medium: src/ui/fonts.ts:44–45 treats any nonempty HTTP-200 family response as complete…" (fonts-cleanup planner section). The finisher marks it `~~item~~ ✅ fixed in build <BUILD> (google-partial-fonts)` at the merge.

## State
- Main `aa19bae`, build 2026-10-21.7. Paste checks up to 3ah are taken.
- In flight: link-upload-fixes (may edit src/ui/run.ts), text-breaks (style/), cta-label-wrap (adapt/, in review). Stay within this plan's files; whoever merges second rebases and keeps both HANDOFF sections.

## How
1. `skill_view('figma-to-bricks')`, BUILDER role (Step 2 through Step 3, skip item 6). `references/rules-summary.md` first, then only the CLAUDE.md font sections. Never the whole file.
2. `skill_view('test-driven-development')`: a failing test before each change. Surprise failure: `skill_view('systematic-debugging')`. Say you loaded them.
3. Worktree `.claude/worktrees/google-partial-fonts`, branch `worktree-google-partial-fonts`, from main.
4. No look change: return a text proof (old vs new rows/notes for the real 400+800 answer). Google stand-ins answer like real Google (HTTP 200 with a weight missing).
5. Plan copy to `docs/plans/2026-10-21-google-partial-fonts.md`; ledger; HANDOFF with the next free paste check (or "none owed" if the panel note is the only change and a Convert shows it).
6. Leave BUILD and CLAUDE.md alone. Read-only GETs only. Rulings as "My ruling, not yet confirmed". Other bugs: `found_else`.
7. Stop at ready-for-review: all committed; `npm run check`, `npm run test:browser` (3 known stale panel tests), `npm run corpus` no worse; not merged, nothing pushed. Kill Chrome you started. Out of steps: commit what passes, `status: stopped`.
8. Plain words for WhatsApp.
