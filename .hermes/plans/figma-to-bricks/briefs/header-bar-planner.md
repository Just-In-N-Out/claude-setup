# Brief: PLANNER for figma-to-bricks feature "header-bar" (Full pipeline)

You are the PLANNER for one job on the Figma → Bricks plugin, in two parts: **Part A, the B-Dry header bar** (Justin's
first report), and **Part B, three sections missing after the FAQ** (his second report, folded into the same job).
Write a plan Justin will approve. Don't build anything. Don't start agents: the main session runs every role.

## Where
- Worktree (your copy, branch `worktree-header-bar`, made from local `main` at a3a008e, build 2026-10-28.5):
  `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/header-bar`. Work only there. Never edit the main folder
  `/home/justin/Documents/FigmaToBricksV2`.
- Write the plan to `docs/plans/2026-10-29-header-bar.md` in the worktree. Don't commit it (the builder does). Make no
  code or test change.
- Your own evidence and scratch: `~/.hermes/plans/figma-to-bricks/evidence/header-bar/planner/` (create it).
- Justin's screenshots (open each with Read), all in `~/.hermes/plans/figma-to-bricks/evidence/header-bar/screens/`:
  `1-real-bdryswi-header.png`, `2-plugin-paste-header.png`, `3-real-after-faq.png`, `4-paste-after-faq.png`.

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the
   PLANNER role (Full: its Step 1 context load). Read its `references/rules-summary.md` first, then only the sections of
   the worktree's `CLAUDE.md` you need (grep for headings, read with offset/limit, never the whole file). Always:
   "Status", "Build general logic", "Architecture rules", "Decisions the user made" (Interactions, Layout, "The site's
   own header and footer", "Call and email links", "Links to pages", "Website rules"), "Waiting on the user" (the Bricks
   samples line) and the lines about `reference/bricks/` samples.
2. `engineering-best-practices` (Skill tool).
3. `implementation-planning` (Skill tool).
4. `systematic-debugging` (Skill tool): both parts are bugs. Prove each root cause with file:line evidence before
   planning its fix.

## Background: the B-Dry copy
Justin is copying the home page of bdryswi.com (WordPress.com + Elementor) onto a new Bricks site,
`bdry.staging.growithgro.com` (Bricks; Home is page 14). Read the context note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md` first (media ids, the site's own
class names the paste must not reuse, the `home-` class prefix, the paste history v1 → v3).
- Read-only capture of the source page: `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/` (`README.md`,
  `home.html` with Elementor CSS and popup templates, `tree-<width>.json` at 1440/1024/767/390, `body-*.png`,
  `s1440-*.png`).
- The current Home paste: `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v3/home-paste-v3.json` (233 elements)
  and its build scripts in `v3/scripts/` (`build-v3.ts`). v1 was built by hand from the source capture; v2 and v3 added
  the plugin's own output for the slider, flip boxes and photo dots.
- You may read both live sites over HTTP (`https://bdryswi.com/`, `https://bdry.staging.growithgro.com/`; add
  `?f2b=<random>` to get past any cache). Never log in, never change anything on either site.

## Part A: the header bar (Justin's first report)
**The ask:** the B-Dry site's top navigation bar (not the hero under it) should look and work like the real site's.
Screenshot 1 is the real bdryswi.com header (the target), screenshot 2 the header on the staging site, which Justin
says he made by converting **a Figma frame with the plugin** and pasting the result. (The WordPress admin bar at the top
of shot 2 is only there because he's logged in: ignore it. The different hero photo under the bar is the hero slider on
another slide, not a defect.)

