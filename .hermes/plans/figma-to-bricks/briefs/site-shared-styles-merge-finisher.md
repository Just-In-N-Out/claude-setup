# Finisher brief: after-merge steps for site-shared-styles (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `6bca1176` (Build 2026-11-14.3) to `1eec2afaf52340c162d259fa951de7c44d70a67a`
(`site-shared-styles-final2`), accepted: verifier 2 and blind auditor 2 proved AC1–AC14 on f971b306 (AC15 live), review 4 clean there; then
rebased onto 6bca1176 under the notes-only rule (HANDOFF-only conflict; delta review 5 MOVE ON; receipt-1eec2af.log EXIT=0). The session holds the merge lock (owner `website-importer`); don't touch it. Never stop to
ask. Never load any live site; no logins; never write to any WordPress site; touch nothing under `~/Downloads`. Start no agents. Touch no
other agent's processes, worktrees or branches. Work quickly (15–20 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `1eec2afaf52340c162d259fa951de7c44d70a67a`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-14.3`); bump to the next free `.N` for today (`2026-11-14.4` unless taken). `npm run build` and
   `npm run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-site-shared-styles/progress.md docs/plans/2026-11-11-site-shared-styles-ledger.md` (move any other file
     in that folder beside it the same way), add a closing "Merged" line (build, paste check); leave the other `.superpowers/sdd/` folders.
   - **Paste check id: the next free one.** Grep main's HANDOFF and every plan under `docs/plans/` and `~/.hermes/plans/figma-to-bricks/*.md`
     for exact ids: 3eo is the last used, **3ek and 3el are reserved by forms-wpforms**, so expect **3ep**; confirm it is unused. Replace this
     job's `<… at merge>` placeholders in HANDOFF and the ledger with that id and the new BUILD; the entry sits at the top of HANDOFF's
     "End-of-run check list" (AC15, live: his own scan of bdryswi.com, import the page's `palette.json` on B-Dry staging first, paste, then
     change one text class and one palette colour in Bricks and see every carrier change).
   - HANDOFF site-shared-styles "Deferred / known limits", one line each if missing, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/follow-ups.md` (above all: a section paste's `palette.json` lacks the opened
     boxes' colours on a scan with a menu or pop-up — import the page's first; ruling 5's duplicate classes on self-hosted-font sites).
   - `cmp` the plan copy in `docs/plans/2026-11-11-site-shared-styles.md` with
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-shared-styles/plan-approved.md`; if they differ only by a reviewed fix or
     amendment, keep the docs copy and say so; else copy over.
4. Commit `Build <BUILD>: a scanned page's repeated looks paste as shared classes (text, buttons, cards and boxes, rows) and its colours as
   one palette, palette.json and styles.txt beside the pastes (site-shared-styles)` (plain `git commit`; no author override, no AI or
   Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as
   Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the date and build line, and one line at the top of the feature list, compact like
   its neighbours, from HANDOFF's site-shared-styles section (website importer; same-looking words, buttons, cards and rows share one
   purpose-named class, a one-off tweak on the element, never two classes writing one property; colours to one palette `palette.json`
   (Style Manager → Colors, import it first) linked as `var(--color-<hex>, <as written>)`; every text Rich Text; `styles.txt`; looks stay
   true; the switch off and Figma designs byte for byte as before; rulings not yet confirmed as HANDOFF names them, ruling 5 open for
   Justin); its paste check (AC15, live). Add any new standing rule HANDOFF names for every agent. If writing CLAUDE.md is refused, leave
   exactly those lines in `~/.hermes/plans/figma-to-bricks/site-shared-styles-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `1eec2afa`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending (which lines);
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save
these skill_lessons now.`
