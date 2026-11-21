# site-career-update: put the last months of work on the personal website

Plan for the personal website (`/home/justin/JustinPersonalWebsite`, branch `main`, base commit `37b40d5`). Written 2026-11-21 by the planner. Nothing is built yet. Nothing in this job is pushed: Justin views a local preview and says "push" himself.

## Questions for Justin

The plan below is written as if every **recommended** option was chosen. "go" approves them, and the proposed ACs, together.

1. **What should the site lead with?**
   - **A (recommended):** keep the headline "Security engineer. Full-stack capable." and the page title. Refresh the line under it, add a row of 3 numbers under the buttons, and widen the contact line to "software, security and AI engineering roles".
   - B: leave the hero and the contact line as they are; only add the three items lower down.
   - C: change the headline to lead with AI-agent engineering.
2. **Dollar figures or percentages only?**
   - **A (recommended):** percentages only, and the cost result always with both baselines (−27% and about −4%). No "$" on the site.
   - B: show dollars, each labelled "API-price equivalent".
3. **Link the private repositories?**
   - **A (recommended):** no repository link on the Leorna entry, the Gro entry or the pipeline card. All three are private.
   - B: link the FigmaToBricksV2 repository anyway (visitors get a 404 while it is private).
   - C: no links now; a public write-up or demo later, as its own job.
4. **How much of the pipeline to show, and where?**
   - **A (recommended):** one full card, first in Projects under a new "AI Engineering" heading, 10 lines: the pipeline, the review loop, the two proofs, the gates, the hooks, the loop brakes, the cost routing and the memory incident.
   - B: a short card with 4 lines.
   - C: an entry in Experience instead of Projects.
5. **Education sentence in About.** It still says "Finishing my B.S. … and starting Georgia Tech's M.S. … in Fall 2026", which is out of date in November 2026.
   - **A (recommended):** remove that sentence. The two cards right under it already show both degrees and their dates, so no new fact is stated.
   - B: replace it with "I hold a B.S. … and am studying for the M.S. …" (choosing this confirms both facts).
   - C: keep it as it is.
6. **Lint.** `npm run lint` already fails on `main` with 7 errors in the blog and navbar files, none from this job.
   - **A (recommended):** this job adds no new lint error; the 7 old ones stay and become their own small job.
   - B: fix the 7 here too (touches the navbars and blog pages).
7. **Model names.** The pipeline profile leaves open whether "Fable 5.2" and "Opus 5.5" may be printed.
   - **A (recommended):** say "the larger model" and never print a model name.
   - B: print the names.
8. **Resume PDF.** The site has no resume or CV file and no link to one.
   - **A (recommended):** add nothing.
   - B: add a "Resume" link (you supply the PDF; a small follow-up).
9. **Gro's browser-test count.** The profile says 628 real-browser tests, of which 603 passed in the last full run, and leaves the reason open.
   - **A (recommended):** show the unit tests only (4,218 with 0 failing).
   - B: also show "628 real-browser tests".

## Playback

Update the personal website so it shows the work of the last months, with what was built and its impact first, in numbers. Three items go in: the Leorna internship, the Gro role (the FigmaToBricksV2 tools), and the multi-agent delivery pipeline. Every page and section is checked so nothing stale is left. Every fact and number comes from the three profiles in `/home/justin/career/`, as corrected on 2026-11-21 18:05.

## Acceptance criteria (all proposed)

The request states no ACs, so these are proposed. Each has one named test in its own file under `tests/`.

- AC1 (proposed): the Experience section's first entry is Leorna: "Software Engineer Intern", "Aug 2026 – Dec 2026", "pre-release", the wording "multi-agent AI pipeline I designed and operate", all ten feature areas, and the numbers 33 stories, 39 merged pull requests and 906 test functions. Test: `AC1 leorna entry shows role dates ten feature areas and numbers`
- AC2 (proposed): the second entry is Gro: "Web Infrastructure Developer", "Aug 2026 – Dec 2026", the Figma plugin and the live-site importer, "5 websites in 2 weeks", "under 3 seconds", "33–35 minutes to 3.4–3.7 minutes", "75 to 6", the wording "Built by directing a multi-agent pipeline I designed", and the sites are only ever "built". Test: `AC2 gro entry shows role dates tools and numbers`
- AC3 (proposed): Projects opens with an "AI Engineering" group holding the pipeline card: 7 roles, 1,814 agents, 113 stories, 26 days, 472 reviews, 355 P1/P2 defects, 1,211 criteria, 45 refused by the blind auditor, the gates, the hooks, the loop brakes, the routing and the memory incident, with no link. Test: `AC3 pipeline project card shows roles loops gates and numbers`
- AC4 (proposed): the story-cost result is on the page, and wherever "27%" appears the same sentence also gives "about 4%" and names both baselines; the page shows no "$". Test: `AC4 cost claim carries both baselines and no dollar figure`
- AC5 (proposed): the Leorna and Gro entries carry no pipeline-run numbers; no project's share of a pipeline total appears anywhere; "136" appears only in the pipeline card with its split 32, 63 and 41; "121" appears nowhere. Test: `AC5 pipeline totals stay out of the job entries`
- AC6 (proposed): the hero line and its 3-number row, and the About paragraph, name the new work; About no longer says "Finishing my B.S." or "starting Georgia Tech". Test: `AC6 hero and about are current`
- AC7 (proposed): Skills has an "AI & Agents" group and the new skills from the profiles (Go, OpenAPI, ClickHouse, MCP, Claude Code, WordPress, Bricks Builder and the rest of the list in this plan), and all five groups are visible after scrolling. Test: `AC7 skills list the new work and every group is visible`
- AC8 (proposed): the contact line reads "Open to software, security and AI engineering roles — full-time or internship." and the page description and its Open Graph copy name Leorna, Gro and the pipeline. Test: `AC8 contact line and page metadata are current`
- AC9 (proposed): every number on the home page and in its metadata is either copy unchanged from the base commit or listed in a ledger with a quote that is found word for word in a profile and contains that number; the ledger has no entry that is not on the page. Test: `AC9 every number on the page traces to a profile line or to unchanged older copy`
- AC10 (proposed): the home page, its metadata and the ledger hold no forbidden detail: no "production", customers, users, launch or traffic claim; no model name; no ticket ID, PR number, internal address or file path; no teammate's name; no link outside the allowed list, and no link at all in the three new items. Test: `AC10 page and ledger hold no forbidden detail`
- AC11 (proposed): at 320×568, 375×667, 390×844, 768×1024, 1280×800, 1440×900 and 1440×2560 the home page has no sideways scroll, no element past the screen edge, and every section and every item in it becomes visible after scrolling. Test: `AC11 layout fits seven screen sizes with nothing hidden`
- AC12 (proposed): `npm ci` installs from the lock file, `npm run build` passes, and lint reports no error beyond the 7 that `main` already has. Test: `AC12 clean install build and lint baseline hold`
- AC13 (proposed) (live): after Justin says "push" and Vercel deploys, personal-website-gilt-five.vercel.app shows the Leorna entry, the Gro entry and the pipeline card. Only Justin can check this.

