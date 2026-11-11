# Finisher brief: after-merge steps for media-clickable (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder**
`/home/justin/Documents/FigmaToBricksV2` (not a worktree). The session just fast-forwarded local `main` from `02481763`
(Build 2026-11-11.3) to `d9a0abae1c207306915615db19a950fa9e07251a` (`media-clickable-build`), accepted by `ac-check.sh
--reviews` (READY FOR THE USER 6/7; AC7 live, Justin's). The main session holds the merge lock (`website-importer-d1`); don't
touch the lock. Never stop to ask. Never load bdryswi.com, B-Dry staging or any live site; no logins; never write to any
WordPress site; never run `site:upload`/`site:import`. Start no agents. Other agents and Justin run tests and Chrome on this
machine: touch none of their processes, worktrees or branches. Work quickly (about 10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `d9a0abae1c207306915615db19a950fa9e07251a`, branch `main`, clean tree apart from the
   untracked `site-check-out/` (leave it, never commit it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-11.3`); bump `BUILD` to `2026-11-11.4` (or the next free `.N` for `date +%F`).
   Run `npm run build` and `npm run check`; both must exit 0. Node `/home/justin/.local/node-v22.23.3/bin` first on PATH;
   run check under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0` (if killed, check earlyoom; a
   `site-upload-stop` or socket-gate timing test that fails under load reruns alone).
3. Records in the same commit (docs and `build.ts` only):
   - **The ledger:** the branch kept it at `.superpowers/sdd/2026-11-11-media-clickable/progress.md` (if tracked) — move it
     to `docs/plans/2026-11-11-media-clickable-ledger.md` (`git mv`); `git ls-files .superpowers/` must then be empty. If
     it was never tracked, copy it from the builder's worktree
     `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a49ccc1aae3713018/.superpowers/sdd/2026-11-11-media-clickable/progress.md`
     (read only) to that `docs/plans/` path.
   - **Paste check id: 3ea** (agreed with the other session: it takes 3dz for footer-icon-list; this session takes 3ea
     onward). Check 3ea isn't used on main's HANDOFF (`command grep -rhoE --exclude-dir=evidence '\b3e[a-z]\b' docs/`).
     Replace every `3ec`, `<id at merge>`, "build set at the merge" / `<at merge>` placeholder of **this job** in
     `docs/HANDOFF.md` and the ledger with **3ea** and the new BUILD.
   - HANDOFF's media-clickable paste-check steps (review 1, R1-4): on the Elementor route Bricks asks nothing on a re-paste —
     the 25 classes arrive as new classes and the 25 old ones stay on the site unused; say that instead of "answer
     replace". Add: "Bricks may load a class's background photo only as it nears the screen (lazy), like its own
     backgrounds."
   - HANDOFF media-clickable "Deferred"/"Known limits", add if missing: the four P3s of review 1 (from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/follow-ups.md`) in one line each, and the builder's
     find: a background with no file in the capture (`Untitled-1600-x-300-px-1.png`) stays on its old address and the
     whole-page paste doesn't name it.
   - `cmp` `docs/plans/2026-11-11-media-clickable.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-clickable/plan-approved.md`; copy it over if they differ.
4. Commit `Build <BUILD>: a scanned page's background photos are Bricks' Background image setting with their media-library
   id, so each is clickable and swappable in Bricks; the page looks the same (media-clickable)` (plain `git commit -m` or
   `-F <file>`; no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or
   site-check-out), then `git push` (`main` only, through the repo's own credential helper as Just-In-N-Out; never switch
   gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git) **Status:** the build line ("**Current build `<BUILD>`**") and one line at the top
   of the feature list in the house style, checked against HANDOFF's section and `src/core/site/background.ts`:
   "**<BUILD> media-clickable (website importer):** with a media map (`site:upload`/`site:import`/`site … --media`), a box's
   own media-library background photo is its class's Bricks Background → Image setting (id, size; a photo per Bricks
   breakpoint in that tier's setting), so it is clickable and swappable in Bricks; `background-image`/`-size` leave the
   class's custom CSS; what a setting can't hold (a gradient, layers, a photo changing between Bricks' tiers, a hover's
   photo, `::before`) stays CSS, named in the notes; the test renderer prints `_background` as Bricks does (an unset
   position is no longer printed); pastes without a media map and Figma designs are byte for byte as before; on the
   Elementor route the 25 changed classes of B-Dry's home arrive as new classes on a re-paste. Paste check **3ea** (AC7,
   live: re-paste on B-Dry staging, click a box's class, Style → Background shows the photo and opens Media)."
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/media-clickable-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `d9a0abae`, `git status` clean but for
   `site-check-out/`, `git log -1 --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
The build commit SHA and BUILD; push result; the files changed; the paste check id; CLAUDE.md written or pending;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN
SESSION: check and save these skill_lessons now.`
