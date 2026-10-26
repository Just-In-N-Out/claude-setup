# Brief: apply the 4 pending CLAUDE.md updates (Justin OK'd 2026-10-21 ~07:00: "Ok Claude.md")

Target: `~/Documents/FigmaToBricksV2/CLAUDE.md` (main folder, ~90 KB, NOT in git, protected: each write asks Justin for /approve on WhatsApp; that's expected).

Apply the pending files in build order:
1. `~/.hermes/plans/figma-to-bricks/emergency-cta-width-claude-md-pending.md` (build 2026-10-21.1)
2. `~/.hermes/plans/figma-to-bricks/early-line-breaks-claude-md-pending.md` (2026-10-21.2)
3. `~/.hermes/plans/figma-to-bricks/font-weight-gaps-claude-md-pending.md` (2026-10-21.3)
4. `~/.hermes/plans/figma-to-bricks/phone-side-padding-claude-md-pending.md` (2026-10-21.4)

## Rules
- Read each pending file whole. Never read CLAUDE.md whole: find each anchor with `search_files` and read around it with `offset`/`limit`. Re-read the spot right before each `patch` (another session may edit the file).
- Each pending file was written against CLAUDE.md as it stood then, before the later ones. So where a later file replaces the same line (the "Current build" line, the Checks bullet counts), the later file wins; end state: `**Current build `2026-10-21.4`.**` and the Checks numbers from the phone-side-padding file. Keep every feature's "Start here" entry and "Where things stand" entry, newest first in the same order as the existing entries.
- Some pending files may say an edit already went in. Check the file actually has it; don't add it twice.
- Use the `patch` tool only (never terminal/execute_code to route around the protection). If a write is denied, don't retry it: stop and report which edits went in and which didn't.
- Change nothing else: no code, no git, no other docs.
- After the last edit, update `skill_view('figma-to-bricks', file_path='references/rules-summary.md')` only if a pending file added a new rule (section "Working in this repo") that the summary lacks: `skill_manage` `patch` on that reference file, keep it under ~11 KB, no status lines.
- Then rename each applied pending file to `<name>-claude-md-applied.md` (terminal `mv`), so it isn't applied twice.

## Answer
Plain words for WhatsApp: which edits landed per build, anything skipped or denied, the final "Current build" line, and whether rules-summary.md changed.