What the main session sees in the shots (both about 1920px wide; check, don't trust blindly):
1. **Bar shape and colour:** the real bar is slim (about 58px tall), with a left-to-right gradient from dark navy to
   bright blue. Ours is about 100px tall and one flat blue.
2. **Placement:** the real logo sits near the window's left edge (about 38px in) and "Get A Quote" plus the ☰ sit near
   its right edge; the phone line is centred. Ours keeps everything inside a centred page-width box: the logo starts
   about 425px in and the ☰ ends about 1477px. Our logo is also about twice as big.
3. **Button and ☰:** the real "Get A Quote" is small, in normal letters; ours is bigger, "GET A QUOTE" in spaced
   capitals (maybe the site's own button style: find out). The real ☰ is bigger, with thin orange lines; ours smaller.
4. **What clicks do (Justin asked for all three):** the logo goes to the home page; the phone number "(812) 436-2379"
   calls (a `tel:` link); the ☰ opens a menu that **slides down**. Find on the real page what that menu holds and how
   it opens (Elementor popup or nav; `home.html` holds the popup templates), and say what ours does today and why
   (for example, why the plugin's call-link rule didn't link this number, if it didn't).

**Debug file pending:** Justin has been asked to save the plugin's debug file of the Figma frame he converted (panel →
"Save debug file"). Until it arrives, work from the staging site's live HTML (what was pasted, its classes and settings),
the source capture and the plugin's code. When it arrives, the main session will send you its path: check its `build`
and root frame name, then `npm run replay` it and base the root cause on it. Don't hold the whole plan for it: finish
what you can and mark what still depends on the file.

## Part B: three sections missing after the FAQ (Justin's second report)
**The ask:** after the FAQ, the real page has three sections that our Home page lacks; they must come across, "with the
animations and everything". Screenshot 3 is the real page, screenshot 4 ours (on ours the FAQ is followed directly by
the site's own footer template: logo, Contact Us, Visit Us with a map, Areas We Serve, "Powered by GRO". That footer is
the site's and is not part of the ask).
The missing sections, in order:
1. **"Schedule A Consultation" band:** dark blue over a faint photo, the line "Call Us Today For A No Cost, No Pressure
   Quote", and a white pill button "Get Your Free Quote".
2. **"Contact us today to get started":** a heading and a numbered 5-step list ("Contact Us: By Phone, Email, Or Contact
   Form." … "On Time, Every Time: Projects End When You Are Fully Satisfied.").
3. **"Customer Reviews":** a full-width blue band with the heading, then a reviews carousel: a summary card (logo,
   stars, "224 reviews", "Write a review") and Google/Facebook review cards with arrows. It's likely a third-party
   reviews widget: identify which one from `home.html` and what a Bricks page can do with it.

Main session's quick check (verify): in `home-paste-v3.json`, "Schedule A Consultation", "Customer Reviews", "Get Your
Free Quote" and "On Time, Every Time" appear 0 times and "Contact us today" once (find out what that one is); the source
`home.html` has all of them. Find where they were lost (never in the paste's input, dropped by the plugin, or left out
of a paste build) and say so with evidence. Each section's entrance animations are in its Elementor `data-settings`
(the `tree-*.json` files).

## Must be general (CLAUDE.md "Build general logic, never one-file fixes")
Plugin changes recognise patterns from structure and properties, never from this site's names, words, colours or pixel
values. For each plugin change, think about the variations: header bars with or without a logo, phone, button or ☰;
bars drawn full-width vs inside a page-width frame; gradients vs flat fills; designs with the header tick on or off
(the plugin leaves a header out when the site has its own); drawn phone designs; GRO-style free-drawn pages. Native
interactive elements (a ☰ menu: Nav Nestable, Offcanvas, Toggle, Dropdown) must be written only against canonical
samples in `reference/bricks/`. If the sample the plan needs isn't there, don't plan an emitter from memory: make it a
question and give Justin plain, numbered steps to copy that sample out of Bricks. Say clearly which part of the fix is
the plugin's (general) and which is the B-Dry paste (rebuilt from the plugin's own output, as v3 was), and put a
question with ⭐ wherever that split is a real choice.

## Checks on this machine (important)
This is the Linux desktop (WSL). `corpus/corpus.json` lists Mac paths, so `npm run corpus` finds no files here and
measures nothing, and `npm run check` silently skips corpus tests (memory note
`~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/corpus-paths-on-desktop.md`). Plan checks on the
files that exist, via `npm run replay` / `npm run snap`, before vs after: `corpus/files/hydraulics-home.json`,
`corpus/files/gro-home.json`, the repo-root `figma-to-bricks-debug-page-1.json` and
`figma-to-bricks-debug-design-inspo-brainstorm.json`, plus Justin's B-Dry debug file once it arrives, with the ticks
off and with header+footer ticked. Browser tests need `export CHROME_PATH=$HOME/.cache/chrome-for-testing/chrome-f2b`;
a browser run counts only when its output says `skipped 0`, and the full suite has known font-environment failures:
compare by test name against base a3a008e. Fixing corpus.json is not part of this job: put it in `found_else` if needed.

## ACs
Justin gave no ACs: write your own, marked **proposed**, numbered AC1, AC2…, each with one named test, each whole on
one line (`ac-check.sh` matches test names line by line). Part A's ACs first, then Part B's. Cover at least, for Part A:
the bar's height, gradient and edge-to-edge placement at the real site's widths; logo and button size and the button's
letter case; the logo links to `/`; the phone number is a `tel:` link; the ☰ opens a menu that slides down (with
keyboard and phone taps) and closes; designs without a header bar give byte-identical pastes (name which). For
Part B: each of the three sections is in the paste, in order, after the FAQ, at 1440, 1024, 767 and 390, with its
entrance animation; lint no worse on every available file. Tag `(live)` right after the id any AC only Justin can check
(a paste into Bricks, a real phone), e.g. `- AC9 (proposed) (live): …`.

## Rules
- You can't ask Justin anything. Put the questions at the top of the plan, right after the title, each with 2–4
  lettered options under about 60 characters, the recommended one marked ⭐. Write the plan as if the ⭐ options were
  chosen: this project has a standing auto-go, so the builder starts right after the plan message.
- Each part gets its own root cause, tasks and checks. Keep Part A first everywhere.
- Say whether this job touches the same files as other open work (worktrees `headline-marker`, `slider-autoplay`,
  `photo-hotspots`, `flip-cards`, `closing-cta` exist; the last four are merged into main) so it can be built safely.
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
acs[], live_acs[], debug_file_dependent[], risks[], touches[], overlaps, found_else[], skill_lessons[]}` (only
`plan_path` and `summary` required). End it with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
First message: "We have a little issue between the bee, drag, copy, paste, and all. I'll send you some photos: the
first photo is what's on the actual page, which is what we want, and the second photo is what our copy‑paste with the
plug‑in shows."
Second: "Take a look at the header. For instance, in the first photo you can see how the buttons are placed. In the
second photo is what our plug in gets from utilizing it. You can see a big difference. Also, on the top left, when you
click the logo it takes you back to the home screen. When you click on the phone number you can call them. On the right
side, for the sidebar, it slides down. We need to implement all of these. Have a planar agent running all of these and
make sure you're orchestrating it properly." (Voice note: "bee, drag" = B-Dry, "planar" = planner, "sidebar" = the ☰
menu.) He chose the **Full** pipeline and said the header came from "Plugin, from a Figma frame".
Third: "Here, as you can see, we have an issue. After the FAQ there are the Contact Us and review forms, with the
animations and everything. Our plug-in didn't pull any of those, so we need to fix that."
