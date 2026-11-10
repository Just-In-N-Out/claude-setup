# Role: planner (Full): site-media-upload (a scanned page's pictures go to the user's WordPress media library, from the command line)

You are a fresh planner for FigmaToBricksV2 (**Opus 5.5, high**). Write an implementer-ready plan; change no source or
test, commit nothing, start no agents. Never edit the main folder's files or any worktree (read the repo with `git -C
/home/justin/Documents/FigmaToBricksV2 show <sha>:<path>` or plain reads; `git archive` scratch copies under
`~/.cache/smu-p/` if you run anything). **Never load bdryswi.com, B-Dry staging or any live site; never write to any
WordPress site; use no login, no Application Password, no key** (not Justin's site, not any site): everything you run
talks only to local stand-ins. Nothing paid.

**Skills to load:** the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with
`references/live-site-reading.md` and `references/testing-pitfalls.md`), `engineering-best-practices`,
`implementation-planning`. Read the repo `CLAUDE.md` in full (the sections on pictures, uploads, WordPress, the
importer's helper, "Website captures", "Pictures inside the paste", "AI picture descriptions", "Bricks swaps pasted
pictures for its grey placeholder", "A WordPress upload attached to no page owns the address…", "Photos as AVIF",
"A stand-in for WordPress answers as WordPress does") and `docs/HANDOFF.md` (the upload, web-panel, web-code-page and
alt-text sections).

## The request (Justin, 2026-11-10, in the session)
He asked how alt text is handled for a scanned page, was told that on the `npm run site` route pictures stay on the old
site's addresses with the old site's alt text in each Image's Custom alt text, and said: **"Can we make them upload to
my Wordpress media library like how it is in the plugin?"** Asked where the upload should happen, he chose **"From the
command line"** (over "In the Figma panel" and "Both"), and the **Full** pipeline. He was told plainly that this is a
new tool that writes to WordPress, which his standing rule forbids today ("Never write to any WordPress site; GET/read
only, and ask me before using any login."; CLAUDE.md: "The helper binds 127.0.0.1 only and never writes to a site").
His choice changes that rule for this one tool, run by him: **agents still never run an upload against his site or any
live site, and never hold his password.**

## What exists (find it and cite file:line)
- The Figma panel uploads pictures to WordPress through the REST API with an Application Password
  (`src/ui/wordpress.ts`, `src/ui/site-media.ts`, `src/ui/site-read.ts`, `src/ui/site-fonts.ts`, `src/ui/main.ts`;
  browser features go through `src/ui/env.ts`): naming (uploads end in `-image`/`-video`), the upload cache, AVIF/WebP
  choice, alt text into WordPress's alt field, alttext.ai for photos (his account, only when pictures go to WordPress),
  and the paste then names the site (`siteAddress`, Bricks' `sourceUrl` rule) with media ids.
- The code route (`npm run site`, `tools/site.ts`, `src/core/site/`): `kinds.ts` makes each `<img>` a Bricks Image
  `{ image: { url, external: true, filename }, altText }` (the old site's address; `--pictures address` or `data`);
  CSS background pictures and `<picture>`/`srcset` are handled somewhere too: find out how each is pasted today.
  The capture file holds the pictures' bytes (`web.pictures` or similar: find it).
- Justin's answer 10 (2026-10-30, HANDOFF): a capture's pictures keep the old site's alt text; alttext.ai writes only
  for pictures without words, a decorative one (`alt=""`) is never sent.

## What to plan
A command-line step that uploads a scanned page's pictures to the user's WordPress media library and makes the paste
use them "like the plugin": the Image elements point at the site's own media (ids and addresses Bricks accepts without
swapping in its grey placeholder), the alt text is in Media, and the paste still looks like the site within the code
route's tolerances. A general rule for any scanned site, not B-Dry. Work out and decide (with ⭐ recommendations):
- **The command's shape:** a flag on `npm run site` (`--upload <site address>`), or its own command run on a made
  paste (`npm run site:upload -- <out folder> <site address>`) — which is safer to re-run, and which keeps `npm run
  site` itself offline and unable to write.
- **The password:** how the Application Password reaches the tool without ever being written to a file, the paste,
  the notes, a log, the shell history or a process list an agent could read (a prompt with no echo; an environment
  variable; never a command-line argument); what the tool prints; a dry run that lists what it would upload and writes
  nothing; a first confirmation line naming the site and the count.
- **Reuse, not a second copy:** which of the panel's upload modules can run in Node as they are (they go through
  `src/ui/env.ts`), which need a Node environment, and what must be shared so the panel and the command line name,
  cache and de-duplicate uploads the same way (a picture the panel already uploaded is not uploaded again; a re-run
  uploads nothing new; a picture used on header, page and footer is uploaded once).
- **Which pictures:** `<img>`, `<picture>`/`srcset`, CSS backgrounds, pictures inside slides and opened boxes, SVGs
  (WordPress refuses SVG uploads by default: what then), pictures the capture has no bytes for, pictures of another
  host (a widget's), data pictures, very large files, the same file at several sizes; AVIF/WebP as the panel chooses
  them ("never fall back silently").
- **Alt text:** into WordPress's alt field and, as today, on the element or not (the panel's rule: Bricks shows the
  media library's alt, so the paste carries none: confirm from the code and `reference/bricks/README.md`); `alt=""`
  stays decorative; a picture with no alt: alttext.ai as in the panel (it is his paid account: the tool must only use
  it when he passes his key, and say so), or left empty with the note.
- **What it must never do:** delete or change anything already on the site; upload when the address isn't the site it
  was told; send the password to any host but that site; run from an agent against a live site. A failure half-way
  leaves a paste that still works (the old addresses) and says what was and wasn't uploaded.
- **Testing without any real site:** a local stand-in for WordPress's media and Application Password endpoints that
  answers as WordPress does, read from WordPress's own code or a real saved answer, never from what the code expects
  (CLAUDE.md's rule); what the live AC is and that only Justin runs it.
- **Standing-rule changes** this needs in CLAUDE.md and HANDOFF (the importer's helper line; "never writes to a
  site"), worded so every other tool stays read-only.
- Overlaps with the unmerged jobs (staging-fit-renderer, site-native-structure — it changes how a linked picture
  becomes an Image —, staging-fit-cancels, site-menu, panel-embed-code): which files.

## The plan must have
- Playback of the request in plain numbered words; what exists, with file:line evidence.
- Questions at the top with ⭐ recommended answers (Justin takes the planner's recommendation unless he changes it),
  each with what it costs him in plain words.
- **Numbered acceptance criteria AC1, AC2… marked (proposed), one test each, named, each test name whole on one line**
  (and no other line starting with a list marker followed by `AC<n>`); tag `(live)` right after the id for what only
  Justin can check (the upload against his staging site with his own password; the pasted page in Bricks showing the
  media library's pictures and alt text). Include: the password never appears in any file, output or argument (a test
  that greps everything the tool wrote and printed); a dry run writes nothing (the stand-in received no non-GET
  request); a re-run uploads nothing new; without the upload step every paste is byte for byte as today; the page
  still within the code route's 2 px with the uploaded pictures; Figma designs and the panel byte for byte as before.
- Ordered tasks a fresh builder with no context could follow (a consumer's guard before the producer's change where
  both exist), tests (RED on base, GREEN), risks.

## Output
Write the plan to `/home/justin/.hermes/plans/figma-to-bricks/site-media-upload.md`. Run `ac-check.sh`'s `ac_start`,
`bad_id` and `live` regexes on it (from `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`)
and show the output; check each cited test name sits whole on one line.

## Report (as text)
The playback, what exists, the questions with ⭐ answers, the ACs one line each (naming the `(live)` ones), the
standing-rule change it needs, overlaps; then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty
is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
