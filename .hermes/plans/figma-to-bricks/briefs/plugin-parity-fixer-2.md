# Role: fixer (fix round 2, after verifier 2; test-only): plugin-parity — AC9 and AC10's cited tests must catch the regression

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify the finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`; the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
(directly; not linked) with `references/testing-pitfalls.md`. Read both `repeat-mistakes.md` files first (`figma-to-bricks/references/`,
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/`). Never load any live site; never write to any WordPress site; touch
nothing under `~/Downloads`. Commit to your branch only (plain `git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push;
don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare `git stash`. Plain `git` in your own worktree, each command alone (never
`git -C` the main folder; no git piped into another command; scripts with the Write tool, run as `bash <file>`, no heredocs).

## What failed
`ac-check.sh` on head `beeacc8f72b1fa4c21d52f9e4ca690bf75a4c9c7` (branch `plugin-parity-fix1`, base `7b7501bd`): AC9 and AC10 NOT
ACCEPTED. Read `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/verifier-2/ac.json` and its logs
`prefix-89e41a0-ac9*.log`, `prefix-89e41a0-ac10*.log`, `mutant-typed-names-ac9*.log`, `mutant-typed-names-ac10*.log`, `own-pairs*.log`.
The behaviour holds on head, but the plan's **cited** tests pass on the head the first auditor proved false (89e41a0d) and on a mutant that
undoes fix 1's naming; only the supporting tests fix 1 added beside them fail there:
- AC9 cites `test/unit/plugin-looks-names.test.ts` "a look has one name, id and settings on every page, and a new look renames nothing";
  the supporting "looks whose settings write alike are one look…" catches it.
- AC10 cites `test/unit/emit-class-paste.test.ts` "shared looks add no class conflict on a re-paste, between two pages, or after a label's
  minimum size"; the supporting "a look's name and id follow its settings as written…" catches it.

## Fix (test-only; no source change)
Fold the supporting cases into the cited tests under their **unchanged** plan names (keep the supporting tests or merge them, your call), so
each cited test, run by name: passes on head beeacc8f; fails on 89e41a0d (a `git archive` of it with your test files copied in); fails on the
typed-names mutant (fix 1's naming undone). Record the three runs per AC as logs in
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/fixer-2/` (create it), each starting `HEAD=<sha>` and ending `EXIT=`.

## Gates
`npm run check` (8G); AC6–AC10 tests by name on your head. Ledger: a "Fixer 2" section. Stop at `ready-for-next-review`.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ppf2/t1`); scripts under `~/.cache/ppf2/s/`;
memory scopes `systemd-run --user --scope -p MemoryMax=<n>G -p MemorySwapMax=0 /bin/bash -c 'export PATH="/home/justin/.local/node-v22.23.3/bin:$PATH";
…'`. A git-archive tree has no `node_modules/.bin`: call `node node_modules/typescript/bin/tsc` directly. Use `tail -n 3`. Waits under 115 s.
SIGTERM/143/137/"Killed": check earlyoom's log first. Write summaries as .txt/.json.

## Report (as text)
Branch, head (full SHA); per AC the three runs; gates by name; `ac_status`; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit
skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
