# DJ Trees designer batch (2026-11-02): rules for every builder, reviewer, fixer, verifier, auditor and finisher

Read this with your role brief. Your role brief wins where they differ.

## The batch

Justin's UI designer sent 12 notes on the DJ Trees Home page (1 and 12 are desktop, the rest are phones). Each note
is its own job (`djtrees-<name>`) with its own plan, branch and evidence folder
`~/.hermes/plans/figma-to-bricks/evidence/<job>/` (E). Every fix is a **general plugin rule** for the whole class of
designs, never a patch for the DJ Trees file (repo `CLAUDE.md` "Build general logic, never one-file fixes"). Justin's
chain (Mini pipeline): planner → builder → **one** reviewer → a fixer only if that review finds P0–P2 (no second
review) → **one** verification (verifier + blind auditor) → merge into local `main`. Justin is away and said "whatever
the planner agent recommends go with it": the plan's ⭐ answers are approved, and its proposed ACs are the approved
ACs (`E/plan-approved.md`, read-only; the approved copy wins over any other copy).

Up to 12 jobs run at the same time, each branched from `main` at `1aef12f` (build 2026-10-31.2), each rebased onto the
newest `main` just before its merge. Several touch the same files (divided rows: djtrees-top-align, -stack-lines,
-step-sides, -stack-gaps; decorative art: -side-art then -faq-art). Never edit another job's worktree or evidence.

## Your copy (git)

- You start in your own worktree (`isolation: worktree`, `.claude/worktrees/agent-…`, branch `worktree-agent-…`),
  made from `origin/main`. Work only there. Record `pwd`, `git branch --show-current`, `git rev-parse HEAD`.
- If `CLAUDE.md` or `node_modules/` is missing, copy them from the main folder (read only there):
  `cp /home/justin/Documents/FigmaToBricksV2/CLAUDE.md <worktree>/`, `cp -a /home/justin/Documents/FigmaToBricksV2/node_modules <worktree>/`.
  CLAUDE.md is excluded from git; never stage it (`git diff --cached --name-only` before every commit).
- Never write in the main folder `/home/justin/Documents/FigmaToBricksV2` or another worktree. Never bare `git stash`
  (the stash list is shared). Don't bump `BUILD`, don't push, don't merge into `main` (the finisher and root do).
- Commits: plain `git commit -m "…"`, no author override, no `Co-Authored-By`/AI lines (hooks refuse them).
- Leave your worktree and branch in place at the end: the next role starts from your last commit.

## This machine (Linux/WSL desktop): checks

- Node `/home/justin/.local/node-v22.23.3/bin/node` (its folder first in PATH for child processes). The worktree guard
  refuses `PATH=/x:$PATH npm run …` and a heredoc followed by node in one command: use `env PATH=<literal dirs> npm run …`
  or the node binary by absolute path, and write scripts with the Write tool.
