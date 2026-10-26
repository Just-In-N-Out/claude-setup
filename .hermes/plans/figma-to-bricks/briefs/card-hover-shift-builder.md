# BUILDER brief: card-hover-shift [Figma]

## Role and skills

You are the **BUILDER** for the FigmaToBricksV2 feature `card-hover-shift`. Build the approved plan at `~/.hermes/plans/figma-to-bricks/card-hover-shift.md`. The plan is approved; don't re-plan.

Load these skills in this order and say so in your first steps:

1. `skill_view('figma-to-bricks')`, then follow it in the **BUILDER** role, from its worktree step (Step 2) to `ready-for-review`.
2. `engineering-best-practices`. Where they differ, the project skill and Justin's rules win.
3. `test-driven-development`: write a failing test before each code change.
4. `systematic-debugging` whenever a test fails unexpectedly or a corpus number gets worse.
5. `mutation-testing-discipline` for the plan's task 5 (the same-size guard).
6. `frontend-ui-repair`, the specialist skill for UI bugs. It carries the Agent Defect Loop. The main chat runs the reviewer and verifier, so skip its "spawn an agent" steps.

## Where to build

- Worktree: `~/Documents/FigmaToBricksV2/.claude/worktrees/card-hover-shift`, branch **`worktree-card-hover-shift`**, made from local `main` exactly as the project skill's Step 2 says.
- Always pass `workdir` to terminal commands.
- Never edit the main folder, `BUILD` or the copy's `CLAUDE.md`. Don't merge or push.
- Stop at `ready-for-review`:
  - everything committed;
  - `npm run check` and `npm run corpus` green, measured against your saved baseline;
  - `npm run test:browser` run for the new browser test.

## What to build (Justin's picks)

Justin picked **Q1A, Q2A, Q3B, Q4A**. Q3B differs from the plan's ⭐, so the plan text assumes Q3A there. Follow the "Justin's answers (2026-10-22)" section at the end of the plan.