Each AC gets a screenshot. Visual ACs: the section at 375 and 1280 wide. The traceability, forbidden-detail and build ACs have nothing to see, so they get a terminal capture of the run.

## The audit: every page and section

Base commit `37b40d5` (2026-06-11). Pages: `/` (one page with all sections), `/blog`, `/blog/vercel-breach-response`.

| Section | State | Evidence | What this job does |
|---|---|---|---|
| Hero | Stale | `components/Hero.tsx:25-26`: "Backend architecture, agentic AI security, and LLM pipeline hardening." says nothing of the new work | New line, plus a 3-number row (question 1) |
| Hero label | Current | `components/Hero.tsx:9`: "Software Engineer · ASU '26" | Unchanged |
| About paragraph | Stale | `components/About.tsx:24-31`: "builds production systems", "Finishing my B.S. … and starting Georgia Tech's M.S. … in Fall 2026", and only the older work | Rewritten |
| About education cards | Current | `components/About.tsx:53` "May 2026", `:75` "2026 - 2028" | Unchanged |
| Experience | Missing | `components/Experience.tsx:5-34` holds one entry, LinkClicks, as a single object with a required live link and GitHub link | Becomes a list: Leorna, Gro, LinkClicks |
| Experience: LinkClicks | Current (a past role) | `components/Experience.tsx:9`: "Aug 2025 – May 2026" | Text unchanged, now third |
| Projects | Missing | `components/Projects.tsx:6-60`: DevSecOps Pipeline, LLM Vulnerability Scanner, MinimaLog; no pipeline | New first group "AI Engineering" with the pipeline card |
| Project card | Blocks the change | `components/ProjectCard.tsx:9`: `githubUrl` is required | Made optional |
| Skills | Stale | `components/Skills.tsx:5-82`: 4 groups, no Go, ClickHouse, OpenAPI, MCP, WordPress or agent skills | 5 groups, new skills added |
| Blog preview and blog pages | Current | one post, 2026-04-19 | Unchanged (a date bug is in "Other things found") |
| Contact | Stale | `components/Contact.tsx:74-76`: "Open to security engineering and AppSec roles" | Widened (question 1) |
| Page title | Current | `app/layout.tsx:16` | Unchanged |
| Page description | Stale | `app/layout.tsx:17-18`: "Building production systems — Django + Celery platforms…" | Rewritten |
| Open Graph text | Missing | `app/layout.tsx:15-20` has no `openGraph` | Added, same title and description |
| Resume or CV | Missing | `public/` holds only two logos and `robots.txt`; no link on any page | Nothing added (question 8) |
| Navbar | Current | `components/Navbar.tsx:5-12` already lists Experience and Blog | Unchanged |
| Footer | Current | `components/Footer.tsx:4`: "Justin © 2026" | Unchanged |

Two layout traps the new content would hit, both proven on a scratch copy of the base:

- **A fifth item in a staggered group never shows.** `app/globals.css:65-68` reveals only children 1 to 4. With a fifth Skills group added, that group stays at opacity 0 at 375 and 1280 wide (`evidence/site-career-update/planner/trap-5th-skill-group-375.png`).
- **A tall section never fades in on a short screen.** `hooks/useFadeIn.ts:5` waits until 15% of the section is on screen. With 25 bullets in Experience the section is 3,971 px tall at 320×568 and stays at opacity 0 (`planner/tall-section-probe.log`). The real copy has 25 bullets too.

## Rules for every word of copy

The builder re-reads all three profiles first, including each file's instructions, "To confirm with Justin" and honesty notes. If a profile's number differs from this plan, the profile wins and the builder reports the difference.

1. Only numbers written in a profile, as written. No rounding beyond what a profile sentence itself does ("32,000+").
2. Leorna is "pre-release". Never users, customers, traffic, revenue or "production".
3. Gro's 5 websites were "built". Never "launched", "live" or "in production". Features are "merged to main". No CI/CD claim. No time saved per page.
4. Authorship: Leorna "delivered through a multi-agent AI pipeline I designed and operate"; Gro "Built by directing a multi-agent pipeline I designed". Verbs: designed, built, delivered, specified, ran. Never "hand-wrote", and "wrote" is not used for harness code.
5. **Never count a number twice.** The job entries carry product numbers only. Pipeline totals (1,814 agents, 472 reviews, 355 defects, 1,211 criteria, 6,041 checks) appear only in the pipeline card, and 1,814 once more in the hero row.
6. **121 and 136.** 121 is Gro's own project (17 weak tests, 63 criteria false in a realistic case, 41 left pending). 136 is the all-project total (32, 63, 41). The site shows only the 136, in the pipeline card, with its split. It never shows 121, and never labels 136 as Gro's.
7. **−27% never alone.** It is measured against the 2 days the larger model ran in several roles; the same sentence gives about −4% against the 45 stories before it.
8. No dollars and no model names (questions 2 and 7).
9. Open in the profiles, so not on the site: team-share percentages, cards completed, team size, the pipeline's start date, the label "personal project", whether the dream pass runs, whether the freezes stopped, Gro's browser-test count, who uses the Gro tools.
10. No secrets, customer names, internal addresses, ticket IDs, PR numbers, file paths or teammates' names. Naming Scaleway is approved.
11. No location is shown for Leorna or Gro: the profiles give none.

## The copy

Source marks: **L** = `leorna-work-profile.md`, **G** = `figma-to-bricks-profile.md`, **H** = `agentic-harness-profile.md`; "bank n" is that file's resume bullet n.

### Hero (`components/Hero.tsx`)

Line under the headline: "Backend architecture, application security and multi-agent AI engineering. Building systems designed to resist attack."

A row of 3 numbers under the buttons, marked `data-entry="hero-stats"`:

| Number | Label | Source |
|---|---|---|
| 39 of 39 | pull requests merged at Leorna | L bank 1 |
| 5 websites | built in 2 weeks with tools I built at Gro | G bank 1 |
| 1,814 agents | run in 26 days through a pipeline I designed | H bank 1 |

### About (`components/About.tsx`)

