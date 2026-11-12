# Finisher brief: after-merge steps for media-avif-alt (website importer uploader)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `5bf71692` (Build 2026-11-11.9) to `7f53ecf9fe02dba712b24a5e23e8b7364a85fff3`
(`media-avif-alt-final2`), accepted (READY FOR THE USER 15/17 on `caf9291f`; two HANDOFF-only rebases, review 3 clean, receipt EXIT=0 —
Justin's notes-only rule). The session holds the merge lock (`website-importer-d1`); don't touch it. Never stop to ask. Never load any live
site; no logins; never write to any WordPress site; never call alttext.ai. Start no agents. Touch no other agent's processes, worktrees or
branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the `.superpowers` line, the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `7f53ecf9fe02dba712b24a5e23e8b7364a85fff3`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-11.9`); bump to `2026-11-11.10` (or the next free `.N` for `date +%F`). `npm run build` and `npm
   run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git add` every edited file, the moved ledger after editing it; `git show --stat
   HEAD` lists each with its lines):
   - Ledger: `git mv .superpowers/sdd/2026-11-11-media-avif-alt/progress.md docs/plans/2026-11-11-media-avif-alt-ledger.md` (if tracked);
     `git ls-files .superpowers/` empty.
   - **Paste check id: 3ef** (3dz, 3ea–3ee used; confirm 3ef unused on main's HANDOFF). Replace this job's `<id at merge>` / "build set at
     the merge" placeholders in HANDOFF and the ledger with **3ef** and the new BUILD.
   - HANDOFF media-avif-alt "Deferred / known limits", add if missing, one line each from
     `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/follow-ups.md`: R1-3, R1-5, R1-6, R1-8, R2-1 (correct the limit line
     that names `src/ui/uploader.ts checkHits`: the id-only "already in your library" for recorded pictures is this job's own `checkKnown`),
     R2-2, R2-3, R2-4, the paste notes' "decorative" wording after AI alt, a CMYK JPEG not probed.
   - `cmp` `docs/plans/2026-11-11-media-avif-alt.md` with `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/plan-approved.md`;
     copy over if they differ.
4. Commit `Build <BUILD>: site:upload and site:import send a scanned page's JPEG, PNG and WebP pictures as AVIF and fill empty alt text with
   alttext.ai (key asked once, saved 0600); --as-served/--no-ai-alt give the old behaviour (media-avif-alt)` (plain `git commit`; no author
   override, no AI or Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only,
   as Just-In-N-Out through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git):
   - **Status:** the build line and one line at the top of the feature list: "**<BUILD> media-avif-alt (website importer uploader):**
     `site:upload`/`site:import` make every still JPEG, PNG and WebP a `.avif` before the typed yes (the panel's pinned encoder in an offline
     Chrome of the tool's own; own size up to 2560 px, upright, alpha kept; SVG, GIFs, moving pictures and AVIF stay as served, named; a
     picture that can't be made stops the run, never another format), record keyed `<source>-avif-max2560` (earlier as-served uploads aren't
     sent again; `--reupload-avif` sends AVIF copies), and after the upload describe every picture whose alt is still empty in WordPress with
     alttext.ai (key asked once after the login, tested, saved `~/.config/figma-to-bricks/alttext-key` 0600; Enter skips; `--new-ai-key`,
     `--no-ai-alt`), writing only `{alt_text}` on an item this tool uploaded whose file still matches; `--as-served --no-ai-alt` is byte for
     byte as before; nothing under `src/` changed. Q1–Q13 ⭐ not yet confirmed. Paste check **3ef** (AC16, AC17, live: his own `site:import …
     --elementor --reupload-avif` on B-Dry staging, Media shows `.avif` with alt text, the pastes show them)."
   - Replace in "One uploader writes to WordPress…": "It only adds media items (never changes, moves or deletes one; …)" with "It only adds
     media items and fills the empty alt text of an item it uploaded itself whose file still matches (never changes, moves or deletes one;
     …)", and add one sentence: "The alttext.ai key is asked once and saved only in `~/.config/figma-to-bricks/alttext-key` (0600); it never
     goes in an argument, a variable, the record, the capture, the paste, a log, a printed line or Chrome, and is sent only to alttext.ai."
   - In "A scanned page's pictures go to WordPress from the command line": mark Q6 A ("files as served") and Q8 A ("no alttext.ai") as
     reversed by media-avif-alt (Justin, 2026-11-11: AVIF for photos and PNGs; AI alt text for pictures with none).
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/media-avif-alt-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `7f53ecf9`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[]` (empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
