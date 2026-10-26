# Brief: FIXER 1 (intermediate finisher) for figma-to-bricks feature "label-floor" (Full pipeline)

Fix review 1's valid findings test-first, then stop at `ready-for-next-review`. No merge, no rebase, no BUILD.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, reviewed HEAD 6cfd9e2, base cd9c1c9). Work only there; never edit the main folder.
- Approved plan (contract, read-only): `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md` (AC1–AC15; AC9 live). Worktree copy `docs/plans/2026-10-26-label-floor.md`; ledger `.superpowers/sdd/2026-10-26-label-floor/progress.md` (commit it with each fix).
- Review 1's evidence: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/review1/` (probe outputs `probe-outputs.txt`, mutation runs `muts-r1*.out.json`, scripts `scripts/mutate.mjs`, scratch copies `src-head`/`src-base`/`src-mut`). Write your own evidence to `~/.hermes/plans/figma-to-bricks/evidence/label-floor/fix1/`.

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FINISHER role, and `references/rules-summary.md`; only the worktree `CLAUDE.md` sections you need), `engineering-best-practices`, `receiving-code-review` (verify each finding before fixing; push back with evidence on any that isn't valid), `test-driven-development` (a failing test before each fix), `mutation-testing-discipline`.

## Review 1 findings (verdict approve-with-fixes) and the main session's ruling on each
**F1 (medium): menu and footer links get the minimum, their siblings don't.** `linkWords` (`src/core/understand/min-font.ts:52–59`) marks any short one-line linked text starting with a go-word (explore, discover, view, see, browse, visit, read, check out); nothing excludes a menu. `pillShape` also counts a nav's "active" item in a round painted box as a pill. Probe 1 on HEAD: header menu at 14px, "Explore" and "Visit us" → 15 while Home/About/Contact stay 14; footer column at 12px, "View all products" and "Read our blog" → 15, siblings 12; active-menu pill "Home" 12 → 13, Work/About stay 12.
→ **Fix.** A menu or link list is never "Learn more"-style and its active-item pill isn't a tag: leave out words that are one of a row or column of three or more sibling short links of one look (reuse `understand/site-header.ts` `menuItem`/`links` where they fit, don't duplicate them), and a pill whose sibling links are plain words. Add a nav, a footer link column and an active-menu pill to AC4's controls (test "other small words keep their drawn size"). Record it in the ledger and HANDOFF as "My ruling, not yet confirmed (narrows 2A): menu and footer links keep their drawn size". Hydraulics and GRO must keep the current output for their real labels (prove with the by-id diff vs 6cfd9e2: any change must be explained).

**F2 (medium): a "Learn more →" drawn without auto layout keeps its small size inside a row.** A frame or group of words + arrow with no auto layout becomes an inferred fixed-width row with zero free room, so it is itself a tight row; its one gap gives at most half, and `widens()` (`give-way.ts:58–64`) refuses any parent that isn't a column, so inside a CTA row `keepDrawn` leaves the words at 11px with the note "the row has no room" though the outer row has room. The same link with auto layout (hugging) grows to 15. Probe 2: in the hero pair `GIVE Hero pair {"gap":12,"widen":5}`, `SEE ALL WORK min -` + that warning; alone in a column `{"gap":4,"widen":39}`, `SEE ALL WORK min 15`.
→ **Fix (general):** a tight row inside a row passes its widening up (`grownAlong` already returns `giveWay.widen`), so the outer row gives, widens or keeps its words drawn as one unit (post-order already visits the inner row first). Only if that proves unsafe, the alternative is to treat an unpainted words+arrow frame as hugging; say which you chose and why. Add a free-drawn link group inside a CTA row to the give-way fixture (and its browser test if it renders the case). The panel note must only say "no room" when no row up the chain has room.

**F3 (low): three branches survive every test.** R1 `least.ts` `reading()` reading a tight row's gap with `gapAt` instead of `rowGapAt` (GRO paste byte-identical: equivalent on our inputs); R2 `grownAlong`'s hugging-box recursion replaced by `boxGrowth(n).w`; R3 a hugging column's growth summed instead of its widest item.
→ **Fix R2, R3:** fixtures for a hugging wrapper around a pill, and a hugging column of two grown links, each inside a tight row; re-run those mutants (review 1's `scripts/mutate.mjs` works on a scratch copy) and show them killed. **R1:** kill it if a fixture reaches it cheaply; otherwise document it as equivalent in the ledger with why.

**F4 (low): plan and paste disagree on a tight row's gap where it wraps.** `rowGapAt` takes the give off at every tier; `givenGaps` only where `layout.row === "keep"`; the plan under-counts a wrapping tight row's least by give × (k−1) (GRO header on tablets: 16px). No effect seen.
→ **Record** as an accepted approximation in the ledger and HANDOFF (no code change), unless the fix for F2 makes it trivial to align.

## This machine
- Chrome: `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`. Browser baseline at main: 12 font-environment failures by name (`~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`).
- `npm run corpus` measures nothing here (Mac paths). In a scratch copy (never the worktree), re-point corpus.json's hydraulics/gro entries to `corpus/files/` to un-skip the 22 corpus unit tests. Measure the five files (hydraulics-home, gro-home, Repairs = repo-root debug-page-1, inspo, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) with replay/snap and the scripts in `evidence/label-floor/corpus/`; compare with 6cfd9e2.
- Local `main` has moved to f46f8a2 (faq-answer-space merged; HANDOFF overlaps only). Don't rebase: the final finisher does.

## Gates before you stop
`npm run check` green; browser suite: only the 12 known failures; the five files: by-id diff vs 6cfd9e2 with every change explained; lint no worse; AC1–AC15's named tests green on HEAD; worktree clean (everything committed, scratch outside it).

## Rules
- Commit each fix separately (plain `git commit -m "Review F1: …"`, no author override, no `Co-Authored-By` or AI lines; `git diff --cached --name-only` first: CLAUDE.md never staged). Don't push, merge, rebase or bump BUILD. Don't edit the worktree's CLAUDE.md. Never bare `git stash`.
- You can't ask Justin anything. Rulings: "My ruling, not yet confirmed" in `rulings[]`, the ledger and HANDOFF. A fix that would need a new product decision: stop with the options.
- Other bugs: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; empty is normal).

## Return
`{name, status: ready-for-next-review|stopped, summary, findings[{id, verdict: fixed|pushed-back|recorded, commit, test, evidence}], rulings[], last_commit, shots[], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