"I'm a full-stack engineer who builds systems with security designed in from day one, and I now deliver them through a multi-agent AI pipeline I designed and operate. As a Software Engineer Intern at Leorna, an AI startup with a pre-release product, I delivered 33 user stories through 39 merged pull requests across a Go control plane and a Windows desktop client. As Web Infrastructure Developer at Gro, I built a Figma-to-WordPress plugin and a live-site importer that were used to build 5 websites in 2 weeks. Before that I shipped a Django + Celery platform aggregating 5 third-party APIs, a reusable DevSecOps pipeline emitting SARIF to GitHub Security, and a live iOS app with row-level security and end-to-end encryption."

(L bank 1; G bank 1; the last sentence is the base's own.)

### Experience entry 1: Leorna (`data-entry="leorna"`)

- Role, company, dates: Software Engineer Intern @ Leorna, Aug 2026 – Dec 2026 (L line 3)
- Line under the title: "AI startup · product pre-release · delivered through a multi-agent AI pipeline I designed and operate"
- Summary: "Leorna is building a platform that lets a company manage the skills, agents, prompts and tool integrations its engineers' AI coding tools use." (L "Summary for a recruiter")
- No links.

| # | Bullet | Source |
|---|---|---|
| 1 | Delivered 33 user stories through 39 merged pull requests (39 of 39), each reviewed by a teammate, across a Go control plane and a Windows desktop client in 8 weeks | L bank 1 |
| 2 | Shipped 32,000+ lines of Go with 62,000+ lines of tests (906 test functions, 1.9 test lines per source line) | L bank 9 |
| 3 | Built an integrations platform (6 stories, 134 tests) that delivers GitHub, Google Workspace, ClickUp and admin-defined MCP servers to 3 AI coding tools, with each engineer's credential kept only in the OS credential store | L bank 2 |
| 4 | Built staged client rollout and one-click server updates on Scaleway Serverless Containers, with SHA-256 verification and automatic rollback after a failed start or health check, proven by 13 acceptance criteria and 144 tests | L bank 3 |
| 5 | Added custom-domain support on Scaleway Serverless Containers that activates only after DNS and TLS checks pass and keeps the original address working | L bank 4, first half |
| 6 | Built a CI quality gate that renders every content-library item for 3 AI tools and secret-scans it, then shipped 26 skills, 4 agents and 9 prompts through it with source and licence records | L bank 5 |
| 7 | Built a versioned pack builder with a three-way merge for company-customised content: 5 migrations, 4 API operations, 109 tests | L bank 6 |
| 8 | Built 16 admin console pages and 22 form actions, 40 of the service's 120 HTTP routes, and added 11 of its 35 PostgreSQL migrations, each with a rollback, and 8 of its 46 OpenAPI operations | L bank 8 and 7 |
| 9 | Hardened 2 features against server-side request forgery, and found 9 tenant-isolation filters that could be deleted with every test still passing, using mutation testing, then pinned each with a test | L bank 14 and 15 |
| 10 | Desktop client for Windows: config transformers and sync for Claude Code, Codex and Cursor that never overwrite a user's file (108 tests), chat handoff between AI coding tools (97 tests), and an app that updates itself | L bank 10 and 11; L "Desktop client (Windows)" |
| 11 | Built usage analytics on ClickHouse that reports content use per team from identifiers only (38 tests), and a setup wizard with a per-tenant advisory lock so repeated clicks provision a database exactly once | L bank 12 and 13 |

Stack line: Go · PostgreSQL · ClickHouse · SQLite · OpenAPI · MCP · Wails · GitHub Actions · Scaleway

The ten feature areas and their bullets: integrations 3; release management 4; custom domain 5; content library and CI gate 6; pack builder 7; admin console and control-plane APIs 8; security hardening 9; desktop client 10; usage analytics 11; onboarding 11.

### Experience entry 2: Gro (`data-entry="gro"`)

- Role, company, dates: Web Infrastructure Developer @ Gro, Aug 2026 – Dec 2026 (G line 3)
- Line under the title: "Built by directing a multi-agent pipeline I designed"
- No links.

| # | Bullet | Source |
|---|---|---|
| 1 | Built a Figma-to-WordPress plugin and a live-site importer for Bricks Builder that were used to build 5 websites in 2 weeks | G bank 1 |
| 2 | Held conversion of real designs with up to 1,470 layers under 3 seconds through speed budgets that fail the build | G bank 6 |
| 3 | Cut live-site capture time from 33–35 minutes to 3.4–3.7 minutes (about 9 times faster) by reading 4 screen-width ranges in parallel Chrome windows and reducing style queries to one per element | G bank 5 |
| 4 | Generated tablet and phone layouts from desktop-only designs with 38 tested layout rules, cutting layout errors at 390 px from 75 to 6 on a real design | G bank 4 |
| 5 | Replaced a single 9,824-line JavaScript file with a six-stage pure pipeline (extract → normalise → understand → style → adapt → emit) whose output is byte-identical for the same input | G bank 3 |
| 6 | 59,600 lines of TypeScript in 546 modules, 2,914 commits and 168 numbered builds in 33 days, with 60 named features merged to main in 13 days | G bank 2; G section 1, item 10 |
| 7 | Covered by 4,218 unit tests with 0 failing, at 2.75 lines of test per line of source | G section 1, item 9 |
| 8 | Built a layout lint that checks rendered pages in headless Chrome at 5 screen widths for 8 kinds of error, driven by a 91-line DevTools Protocol client with no npm dependencies | G bank 8 |
| 9 | Automated media handling for WordPress: AVIF and WebP encoding, plus SHA-256 marks checked 50 at a time against the media library so existing pictures are reused instead of uploaded twice | G bank 10 |

Stack line: TypeScript · Node.js 22 · Figma Plugin API · WordPress REST API · Bricks Builder · Chrome DevTools Protocol · esbuild

### Experience entry 3: LinkClicks (`data-entry="linkclicks"`)

Every word as at the base (`components/Experience.tsx:7-33`), with its two links.

### Projects: new first group "AI Engineering" (`data-entry="pipeline"`)

- Name: Multi-Agent Software Delivery Pipeline
- Subtitle: "The system I designed and run to deliver software with AI agents. Used in both roles above."
- No links.

| # | Bullet | Source |
|---|---|---|
| 1 | Designed a 7-role multi-agent pipeline (planner, builder, reviewer, fixer, verifier, blind auditor, finisher) on Claude Code and ran 1,814 agents through it in 26 days, taking 113 stories end to end | H bank 1 |
| 2 | Set up independent AI code review on every change: 472 reviews across 117 stories caught 355 P1/P2 defects before merge, with 190 reviews blocking until fixed | H bank 7 |
| 3 | Required two independent proofs of every acceptance criterion; 1,211 criteria were proven by agents that never saw the code being written, in 6,041 recorded checks | H bank 9 |
| 4 | Added a blind auditor that sees only the plan and the code; it refused 45 criteria the first verifier had accepted on the same commit | H bank 10 |
| 5 | After review had passed, 136 checks were still not accepted: 32 because the named test could not fail, 63 because the criterion was false in a realistic case, and 41 left pending | H section 2, "Refused after review had passed" |
| 6 | Built scripted merge gates (555 lines of Bash, 1,805 lines of tests) that decide "review again", "move on" or "ask the human" from evidence files and refuse any commit no clean review covers | H bank 12 |
| 7 | Built 11 agent hooks (1,928 lines, 3,233 lines of tests), including a 985-line git guard that denies commit-identity overrides, credential and remote changes and hook skipping by AI agents | H bank 14 |
| 8 | Added loop brakes and rebase receipts that halved the share of agent cost spent on late review rounds (14.0% → 7.0%) and removed re-proving after a clean rebase (4.0% → 0) | H bank 22 |
| 9 | Built a token-accounting tool in Python (4 scripts, 1,115 lines) and routed each agent role to the cheapest model and reasoning effort that kept every check in place: mean story cost fell 27% against the 2 days the larger model ran in several roles, and about 4% against the 45 stories before it | H bank 18 and 20; H table 7c |
| 10 | Diagnosed 7 workstation freezes to one test process growing from 0 to 17 GB in 12 seconds, then added an out-of-memory killer, a 20 GB VM cap and a 4 GB cap on mutation runs | H bank 26 |

Tag line: Claude Code · Codex · Bash · Python · Git Worktrees · Model Routing · Mutation Testing

The other two groups ("Security Projects", "Built for Fun") keep every word; their index numbers move up by one (02, 03, 04).

### Skills (`components/Skills.tsx`)

Group order: Security & DevSecOps, AI & Agents, Languages, Technologies, Tools. Existing skills all stay.

| Group | Added | Source |
|---|---|---|
| Security & DevSecOps | Multi-Tenant Isolation, SSRF Prevention, CSRF Protection, Secret Scanning, Mutation Testing | L "Skills demonstrated" |
| AI & Agents (new) | Multi-Agent Orchestration, Claude Code, Codex, Cursor, MCP, Agent Hooks, Model Routing, LLM Cost Analysis, Prompt Caching, Human-in-the-Loop Approval, Agent Guardrails | L "Skills demonstrated"; H section 9 |
| Languages | Go (after Python) | L "Tech stack" |
| Technologies | OpenAPI, ClickHouse, SQLite, Wails, WordPress, Bricks Builder, Figma Plugin API, Chrome DevTools Protocol, esbuild | L "Tech stack"; G section 9 |
| Tools | Git Worktrees, Make, Scaleway, WSL2, systemd | L "Tech stack" |

### Contact and metadata

- Contact line (`components/Contact.tsx:74-76`): "Open to software, security and AI engineering roles — full-time or internship."
- Title (`app/layout.tsx:16`): unchanged.
- Description (`app/layout.tsx:17-18`): "Software engineer with a security mindset. Software Engineer Intern at Leorna and Web Infrastructure Developer at Gro, and designer of a multi-agent software delivery pipeline. B.S. Software Engineering, ASU. Pursuing M.S. Cybersecurity at Georgia Tech."
- New `openGraph: { title, description, type: "website" }` with the same two strings, each defined once in the file and used twice.

## Approach

Keep the site's own patterns: content stays as data arrays in each component, with the same typography and "field notes" bullets. No new section, no new runtime dependency, no redesign. The hero row uses the classes the site already has (`font-mono text-[11px] tracking-[0.15em] uppercase text-muted` for labels, a light large number), in a 1-column grid on phones and 3 columns from `sm`.

Code changes:

- `components/Experience.tsx`: the single `experience` object becomes `experiences: ExperienceEntry[]` (`id`, `role`, `company`, `date`, `tagline`, optional `summary`, `bullets`, `stack`, optional `liveUrl`, `liveLabel`, `githubUrl`), rendered with `.map`. Index labels come from the position ("01"…). The "Live at" text and each link render only when the entry has them. Each entry's wrapper carries `data-entry={id}`.
- `components/ProjectCard.tsx`: `githubUrl` becomes optional; a new optional `entryId` sets `data-entry`; the links row renders only when a link exists.
- `components/Projects.tsx`: a new `aiProjects` array and an "AI Engineering" heading first; the index offsets follow.
- `components/Skills.tsx`, `Hero.tsx`, `About.tsx`, `Contact.tsx`, `app/layout.tsx`: the copy above.
- `app/globals.css:65-68`, so any number of staggered children shows:

  ```css
  .stagger-children.visible > * { opacity: 1; transform: translateY(0); }
  .stagger-children.visible > *:nth-child(2) { transition-delay: 100ms; }
  .stagger-children.visible > *:nth-child(3) { transition-delay: 200ms; }
  .stagger-children.visible > *:nth-child(n+4) { transition-delay: 300ms; }
  ```

- `hooks/useFadeIn.ts`: the observer no longer depends on the section's height. It uses `{ threshold: 0, rootMargin: "0px 0px -10% 0px" }`, so a section shows when its top edge passes the lower 10% of the screen, however tall the section is. The last section (Contact) must still show at the bottom of the page on a tall screen; the layout test's 1440×2560 size checks that. The hook's `threshold` argument is removed (no caller passes one).
- `AGENTS.md` asks for the bundled Next.js docs before any code. Read `node_modules/next/dist/docs/01-app/03-api-reference/04-functions/generate-metadata.md` (the `openGraph` field, line 466 on) before the metadata task. Nothing else here touches a Next.js API.

Tests: Node's own test runner (`node --test`) drives a real browser through the `playwright` library against `next start` on a free port. No test framework is added. `playwright` is pinned to `1.65.0`, the version whose browser (chromium 1254) is already in `~/.cache/ms-playwright`, so nothing is downloaded on this desktop.

## Tasks

Work on a branch off local `main` (`37b40d5`; check it first). One commit per task, each green. Never stage `CLAUDE.md` or `AGENTS.md`: the commit hook refuses them.

Every command runs under the memory cap, and browser runs need the library path:

```
RUN='systemd-run --user --scope -q -p MemoryMax=4G -p MemorySwapMax=0'
export LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu
$RUN npm run build && $RUN node --test tests/<file>.test.mjs
```

Stop a test server by its port or PID, never with `pkill -f` and a pattern that is also in your own command line.

1. **Harness and install.**
   - Write `tests/ac12-build-lint.test.mjs` first (code below) with `tests/lint-baseline.json` holding the 7 base errors. Run it: red at `npm ci --dry-run` (exit 1 on the base, because of the lock drift in "Other things found").
   - `npm install --save-dev --save-exact playwright@1.65.0`. This also brings `package-lock.json` back in step with `package.json`, which is why the lock file changes by more than one package.
   - Add to `package.json` scripts: `"test": "node --test --test-concurrency=1 \"tests/*.test.mjs\""`.
   - Add `tests/helpers/site.mjs` and `tests/helpers/number-blocks.mjs` (code below). Run the build-and-lint test: green.
2. **Record the older copy.** Build the untouched site, run `node tests/helpers/print-number-blocks.mjs`, and save its output as the `legacy` list of `tests/number-ledger.json` (`sourced` and `replaced` empty for now). No test yet: the numbers test arrives with the first new copy, in task 4.
3. **Experience becomes a list** (no copy change). Refactor `components/Experience.tsx` as described. Check: build passes; `print-number-blocks.mjs` prints the same list as in task 2.
4. **Leorna.** Write `tests/ac1-leorna.test.mjs` and `tests/ac9-numbers.test.mjs` (code below): both red (no `[data-entry="leorna"]`; no sourced ledger entry). Add the entry and its ledger rows: both green. From here on every copy task adds its ledger rows in the same commit, and the numbers test is run each time.
5. **Gro.** Write `tests/ac2-gro.test.mjs`: red. Add the entry and its ledger rows: green.
6. **Pipeline card.** Write `tests/ac3-pipeline.test.mjs`, `tests/ac4-cost.test.mjs` and `tests/ac5-scope.test.mjs`: red. Make `githubUrl` optional, add `entryId`, the "AI Engineering" group, the card and its ledger rows: green.
7. **Skills and the stagger rule.** Write `tests/ac7-skills.test.mjs`: red. Add the group and the skills: still red, now only on the visibility clause (the fifth group is at opacity 0); note that in the task's receipt. Change `app/globals.css`: green.
8. **Tall sections.** Write `tests/ac11-layout.test.mjs`. Expected red at 320×568, where the Experience section stays at opacity 0. If it is already green there, record the section's height and prove the clause once with a throwaway doubling of the bullets that is not committed. Change `hooks/useFadeIn.ts`: green at all seven sizes.
9. **Hero and About.** Write `tests/ac6-hero-about.test.mjs`: red. Change both, add ledger rows, move the old About paragraph to `replaced`: green.
10. **Contact, metadata and forbidden detail.** Write `tests/ac8-contact-meta.test.mjs` and `tests/ac10-forbidden.test.mjs`: both red (the forbidden-detail test on "production" in the page description; About lost the word in task 9). Change the contact line and the metadata: both green.
11. **Strict runs.** Build your own `private-terms.txt` (recipe below). Run the numbers test and the forbidden-detail test with their strict switches: both green. Fix the copy or the ledger if not.
12. **Whole run and screenshots.** `$RUN npm run build && SHOTS_DIR=<evidence>/builder $RUN npm test`, with `REQUIRE_PROFILES=1 CAREER_PROFILES_DIR=/home/justin/career REQUIRE_PRIVATE_TERMS=1 PRIVATE_TERMS_FILE=<evidence>/builder/private-terms.txt`. All 12 tests pass. Look at every screenshot at 375 and 1280: no cut-off text, no orphaned label, the hero row lines up. Stop at `ready-for-review`.
13. **Docs & records** (closing task, below).

## Test code

Not run by the planner: there is no head code yet. All four blocks pass `node --check`. The helper's scroll-then-check steps come from the planner's probe, which ran on the base (`planner/probe.mjs`).

`tests/helpers/site.mjs`:

```js
import { spawn } from "node:child_process";
import { createServer } from "node:net";
import { fileURLToPath } from "node:url";
import fs from "node:fs";
import path from "node:path";
import { chromium } from "playwright";

export const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..", "..");

function freePort() {
  return new Promise((resolve, reject) => {
    const s = createServer();
    s.on("error", reject);
    s.listen(0, "127.0.0.1", () => {
      const { port } = s.address();
      s.close(() => resolve(port));
    });
  });
}

export async function startSite() {
  if (!fs.existsSync(path.join(ROOT, ".next", "BUILD_ID"))) {
    throw new Error("no build found: run `npm run build` first");
  }
  const port = await freePort();
  const next = path.join(ROOT, "node_modules", "next", "dist", "bin", "next");
  const child = spawn(process.execPath, [next, "start", "-p", String(port)], { cwd: ROOT, stdio: "ignore" });
  const url = `http://127.0.0.1:${port}`;
  for (let i = 0; ; i++) {
    try {
      if ((await fetch(url)).ok) break;
    } catch {}
    if (i > 150) {
      child.kill();
      throw new Error("the site did not start");
    }
    await new Promise((r) => setTimeout(r, 100));
  }
  const browser = await chromium.launch();
  return {
    url,
    browser,
    async stop() {
      await browser.close();
      child.kill();
    },
  };
}

