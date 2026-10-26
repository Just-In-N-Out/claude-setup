# Pending main CLAUDE.md edits — text-breaks, build 2026-10-21.10

The protected-file guard denied the first patch. **No text-breaks CLAUDE.md edit landed**, including the build line. Do not retry through another tool. Main source/dist and origin/main are build 2026-10-21.10 (commit 2dd96eb); CLAUDE.md was still at .8 when read. Re-read before applying, preserve all concurrent entries, and send the build-line edit last.

## 1. Where things stand

Immediately before the unique `- **Paste checks:**` entry, insert:

- **Text breaks** (build `2026-10-21.10`, `text-breaks`, HANDOFF "Text breaks"; approved T1A T2A):
  - Recognised phone ranges travel together when they fit a whole line; a capped max-content inline unit wraps digits
    only when the box is too narrow. `word-break:break-all` respects adjoining closing punctuation, unlike
    `overflow-wrap:anywhere`. Existing run styles, hrefs and anchor positions stay; no nested links or font shrink.
  - Fixed-width flowing prose may soften an isolated sentence-ending wrap only when every break passes the original
    ink/letter-slack proof. Sentence-a-line items (including a trailing empty line or unpunctuated last item), headings,
    deliberate breaks and blank paragraphs stay. Recognised addresses get neither softening nor rag hiding. L1A/L2A and
    the replaced-word guard stay (the latter already shipped in 21.2, not newly fixed here).
  - Fresh review F1/F2 reproduced and fixed test-first; original reviewer tests 3 red without fixes, 3 green with them.
    Rebased check 1446; browser 142/145, the same three stale panel-name failures reproduced on main. Corpus's 17 known
    worse-than-v1 identities unchanged; matched font-loaded/frozen rerenders have identical full lint at every width.
  - Homepage phone intact at 478, no overflow at 479; CTA .8 now gives that text 385px at 479 (not the old 101px).
    Services quote 10 → 8 lines at 390, five unchanged at 1728; address street/city break retained. Address snaps use
    the recorded Mont fallback. Refreshed before/after pictures and evidence are under ~/.hermes/plans/figma-to-bricks/.
  - **My ruling, not yet confirmed:** a number partially crossing an existing anchor stays ungrouped so that exact
    frame-link positions survive. Cross-run automatic dial links, permissive recognition and long hours remain separate.
  - Paste check **3ak** owed: reconvert/paste homepage, Services and address; save, sign existing Code if present,
    LiteSpeed Purge All; reply pasted + page name for read-only live checking.

## 2. Decisions the user made — Typed line breaks

After this existing sentence:

> would have fitted on) stay. Only prose goes soft (finisher's ruling under the user's auto-go; `style/rag.ts`).

Insert:

  - **T1A (text-breaks, 21.10):** an isolated sentence end inside fixed-width flowing prose does not disqualify
    measured wrap breaks; every break still needs the original ink/letter-slack evidence. Sentence-a-line items keep
    their separators even with a trailing newline or an unpunctuated final item. Recognised addresses never receive
    either permanent softening or narrow-screen rag hiding. Existing hug-width L2A is unchanged.
  - **T2A:** a recognised phone-number visual unit moves whole when it fits the full line; only an over-wide unit may
    wrap internally, without font shrinking, overflow or a closing-punctuation-only line. Existing links/styles stay.
    Partially crossing anchors are conservatively left ungrouped (finisher's ruling, not yet confirmed).

## 3. Start here — checks and new feature entry

Replace only `npm run check`'s 1402 count with 1446, and browser 137 of 140 with 142 of 145, retaining the existing
explanation of the same three stale panel upload-name expectations.

Immediately before `- **CTA label wrap (21.8, cta-label-wrap):**`, insert:

- **Text breaks (21.10, text-breaks):** phone numbers move together when they fit; an impossibly narrow box may wrap
  digits without overflow or a lone closing period. Proven fixed-width flowing prose reflows through an isolated
  sentence-ending wrap; sentence-a-line items and addresses retain their deliberate separators. Fresh review F1/F2
  fixed test-first. Services review 10 → 8 lines at 390; same five at 1728. Check 1446; browser 142/145 with only the
  three pre-existing panel failures; matched corpus no worse, same 17 known v1 comparison items. HANDOFF "Text breaks";
  paste check **3ak** owed. CLAUDE.md pending edits are in this file because the guard denied the first write.

## 4. Build line — apply last

Replace:

`**Current build \`2026-10-21.8\`.**`

with:

`**Current build \`2026-10-21.10\`.**`

If another finisher has advanced the actual build before these edits are applied, keep that newer build instead.
