# Role: FIXER, round 2 — djtrees-phone-menu (car 12; the blind AC auditor's NOT ACCEPTED)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it (Chrome, fonts as
`data:` URLs with a load check, ticks as a JSON string, bounded mutation runs, never end your turn to wait).

`ac-check.sh` says **NOT ACCEPTED: AC5 and AC8** on head `228d28b8ffbcd6e41dd633f3eb1f8ce5b2a91c1b` (car 12, branch
`train-phone-menu`, on car 11 `5a5beeb294a9d2f052d5c11a6095df49fd2c4f94`). The verifier accepted both; the blind auditor
did not. Read both reports: `E/verifier/ac.json` (+ logs) and `E/auditor/ac.json` with `auditor/ac8-228d28b.log`,
`auditor/supporting-linked-logo-228d28b.log`, `auditor/shots-output.txt`, `auditor/ac5-fixture-390.png`,
`auditor/ac8-390.png`, `auditor/ac8-991.png`, `auditor/scripts/`.

## The finding (A1, P1 per the auditor)

A linked picture logo renders too small where the menu folds and the actions float mid-bar. `adapt/rules/menu.ts`
writes the logo picture's width, `height: auto`, `widthMax: calc(100% - (TAP + gap)px)` and `margin-right: auto`. Bricks
prints a linked image as `<a href><img id=brxe-…></a>` (`test/browser/render.ts` prints it so; HANDOFF: Bricks puts a
linked picture's attributes on the img), so the `<a>` is the row's flex item: the img's percentage max-width resolves
against the `<a>` and the auto margin never reaches the row. DJ Trees: 88×24 at 390 instead of 148×40, 137×37 at 991
instead of 197×53, FREE ESTIMATE 227px from the ☰ at 991. With only the logo's link removed, everything is exact. The
plugin links picture logos home (header-bar 29.3), so this hits every such logo.

1. **First explain the disagreement** with evidence: why the builder's/reviewers'/verifier's AC8 receipt measured 39.9px
   (was its logo unlinked: no site address, ticks, a different render path, a stale snapshot?). Make the AC8 receipt
   and the AC5 browser test render the logo the way a real paste links it, so they fail on this head (RED).
2. **Fix it as a general rule** (the plugin's own rule in `menu.ts`, or where the linked picture is emitted): the logo's
   size and its push to the left must hold whether the picture is linked or not, in Bricks' real markup. Prefer what
   Bricks offers for a linked image (check `reference/bricks/` samples and Bricks' own CSS in
   `reference/bricks/frontend-2.3.9/` for how an Image with a link is printed and sized) over custom CSS; never name
   another element's id. Keep every other rule's output unchanged.
3. Also A3 (P3, same file, cheap): the logo's custom CSS writes `aspect-ratio: 256 / 69;` twice in one rule.
4. Gates: `npm run check`; every phone-menu AC test by name (`ok` line, `# pass` ≥ 1, browser `skipped 0`); the AC8 DJ
   Trees receipt with a linked logo, ticks off and on (390: logo ≈40px tall at x16; 991: ≈53px with FREE ESTIMATE beside
   the ☰); the blast-radius witness (six real files plus fixtures, ticks off and on; switch off = car 11 byte for byte);
   cars 7–11's AC tests that share files still green. Bounded mutants for the fix.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu`; write `E/fixer-2/`.
- **Task 0:** in your own worktree, `git reset --hard 228d28b8ffbcd6e41dd633f3eb1f8ce5b2a91c1b`. Commit on your branch
  (fix + tests, then HANDOFF line + ledger). Don't rebase. Report the new head (full SHA).

## Skills

`receiving-code-review`, the project skill (FIXER role), `engineering-best-practices`, `test-driven-development`,
`systematic-debugging` (for step 1), `mutation-testing-discipline`.

Return per finding: verified or pushed back (evidence), the cause of the disagreement, the fix, red→green tests, mutants,
new head, gates, `found_else`, `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
