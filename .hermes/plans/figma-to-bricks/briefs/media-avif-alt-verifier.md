# Role: verifier (read-only): media-avif-alt

You are a fresh verifier who never saw the build, the fix or the reviews (**Opus 5.5, high**). Prove each acceptance criterion
yourself. Change no source or test, commit nothing, start no agents. Never edit the main folder or other worktrees. Never load any
live site; no logins; **never call the real alttext.ai**; never write to any WordPress site; run `site:upload`/`site:import` only
against the tests' 127.0.0.1 stand-ins; touch nothing under `~/Downloads`. The verifier folder
`evidence/media-avif-alt/verifier/` is empty: check before writing.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (your job and the `ac.json`
format at the top of `scripts/ac-check.sh`) and follow it; `security-best-practices`, `authorized-write-safety`; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Don't read the builder's, fixer's or
reviewers' reports or folders as proof.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/plan-approved.md` (AC1–AC17; AC16,
  AC17 live: `not_run`). Story pins run by name with `F2B_STORY_PINS=1` and `F2B_BASE_TREE` = a fresh `git archive` of the base with
  main's `node_modules` linked; each prints its own `ok`, never `# SKIP`.
- Head `caf9291f681e1b6fed7862de125dddb40084da21` (branch `media-avif-alt-fix1`), base `0248176342c662b821629d462f4d15a2a2a1df98`. In
  your own worktree: `git checkout --detach caf9291f…`, clean status. Old code: a `git archive` of `02481763` with head's test files,
  fixtures and stand-ins copied in (a new module that doesn't import on base is weak RED: prove the test can fail with a one-line
  mutant). An AC log cited in `ac.json` starts with `HEAD=<sha>` (say "archive" on its second line) and ends with `EXIT=`, skipped 0.

## Work
1. Gates on head against base by name: both typechecks, `npm run check` (8G scope), the story's web files and the uploader's existing
   web files (`site-upload-*`, `site-import-*`, `media-avif-*`) each alone under `systemd-run --user --scope -p MemoryMax=4G -p
   MemorySwapMax=0`; `git diff 02481763 caf9291f -- src/` empty (AC15); `dist/` byte-identical to base's build.
2. Every AC's test on head (pass) and on old code; a terminal capture per AC (the printed run: the list before the yes with AVIF and
   stays-as-served lines, the credits line, the key prompt, a stop line).
3. Beyond the fixtures, your own checks: a folder of real-world pictures (JPEG with EXIF rotation, a see-through PNG, a WebP, an
   animated GIF, a 16-bit PNG, a 5000 px photo) through `site:upload` against `wp-standin.ts` + the alttext.ai stand-in — what goes up
   (`.avif`, sizes, alpha), what stays, what gets alt text; the secret sweep yourself (the key and the password absent from every file
   the run left, stdout/stderr, `/proc` of the tool and its Chromes); a stale record (ids now holding other files): no alt written.
4. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/verifier/ac.json` and logs there; self-check with
   `ac-check.sh` on a copy (`--base 0248176342c662b821629d462f4d15a2a2a1df98`, no `--reviews`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` under 31 characters (`~/.cache/mav/t1`; Chrome's "Socket path
too long"); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`). Write scripts with the Write tool, run as plain `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u
earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), evidence; gates; your own checks; `verdict`; `ac_status`; `skill_lessons[{skill, lesson,
evidence, enforce}]` (empty is normal), ending with `MAIN SESSION: check and save these skill_lessons now.`
