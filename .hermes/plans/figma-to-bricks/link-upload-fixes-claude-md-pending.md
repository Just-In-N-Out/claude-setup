# link-upload-fixes — CLAUDE.md edits pending

- Merged and pushed **2026-10-21.11**, main **6ba11f5c2b146888b73a4cea707ea53a26c514ab**.
- **Applied here: none.** The first protected-file patch was denied. No retry, terminal workaround or alternate-path write was attempted. Main CLAUDE.md still says .8 at the last read; this is a documentation blocker, not a missing merge.
- **Do not overwrite or mark applied** `google-partial-fonts-claude-md-pending.md` (.9) or `text-breaks-claude-md-pending.md` (.10). The parent should re-read anchors, apply those files first, then these B2 edits. Apply the final BUILD/check line below last, so .9/.10 never regress the actual .11 build.
- Preserve every concurrent feature entry. Offsets below are from the pre-edit .8 file and are not reliable after earlier pending edits; use the exact text anchors.

## 1. Start here: replace the old link-hrefs entry

Exact OLD:
```markdown
- **Links that opened a picture (20.14, link-hrefs):**
  - **The user:** the bottom-left service card "downloaded a photo and didn't take me to the page … make it so that
    the plugin first does not take hyperlink as photos … and … accurate with hyperlinks".
  - **The cause** (live site read over HTTP): on the Hydraulic, Remanufactured and Core Exchanges pages the Rods card
    links to `/rods-1-15-rechroming-rods/`, the address WordPress lent media 647 (the Rods page's hero PNG, uploaded
    after those pages were pasted). Since WP 6.4 an unattached upload's `/<name>/` redirects to its file. Every card's
    link was on its own card.
  - **The user chose (1A–5A):** uploads always end in `-image` / `-video`; a link to a page not made yet keeps its
    address; the plugin moves **its own** pictures (ids in the upload cache) off a link's address; a Figma link typed
    to a picture or video file is dropped and named; text links to frames came in 21.5 (frame-text-links).
  - **What it does:** every Convert with WordPress connected reads the media on every link's address and sends `POST
    wp/v2/media/<id> {slug: "<slug>-image"}` for the plugin's own. That repairs the pages already pasted, with no
    re-paste: WordPress then forwards the old address to the page named like it.
  - Reviewed on opus and fixed (a picture attached to a page never counts, a video named a video, one change per
    media item at a time). Corpus pastes byte-identical. HANDOFF "Links that opened a picture, and links kept
    right"; paste check 3aa owed.
```

Exact NEW (the denied first patch; none of it landed):
```markdown
- **Link and upload fixes (21.11, link-upload-fixes; supersedes 20.14's repair promise):**
  - **The user:** a service card downloaded a photo instead of opening the page. Approved L1A/L2A/L3A:
    re-convert/re-paste old pages, rename only in WordPress-picture mode, leave opaque attachment-ID links plain.
  - Uploads explicitly request the transmitted safe filename's stem as the slug (`-image` / `-video`), so a JPEG's
    metadata title cannot undo the suffix. Only cache-owned media move, only while an active WordPress-picture run
    allows it. The per-media queue rechecks permission immediately before POST and holds an exact-ID GET readback:
    changed slug, same file/id, no old-path occupancy. Refused, ignored or unverifiable moves never count as freed.
  - Connected inside-JSON Convert still reads/matches links but never renames media. Cancel prevents new repair
    POSTs and a copyable Outcome; the panel also rechecks run ownership after video lookup/save, so a stale finish
    cannot copy, replace the error, automatically rerun or unlock a newer conversion. In-flight writes cannot roll back.
  - Both original and candidate page addresses are media-checked; a known occupied final target is left plain.
    Notes count/name every verified media move once. New pastes use the exact matched page address; draft/missing
    pages remain honestly labelled. Navigation filters .ogg/.jfif/.apng/.avi/.mkv and positive attachment IDs
    (type unknown: use a direct document URL); direct PDFs/Office files, normal queries and video sources remain valid.
  - `assertPayload` guards core emission and the final panel paste; invalid output is refused, not copied.
  - **Old pages are not repaired by Convert alone.** Media 647/514 were already renamed in October 21 GET captures;
    Hydraulic's Rods href was canonical, Remanufactured/Core still guessed. Re-convert/re-paste those saved pages,
    save and purge LiteSpeed; media renames never guarantee a public redirect. **3aa superseded, not verified; 3al owed.**
  - Check 1472; browser 146/149 (three baseline stale upload-name tests, test-cleanup). Five corpus pastes/HTML and
    all lint/heights/fonts at 29 widths equal .10. Both fresh review findings fixed test-first, mutations prove them.
    Separate pre-existing LINK-RENAME-COLLISION remains open (rename destination can occupy another protected path).
    HANDOFF "Link and upload fixes"; plan/ledger `docs/plans/2026-10-21-link-upload-fixes*`.
```

