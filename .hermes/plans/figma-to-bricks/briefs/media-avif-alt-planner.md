# Role: planner (Full): media-avif-alt — a scanned page's photos go up as AVIF, and pictures with no alt text get AI alt text

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com** (its bot check; Justin's rule), B-Dry staging or any live site; no logins;
never write to any WordPress site; **never call the real alttext.ai** (nothing paid; no key). Read-only on
`~/Downloads`.

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`,
`security-best-practices` and `authorized-write-safety` (this writes to WordPress and holds a paid key). Read the repo's
`CLAUDE.md` (main folder `/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.3, `02481763`), especially
"One uploader writes to WordPress…" and the decision "A scanned page's pictures go to WordPress from the command line",
and `docs/HANDOFF.md`'s site-media-upload and site-one-command sections.

## What Justin asked (his words, 2026-11-11; "font" is his voice note for "format")
"for the media part of the importer, when we pull them I need the font to be a .avif format For every photo … Also, for
images without alt text, make it so it asks for an API to implement alt text for them."
His answers (in questions): **Full**; **"Photos + PNG pictures"** — JPEG, PNG and WebP pictures go up as AVIF (AVIF
keeps see-through parts); SVG and animated GIF stay as served; **"Ask once, save it"** — the alt-text service key
(alttext.ai, which the Figma panel already uses: project decision "AI picture descriptions with alttext.ai",
`~/.hermes/skills/software-development/figma-to-bricks/references/project-decisions.md`) is asked once and saved on this
computer, so he types it only once.

This **reverses two of his earlier rulings** for `site:upload` / `site:import` (`tools/lib/site-upload/`): Q6 A "files as
served, never re-encoded" and Q8 A "no alttext.ai". Everything else of those rulings stands: only adds media items; only
on the typed site; https, the site read first, a typed `yes` after everything is shown; the old site's first alt with
words in Media, an alt already in WordPress never changed by a re-run (Q7 A); a stopped run keeps what went up and the
next sends the rest (Q11 A); the record per computer (Q9 A); the password at a hidden prompt, never saved, never printed.
Also the standing decision: **"Photos as AVIF: never fall back silently to WebP or the original; stop and explain."**
The repo rule: no runtime dependencies (dev dependencies only; browser tools use Node built-ins and the system Chrome).

## The plan must settle (with file:line evidence)
1. **How AVIF is made without a runtime dependency:** how the Figma panel encodes AVIF today (`src/ui/…`; find it) and
   whether the command can reuse it (the system Chrome over CDP, a WASM encoder already in the repo, …); quality and size
   as the panel's; transparency kept; the picture's pixel size unchanged (or the panel's 2x-of-shown rule? ⭐ recommend
   unchanged size: the command doesn't know the shown size at every width); EXIF orientation; colour profile; an
   animated WebP (⭐ stays as served, like an animated GIF); a picture that fails to encode → stop and explain, never a
   silent fallback. File names end `.avif` and keep the `-image` suffix rule (CLAUDE.md "A WordPress upload attached to
   no page owns the address…").
2. **Re-runs and the record:** a picture already uploaded as served by an earlier run (Justin's 34 on B-Dry staging,
   media 174–207) — ⭐ recommend: a re-run uploads nothing again (the record keys the source file; the existing item is
   reused as is) and says how many stay non-AVIF, with a flag (`--reupload-avif`?) to send AVIF copies; never deletes or
   changes the old items. media.json and the pastes point at the AVIF item.
3. **AI alt text:** which pictures (no alt with words on the old site and none in WordPress; never decorative ones the
   site marks `alt=""`? ⭐ decide and say why), when it is asked (before the typed `yes`, with the count and the credit
   cost per picture shown), where the key is saved (`~/.config/figma-to-bricks/`, mode 0600, never printed, never in an
   argument, variable, the record, the capture, the paste, a log or a scrubbed line; how to replace or forget it), what
   happens when the key is missing (asked once; Enter skips AI alt text that run), wrong (stops before any upload? ⭐),
   out of credits or the service is down mid-run (pictures go up without alt, named, and a later run fills them?), the
   language, alttext.ai's API exactly as their docs / the panel's existing client use it (read the panel's code; a
   stand-in answers as alttext.ai does, read from that code or their docs, never from what the new code expects). Whether
   the alt is written on the media item at upload (the REST `alt_text` field) and how it's shown in the plan before
   `yes`. Note: Justin's sites may run the AltText.ai WordPress plugin, which can describe uploads itself — say how the
   two meet (⭐ the command's alt wins only where WordPress has none).
4. **Security:** the key and the password never reach Chrome, the scan, logs or printed lines (`site-upload`'s scrubber);
   the saved key file's permissions; an agent never holds Justin's real key or password; tests run only against
   `test/fixtures/wp-standin.ts` and a new local alttext.ai stand-in.
5. **Byte-for-byte:** `capture`, `capture:check`, `site`, the helper, the Figma plugin and the panel unchanged; `site:upload`
   and `site:import` change only in format, alt and the new key prompt; `--dry-run` sends nothing (no WordPress, no
   alttext.ai) and says what it would do.
6. **Numbered ACs, AC1, AC2…, each with one named test** (each name whole on one line; a line that isn't an AC's
   definition never starts with a list marker followed by `AC<n>`); mark ACs **proposed**; `(live)` ACs: Justin's own
   `site:import` run against B-Dry staging shows the photos as `.avif` in Media with alt text on those that had none,
   and the pastes show them.

## Write
`~/.hermes/plans/figma-to-bricks/media-avif-alt.md` (the builder copies it to `docs/plans/2026-11-11-media-avif-alt.md`):
playback in 3 plain lines, questions at the top with ⭐ answers (Justin's standing auto-go runs the builder at once on
them), the design, ACs, touched files, tasks, a Docs & records task (HANDOFF section; CLAUDE.md's uploader rule and the
media decision change: Q6 and Q8 reversed). Evidence under `~/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/maa/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`). One plain git command per call, `git -C <absolute path>`. Use `tail -n 3`. Waits under
115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E
'sending SIG[A-Z]* to process'` first.

## Report (as text)
The plan's path; the playback; the AVIF route; the alt-text design; the ACs one line each (live ones named); questions
with ⭐; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
