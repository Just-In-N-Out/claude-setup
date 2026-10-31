---
name: website-importer-paused
description: "Website importer (J0 web-compare, J1 web-capture) paused 2026-10-31 at Justin's word after their last reviews; where each job stands and how to resume"
metadata:
  node_type: memory
  type: project
  originSessionId: 519648e7-1ba1-46ba-a0a3-91e300b908f4
  modified: 2026-10-31T10:15:47.971Z
---

Justin, 2026-10-31: "Just wrap things up after this review … We're done." RESUMED the same day: "Go, straight through (Recommended)" to build all 11 jobs; this note is the state at the pause. The website importer (plan
`~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md`, 11 jobs in 4 waves) stopped after wave 1's last
reviews. Nothing merged into `main`; no wave-2 builder started. Full step log:
`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md` (last entries 2026-10-31).

- **J1 web-capture:** review 9 at `3705de1` (branch `web-capture-fix-8`, worktree `agent-aa8fc9df89fe1fe2f`) is clean
  (MOVE ON); P3s in `evidence/web-capture/follow-ups.md`. Resume = verifier → blind auditor → `ac-check.sh` → finisher
  → ff-merge (AC14's bdryswi.com part owed to Justin).
- **J0 web-compare:** review 7 at `b40a81d` (branch `web-compare-fix-5`, worktree `agent-a3bc5924f0eed70b2`) says
  REVIEW AGAIN: 1 P2 (R7-1, small drift chains with no limit; carry each row's/band's unexplained remainder down).
  Resume = fixer 6 from `b40a81d`, then a delta review.
- Story base for both: `3ea33bb`. Wave 2 plans approved and waiting: web-tiers `503dc8b`, web-panel `c9e95c6` (AC17
  alt text), web-embeds `a428659`.
- **Rulings taken under his away grant, not confirmed:** capture F31 (timer pop-ups read open), F32 (wheel only, no
  mouse move), F35 (pulse/blink 6 s limit), F36 (note leaves out touchstart), R9-1's options; compare R30–R37 and
  R7-3 (does an icon's own margin count as its room?).
- **Owed by Justin:** allow-list the capture past bdryswi.com's bot check; confirm bdryswi.com, letsgro.ai and the
  plugin-made site as his; two Bricks samples (Interaction "Enter viewport → Start animation, run once" and "Show
  pop-up" on click) by wave 4. Alt text "Keep the old site's" goes into CLAUDE.md at J4's finish.

**Why:** a resumed session must not restart the jobs or redo finished rounds. **How to apply:** read the log's last
entries and this note, run `review-check.sh` on each evidence folder to confirm the state, then continue from the
resume step named above. Related: [[brainstorm-goes-to-planner]], [[bdry-home-copy]], [[run-without-stopping]].
