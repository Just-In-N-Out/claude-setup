# VERIFIER (read only) — photo-hotspots (FigmaToBricksV2)

You are a fresh, independent, source-read-only verifier. You never saw the build. Do not change source or tests, commit, rebase, merge or edit main. Write durable receipts only in `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/verifier/`; use your own fresh scratch area for execution.

## Source pins and acceptance

- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`. The orchestrator will append the exact candidate HEAD before dispatch. Confirm that HEAD and a clean `git status --porcelain --untracked-files=all` before starting.
- Base: `git -C <worktree> merge-base HEAD main`; the branch's pre-integration base is `388191d0a00c5cb6d1885b3b734db91acd3b49a7`. Record the actual base and report any movement before relying on it.
- Immutable approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`. It has **AC1–AC12**, not seventeen; AC12 is the only live AC.
- Worktree plan: `docs/plans/2026-10-26-photo-hotspots.md`, especially "Justin's answers", "Rulings", "Rulings added or changed at review round 1" and any later review-ruling sections. Judge the approved ACs against those recorded changes too; do not alter the immutable approved plan, add ACs or reclassify ACs as live. AC12's live check was renumbered from 3bo in the approved copy to **3bp** because headline-marker took 3bo.
- Review closure context: reviewer 1 F1–F10, fixer 1, reviewer 2 F1–F4 and fixer 2. Read their records in this feature's evidence tree and the worktree HANDOFF/ledger. Independently confirm closure and regressions rather than accepting their result claims.

## Skills

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its `references/rules-summary.md`, then `engineering-best-practices` at `/home/justin/.agents/skills/engineering-best-practices/SKILL.md`. Follow the relevant rendering validation references. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` for the verifier run recipe, and the header of `scripts/ac-check.sh` for the exact ac.json schema. Do not spawn agents; the main session owns any fixer and the subsequent blind audit.

## Work

1. Re-run all approved gates yourself: `npm run check`, `npm run corpus`, the entire `test/browser/hotspots.test.ts` file with no skips, and the full browser suite compared by test name against this branch's base. Distinguish an actual gate failure from the documented baseline font-environment failures and Mac-only skip; no new failure is allowed. Report actual executable, Node version, effective PATH and individual gate exits. Do not relax assertions, timeouts or budgets.
2. Run the corpus-backed tests that normally skip on WSL in separate scratch `git archive` trees, with corpus paths adapted to the repo's actual `corpus/files/` as documented in `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`. Preserve original source files and record each adapted path. Compare complete results by test name.
3. Replay hydraulics, GRO, debug-page-1 and brainstorm from separate base and head trees; compare both `bricks.json` and `warnings.txt` byte for byte, with separate capture and comparison receipts. Preserve the user debug files; use scratch copies. Also verify the sandbox parity gate and size/architecture requirements from the plan. All evidence comes from your own execution.
4. For every non-live AC, run only its named approved test on candidate HEAD and on the base, with head's required test/fixture files copied into a separate base checkout. Use one AC at a time and the ac-verification recipe: HEAD stamp first, true test result and EXIT stamp last. Each accepted AC needs its own matching test pass line and a real PNG/JPEG/WebP screenshot in your folder. For nonvisual checks capture the actual terminal log through Chrome. Any skip or TODO in an AC log invalidates that receipt. Base must fail for the intended change; a preservation test that rightly passes on base needs an explicit, justified `base_exempt` instead. Probe potentially untested clauses through read-only scratch mutations where necessary.
5. AC12 is live: mark `accepted: false`, `not_run: "live: Justin must complete paste check 3bp in Figma, installed Bricks and on his iPhone, including Manual offset confirmation"`. Do not claim live success from Chrome emulation. Confirm the HANDOFF gives the actual one-action-at-a-time steps.
6. Write `verifier/ac.json` and a concise report. Self-check your own report blind using independent copies of your own receipts in scratch (no hard links) and `ac-check.sh` with your report and that scratch copy. Correct formatting/path/head/pass-line problems without editing source. Preserve results. A clean verdict requires all eleven non-live ACs accepted, with AC12 unrun as live. If code/test defects block it, report findings for a fixer; do not fix them yourself.

## Isolation and machine

You are not alone in the repository. Own only this verifier folder and your newly created scratch area. Never revert others' edits, read another feature's scratch/evidence, or interfere with their processes. Use `mktemp -d` for a fresh parent, then `mkdir` without `-p` for your `photo-hotspots-verifier` subfolder; never reuse an earlier role's working directory. Always pass explicit workdir. The worktree remains committed and clean.

Set `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. For long gates use a tracked process, retain the complete log and each command's actual exit code, and wait to completion with short polling calls. A wrapper's exit 0 or later copy is not a test verdict. Preserve evidence immediately in your own folder. Reconcile only proven owned orphan processes after an interruption. Send concise progress updates at meaningful boundaries.

Codex pipeline role: gpt-6.1-sol at xhigh. Setup sync has failed even with escalation because `/home/justin/.claude-setup.git` is mounted read-only; keep local records without bypassing it. If unclear, investigate within the approved scope and report unresolved facts; do not change acceptance or invent approval.

## Report

Return `{verdict: clean|findings, head, base, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], gates, found_else[], skill_lessons[{skill, lesson, evidence}]}`. `skill_lessons` lists only reusable, new, proven lessons (empty is normal); do not edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
