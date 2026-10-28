# FINISHER — slider-autoplay, main-folder release only

The orchestrator dispatches this role only after independent verification, blind audit, a passing ac-check verdict,
and the fast-forward merge. It records the accepted feature HEAD and merge-lock ownership below. Do only the
after-merge release steps. Do not merge/rebase or start agents.

## Skills and ownership
Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules summary,
`engineering-best-practices`, and `git-commit-rules`. Read the main project's current CLAUDE.md sections needed for
the finish; it is never committed. Main folder: `/home/justin/Documents/FigmaToBricksV2`, branch main.
You are not alone in the repository. Other chats own headline-marker/photo-hotspots. Never touch their worktrees
or evidence, never revert their edits, and preserve their complete notes. The orchestrator owns the shared merge
lock across this release. Do not acquire/release/delete a lock yourself unless asked in the dispatch addendum.

Feature plan: `docs/plans/2026-10-26-slider-autoplay.md`. Approved criteria AC1–AC14 are in
`/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`, with later answers/rulings in
the committed plan copy. AC13 and AC14 are live paste check 3bm, still owed to Justin; AC14 expects interval 5800
and speed 800. Your own evidence folder is
`/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/finisher-release/`.

## Do exactly
1. Confirm main is at the recorded accepted feature HEAD, no merge/rebase is in flight, and ownership of current
   working changes. Leave unrelated changes alone; never stage the user's debug files. Read current BUILD in
   `src/shared/build.ts` immediately before changing it. Set the next `YYYY-MM-DD.N` for today, accounting for any
   sibling releases. A changed main HEAD requires returning to the orchestrator, not silently releasing another tip.
2. Move this feature's ledger `.superpowers/sdd/2026-10-26-slider-autoplay/progress.md` to
   `docs/plans/2026-10-26-slider-autoplay-ledger.md`. Update only slider-autoplay's HANDOFF entries with actual
   build, independent acceptance result, preserved rulings/limits, and paste check 3bm. Keep all other features'
   entries. Ensure the source facts and live obligations are accurate and in plain words.
3. Run `npm run build` so the manifest's main-folder dist/code.js and dist/ui.html contain the new build. Preserve
   actual runtime, complete output and exit marker. Do not repeat all tests without a new failure/change reason;
   substantive implementation changes require returning to the orchestrator for the verification loop.
4. Before commit, confirm HEAD is still the accepted feature tip, personal identity is
   `Justin <issajustin04@gmail.com>`, and staged paths include only this release's BUILD/ledger/HANDOFF records.
   Never stage any CLAUDE.md, AGENTS.md, unrelated debug file, or sibling changes. Plain
   `git commit -m "Build <BUILD>: slider-autoplay"`, with no AI trailers or author override.
5. Push main only through the existing repo remote and identity configuration. Check the configured transport:
   for SSH confirm `ssh -T git@github.com` identifies Just-In-N-Out before pushing (its success greeting may exit
   1); for HTTPS retain the repo-local helper. Never switch gh accounts, rewrite a remote/helper, use another
   account/token, force-push, or push worktree-slider-autoplay. Preserve push output. Network sandbox failures use
   the normal escalated retry, not another transport bypass. Auth failures must be reported.
6. Update the main-folder CLAUDE.md `Start here` and `Where things stand`, and the Interactions user-decision
   section as the committed plan requests, rereading each section immediately before editing to retain concurrent
   changes. Keep rules/rulings separate: user's timing/phone-arrow/corner-arrow answers are confirmed; remaining
   defaults are rulings. Keep outstanding AC13/AC14 and machine limits visible. If a protected write is denied,
   preserve exact pending edits in a task-owned pending file and report it; never bypass the denial. If older pending
   edits have not landed, follow the skill's pending-edit ordering rule. Do not edit skills or memory: propose any
   new rules-summary amendment as skill_lessons with evidence for the main session to assess/save.
7. Verify the exact release commit, recorded BUILD, rebuilt dist artifacts, main/origin agreement after push and
   final status. Preserve the feature worktree and branch; Justin's explicit instructions say leave them in place.

Make a fresh `/tmp/slider-autoplay-finisher-release-XXXXXX` scratch area. Do not extract into an existing one.
No unrequested live website edits, clipboard replacements or message posting. If the plan's B-Dry paste artifact
is still pending, report its concrete state separately; do not conflate it with live site publication.

## Report
Return `{status: released|stopped, build, feature_head, release_head, push, dist, docs, ledger, summary,
rulings[], deferred[], steps_for_justin[], gates, skill_lessons[{skill,lesson,evidence}]}`. Name every unresolved
live AC and machine-only gate. Empty skill_lessons is normal. Never edit skills/memory yourself.
End with `MAIN SESSION: check and save these skill_lessons now.`
