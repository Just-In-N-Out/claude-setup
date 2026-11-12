# Role: planner (Mini, a bug): plugin-header-footer-ticks — unticked header and footer still reach the Figma paste

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. Never load any live site; no logins; never write to any WordPress site. Read-only on `~/Downloads`.

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`,
`systematic-debugging` (prove the root cause with evidence before any fix). Mini mode
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`): load the project skill and only the
code/docs sections this touches; finish within about 20 steps; if it's bigger or riskier, say so and recommend Full. Read the repo's
`CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.5, `11f07742`): the decision "The site's
own header and footer" (details in `~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md`), "Space
drawn next to a part the site already has stays (`designs.ts` `keepBeside`)", the header-tick known bugs line ("GRO's and
brainstorm's nav drawn inside the hero stays in the paste…"), and HANDOFF's sections on the header/footer ticks.

## What Justin reported (2026-11-11)
"there is also a bug in the figma to bricks plugin. When a user says to not include the header or the footer it is including it
in the paste please look into this." His answers: **Mini**; he unticked **both** header and footer and **both** were still in the
paste. (He may send a debug file and a screenshot of the panel later; plan without waiting.)

## The plan must settle (file:line evidence)
1. Root cause: follow the panel's header/footer ticks from the UI (`src/ui/…`) through the message to the plugin
   (`src/shared/messages.ts`, `src/plugin/convert.ts`) into the conversion (`ConvertOptions`, `designs.ts` / the understand stage's
   header/footer recognition) and emit. Reproduce on the corpus files (`corpus/files/*`, the repo's debug file) with `npm run replay`
   and the panel's own path (`test/fixtures/panel.ts`): with both ticks off, is the header/footer still emitted? When — a design
   whose header/footer isn't recognised as one (no named layer, a header inside the hero, a footer that's two sections), a tick
   that doesn't reach the conversion (a saved setting, a default, the message), a paste that comes from a cached earlier conversion,
   a "Copy" button that copies something else? Name the exact case(s) that leave both in.
2. The general fix for every design (CLAUDE.md "Build general logic"), and what the panel tells the person when it can't find a
   header or footer to leave out (a note, not a silent paste). Byte-for-byte for every paste where the ticks already work.
3. Numbered ACs, AC1, AC2…, each with one named test (each name whole on one line; a line that isn't an AC's definition never
   starts with a list marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin converts the same Figma page with
   both ticks off, pastes on darksalmon, and neither header nor footer is in it.

## Write
`~/.hermes/plans/figma-to-bricks/plugin-header-footer-ticks.md` (the builder copies it to
`docs/plans/2026-11-11-plugin-header-footer-ticks.md`): playback in 3 plain lines, questions at the top with ⭐ answers (Justin's
standing auto-go runs the builder at once on them), root cause, fix, ACs, touched files, tasks, a one-line Docs & records task.
Evidence under `~/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/planner/`. Overlaps to name: plugin-parity and
bricks-icons (Figma side; bricks-icons M1 is building now: `emit/elements.ts`, `understand/understand.ts`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/phf/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (`pgrep -f '[u]ser-data-dir=<path>'`).
One plain git command per call, `git -C <absolute path>`; write scripts with the Write tool. Use `tail -n 3`. Waits under 115 s.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending
SIG[A-Z]* to process'` first.

## Report (as text; you may write the plan file)
The plan's path; the playback; the root cause; the fix; the ACs one line each (the live one named); questions with ⭐;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
