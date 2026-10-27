# Brief: FIXER 3 for figma-to-bricks feature "label-floor" (Full pipeline)

Fix the verifier's one finding test-first with Justin's ruling, then stop at `ready-for-verify`. No merge, no rebase, no BUILD.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, HEAD a0c3b2b, clean, rebased onto local main f46f8a2). Work only there; never edit the main folder.
- Approved plan (read-only contract): `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md`. Worktree plan copy `docs/plans/2026-10-26-label-floor.md`, ledger `docs/plans/2026-10-26-label-floor-ledger.md`, HANDOFF section in `docs/HANDOFF.md`.
- The verifier's finding and probes: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/verifier/verifier.json`, `verifier/probes/v/meta-row.head.txt` and `meta-row.b49d6f7.txt`. Review 2's R2-F5 ruling: `~/.hermes/plans/figma-to-bricks/briefs/label-floor-fixer-2.md`. Your evidence: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/fix3/`.

## Skills (load first, one line each)
Project skill (Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, FINISHER role; `references/rules-summary.md`), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`.

## The finding
**V-F1 (low; caused by the R2-F5 fix, 34f0309):** a category pill beside two or more short plain words in its own font and size is read as a tab row's chosen option and stays at its drawn 11px. The common case is a blog card's meta row, `[Guides] 5 min read · Oct 12`, all 11px. At b49d6f7 the same pill grew to 13px, as AC1 asks. The structure is identical to the "Word tabs" fixture.

## Justin's ruling (2026-10-27)
Asked how to tell a card's pill from tabs, he chose **"Clickable = tabs"**: a row is a tab row (its chosen option keeps its drawn size) only when its other options are links or clickable in the Figma prototype. So:
- a card's category pill beside plain, non-clickable meta words grows to 13px again (as at b49d6f7);
- tabs whose other options the designer made clickable (a link, a Navigate, or an on-click reaction the snapshot records) keep their size;
- an un-prototyped tab row of bare words: its chosen tab grows (accepted by Justin).
- Unchanged: menus (review 1's F1 rule: linked items) and switches whose other option is drawn as the same box (R2-F5) keep their size, since those already need links or a matching box.

Find what the snapshot records about clickability (`SceneNode.link`, `linkFrame`, text `Run.link`/`linkFrame`, `pageLink`, any prototype reactions extract keeps) and use only what is really there; say in the ledger exactly what counts as clickable. Never key on names or words.

## Tests (test-first)
- RED: the verifier's meta-row probe as a fixture (`[Guides] 5 min read · Oct 12`, all one font and size, nothing clickable): the pill must be 13px (fails on a0c3b2b).
- Controls: tabs whose other options are links or clickable stay as drawn; the "Word tabs" fixture (bare, unclickable words) now grows its chosen pill (update that assertion, name it in the ledger); the two-box switch and menus unchanged; a pill beside one date of another size still grows.
- Mutation-test the new guard.

## Gates before you stop
`npm run check` green; browser suite with `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`, failures equal by name to main's (12 font-environment failures, `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/baseline-failures-names.txt`); unit suite with the corpus re-pointed in a scratch `git archive` copy (corpus.json's hydraulics/gro → `corpus/files/`); the five files (hydraulics-home, gro-home, Repairs = repo-root debug-page-1, inspo, Services = `git show 2199895:figma-to-bricks-debug-page-1.json`) replayed: byte-identical to a0c3b2b unless a change is proven necessary (name each); lint no worse; AC1–AC15's named tests green; worktree clean.

## Records
Update the ledger, the HANDOFF section (replace the R2-F5 "known limit" about card meta rows with Justin's ruling) and the plan copy's "After approval" section. Never edit `plan-approved.md`.

## Rules
- Commit each change separately (`git commit -m "Verifier V-F1: …"`, no author override, no `Co-Authored-By` or AI lines; `git diff --cached --name-only` first: CLAUDE.md never staged). Don't push, merge, rebase or bump BUILD. Don't edit the worktree's CLAUDE.md. Never bare `git stash`.
- You can't ask Justin anything; a new product decision: stop with the options.
- Other bugs: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence}]` (never edit skills or memory; empty is normal).

## Return
`{name, status: ready-for-verify|stopped, summary, finding{id, verdict, commit, test, evidence}, clickable_means, rulings[], last_commit, found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
