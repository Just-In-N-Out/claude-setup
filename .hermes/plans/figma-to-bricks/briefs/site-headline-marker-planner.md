# Role: planner (Mini): site-headline-marker — a site's animated headline marker (circle around words) pastes drawing as on the site

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no
agents. **Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site. Read-only on
`~/Downloads` (Justin's 2026-11-11 scan: read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`).
Any test you run that captures the B-Dry stand-in or draws his scan runs only with no outside network (`unshare -rn sh -c 'ip link set lo up &&
exec unshare --user --map-user=1000 --map-group=1000 <cmd>'`). Plain `git`, each command alone (no `git -C` the main folder from a worktree;
no git piped into another command); scratch under `~/.cache/shm-pl/`. Background agents' Write refuses `.md` evidence files: write evidence
as `.txt`/`.json` (the plan itself is `.md` and must be written; if Write refuses it, write it with a short script file run as `bash <file>`).

Load `figma-to-bricks` (project skill, read directly: `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`),
`engineering-best-practices`, `implementation-planning`. Read the repo's `CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`),
above all **the standard at the top of "Decisions the user made"** (every paste, from both tools, built like a skilled Bricks builder made it by
hand; six points) and the memory note `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bricks-pro-standard.md`.
Your plan says, point by point, how its output meets that standard. Bricks shapes only from `reference/bricks/` samples or Bricks' GPL code
(memory note `bricks-source-research.md`), never from memory.

## What Justin asked (2026-11-14)
Research `~/.hermes/plans/figma-to-bricks/evidence/bdry-pages-motion/report.md` gap 4 (row 16; detail in `notes-home-detail.txt` line 21):
B-Dry's home headline "Over 60 Years Of Trusted Waterproofing And Foundation Repair" is Elementor Pro's Animated Headline
(`widget/animated-headline.default`, `headline_style: "highlight"`, `marker: "circle"`): an SVG circle is drawn around the highlighted
words as it comes into view (Elementor's stroke-dasharray draw, its loop/delay settings). The importer pastes it as a still copy. Justin: "start
it". **Mini pipeline** (website importer: one review, edge cases to follow-ups).

## The plan must settle
1. **A general rule, not B-Dry's:** every Elementor Animated Headline (highlight style: each `marker` shape Elementor ships — circle,
   curly, underline, double, double_underline, underline_zigzag, diagonal, strikethrough, x — and the rotating style: say what is in scope and
   what is named and left still); read Elementor Pro's GPL widget code for its markup, SVG paths, CSS and timing (`highlighted_text`,
   `loop`, `highlight_animation_duration`, `highlight_iteration_delay`, colours, stroke width, bring to front, rounded edges), and what the
   capture already holds (its `data-settings`, the drawn `<svg>` path). What the capture must add, if anything.
2. **Same shape in both tools:** the Figma plugin already has a headline marker (build 2026-10-30-ish "headline-marker", HANDOFF and
   `git log --grep headline-marker`): read how it pastes (element, class, keyframes, Interaction) and make the importer paste the same
   Bricks shape where it fits (CLAUDE.md: "both tools follow the same rules and make the same shapes"). Words stay in the Heading's text
   field (editable), the drawing in the most editable place a Bricks pro expects (an SVG the Icon/media library holds vs. inline markup vs.
   a pseudo-element; pick with evidence), the animation through Bricks' Interaction or CSS keyframes on a purpose-named class, no Code
   element; reduced motion shows the drawn marker still.
3. **Base and overlaps:** main is `fe29b65d` (Build 2026-11-14.4). In flight on the same importer code: importer-parity (rebasing now,
   `evidence/importer-parity/plan-approved.md`), site-sticky-cards, page-faq-slide, native-widgets, short-class-names, look-grouping
   (plans in `~/.hermes/plans/figma-to-bricks/evidence/<job>/plan-approved.md`). Name every shared file, what this job assumes from each,
   and the order (build after importer-parity merges if they meet).
4. **Proof:** a fixture site of each in-scope shape (generic, not B-Dry's words), drawn in Chrome on Bricks 2.4.2 and 2.3.9 JS + CSS: the
   marker drawn at 0/50/100 % of its time matches the site's, the words and their wrap as on the site at 1440/1024/768/390, reduced motion,
   the switch-off and every other paste byte for byte as before, Figma designs byte for byte.

If you need to figure something out, research it first; if nothing is found, give your best-reasoned answer as a ⭐ ruling.

## Also
Numbered ACs AC1, AC2… each with one named test (each name whole on one line; a line that isn't an AC's definition never starts with a list
marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin's own `site:import` of bdryswi.com's home pasted on B-Dry
staging, where the circle draws around "60 Years" as on the site and a Bricks pro can change the words and the marker's colour.

## Write
`~/.hermes/plans/figma-to-bricks/site-headline-marker.md` (the builder copies it to `docs/plans/<date>-site-headline-marker.md`): playback in
3 plain lines, questions at the top with ⭐ answers, the design, the standard point by point, ACs, touched files, tasks in milestones, overlaps
and order, a Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/site-headline-marker/planner/`.

## Report (as text)
The plan path; the questions with ⭐ answers; the ACs one line each; what you measured; `skill_lessons[{skill, lesson, evidence, enforce}]`
(never edit skills or memory; empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
