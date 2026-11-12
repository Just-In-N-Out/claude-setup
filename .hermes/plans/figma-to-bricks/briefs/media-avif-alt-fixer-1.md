# Role: fixer (Full fix round 1): media-avif-alt — R1-1 (P1) and R1-2 (P2)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify each finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, `security-best-practices`, `authorized-write-safety`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load any live site; never call
the real alttext.ai; never write to any WordPress site; run the tools only against the tests' 127.0.0.1 stand-ins; touch nothing
under `~/Downloads`. Commit to the branch only; don't push; don't bump BUILD; don't edit the main folder or CLAUDE.md; never bare
`git stash`.

## Findings (review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/media-avif-alt/review-1/review.json`; probes in
`/home/justin/.cache/mar/review-1-probes/`)
- **R1-1, P1, `tools/lib/site-upload/alt-ai.ts:58`** (ids from `media-steps.ts:44`): alttext.ai's words are written on whatever
  item now has the record's id; `url`/`filename` never compared. A restored or re-cloned site → foreign items get Justin's alt text
  (probe A: `POST wp/v2/media/11..13` on three foreign `team-photo-*.png`). Fix: read `source_url` (and the file name) in the same
  GET and describe/write only when it matches the record's entry; a mismatch is named in the output (never written), and the
  record entry is treated as unknown (say what the run does with it — ⭐ leave it, name it, no write, no re-upload unless the
  picture is otherwise due).
- **R1-2, P2, `tools/lib/site-upload/ai-key.ts:81`:** the key question uses `prompter.hidden()`, which keeps typed-ahead input; an
  extra Enter after the password answers it ("No AI alt text this run."). Fix: drop typed-ahead input before the key question shows
  (a fresh mode for `hidden()`, as `line()` has: `ask.ts:81-103`); the password prompt keeps its behaviour.
- Take if cheap: **R1-4** (a key refused mid-run says to run again with `--new-ai-key`, not the panel's box), **R1-7** (create
  `~/.config/figma-to-bricks` 0700 when this tool creates it; never chmod an existing folder Justin owns — say so).

## Do
1. Your own worktree: `git checkout -B media-avif-alt-fix1 23615bb9dc8066f7fe6d9e578dacf40887f4eaaf`.
2. RED first for each: a test in `test/web/site-upload-ai-alt.test.ts` (a record id whose library item is another file: no `POST
   wp/v2/media/<id>`, the mismatch named) and one in the prompt tests (typed-ahead Enter after the password: the key question still
   waits). Then GREEN. Mutants: drop the match → RED; keep typed-ahead → RED.
3. Gates: `npm run check` (8G scope); the story's web files (`site-upload-avif`, `site-upload-ai-alt`, `site-upload-secrets`,
   `site-import-avif`, `site-upload-picture-chrome`) and `site-import-dry-run`, `site-import-yes` under 4G scopes; story pins with
   `F2B_STORY_PINS=1`. Record in the ledger and HANDOFF (the paste check stays `<id at merge>`). Stop at `ready-for-next-review`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` under 31 characters (`~/.cache/maf/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`). Write scripts with the Write tool, run as plain `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. Stop shared stand-in servers in one outer `finally`.
SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending
SIG[A-Z]* to process'` first.

## Report (as text)
Branch, head; each finding verified, RED, GREEN, mutant; R1-4/R1-7 taken or not; gates; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