1. **Q1A and Q2A, the main fix.** In the hover copy, each paired layer takes the instance's sizing mode (fill, hug or fixed) on any axis where the hover variant draws it at the same size (±1px). Apply it to both the src and the IR side, at every width. These are plan tasks 1–7 as written.
2. **Q3B, an added task after the Q1/Q2 commits, in its own commit.**
   - **What it covers:** when the hover variant wraps a paired layer in an extra wrapper (here, the arrow's transform wrapper: 19×35 with padding 3/1.88, around the 16×25 arrow), that wrapper must take no more row room than the card's own layer.
   - **Done looks like:**
     1. The hovered copy wraps exactly like the card.
     2. At 360, "Assembly, Test, Paint & Delivery" stays on the label's line when hovered.
     3. An arrow on its own line never pokes below the card.
     4. The arrow's visible hover position and motion stay as designed (±1px).
   - **Rules:** general logic only (any added wrapper around a paired layer); add a fixture test with a RED proof.
   - **Where:** prefer `understand/overlay.ts`, or style sizing.
   - **If it can't be done cleanly:** if it would need `adapt/rules/` breakpoint styles or change how the hover looks, either write a "My ruling, not yet confirmed" or stop with `status: stopped` and the options. Keep the Q1/Q2 commits either way.
   - Add the Q3B case to the 15-width browser check and the after proof (plan task 6): the 360 residual must be gone, not just recorded.
3. **Records (Q4A).** In HANDOFF and the ledger, write the rule wording for the finisher's CLAUDE.md and rules-summary update: "The instance keeps … and how each layer sizes (fill, hug, fixed)", plus the wrapper rule. Don't edit `CLAUDE.md` yourself.

## Before/after pictures

`snap` doesn't hover, so use the plan's scratch repro script (from the planner's evidence in `~/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/`).

1. **Before your first code change**, while the copy still equals `main`: capture the hovered "More services" cards at **990 and 390**, and at **360** for the Q3B case.
2. **After the last task:** capture the same shots again.
3. Copy them to `~/.hermes/plans/figma-to-bricks/shots/card-hover-shift/`, named `before-hover-990.png`, `after-hover-990.png`, and so on.
4. Return their absolute paths in `shots[]`. Never commit them.

Use a scratch copy of the main folder's debug JSON and never edit the original. Justin's screenshot shows Service 01/03/04/05, while the debug file shows 02–05: same component, same cause.

## Other features running in this repo

- `found-layout` and `found-tiles` are in review; `found-contacts` and `found-gates` are finishing; `found-list-head` is queued.
- The planner found no shared files. Stay within this plan's files.
- Whoever merges second rebases and keeps both HANDOFF sections.
- For the paste check, write "next free number on main at merge time", not a fixed number.
- Other features may merge while you build and move the corpus pastes. Compare corpus runs against your own baseline taken in your copy.

## Rules

- You can't ask Justin anything. On a real trade-off, make the ruling and write it down as "My ruling, not yet confirmed". If it can't be decided safely, stop with `status: stopped` and list the options.
- If you run low on steps, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`, naming the worktree and the last commit.
- If you find any other bug, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).
- Return `defect_loop_skills[]` naming any Agent Defect Loop skill you loaded (at least `frontend-ui-repair`).

## Justin's words

> okay I have an issue. As you can see here, for the tablet animations and checking for iPhone and all that, whenever someone hovers over those hyperlinks or something for the animation to happen, you can see how the text moves down. It doesn't stay there. Is it possible that we can fix this error or no?

His picks in the desktop app:

- Q1 "Every width (fixes tablets, phones and the laptop shift)"
- Q2 "Only layers the hover draws at the same size as the card"
- Q3 "Fix it in this feature too"
- Q4 "CLAUDE.md plus the rules summary"
- Model "Opus 5.5 medium builds it, Opus 5.5 xhigh reviews and verifies"

He also confirmed: branch off local `main`, then merge back.

## RESUME — option 1 approved October 22, 2026

**This section supersedes the original stop boundary for the specific responsive-accounting mismatch.** Justin replied `1` to: "Finish both fixes: allow a narrow change to how responsive layout counts the arrow wrapper's space. Keep the same strict test."

1. Resume the existing worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/card-hover-shift`, branch `worktree-card-hover-shift`, saved tip `936cfa4bc50f863d71921941ee14b2d667712dc4`. Do not recreate, reset, discard or stash it. Last parent git check showed only untracked `.superpowers/`; recheck because this is a snapshot.
2. Read the committed ledger/HANDOFF and durable stop evidence under `/Users/justin/.hermes/plans/figma-to-bricks/evidence/card-hover-shift/builder-stop/` before repeating diagnostics. Preserve the failing browser test and TAP. Historical results are not fresh verification.
3. Prior builder report: Q1/Q2 commits `d2270e7`, `b0c50a4`; provisional Q3B `0263b58`. Wrapper compensation fixed wrapping/containment across 60 real-card measurements including Assembly at 360, but the strict motion fixture failed at 375. The planner counted the full wrapper width despite CSS compensation, yielding 23px copy padding vs 24.5px own padding. Treat that as the reported hypothesis and prove the cause yourself.
4. The newly authorized work is **narrow responsive room/minimum accounting for wrapper compensation**, retaining the failing strict ±1px motion oracle. Identify and record the essential extra files in a plan addendum. Check shared board, plans and actual diffs for source/test ownership before changing those files; other sessions' work is not dead just because it is absent from this chat's live list. Coordinate an actual conflict rather than overwrite it.
5. Keep the general-logic rule; no special names/IDs/text/pixels. No unrelated grid/wrapping/phone policy change, alternate wrapper representation or designed-motion change is authorized. Stop with concrete evidence/options if any of those is indispensable.
6. Load the same role skills from this brief (project, engineering-best-practices, test-driven-development, systematic-debugging, mutation-testing-discipline, frontend-ui-repair). Implement test-first, prove the original failing oracle now passes without loosening it, and rerun the established project/plan gates. Report remaining font non-comparability honestly; do not substitute a font or narrow expectations.
7. Preserve the original before/provisional-after evidence. Capture corrected after pictures and label their tested revision; don't silently relabel provisional Q3B shots as final. Archive the original and final proofs durably before reporting.
8. Update plan copy, ledger and HANDOFF with Justin's approval, exact files changed and real gate receipts. Commit and stop at **ready-for-review**. No merge, push, BUILD bump, CLAUDE.md edits or worktree cleanup. A fresh Opus 5.5 xhigh review and independent verifier still precede release.
9. Model remains **Opus 5.5 medium**. At approval its window was exhausted; reset is due **October 22, 2026 12:19 EDT**. The parent must verify quota before dispatch. No switch to Sol authorized.

Justin's words for this continuation: **"1"**.

## MODEL OVERRIDE — latest instruction, October 22, 2026

Justin explicitly asked **"cant you resume with 6.1 sol"**. Resume now on **Sol 6.1 xhigh** (`openai-codex`, `gpt-6.1-sol`), superseding all Opus/quota-wait language above. The remaining pipeline also uses fresh Sol 6.1 xhigh reviewer and verifier, with Sol finisher. Only routing changes: keep all option-1 scope, strict motion proof, ownership coordination and no-merge boundaries. Continue from the existing tip `936cfa4`, preserving untracked `.superpowers/` and original evidence.
