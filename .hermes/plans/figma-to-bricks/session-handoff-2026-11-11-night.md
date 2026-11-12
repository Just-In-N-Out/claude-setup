# Session hand-off — FigmaToBricksV2 website importer, 2026-11-11 night (session figmatobricksv2-d1)

Supersedes `session-handoff-2026-11-11.md`. Read global `~/.claude/CLAUDE.md` pipeline + repo `CLAUDE.md` first. Justin is
**asleep**: "keep everything running" — take ⭐ answers, merge what passes, never write to WordPress, never load bdryswi.com, nothing
paid. When he's back: one plain summary (what merged, builds, numbered live checks).

## Standing rules set today (memory)
- **No agent cap** (memory `run-without-stopping.md`, 2026-11-11). earlyoom check each time an agent returns; memory scopes on tests.
- **Notes-only rebase rule** (memory `notes-only-rebase-rule.md`): a rebase whose only conflict is HANDOFF/ledger (both sides word for
  word, code identical) — and a test-only pin update a merged feature forces — needs a short delta review + an AC test re-run
  receipt, no new verifier/auditor. `ac-check.sh` prints REBASE NOT ACCEPTED for it; record the rule in follow-ups and merge.
- Ledger moves into `docs/plans/` in the merge's build commit on main (not a branch commit), so the accepted head fast-forwards.
- Paste-check ids: other session (figmatobricksv2-14) has 3dz (footer-icon-list); this session takes 3ea onward in merge order.
  Used: 3ea media-clickable, 3ed site-scroll-lock, 3ec site-menu-motion; 3eb reserved for site-sticky-header. Next free: 3ee.
- Merge lock: `~/.hermes/scripts/merge_lock.sh acquire|release ~/Documents/FigmaToBricksV2 website-importer-d1`; message the other
  session (`figmatobricksv2-14`) before taking it and send the new main SHA after.

## Main
`main` = `origin/main` = `e61c0ca0` **Build 2026-11-11.6**. Merged today in this session: 11.4 media-clickable (3ea), 11.5
site-scroll-lock (3ed), 11.6 site-menu-motion (3ec). Live checks owed to Justin: 3ea, 3ed, 3ec (+ older 3do–3dy).

## In flight (evidence `~/.hermes/plans/figma-to-bricks/evidence/<job>/`, briefs in `briefs/`, each job's `follow-ups.md`)
1. **site-sticky-header** — accepted; moved onto 11.5 as `site-sticky-header-final` `dac22907` (parts.ts code conflict, resolved
   lock-first; review-3 clean). **Verifier-2 running** (brief `site-sticky-header-verifier-2.md`, base `11f07742`). Then blind auditor
   (fresh brief, base 11f07742, head dac22907), ac-check `--reviews`, then rebase onto e61c0ca0 (likely HANDOFF-only → notes rule:
   short review + receipt), merge as next build, paste check **3eb**; merge finisher fixes HANDOFF:83 (R3-1).
2. **site-native-structure** — `site-native-structure-stack7` `f86ab19d` on base `731707c5` (footer-icon-list's head); plan amendment 2
   installed; reviews 5, 6 clean. **Verifier running** (brief `site-native-structure-verifier-2.md`). Then auditor, ac-check; merge
   after footer-icon-list lands (rebase onto main then: big — HANDOFF + site jobs since → likely a real move: review + verifier +
   auditor unless notes-only).
3. **media-avif-alt** (Full) — review 1 REVIEW AGAIN (R1-1 P1 alt written on a record id now holding another item; R1-2 P2 key
   prompt takes typed-ahead Enter). **Fixer 1 running** (brief `media-avif-alt-fixer-1.md`, branch `media-avif-alt-fix1`). Then Full
   round 2: a fresh full review of the whole story from 02481763 (Opus high), then verifier → auditor → ac-check → rebase → merge.
4. **bricks-icons** (Full, M1 = Figma plugin side) — **builder running** (brief `bricks-icons-builder-m1.md`). Then Full review r1
   (Fable high) … M2 (importer) builds after site-shared-styles.
5. **plugin-header-footer-ticks** (Mini bug: plugin pastes header+footer with both ticks off) — **planner running**. Then auto-go
   builder → review(+verifier work) → auditor → merge.
6. **site-fonts-match** (Mini bug: the paste's font looks different from bdryswi.com; told Justin no manual WP font import) —
   **planner running**.
7. **footer-icon-list** — the other session's (verifier/auditor, rebase onto main, merge as next free build, 3dz).

## Planned and approved, waiting
- **site-no-div** (Full): builder starts once main holds site-native-structure's build commit.
- **site-shared-styles** (Full, amendment 1 installed: palette by value `--color-<hex>`): after site-no-div.
- **importer-parity**, **plugin-parity** (Full), **shared-palette** (Mini, amendment 1 installed): after site-shared-styles.
- **bricks-icons M2**: after site-shared-styles.

## Done for Justin, owed later
- Footer paste help: footer.json was on his clipboard; he hasn't sent screenshots.
- structure-parity audit report: `evidence/structure-parity/report.md`.
