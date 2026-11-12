# Role: verifier (read-only): site-native-structure on its stacked head

You are a fresh verifier who never saw the build, the moves, the fixes or the reviews (**Opus 5.5, high**). Prove each
acceptance criterion yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or
other worktrees (read them with `git show`). **Never load bdryswi.com, B-Dry staging** or any live site (local stand-ins
and saved files only); no logins; never write to any WordPress site. Nothing may hide that the importer's Chrome is
automated. Never stop a Chrome you didn't start; touch nothing under `~/Downloads`.

**Before you write anything:** `evidence/site-native-structure/verifier/` must not exist or must be empty; if another agent
is writing there, stop and hand back.

**Skills to load:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job
and the `ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (the
stack-move line: run named-only tests by name), `references/live-site-reading.md`, `references/rendering-validation.md`;
`reference/bricks/README.md`. Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Inputs
- Approved plan (read-only, amendment 2): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live: `not_run`, owed). The job: the website importer's `--elementor` paste becomes Bricks' Section /
  Container / Block, Heading, Button, Divider and linked Image; a part's root that draws nothing is "lifted"; the plain
  route byte for byte. Find every cited test name with ac-check's own grep first; read each cited test before running it;
  **named-only tests run by name with their variables** (AC13 `F2B_PIN_BASE=1`; AC14 `F2B_CODE_PROOF_BDRY`,
  `F2B_CODE_PROOF_CAPTURE`, `F2B_ELEMENTOR_STANDIN` = `evidence/site-native-structure/inputs/standin-capture-b2435de.json`,
  sha256 `462f292d20eee2292c8f1b21db745ddde09be4a6f1f7059dab2752277f3e0f6d` — check it), each printing its own `ok` line,
  never `# SKIP`.
- Head **`d6f169848744d4f23f8dd2a8b2b6787dae1872f7`** (branch `site-native-structure-final2`), base **`4f8b61165d98002e64f97aa2e4330f6cf9801c1d`**
  (main, Build 2026-11-11.10). In your own worktree: `git checkout
  --detach d6f16984…`, confirm HEAD and a clean status. Old code: a `git archive` of `4f8b6116` with head's test files,
  fixtures and test-only modules copied in (a new module that doesn't import on base is weak RED: prove the test can fail
  with a one-line mutant; preservation ACs that rightly pass on base are `base_exempt` with a reason and your own byte
  receipt). An AC log cited in `ac.json` starts with the bare `HEAD=<sha>` (say "archive" on its second line) and ends with
  one line `EXIT=`, skipped 0.
- **Known, not this job's:** five browser files fail on main on this desktop (composition-clipping, fonts, hero-pair,
  peer-sides, pill-holder); flakes under load: `capture-opens-guards`, `site-upload-stop` R1-1, `site-motion-flat`: rerun
  alone before judging. Recorded P3s: `follow-ups.md` (R5-*, R6-1, R7-*, R8-*); flaky under load: site-elementor-button AC7 at-rest picture, render-site-motion, strips.
- Don't read builders', fixers', reviewers' or planners' reports or folders as proof.

## Work
1. **Gates on head against base by name:** both typechecks, `npm run check` (8G scope), `npm run corpus` (same as base),
   the **full** `test:web` and `test:browser` file by file, each alone under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0` (B-Dry files 8G), compared with base by name (run base's side for every file whose result differs).
   Five Figma replays and `dist/` byte-identical to base's build; `test/unit/plugin-convert.test.ts`.
2. Every AC's named test on head (pass) and on old code; a picture per AC (AC14: B-Dry's header, page, footer site |
   paste at 1440, 1025, 768, 390; AC6/AC10: the Structure tree of a pasted Elementor section, before and after).
3. Beyond the fixtures: one Elementor page of your own on a local server (a header with a ☰ that opens a pop-up, a
   button row, a linked logo, a FAQ, a carousel): paste with `--elementor`, draw as Bricks 2.4.2 and 2.3.9 at 1440 and 390,
   Structure tree and the open/close of the pop-up.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/verifier/ac.json` and logs in that
   folder; self-check with `ac-check.sh` on a copy (`--base 4f8b61165d98002e64f97aa2e4330f6cf9801c1d`, no `--reviews`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/snv3/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). A `git archive` tree needs main's `node_modules` symlinked and its `.bin` on
PATH; piped/chained git commands may be refused (script files, `bash <file>`; `git -C <absolute path>`). Use `tail -n 3`.
Never edit a tree a test is running against. Scripts and logs under `~/.cache/sn-verifier3/`. Waits under 115 s; long
drivers with `setsid --fork`, waiting on `^EXIT=`; write each log's `EXIT=` line; when resumed, read finished logs first.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending
SIG[A-Z]* to process'` first and rerun alone under a cap. Many agents run at once: run one Chrome suite at a time.

## Report (as text; only ac.json and logs are written)
Per AC: test, head result, old-code result (or the mutant), evidence path; gates against base by name; your own page's
result; `verdict`; `ac_status`; then `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit
skills or memory), ending with `MAIN SESSION: check and save these skill_lessons now.`

## Added for this head
This head sits on main `4f8b6116`, holding today's merged jobs (scroll lock, sticky header with its stay class, menu slide, media
background settings, footer one-name sides, AVIF uploader). Amendment 3 v2 adds AC2's kept-header exception (a sticky header keeps one
"Header" Block only where two pasted top Sections show at one width) and AC15's B-Dry step (two top Sections, the bar for each width at the
top). Prove every AC on this head with those jobs present; your own Elementor page should include a sticky header with two bars shown
together and one with a desktop/phone pair. Named-only tests that fail on main too (`site-scroll-lock-base`, `site-opens-old`,
`site-motion-old`) are main's: say so with a main run. **`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b` on every browser run;
plain `git` in your own worktree.**
