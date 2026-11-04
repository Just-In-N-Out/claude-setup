---
name: website-importer-paused
description: "Website importer: waves 1+2 all merged (Build 2026-11-02.5 + 2026-11-03.2 embeds), building STOPPED per Justin; next he wants to try importing bdryswi.com once its bot check is allow-listed"
metadata:
  node_type: memory
  type: project
  originSessionId: 519648e7-1ba1-46ba-a0a3-91e300b908f4
  modified: 2026-11-03T21:45:46.309Z
---

**State (2026-11-03 ≈16:55 local):** the importer's waves 1 and 2 are merged and pushed. Plan:
`~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` (11 jobs, 4 waves); step log
`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`.
- Build 2026-11-02.5 (`9212c477`) carries capture, compare, the panel's capture drop, the address box (helper:
  `npm run capture:serve`) and tiers. Build 2026-11-03.2 (`70be9c09`) carries embeds: widgets, maps, floating extras.
- **Stop (Justin, 2026-11-03 morning):** "after you merge wave 1 and wave 2 stop building ok". Start nothing new for the
  importer (no wave 3, no demo-fix planners, no follow-up jobs) until he says so.
- **Next, his words (2026-11-03 evening):** "after this we can try importing bdry". It needs him to allow-list the
  capture past bdryswi.com's bot check ("Checking your browser…") or pause it while capturing. Never get past it by
  hiding automation. Asked where bdryswi.com is hosted and what shows the check (host, Cloudflare or a WP plugin).
- **Restart choice (2026-11-03 ≈17:05):** "bdry first, then decide": no building yet; import bdryswi.com (WordPress.com + Elementor, [[bdry-home-copy]]), look at the paste with him, then pick what to build from what's wrong. Its bot check is likely WordPress.com's Defensive mode (unconfirmed).
- **bdry capture, 2026-11-03 ≈17:15:** the address box worked end to end but bdryswi.com answered with a human check ("Confirm you are human / I am human", HTTP 403). Asked for another way than disabling, Justin chose **"I click 'I am human'"**: the helper opens a visible Chrome and he passes the check himself, with nothing hiding automation. Mini job `web-human-check` MERGED as Build 2026-11-04.1 (`39d96c98`, pushed; paste check 3cz = AC8 live: his bdryswi.com try). Review P3s in its evidence follow-ups.md (R1-5: a 'verifying' page after the click may count as passed).
- **bdry paste, 2026-11-04 ≈02:00:** it worked. His issues: (1) button animations missing (wave 3/4); (2) hero slider squashed into strips (wave 3 sliders); (3) three photos cut at the bottom (bug); (4) phone view very bad, because the capture read switch points off the check page (bug A), and a later re-check plus the site's reload killed the full run (bug B). Mini job `web-human-reload` (A+B), agents on **Opus medium** at his word ("run it but on opus 5.5 medium"; then 2026-11-04 ≈02:40: "run every subagent for this chat going forward on opus 5.5 medium", i.e. every role in the importer session, overriding the xhigh default for this chat only); he went to sleep: "keep it running".
- **Owed by Justin (live):** paste checks 3cx (panel AC16), 3cy (address AC13) and 3cw (embeds AC12); the bdryswi.com
  ACs (capture AC15, tiers AC15, embeds AC13) once allow-listed.
- **My rulings, not yet confirmed:**
  - embeds amendment 1: AC2 counts only JavaScript, and an inline script only when it loads or calls the host;
  - BUILD date naming (the 11-02.5 build kept the 11-02 date).
  - Open question: should floating extras follow tablet/phone layouts (Task 11 was never built)?
- **Merge-order ruling (2026-11-03):** embeds went ahead of dark-structure-recognition at Justin's word ("Embeds now"). He
  removed that job's lock himself, the lock was put back afterwards, and a note was left in its evidence folder.

**Justin's AC rulings, 2026-11-02 (capture):**
- AC4 "Keep it in the Header": a part's own fixed content stays in its part.
- AC14 "Mark it mine, merge now": the bdryswi.com pages are a live AC owed to him.

**Earlier:** he chose "Address in the panel" for importing a live site without a Figma design. Related:
[[review-round-cap]], [[deliverable-first]], [[bdry-home-copy]], [[run-without-stopping]].
