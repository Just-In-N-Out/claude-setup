# Role: reviewer (Full round 1, the whole story; report only): site-media-upload

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`).

## The one rule above all others in this job
This job builds the first tool that writes to WordPress (`npm run site:upload`). **You never run it, or any upload,
against a real site: not Justin's staging, not bdryswi.com, not any host that isn't 127.0.0.1 / localhost.** Every run
of the uploader talks only to the local WordPress stand-in (`test/fixtures/wp-standin.ts`) or a stand-in of your own on
127.0.0.1. **You use no login, no Application Password and no key of any kind, and you never ask for, look for, read or
print one** (not from the environment, the repo, `.git/config`, a credential helper, a file under the home folder, or
the panel's storage): probes use made-up passwords that exist only in the probe. Never load bdryswi.com, B-Dry staging
or any live site; read-only GETs of WordPress's or Bricks' public source code are fine. Justin's standing rule — "Never
write to any WordPress site; GET/read only, and ask me before using any login." — binds you fully; only Justin, in his
own terminal, ever runs the finished tool against his site (the plan's live ACs).

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"; one real-bug review per job):**
report as P0–P2 only bugs a real site or normal use hits (Justin running `npm run site:upload` on a real capture
against his own WordPress, then pasting into Bricks 2.3.9 / 2.4; `npm run site` and Figma designs converting as
before), each with a concrete real-use scenario. Edge cases are P3. **This job's guards are P0/P1 when they fail:**
- the password reaching any file, output, log, error text, command line, environment, record, `media.json` or paste,
  or being sent anywhere but the typed site's REST API over https;
- any write other than adding media (and the alt of a file the run just uploaded) on the typed site: a
  PUT/PATCH/DELETE, a POST to anything else, a change to a media item the run didn't create, an alt Justin edited in
  WordPress overwritten on a re-run;
- any request, with or without the password, to a host other than the typed one (a followed redirect, a site whose
  index names another address, a picture address used as a request target with credentials);
- a path that skips the typed `yes`, the login check or the terminal check; a dry run that sends or writes anything;
- `npm run site` able to reach the network or write to a site through its new `--media` flag.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/plan-approved.md`
  (AC1–AC16; AC15 and AC16 live). Justin asked for the job ("Can we make them upload to my Wordpress media library
  like how it is in the plugin?"), chose "From the command line" and the Full pipeline; the ⭐ answers Q1–Q11 are taken
  (not yet confirmed).
- Branch `site-media-upload-build`, head `ff35a890590549d922da07ec3402d5aa003237b4`, base
  `2879e4968438e7a442594d1021cb024dd85b3976` (`main` has since moved to `7eeca437`, Build 2026-11-10.4: a later step
  moves the job). In your own worktree: `git checkout --detach ff35a890590549d922da07ec3402d5aa003237b4`, confirm HEAD
  and a clean status. Review `git diff 2879e496...HEAD`.
- The builder's receipts (read, don't trust): `evidence/site-media-upload/builder/` (`red/`, `green/`, `gates/`,
  `mutation/`, `shots/`); deferred items and the builder's deviations: `evidence/site-media-upload/follow-ups.md`. The
  planner's scratch (WordPress 6.8 source excerpts): `~/.cache/smu-p/`.
