# Role: planner (plan amendments, wording only): site-media-upload

You are a fresh planner (**Opus 5.5, high**). Amend the approved plan's wording where the build, one fix round and two
reviews refined what an AC states and the reviews found the head right; change no source or test, commit nothing,
start no agents. Never edit the main folder or any worktree; never load any live site; never run the uploader; no
logins, and never look for a password or key. Work under `~/.cache/smu-pa/`.

**Skills:** `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph: an Amendments list at the top, changed lines marked, receipts encoding an old expectation
named with a sorter that really separates old heads from new, where the pre-amendment text lives, `ac-check.sh`'s
`ac_start`, `bad_id` and `live` regexes run on old and new with ids, live set and cited test names unchanged, no
Amendments-list line starting with an AC id, each cited test name whole on one line; a reviewer's suggested wording is
set against the head's real output before it is adopted).

## Inputs
- **The approved copy** (read-only, your base text; no Amendments list yet):
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/plan-approved.md` (AC1–AC16; AC15, AC16 live;
  Q1–Q11 ⭐ taken under the standing auto-go, not yet confirmed by Justin).
- Head: `c66ded408ca965502ec0f2f7c3038645cf364532` (branch `site-media-upload-fix1`, on `2879e496`; read with `git -C
  /home/justin/Documents/FigmaToBricksV2 show c66ded40:<path>`): `tools/site-upload.ts`,
  `tools/lib/site-upload/{args,guard,ask,record,pictures,summary,stop,sent,scrub}.ts`, `src/core/site/media.ts`,
  `src/ui/uploader.ts`, `test/fixtures/wp-standin.ts`, the AC tests the plan cites (`test/unit/wp-standin.test.ts`,
  `site-media-convert`, `site-media-unchanged`, `site-upload-pictures`, `site-upload-cli`, `site-upload-panel-unchanged`,
  `test/web/site-upload-page.test.ts`), the fix's tests (`site-upload-stop`, `site-upload-sent`), `docs/HANDOFF.md`
  (the site-media-upload section) and the ledger `docs/plans/2026-11-10-site-media-upload-ledger.md` ("Fix pass 1" and
  the builder's deviations list the plan lines to amend).
- Reviews 1 and 2 (`evidence/site-media-upload/review-{1,2}/review.json`; 2 is clean), the builder's and fixer's
  receipts (`builder/`, `fixer-1/`), `evidence/site-media-upload/follow-ups.md`, and the planner's WordPress 6.8 source
  excerpts (`~/.cache/smu-p/`).

## What to amend
1. **AVIF (Q6 and AC1's words; the builder's deviation 1, confirmed by review 1 against WordPress's own code):**
   WordPress refuses an image type its server can't resize (`rest_upload_image_type_not_supported`) only for multipart
   uploads; the raw-body upload the panel and this tool send is accepted without sub-sizes, and a raw AVIF is refused
   only where AVIF isn't an allowed type (WordPress before 6.5, or a filter): 500 `rest_upload_sideload_error`. Q6's
   decision stands as taken (a refused picture type stops the run and says why; never a silent fallback), but its
   premise and AC1's stand-in sentence must say what WordPress really does, and what Justin gets on a host without an
   AVIF editor (the full file at every width: the same look, heavier on phones). Add under open questions, **"to be
   confirmed with Justin"**: on a refused type, stop the run (as built: every rerun stops at the same picture until the
   site allows the type) or skip the picture and name it (review 1's R1-3).
2. **A stopped run (AC11; fix round 1, review 1's R1-1, Justin's standing "fix what you find"):** the killed-run
   sentence allowed the duplicate the fix removes. State the rule as the head has it: a stop the tool can hear
   (Ctrl+C, a kill, a closed window) starts no new upload, waits at most 65 s for those in flight, records every
   answer, writes the pastes as a half-way run does, and exits 130 / 143 / 129; after a stop it can't hear, the next
   run reads the library's 100 newest items once and, with no login, the file of each item named as WordPress would
   name it, taking an item only when its bytes are the picture's; the test's oracle is "the rerun sends 6 minus what
   the library holds, and each file is in the library once". Known limits, as HANDOFF has them (not among the 100
   newest; media on another address; a file rewritten after upload: one duplicate, cured by deleting the `-1` copy).
   Check AC9's words against this (a rerun with nothing waiting reads no library list and sends GETs only).
3. **What the tool prints (AC8's words; review 1's R1-2):** every line the tool prints passes a scrubber that removes
   the password as typed and without spaces, the encoded login in its encodings, and anything shaped `Basic <b64>` or
   an `Authorization:` header; the paste files and `media.json` never pass through it.
4. **Redirects (AC10's words; R1-8):** the tool asks with redirects off and refuses any 3xx itself, naming the route
   and where it goes; nothing is followed; a refused upload counts no picture as sent.
5. **The builder's other deviations the reviews upheld:** `sourceUrl` is set on a part only when that part shows a
   library picture (AC2 / AC3 / AC4's words); AC14's fixture server stays up and "the upload never asked the old site"
   is proven by its request log; the alt rule as Bricks prints it (an empty Custom alt prints as none, so an element
   whose own alt is empty over a library alt with words shows the library's words, named in the notes: Q7's words).
6. Any other AC line or rule line the head makes false (read both reviews' findings, the follow-ups and HANDOFF's "not
   yet confirmed" lines against each AC): mark it, say which finding it follows. The plan's paste-check id sentence
   (it names 3ds, taken by staging-fit-renderer): "the next free id at the merge".
- Don't add, remove or renumber an AC; keep every cited test name; put a cited name the approved copy wraps over two
  lines whole on one line (say which). Name supporting tests under the AC they support ("never a report's cited
  test"). Keep the rule-change paragraph (the one tool allowed to write to WordPress: only adds media, only on the
  typed site, only after a typed `yes`, only Justin runs it; agents use the local stand-in and never hold a password)
  exactly as approved.

## Output
1. `/home/justin/.hermes/plans/figma-to-bricks/site-media-upload-amended.md` (the whole plan). Don't touch
   `plan-approved.md`.
2. The regex checks' output (old vs new) and `ac-check`'s whole-line match for each cited name.

## Report (as text)
The amendments one line each, what is marked "to be confirmed with Justin", receipts that encode an old expectation
(with the sorter run on the job's heads `ff35a890` and `c66ded40`), the regex check; then `skill_lessons[{skill,
lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory), ending with:
`MAIN SESSION: check and save these skill_lessons now.`
