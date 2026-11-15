# Finisher brief: after-merge steps for plugin-parity (a Figma paste built like a Bricks pro: no Div, labels, shared looks)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `9942df18` to `caf29a3fb67919797fcaf79b214987f0434ec663` (`plugin-parity-fix4`), accepted on
that head: `ac-check.sh` READY FOR THE USER 17/18 (AC18 live), review 7 clean, verifier 6 and auditor 5 clean. The session holds the merge lock
(owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site; touch
nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or branches. Files only with Write/Edit (no heredocs,
no `sed -i`); plain `git`, each command alone. Work quickly (20–25 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `caf29a3fb67919797fcaf79b214987f0434ec663`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-15.1`); bump to the next free `2026-11-15.N` (expect `.2`). `npm run build` and `npm run check`
   exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing or drawing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - The ledger is already at `docs/plans/2026-11-11-plugin-parity-ledger.md`: add a closing "Merged" line (build, paste check).
   - **Paste check id: 3eq** (reserved for this job; confirm it is unused by grepping main's HANDOFF, `docs/plans/` and
     `~/.hermes/plans/figma-to-bricks/*.md`). Replace this job's `<set at merge>` and `<plugin-parity id at merge>` placeholders in HANDOFF
     (lines 7, 105, 14471 and any other) and the ledger with `3eq` and the new BUILD; the check entry sits at the top of HANDOFF's
     "End-of-run check list" (AC18, live: in Figma convert a page, paste on darksalmon, answer Import classes, Structure shows Sections,
     Containers and labelled Blocks with no Div; change one shared text or Button class and see every element carrying it change).
   - HANDOFF plugin-parity "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/follow-ups.md` (review 6's and review 7's P3s, the auditor's and
     verifier's notes, M9). R7-1 is a question for Justin: should every element painting a colour the palette now holds link to it too?
   - `cmp` `docs/plans/2026-11-11-plugin-parity.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-parity/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a Figma paste is built like a Bricks pro's: no Div, every Section and Block labelled, repeated looks in shared
   classes, Button looks in their class with palette colours (plugin-parity)` (plain `git commit`; no author override, no AI or Co-Authored-By
   lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as Just-In-N-Out through the
   repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the date and build line, and one line at the top of the feature list, compact like its neighbours, from HANDOFF's
     plugin-parity section (no Div in a Figma paste, only an inlined picture; every Section and Block labelled by purpose or first words;
     repeated looks in shared purpose-named classes decided in emit after adapt; a Button look's font, colours, background, border, corners,
     shadow and padding in its class's Custom CSS at `html:root .<class>.brxe-button.bricks-button`, every opaque colour a palette link
     `var(--color-<hex>, …)`, a colour the palette lacks added to the palette file, the site's own colour where the export holds it; looks the
     same with and without a Theme Style; plugin = replay; rulings not yet confirmed as HANDOFF names them); its paste check **3eq** (AC18, live).
   - The standing rules the plan's task 13 lists, word for word (plan lines ~492–497: "Every frame and shape of a Figma paste is a Block…",
     "Shared looks are decided in emit after adapt…"), plus "A Button look class keeps its look in its own Custom CSS at `html:root
     .<class>.brxe-button.bricks-button` (0,4,1), above Bricks' Theme Style button rules; renaming that class in Bricks drops the look" in
     "Working in this repo", and the `~/.hermes/plans/figma-to-bricks/structure-parity-claude-md-pending.md` edit (Offcanvas no longer owed as a
     sample) if it is not already in CLAUDE.md.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/plugin-parity-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `caf29a3f`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
