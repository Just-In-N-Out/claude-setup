# Finisher brief: after-merge steps for site-scroll-lock (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), working in the **main folder** `/home/justin/Documents/FigmaToBricksV2`
(not a worktree). The session just fast-forwarded local `main` from `088ee066` (Build 2026-11-11.4) to
`c37528ced95f707ccade6627b6a59c0e05cedfa4` (`site-scroll-lock-final`), accepted (READY FOR THE USER 6/7 on `ad5bd862`; rebased with a
HANDOFF-only conflict, review 2 clean, receipt EXIT=0 — Justin's notes-only rule). The main session holds the merge lock
(`website-importer-d1`); don't touch it. Never stop to ask. Never load any live site; no logins; never write to any WordPress
site. Start no agents. Touch no other agent's processes, worktrees or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
("Step 4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `c37528ced95f707ccade6627b6a59c0e05cedfa4`, branch `main`, clean tree but for the untracked
   `site-check-out/` (leave it). If not, stop and report.
2. Read `src/shared/build.ts` (now `2026-11-11.4`); bump `BUILD` to `2026-11-11.5` (or the next free `.N` for `date +%F`). `npm run
   build` and `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) must exit 0; Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH; a `site-upload-stop`/socket-gate timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only):
   - **Ledger:** `git mv .superpowers/sdd/2026-11-11-site-scroll-lock/progress.md docs/plans/2026-11-11-site-scroll-lock-ledger.md`
     (if tracked; else copy it read-only from
     `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-af4a0e5b76e66668b/.superpowers/sdd/2026-11-11-site-scroll-lock/progress.md`);
     `git ls-files .superpowers/` must be empty.
   - **Paste check id: 3eb** (this session takes 3ea onward in merge order; the other session has 3dz). Check 3eb is unused on
     main's HANDOFF. Replace this job's `<id at merge>` / "build set at the merge" / `<at merge>` placeholders in `docs/HANDOFF.md`
     and the ledger with **3eb** and the new BUILD.
   - HANDOFF site-scroll-lock section, "Deferred / known limits", add if missing, one line each, from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/follow-ups.md`: R1-1 (`site:live` refuses a page pasted
     before this build until re-pasted), R1-2 (Additional CSS `hidden` still wins if left in: step 1 removes it), R1-3 (add to the
     paste check: "open the page in the builder: the canvas scrolls and elements select as before"), Safari < 16 fallback, the
     empty section paste note. Add the R1-3 step to the 3eb check-list entry.
   - `cmp` `docs/plans/2026-11-11-site-scroll-lock.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/plan-approved.md`;
     copy it over if they differ.
4. Commit `Build <BUILD>: every website-importer paste locks sideways scrolling (overflow-x: clip on html and body, Bricks'
   no-scroll kept working, sticky headers still stick); Figma designs as before (site-scroll-lock)` (plain `git commit`; no author
   override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out), then `git push`
   (`main` only, the repo's own credential helper as Just-In-N-Out; never switch gh accounts or change the remote).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line ("**Current build `<BUILD>`**") and one line at the top of the feature list: "**<BUILD>
     site-scroll-lock (website importer):** every paste `site`/`site:upload`/`site:import` writes carries one class
     `site-scroll-lock-<4>` (second after the reset, on each part root) with `html, body { max-width: 100%; overflow-x: clip }`,
     `html:has(> body.no-scroll) { overflow-y: hidden }`, `body.no-scroll { overflow-y: visible }` and a `hidden` fallback for
     browsers without `clip`: a page never moves sideways on phones, sticky headers still stick, Bricks' No-scroll pop-ups still
     hold the page; it hides what sticks out, it doesn't fix it (`site:check` still names it); Figma designs and the panel byte for
     byte as before. Q1–Q3 A not yet confirmed. Paste check **3eb** (AC7, live: take `html, body { overflow-x: hidden }` out of
     Additional CSS, re-paste on B-Dry staging, on a phone the page doesn't move sideways, the header sticks, with ☰ open the
     page behind stays still)."
   - In "Code-method class names start with the page's name", add `site-scroll-lock-<4>` to the names that keep theirs.
   - One standing rule under "Working in this repo": "**A website paste locks sideways scrolling with `clip`, never `hidden`, on
     html and body** (site-scroll-lock): `hidden` on both makes body a scroll container (sticky headers ride off), and any
     overflow on html stops Bricks' `body.no-scroll` reaching the window, so the lock also carries the two `no-scroll` lines."
   - The pending line from `~/.hermes/plans/figma-to-bricks/structure-parity-claude-md-pending.md` (Offcanvas sample no longer
     owed) — apply it and delete that pending file.
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/site-scroll-lock-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `c37528ce`, `git status` clean but for `site-check-out/`,
   `git log -1 --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
The build commit SHA and BUILD; push result; files changed; the paste check id; CLAUDE.md written or pending;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these
skill_lessons now.`
