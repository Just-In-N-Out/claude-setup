# Role: planner (Mini): site-scroll-lock — every website-importer paste locks sideways scrolling

You are a fresh planner for FigmaToBricksV2 (**Fable 5.2, high**). Plan only: change no source or test, commit nothing,
start no agents. **Never load bdryswi.com** (its bot check; Justin's rule), B-Dry staging or any live site; no logins;
never write to any WordPress site. Nothing paid.

Load the skills `figma-to-bricks` (project skill), `engineering-best-practices`, `implementation-planning`. Mini mode
(`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/mini-pipeline.md`): load the project skill and only
the code/docs sections this touches; skip the full Step 1 context load; finish within about 15 steps. If this is bigger
or riskier than a Mini job, say so in your report and recommend Full. Read the repo's `CLAUDE.md` (main folder
`/home/justin/Documents/FigmaToBricksV2`, `main` at Build 2026-11-11.3, `02481763`).

## What Justin asked (his words, 2026-11-11)
"on mobile and parts i need to lock in horizontal scroll, so please for the website importer that scans and all add this
to the code so horizontal scrolling is not a thing"
He pasted this, which he otherwise adds in WordPress → Appearance → Additional CSS:
```
html, body {
    max-width: 100%;
    overflow-x: hidden;
}
```
His answers (in questions): **Mini**; and **"Use clip instead"**: if plain `overflow-x: hidden` on html and body stops a
sticky header from sticking (it can: hidden on body, with html also not visible, makes body a scroll container, so
`position: sticky` in it no longer sticks to the viewport), the paste locks sideways scroll with `overflow-x: clip`
(which makes no scroll container), with a `hidden` fallback only for browsers without `clip` if that can be done without
breaking sticky in browsers that have it. Prove which form keeps a sticky header sticking (Bricks' sticky header as
Bricks 2.4.2 prints it, and a plain `position: sticky` bar) AND stops sideways scroll, in the repo's test renderer
(`test/browser/render.ts`, Chrome over CDP), with an element wider than the screen at 390.

## The plan must settle (with file:line evidence)
1. **Where the rule goes** so every website-importer paste carries it once: the code route (`npm run site`,
   `site:upload`, `site:import` — `src/core/site/…`) and the Figma panel's website route if it writes its own payload.
   Find what already holds page-wide CSS there (e.g. the site-reset class / `site-fonts` / a page-level custom CSS) and
   how Bricks 2.4.2 prints it (does a `html, body {…}` selector survive in that spot as written? `%root%`? read
   `reference/bricks/README.md` and the renderer). One copy per page even when header, page and footer are pasted as
   separate pastes (Justin pastes three; a whole-page paste too) — or say why a repeat is harmless.
2. **Figma designs:** ask with a ⭐ answer whether the Figma plugin's own pastes get it too ("and all" is ambiguous).
   ⭐ recommend: website importer routes only; Figma pastes stay byte for byte as before (say why in one line, and that
   it is a one-line follow-up if he wants it).
3. **What the lock does not do**, in one plain line for Justin: it hides overflow, it doesn't fix the element that is too
   wide (content past the right edge is cut off); whether `site:check`/the lint still reports such overflow (it should).
4. Byte-for-byte: pastes change only by the added rule; Figma designs unchanged; `npm run check`, `npm run corpus`,
   `test/unit/site-no-revert.test.ts` and its golden (`node tools/site-no-revert-golden.ts .` if the job changes what a
   site paste writes) and `src/plugin/convert.ts` ≡ replay hold.
5. **Numbered ACs, AC1, AC2…, each with one named test** (each name whole on one line; a line that isn't an AC's
   definition never starts with a list marker followed by `AC<n>`), all marked **proposed**: at least — the paste holds
   the rule once; at 390 a wider-than-screen element gives no sideways scroll (`scrollWidth`/`scrollX` after a sideways
   scroll attempt) in the renderer; a sticky header and a sticky bar still stick after a vertical scroll; Figma pastes
   byte for byte; one `(live)` AC: Justin re-pastes on B-Dry staging and on his phone the page doesn't move sideways and
   the header still sticks.

## Write
`~/.hermes/plans/figma-to-bricks/site-scroll-lock.md` (the builder copies it to
`docs/plans/2026-11-11-site-scroll-lock.md`): playback in 3 plain lines, questions at the top with ⭐ answers (Justin's
standing auto-go runs the builder at once on them), the fix, ACs, touched files, tasks, a one-line Docs & records task
(HANDOFF section). Planner evidence under `~/.hermes/plans/figma-to-bricks/evidence/site-scroll-lock/planner/`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/ssl/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start (by the PIDs of its own
profile path; never `pkill -f`; other agents and Justin run Chrome too). One plain git command per call, `git -C
<absolute path>`. Use `tail -n 3`. Waits under 115 s. A command that dies with SIGTERM/143/137/"Killed" may be an
earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`
before reading it as a result.

## Report (as text)
The plan's path; the playback; where the rule goes and the clip-vs-hidden proof; the ACs one line each (the live one
named); questions with ⭐; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or
memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