- The builder's words: the tool is `tools/site-upload.ts` with `tools/lib/site-upload/{args,guard,ask,record,pictures,
  summary}.ts`; every request goes through `guardFetch` (typed origin only, `redirect: "error"`); it uploads with the
  panel's own `uploadAll` (`syncAlts: false`); the record is saved after every picture; the converter's media map is
  `src/core/site/media.ts` with hooks in `kinds.ts`, `convert.ts`, `parts.ts`; `npm run site --media <file>` only reads
  a local file; the stand-in `test/fixtures/wp-standin.ts` cites WordPress 6.8 lines; fixture site `media-page`.
  **Its deviations, each for you to judge:** (1) AC1's AVIF wording: WordPress refuses an unresizable image type only
  for multipart uploads, so the raw-body upload of an AVIF is accepted without sub-sizes (check this against
  WordPress's own code yourself; if right, the plan's Q6 words need amending and the summary Justin reads must say what
  really happens: is a picture with no sub-sizes fine for his page?); (2) `sourceUrl` is set on a part only when that
  part shows a library picture; (3) AC14's fixture server stays up, "the upload never asked the old site" proven by
  its request log; (4) the fixture's photo row uses `flex: 1 1 0`; (5) Task 6's modules were written before their
  tests (RED = module missing; the mutants are the sensitivity proof): do the tests really fail for each behaviour?

## Check hardest (probe with your own stand-in on 127.0.0.1 that records every request, header and body; and your own
page; never a real site)
1. **The password.** Type a made-up one through a pseudo-terminal: grep everything the tool wrote (record, `media.json`,
   pastes, summary, any temp file, the out folder, the config folder under a scratch `HOME`), everything it printed
   (stdout, stderr, on success, on a wrong password, on a 401/403/500 with WordPress's JSON error echoed back, on a
   network error, on Ctrl+C, on an uncaught exception with a stack), `/proc/<pid>/cmdline` and `environ` of the tool
   and its children while it runs, for the password as typed, with spaces removed, and inside the Basic
   `user:password` base64. Is it echoed while typed (raw mode restored after Ctrl+C: the terminal isn't left without
   echo)? Does a pasted password with a trailing newline or CR work? Is it held longer than needed, or passed to any
   module that logs?
2. **Where requests go.** A stand-in that answers the index with a 301/302/307/308 to another origin, to http, to
   another path; an index whose `url` / `home` / `_links` name another host, another folder, another scheme; a media
   answer whose `source_url` or `Location` is on another host; a `Link` header; a stand-in that answers the upload
   with a redirect. Does any request leave the typed origin, and does the Authorization header ever go with it? A
   site address typed with a path, a port, a trailing slash, upper case, `www.` against no `www.`, an IDN, `user:pass@`.
3. **Only adds media.** From the stand-in's log over a first run, a second run, a run killed half-way (SIGINT, SIGTERM,
   SIGKILL, a power loss between the upload and the record's save) and its rerun: every method and path. Is anything
   but GET and the media POST (plus the alt of a just-uploaded file) ever sent? Is a duplicate ever uploaded (the
   record lost or stale; the same picture under two addresses; two pictures with one file name; a file name with
   spaces, non-ASCII or no extension; the `-image` suffix rule of the repo's CLAUDE.md: an upload attached to no page
   owns `/<its file name>/`)? Is an alt edited in WordPress ever changed on a re-run? A record pointing at a media item
   deleted in WordPress since?
4. **The paste.** Each uploaded picture is a library picture (`id`, the site's own URL, no old address left) in Image
   elements and in CSS backgrounds/masks, both text modes, `--elementor` and plain, every part; `sourceUrl` is the
   typed site so Bricks keeps the pictures (the repo's "Bricks swaps pasted pictures for its grey placeholder" rule),
   and on a part with no library picture the paste is byte for byte as without the map; srcset/sizes and
   width/height: does a library picture still draw at the old page's size at every width (AC14), with and without
   sub-sizes? A picture the upload left out (another company's script drew it, no bytes in the capture, SVG without
   `--svg`) keeps its old address and is named, once, in plain words. Without `--media` every paste is byte for byte as
   base (AC4) and Figma designs too (AC13); the panel's uploads send the same requests as on main (AC12).
5. **What Justin sees and types.** Run the whole flow on the stand-in through a pseudo-terminal as he would: are the
   lines plain, in order, naming the site and the count before the password is asked; is a refusal one plain line
   saying what to do; are exit codes as the plan says; does the summary say what stayed on its old address and why?
   Read HANDOFF's numbered steps for the live check against what the tool really prints.
6. **The stand-in is honest (AC1):** spot-check five of its answers against WordPress's own source (the planner's
   excerpts or the public repository): status codes, error codes, the media item's shape, Application Password auth,
   what a wrong password answers.
7. The tests can fail (read the mutant receipts; two or three mutants of your own on the guards under
   `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`); the story pins (AC4, AC12, AC13) are honest and
   don't run in the default suite after the merge in a way that breaks the next job.
8. Overlap with jobs about to merge under it (site-native-structure: `convert.ts`, `parts.ts`, the linked picture's
   Image settings in `elementor-fold.ts`; site-menu: `kinds.ts` beside the img branch): does the media map reach a
   linked Image made by the fold, or only `kinds.ts`'s `<img>` branch? (A P3 note for the later stack step unless it is
   wrong on this head.)

## Work
Load `requesting-code-review`, `code-review-practice` and `security-best-practices` (credential handling in a CLI);
read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with
`references/testing-pitfalls.md` and `references/live-site-reading.md`, the repo `CLAUDE.md` (the upload, picture and
WordPress rules) and `reference/bricks/README.md` ("Paste rules"); read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole story for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   2879e4968438e7a442594d1021cb024dd85b3976 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-media-upload` (exit
   2 means your file is wrong: fix it). Put nothing password-shaped in any file you write.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/smu-r1/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after. A worktree's `node_modules` may lack `.bin`, and a `git archive`
  scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
  PATH and symlink the main folder's `node_modules` in). Scripts written with Write; probes and logs under
  `~/.cache/smu-r1/` (a restart empties `/tmp`). The tool's record file belongs under a scratch `HOME` / config folder
  in your probes, never the real `~/.config/figma-to-bricks/`.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under the 4 GB cap. Waits under 115 s. The PC loses power now and then: keep your
  notes and finished probe results on disk as you go; when resumed, read them first.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), your reading of each builder deviation, `verdict`,
`ac_status` (per AC: what the review saw), a line confirming you ran the uploader against nothing but a 127.0.0.1
stand-in and used no real login, then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is
normal; `enforce` is `none` or a one-line check proposal; never edit skills or memory), ending with: `MAIN SESSION:
check and save these skill_lessons now.`
