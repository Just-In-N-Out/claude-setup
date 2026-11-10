# Role: planner: panel-embed-code (the panel's website route pastes only a widget's own code)

You are a fresh planner for FigmaToBricksV2 (**Opus 5.5, high**). Write an implementer-ready plan; change no source or
test, commit nothing, start no agents. Never edit the main folder's files or any worktree (read the repo with `git -C
/home/justin/Documents/FigmaToBricksV2 show <sha>:<path>` or plain reads; use `git archive` scratch copies under
`~/.cache/pec-p/` if you run anything). Never load bdryswi.com, B-Dry staging or any live site; no logins; never write
to any WordPress site. Nothing paid.

**Skills to load:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/live-site-reading.md`, the embeds lines, and `references/testing-pitfalls.md`), `engineering-best-practices`,
`implementation-planning`, `systematic-debugging` (prove the root cause with file:line evidence). Read the repo
`CLAUDE.md` ("Build general logic, never one-file fixes"; "Website captures"; web-embeds' line in Status) and
`docs/HANDOFF.md` (web-embeds and site-reviews sections).

## The report (the blind auditor of site-reviews, 2026-11-10; not yet a user request: Justin decides whether to build it)
Since site-reviews (merged on `main`, Build 2026-11-10.2 or the build commit on top of
`cd13abf38b5012df17ed7c12d075b98d9fbb4222`; check `git -C … rev-parse main`), a capture holds a new kind of embed: a
third-party widget whose loader draws it (`web.embeds[]` with `how: "slot"`, its own served markup kept apart as
`slot`, beside the older `snippet` that web-embeds rule 2 collects, which can include tags from elsewhere in the page:
inline scripts naming the widget's host, and for some kinds every script loading from it).
- **The code route** (`npm run site`, `src/core/site/`) pastes only the slot's own served markup, or the loader's own
  tag at its own place: nothing else of the page rides along (site-reviews' rule, proven).
- **The panel's website route** (the Figma panel's Convert on a capture: `src/plugin/capture.ts` → `convert`, built by
  web-embeds / web-panel) makes each embed a Code element holding rule 2's **whole snippet**. On the auditor's probe
  page (a widget in an unpainted slot, the same loader in a painted card beside an inline tracking call, the loader
  alone in a painted card, the widget host's tracking in `<head>`, beside the slot and at the end of `<body>`) that is
  8 `<script>` tags per paste, with the tracking account's init and three pixel loads in each of the two Code elements;
  main before site-reviews gave still copies with no scripts there. Receipts:
  `~/.hermes/plans/figma-to-bricks/evidence/site-reviews/auditor/` (`ac.json` found_else, `scripts/probe-site-index.html`,
  `supporting/`), and site-reviews' reviews (`review-1/review.json` R1-1/R1-2; fixer 1's follow-up "web-embeds'
  Figma/panel route still pastes its collected snippet to run").
- So a tracking pixel of the old site's vendor can run on the new Bricks site once code signatures are regenerated,
  through the panel route, for any widget whose host also has tracking tags on the page; and web-embeds' older embed
  kinds (`how: host`, `frame`, …) have pasted their collected snippet this way since Build 2026-11-03.2 (its Amendment 1
  on AC2 — "only JavaScript counts, an inline script only when it loads or calls the widget's host" — is the main
  session's ruling, not yet confirmed by Justin).

## What to plan
A general rule for the panel's website route, for **every** embed kind, not one widget: what a pasted Code element may
run is the widget's own code — its own served markup or its loader's own tag — never tags collected from elsewhere in
the page because they name the same host; when the capture can't tell (an older capture without `slot`; an embed kind
whose own code can't be separated), the safe output (a still copy, or today's behaviour only where it is proven to be
the widget's own code) with a note naming it. Work out from the code which embed kinds exist, what each pastes today on
both routes, and where one shared rule can serve both routes (the code route's `live.ts` logic reused, not duplicated).
Say plainly what changes for a paste made from an older capture, and what the panel shows the user.

## The plan must have
- Playback of the problem in plain numbered words; the root cause with file:line evidence; reproduce it yourself on the
  auditor's probe page or your own (a `git archive` copy of `main`; local fixture servers only).
- Questions at the top with ⭐ recommended answers (Justin's standing rule for this repo: he takes the planner's
  recommendation unless he changes it). At least: (Q1) older embed kinds — paste only proven-own code and copy the rest,
  or keep today's snippet with a note; (Q2) older captures without `slot`; (Q3) whether the panel should list what each
  Code element will run before Convert.
- **Numbered acceptance criteria AC1, AC2… marked (proposed), one test each, named, each test name whole on one line**;
  tag `(live)` right after the id for anything only Justin can check (a real panel Convert in Figma, a paste on
  staging). Include: no tracking tag in any pasted Code element on a probe page shaped like the auditor's; the widget
  still works where it worked; Figma designs and captures without embeds byte for byte as before
  (`test/unit/plugin-convert.test.ts`, `npm run corpus`, replays); the plugin sandbox rules (`npm run typecheck` with
  `tsconfig.sandbox.json`: code Figma runs uses only the language's built-ins).
- Ordered tasks a fresh builder with no context could follow (a consumer's guard before the producer's change where
  both exist), tests (RED on base, GREEN), risks, overlaps with the jobs still unmerged (site-slider, staging-fit-renderer,
  staging-fit-cancels, site-native-structure, site-menu: all touch `src/core/site/` or the capture; say which files).
- A recommendation: **Mini** or **Full** pipeline, with the reason.

## Output
Write the plan to `/home/justin/.hermes/plans/figma-to-bricks/panel-embed-code.md`. Run `ac-check.sh`'s `ac_start`,
`bad_id` and `live` regexes on it (from `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`)
and show the output; check each cited test name sits whole on one line.

## Report (as text)
The playback, the root cause, the questions with ⭐ answers, the ACs one line each (naming the `(live)` ones), Mini or
Full and why, overlaps; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never
edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
