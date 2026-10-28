# Brief: FIXER 4 (test gap only) for figma-to-bricks feature "label-floor" (Full pipeline)

Close the round-2 verifier's one finding with tests, then stop at `ready-for-verify`. No source change unless a test proves one is needed; no merge, rebase or BUILD.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, HEAD c206ade, clean, on local main f46f8a2). Work only there; never edit the main folder.
- The finding: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/verifier/verifier.json` (V2-F1) with its probe `verifier/probes/v/n8b-switch.ts` and outputs `n8b-switch.{head,mutant}.txt`, mutant runs `verifier/muts/muts-v2.out.json`. Review 2's mutant list: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/review2/muts/`. Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/fix4/`.
- Ledger `docs/plans/2026-10-26-label-floor-ledger.md`, HANDOFF section in `docs/HANDOFF.md`.

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FINISHER role), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`.

## V2-F1 (low, introduced by the V-F1 fix 364687f)
Review 2's mutant N8b (drop the placement guard in `min-font.ts` `optionOfLook`, so a placed layer counts as a tab or switch option) was killed on a0c3b2b but survives on c206ade: after V-F1 the two-or-more path filters through `linkOfLook`, which checks placement itself, so the guard matters only on the one-option switch path, and no fixture reaches that path with a placed layer. It is not equivalent: (a) a switch with a placed "Save" badge of its look over the track: head keeps "Monthly" at 12, the mutant grows it to 13; (b) a pill beside a placed box drawn as its twin: head grows it to 13, the mutant keeps it.
→ **Fix:** add both cases to the `tabs()` fixture (generic, no names from any user file), assert them in `test/unit/min-font.test.ts`, show the new assertions fail under the N8b mutant and pass on head, then re-run review 2's and the verifier's full mutant lists for `min-font.ts` (not only N8b) and show every one killed or documented equivalent. If `test/fixtures/min-font.ts` grows past ~380 lines, split it by section (tags/pills, links, menus/tabs, controls) in a byte-identical move first.

## Gates before you stop
`npm run check` green; browser suite with `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`, failures equal by name to main's 12 (`~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`); the five files (hydraulics-home, gro-home, repo-root debug-page-1, inspo, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) replayed byte-identical to c206ade; AC1–AC15's named tests green; worktree clean. A session restart kills background runs: run each gate as its own call, long ones to a log ending in `echo EXIT=$? >> log`, waiting with `until grep -q '^EXIT=' log; do sleep 2; done`.

## Rules
- Commit separately (`git commit -m "Verifier V2-F1: …"`, no author override, no `Co-Authored-By` or AI lines; `git diff --cached --name-only` first: CLAUDE.md never staged). Don't push, merge, rebase or bump BUILD; don't edit the worktree's CLAUDE.md; never bare `git stash`. Update the ledger and HANDOFF's Checks line.
- Justin is away: decide anything unclear yourself after researching the code, recorded as "My ruling, not yet confirmed".
- Other bugs: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; empty is normal).

## Return
`{name, status: ready-for-verify|stopped, summary, finding{id, verdict, commit, test, evidence}, mutants{run, killed, equivalent[]}, last_commit, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
