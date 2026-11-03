# Role: planner — web-address (website importer: type the site's address in the plugin panel)

You are a fresh planner for FigmaToBricksV2. You plan only: no product code, no tests committed beyond the plan file,
no BUILD bump, no merge, no push, never start other agents. Other agents work in other copies of this repo: never touch
the main folder `/home/justin/Documents/FigmaToBricksV2` (read it only), never use bare `git stash`, leave every other
worktree alone.

## The request (Justin, 2026-11-02)

"I want to be able to import a live website, not related to Figma, using my plugin." Asked how, he chose **"Address in
the panel"**: he types a website's address into the plugin's panel; a small helper he starts once on his PC reads the
site in Chrome (the importer's existing capture) and sends the result straight to the panel; he picks Page / Header /
Footer, presses Convert and copy, and pastes into Bricks. No capture file to move around. Figma only hosts the panel; no
Figma design is involved.

Justin's standing rules for the importer: "focus on building and not too much of edge cases"; one review per job (real
bugs only); ACs proven by a verifier and a blind auditor before merge.

## What already exists (read it at the code below)

- **Capture (wave 1, J1):** `npm run capture -- <url>` (`tools/capture.ts`, `src/web/`, spec `docs/specs/web-capture.md`):
  reads a page in Chrome at every switch point, writes one capture file (10–40 MB, pictures inside), `--list` lists a
  site's pages, asks once per site "is this your client's own site?". About 5 minutes a page.
- **Panel (wave 2, J4):** the capture box (`src/ui/capture*.ts`, `src/ui/main.ts`, `src/plugin/capture.ts`): open or
  drop a capture file, Page / Header / Footer, Convert and copy, pictures from the file, the old site's alt text and
  fonts, ticks per site. Spec section and HANDOFF's web-panel section.
- Your worktree starts at `main`. The code to plan against is the panel's rebased head (not merged yet; it merges
  within hours): `git checkout --detach c2f6a160f533a8912727e8fcc4cc9ad5255708e7`, then `git switch -c web-address`.
  Write the plan as `docs/plans/2026-11-02-web-address.md`, commit it (plain `git commit -m`, no author override, no AI
  lines, no CLAUDE.md staged), copy it to `E/planner/plan.md`, and report the branch and commit SHA.
- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-address` (yours: `E/planner/`).

## Questions the plan must settle (each with a ⭐ answer; Justin takes the ⭐s under his standing auto-go)

1. **How the panel reaches the helper.** Figma's plugin network rules (`manifest.json` `networkAccess`:
   `allowedDomains`, `devAllowedDomains`, `reasoning`; this plugin is loaded as a development plugin from its manifest),
   whether `http://localhost:<port>` / `127.0.0.1` is allowed from the panel's iframe, and CORS from Figma's `null`
   origin. Read Figma's current docs; prove it with a probe if you can (a tiny local server and the panel's fetch path
   through `src/ui/env.ts`).
2. **The helper.** How Justin starts it (one command, e.g. `npm run capture:serve`, or a double-click), what it listens
   on (127.0.0.1 only), how the panel knows it's there and says so plainly when it isn't ("Start the importer helper:
   …"), how a capture's progress lines reach the panel during the ~5 minutes, how the result reaches the panel without
   a file step (stream, or a temp file the helper serves), and that it never writes to any WordPress site.
3. **Safety.** Only Justin's panel may ask it to read a site (a pairing token or similar); only http(s) addresses; the
   "client's own site" question in the panel; nothing secret in the paste, the debug file or the Figma file.
4. **The Windows desktop:** the helper runs in WSL while Figma desktop runs on Windows; check WSL's localhost
   forwarding from Windows to WSL (Mac: everything local). Name what Justin must do once.
5. **Pages:** typing a home address and choosing other pages from `--list` in the panel, or one page at a time first.

## Inputs and skills

Read the repo `CLAUDE.md`, the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/live-site-reading.md`, and the brainstorm `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md`
(§2, §4, the walkthrough). Load `engineering-best-practices`, then `implementation-planning` and
`security-best-practices` (a local server that reads websites on request).

## The plan

Playback, the answers above with evidence, tasks a builder with no context can follow, and numbered ACs (AC1…,
**proposed**) with one named test each: the address box, helper found / not found, progress, the result opening as the
capture box does today, Convert and copy unchanged, the safety rules, the Figma replays byte-identical. A `(live)` AC
for Justin's real run in Figma desktop on the Windows desktop. Keep it the smallest change that gives Justin the
address box; list anything larger as a follow-up.

## Rules

- Live reads only of `https://darksalmon-badger-335429.hostingersite.com/` (add `?f2b=<random>`) and
  `https://www.letsgro.ai/`, GET only; never bdryswi.com (bot check); never write to any WordPress site.
- This machine (WSL): `CHROME_PATH` = `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`,
  Node `/home/justin/.local/node-v22.23.3/bin` first on PATH, `TMPDIR` short (`~/.cache/waddr-plan/tmp`). One Chrome job
  of your own at a time, closed after each step. SIGTERM / exit 143 / 137 / "Killed" may be an earlyoom kill
  (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`); rerun such a check under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Write multi-step scripts with Write and run
  `bash <file>`; the bare word `source` in a command is refused.
- Put any summary in your report, not in a separate summary file.

## Report

Branch, commit SHA, plan path; the five answers in one line each with their ⭐; the ACs one line each (proposed, live
marked); then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; `enforce` `none` or a one-line check
proposal; empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
