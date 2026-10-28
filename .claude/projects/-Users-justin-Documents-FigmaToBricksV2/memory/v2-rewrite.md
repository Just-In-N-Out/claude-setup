---
name: v2-rewrite
description: "Figma-to-Bricks v2 rewrite status and the user's target output (ExampleBricks) — read before planning M2b+ work"
metadata:
  node_type: memory
  type: project
  originSessionId: f7a3c41a-53da-4665-b4dd-957fb80b6724
---

v2 rewrite of the user's Figma→Bricks plugin lives in ~/Documents/FigmaToBricksV2 (spec docs/specs/2026-10-06-v2-design.md,
plans + ledgers in docs/plans/, status and next steps in docs/HANDOFF.md). M0, M1a and M1b (desktop parity: free-frame
inference, fluid sizing, turned layers, native dividers/buttons) finished 2026-10-06. Next: M1c (panel, upload, SVG
icons) and M2 (phones/tablets); the user asked for M1 then M2.

Answered 2026-10-06 after M1b: wide designs keep the 1440 Container; Buttons by shape alone (both in CLAUDE.md).
Paste check done 2026-10-07 on their test site (Hostinger, Bricks 2.3.9): desktop layout matches Figma on the live
page; the Bricks editor hides some placehold.co stand-ins; the cut-off "North" floating button was fixed.
M1c (plugin panel: convert in Figma, WordPress upload, AVIF photos, Google Fonts) done, reviewed and fixed 2026-10-07,
build 2026-10-07.1. Next: the user's first real run in Figma (steps in HANDOFF "What the user must provide" item 3),
then native SVG icons (needs their Bricks samples), then M2. The user asked that photos be .avif (the default; logos
and icons stay PNG — offered to make those AVIF too if they want).
First real run in Figma worked (2026-10-07, a new hydraulics-shop design: 473 elements, 10 sections). The user then
asked for v1's "photos inside the copied JSON" back (they had relied on it, not on WordPress): done as build
2026-10-07.2, default "Pictures go: inside the copied JSON". Phones (M2) and FAQ accordion/animations (M3/M4) are
known not-built-yet, explained to the user.
M2 is split M2a–M2d. M2a (adapt stage: rulebook engine, page scales, type/space step-down, unpinned heights, photo
shape, lint text-overlap/image-distortion) done, reviewed and fixed 2026-10-07, build 2026-10-07.4; phones still
look worse than v1 until M2b (rows wrap/stack). Corpus now has a 4th design,
hydraulics (corpus/files/hydraulics-home.json). Still waiting on the user's Nav (Nestable) sample (M2d).
M2b (layout plan, rows/grids reflow, rag line breaks, balanced headings, full-width CTAs, footer, tap areas) done,
reviewed and fixed 2026-10-07, build 2026-10-07.6: phones now look like a real mobile site on hydraulics. The user
said "Yes LETS do it" to M2b. Next: M2c (hero, phone sliders as copies, zigzag, free compositions), M2d (nav, needs
sample), M2e (clamp between W and 992).
M2c (phone-only copies at understand: photo-card/gallery sliders, hero "Phone buttons" band, zigzag photo-first,
intro order, crop subject) done, reviewed and fixed 2026-10-07, build 2026-10-07.9. Decided 2026-10-07 (user: "whatever
looks nicer"): a hero without a photo keeps its buttons in place, no band (in CLAUDE.md).

`ExampleBricks` in the repo root is the user's hand-built Bricks 2.3.9 version of a real page (one copy per line).
On 2026-10-06 the user chose it as the target: editable structure over pixel-pinning, purpose-named classes,
native button/icon/divider/accordion/slider/carousel, and phone sliders as copies (desktop row + phone-only slider).

**Why:** v1's output had 1,455 elements with custom CSS on 84% of them; the user's example has 151 elements, 7 with
custom CSS — v1 is hard to edit and hard to make responsive.
**How to apply:** judge output against ExampleBricks' structure, not only pixels. See [[user-workflow]].
Paste check 2026-10-07 after M2c (hydraulics on a phone): "nothing looks wrong. Slider work and look great." The user
then asked to continue: next M2e (clamp between W and 992), M2d waits for the Nav (Nestable) sample.
M2e (fluid tier: spacing ≥40 and type ≥28 slide as clamp() between the design width and 992; rag line breaks below W)
done, reviewed and fixed 2026-10-07, build 2026-10-07.11. Next: M2d nav once the user sends a Nav (Nestable) sample
(they first pasted the card/slider sample again by mistake); otherwise free compositions.
M3a (hover styles as Bricks :hover keys/CSS where exact, else none + warning; FAQ → native accordion-nested; question
and icon on one line on phones) done, reviewed and fixed 2026-10-07, build 2026-10-07.12. Paste check owed (the user
will check everything at the end). Next: M3b (hover states for what CSS can't draw), the sample-free rest of M3, then M4.
M3b (hover layers: a copy of the hover variant laid over the component for hovers CSS can't draw) done, reviewed and
fixed 2026-10-07, build 2026-10-07.13. Every corpus hover is now drawn. Next: M4a (plan written), then M4b (Motion,
no corpus data: ask the user for a Motion test file at the end). Tabs/Dropdown/Offcanvas/Nav/pop-ups wait for samples.
M4a (headings: one h1, no skipped levels, stacked title pieces merged like ExampleBricks' h1; alt text sent with WordPress
uploads; focus ring; reduced motion) done, reviewed and fixed 2026-10-07, build 2026-10-07.14. Next: M4b (Motion).
M4b (Figma Motion → CSS keyframes; clock on the first screen, scroll-driven below, leaving on scroll-out, reduced
motion) done, reviewed and fixed 2026-10-07, build 2026-10-07.15. M3 and M4 are done except what needs the user's Bricks
samples. Next: the user's end-of-run check (HANDOFF "End-of-run check list"), then sample-bound work.
GRO desktop (2026-10-07, build 2026-10-07.16): the user pasted their GRO homepage, which is drawn entirely without auto
layout. They reported "white between sections" and "text jumping to a new line", and asked for every other bug too.
Thirteen general rules fixed it; GRO is now a corpus file and exact at 1440. The user chose: desktop first, then a
phone pass for free-floating designs as its own plan (see [[gro-phone-pass]]); content in the 64px margin stays exact
at desktop.
Drawn phone design (2026-10-08, build 2026-10-08.2, reviewed and fixed): the user's designers sometimes draw desktop + a 390 phone frame
(GRO). Select both → one paste, two copies swapped at 767; one frame = the automatic phones as before. The user chose
two copies over merged elements, and full pages over per-section fallback; unsure about tablets (default: desktop
adapted). Their pair debug file arrived (repo root, figma-to-bricks-debug-design-inspo-brainstorm.json); first paste
showed drawn carousels (rows running past the phone's edge) stacked → build 2026-10-08.3 makes them Sliders (one card
per view, dots; the drawn peek needs a slider sample). Selecting both frames: Cmd+click in Layers (Shift selects a range).
2026-10-16 → 19 (builds 2026-10-16.1 … 2026-10-19.6): buttons/FAQ/maps/contact-card fixes, real Bricks forms (then the
team switched that form to WPForms by hand), photos keep their drawn size on wide screens / zoomed out, and searchable
lists (search, pills, count, CSV in the panel, scroll boxes). The current status, what's waiting on the user and the
open questions live in CLAUDE.md "Start here: handoff of 2026-10-19"; read that first.

## Slider autoplay — 2026-10-28

Released build `2026-10-28.3`: feature `2b551344`, build commit `979c5b3`, records/push `5e2f98b`.
Local main, origin/main and GitHub were verified equal. Figma component variants looping After delay become
native Slider (Nestable) with Block slides; emitted interval is delay plus speed, drawn controls only,
24px phone arrows and corner-pair recognition. Ordinary designs' five complete replays/warnings are unchanged.
Verifier and blind auditor round3 accepted AC1–AC12 on base `27b787b`; ac-check READY FOR THE USER.
AC13/AC14 remain live paste check **3bo** (renumbered from 3bm); real Figma test expects interval5800/speed800.
Narrow desktop/tablet sliders can have CTA endpoints under arrows (OBS1); phones pass. Existing 12 browser
font/environment failures and 3 unavailable Mac corpus files remain. Full details: HANDOFF and
`docs/plans/2026-10-26-slider-autoplay-ledger.md`.

SSH's system-config ownership error was resolved for the push with a command-scoped explicit trusted config,
preserving byte-identical effective settings and verifying Just-In-N-Out; no system files/remotes/keys changed.
Setup sync still cannot write its read-only bare repository. CLAUDE status edits remain queued behind older
unapplied/denied records at `~/.hermes/plans/figma-to-bricks/slider-autoplay-claude-md-pending.md`.
