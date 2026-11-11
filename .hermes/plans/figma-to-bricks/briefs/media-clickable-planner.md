# Role: planner (Mini, a bug): media-clickable — uploaded photos that show on the Bricks page but aren't their own clickable media items

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com** (its bot check; Justin's rule), B-Dry staging or any live site; no logins;
never write to any WordPress site. Read-only on `~/Downloads` (copy what you need into your evidence folder).

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`,
`systematic-debugging` (prove the root cause with evidence before any fix). Mini mode
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`): load the project skill and only the
code/docs sections this touches; skip the full Step 1 context load; finish within about 20 steps. If this is bigger or
riskier than a Mini job (a design decision, more than ~3 source files), say so and recommend Full. Read the repo's
`CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.3, `02481763`).

## What Justin reported (his words, 2026-11-11)
"I noticed some photos are in the media but not clickable as separate items on the bricks page. We need to fix that,
probably because they lack alt text, so the import didn't recognize them as their own media and clickable on alt text
even though they are in the media library."
His hypothesis (missing alt text) is a hypothesis: prove or disprove it.

## The run that shows it (files on this PC)
He scanned bdryswi.com's home with Build 2026-11-11.3, ran `site:upload` against B-Dry staging (Bricks 2.4.2; 34 pictures
uploaded, media ids 174–207) and pasted header, page and footer:
- capture `~/Downloads/bdry-test/bdryswi-com-home.f2b-capture.json`
- `~/Downloads/bdry-test/paste/`: `header.json`, `page.json`, `footer.json`, `media.json`, `notes.txt`, `sources-*.json`,
  `live-footer.json`.
The capture holds 52 pictures; 34 went up. For each picture the capture holds: did it go up (media.json), and how does
the paste carry it — a Bricks Image (or `image-gallery`/`svg`) element whose image has an `id` and the site's
`sourceUrl` (CLAUDE.md "Bricks swaps pasted pictures for its grey placeholder…"), a CSS `background-image` in a class or
custom CSS, an `<img>` inside Rich Text or a Code element (reviews widget, a menu box), a slider slide's background, a
Div with a picture background, … Table them; name which of these Bricks shows as a separate, clickable, swappable
picture in the builder and which not (from Bricks' own code in `reference/bricks/` and the README; never from memory).
Alt text: check whether alt actually decides it (the paste carries no `altText`: Bricks shows Media's alt).

## The plan must settle
1. Root cause with file:line evidence, per kind of picture that isn't its own item.
2. The general fix (every scanned site, not B-Dry only): e.g. a picture the site draws as an `<img>` becomes a Bricks
   Image with the media id wherever the paste can hold one without changing the look; a CSS background picture uses
   Bricks' background control with the media id (if Bricks has one that holds an id: read the samples) — or stays CSS,
   named. Where making it its own item would change the look (a background behind words, a slider, a box the site's
   script draws), ask with a ⭐ answer. Pastes without such pictures and Figma designs stay byte for byte.
3. Numbered ACs, AC1, AC2…, each with one named test (each name whole on one line; a line that isn't an AC's definition
   never starts with a list marker followed by `AC<n>`), all marked **proposed**; one `(live)` AC: Justin re-pastes on
   B-Dry staging and each of those pictures is its own clickable Image in the builder.

## Write
`~/.hermes/plans/figma-to-bricks/media-clickable.md` (the builder copies it to
`docs/plans/2026-11-11-media-clickable.md`): playback in 3 plain lines, questions at the top with ⭐ answers (Justin's
standing auto-go runs the builder at once on them), the picture table, root cause, fix, ACs, touched files, tasks, a
one-line Docs & records task. Evidence under `~/.hermes/plans/figma-to-bricks/evidence/media-clickable/planner/`.
Note: another job (media-avif-alt) is changing `tools/lib/site-upload/` (format and alt text) at the same time: say
which files the two share.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/mcl/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`). One plain git command per call, `git -C <absolute path>`. Use `tail -n 3`. Waits under
115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E
'sending SIG[A-Z]* to process'` first.

## Report (as text)
The plan's path; the playback; the picture table in short; the root cause; the fix; the ACs one line each (the live one
named); questions with ⭐; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
