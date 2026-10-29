# BUILDER: B-Dry Home paste v3, with the three released moving parts (FigmaToBricksV2)

You are a builder for a one-off paste file, not a plugin change. Justin wants bdryswi.com's Home as a Bricks paste for the
new B-Dry site (`bdry.staging.growithgro.com`, Home is page 14). He chose "Updated": take the hand-built copy from
2026-10-28 and make three moving parts exactly the way the plugin (current `main`, build `2026-10-28.5`) emits them.

## What exists
- **Base paste:** `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/home-paste-v2.json`. It was built by hand from the
  live site in the plugin's structure: about 188 elements, own classes prefixed `home-`, photos already in the B-Dry
  site's Media. In it the slider, the flip boxes and the hotspot dots are still. Log: `bdry-paste/overnight-log.md`.
- **Slider-only draft:** `~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/finisher-closeout/home-paste-slider-autoplay.json`
  (sha256 `f342ff5d…`, 191 elements). Structure and geometry checks passed; motion was never seen because the renderer
  stalled (`slider-autoplay/finisher-artifact-proof/report.json`). Treat it as a draft: check it against current main's
  emitter before reusing it.
- **The source page capture (read only):** `~/.hermes/plans/figma-to-bricks/evidence/bdry-source/`: `README.md`,
  `home.html` (the popups are in it too), `tree-<width>.json` (Elementor tree with boxes, text, images, links at 1440,
  1024, 767 and 390), `body-<width>.png`, `s1440-NN.png`.
- **The project memory note** with the media ids and Justin's choices:
  `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md`. Read it first.

## The three parts (each one the plugin's own output)
1. **Hero slider plays by itself** (build 28.3, HANDOFF "A slider that plays by itself", plan
   `docs/plans/2026-10-26-slider-autoplay.md`). Justin's choices: interval 7500 / speed 2500 (Figma's wait plus the
   change), three Block slides, source-coloured arrows 25px (24 on phones), no dots, gap 0, pauses under the mouse and
   on focus.
2. **The 6 service boxes flip** (build 28.1, HANDOFF "Flip cards", CLAUDE.md "Flip cards"). The front and back come
   from the source page's flip boxes. The line icons are SVG media 149–154. Check which way the source turns them.
3. **The dots on the photo open a small card** (build 28.4, HANDOFF "Photo hotspots"). The hotspot photo is media 98.
   Under the pointer or on a tap, a card opens beside its dot. Its words and links come from the source.

The "60 Years" circle drawing itself (headline-marker) isn't released: it stays still, as in v2.

**How to make them "as the plugin emits":** prefer building a small generic Snapshot fixture for each part (the
project's test fixtures show how a slider, a flip component and a hotspot are drawn in Figma), running the current
main converter on it (`src/core/convert.ts`), and grafting the emitted elements, classes and CSS into the paste.
Rename only what would collide. If that can't express a part faithfully, write it to match the emitter's code and its
tests exactly, and say which part and why.

## Rules
- **Don't change any repo file** in `/home/justin/Documents/FigmaToBricksV2` or any worktree, and don't commit. Read
  them freely.
- **Don't touch any website:** no writes to bdry.staging.growithgro.com or any other site, no uploads, no logins.
  Reading public pages is fine. If a part needs a picture that isn't in the site's Media yet, stop and report it.
- **No clipboard or Windows Downloads writes:** the main session delivers the file.
- **Keep the rest of v2 as it is:** content, links, media, classes and spacing. It copies the live site, so the plugin's
  section rhythm (28.5) does not apply. Only the three parts change.
- **Classes:** the B-Dry site already has global classes named `section`, `container`, `h1`–`h4`, `text1`,
  `cta-btn-orange`…, so never emit a class with one of those names. Keep the `home-` prefix for the page's own classes.
- **Paste rules from CLAUDE.md:** no CSS names another element's id (Bricks renames ids; a slide's id is renamed by
  Splide too); no link inside a link; layout keys only on layout elements; no `_alignSelf: stretch`; font weights are
  single hundreds; an empty global class is `settings: []`.
- **Output:** `~/.hermes/plans/figma-to-bricks/evidence/bdry-paste/v3/home-paste-v3.json`. Put every script you write
  in `bdry-paste/v3/scripts/` as soon as you write it (a session restart empties the scratchpad).

## Checks (run them; report true results)
1. `assertPayload` and `payloadProblems` are clean. There are 0 placeholders, and no CSS or script names an element's
   id. There is no nested link, and no class name collides with the list above.
2. **Diff against v2:** list every element added, removed or changed, and show that nothing outside the three parts
   changed.
3. **Render** at 390, 767, 1024 and 1440 with the project's renderer and compare the shots with the source's
   `body-<width>.png`. On this machine use the CPU/CSS Chrome profile: a wrapper running
   `/home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"` as `CHROME_PATH`, with
   Node `/home/justin/.local/node-v22.23.3/bin` first on PATH. Details are in the memory note
   `corpus-paths-on-desktop.md` in the same memory folder. Use a short TMPDIR (Chrome's socket path limit); never
   point it into the scratchpad.
4. **Motion:**
   - the slider moves to slide 2 by itself and stops while the mouse is over it;
   - a box turns over under the pointer and on a tap;
   - a dot opens its card under the pointer and on a tap, and a tap elsewhere closes it.

   Save a shot of each. If the renderer still stalls, say so and keep the structural proof. Don't claim motion you
   didn't see.
5. No horizontal scroll at any of the four widths.

## Skills
Load and say so in one line each:
- the project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, then
  `references/rules-summary.md`;
- `engineering-best-practices`.

## Report (final message)
`{status: ready|stopped, file, sha256, elements, changes_vs_v2, parts:{slider, flip, hotspots}, checks, shots,
limits, live_checks_for_justin, skill_lessons[{skill, lesson, evidence}]}`. The `live_checks_for_justin` field is
plain steps for him: paste into the empty Home, save, then watch the slider, the boxes and the dots.

List reusable lessons in `skill_lessons`; an empty list is normal. Never edit skills or memory yourself. End with the
line `MAIN SESSION: check and save these skill_lessons now.`
