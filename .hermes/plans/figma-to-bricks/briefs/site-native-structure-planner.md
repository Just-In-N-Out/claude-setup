# Role: planner (Full pipeline): site-native-structure (website importer)

You are a fresh planner (Opus 5.5, high) for FigmaToBricksV2. Write an implementer-ready plan; change no source or test,
commit nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` (read it, or use your
own worktree). **Never load bdryswi.com** (bot check; Justin's own scan and the saved 2026-10-29 files are the site's
record). **Never write to any WordPress site; GET/read only; never log in.** Nothing paid.

**Skills:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/testing-pitfalls.md`, `references/live-site-reading.md`, `references/rendering-validation.md`),
`engineering-best-practices`, `implementation-planning`, `systematic-debugging` (prove each cause with file:line
evidence). Read the repo `CLAUDE.md` ("Build general logic": nothing keyed on B-Dry; "Bricks element shapes come from
`reference/bricks/*.json`" — never write a native emitter from memory; "The renderer only approximates Bricks. The live page
is the final judge") and `reference/bricks/README.md`.

## Context (Justin, 2026-11-09)
Justin captured bdryswi.com (`/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`, build 2026-11-09.1, 48 widths)
and pasted the importer's whole page (`--elementor`, build 2026-11-09.3: `/home/justin/f2b-test/paste-el3/whole.json`,
`notes.txt` beside it) onto **`https://bdry.staging.growithgro.com/homev2/`** (public; read it as a logged-out visitor,
add `?f2b=<random>` to pass LiteSpeed). He listed what's wrong; each problem is its own job, planned in parallel by its own
planner: staging-fit (tablet/phone widths, the core, planned by another agent whose measurements are in
`~/.hermes/plans/figma-to-bricks/evidence/staging-fit/planner/` — reuse them, read only), site-menu, site-slider,
site-reviews, site-faq and site-native-structure. His goal: "paste once, neat at every size, everything works";
"whatever else you find, obviously fix it". Screenshots are in
`/tmp/claude-1000/-home-justin-Documents-FigmaToBricksV2/a492f614-99ad-4c9d-89a6-3356eed047b1/images/`.

## Your job: site-native-structure
- **The problem:** Bricks' Structure panel shows the pasted page as bare "Div, Div, Div" (images/11.png). Justin: "I want the structure to work like the plug-in when we copy it from Figma to Bricks — how the buttons are laid out, the area stuff we did. I don't want it to be all div div div."
- **The general rule to plan:** the importer's paste has the Figma route's editable structure (repo CLAUDE.md "Output style (2026-10-06): editable structure first", `ExampleBricks`): Section > Container > Block per page section, Heading with its tag, Rich Text, native Button (with icon), Image, Icon, Divider, Nestables, classes named by purpose, a shallow tree, Bricks controls over custom CSS where a control exists — while still looking like the site. Read how the code method builds elements today (src/core/site/, elementor-map's fold) against the Figma route's emit (src/core/emit/), and ask what it means for the "within 2 px" promise as a question with a ⭐ answer.
- Work from main `fd1986dcdbc8cf35f114b80be456e94279346743` (Build 2026-11-09.3). Note every overlap with the other five
  jobs (files, rules, the order to merge) so they can be built side by side; the native-structure job may change what
  element types the others emit — say how your job should look either way.

## Plan
Write `~/.hermes/plans/figma-to-bricks/site-native-structure.md` (evidence in `~/.hermes/plans/figma-to-bricks/evidence/site-native-structure/planner/`):
playback; what the site does (from the capture and the saved files) and what the paste does (our renderer and the real
staging page), with proof; root cause with file:line; the general rule; numbered ACs **AC1, AC2…** marked **(proposed)**,
one named test each (a generic fixture RED on main; B-Dry named-only on the saved capture; the plain route and Figma
designs byte-identical unless the rule must change them — say so); `(live)` for Justin's re-paste on staging; tasks
test-first; questions at the top with a ⭐ answer each (the standing auto-go takes them); any Bricks sample you need that
`reference/bricks/` lacks (Justin copies it from his Bricks).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-p/tmp`,
  its own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Several agents run
  Chrome now: close every Chrome you start. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. One
  `bash <file>` per Bash call (scripts written with Write).
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso |
  grep sending`) or a scope oom-kill (`journalctl --user`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G
  -p MemorySwapMax=0 <cmd>` (B-Dry renders 8G). Waits under 115 s.

## Report (as text)
The plan path, the cause in two lines with its proof, the ACs one line each (mark live ones), the questions with ⭐
answers, overlaps with the other jobs, any Bricks sample needed, then `skill_lessons[{skill, lesson, evidence, enforce}]`
(reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
