# DJ Trees batch: POST-MERGE FINISHER — rules for every job

You are a fresh post-merge `pipeline_finisher` in the main folder `/home/justin/Documents/FigmaToBricksV2` (M), on
`main`. No child agents, no product fixes or tests, no re-planning. Other DJ Trees jobs merge after you, one at a time:
preserve everything else on main. Root holds the merge lock under the job's name; don't acquire or release it.

Load `engineering-best-practices`, `git-commit-rules` and the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (finish instructions). Read M's
`CLAUDE.md` ("Finish" step 3) and the job's HANDOFF section and ledger.

## Steps

1. Check M is on `main` at the expected merged head (your job brief) with a clean tracked status.
2. Read `src/shared/build.ts` and set `BUILD` to today's next free `YYYY-MM-DD.N` (today is 2026-11-02; read it,
   another session may have bumped it).
3. Move the ledger `.superpowers/sdd/<plan>/progress.md` to `docs/plans/<plan>-ledger.md` (`git mv`). Fill the job's
   HANDOFF heading placeholder (`build <BUILD>`) with the new build; keep its paste check id.
4. `npm run build` with Node `/home/justin/.local/node-v22.23.3/bin/node` first in PATH (use `env PATH=<literal> npm
   run build`). Check `manifest.json` points at `dist/code.js` and `dist/ui.html` and the built bundle carries the new
   BUILD (grep). `dist/` is not in git.
5. Commit on main: only `src/shared/build.ts`, `docs/HANDOFF.md`, the ledger move; message `Build <BUILD>: <feature>`;
   plain `git commit -m`, identity `Justin <issajustin04@gmail.com>`, no AI/Co-Authored-By lines, no author override,
   CLAUDE.md never staged (`git diff --cached --name-only`).
6. `git push` main (the repo's own credential helper pushes as Just-In-N-Out; never switch gh accounts or change the
   remote/helper). If the push fails, keep the exact error and report it; never force.
7. Re-read M's `CLAUDE.md` just before editing it (other jobs edit it too) and update its **Status**: the current
   build line (`Current build \`<BUILD>\``) and one short line for this feature with its paste check, placed at the top
   of the feature list; plus the standing-rule/decision lines your job brief gives. No build narrative. CLAUDE.md stays
   unstaged. If writing it is refused, save exactly those lines to
   `~/.hermes/plans/figma-to-bricks/<job>-claude-md-pending.md`.

## Return

The new BUILD, the commit SHA, `git log --oneline -3 main`, push result (`origin/main` equal to main), the CLAUDE.md
lines written (or the pending file), any failure, and `skill_lessons` (normally `[]`). End with
`MAIN SESSION: check and save these skill_lessons now.`
