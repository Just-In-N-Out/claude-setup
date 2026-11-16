# Finisher brief: after-merge steps for native-widgets and page-faq-slide (one build for both: a menu's sliding list and a page's FAQ are Bricks' Accordion; what stays Code is labelled)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `d08c6a62` to `1ed7092dae235ca4ebe47218b0d6c899b3064ae2` (`page-faq-slide-on-main6`, holding native-widgets bde709b9 then page-faq-slide), both accepted:
verifiers and auditors READY (nw 9/10, AC10 live; pfs 8/9, AC9 live), restack reviews nw-5 and pfs-7 clean, rebase receipts EXIT=0 (notes-only rule). The session holds the merge lock
(owner `website-importer`); don't touch it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site; touch
nothing under `~/Downloads`. Start no agents. Touch no other agent's processes, worktrees or branches. Files only with Write/Edit (no heredocs,
no `sed -i`); plain `git`, each command alone. Work quickly (20–25 minutes). TMPDIR ~/.cache/nwpfmf/t1.

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `1ed7092dae235ca4ebe47218b0d6c899b3064ae2`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-15.6`); bump to the next free `2026-11-15.N` (expect `.7`; one build for both jobs). `npm run build`. Commit first, then run
   `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`), so `offline-tally-compare` doesn't refuse the uncommitted bump; a
   timing or drawing test failing under load reruns alone. If check fails for real, stop before pushing and report.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Move both ledgers with `git mv`: `.superpowers/sdd/2026-11-13-native-widgets/progress.md` → `docs/plans/2026-11-13-native-widgets-ledger.md`
     and `.superpowers/sdd/2026-11-13-page-faq-slide/progress.md` → `docs/plans/2026-11-13-page-faq-slide-ledger.md`; add a closing "Merged"
     line to each (build, paste check). `git ls-files .superpowers/` must end empty.
   - **Paste check ids:** native-widgets **3ev**, page-faq-slide **3ew**. Replace every `<native-widgets id at merge>` and `<page-faq-slide id at merge>`
     in HANDOFF (lines ~105, ~183, ~15320, ~15334 and any other) and the ledgers, and each heading's `<set at merge>` with the new BUILD.
     Confirm no other entry uses 3ev/3ew; check-list order 3ek, 3el, 3et, 3es, 3eu, 3ev, 3ew, 3eq.
   - HANDOFF "Deferred / known limits" of each job, one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/{native-widgets,page-faq-slide}/follow-ups.md` (skip merge lines). page-faq-slide's
     "gap rule" (a details list with a gap between title and answer stays as it is) goes under its rulings as a question for Justin.
   - `cmp` each `docs/plans/2026-11-13-<job>.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/<job>/plan-approved.md`; copy over
     if they differ.
4. Commit `Build <BUILD>: a menu's sliding list and a page's FAQ paste as Bricks' Accordion with the site's slide; what stays Code is labelled and named (native-widgets, page-faq-slide)`
   (plain `git commit`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out);
   run the check (step 2); then `git push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line, and two lines at the top of the feature list (one per job, both naming the build), compact like their
     neighbours, from each job's HANDOFF section (rulings not yet confirmed as HANDOFF names them); paste checks **3ev** (native-widgets AC10,
     live) and **3ew** (page-faq-slide AC9, live).
   - Any standing rule or decision each plan names for CLAUDE.md (its "For the finisher" lines), word for word.
   If writing CLAUDE.md is refused, leave exactly those lines in `~/.hermes/plans/figma-to-bricks/nw-pfs-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `1ed7092d`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
