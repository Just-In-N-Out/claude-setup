# Frame text links: words linked to another frame become a link to that frame's page

**Approved by Justin 2026-10-21** (answers F1A F2A F3A).

## Open questions (plan written as if ⭐ chosen)

1. When the target frame's page doesn't exist on the site yet?
   - A ⭐ Link to its guessed address, panel note (same as card links)
   - B Leave the words plain, panel note
2. A text link to a frame that isn't a page (a section or a card inside the same page)?
   - A ⭐ Link to the page of the top frame holding it
   - B Link to an anchor on that section (#id), later feature
   - C Drop it, panel note
3. Words whose target frame is gone from the file (deleted)?
   - A ⭐ Plain text, panel note naming the words
   - B Link to "#"

## Request played back

1. In Figma you can link selected words to a web address or to another frame in the file.
2. Web-address links already work; frame links are dropped, so in Bricks the words are plain text.
3. Make frame links work: the words link to the page the target frame becomes, by the same rules as card arrows / "Learn more" / Figma Navigate clicks: never a picture or video file, checked against the site's pages at Convert, panel notes when no page exists, any design.

## Current behaviour (evidence)

- `src/core/normalise/text.ts:41-52` `hyperlinkOf`: `if (h.type !== "URL" || !h.value) return null;` Figma gives `{ type: "NODE", value: "<frame id>" }` for a frame link, so it's dropped. The comment says "left for later (user, 2026-10-20)" (link-hrefs answer 5A).
- A run's link is written as `<a href>` inside the text's HTML (`src/core/style/typography.ts:80`), not as the element's `settings.link`.
- The frame-to-page path already exists for Figma Navigate clicks: `normalise/links.ts:79-81` `linkOf` turns a NODE destination id into `pageUrl(name)` plus `linkFrame` = the frame's name; `emit/page-addresses.ts` lists it as a `PageAddress` (`from: "figma"`); `ui/site-pages.ts` `checkLinks`/`relink` match it to the site's pages and rewrite or remove it.
- Two gaps for runs:
  1. `pageAddresses` only reads `n.link` / `src.linkFrame` (element links), never run links.
  2. `relink` (`ui/site-pages.ts:116-133`) only edits `settings.link.url`; a run's `<a href>` inside text HTML is never rewritten or removed, so even a correct guess couldn't be fixed against the site, and a picture's address couldn't be taken off.
- Extract: frame names come from `names` (normalise.ts:235-236: roots, `s.targets`, components). `s.targets` is filled in `plugin/extract/dump.ts:70-77` only from prototype **reactions'** `destinationId`. A text hyperlink's NODE id isn't added, so a target frame outside the converted frame (another top frame, another Figma page) has no name. **Extract needs a change.**
- No corpus file has a text hyperlink, so nothing in the corpus changes.

## Approach

1. **Extract** (`plugin/extract/text.ts` / `dump.ts`): after reading segments, for each segment with `hyperlink.type === "NODE"`, add its `value` to `found.targets` (navigation `"NAVIGATE"`), so the target's name lands in the snapshot's `targets` as for reactions. Debug-file format note: no new field; `targets` may now hold frames reached only by text links. Older debug files: a NODE link whose id has no name gets the "frame not found" note (Q3A).
2. **Normalise** (`text.ts`): `hyperlinkOf` takes the `names` map. NODE → resolve to the top frame (Q2A: walk up via snapshot parent info to the page-level frame; if only the id's own name is known, use it), then `pageUrl(name)`. Store on the run: `link: url`, plus a new `linkFrame: string | null` on `Run` (scene.ts), mirroring the element's `linkFrame`. Same safety: `pageUrl` gives a `/slug/` path, never a file; an empty name → null + note.
3. **Emit** (`emit/page-addresses.ts`): also walk each node's text runs; a run with `linkFrame` adds a `PageAddress` `{url, name: frame, words: run text, from: "figma"}` carrying the element's id plus a run marker (see 4).
4. **Panel** (`ui/site-pages.ts` `relink`): besides `settings.link`, rewrite `href="<from>"` inside the element's text HTML setting (exact attribute match, only for listed ids); when the match says `picture`, unwrap that `<a>` (keep the words). Keep it a pure function; a small helper `relinkText(html, from, to|null)` in its own file if site-pages.ts passes ~180 lines (it's 178 now) → new `src/ui/text-links.ts`.
5. `ui/run.ts` note text already names `words`; nothing new beyond the "frame not found" note from normalise.
6. Never a one-file fix: keyed on Figma's link type only, no names/ids.

## Tasks (test first each)

1. Fixture: generic snapshot with two top frames "Home" and "Pricing Page Final"; a text in Home with runs "See " + "our pricing" (hyperlink NODE → Pricing's id) + "."; plus one run linking to a child section of Pricing, one to a missing id, one URL link (control). Test normalise: run links `/pricing-page-final/`-style `pageUrl` with `linkFrame`, child → top frame's page, missing → null + note, URL unchanged. RED then GREEN.
2. Extract: unit test with a fake node whose segments carry a NODE hyperlink → `found.targets` has the id. Implement.
3. `pageAddresses` lists run frame links (id, words, from "figma"); a URL run never listed. Implement.
4. `relink`: text HTML href rewritten to the matched page, unwrapped on `picture`, untouched when the element changed since or the href differs; a typed URL with the same path never touched. Implement.
5. End-to-end: `convert` the fixture → paste's text HTML has `<a href="/pricing/…">our pricing</a>`; with a stub site (page "Pricing" published) relink → `/pricing/`; with a picture on the address → words plain + note.
6. `npm run check`, `npm run test:browser`, `npm run corpus` (pastes `cmp` equal: no corpus text links).
7. **Text proof** (no look change, no pictures): scratch script importing main's and the copy's `src/`, fixture converted by both → per run: words → href (old: none; new: guessed address, then the site-checked one).
8. **Docs & records**:
   - plan copied to `docs/plans/2026-10-2x-frame-text-links.md`;
   - ledger moved to `docs/plans/2026-10-2x-frame-text-links-ledger.md`;
   - `docs/HANDOFF.md` section + paste check owed at the next free number (3ac at time of writing, after 3ab; renumber if a parallel feature took it): link words to another frame in Figma, convert with WordPress connected, paste, click the words → lands on the page;
   - remove "left for later" in `hyperlinkOf`'s comment;
   - `BUILD` bump and main `CLAUDE.md` "Start here" / "Where things stand" by the finisher at merge;
   - CLAUDE.md rule: "every link kind (element or text run) goes through page-addresses + relink".

## Tests
Listed per task above; all in `test/` with `node --test`, generic fixture only.

## Choices
Q1A, Q2A, Q3A. Anchors to sections (#id) deferred.

## Risks
- Rewriting href inside HTML: must match exact `href="…"` of listed elements only, or a typed link with the same path could change. Tests cover it.
- Target frame name needs extract; old debug files lack it → note, not a guess.
- Parent walk for Q2A: snapshot `targets` may hold the child only; then the child's own name is used (could name a section, not a page). Note in panel.

## Pipeline parts touched
extract (`src/plugin/extract/text.ts` or `dump.ts`), normalise (`src/core/normalise/text.ts`, `scene.ts` Run type, `normalise.ts` passing `names`), emit (`src/core/emit/page-addresses.ts`), panel (`src/ui/site-pages.ts`, maybe new `src/ui/text-links.ts`), tests.

## Overlaps with parallel planners
- early-line-breaks: may touch `normalise/text.ts` (wrapping/`wordsOf`). Mine edits only `hyperlinkOf`/`textOf` signature: small textual clash, rebase-merge easily; build in sequence if they touch `textOf`.
- test-cleanup: edits `test/browser` panel tests and `style/style.ts`; I don't touch style.ts. If I add panel browser tests, rebase after it.
- phone-side-padding: no clash (adapt/rules).

## Other things found
- `ui/site-pages.ts` `relink` only rewrites `settings.link`; any text-run link (even a typed URL whose page is a picture's address) is never checked. Folded only for frame links here; typed URLs are by design never changed. Low.
- `ui/site-pages.ts` is 178 lines; fine. `normalise/page-links.ts` at 279 lines is near the ~300 limit. Low.


## Justin's answers (2026-10-21)

1A: guessed address plus a panel note. 2A: a link to a section goes to its top frame's page. 3A: deleted target gives plain words plus a note. All recommended.
