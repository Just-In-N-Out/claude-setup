# landing-page-loop — Full pipeline planner

## Role and ownership

You are the fresh PLANNER. Investigate and write an implementer-ready plan; do not implement fixes or launch other agents. Own the plan and your planning evidence only. You are not alone in this repo: preserve other sessions' work and do not edit the main folder. Work in `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/landing-page-loop`, branch `worktree-landing-page-loop`, from local main base `c67128c4cca8eff67afdf3f7e6e8b28a75294deb`.

Read this worktree's CLAUDE.md and global rules. Load project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, `engineering-best-practices`, `implementation-planning`, and `systematic-debugging`; announce them. Resolve linked skills via `/home/justin/.agents/skills/<name>/SKILL.md`. Apply user/project instructions over skill defaults. Do not edit skills or memory.

## User request, rewritten

Audit and improve the plugin's conversion of the complete DJ Tree Service Organic Concept 04 landing page. Compare its real Figma drawing and snapshot with the current live Bricks page and fresh plugin output. Check all text (words, family, actual loaded font, weight, size, line height, spacing and wrapping), photos/art (correct image, ratio/crop, dimensions, start/end positions), section boundaries/spacing/alignment, responsive behavior, links and interactions/animations. Iterate through confirmed plugin problems, implementing general structural rules that benefit other files. Desktop follows the drawing subject to standing user rules; tablet/phone versions follow existing responsive rules because only a desktop drawing is provided. Cover desktop and smaller/wider desktops, tablets, landscape phones, portrait phones and breakpoint transitions. Do not treat the animation survey as the full audit.

The user specifically added the testimonial section's pagination marks as an intended swipeable review slider. Recognise likely interaction intent from visible structure even when reactions are empty. Existing snapshot has one placeholder review, a selected bar and two dots. Investigate a general way to represent that intent in native editable Bricks structure; explicitly resolve the missing additional slide content in proposed questions/ACs. Do not fabricate actual customer reviews or silently omit the requested slider. Do not invent autoplay/timing or unrelated decorative motion from static art.

Identify all confirmed differences and their causes; distinguish intended standing-rule differences, site/theme effects, unsupported samples, and actual plugin defects. Reproduce suspected plugin defects through the plugin first. Do not patch one paste, hardcode the page's names/ids/colors/strings/dimensions, or change unrelated project decisions. No Figma or WordPress writes/publishing are authorised here; live page is read-only. The project's usual local merge/build/main push is authorised after review/acceptance.

## Justin's words

### Added while planning — header/footer and sticky navigation

Justin explicitly added this to the same job while you were planning. Include it in the plan, tasks and numbered ACs: identify the site's navigation header and footer; make the navigation header stay with the user while scrolling; make applicable header links available and functional. The header here is the top navigation bar (logo/menu/CTA), not the hero's text/photos. Verify both header/footer ticks and the retained-header/footer behavior under current rules, so omission does not leave duplicates or lost page content. Cover sticky behavior and header links responsively, consistent with existing rules and samples; identify any genuine product decision with a recommended answer rather than silently dropping the request. Treat logo/home, navigation and contact/CTA link cases according to the established general link rules, deriving targets from available Figma/site information. Do not assume a new native mobile menu shape without the required reference sample.

Original addition: "Crap, I forgot if you can tell the planner one thing: it should identify the header and the footer. It should also make the header scroll with me, and the header should have a hyperlink available. Also that stuff, yeah. That's the call."

"is there a way I can show you the figma page and the live page and you can keep looping updating the plugin so that it adds general rules that also help with building the figma page?"

"there is also this animation that the plugin needs to identify for the reviewers swipping as you can see on the bottomn"

"Well, you should be able to figure it out and have identified the animation. Are there any other animations you can look up, or anything I can give you in Figma to help identify them?"

"Okay, I'm sure you're gonna double-check the fonts and sizes, make sure the text is right, the images are correct, the image sizes are right, and they're ending and starting where they should for desktop. You'll keep iterating for mobile, landscape, and mobile display, and for tablet and mobile landscape, correct?"

"Okay, great. Then let's do it. Let's run it."

The main chat recommended Full for this scope and Justin said to run it. Standing auto-go applies: provide questions with recommended/starred answers so the builder can start after the plan is shown unless Justin changes them. Explicitly list any decision that cannot reasonably use a recommendation or requires missing user material.

## Inputs and prior read-only observations

Evidence root: `/home/justin/.hermes/plans/figma-to-bricks/evidence/landing-page-loop`.

