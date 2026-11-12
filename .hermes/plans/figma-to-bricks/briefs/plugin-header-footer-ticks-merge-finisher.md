# Finisher brief: after-merge steps for plugin-header-footer-ticks (Figma plugin panel)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a
worktree). The session just fast-forwarded local `main` from `9f75e8ac` (Build 2026-11-11.7) to
`b61f0d57d8bcbf87c059ea99a8c8367765409ee9` (`plugin-header-footer-ticks-final`), accepted (READY FOR THE USER 5/6; HANDOFF-only rebase,
review 2 clean, receipt EXIT=0 — Justin's notes-only rule). The session holds the merge lock (`website-importer-d1`); don't touch
it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site. Start no agents. Touch no other
agent's processes, worktrees or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step
4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `b61f0d57d8bcbf87c059ea99a8c8367765409ee9`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-11.7`); bump to `2026-11-11.8` (or the next free `.N` for `date +%F`). `npm run build` and
   `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) exit 0; Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git add` every edited file, the moved ledger included after editing it;
   `git show --stat HEAD` must list each with its lines):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-plugin-header-footer-ticks/progress.md docs/plans/2026-11-11-plugin-header-footer-ticks-ledger.md`
     (if tracked; else copy read-only from `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-afdd9df4ff0e4f5c8/.superpowers/sdd/2026-11-11-plugin-header-footer-ticks/progress.md`);
     `git ls-files .superpowers/` empty.
   - **Paste check id: 3ee** (next free: 3ea–3ed and 3em are used; confirm 3ee is unused on main's HANDOFF). Replace this job's `<id at merge>` /
     "build set at the merge" / `<at merge>` placeholders in HANDOFF and the ledger with **3ee** and the new BUILD.
   - HANDOFF plugin-header-footer-ticks "Deferred / known limits", add if missing, one line each from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/follow-ups.md`: R1-1 (capture open: the line speaks of
     Figma pages), R1-2 (a site's remembered ticks: the line shows the note), the auditor's two pre-existing lines, Q2 still open (if
     Justin's boxes were TICKED: a recognition bug needing his debug file).
   - `cmp` `docs/plans/2026-11-11-plugin-header-footer-ticks.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: the Figma panel's header and footer boxes say what they do ("Leave the header/footer out of the paste") and the line under them says what the next paste does; no paste changes (plugin-header-footer-ticks)` (plain `git commit`;
   no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git
   push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status:** the build line and one line at the top of the feature list: "**<BUILD>
   plugin-header-footer-ticks (Figma plugin panel):** the two boxes read \"Leave the header out of the paste (my site already has its own;
   the page starts below it)\" and \"Leave the footer out of the paste (my site already has its own)\" (a tick still leaves the part out,
   an empty box keeps it), the line under them says what the next paste does in all four states, and every note names a box by those
   words (`tickName()` in `src/core/normalise/site.ts`); no paste changes by a byte. Q1–Q3 A; Q2 open (if Justin's boxes were ticked when
   both parts stayed, a recognition bug: needs his debug file). Paste check **3ee** (AC6, live: in Figma tick both boxes, convert, paste
   on darksalmon, neither part is in it; with both empty the line says the paste keeps both)."
   Also in "Decisions the user made" → "The site's own header and footer": add one sub-line naming the two boxes' words.
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/plugin-header-footer-ticks-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `b61f0d57`, `git status` clean but for `site-check-out/`, `git
   log -1 --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[]` (empty is
normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