// Opens a route and scrolls through it, so every fade-in has run before a check.
export async function openPage(site, route, { width = 1280, height = 800 } = {}) {
  const page = await site.browser.newPage({ viewport: { width, height } });
  await page.goto(site.url + route, { waitUntil: "networkidle" });
  const total = await page.evaluate(() => document.documentElement.scrollHeight);
  for (let y = 0; y <= total; y += 200) {
    await page.evaluate((top) => window.scrollTo(0, top), y);
    await page.waitForTimeout(40);
  }
  await page.waitForTimeout(1000); // 600 ms fade plus the longest 300 ms stagger delay
  return page;
}

// Text of one marked entry, spaces collapsed.
export async function entryText(page, id) {
  const el = page.locator(`[data-entry="${id}"]`);
  if ((await el.count()) !== 1) throw new Error(`expected one [data-entry="${id}"], found ${await el.count()}`);
  return (await el.evaluate((e) => e.textContent)).replace(/\s+/g, " ").trim();
}

// Screenshots go where SHOTS_DIR says; with no SHOTS_DIR none are taken.
export async function shot(target, name) {
  const dir = process.env.SHOTS_DIR;
  if (!dir) return;
  await target.screenshot({ path: path.join(dir, name) });
}
```

`tests/helpers/number-blocks.mjs` (the collector the numbers test and the print script share):

```js
export const norm = (s) => s.replace(/\s+/g, " ").replace(/^[—–-]\s*/, "").trim();
export const numbers = (s) => s.match(/\d[\d,.]*\d|\d/g) || [];
export const STRUCTURAL = /^\d{2}$/; // section and entry index labels: 01, 02 …

