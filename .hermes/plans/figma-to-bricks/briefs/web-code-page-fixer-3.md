# Role: fixer (round 3, Justin's naming ruling): web-code-page

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). Build one change test-first, then stop at `ready-for-review`.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump
`BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md` and `references/live-site-reading.md`, and the repo `CLAUDE.md` ("Build general logic";
ids are deterministic; an empty global class is `settings: []`).

## The finding and Justin's ruling
elementor-map's review 4 (R4-2, `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-4/review.json`)
found: the code method (`src/core/site/classes.ts:34`) names a section with no words plain `section`, and B-Dry's
`header.json` carries it. B-Dry staging already has the team's own global classes `section`, `container`, `h1`–`h4`, `text1`…
(memory `bdry-home-copy`). AC12's step "press Accept in Import classes" would replace the team's `section` styles on their
hand-built pages; Reject breaks the pasted header. **Justin, 2026-11-07** (`evidence/web-code-page/justin-r4-2-section.md`):
"Never use bare names": the code method always puts the page's name in front of generic class names (e.g. `home__section`),
so it never clashes with a site's own classes.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a631038f87d3d7d43`, branch `web-code-page-build`,
  head `c920728a`, base main `ea504778` (don't rebase).
- Plan (read-only copy): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md`.

## Work
1. Verify the finding on the saved B-Dry stand-in capture and the generic fixture: list every class name each paste
   (header, page, footer, `--section`) can carry that has no page or section prefix (`section`, `container`, a bare role, an
   element name, `h1`…), apart from the plugin's own shared `site-*` classes.
2. General rule: no code-method class is ever a bare name: one with no section slug gets the page's slug in front (the
   capture's page name or address path; home → `home`), in the plan's style "slug, then a role". Test first (RED on
   `c920728a`): every class of every paste of the fixtures and the B-Dry stand-in either starts with a page/section slug or is
   a plugin `site-*` class. Mutate the guard. Pastes other than the renamed classes stay byte-identical (prove it by renaming
   only whole `.name` selectors and class name/id fields when comparing, never raw substrings).
3. Record Justin's ruling in the plan as a short **Amendment 3** paragraph (his words verbatim, the rule, the test's name),
   and in HANDOFF (AC12's steps: what Import classes may list now, and what to press). Commit the plan change on its own.
4. Gates: both typechecks, `npm run check`, five replays byte-identical to main, AC7/AC16/AC20 (`site-page-proof`),
   AC9/AC17/AC18 (named inputs as the plan says), AC10
   (`F2B_CODE_PAGE_CAPTURE=/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`), `test:web` file by file under the 4 GB
   cap. Evidence in `evidence/web-code-page/fixer-3/` (logs start `HEAD=`, end `EXIT=`).
5. Commits: plain `git commit -m`, no author override, no AI lines, no CLAUDE.md (`git diff --cached --name-only` first).
Note: elementor-map is built on `c920728a` and will rebase onto your head; it names its own classes after their rules.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-f3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time. Never edit a script a background
  run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- A foreground Bash call goes to the background at 120 s: keep waits under 115 s.

## Report (as text)
The bare names found; the rule; test, RED/GREEN logs, commits, mutants; head SHA; what Justin will see in Bricks' class list;
gates; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
