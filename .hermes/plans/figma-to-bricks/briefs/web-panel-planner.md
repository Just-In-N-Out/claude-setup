# Planner brief: web-panel (J4 of the website importer, wave 2)

**Role:** planner (fresh Opus 5.5, xhigh) for one Full-pipeline job. You write the job's implementer-ready plan; you
build nothing. Justin is asleep under an away grant (`~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`):
you can't ask him anything. Put questions at the top of the plan, each with options and a ⭐ answer; the build takes
the ⭐ answers ("taken under the away grant"). Where a source is unclear, research and decide; record it as a ruling,
not yet confirmed.

**Skills:** load `engineering-best-practices` and `implementation-planning` with the Skill tool; read the project skill
with Read: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (and the `references/` it points you to).

## The job

The plugin panel in Figma opens a capture file (drop or open) instead of a Figma selection: it converts the part chosen (Page / Header / Footer, later Pop-ups), takes pictures from the file instead of Figma, uploads pictures and fonts to WordPress as today, remembers the site's header/footer ticks after those parts are copied, and shows the warnings and lists (floating extras, embeds) as it does for a Figma design.

The approved proposal is `~/.hermes/plans/figma-to-bricks/website-importer-brainstorm.md` (Justin's final answers at
the top, chosen for the most faithful one-to-one copy). This job is its **J4** row in §9; read the whole proposal
(§2–§10 all bear on it) and plan exactly that row's scope, with the proposal's ACs for it as the start. Other jobs are
planned separately; note what you need from them as a hand-over, never build it here. Also read the repo's
`CLAUDE.md` and `docs/specs/2026-10-06-v2-design.md`.

## Wave one is not merged yet: read it where it is

- **J1 web-capture** (the capture format you build on), in review: head `c0f0529`, readable in place at
  `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-abd9b14258d5e32f2/` (read only; its
  `docs/specs/web-capture.md`, `src/core/snapshot/web.ts`, `src/web/`, its HANDOFF section and its evidence
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/builder/`, live captures in `corpus/` there).
- **J0 web-compare** (the oracle your ACs are judged by), in fix pass 1: head `6f47616`, readable at
  `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/agent-ac72814ffff3e6cce/` (`npm run compare`,
  `test/web/lib/`, its HANDOFF section).
- Your builder starts only after J1 (and J0) merge into `main`; plan against their current heads and say which of
  their facts your plan depends on, so a review change there can be spotted.
- Other wave-2 jobs planned in parallel: **web-tiers** (J2: per-tier layout, normalise/adapt/phone), **web-panel** (J4:
  the panel opens a capture), **web-embeds** (J5: embeds, maps, floating extras). List your owned files and any file
  another of these may touch.

Read especially proposal §4 (the panel opening a capture file), `src/ui/` (`env.ts`, `run.ts`, `main.ts`, `debug.ts`), `src/plugin/main.ts` and `src/shared/messages.ts`, and `test/fixtures/panel.ts` (how panel tests stand in for the browser). The panel runs inside Figma desktop: say which ACs tests prove and which are `(live)` (Justin dropping a capture on the panel and pasting). CLAUDE.md's sandbox rules (no URL/TextDecoder in code Figma runs; SES-forbidden strings) apply.

## Where you work

You start in your own agent worktree at `main` (`3ea33bb`). Write the plan there as `docs/plans/2026-10-30-web-panel.md`
and commit it to your copy's branch (plain `git commit -m`, no author override, no AI lines; no CLAUDE.md staged).
Don't push, don't bump `BUILD`, don't edit CLAUDE.md, never bare `git stash`. Probes and saved pages go in
`~/.hermes/plans/figma-to-bricks/evidence/web-panel/planner/`. Report your branch and commit SHA.

## The plan must have

- Playback in plain words, the questions (⭐) at the top, then numbered acceptance criteria **AC1, AC2…**, each with one
  named test (mark ones you add or change as **proposed**; tag checks only Justin can do `(live)` right after the id).
  Tasks a fresh agent with no context can build test-first, owned files, the hand-over.
- **General logic only** (CLAUDE.md "Build general logic"): nothing keyed on one site's names, ids, classes, texts or
  sizes; Figma conversions stay byte-identical unless the plan says why not.
- **bdryswi.com now answers automated Chrome with a bot-check page: don't load it**, and never try to hide automation.
  Its live captures are owed to Justin (he must allow-list the capture). Prove ACs on fixture sites, the plugin-made
  Bricks site `https://darksalmon-badger-335429.hostingersite.com/` and `https://www.letsgro.ai/` (GET only), and the
  proposal's earlier bdryswi.com evidence; name the bdryswi.com checks as owed, not as agent-provable ACs.
- **This machine (WSL):** read `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`
  (Chrome wrapper as `CHROME_PATH`; a browser run counts only with `skipped 0`; `npm run corpus` measures nothing
  here: say how the byte-identity receipts are taken).
- Never write to any WordPress site.

## Report back

The plan path, branch and commit; the questions with ⭐; the ACs one line each (marking `(live)` and **proposed**);
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable lessons only; `enforce` `none` or a one-line check
proposal; an empty list is normal; never edit skills or memory yourself), and end with:
`MAIN SESSION: check and save these skill_lessons now.`
