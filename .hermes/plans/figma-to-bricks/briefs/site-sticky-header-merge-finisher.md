# Finisher brief: after-merge steps for site-sticky-header (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a
worktree). The session just fast-forwarded local `main` from `e61c0ca0` (Build 2026-11-11.6) to
`c58e97dad13d63da794677e9274d8e6a0db9f4be` (`site-sticky-header-final3`), accepted (READY FOR THE USER 8/9; HANDOFF-only rebase,
review 4 clean, receipt EXIT=0 — Justin's notes-only rule). The session holds the merge lock (`website-importer-d1`); don't touch
it. Never stop to ask. Never load any live site; no logins; never write to any WordPress site. Start no agents. Touch no other
agent's processes, worktrees or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step
4: Merge into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `c58e97dad13d63da794677e9274d8e6a0db9f4be`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-11.6`); bump to `2026-11-11.7` (or the next free `.N` for `date +%F`). `npm run build` and
   `npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) exit 0; Node
   `/home/justin/.local/node-v22.23.3/bin` first on PATH; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git add` every edited file, the moved ledger included after editing it;
   `git show --stat HEAD` must list each with its lines):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-site-sticky-header/progress.md docs/plans/2026-11-11-site-sticky-header-ledger.md`
     (if tracked; else copy read-only from `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-ac2cd66e50e7c986b/.superpowers/sdd/2026-11-11-site-sticky-header/progress.md`);
     `git ls-files .superpowers/` empty.
   - **Paste check id: 3eb** (already this job's in HANDOFF; confirm no merged section uses it). Replace this job's `<id at merge>` /
     "build set at the merge" / `<at merge>` placeholders in HANDOFF and the ledger with **3eb** and the new BUILD.
   - HANDOFF site-sticky-header: fix the stale sentence (review 3, R3-1, ~HANDOFF:83): in Safari before 16 the header scrolls away on
     every paste (site-scroll-lock's `@supports` fallback), not "only if Additional CSS holds the hidden rule". "Deferred / known
     limits", add if missing, one line each from `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/follow-ups.md`:
     R1-2 (a `#section` link lands under the header), R1-3 (Offcanvas z-index inside `#brx-header` in a template), R1-6 (a bar fixed
     only after a strip scrolls away), R2-1 (no `:has()` browsers), R3-2, R3-3, the auditor's painted-`<header>` note, verifier 2's
     "one draw without the lock" test gap.
   - `cmp` `docs/plans/2026-11-11-site-sticky-header.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: a scanned header the site's script keeps at the top stays at the top in the paste, in the page or a Header
   template, even with overflow-x hidden in Additional CSS and while a pop-up holds the page (site-sticky-header)` (plain `git commit`;
   no author override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git
   push` (`main` only, as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status:** the build line and one line at the top of the feature list: "**<BUILD>
   site-sticky-header (website importer):** a header whose bars the site's script keeps at the top (the capture's `web.position:
   "fixed"` mark, not fixed by the site's own CSS) gets one class `<page>__site-stay-<4>` on the header root: `position: sticky; top:
   var(--wp-admin--admin-bar--height, 0px); z-index: 100` (also on `#brx-header:has(.N)` for a Header template), `html:root, html:root
   > body { overflow-x: clip }` and the two `no-scroll` lines, so it stays at the top pasted in the page or in a Header template (Sticky
   header off or on), with `overflow-x: hidden` in Additional CSS, and while a pop-up holds the page; headers the site's CSS keeps or
   that scroll away paste as before; Figma designs byte for byte. Q1–Q5 A not yet confirmed. Known limits: a painted `<header>`
   wrapper isn't marked; a bar fixed only after a strip scrolls away pastes in flow. Paste check **3eb** (AC9, live: remake the pastes
   from the saved scan, paste into an emptied page, the header stays at the top on desktop and phone in a private window)."
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/site-sticky-header-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `c58e97da`, `git status` clean but for `site-check-out/`, `git
   log -1 --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[]` (empty is
normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
