# Role: fixer (round 4, Justin's second naming ruling): web-code-page

You are a fresh fixer for FigmaToBricksV2 (Opus 5.5, xhigh). Build one change test-first, then stop at `ready-for-review`.
Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`, never bare `git stash`, never push or merge, don't bump
`BUILD`, leave other worktrees alone, start no agents. Never load bdryswi.com; no logins; never write to any WordPress site.

**Skills to load:** `receiving-code-review`, `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline`. Read the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md` and `references/live-site-reading.md`, and the repo `CLAUDE.md` ("Build general logic";
ids are deterministic; an empty global class is `settings: []`).

## The finding and Justin's ruling
Amendment 3 (fixer 3, `c920728a..f28f1dc0`) put the page's name only in front of wordless sections (`home__section`).
Review 4 (`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/review-4/review.json`) R4-1: classes named from a
section's words stay plain (`services`, `services__heading`, `why`, `step-1`…`-5`, `section-2026`), so they can clash with a
team's own class of that name, and R4-2: two pages of one site share word-named classes, so Accept on the second restyles the
first. **Justin, 2026-11-07** (`evidence/web-code-page/justin-r4-1-prefix.md`): "Prefix every name (Recommended)": every
code-method class starts with the page's name (`home__services`, `home__step-1`, `home__section`), which also keeps two pages
of one site apart.

## Inputs
- Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-a631038f87d3d7d43`, branch `web-code-page-build`,
  head `f28f1dc0`, base main `ea504778` (don't rebase).
- Plan (read-only copy): `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md`.

## Work
1. Extend the rule (`src/core/site/classes.ts` `slugOf`/`pageSlugOf`, its two callers): every section slug, worded or not,
   starts with `<page>__`, so every class but the plugin's own exact `site-*` names (reset, fonts, text, flat) is under the
   page. Decide and state whether the parts' shared roots (`site-page`, `site-page__inner…`, `site-header`, `site-footer`)
   also take the page (they differ per page's capture, so R4-2 says they should, at least `site-page…`); keep it general.
   Keep numbering counted on the full prefixed name, so `home__step-2` (repeat) can't equal the words "Step 2"
   (fixer 3 note 4; test it). Keep the 24-character page cap; check the whole name stays a valid Bricks class.
2. Test first (RED on `f28f1dc0`): tighten `test/web/lib/class-names.ts` `bareNames` so every class is the page's or an exact
   plugin `site-*` name; two pages of one capture-set (different addresses, a same-worded section) share no class name
   except the exact `site-*` ones. Mutate the guard. Prove every paste is byte-identical apart from the renames (fixer 3's
   `rename-compare` method: whole `.name` selectors and class name/id fields only, with controls).
3. Record the ruling as **Amendment 4** in the plan (his words verbatim, the rule, the tests), commit it on its own; update
   HANDOFF (Amendment 4 entry; AC12 step 4 stays: Accept unless a team name appears).
4. Gates as fixer 3 ran them: both typechecks, `npm run check`, five replays byte-identical to main, AC7/AC16/AC20
   (`site-page-proof`), AC9/AC17/AC18, AC10 (`F2B_CODE_PAGE_CAPTURE=/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`),
   `test:web` file by file under the 4 GB cap. Evidence in `evidence/web-code-page/fixer-4/` (logs start `HEAD=`, end `EXIT=`).
5. Commits: plain `git commit -m`, no author override, no AI lines, no CLAUDE.md (`git diff --cached --name-only` first).
Note: elementor-map is being rebased onto `f28f1dc0` and will rebase again onto your head; keep `slugOf`'s signature if you
can, so its callers need no change.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-f4/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job at a time. Never edit a script a background
  run is executing.
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- A foreground Bash call goes to the background at 120 s: keep waits under 115 s.

## Report (as text)
The bare names found; the rule; test, RED/GREEN logs, commits, mutants; head SHA; what Justin will see in Bricks' class list;
gates; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