## 2. Where things stand: replace the link-hrefs implementation entry

Exact OLD:
```markdown
- **Links that opened a picture** (build `2026-10-20.14`, branch `worktree-link-hrefs`, HANDOFF "Links that opened a
  picture, and links kept right"; plan and ledger `docs/plans/2026-10-20-link-hrefs*`):
  - **Core:** `normalise/links.ts` `fileAddress` (a path ending in a picture or video type), `fileNote`, `notWebNote`;
    `normalise.ts` `build` and `text.ts` `hyperlinkOf` (text links through `safeUrl` too) leave such links off;
    `emit/payload.ts` `payloadProblems` refuses a link or `<a href>` to one.
  - **Panel:** `files.ts` `safeFilename` (always `-image`; `fileStem` for embed), `videos.ts` `videoUploadName`
    (`-video`; the lookup still finds those names); `site-read.ts` `heldAddresses`/`opensAt` (media on a link's
    address only where WordPress serves it: attached to no page, or its own `link`) and `wordpress.ts`
    `setMediaSlug` + `oneAtATime`; `site-pages.ts` `Held`, `Match.freed`, the notes; `run.ts` passes the upload
    cache's ids.
  - **On the user's file:** the grid's cards keep their hrefs (`/remanufactured-hydraulic-cylinders/`,
    `/core-exchanges/`, `/rods-1-15-rechroming-rods/`, `/assembly-test-paint-delivery/`); the site check sends them
    to the "… Final" pages, and with 647 in the upload cache frees `/rods-1-15-rechroming-rods/`.
  - **My rulings and the deferred minors:** in HANDOFF. Not yet tried by the user (3aa).
```

Exact NEW:
```markdown
- **Link and upload fixes** (build `2026-10-21.11`, branch `worktree-link-upload-fixes`, HANDOFF "Link and upload
  fixes"; plan/ledger/proof `docs/plans/2026-10-21-link-upload-fixes*`; supersedes 20.14's automatic-repair claim):
  - **Core:** `normalise/links.ts` shares media/opaque-attachment classification and honest notes with the validator;
    `emit/payload.ts` `assertPayload` is operational after core emission and final panel processing (`convert.ts`,
    `run.ts`). Direct documents and video sources remain valid. Invalid positive fixtures use real six-letter IDs.
  - **Panel:** `wordpress.ts` sends filename-stem slug on every upload route; per-media queue serializes permitted
    rename plus exact-ID readback. `site-media.ts` holds the existing full-path occupancy rule, explicit repair
    policy and verified/refused/unverified/skipped results. Only active WordPress-picture mode repairs owned media;
    inline mode reads only. Cancel is checked inside the queue and after async panel video work (`main.ts`).
  - `site-read.ts` checks original and candidate addresses; `site-pages.ts` derives hrefs/counts from the final media-
    safe decision. Match retains every verified move, including an unused candidate, deduplicated by media ID.
    Frame-linked runs retain origin scoping; unrelated typed URLs do not change.
  - **Saved pages:** new pastes use exact canonical page hrefs; media moves never rewrite saved pages or guarantee
    WordPress's loose guessed redirects. October 21 GETs already showed 647/514 renamed and Hydraulic canonical,
    Remanufactured/Core still guessed. Re-convert/re-paste those pages, save and purge LiteSpeed; check **3al**
    supersedes 3aa (not verified). No agent writes to the site.
  - Fresh review findings fixed test-first with reverted-fix mutation proof; check 1472/1472, browser 146/149
    (only three reproduced baseline upload-name expectations). Archived .10 versus branch corpus: 5/5 identical
    pastes/HTML, full lint/heights/fonts at 29 widths equal. Motion-frozen marquee pixels identical. Pre-existing
    LINK-RENAME-COLLISION is recorded separately and remains open.
```