// Every piece of text on the page that holds a digit, plus the title and description tags.
// The blog preview is left out: its dates come from posts and shift with the time zone.
export async function collectNumberBlocks(page) {
  const raw = await page.evaluate(() => {
    const out = new Set();
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    for (let n = walker.nextNode(); n; n = walker.nextNode()) {
      if (!/\d/.test(n.nodeValue)) continue;
      const el = n.parentElement;
      if (!el || el.closest("script, style, noscript, #blog")) continue;
      out.add(el.textContent);
    }
    const metas = document.querySelectorAll('meta[name="description"], meta[property^="og:"]');
    for (const m of metas) if (/\d/.test(m.content)) out.add(m.content);
    if (/\d/.test(document.title)) out.add(document.title);
    return [...out];
  });
  return [...new Set(raw.map(norm))].filter((b) => !STRUCTURAL.test(b)).sort();
}
```

`tests/helpers/print-number-blocks.mjs` starts the site, opens `/`, prints `JSON.stringify(await collectNumberBlocks(page), null, 2)` and stops the site.

`tests/number-ledger.json` has three lists:

```json
{
  "legacy": ["<each number-bearing text of the base page, from task 2>"],
  "replaced": ["<a legacy text this job removed on purpose: the old About paragraph>"],
  "sourced": [
    {
      "text": "<the text exactly as the page shows it>",
      "sources": [
        { "file": "leorna-work-profile.md", "quote": "<a sentence or table cell from the profile, word for word>" },
        { "legacy": "<a legacy or replaced text, for a number the older copy already had>" }
      ]
    }
  ]
}
```

`tests/ac9-numbers.test.mjs`:

```js
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { ROOT, startSite, openPage } from "./helpers/site.mjs";
import { norm, numbers, collectNumberBlocks } from "./helpers/number-blocks.mjs";

