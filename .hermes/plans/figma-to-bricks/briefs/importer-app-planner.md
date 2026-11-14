# Role: planner (Full): importer-app — a simple local app for the website importer: scan, preview, copy header / body / footer / all

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing, start no agents.
**Never load bdryswi.com**, B-Dry staging or any live site; no logins; never write to any WordPress site; never call alttext.ai. Read-only on
`~/Downloads` (Justin's 2026-11-11 scan: read-only copy `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/run/`). Plain `git`, each
command alone; scratch under `~/.cache/iapp-pl/`.

Load `engineering-best-practices`, `implementation-planning`, `ux-frontend-workbench`, `security-best-practices`, and read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` directly (it isn't linked as a Skill). Read the repo's `CLAUDE.md` (main folder
`/home/justin/Documents/FigmaToBricksV2`): the standard at the top of "Decisions the user made", "The website importer's helper" (binds
127.0.0.1 only), "The importer never hides that its Chrome is automated", "One uploader writes to WordPress, reached by two commands"
(the Application Password and the alttext.ai key rules), and the Status lines for site-one-command (11.1), site-media-upload (10.5),
media-avif-alt (11.10). If you need to figure something out, research it first; if nothing is found, give your best-reasoned answer as a ⭐
ruling.

## What Justin asked (2026-11-13)
"I also want to build a simple UI for the importer so we run the app, it pastes like the page and then we can copy either the header,
body, or footer or all" … "plus a section where we can put the API for alt text". His answers: **a local browser page** (`npm run importer`
opens `http://127.0.0.1:<port>` served by the tool on his own computer; works on the Mac and the desktop); features: **scan + preview +
copy** (type the address, Elementor box, Scan — the visible Chrome window for "I am human"; the page drawn as Bricks will show it; Copy
header / Copy body / Copy footer / Copy all to the clipboard), **open saved scans** (list earlier scans, preview and copy again without
rescanning), **desktop / tablet / phone view** (1440, 991, 767, 390), **upload pictures to WordPress** inside the app (site:import's upload
step), and **an alttext.ai key section**. Full pipeline. Importer only (the Figma plugin has its own panel).

## The plan must settle
1. **Reuse, not rewrite:** the app drives the same code `site:import`, `site:upload`, `site`, `site:check`'s renderer and the capture use
   (`tools/lib/site-import/`, `tools/lib/site-upload/`, `src/web/`, `test/browser/render.ts` or a product copy of its Bricks drawing); no
   runtime dependency (Node built-ins and the system Chrome only, as the repo's setup rule says); the pastes the app copies are byte for byte
   what `site:import`/`site` write for the same scan and options.
2. **The preview:** how the page is drawn as Bricks will show it (Bricks 2.4.2 / 2.3.9 front-end CSS the renderer already has), the
   three parts and "all", the four widths, opened boxes (menus) if useful; how long a scan takes and what the page shows meanwhile (the
   capture's progress lines, the person check, a stop button).
3. **Copy:** what each button puts on the clipboard (header, body, footer, all as one paste — Justin's "ONE paste" memory note
   `importer-whole-page-paste.md`), in a local page's clipboard rules (`navigator.clipboard` on 127.0.0.1 is a secure context; test it on the
   desktop's Chrome and the Mac's), and a fallback.
4. **WordPress upload and the alttext.ai key — security first.** Today the Application Password is typed only at a hidden terminal prompt
   and kept in the process's memory; the alttext.ai key is asked once and saved 0600. In a browser page: the password box (type=password,
   never stored, never echoed back, never in a URL, a log, the record, the paste or the scan's Chrome), the key section (save / replace /
   test / remove; never shown back in full), the typed "yes" before any upload, and the local server's defences: bind 127.0.0.1 only, a
   random per-run token so another site's page can't drive it (CSRF / DNS rebinding: check the Host and Origin headers), POST bodies only,
   nothing written to any site but by the existing uploader. Say exactly which CLAUDE.md rule lines change (they say "typed at the hidden
   prompt") and propose the new wording; the app never lets an agent or a test reach a live site (tests use `test/fixtures/wp-standin.ts`).
5. **Saved scans:** where they're found (`~/Downloads/<page>/`, the scans the app makes), what's listed (page, date, build, routes made).
6. **The standard:** say how the app keeps the paste to the standard (it doesn't change the paste, only how he gets it) and what the notes
   show (the paste notes per part, the Structure line).
7. Numbered ACs AC1, AC2…, each with one named test (each name whole on one line; a line that isn't an AC's definition never starts with a
   list marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin runs `npm run importer`, scans bdryswi.com, previews
   it at four widths, copies the header and pastes it on B-Dry staging, then uploads with his own password and key. Tests run the app in
   Chrome against local fixture sites and the WordPress stand-in.

## Base and order
Base: main (now `7f54b0a5`, Build 2026-11-12.3; site-no-div merges next as 12.4). It touches the importer's tools, not the paste code, so it
can build alongside the paste jobs; name every shared file (site-import's next steps change in site-shared-styles; short-class-names adds
`--class-names`/`--prefix`; clean-values adds `clean.json`) and how the app passes those options through.

## Write
`~/.hermes/plans/figma-to-bricks/importer-app.md`: playback in 3 plain lines, questions at the top with ⭐ answers, a screen sketch, the
design, the security section, ACs, touched files, tasks in milestones, overlaps and order, a Docs & records task (the CLAUDE.md rule lines).
Evidence under `~/.hermes/plans/figma-to-bricks/evidence/importer-app/planner/`.

## Report (as text)
The plan path; the questions with ⭐ answers; the ACs one line each; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these
skill_lessons now.`
