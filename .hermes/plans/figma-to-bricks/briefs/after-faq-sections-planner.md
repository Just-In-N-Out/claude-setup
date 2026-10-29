# Brief: PLANNER for figma-to-bricks feature "after-faq-sections" (Full pipeline)

You are the PLANNER for one job on the Figma → Bricks plugin: **three sections missing after the FAQ on the B-Dry Home
page**. Write a plan Justin will approve. Don't build anything. Don't start agents: the main session runs every role.
A separate job, `header-bar` (the B-Dry site's top navigation bar), is being planned by another planner: leave the
header out of this plan.

## Where
- Worktree (your copy, branch `worktree-after-faq-sections`, made from local `main` at a3a008e, build 2026-10-28.5):
  `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/after-faq-sections`. Work only there. Never edit the main
  folder `/home/justin/Documents/FigmaToBricksV2` or the `header-bar` worktree.
- Write the plan to `docs/plans/2026-10-29-after-faq-sections.md` in the worktree. Don't commit it (the builder does).
  Make no code or test change.
- Your own evidence and scratch: `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/planner/` (create it).
- Justin's screenshots (open each with Read), in `~/.hermes/plans/figma-to-bricks/evidence/after-faq-sections/screens/`:
  `3-real-after-faq.png` (the real page: the target) and `4-paste-after-faq.png` (ours).

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the
   PLANNER role (Full: its Step 1 context load). Read its `references/rules-summary.md` first, then only the sections of
   the worktree's `CLAUDE.md` you need (grep for headings, read with offset/limit, never the whole file). Always:
   "Status", "Build general logic", "Architecture rules", "Decisions the user made" (Interactions, Layout incl. the
   section rhythm, "The site's own header and footer", "Call and email links", "Links to pages", "Forms", "Website
   rules"), "Waiting on the user" (the Bricks samples line) and the lines about `reference/bricks/` samples.
2. `engineering-best-practices` (Skill tool).
3. `implementation-planning` (Skill tool).
4. `systematic-debugging` (Skill tool): this is a bug. Prove the root cause with file:line evidence before planning the
   fix.

## Background: the B-Dry copy
Justin is copying the home page of bdryswi.com (WordPress.com + Elementor) onto a new Bricks site,
`bdry.staging.growithgro.com` (Bricks; Home is page 14). Read the context note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md` first (media ids, the site's own
class names the paste must not reuse, the `home-` class prefix, the paste history v1 → v3).
- Read-only capture of the source page: `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`README.md`,
  `home.html` with Elementor CSS and popup templates, `tree-<width>.json` at 1440/1024/767/390 with each widget's
  `data-settings`, `body-*.png`, `s1440-*.png`).
- The current Home paste: `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v3/home-paste-v3.json` (233 elements)
  and its build scripts in `v3/scripts/` (`build-v3.ts`). v1 was built by hand from the source capture; v2 and v3 added
  the plugin's own output for the slider, flip boxes and photo dots.
- You may read both live sites over HTTP (`https://bdryswi.com/`, `https://bdry.staging.growithgro.com/`; add
  `?f2b=<random>` to get past any cache). Never log in, never change anything on either site.
- **No debug file** (Justin, 2026-10-29: "just do it without the debug and figure it out"): work from the staging
  site's live HTML, the source capture, the paste and its build scripts, and the plugin's code. Mark each root-cause
  claim that rests on inference rather than a replay as such, with its evidence.

## The ask
After the FAQ, the real page has three sections that our Home page lacks; they must come across, "with the animations
and everything". On ours (screenshot 4) the FAQ is followed directly by the site's own footer template (logo, Contact
Us, Visit Us with a map, Areas We Serve, "Powered by GRO"). That footer is the site's and is not part of the ask.
The missing sections, in order:
1. **"Schedule A Consultation" band:** dark blue over a faint photo, the line "Call Us Today For A No Cost, No Pressure
   Quote", and a white pill button "Get Your Free Quote".