const PROFILES = ["leorna-work-profile.md", "figma-to-bricks-profile.md", "agentic-harness-profile.md"];

test("AC9 every number on the page traces to a profile line or to unchanged older copy", async () => {
  const ledger = JSON.parse(fs.readFileSync(path.join(ROOT, "tests", "number-ledger.json"), "utf8"));
  const legacy = new Set(ledger.legacy.map(norm));
  const replaced = new Set(ledger.replaced.map(norm));
  const sourced = new Map(ledger.sourced.map((e) => [norm(e.text), e]));

  const site = await startSite();
  let blocks;
  try {
    blocks = await collectNumberBlocks(await openPage(site, "/"));
  } finally {
    await site.stop();
  }
  const seen = new Set(blocks);

  for (const b of blocks) {
    assert.ok(legacy.has(b) || sourced.has(b), `text with a number is neither older copy nor in the ledger: "${b}"`);
  }
  for (const t of sourced.keys()) assert.ok(seen.has(t), `ledger entry is not on the page: "${t}"`);
  for (const t of legacy) {
    assert.ok(seen.has(t) || replaced.has(t), `older copy is gone and not listed as replaced: "${t}"`);
  }
  for (const t of replaced) assert.ok(legacy.has(t) && !seen.has(t), `"replaced" entry is not a removed legacy text: "${t}"`);
  assert.ok(sourced.size > 0, "the ledger has no sourced entry");

  const dir = process.env.CAREER_PROFILES_DIR;
  if (process.env.REQUIRE_PROFILES === "1") {
    assert.ok(dir && fs.existsSync(dir), "REQUIRE_PROFILES=1 needs CAREER_PROFILES_DIR to point at the profiles");
  }
  const profiles = new Map();
  if (dir && fs.existsSync(dir)) {
    for (const f of PROFILES) profiles.set(f, norm(fs.readFileSync(path.join(dir, f), "utf8")));
  } else {
    console.log("note: profiles not checked (CAREER_PROFILES_DIR is not set)");
  }

  for (const e of ledger.sourced) {
    const allowed = new Set();
    assert.ok(e.sources.length > 0, `no source for "${e.text}"`);
    for (const s of e.sources) {
      if (s.legacy !== undefined) {
        assert.ok(legacy.has(norm(s.legacy)), `legacy source is not in the legacy list: "${s.legacy}"`);
        numbers(s.legacy).forEach((n) => allowed.add(n));
        continue;
      }
      assert.ok(PROFILES.includes(s.file), `unknown profile file: ${s.file}`);
      numbers(s.quote).forEach((n) => allowed.add(n));
      if (profiles.size) {
        assert.ok(profiles.get(s.file).includes(norm(s.quote)), `quote not found in ${s.file}: "${s.quote}"`);
      }
    }
    for (const n of numbers(e.text)) {
      assert.ok(allowed.has(n), `"${n}" in "${e.text}" is in none of its source quotes`);
    }
  }
});
```

`tests/ac12-build-lint.test.mjs`:

```js
import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const run = (cmd, args) => spawnSync(cmd, args, { cwd: ROOT, encoding: "utf8", maxBuffer: 64 * 1024 * 1024 });

