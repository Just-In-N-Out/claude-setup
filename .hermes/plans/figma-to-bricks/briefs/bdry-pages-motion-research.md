# Role: researcher/planner (report only): does the website importer carry the animations on B-Dry's other pages?

You are a fresh planner-researcher for FigmaToBricksV2 (**Fable 5.2, high**). Research and report only: change no source or test, commit
nothing, start no agents, write no plan to build yet (a plan follows only if Justin asks after your report). Scratch under `~/.cache/bpm-rs/`.

## Justin's question (2026-11-13)
"Taking a look at other pages that bdry has, does our importer have the animations and all of them also?"

## What you may do on bdryswi.com (Justin's answer, 2026-11-13: "Read pages' HTML only")
**Plain read-only fetches** of `https://bdryswi.com/` pages: its sitemap(s) (`/sitemap.xml`, `/wp-sitemap.xml`, Yoast's `/sitemap_index.xml`) and
each page's HTML, plus the CSS/JS files a page links where you need to read an animation's definition. **No Chrome, no headless browser, no
clicks, no forms, no logins, no POST**, a plain `User-Agent` naming a generic client (never his name or email), at most one request a second,
at most ~150 requests in all. If the site refuses (its WordPress.com bot check), stop on that page, note it, and never try to get around it.
Never write to any site. Touch nothing under `~/Downloads` (his home scan: read-only copy
`~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/bdryswi-com-home.f2b-capture.json`).

## Do
1. List the site's pages (from the sitemaps), with each page's Elementor data: entrance animations (`data-settings` `_animation`,
   `animation`, `animation_delay`, `elementor-invisible`), Motion Effects (scrolling effects: translate, opacity, blur, rotate, scale; mouse
   track, 3D tilt; sticky), hover animations (`elementor-animation-*`), Lottie, background slideshows/videos, carousels and sliders, counters,
   progress bars, animated headlines, flip boxes, accordions/tabs/toggles, pop-ups, CSS `@keyframes` from the theme or plugins, and any
   other moving or interactive widget. Note the plugin behind each (Elementor, Elementor Pro, ElementsKit, others).
2. For each kind, say what the importer does today on `main` (Build 2026-11-12.3; read the code: `src/web/` capture, `src/core/site/`
   paste — site-motion (Build 2026-11-09.1: `@keyframes`, hover/focus looks, entrances through Bricks Interactions), site-slider, site-faq,
   site-menu, site-menu-motion, site-reviews/panel-embed-code, site-sticky-header; HANDOFF sections) and what the jobs in flight add
   (site-no-div, site-shared-styles, importer-parity, native-widgets plans in `~/.hermes/plans/figma-to-bricks/`): carried as on the site,
   carried differently (say how), or not carried. Back each verdict with code (file:line) or a fixture/test name; where only a real scan
   would tell, say so.
3. Rank the gaps by how many of B-Dry's pages use each and how visible it is, and for each gap say what a job would need (a Bricks
   element/Interaction, a capture change, a sample Justin must copy) — Bricks facts only from `reference/bricks/` or Bricks' GPL code
   (`saqib6571/bricksbuilder`, memory note `bricks-source-research.md`), never from memory. Keep to the standard at the top of CLAUDE.md's
   "Decisions the user made" (Bricks' own behaviour before Code).

Load `figma-to-bricks` (read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` directly; it isn't linked as a Skill) and
`engineering-best-practices`. If you need to figure something out, research it first; if nothing is found, give your best-reasoned answer and
mark it as such.

## Write
`~/.hermes/plans/figma-to-bricks/evidence/bdry-pages-motion/report.md`: a table of pages × kinds, the importer's verdict per kind (today /
after the jobs in flight), the ranked gaps with what each would need, every fetch refused. Raw fetches and notes beside it.

## Report (as text)
In plain words for Justin: what animates on his other pages, what the importer already carries, what it doesn't, and the jobs you'd
suggest (one line each, with ⭐ recommendations); `skill_lessons[]`, ending with: `MAIN SESSION: check and save these skill_lessons now.`
