# Finisher brief: after-merge steps for site-native-structure (website importer)

**Role:** after-merge finisher (fresh **Opus 5.5, high**), in the **main folder** `/home/justin/Documents/FigmaToBricksV2` (not a worktree).
The session just fast-forwarded local `main` from `4f8b6116` (Build 2026-11-11.10) to `172be61aacaa19e8fcf06f926ea7cdfecc94707d`
(`site-native-structure-merge`), accepted (READY FOR THE USER 14/15 on `d6f16984`; test-only re-pins and HANDOFF in 2 commits, review 9
delta clean, receipt EXIT=0 — Justin's notes-only rule). The session holds the merge lock (`website-importer-d1`); don't touch it. Never stop
to ask. Never load any live site; no logins; never write to any WordPress site. Start no agents. Touch no other agent's processes, worktrees
or branches. Work quickly (10–15 minutes).

**Skills:** load `git-commit-rules`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` ("Step 4: Merge
into main", the paste-check id line) and the repo `CLAUDE.md` "Finish" step 3.

## Steps
1. Confirm `git rev-parse HEAD` = `172be61aacaa19e8fcf06f926ea7cdfecc94707d`, branch `main`, clean but for untracked `site-check-out/`.
2. Read `src/shared/build.ts` (now `2026-11-11.10`); bump to `2026-11-12.1` (or the next free `.N` for `date +%F`). `npm run build` and `npm
   run check` exit 0, run as `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0 --working-directory=<repo> /bin/bash -c 'export
   PATH="/home/justin/.local/node-v22.23.3/bin:$PATH"; npm run check'`; a timing test failing under load reruns alone.
3. Records in the same commit (docs and `build.ts` only; `git show --stat HEAD` lists each):
   - The ledger is already `docs/plans/2026-11-09-site-native-structure-ledger.md` (`git ls-files .superpowers/` empty): add a closing
     "Merged" line (build, paste check).
   - **Paste check id: 3eg** (3dz, 3ea–3ef used; confirm 3eg unused on main's HANDOFF). Replace `<site-native-structure id at merge>` (and any
     "build set at the merge" placeholder of this job) in HANDOFF and the ledger with **3eg** and the new BUILD. Add 3eg to HANDOFF's
     "End-of-run check list" if the job's section doesn't already put it there.
4. Commit `Build <BUILD>: the website importer's --elementor paste is Bricks' own Section / Container / Block, Heading, Button, Divider and
   linked Image, a part's root that draws nothing left out (site-native-structure)` (plain `git commit`; no author override, no AI or
   Co-Authored-By lines; `git diff --cached --name-only` without CLAUDE.md or site-check-out); then `git push` (`main` only, as Just-In-N-Out
   through the repo's own helper).
5. Update the repo `CLAUDE.md` (not in git) **Status**: the date and build line, and one line at the top of the feature list, compact like its
   neighbours, from HANDOFF's site-native-structure section: what the paste now is (Elementor sections/containers/inner containers → Section,
   Container, Block; Buttons, Dividers, linked Images standing alone where the site's box only holds them, kept and named otherwise; a part's
   root that draws nothing lifted, its top Sections carrying the reset, scroll-lock and fonts; the header root kept as one Block "Header" only
   where two pasted top Sections show at one width; labels from first words), plain route and Figma designs byte for byte; Q-rulings not yet
   confirmed (name them as HANDOFF does); paste check **3eg** (AC15, live: a capture made with Build 2026-11-11.2 or later, paste B-Dry's home on
   staging: two top Sections, the bar for each width stays at the top at 1440 and 390, ☰ opens, one pop-up opens as on bdryswi.com).
   If writing CLAUDE.md is refused, leave the lines in `~/.hermes/plans/figma-to-bricks/site-native-structure-claude-md-pending.md`.
6. Verify: `git log --oneline -3 main` shows the build commit on top of `172be61a`, `git status` clean but for `site-check-out/`, `git log -1
   --pretty='%an <%ae>'` is `Justin <issajustin04@gmail.com>`, `origin/main` equals `main`.

## Report (as text)
Build commit SHA and BUILD; push result; files changed; paste check id; CLAUDE.md written or pending; `skill_lessons[]` (empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
