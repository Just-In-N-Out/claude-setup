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

## Updates (later the same night)
- **plugin-header-footer-ticks**: planned (cause: a TICKED box leaves a part out; empty keeps it by design; the panel's words and its
  "leaves these out" line mislead) → wording-only fix; **builder running** (`briefs/plugin-header-footer-ticks-builder.md`). Ask Justin
  for a debug file if his boxes were ticked (then it's a recognition bug, its own job).
- **site-fonts-match** (now **Full**): bdryswi.com's own Roboto 600/ADLaM files 403 → its headings show system sans-serif; the paste
  shows Google Roboto. ⭐ Q1 A taken (match what visitors see; one-line switch to B). **Builder running** (`briefs/site-fonts-match-builder.md`).
  Needs Justin's re-scan for the live AC.
- **site-sticky-header**: verifier-2 clean on dac22907; **auditor-2 running** (`briefs/site-sticky-header-auditor-2.md`). Then rebase onto
  e61c0ca0 (expect notes-only) → receipt → merge as next build, 3eb.
- **media-avif-alt**: fixer 1 done (caf9291f); **Full review round 2 running** (`briefs/media-avif-alt-reviewer-2.md`).
- **site-menu-motion**: merged as 11.6 (3ec).

## Later still (after the 20:06 restart; session now figmatobricksv2-12, peer figmatobricksv2-69)
- **Merged:** 11.7 site-sticky-header (3eb), main = 9f75e8ac. Next: footer-icon-list = 11.8 (3dz, peer's).
- **site-native-structure:** accepted 14/15 on f86ab19d (base 731707c5). After 11.8: `git rebase --onto <main> 731707c5 site-native-structure-stack7`, review (+ verifier/auditor if code conflicts), merge; then site-no-div's builder.
- **media-avif-alt:** reviews clean; verifier running (`briefs/media-avif-alt-verifier.md`); then auditor, rebase, merge.
- **plugin-header-footer-ticks:** built (c0e04ef4); Mini review r1 running.
- **site-fonts-match** (Full) and **bricks-icons M1** (Full): builders running.
- Rule learned: no agent cap → one Chrome suite per agent; hold dispatch above load ~40 (Linux restarted at 20:06 under load ~50).

## Late night (Justin asleep: "keep them all moving whenever you can start something do it")
- Merged 11.8 plugin-header-footer-ticks (3ee), main = 20ce41a8. HOLD my merges until peer's footer-icon-list = 11.9 (3dz).
- media-avif-alt: accepted; rebased onto 20ce41a8 as 93e1afcf (receipt EXIT=0). After 11.9: rebase again + receipt + short review → merge (3ef).
- site-native-structure: accepted on f86ab19d; after 11.9: rebase --onto main 731707c5 → review (+verifier/auditor if code conflicts) → merge.
- **site-no-div builder started early** on f86ab19d (branch site-no-div-build; `briefs/site-no-div-builder.md`); moves onto main after native merges.
- site-fonts-match, bricks-icons M1: builders running.
- Known: site-menu-motion's F2B_SITE_SLIDE_BDRY pin fails on main since 11.7 (stay class); footer-icon-list's 11.9 fixes it test-only.
- Merged 11.10 media-avif-alt (3ef), main = 4f8b6116 (2026-11-11 ~22:55).

## 2026-11-12 01:15
- bricks-icons: review 2 clean (MOVE ON c78fa0cf). Amendment 1 installed (M1 only, AC1–AC7; rules 2–5 prose matched to head's stricter code; old copy plan-approved-v1-before-amendment-1.md). Verifier dispatched on c78fa0cf / base 02481763.
- New job bricks-icons-site (the importer half, AC1–AC5, AC5 live): plan ~/.hermes/plans/figma-to-bricks/bricks-icons-site.md. Full (planner's recommendation; Justin's "go with recommended"). Starts after site-no-div, site-shared-styles and bricks-icons M1 are on main (Task 0 checks).
- 01:57 site-native-structure: verifier 3 clean (READY FOR THE USER, AC15 live). Auditor 3 dispatched. Merge finisher must re-pin media-avif-untouched and site-import-figma-unchanged (src file set).
- 04:22 Linux restarted ~02:15 (log gap 02:14→04:18; load 3, 13 GB free: not an overload). Resumed all four agents by SendMessage: bricks-icons verifier (ac.json clean already), site-native-structure auditor 3, site-fonts-match verifier, site-no-div builder.
- 04:35 site-native-structure: auditor 3 clean; ac-check READY FOR THE USER (AC15 live) on d6f16984.
- 04:40 site-native-structure: merge-prep finisher dispatched (branch site-native-structure-merge from d6f16984: re-pin media-avif-untouched + site-import-figma-unchanged test-only, HANDOFF R8-1/R8-2/auditor P3, receipt). Then short delta review (notes-only rule) → ff merge → after-merge finisher (Build 11.11, paste check 3eg).
- 04:49 site-native-structure: merge prep done (head 172be61a = d6f16984 + re-pins 02c60b05 + HANDOFF 172be61a; receipt-172be61.log EXIT=0). Delta review 9 dispatched. Then ac-check --rebase-receipt → ExitWorktree n/a (session in main) → ff-merge site-native-structure-merge → after-merge finisher (Build 11.11, 3eg).
- 04:55 site-native-structure MERGED into local main (ff to 172be61a; review 9 clean + receipt, notes-only rule). After-merge finisher dispatched (BUILD 2026-11-12.1, paste check 3eg, push). Merge lock held. Next: site-no-div rebases onto this main; site-fonts-match rebase onto it too.
- 05:05 Build 2026-11-12.1 (site-native-structure) committed 56b5076b, pushed; CLAUDE.md Status written; paste check 3eg. Lock released. Next free paste id 3eh.
- 06:15 bricks-icons: verifier clean (READY FOR THE USER 6/7, AC7 live). Auditor dispatched (Opus xhigh) on c78fa0cf / base 02481763. After: rebase onto main 56b5076b (Build 11.12.1) + receipt, merge.
- 06:25 site-fonts-match: verifier clean (READY FOR THE USER 8/9, AC9 live; needs a fresh scan for Roboto). Auditor dispatched on dde55059 / base e61c0ca0. Then rebase onto main 56b5076b (parts.ts import + HANDOFF conflicts likely) → review/receipt → merge.
- 06:45 site-no-div: builder ready-for-review, head ae288ac8 on main 56b5076b (AC1–AC13 RED/GREEN; B-Dry Divs 245→0 elementor, 569→0 plain). Review 1 (Fable high, full) dispatched.
- 07:00 site-shared-styles builder dispatched early on site-no-div head ae288ac8 (Opus xhigh). bricks-icons: auditor clean; ac-check READY FOR THE USER (6/7, AC7 live) on c78fa0cf. Rebase finisher dispatched onto main 56b5076b (+ receipt; source conflicts → full path).
- 07:40 site-fonts-match: auditor clean; ac-check READY FOR THE USER (8/9, AC9 live) on dde55059. Rebase finisher dispatched onto main (source conflicts in src/core/site likely → full path).
- 07:48 Linux restarted ~07:01 (crashlog gap 07:00:50→07:02:57; 16 GB free, load 2.5: not an overload; 2nd restart today, also 02:15). Resumed 4 agents: site-no-div reviewer 1, site-shared-styles builder (4f4599f3), bricks-icons rebase finisher (9bf4d3a0, re-pins logged), site-fonts-match rebase finisher (nothing recorded yet).
- bricks-icons rebased → 643109ec on main 56b5076b; render.ts test conflict → full path. Review 3 (delta, Opus high) dispatched; then verifier → auditor → ac-check on 643109ec.
- bricks-icons review 3 clean (MOVE ON 643109e; R3-1 P3). Old verifier/auditor archived as -c78fa0c. Verifier 2 dispatched on 643109ec / base 56b5076b.
- site-no-div review 1: REVIEW AGAIN (3 P2: R1-1 % sizes fold, R1-2 nested relative font sizes, R1-3 HANDOFF live check words). Fixer 1 dispatched (site-no-div-fix1 from ae288ac8). Shared-styles builder told.
- site-fonts-match rebased → 45b9c3e0 (source conflicts → full path; AC7 base sums stale). Fixer 2 dispatched (regenerate 3 elementor sums, test-only). Then delta review (resolution + re-pins + sums) → verifier → auditor → ac-check. Repo: 8 empty unreachable objects from 2026-11-10 deleted by the session; fsck clean.
- bricks-icons verifier 2 handed back 'incomplete' (ACs 6/6 proven; long gates running in background). Told it to finish gates and report final verdict.
- site-fonts-match fixer 2 done: c8ad17b8 (AC7 elementor sums from 56b5076b; receipt-c8ad17b EXIT=0). Review 3 (delta: resolution + re-pins + sums) dispatched.
- site-fonts-match review 3 clean (MOVE ON c8ad17b). Old verifier/auditor archived -dde5505. Verifier 2 dispatched on c8ad17b8 / base 56b5076b.
- site-no-div fixer 1 done: 374ea2ce (R1-1..R1-4 fixed; 11/11 mutants). Dispatched: plan amendment 1 (AC14 words, Fable) + review 2 (delta, Opus high). Shared-styles builder told to rebase onto 374ea2ce.
- site-no-div: amendment 1 installed (AC14 words). Amendment 2 (AC4 vs builder's Section/Container tag rule) dispatched. AC5 rows (ac5-rows.txt) go to the next fixer step after review 2.
- site-no-div review 2: REVIEW AGAIN (R2-1 flex-row % exception, R2-2 heading font settings). Fixer 2 dispatched (+ AC5 rows). Round 3 = last review (project cap).
- site-no-div amendment 2 installed (sha 60206e75, AC4 = head's rule S). AC4 rows sent to fixer 2.
- site-no-div fixer 2 done (d915f7dc). Dispatched: amendment 3 (AC5 words) + review 3 (last round, delta from 374ea2ce). Shared-styles builder to be told the final head after review 3.
- site-no-div review 3 MOVE ON (d915f7dc). Waiting on amendment 3 → then verifier. Shared-styles builder told final head.
- site-no-div amendment 3 installed (40770b68). Fixer 3 (test-only AC5 rows + plan copy) dispatched on d915f7dc → then short review → verifier → auditor.
- site-no-div fixer 3 done: 828f7dc0 (test+docs only; 50/50 mutants). Short review 4 dispatched.
- site-no-div review 4 MOVE ON (828f7dc0). Verifier dispatched on 828f7dc0 / base 56b5076b.
- site-fonts-match verifier 2 clean (READY 8/9 on c8ad17b). Auditor 2 dispatched.
- site-fonts-match: auditor 2 clean; ac-check READY (8/9) on c8ad17b8; ff-merged into main (lock held). After-merge finisher dispatched (BUILD 2026-11-12.2, paste check 3eh). bricks-icons and site-no-div will need a rebase onto the new main after.
- Build 2026-11-12.2 (site-fonts-match) 6cd6154e pushed; 3eh. Lock released. Next free paste id 3ei.
- bricks-icons verifier 2 clean (READY 6/7 on 643109ec). Dispatched in parallel: auditor 2 on 643109ec + rebase-2 finisher onto 6cd6154e (branch bricks-icons-final2; notes-only rule if only HANDOFF/pin conflicts).
- bricks-icons rebase-2: 37687fcb on 6cd6154e, HANDOFF-only conflict, receipt EXIT=0. Short review 4 dispatched; auditor 2 (on 643109ec) still running. Merge on auditor clean + review 4 clean + receipt (notes-only rule).
- bricks-icons review 4 clean (37687fcb); waiting on auditor 2. site-shared-styles builder done (e124dcda); review 1 (Fable) dispatched. Started early on e124dcda: shared-palette builder, plugin-parity builder. importer-parity waits (same site code as shared-styles' fixes).
- bricks-icons M1 ff-merged into main (37687fcb; notes-only rule). After-merge finisher dispatched (BUILD 2026-11-12.3, paste check 3ei). Lock held.
- Build 2026-11-12.3 (bricks-icons M1) 7f54b0a5 pushed; 3ei. Lock released. Next free paste id 3ej. site-no-div (on 56b5076b) must rebase onto 7f54b0a5 after its auditor.
- site-shared-styles review 1: REVIEW AGAIN (R1-1 em line heights). Fixer 1 dispatched (+R1-4 next steps, R1-5 HANDOFF). R1-2 (font-family vs fonts rename) to handle at rebase onto main. importer-parity still waits.
- site-no-div verifier clean (13/14 on 828f7dc0); V-1 sticky-wrapper → follow-up (round cap). Auditor dispatched.
- site-shared-styles fixer 1 done (7b7501bd). Review 2 (delta) dispatched. shared-palette and plugin-parity builders to be told the new head after review 2.