2. **"Contact us today to get started":** a heading and a numbered 5-step list ("Contact Us: By Phone, Email, Or Contact
   Form." … "On Time, Every Time: Projects End When You Are Fully Satisfied.").
3. **"Customer Reviews":** a full-width blue band with the heading, then a reviews carousel: a summary card (logo,
   stars, "224 reviews", "Write a review") and Google/Facebook review cards with arrows. It's likely a third-party
   reviews widget: identify which one from `home.html`, and what a Bricks page can do with it. If bringing it over is a
   real choice (for example the same reviews plugin on the new site vs. cards built in Bricks), make it a question
   with ⭐.

Main session's quick check (verify): in `home-paste-v3.json`, "Schedule A Consultation", "Customer Reviews", "Get Your
Free Quote" and "On Time, Every Time" appear 0 times and "Contact us today" once (find out what that one is); the source
`home.html` has all of them. Justin believes "our plug-in didn't pull any of those". Find where they were lost (never in
the paste's input, dropped by the plugin, or left out of a paste build) and say so with evidence. Each section's
entrance animations are in its Elementor `data-settings` (the `tree-*.json` files). Say what "the animations" are for
each section and how the plan carries them, within the project's motion rules (CLAUDE.md "Only Figma's animations" and
the CTA rules).

## Must be general (CLAUDE.md "Build general logic, never one-file fixes")
Any plugin change recognises patterns from structure and properties, never from this site's names, words, colours or
pixel values. Think about the variations (pages whose last sections before the footer are bands, lists or carousels;
the footer tick on or off; drawn phone designs; GRO-style free-drawn pages). Native interactive elements (a carousel,
Slider Nestable, Tabs, Offcanvas) must be written only against canonical samples in `reference/bricks/`. If the sample
the plan needs isn't there, don't plan an emitter from memory: make it a question and give Justin plain, numbered steps
to copy that sample out of Bricks. Say clearly which part of the fix is the plugin's (general) and which is the B-Dry
paste (rebuilt from the plugin's own output, as v3 was), and put a question with ⭐ wherever that split is a real
choice.

## Checks on this machine (important)
This is the Linux desktop (WSL). `corpus/corpus.json` lists Mac paths, so `npm run corpus` finds no files here and
measures nothing, and `npm run check` silently skips corpus tests (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Plan checks on the
files that exist, via `npm run replay` / `npm run snap`, before vs after: `corpus/files/hydraulics-home.json`,
`corpus/files/gro-home.json`, the repo-root `figma-to-bricks-debug-page-1.json` and
`figma-to-bricks-debug-design-inspo-brainstorm.json`, with the ticks off and with header+footer ticked. Browser tests
need `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`; a browser run counts only when its output says
`skipped 0`, and the full suite has known font-environment failures: compare by test name against base a3a008e. Fixing
corpus.json is not part of this job: put it in `found_else` if needed.

## ACs
Justin gave no ACs: write your own, marked **proposed**, numbered AC1, AC2…, each with one named test, each whole on
one line (`ac-check.sh` matches test names line by line). Cover at least: each of the three sections is on the Home
page, in order, right after the FAQ, at 1440, 1024, 767 and 390; each has its entrance animation (and stands still for
reduced motion); the button and the reviews' links work; whatever plugin change is made leaves other designs'
pastes byte-identical (name which); lint no worse on every available file. Tag `(live)` right after the id any AC only
Justin can check (a paste into Bricks, a real phone), e.g. `- AC9 (proposed) (live): …`.

## Rules
- You can't ask Justin anything. Put the questions at the top of the plan, right after the title, each with 2–4
  lettered options under about 60 characters, the recommended one marked ⭐. Write the plan as if the ⭐ options were
  chosen: this project has a standing auto-go, so the builder starts right after the plan message.
- The `header-bar` job may also change the B-Dry paste and plugin code: say which files and paste parts this plan
  changes, so the two can be built one after the other without clashing. Other worktrees: `headline-marker` (open),
  `slider-autoplay`, `photo-hotspots`, `flip-cards`, `closing-cta` (merged into main).
- End the plan with a **Docs & records** task naming every file the build and finish will update (plan, ledger,
  HANDOFF, BUILD at merge, the main folder CLAUDE.md "Status" line, any new "Decisions the user made" line, the B-Dry
  memory note's paste status).
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, with
  evidence and severity) and in an "Other things found" section at the end of the plan.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong,
  missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence,
  enforce}]` and a "Skill lessons" section of your report. `enforce` is `none`, or, when the lesson is about a rule
  that was broken or nearly broken, a one-line proposal for a check that would have caught it (its kind: Claude Code
  hook, git hook, test, lint or script; what it checks; where it runs). An empty list is the normal answer: list only
  what a future task needs that the skill doesn't already say.
- Plain words: Justin reads short messages.

## Return (your final message)
A JSON-like report: `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}],
acs[], live_acs[], risks[], touches[], overlaps, found_else[], skill_lessons[]}` (only `plan_path` and `summary`
required). End it with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
"Here, as you can see, we have an issue. After the FAQ there are the Contact Us and review forms, with the animations
and everything. Our plug-in didn't pull any of those, so we need to fix that." (Screenshots 3 and 4.)
Then: "Whatever, just do it without the debug and figure it out."
Then: "No, don't do it in the same plan. Put it in another planner who's going to plan for it, and then we'll give it
to another builder and do the pipeline again. Full pipeline."