test("AC12 clean install build and lint baseline hold", () => {
  const ci = run("npm", ["ci", "--dry-run"]);
  assert.equal(ci.status, 0, `npm ci --dry-run failed:\n${ci.stderr.slice(0, 2000)}`);

  const build = run("npm", ["run", "build"]);
  assert.equal(build.status, 0, `npm run build failed:\n${(build.stdout + build.stderr).slice(-2000)}`);

  const lint = run("npx", ["eslint", "-f", "json", "."]);
  const found = [];
  for (const file of JSON.parse(lint.stdout)) {
    for (const m of file.messages) {
      if (m.severity === 2) found.push(`${path.relative(ROOT, file.filePath)} ${m.ruleId}`);
    }
  }
  const left = JSON.parse(fs.readFileSync(path.join(ROOT, "tests", "lint-baseline.json"), "utf8"));
  const extra = [];
  for (const f of found) {
    const i = left.indexOf(f);
    if (i === -1) extra.push(f);
    else left.splice(i, 1);
  }
  assert.deepEqual(extra, [], "lint errors that are not in the baseline");
});
```

`tests/lint-baseline.json` (the 7 errors on `37b40d5`, by file and rule):

```json
[
  "app/blog/[slug]/page.tsx @next/next/no-html-link-for-pages",
  "app/blog/page.tsx @next/next/no-html-link-for-pages",
  "components/BlogNavbar.tsx react-hooks/set-state-in-effect",
  "components/BlogNavbar.tsx @next/next/no-html-link-for-pages",
  "components/BlogPreview.tsx @next/next/no-html-link-for-pages",
  "components/ui/floating-navbar.tsx react-hooks/set-state-in-effect",
  "components/ui/floating-navbar.tsx @next/next/no-html-link-for-pages"
]
```

The other test files follow one shape: start the site in the test, check, stop it in `finally`. What each asserts:

| Test file | Asserts |
|---|---|
| `ac1-leorna.test.mjs` | `leorna` is the first `[data-entry]` inside `#experience`. Its text holds: "Software Engineer Intern", "Leorna", "Aug 2026 – Dec 2026", "pre-release", "multi-agent AI pipeline I designed and operate", "33 user stories", "39 merged pull requests", "906 test functions", and one phrase per feature area: "integrations platform", "staged client rollout", "custom-domain support", "CI quality gate", "pack builder", "admin console pages", "server-side request forgery", "Desktop client", "usage analytics", "setup wizard". Screenshots of the entry at 375 and 1280. |
| `ac2-gro.test.mjs` | `gro` is the second entry and `linkclicks` the third. Its text holds: "Web Infrastructure Developer", "Gro", "Aug 2026 – Dec 2026", "Built by directing a multi-agent pipeline I designed", "Figma-to-WordPress plugin", "live-site importer", "5 websites in 2 weeks", "under 3 seconds", "33–35 minutes to 3.4–3.7 minutes", "from 75 to 6", "merged to main"; and none of "launched", "live site", "in production", "CI/CD". Screenshots. |
| `ac3-pipeline.test.mjs` | The first `h3` in `#projects` is "AI Engineering" and `pipeline` is the first card. Its text holds "Multi-Agent Software Delivery Pipeline", all 7 role names, "1,814 agents", "113 stories", "26 days", "472 reviews", "355 P1/P2", "1,211 criteria", "refused 45 criteria", "merge gates", "11 agent hooks", "loop brakes", "token-accounting", "17 GB". The card has no `a[href]`. The older cards are still there: "DevSecOps Pipeline", "LLM Vulnerability Scanner", "MinimaLog". Screenshots. |
| `ac4-cost.test.mjs` | At least one text on `/` holds "27%". Every text that holds "27%" also holds "about 4%", "the 2 days the larger model ran in several roles" and "the 45 stories before it". The page text and the metadata hold no "$". Screenshot of that bullet. |
| `ac5-scope.test.mjs` | The pipeline card holds "1,814", "472", "355", "1,211", "6,041". The `leorna` and `gro` entries hold none of those, nor "agents run", "review rounds", "P1", "P2", "blocking defects" or "acceptance checks". Reading numbers as whole numbers (so "121" is not found inside "1,211"), the page holds none of 1,319, 359, 268, 1,011, 4,696, 576 and 121, nor the phrases "360 agents", "44 blocking" and "79 automated". Every text holding the number 136 is inside the pipeline card and also holds 32, 63 and 41. Screenshot of the card. |
| `ac6-hero-about.test.mjs` | The hero holds "multi-agent AI engineering"; `hero-stats` holds "39 of 39", "5 websites", "1,814 agents". `#about` holds "Leorna", "Gro", "multi-agent AI pipeline I designed and operate", "pre-release", "5 websites in 2 weeks"; and not "Finishing my B.S.", "starting Georgia Tech" or "production". The two education cards are still there ("May 2026", "2026 - 2028"). Screenshots. |
| `ac7-skills.test.mjs` | `#skills` has 5 group headings in the planned order. Each added skill in this plan's Skills table is a pill in its group, and each skill of the base is still there (the base list is written out in the test). At 375×667 and 1280×800 every group has computed opacity 1 after scrolling. Screenshots. |
| `ac8-contact-meta.test.mjs` | `#contact` holds the new line and not "AppSec". `meta[name="description"]` and `meta[property="og:description"]` both equal the planned description; `og:title` equals `document.title`; the title is unchanged. Screenshot of the contact section; the tags go in the log. |
| `ac10-forbidden.test.mjs` | Over the page text of `/`, its title and meta tags, and the `sourced` list of `tests/number-ledger.json` (texts and quotes; the `legacy` and `replaced` lists hold the old About paragraph, which says "production"): no match for `\bproduction\b`, `\bcustomers?\b`, `\brevenue\b`, `\btraffic\b`, `\blaunched\b`, `\b(Fable|Opus)\b`, `\b86[a-z0-9]{7}\b`, `\bPR ?#?\d+`, `leorna\.com`, `scw\.cloud`, `clickup\.com`, `localhost`, `/home/`, `C:\\`, or an email other than the one in Contact. Inside `leorna`, `gro`, `pipeline` and `hero-stats`: also no `\busers\b`, `\b(is|are|went|goes|now) live\b`, `\blive (on|at|in)\b`, `hand-wrote`, and no `a[href]` ("live-site importer" is the tool's name and is allowed). Every `a[href]` on the page is `#…`, `/…`, `tel:…`, or on `github.com/Just-In-N-Out`, `3dsearch.org`, `www.minimalog.fit`, `www.linkedin.com` or `mail.google.com`. With `PRIVATE_TERMS_FILE` set, none of its lines (and no part of a line of 4 letters or more) appears as a whole word, matching case. With `REQUIRE_PRIVATE_TERMS=1` the test fails when that file is missing or empty. |
| `ac11-layout.test.mjs` | For each of the seven sizes on `/` (the tall 1440×2560 one proves the last section still shows at the bottom of the page): the three new entries exist; `documentElement.scrollWidth <= clientWidth`; no element with a visible box has its right edge past `clientWidth + 0.5` or its left edge under `-0.5`; every `.fade-in-section` and every `.stagger-children > *` has computed opacity "1" after scrolling. Full-page screenshots at 375×667 and 1280×800. |

The teammates' names are never stored in the repository. Each role builds its own list in its own evidence folder:

```
{ git -C ~/Leorna/leorna-control-plane shortlog -sn main; git -C ~/Leorna/leorna-client shortlog -sn main; } \
  | cut -f2 | sort -u | /usr/bin/grep -v -i -E '^justin' > <evidence>/<role>/private-terms.txt
```

## For the verifier and the auditor

- Strict runs set `REQUIRE_PROFILES=1 CAREER_PROFILES_DIR=/home/justin/career` for the numbers test and `REQUIRE_PRIVATE_TERMS=1 PRIVATE_TERMS_FILE=<own folder>/private-terms.txt` for the forbidden-detail test.
- Every test command is `npm run build && node --test tests/<file>.test.mjs`, so the test never reads an old build.
- **Base runs: copy `node_modules`, never link it.** With a linked `node_modules` the build stops at "Symlink [project]/node_modules is invalid, it points out of the filesystem root" (`planner/symlinked-node-modules-build.log`), and the test would fail for the wrong reason. In the base copy: `cp -a <worktree>/node_modules .`, then `git checkout <head> -- tests`, and nothing else from head. Keep the base's own `package.json` and lock file: the build-and-lint test fails there because of them. The copy is 515 MB; delete it afterwards.
- Expected on the base: the 12 tests each fail on their own assertion. The first eight and the layout test find no new entry or copy. The cost test finds no "27%". The scope test finds no pipeline card. The numbers test finds ledger entries that are not on the page. The forbidden-detail test finds "production" (`components/About.tsx:24`, `app/layout.tsx:18`). The build-and-lint test fails at `npm ci --dry-run`.
- Screenshots: set `SHOTS_DIR` to your own folder. The floating navbar's emoji icons show as empty boxes in headless Chrome on this desktop (no emoji font); that is the test machine, not the site.

## Risks

1. **The profiles may change again.** The builder re-reads them, and the numbers test compares every quote with the files in its strict run. A changed number is reported, never adjusted quietly.
2. **The Experience section gets long on a phone** (25 bullets). The fade-in fix keeps it visible; whether it reads well is Justin's call at the preview. Trimming later is an amendment, since AC1 names all ten feature areas.
3. **The lock file changes widely.** Adding `playwright` re-syncs a lock that has been out of step since 2026-04-20. Vercel installs from `package.json`'s exact versions today, so the deployed versions should not change; AC13 is the check.
4. **A new dev dependency on Vercel.** `playwright` downloads no browser at install, so the deploy only gets a slightly longer install.
5. **Positioning and tone are judgement.** Tests prove facts and layout, not taste. The local preview is where Justin decides.
6. **The name list can misfire** when a teammate's name part is also an ordinary word. The test prints the term and where it matched; the builder rewords, or reports it.
7. **Disk.** Each base copy holds 515 MB of `node_modules`; every role deletes its copy.

## Other things found

Not fixed here, apart from the lock file (unavoidable) and the two layout traps (needed for the new content).

1. **`package-lock.json` is out of step with `package.json`** (medium). `npm ci` fails with EUSAGE: the lock has next 16.1.7 and react 19.2.3, `package.json` has 16.2.0 and 19.2.4, since commit `3880ee7` (2026-04-20). Task 1 re-syncs it as a side effect.
2. **`npm run lint` fails on `main` with 7 errors** (low): `no-html-link-for-pages` in `app/blog/[slug]/page.tsx:46`, `app/blog/page.tsx:67`, `components/BlogNavbar.tsx:59`, `components/BlogPreview.tsx:36`, `components/ui/floating-navbar.tsx:80`; `react-hooks/set-state-in-effect` in `components/BlogNavbar.tsx:49` and `components/ui/floating-navbar.tsx:65`. Log: `planner/base-lint.log`.
3. **Blog dates show one day early in US time zones** (medium, visible). `components/BlogCard.tsx:12` and `app/blog/[slug]/page.tsx:60` parse "2026-04-19" as UTC and print it in local time: the card says "Apr 18, 2026" under a title that says April 19 (`planner/base-1280.png`).
4. **`CLAUDE.md` and `AGENTS.md` are tracked in this repository** (known; against Justin's rule). The `CLAUDE.md` spec is also out of date: it describes a 2025 site with other projects, a footer year of 2025 and placeholder contact links.
5. **The site tells search engines to stay away** (info). `app/layout.tsx:19` sets `robots: { index: false, follow: false }` and `public/robots.txt` disallows everything, since the first commit. If that is on purpose, nothing to do.
6. **`README.md` is still the create-next-app text** (low).
7. **The three profiles disagree in four places** (low; for whoever maintains them). Hooks: 12 scripts (Leorna file) or 11 (harness file). Agent tools on one setup: 2 or 3. Gate-script tests: 1,457 lines or 1,805. Report send-backs: 111 in 16 days or 371. This plan uses the harness file for every pipeline fact.
8. **No social preview image** (low). This job adds Open Graph text but no image.
9. **The LinkClicks entry's GitHub link goes to the profile page, not a repository** (info, `components/Experience.tsx:13`).
10. **A phone number is on the public page** (info, `components/Contact.tsx:46`). Justin's choice; noted only.

## Docs & records

The closing task, after the whole run is green:

1. Add a short "Tests" section to `README.md`: how to run `npm test`, the two strict switches, and that a new number on the page needs a ledger row with a profile quote.
2. Leave `CLAUDE.md`, `AGENTS.md` and `~/.claude/project-docs/personal-website/CLAUDE.md` alone (item 4 above is Justin's to decide).
3. Put receipts in `~/.hermes/plans/personal-website/evidence/site-career-update/builder/`: the run log, the screenshots, `private-terms.txt`, and a note of every profile line that differed from this plan.
4. Report in the hand-back: the branch, the last commit, each AC with its test and screenshot, anything else found, and the local preview command for Justin (Ubuntu window): `cd ~/JustinPersonalWebsite && npm install && npm run build && npx next start -p 3000`, then open http://localhost:3000.
5. Nothing is pushed. After Justin's "push" and the Vercel deploy, AC13 is his to check.

## Skills

Builder: `engineering-best-practices`, `test-driven-development`, `frontend-testing-workflow`, `ux-frontend-workbench` (the hero row and the long entries on a phone), `git-commit-rules`. No project skill exists. Reviewers and fixers load their role skills as the pipeline says.

## Planner's evidence

In `~/.hermes/plans/personal-website/evidence/site-career-update/planner/`:

- `base-lint.log`, `base-build.log`: lint fails with 7 errors and the build passes on `37b40d5`.
- `base-probe.json`, `base-375.png`, `base-1280.png`, `probe.mjs`: no sideways scroll and nothing hidden on the base at 375, 390, 768, 1280 and 1440 wide, on all three routes.
- `trap-5th-skill-group-375.png`, `trap-5th-skill-group-1280.png`: a fifth Skills group stays hidden.
- `tall-section-probe.log`, `tall-section-probe.mjs`: a 25-bullet Experience section stays hidden at 320×568.
- `symlinked-node-modules-build.log`: the build refuses a linked `node_modules`.