- Immutable snapshot: `<evidence>/inputs/figma-debug.json`. Original Desktop file: `/mnt/c/Users/Admin/Desktop/figma-to-bricks-debug-landing-page-loop.json`. Build 2026-10-30.20; root `DJ Tree Service — Services Landing Page | Organic Concept 04`, id 84:46, 390 layers. Inputs are copied into Linux; do all work under /home/justin or owned scratch, not /mnt/c.
- User's exported full-page Figma PNG: `<evidence>/inputs/figma-full-page.png`, original 1440 × 11457. Inspect in readable section crops/bands, not just a downscaled tall thumbnail. This is the intended visual source.
- User's testimonial screenshot: `<evidence>/inputs/review-slider-request.png`. Cream panel, one placeholder quote/name, a selected short green bar followed by two dots; placeholder chip to their right. User identified this as a slider intent.
- Live page: `https://djtreeservice.staging.growithgro.com/dj-tree-service-services-landing-page-organic-concept-04/?bricks_preview=1793399249`; ordinary published URL works too. Cache-bust with `f2b=<fresh value>`. HTTP read and headless Chrome work. No admin account needed for reading. No direct Figma connector is available.
- Prior browser survey: `<evidence>/initial-live-survey/` with scripts, inventory.json, observations.json, phone.json, final-check.json and PNGs. Scripts contain old /tmp output paths; use your own output paths. Treat these as leads, independently validate findings relevant to your plan. Confirmed there: live fades actually play (including lower items on entering view), CTA hover moves 3px, tested hero image scales to 1.1 over 0.5s, phone-only hero photo slider changes with real touch swipe and dot taps. Review pager is plain divs; clicking second dot leaves review unchanged. No glare sweep was observed on tested hero image. These observations do not establish complete layout correctness.
- Snapshot contains no applied reactions, animations or animationStyles on the 390 nodes; seven built-in motion presets exist with no assignments. It has no instances/components/sets/targets. Empty metadata is not proof of no intended interaction; distinguish inference from observed/recorded effects.
- Relevant project memory: `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/`, especially plugin-first.md, corpus-paths-on-desktop.md, reading-the-live-site.md, user-workflow.md, run-without-stopping.md. Other contextual files through the project skill.

## Plan and proof requirements

Write `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/landing-page-loop/docs/plans/2026-10-30-landing-page-loop.md`.

Include playback, questions at top with recommended choices, evidence-backed root causes with file:line citations for each confirmed bug, scope inventory covering all requested visual categories/sections, concrete implementation tasks, numbered AC1, AC2… (proposed, since user gave no numbered ACs), and one named test per AC kept on one line. Identify preserve-behavior ACs for base exemptions. Only genuinely user-only checks get `(live)` immediately after the id (fresh Figma plugin/Bricks paste, native platform checks). Do not weaken implementable checks into live ACs. State automated local versus actual Bricks verification limits clearly. Do not add a literal requirement inconsistent with the measured baseline or approved responsive rules.

Plan tests/fixtures generically across shape/nesting/breakpoint variants and existing other-page regressions. Use canonical Bricks samples already in reference/bricks; if a new native shape lacks a sample, identify the precise gap, do not invent it. Include complete check/browser/corpus gates, before/after images, real-file replay and all widths needed by the approved ACs. Builder will record ledger in `.superpowers/sdd/<plan>/progress.md`, commit passing tasks, and run corpus at baseline and close. No BUILD bump in worktree.

The full pipeline uses two fresh full reviews, fix/re-review as needed, fresh verifier then blind AC auditor. AC proof rules are in `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`. Keep ACs realistically provable and cover every requested category even where the result is preservation. No arbitrary reduction of this whole-page scope to just the easy findings.

## Environment and shared-state constraints

`node_modules` is linked from main; do not modify shared dependencies. `.worktreeinclude` rules have been copied/linked where available. Main is clean at base, but can advance from other sessions. No bare stash, destructive reset, hook bypass, author override or AI trailers. Never stage CLAUDE.md. If committing plan, load git-commit-rules and check staged names/identity before commit.

Read corpus-paths-on-desktop.md: Mac absolute corpus paths do not resolve here and can silently skip; use actual available Linux files and compare base/head fairly. Available Chrome wrapper `/home/justin/.cache/chrome-for-testing/chrome-f2b`; Node `/home/justin/.local/node-v22.23.3/bin/node`. Current proven browsing wrapper invokes `env -u DISPLAY -u WAYLAND_DISPLAY` and Chrome with `--no-sandbox --disable-software-rasterizer`. Make your own wrapper/output directory. Do not mistake skipped browser cases for passing proof.

Use an owned role scratch directory. `/tmp` is shared, limited RAM; avoid large browser/test outputs there. Store sizable evidence under your own `<evidence>/planner/` subfolder. Never remove another role/session's files. Setup sync pull was attempted with required escalation but failed because `/home/justin/.claude-setup.git` is mounted read-only. No conflict was reported. Use local skills and note that cross-machine sync remains unavailable; don't bypass permissions.

## Return

Return status, plan path, concise findings, proposed ACs, recommended decisions, required user-only items, and any blocker. Include `skill_lessons: [{skill, lesson, evidence, enforce}]` (empty is normal; enforce is `none` or a concrete hook/test/lint/script proposal). Do not edit skill/memory yourself. End with `MAIN SESSION: check and save these skill_lessons now.`