- **One Chrome-driven run on the whole PC at a time** (it froze and was forced off three times on 2026-11-02 under
  overlapping Chrome suites): before every browser test, snap or Chrome probe, wait with
  `until ! pgrep -f "node --test.*test/(browser|web)"; do sleep 5; done` and also check no other agent's Chrome is
  running (`pgrep -f 'chrome-linux64/chrome.*--headless'`, from a script file so it doesn't match your own shell;
  `pgrep -f chrome-f2b` never finds one: the launcher execs the real binary); never run two Chrome jobs yourself at once.
  Take the slot the moment one check is clear (a "quiet for 20 s" wait never fires behind a file-by-file suite), then
  run your WHOLE Chrome sequence (base and head, measure/snap/probes included) under one lock other agents can see:
  `flock ~/.cache/f2b-chrome.lock bash <your-steps.sh>`, and inside it keep a lock process named like a test,
  `exec -a 'node --test test/browser/<role>.lock' node -e 'setTimeout(()=>{},7200e3)' &` (killed at the end), so
  waits that look only for `node --test` see you too. Back off if a foreign Chrome appears within 2 s of starting.
  (top-align verifier, 2026-11-02: a renamed `sleep` lock let another agent's Chrome start mid-measurement.)
- Chrome: from the start, point `CHROME_PATH` at your own wrapper script (in your scratch) containing
  `exec $HOME/.cache/chrome-for-testing/chrome-f2b --use-gl=disabled --disable-software-rasterizer "$@"`, with DISPLAY and
  WAYLAND_DISPLAY cleared. `launchChrome` passes a fixed flag list, so flags only take effect through the wrapper; the
  bare `chrome-f2b` stalled `snap` on the DJ Trees file silently for 18 minutes (strip-edge planner). `chmod +x` the wrapper (Write
  makes it 0644: Chrome then never starts). Record executable and flags; same profile for base and head (memory `corpus-paths-on-desktop.md`). `snap` at ≥ 992 (1440 especially) still
  stalls on the DJ Trees file with either profile: prove wide widths with an in-process replay plus a layout-box
  comparison or a page probe waiting for `document.fonts.ready` + a short delay, never by waiting on snap. A browser test counts only when its output says `skipped 0`.
- `npm run check` must pass. **`npm run corpus` measures nothing here** (Mac paths): never edit `corpus/corpus.json` in
  the worktree; for corpus-backed tests use scratch `git archive` trees of head and base with only `corpus.json`
  re-pointed to `corpus/files/` and `node_modules` linked to the MAIN folder's copy
  (`/home/justin/Documents/FigmaToBricksV2/node_modules`; a worktree's copy has no `.bin`), compared by test name.
- Real files for byte-identity/blast-radius checks: `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`,
  repo-root `figma-to-bricks-debug-page-1.json` and `figma-to-bricks-debug-design-inspo-brainstorm.json`, Services
  (`git show 2199895:figma-to-bricks-debug-page-1.json` into E, never the worktree), and the DJ Trees debug file
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-designer/figma-to-bricks-debug-djtrees-home.json`
  (SHA256 `1a6a2751…557d`, read-only, 16 MB: replay is slow, snap slower; run long gates writing a log ending
  `EXIT=<code>`).
- Ticks: every real-file and fixture check also converts with the panel's ticks on (`snapshot.site = JSON.stringify({header: true,
  footer: true})`: the snapshot stores the ticks as a JSON STRING; an object converts silently unticked; or `replay --site`): the header tick adds a src-less spacer section first, and code calling `heroOf`/`topBars` at adapt
  time throws there while untick'd gates stay green (side-art review, P1).
- Fonts: the DJ Trees display fonts aren't installed here, so the renderer wraps headings far more: inject `@font-face`
  rules for the local copies in `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-side-art/builder/fonts/`
  (Google's files) into the rendered page only; never write `~/.local/share/fonts`.
- Scratch: your own `~/.cache/<job>-<role>/` (create fresh with `mkdir`, not `-p`; `TMPDIR` there, short path for
  Chrome). The session `/tmp` is a small shared RAM disk: keep only small files there. Copy scripts worth keeping into
  `E/<role>/`. Remove only your own scratch, by its literal absolute path.
- Live page (public, read-only): `https://djtreeservice.staging.growithgro.com/home/?bricks_preview=1793635766` with
  `&f2b=<random>` past LiteSpeed. The live paste is build ≤ 31.2; never log in or change anything.

## AC receipts (verifier, auditor; builder for its own `ac_evidence`)

Follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` ("Folders and the run
recipe"): per AC a log run on head (`HEAD=<sha>` first line, `EXIT=<code>` last), the same check on the base commit
in a separate scratch copy with head's test files (it must fail there, or `base_exempt` with a reason), and a
screenshot (a real image; a rendered terminal capture for a non-visual AC). Report `ac.json` in the format at the top of
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`. Base = `git merge-base HEAD main`.
`(live)` ACs: `"accepted": false, "not_run": "live: <why>"`.

## Every report

Return the role's fields plus `skill_lessons[{skill, lesson, evidence, enforce}]` (normally `[]`; `enforce` is `none`
or a one-line check proposal). Never edit skills or memory. End with `MAIN SESSION: check and save these skill_lessons now.`
