# Role: planner (Mini): site-tests-offline — every test that draws a site capture or paste keeps Chrome offline

You are a fresh planner (**Fable 5.2, high**). Load `implementation-planning` and `engineering-best-practices`; read the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (directly) with `references/testing-pitfalls.md` (the
"Website-importer browser tests **must** keep every outside address offline" line). **Mini mode:** load the project skill and only the code
this touches; skip the full Step 1 context load; finish within about 15 steps. If this is bigger or riskier than a Mini job, say so and
recommend Full. Read only: no worktree edits, no code, no commits. Never load any live site; never run a test that draws Justin's scan or the
B-Dry stand-in with a Chrome that isn't offline; touch nothing under `~/Downloads`. Plain `git` in your own worktree, each command alone.

## The request (Justin, 2026-11-14: "Fix it")
A builder found that main's `test/web/site-slider-bdry.test.ts` draws Justin's scan in a bare `launchChrome()` without `SITE_OFFLINE`
(`tools/lib/site-chrome.ts`) whenever `F2B_BDRY_CAPTURE` is set, so pictures the capture holds no bytes of, font files and widget loaders are
fetched from the live site (bdryswi.com, growithgro1.wpcomstaging.com and others) during a test. Justin's rule: agents never load his site or
any live site. Fix the class, not the one file: find every test (`test/web/**`, `test/browser/**`, test helpers under `test/web/lib/` and
`test/fixtures/`) that draws a site capture or a site paste (Justin's scan, the B-Dry stand-in, any saved real capture, named-only or not) in
a Chrome launched without `SITE_OFFLINE`, and make them launch offline (through one shared helper if one fits); plus a guard (a unit test run
by `npm run check`) that fails when a test file under `test/web` or `test/browser` launches Chrome for a site capture/paste without the offline
rules — or, if a static check can't tell, a runtime guard in the shared launch path. Tests only: no file under `src/` or `tools/` changes
unless the plan shows the shared offline launch must move there (say why). Local fixture servers on 127.0.0.1 and Google Fonts must still
load (as `site:check` does).

## Base
Local main `392f67e2a6b52c40a64acaf7d344a50c934dee26` (Build 2026-11-14.2): `git checkout --detach 392f67e2…`.

## Write
`/home/justin/.hermes/plans/figma-to-bricks/site-tests-offline.md`: playback; the list of offending files with file:line evidence (how each
launches Chrome and what it draws); the fix; numbered ACs AC1, AC2… (marked **proposed**) with one named test each — at least: every listed
file launches offline (proved by a request log under a mapped fake live host: 0 requests leave 127.0.0.1/Google Fonts), the guard fails on a
one-line mutant that launches bare, and every touched test still passes on its normal inputs and fails as before where it failed; no
`(live)` AC unless truly needed; touched files; a one-line Docs & records task (HANDOFF line + the testing-pitfalls line names the guard);
questions at the top with ⭐ answers (if any). Keep it short.

## Report (as text)
Plan path; file count; the ACs one line each; questions; `skill_lessons[{skill, lesson, evidence, enforce}]` (never edit skills or memory;
empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
