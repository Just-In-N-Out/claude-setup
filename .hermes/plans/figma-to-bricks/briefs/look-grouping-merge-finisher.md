# Finisher brief: after-merge steps for look-grouping (copies of the same thing share one class, both tools)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `cc3fa0af` to `3e357cde60f6f985dcaeacff97d31924eacc135d` (`look-grouping-g3`), accepted on
that head: `ac-check.sh` READY FOR THE USER 22/23 (AC23 live), review 6 clean, verifier 3 and auditor 3 clean. The session holds the merge lock
(owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site; touch
nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or branches. Files only with Write/Edit (no heredocs,
no `sed -i`); plain `git`, each command alone. Work quickly (20–25 minutes). TMPDIR ~/.cache/lgmf/t1.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `3e357cde60f6f985dcaeacff97d31924eacc135d`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-15.5`); bump to the next free `2026-11-15.N` (expect `.6`). `npm run build`. Commit first, then run
   `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`), so `offline-tally-compare` doesn't refuse the uncommitted bump; a
   timing or drawing test failing under load reruns alone. If check fails for real, stop before pushing and report.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Move the ledger `.superpowers/sdd/2026-11-13-look-grouping/progress.md` to `docs/plans/2026-11-13-look-grouping-ledger.md`
     (`git mv`, it is tracked) and add a closing "Merged" line (build, paste check).
   - **Paste check id 3eu** is this job's: replace every `<look-grouping id at merge>` in HANDOFF (lines 7, 76, ~15086 and any other)
     and the ledger with `3eu`, and `<set at merge>` in its heading with the new BUILD. Confirm no other entry uses 3eu, and that its entry
     sits in HANDOFF's "End-of-run check list" after 3es (order 3ek, 3el, 3et, 3es, 3eu, 3eq).
   - HANDOFF look-grouping "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/follow-ups.md` (skip merge lines), and its rulings section: the
     fixer-g3 ruling (a copy's own media-library photo is its element's Background setting from the first Bricks tier where it differs,
     replacing the plan's Task line "a kept picture stays CSS"), not yet confirmed.
   - `cmp` `docs/plans/2026-11-13-look-grouping.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/look-grouping/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: copies of the same button, heading or card share one class, their own differences kept on themselves (look-grouping)`
   (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out);
   run the check (step 2); then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line, and one line at the top of the feature list, compact like its neighbours, from HANDOFF's look-grouping
     section (both tools: copies of one button, heading or card share one class by component, the site's class names, or words and link;
     a copy's real difference stays on itself; a copy's own background photo its element's Background setting; copies off byte for byte as
     before; rulings not yet confirmed as HANDOFF names them); its paste check **3eu** (AC23, live).
   - Any standing rule the plan or ledger names for CLAUDE.md, word for word (the plan's "For the finisher" lines if present). Replace the
     Decisions line "**The same button shares one class**" only if the plan says so; otherwise leave it.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/look-grouping-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `3e357cde`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