## 3. Working in this repo: replace the attachment-address rule

Exact OLD:
```markdown
- **A WordPress upload attached to no page owns the address `/<its file name>/`,** and since WP 6.4 that address
  redirects to the file. So the panel's uploads always end in `-image`/`-video`, and a link is never a picture or
  video file (`payloadProblems` refuses one). One attached to a page is at `/<page>/<name>/` instead.
```

Exact NEW:
```markdown
- **A WordPress upload attached to no page owns `/<its slug>/`,** and since WP 6.4 that address redirects to its
  file. Safe upload names end `-image`/`-video`; every upload explicitly requests that transmitted name's stem as
  `slug`, because embedded titles can otherwise override the filename. An attached item's exact parent permalink
  is checked, never just its basename. Only cache-owned media in an active WordPress-picture run can move; the
  per-media queue rechecks permission immediately before POST and verifies the exact ID by GET. A fulfilled POST
  alone is never a freed address. Inline mode reads/matches only; cancellation prevents new repair writes and stale
  panel copying. Media moves never repair old saved hrefs or guarantee redirects: re-convert and re-paste them.
- **A navigation link never opens known media.** Shared classification covers file suffixes and positive opaque
  attachment IDs (type unknown: direct document URLs remain valid). `assertPayload` runs after core emission and
  final panel assets/fonts/relinking, refusing invalid output before it can be copied. Never weaken the guard for
  a positive fixture: give the fixture valid deterministic IDs and reciprocal tree references.
```

## 4. BUILD and checks — apply last, after .9/.10 and B2 content above

At the last read the OLD was:
```markdown
**Current build `2026-10-21.8`.**
- **Checks:** `npm run check` 1402 pass; browser suite (`npm run test:browser`) 137 of 140. The three failures are
  link-hrefs' panel tests (`panel.test.ts`) still expecting upload names without `-image` / `-video`: the code is
  right (the user's 1A), the tests need the new names; they fail the same way on 20.14. Showcase's "number above its
  photo" test can miss once under a busy Chrome (a fixed 650ms wait for a 0.5s hover).
```

After applying .9/.10, re-read and replace the then-current BUILD/check block with this exact NEW, preserving all following feature entries:
```markdown
**Current build `2026-10-21.11`.**
- **Checks:** `npm run check` 1472/1472; browser suite (`npm run test:browser`) 146/149, zero skipped. The three
  stale upload-name panel tests fail identically on archived main .10 (25/28 panel); test-cleanup owns them.
  Fresh .10/branch corpus: same 17 worse-than-v1 identities, 5/5 pastes and HTML byte-identical, full lint/heights/
  fonts equal at 29 widths. Moving-marquee raw score variation is retained; matched-time page/section pixels equal.
```

## Verified release and remaining work

- Main/local origin and read-back remote `refs/heads/main` all equal `6ba11f5c2b146888b73a4cea707ea53a26c514ab` after push.
- `dist/code.js` rebuilt (559160 bytes) and contains .11; `dist/ui.html` rebuilt (157556 bytes).
- User debug JSON left modified and unstaged; never committed. Paste check **3al**: re-convert/re-paste Remanufactured and Core, save, regenerate code signatures if Code exists, purge LiteSpeed, reply **pasted + page names**.
- This file is pending until the parent actually applies it. Only then rename it `link-upload-fixes-claude-md-applied.md`. Do not relabel prior pending files here.
