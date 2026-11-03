---
name: website-importer-paused
description: "Website importer (11 jobs): paused then resumed 2026-10-31; Justin then capped review rounds at 3 after ACs; wave 1 combined (89022ab) and rebasing onto main 1aef12f before its AC check; wave 2 builders started from 89022ab"
metadata:
  node_type: memory
  type: project
  originSessionId: 519648e7-1ba1-46ba-a0a3-91e300b908f4
  modified: 2026-10-31T10:15:47.971Z
---

Justin, 2026-10-31: "Just wrap things up after this review … We're done." RESUMED the same day: "Go, straight through (Recommended)" to build all 11 jobs. **Later that day he capped review rounds** ([[review-round-cap]]): web-capture fix 10 (branch web-capture-fix-10) and web-compare fix 7 (web-compare-fix-7) are the last fix passes (both past 3 rounds); then one finisher puts both on `main`, the ACs are checked on that head (verifier + auditor + `ac-check.sh`; a failed AC is fixed), and they merge; wave 2+ jobs: ACs first, at most 3 review→fix rounds. **19:10:** combined head 89022ab passed every gate; main had moved (landing-page six, 1aef12f), so a rebase finisher makes `wave1-final`, then verifier+auditor ×2 and `ac-check.sh` (no `--reviews`), then merge. For speed the 3 wave-2 builders started from 89022ab and finish with `git rebase --onto main 89022ab`. The bullets below are the state at the pause. The website importer (plan
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

**Live website, no Figma design (Justin, 2026-11-02):** "I want to be able to import a live website, not related to Figma, using my plugin" — he chose **"Address in the panel"** over "File drop is fine" and "Not in Figma at all": type the site's address in the plugin panel; a small helper he starts once on his PC reads it in Chrome (the capture) and hands the result to the panel; Convert and paste. New job `web-address` (planner dispatched 2026-11-02). Figma only hosts the panel.
