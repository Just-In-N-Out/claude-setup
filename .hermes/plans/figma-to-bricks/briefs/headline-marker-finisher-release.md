# FINISHER — headline-marker, after-merge release only

Run only after the orchestrator supplies the accepted and merged commit below. Do not spawn agents.

Expected merged HEAD: TO_BE_PINNED_BEFORE_DISPATCH.

## Ownership and acceptance

- Own after-merge release work in `/home/justin/Documents/FigmaToBricksV2` on `main` only.
- Feature branch `worktree-headline-marker`; keep its worktree and branch on disk. No branch push, fetch, pull, force push, cleanup, stash or author override.
- The orchestrator owns the merge lock as `headline-marker` and will release it after checking your result. Confirm actual owner and the expected clean merged HEAD at entry; do not acquire or release the lock yourself.
- AC1–AC13: `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/plan-approved.md`, with the committed plan's `Changed by review fix pass 1` and `Changed by review fix pass 2` amendments. AC13 is the live paste check, originally 3bo; use any consistent renumbering required during integration. The final accepted head must be supplied by the orchestrator. Do not run application verification again solely for records/BUILD edits.
- You are not alone in the codebase. Other chats own slider-autoplay and photo-hotspots. Do not touch their worktrees, evidence, processes or edits. Re-read shared records just before updating them and preserve every other feature's sections. Stop if main advances unexpectedly or another owner's edits would be included.
- Your evidence folder: `/home/justin/.hermes/plans/figma-to-bricks/evidence/headline-marker/finisher-release/`; fresh task-owned scratch only, created with `mktemp -d` and `mkdir` without `-p`.

## Skills

Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` plus `references/rules-summary.md`, then `engineering-best-practices`, `receiving-code-review`, `git-commit-rules`, and `github`. Follow current global and project privacy/authorship instructions. The main session owns all reviews and skill/memory edits. If the project summary needs a rule update, return the exact proposed edit rather than editing skills yourself.

## Release steps

1. Verify the supplied accepted/merged SHA, main branch, clean status and merge lock. Do not proceed from a different or dirty head. Confirm git identity is Justin <issajustin04@gmail.com>. Confirm the configured push route is Just-In-N-Out without switching accounts, remotes or credential helpers. For an SSH remote, use the documented SSH identity check; never print tokens or keys.
2. Read `src/shared/build.ts` immediately before editing and bump BUILD to the next `YYYY-MM-DD.N`, using the current local date and the repository's build convention. Do not overwrite a sibling's build.
3. Move this feature's ledger from `.superpowers/sdd/2026-10-26-headline-marker/progress.md` to `docs/plans/2026-10-26-headline-marker-ledger.md`. Update the feature's own plan/ledger/HANDOFF release records with the actual BUILD, final acceptance, gates, rulings and owed live paste check. Preserve the audit's exact local-vs-live distinction and the known environment limits: same 12 existing font-related browser failures and one Mac-only skip; three legacy Mac corpus inputs unavailable on WSL. Do not describe those as repaired or passed.
4. `npm run build` in main, with an explicit exit receipt, so Figma's `dist/` is current.
5. Recheck HEAD is still the supplied merge tip. Stage only the owned build/record files, inspect `git diff --cached --name-only` and verify no CLAUDE.md, AGENTS.md, debug JSON, unrelated edit or AI trailer. Plain `git commit -m "Build <BUILD>: headline-marker"`, with no metadata override. Verify actual authorship afterward.
6. `git push` main through the configured Just-In-N-Out route. Do not change auth or retry through another account on failure. If network/sandbox access fails, use the normal escalation path. Record the push result and verify main/origin agreement.
7. Re-read main `CLAUDE.md` directly before editing. Update `Start here`, `Where things stand` and the applicable general rules/user decisions for headline-marker, with the actual build, unconfirmed rulings and live paste check. Never stage or commit CLAUDE.md. If an explicit protected-file denial occurs, preserve the exact remaining edits in a feature-owned pending file under `~/.hermes/plans/figma-to-bricks/`, including sections already applied; do not retry through another tool or agent. Preserve older pending edits and their build order.
8. Verify the release commit, authored identity, rebuilt dist, clean main and main/origin agreement. Do not remove the feature worktree or branch. Do not run setup-sync through a workaround: this session's prior plain escalated calls found the setup repository read-only. Report any unsynced notes accurately; the orchestrator will handle the authorized sync command.

## Report

Return `{status: released|stopped, build, release_commit, accepted_head, summary, gates, push, main_origin, ledger, docs, pending_docs, rulings_unconfirmed, deferred, first_step_for_justin, proposed_summary_edit, skill_lessons: [{skill, lesson, evidence}]}`. Spell out all remaining unconfirmed choices in plain words. Say whether shared classes require accepting replacements on paste, whether code signatures are needed, and whether LiteSpeed Purge All is needed. Keep the first user action singular and name exactly what is on screen. List only new reusable proven skill lessons, normally an empty list; never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
