# Role: planner + builder (Justin's quick job, no review pipeline): importer-gro-look — the importer app's page in GRO's look

You are a fresh agent (**Opus 5.5, xhigh**) for FigmaToBricksV2. Justin (2026-11-16): "fix the UI of this page? Make it more for like Gro based and nicer and all", then "literally no need for pipeline just plan and build", and "Read growithgro.com". So: write a short plan, then build it; no reviewers follow you, so check your own work properly.

Load `engineering-best-practices`, `ux-frontend-workbench`, `frontend-design:frontend-design`, `test-driven-development` (for any test you add), `git-commit-rules`, and the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read `figma-to-bricks/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Read the repo's `CLAUDE.md` ("The importer app (`npm run importer`)…" rule) before you start.

## Scope
- The app's page only: `tools/lib/importer-app/page/` (`index.html`, `app.css`; `views.ts`/`main.ts` only for class names or markup the look needs). **Nothing it does changes**: every control, id, label meaning, step order, button state, prompt and request stays as is; the server, guard, commands, uploads, preview child and pastes are untouched (byte for byte for anything but the page's look).
- Keep the page's Content-Security-Policy as it is (`tools/lib/importer-app/guard.ts` `SHELL_CSP`: `style-src 'self'`, `img-src 'self' data:`, no font source). So no Google Fonts or remote files on the shell page: use a system font stack close to GRO's font, and the GRO logo only as an inline SVG or `data:` image, or a file the app already serves from `'self'` (if you add a static file, add it the way the server serves the page's own files and keep the guard tests green). Don't loosen the CSP.

## GRO's look
Read `https://growithgro.com/` **once, read only** (WebFetch or a plain GET; no logins, no forms, nothing posted; no other site, never bdryswi.com or the staging sites): its colours, fonts, logo, button and card style, spacing. Save what you took to `~/.hermes/plans/figma-to-bricks/evidence/importer-gro-look/brand.txt` (colours as hex, font names, where the logo came from). If the logo is an SVG, keep it inline; if only a raster, a small `data:` copy is fine.

## Make it nicer
Justin uses it step by step (1 Scan a page, 2 Saved scans, 3 Pictures to WordPress, preview, Copy buttons, Notes). Make it clean and modern in GRO's colours: a GRO header bar with the logo and the title, clear numbered step cards, a strong primary button, clear disabled state with its reason readable, good focus rings (WCAG 2.2 AA contrast, keyboard use unchanged), works at laptop widths (1280–1920) and doesn't break at 1024. Light theme is enough; dark only if cheap.

## Plan, build, check
1. Plan: `~/.hermes/plans/figma-to-bricks/importer-gro-look.md` (`.md` writes may be refused for background agents: use `.txt` then): what changes, numbered ACs (AC1 the page looks GRO with the brand from brand.txt; AC2 nothing it does changes: every existing `test/unit/importer-app-*` and `test/web`/browser test of the app green, ids and labels unchanged; AC3 CSP unchanged; AC4 contrast/focus AA…). No questions to Justin: decide and note.
2. Build in your worktree (an `isolation: worktree` copy at origin/main = 38a9ec1b, Build 2026-11-15.7). Commit after each step (plain `git commit -m`, no author override, no AI or Co-Authored-By lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder.
3. Check: `npm run check` (under `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`, `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`, Node `/home/justin/.local/node-v22.23.3/bin`), the importer-app tests, and any browser test of the app. Start the app locally against a local folder holding a test capture (never a real site; no password, no upload) and take before/after screenshots at 1440 and 1024 with the headless Chrome, saved to `~/.hermes/plans/figma-to-bricks/evidence/importer-gro-look/` (`before-1440.png`, `after-1440.png`, …), including a state with a scan picked and section 3 filled.
4. Rebase on local `main` before you stop (`git rebase main`; Justin's main folder is on `main` at 38a9ec1b unless another session moved it), rerun the checks if it moved.

## Report (as text)
Branch and head (full SHA), what changed (files), the brand taken, the screenshot paths, the checks with numbers, `ac_status` per AC, `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
