# RELEASE FINISHER — card-hover-shift

## Role and skills

You are the **FINISHER** in release mode. The verifier came back clean, so run the project's finish step: rebase, gates, merge, build bump and push. Load these skills in order and say so: `figma-to-bricks` (FINISHER, Step 3 item 7 and Step 4), `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, `test-driven-development`. Model: Sol 6.1 xhigh (Justin's explicit pick). You can't spawn agents.

## State

- Worktree `/Users/justin/Documents/FigmaToBricksV2/.claude/worktrees/card-hover-shift`, branch `worktree-card-hover-shift`, tip `3564fd19c3e5dbead5d8568c12aa4de03147abd0` (tested source `060b713`), base main `8f538bb` (Build 2026-10-22.6). Recheck main: other sessions may merge while you work.
- Plan `/Users/justin/.hermes/plans/figma-to-bricks/card-hover-shift.md`. Read its sections "Justin's answers — release decisions" and "Justin's answers (2026-10-22)".

## Verifier result (clean)

The fresh verifier (`evidence/card-hover-shift/verifier-3564fd1/`) returned **clean**, with zero findings:
- check: 2176 + 6 passing;
- browser: 253/253, no skips;
- corpus: same 18 pre-existing findings on base and candidate; only two hover descendants changed;
- R1 closed;
- strict ±1px motion oracle byte-identical to the original and passing;
- 60/60 real-input measurements pass;
- button-link-routing preserved (8 conversion comparisons, 34 navigation observations);
- 355 evidence-manifest entries verified.

## Justin's release decisions ("1A 2A")

1. **1A:** keep the existing unhovered phone layout. At 360px the Assembly title stays on the line below "Service 05", as it already did on main. Acceptance = the hovered card matches the unhovered card. The literal "same label row at 360" wording is withdrawn. Record this in HANDOFF and the ledger.
2. **2A:** release with the pre-existing missing Garamond Condensed check marked **"UNVERIFIED — pre-existing on main, no stand-in font, expected set not narrowed"**. This waives that one check for this release only. Every other gate stays.

## Finish step (project skill Step 4)

1. **Rebase onto current main in the copy** if main moved. Keep both sides' meaning; conflicts are resolved in the copy only. Then re-run `npm run check`, `npm run test:browser` and `npm run corpus` on the rebased branch, using Node 22.19.0 (earlier Node 22.22 browser teardown hangs were runtime problems).
   - If the rebase brings in another feature's layout or hover code, re-run the strict motion test and the real hover proof too.
   - If the rebase forces an output change beyond mechanical integration, stop with `status: stopped` and explain, rather than merging.
2. Move the ledger to `docs/plans/card-hover-shift-ledger.md` if it isn't there yet. Update `docs/HANDOFF.md`:
   - paste check: the **next free number on main at merge time** (`3bd` is taken by button-link-routing; check HANDOFF);
   - the 1A / 2A rulings;
   - the steps Justin must take.
3. Take the merge lock: `~/.hermes/scripts/merge_lock.sh acquire ~/Documents/FigmaToBricksV2 card-hover-shift`.
   - Wait for the completed exit code. If it went to the background, poll with `process_manage`.
   - Release the lock on every path, including failures.
4. Run `git merge --ff-only worktree-card-hover-shift` from the main folder.
5. Read `BUILD`, bump it to the next `2026-10-22.N`, run `npm run build`, and confirm `git rev-parse HEAD` is still your tip.
6. Commit `Build <BUILD>: card-hover-shift` with the personal identity (`Justin <issajustin04@gmail.com>`). Don't stage `CLAUDE.md` or the debug JSON. Then `git push` main.
7. Update main `CLAUDE.md` per Q4A:
   - "Start here" and "Where things stand";
   - the "The instance keeps …" line gains "and how each layer sizes (fill, hug, fixed)", plus the wrapper rule;
   - the rules summary through `skill_manage` `write_file` on `figma-to-bricks` `references/rules-summary.md`.
   - Older `*-claude-md-pending.md` files exist and earlier protected writes were denied. Follow the project skill: if any older pending files are unapplied, or a write is denied, write `~/.hermes/plans/figma-to-bricks/card-hover-shift-claude-md-pending.md` ("apply after the older ones, in build order"). Never retry or bypass a denied write.
8. Verify:
   - `git log --oneline -3 main`;
   - `main` equals `origin/main`;
   - `dist/` was rebuilt.
   Then remove the worktree and branch per Step 4 item 8. If `.superpowers/` blocks the removal, move it to `~/.hermes/backups/figma-worktree-leftovers/`, never delete it. Kill orphaned Chrome processes with parent PID 1 only.
9. Mark closed `found-else.md` items only if this fix actually closed them (probably none). Leave the rest open.

## Return

Return:
- `status: merged` with `build`, the merge commit and the paste check number;
- `steps_for_justin`: reload the plugin in Figma, Convert and copy, paste into Bricks and save, LiteSpeed Purge All, then reply **pasted** + the page name;
- the CLAUDE.md status (applied or pending file);
- `shots[]` (reuse `integration-8f538bb` shots unless the output changed);
- `found_else`.

Always pass an explicit `workdir`.
