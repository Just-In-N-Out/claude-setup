# PLANNER: personal-website, job "site-career-update"

Write a plan Justin will approve. Don't build anything: make no worktree, branch, code edit or commit.

**Pipeline:** Full (Justin picked it, 2026-11-21). After "go", a builder works test-first on its own branch off local `main`. Then come review→fix rounds until a review is clean, a verifier, and a blind AC auditor. **Nothing is pushed:** Justin views a local preview and says "push" himself. The site deploys to Vercel from `main` on GitHub.

## The request
Rewritten: update Justin's personal website so it shows everything from his last few months of work. A builder will loop through every page and section of the site so nothing is left stale. Three new items go in:
1. **Leorna: Software Engineer Intern, Aug 2026 – Dec 2026.** An AI startup, product pre-release. He built the integrations platform, release management, custom company domain, content library and CI gate, pack builder, admin console and control-plane APIs, security hardening, desktop client, usage analytics and onboarding.
2. **Gro: Web Infrastructure Developer, Aug 2026 – Dec 2026.** He built the FigmaToBricksV2 plugin (Figma → Bricks Builder/WordPress, plus a live-site importer) and used it to build 5 websites in 2 weeks.
3. **A multi-agent software delivery pipeline** (personal project, used in both roles): the pipeline, harness, hooks, agentic loops, model routing and cost work.

Lead with what he built and its impact, with numbers. Metrics and impact first, as in the profiles.

Justin's words: "Hey I need to update my personal website with everything we did. Run a agent keep looping through my website make suire it is updated with evetryhing you can pull my perosnal wevbsute on githuib"

**Source of truth for every fact and number:** the three profiles in `/home/justin/career/`: `leorna-work-profile.md`, `figma-to-bricks-profile.md` and `agentic-harness-profile.md`. Read all three, including each file's "Instructions for Claude", "To confirm with Justin" and honesty notes. Never invent or round a number, and never claim users, customers or "production" sites; he hasn't confirmed the 5 sites are live. **A fixer is correcting three overstated claims in the profiles right now.** Plan against the corrected wording:
- Gro's "121 failed checks caught after review" becomes "136 not accepted: 32 weak tests, 63 criteria false in a realistic case, 41 left pending".
- Leorna's "story cost −27%" ($206 → $150) is shown alongside about −4% against the full period before.
- Leorna's "cheapest model that held quality" becomes "kept every check in place".
The builder re-reads the profiles at build time.

**Public-safety level:** the site is public. Justin approved the Leorna product description at the level of the Leorna profile, the AI-authorship wording, and naming the cloud provider. Still no secrets, customer names, internal URLs, ticket IDs or teammates' names. The FigmaToBricksV2 repo is private, so link no repo unless Justin says so; that goes in the questions.

## The repo
- `/home/justin/JustinPersonalWebsite`, just cloned from GitHub `Just-In-N-Out/PersonalWebsite` (private, branch `main`, 33 commits, last 2026-06-11). Live at personal-website-gilt-five.vercel.app.
- Next.js 16.2, React 19, Tailwind 4, MDX via `next-mdx-remote` and `gray-matter`. The `content/`, `app/`, `components/` and `lib/` folders hold the site.
- Read its `CLAUDE.md` and `AGENTS.md` first. AGENTS.md says this Next.js version has breaking changes; read `node_modules/next/dist/docs/` before planning code changes. There are no tests yet, only `lint`. `node_modules` may need `npm ci`, which you may run.
- There is no project skill. Load `engineering-best-practices` and `implementation-planning`, plus `ux-frontend-workbench` or `frontend-design` if the design needs it.

## What the plan must have
- **The audit, first:** a list of every page and section of the site (home/hero, about, experience/timeline, projects, skills, resume/CV download if any, contact, metadata/SEO/OG text, footer), each marked current, stale or missing, with file:line evidence. Note anything stale beyond the three new items, such as a resume PDF, dates, "currently at" text or old skills.
- **Numbered ACs, AC1, AC2…, each proposed** (the request has none), one test each, named, with each AC on one line. Cover:
  - the three new items with their numbers and dates;
  - nothing stale left anywhere the audit found;
  - every number on the site traceable to a profile line;
  - no forbidden detail (confidentiality, "production", customers);
  - build and lint pass;
  - the layout works at phone and desktop widths, with no horizontal scroll.
  Each AC gets a screenshot, or a terminal capture when there is nothing visual. Choose the test approach yourself, e.g. a content test plus Playwright screenshots. Tag `(live)` only what Justin alone can check, such as the deployed Vercel page after his push.
- **Questions at the top**, after the title, each with 2–4 lettered options and your recommendation marked, written as if the recommendations were chosen. Likely questions: dollar figures or percentages only; link the private repos or not; whether the resume PDF changes, if the site has one; how much of the agentic pipeline to show; where it goes (projects vs experience).
- Tasks, the files touched, risks, and a closing **Docs & records** task.
- Save to `~/.hermes/plans/personal-website/site-career-update.md`.

## Rules
- **Found something else:** if you find another bug or problem, don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section of the plan. One known item: `CLAUDE.md` and `AGENTS.md` are tracked in this repo's git, against Justin's rule. List it; don't change it.
- **Skill lessons:** don't edit skills or memory. List reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]`. `enforce` is `none` or a one-line check proposal. An empty list is normal.
- **Memory on this desktop (earlyoom):** run any build or browser command under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Exit 137 or 143, or "Killed", may be an earlyoom kill; check `journalctl -u earlyoom --since "-30 min" -o short-iso | /usr/bin/grep -E 'sending SIG[A-Z]* to process'`.
- Grep here is ugrep and find is bfs: use `/usr/bin/grep` and `/usr/bin/find`.
- Plain words. You can't ask Justin anything; put questions in the plan.

## Report back
`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], found_else[], skill_lessons[]}`, then `verdict` and `ac_status` (`ac_status`: the number of ACs written). End with `MAIN SESSION: check and save these skill_lessons now.`
