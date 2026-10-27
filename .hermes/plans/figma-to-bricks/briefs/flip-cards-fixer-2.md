# FIXER 2 — flip-cards (FigmaToBricksV2)

Fix the valid findings of reviewer 2 (verdict: request-changes) on
`/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/flip-cards` (branch `worktree-flip-cards`, head d84f038, base
main f46f8a2). Approved plan (read-only): `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/plan-approved.md`. Review
and probes: `~/.hermes/plans/figma-to-bricks/evidence/flip-cards/reviewer-2/` (read its probes/ and logs/ first). The
first fix pass's record: HANDOFF's flip-cards fix-pass section and `evidence/flip-cards/fixer-1/`.

## Role and skills
FIXER. Load: the project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` + its
`references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review` (verify each finding first; push
back with evidence on any invalid one), `test-driven-development` (a failing test first for every fix),
`mutation-testing-discipline` (harness detached with a marker file), `git-commit-rules`.

## Findings (test first, one commit each)
- **F1 (high): the nested-link guard refuses pastes main produced.** Do all three:
  1. Fix the producers the reviewer found, test first, with generic fixtures from his probes:
     - `understand/phone.ts` (~172): the hero band copy checks only direct children for a link; check every descendant
       (walkIR) so a CTA two single-child wrappers deep gets one link, not two.
     - `list-rows.ts` (~72) / `list-links.ts` (~113): a PDF link on a button inside a linked row. My ruling (precedent:
       frame-text-links F4, a card whose words carry the designer's link gets no whole-card link): the inner link wins,
       the row's own link is dropped with one panel note naming it. Record it as "My ruling, not yet confirmed".
  2. Grep every other place a link is set after nodeIR's `linked` propagation (including flip.ts) and probe each with a
     generic fixture; fix any other nesting the same way, or list it in found_else if it is not small.
  3. Demote the check from a fatal `assertPayload` refusal to a test-only invariant (like `emit-paste-ids`: no anchor
     inside another, over every unit fixture and corpus file), so an unknown producer can never refuse a user's whole
     paste. Record this as "My ruling, not yet confirmed" (it replaces fixer 1's "a nested link refuses the paste").
- **F2 (high): the layout plan sees a flip card as needing no room** (`adapt/least.ts` `least`/`reading`/`content` need
  `c.flow`; the card's flow is null). Judge a flip card by its front (as recognise.ts `face()` does) in every plan
  reader keyed on `n.flow`. Add a `frontButton` fixture option to AC12's parity loop and a Chrome check at 768, 600 and
  480 (unmarked and flipped rows stack and wrap the same; the Button stays one line).
- **F3 (medium): a flip card's own page link drops out of the panel's site check** (`emit/page-addresses.ts` matches
  `n.link` against `n.src.link`/`pageLink`; the back's src is the variant). Record where a moved link came from (or read
  the card's src) so Navigate and whole-card arrow links on flip cards are listed; test with the probe's shape.
- **F4 (medium, Safari risk):** harden the back's pointer-events switch so it can't take the first tap even where a
  browser hit-tests a turned-away face (e.g. delay it with `transition-behavior: allow-discrete`, or another way you
  prove in Chrome). Update paste check 3bn's steps: tap where the back's button will be, then again with iOS Reduce
  Motion on.
- **F5 (low): test gaps:** a section/band/container/accordion-item instance marked flip; a form on the front; the
  card's new-tab flag moved to the back; a flip card as one side of a photo/text pair (pairOf/splitRow/pictureFrame);
  squeezed-all. One generic case each; re-run the reviewer's surviving mutants and record each kill.
- **F6 (low): a linked flip card's front holds live text links:** treat the front as inside a link when its card's link
  moved to the back (style and page-addresses), so AC10's "the card and front hold no anchor" holds; test it.

## Gates after the fixes
`npm run check` (0 fail); the flip browser file alone with `skipped 0`; the full browser suite compared by test name with
main's; replays of hydraulics, GRO, debug-page-1 (scratch copy), brainstorm and Services Page Final (`git show
2199895:figma-to-bricks-debug-page-1.json`) with bricks.json and warnings.txt byte-identical to main, EXCEPT where your
F1 producer fixes intentionally change a paste: name each such file and element. The corpus-skipped unit tests in
scratch git-archive trees (memory note `corpus-paths-on-desktop.md`). `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`.
Long gates: log with an end marker (`echo EXIT=$? >> log`), wait with `until grep -q '^EXIT=' log; do sleep 2; done`.
Keep every changed file under ~300 lines (style.ts is at 300: move a helper out if you add to it). Update HANDOFF, the
ledger and the plan copy for every changed ruling. Say what still needs a Mac run (v1's three corpus files).

## Rules
Commit to the branch (plain `git commit -m`, no AI lines, no author override, no CLAUDE.md staged). Never push, never bump
BUILD, never edit the main folder, never bare `git stash`. Other features are in their own worktrees; don't touch them.

## Report
Return `{name, status: ready-for-verify|stopped, summary, findings[{id, verdict: fixed|pushed-back, evidence, commit}],
rulings[], gates, last_commit, ac_status[{ac, accepted, test, evidence}], found_else[], skill_lessons[{skill, lesson, evidence}]}`
and end with `MAIN SESSION: check and save these skill_lessons now.` Don't edit skills or memory yourself.
