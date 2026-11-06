# Brief: elementor-route — researcher (read-only, no building)

**Role:** researcher. You are a fresh Opus agent. You research and write a report; you build nothing, commit nothing,
and start no other agents.

**Skills to load first:** `engineering-best-practices` (research parts only), `implementation-planning` (for the
"first step" proposal with numbered ACs marked **proposed**).

## The question (Justin's words, summarised)
Justin wants to explore a different route for the website importer in `~/Documents/FigmaToBricksV2` (his
Figma→Bricks plugin, on the WSL desktop). Instead of capturing a live website by its URL, read the **Elementor pages
straight from WordPress** (B-Dry: bdryswi.com, WordPress.com + Elementor; he has the Elementor pages) and convert them
to Bricks with the plugin. He thinks this reproduces the page in Bricks more exactly than the URL route.

## Read first
- The repo's `CLAUDE.md` (Status; "Decisions the user made", especially "The website importer copies the site's own
  code" and "Website captures").
- `docs/HANDOFF.md`: sections web-capture, web-panel, web-address, web-tiers, web-embeds, web-human-check,
  web-human-reload, web-photo-crop, web-code-proof.
- The old URL route: `src/web/` (capture in Chrome) then `src/core/` (Figma converter). Method review:
  `~/.hermes/plans/figma-to-bricks/evidence/method-review/report.md` (found it right only at 1440).
- The code method (Build 2026-11-04.7): `npm run capture`, `npm run site` (`src/core/site/`), `npm run site:check`.
  Plan: `docs/plans/2026-11-04-web-code-proof.md`.
- Two stopped jobs: web-code-page (`~/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md`, branch
  `web-code-page-build`) and web-capture-steady (`evidence/web-capture-steady/plan-approved.md`, branch
  `web-capture-steady-build`). Look at how far each branch got (`git log main..<branch>`, read-only).
- Running log: `~/.hermes/plans/figma-to-bricks/away-2026-10-29-website-importer.md`. Memory note:
  `~/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/website-importer-paused.md`.
- Bricks samples and paste rules: `reference/bricks/` (README, samples). Bricks PHP source research is allowed (memory
  `bricks-source-research.md`: GPL Bricks on GitHub).

## Find out (answer each)
1. **What Elementor stores for a page and how to get it without breaking anything:** `_elementor_data` JSON (its
   shape: elements, elType, widgetType, settings, `_tablet`/`_mobile` suffixes, custom breakpoints), page settings
   (`_elementor_page_settings`), the global Kit (colours, fonts, breakpoints, `_elementor_page_settings` of the kit
   post), per-page CSS (`/wp-content/uploads/elementor/css/post-<id>.css`, `global.css`, kit CSS). Routes: WP REST
   with an Application Password (is `_elementor_data` exposed in `/wp/v2/pages?context=edit` meta? usually not
   registered — say what is true, from Elementor's source), Elementor's own template export (.json, what it holds),
   Elementor's REST/ajax endpoints, a WordPress export (WXR: does it carry postmeta `_elementor_data`? yes for
   Tools → Export), Elementor Kit export (.zip). **What WordPress.com allows** on which plan (Application Passwords,
   plugins, REST, Export, SFTP/database access on Business/Commerce). Use web search and Elementor's GitHub source.
2. **Mapping Elementor → Bricks:** containers (flexbox/grid), legacy sections/columns, heading, text-editor, image,
   button, icon, icon-list, image-carousel/slides, nav-menu, form (Pro), popup (Pro, a template), HTML widget,
   shortcode, Trustindex (third-party widget), plus spacer/divider/video/google_maps/accordion/tabs. For each: the
   Bricks element (from `reference/bricks/` samples where we have them; name the gaps), how each responsive setting
   (desktop/tablet/mobile and extra breakpoints) lands on Bricks' breakpoints (Elementor 1024/767 defaults vs Bricks
   991/767/478 — say what that mismatch means for 1:1), global colours/fonts → Bricks variables/classes, and what
   can't map (motion effects, sticky, custom CSS, dynamic tags, Pro-only widgets, third-party widgets).
3. **Compare** with our URL routes (old measured-box route and the code method) on: getting 1:1, editability in
   Bricks, effort, what of today's code carries over. Also compare to Bricks' own options: the **Bricks Migration
   Engine for Elementor** (what it is, who makes it, how it works, its known limits) and **Bricks 2.3's "HTML & CSS
   to Bricks"**. Research these on the web; say what is confirmed and what is a guess.
4. **Combine with the code method?** Elementor data for structure and widgets, captured CSS for exact looks. Say how
   the two would be joined (Elementor element ids `data-id` / `.elementor-element-<id>` in the rendered HTML match
   `_elementor_data` ids) and what that buys.
5. **Recommendation** in plain words, with one small first step that would prove it on one B-Dry section (with
   numbered ACs marked **proposed**, one test each), and a verdict per stopped job: resume, park or drop, with why.

## Hard rules
- **Never write to any WordPress site.** GET/read only. **Do not use any login or Application Password** — none is
  needed for research; if a step would need one, write it down as "needs Justin's login" instead.
- **Never load bdryswi.com** (any page or asset, any tool, curl included): it has a bot check and Justin must be
  present. Research public docs, Elementor/Bricks source and other public example sites only.
- Don't edit the repo, its CLAUDE.md, skills or memory. Never commit. Read-only `git` only.
- Desktop memory: a command that dies with SIGTERM/143/137/"Killed" may be earlyoom; check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` and say so. You shouldn't need heavy runs.

## Output
Write the report to `~/.hermes/plans/figma-to-bricks/evidence/elementor-route/report.md`, in plain words for Justin
(numbered steps, short sentences, no jargon without a one-line explanation). Mark every claim **confirmed** (with its
source link or file:line) or **unconfirmed**. Sections: 1–5 above, then "What needs Justin" (logins, exports,
decisions) as a numbered list.

Return: a short summary of the answer to each of 1–5, the report path, `verdict` (one line: possible / partly /
not possible) and `ac_status: n/a (research)`.

**skill_lessons rule:** list reusable lessons (a gotcha, an approach that worked after one failed, a skill step that
was wrong or missing) in `skill_lessons[{skill, lesson, evidence, enforce}]`; never edit skills or memory yourself.
`enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs) when the lesson is about
a rule broken or nearly broken. An empty list is normal. End your report with
`MAIN SESSION: check and save these skill_lessons now.`
