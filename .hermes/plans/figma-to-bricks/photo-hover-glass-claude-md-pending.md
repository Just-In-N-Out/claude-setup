# Photo hover glass — pending main CLAUDE.md edits

Merged and pushed **build 2026-10-21.14**, commit `5568d94` (main = origin/main verified). The first protected CLAUDE.md
patch (edit 2 below) was denied; **none of these edits landed**. Do not retry from the finisher. Main chat: apply
**after** `google-font-hardening-claude-md-pending.md` (.13) and any earlier pending files, re-read anchors, preserve
parallel edits, apply in order, build line LAST; then rename this file `photo-hover-glass-claude-md-applied.md`.

## 1. Start here: feature entry

Insert directly after the "Google font hardening (21.13, google-font-hardening)" entry (from the .13 pending file),
i.e. before the line beginning `- **Test cleanup (21.12, test-cleanup):**`. (If .13's entry is missing, insert before
that line anyway.)

```text
- **Photo hover glare removed (21.14, photo-hover-glass):** product/team cards and listing media keep the 110% zoom
  and the card fade-in; the glare stripe (`::after` + `showcase-glare` keyframes) is gone. Pastes differ from .13
  only by deleted lines in the showcase classes' CSS; full corpus reports identical, same 17 v1 items. Check 1579 +
  6 performance, browser 154/154. Fresh review PASS; fix pass made the guard an allow-list (hover only scales, only
  the zoom copy as pseudo-element), mutations M1/M6 now caught. Zoom "softness pop" (F1) left for Justin (A2 offer).
  HANDOFF "Photo hover glass"; paste check **3an** owed (re-paste with class box answered **replace**).
```

## 2. Decisions: product and team cards

Replace this exact block:

```text
    - **Under the pointer** its photo grows to 110% over 0.5s inside its frame, and a glare crosses it once on each
      hover (the user chose once over nonstop).
    - **Figma's hover on such a card is dropped** (the user chose "New zoom + glare replace it").
```

With:

```text
    - **Under the pointer** its photo grows to 110% over 0.5s inside its frame. **No glare, shine or glass sweep on
      photo hover** (user, 2026-10-21: "this glass flicker I do not want"; build `2026-10-21.14`; reverses the
      19 Oct "zoom + glare" decision): the Staff sample's glare must not be copied. Guard
      (`test/unit/convert-showcase.test.ts`): a showcase class's `:hover` may change only `scale`, its only
      pseudo-element is the zoom copy (`.showcase-photo::before`), no `@keyframes`.
    - **Figma's hover on such a card is dropped** (the user chose "New zoom + glare replace it"; since 21.14 only the
      zoom replaces it).
```

## 3. Decisions: listing rows

Replace this exact text:

```text
      product, there's that hover effect"; build `2026-10-19.11`): two or more photo/text rows (a zigzag) get the zoom
      and glare on their media when the pointer is on it. No fade-in for rows.
```

With:

```text
      product, there's that hover effect"; build `2026-10-19.11`): two or more photo/text rows (a zigzag) get the zoom
      on their media when the pointer is on it (no glare since 21.14). No fade-in for rows.
```

## 4. Current-build line LAST

Only if it reads `2026-10-21.13` (i.e. after the .13 pending file's build line; never lower a newer build), replace:

```text
**Current build `2026-10-21.13`.**
```

With:

```text
**Current build `2026-10-21.14`.**
```

Also replace the "Checks" block's numbers if this is the newest build: check 1579/1579 unit/rule plus 6/6 serial
performance; browser 154/154, no skips. Main .13 versus .14: content identical, showcase classes' CSS lose the glare
lines only; complete reports equal bar createdAt; same 17 v1 differences.

## Other records already complete
- BUILD bumped, dist rebuilt, main pushed. HANDOFF, plan, ledger in git; paste check renumbered 3am → **3an**.
- Rules summary (skill) updated: CTA/photo-card decision now "zoom 110%, no glare".
