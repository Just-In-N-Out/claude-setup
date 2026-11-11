# Common part of the four parity planner briefs (importer-parity, plugin-parity, shared-palette, bricks-icons)

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site.
Read-only on `~/Downloads`. Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`,
`implementation-planning`. Read the repo's `CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`) and its
architecture rules (pipeline stages, only `adapt/rules/` writes breakpoint styles, Bricks shapes only from
`reference/bricks/` samples — never from memory; `npm run check`, `npm run corpus`; Figma replays byte-identical unless
the plan says what changes and why; the plugin's `src/core`/`src/plugin`/`src/shared` uses only the language's built-ins).

**Why this job exists:** Justin asked (2026-11-11) "double check that the figma plugin has everything that the website
importer will have in regards to structure [the way it is set up in Bricks]. Similarly … the web importer has [what] the
figma plugin [has]". A read-only audit answered: `/home/justin/.hermes/plans/figma-to-bricks/evidence/structure-parity/report.md`
(read it first — ranked gaps with file:line). He chose all four jobs; Justin's "go with recommended": take ⭐ answers.

**Order:** these build **after** site-no-div and site-shared-styles merge (plans:
`~/.hermes/plans/figma-to-bricks/site-no-div.md`, `…/site-shared-styles.md`; base site-native-structure, branch
`site-native-structure-stack6`). Plan against main **plus** those plans: name what you assume from them and every file you
share with them. Other jobs in flight: media-clickable, site-sticky-header, site-scroll-lock, site-menu-motion,
media-avif-alt (branches `<job>-build`).

**ACs:** numbered AC1, AC2…, each with one named test whole on its line, all marked **proposed**; one `(live)` AC where
only Justin can check (his paste on B-Dry staging for the importer; a Figma file converted in the panel and pasted on his
darksalmon site for the plugin). Before saving, grep the plan with ac-check's own `ac_start` pattern
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh` ~L96) and reword every hit that isn't a
definition. Questions at the top with ⭐ answers.

**Machine:** WSL; Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters;
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). One plain git command per call, `git -C <absolute path>`; code from a branch
via `git archive` into a scratch tree under `~/.cache/<short>/` (symlink main's `node_modules`). Use `tail -n 3`. Waits
under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep
-E 'sending SIG[A-Z]* to process'` first.

**Report (as text; you may write the plan file):** the plan's path; playback in 3 plain lines; the ACs one line each (live
ones named); questions with ⭐; shared files and order; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is
normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
