# BUILDER brief: tennis-booking (Full pipeline)

**Role:** BUILDER for the new personal project "tennis-booking". Build the approved plan test-first, then stop at `ready-for-review`. Do not merge, push or deploy.

## Inputs
- Approved plan (read-only, the contract): `~/.hermes/plans/tennis-booking/evidence/tennis-booking/plan-approved.md`. Its `## Justin's answers (2026-11-21)` and `## Amendments` sections are part of it: every recommended answer, except **Q1 = C (no domain: the email goes to `OWNER_EMAIL` only, and Justin forwards it)**, and Q8 = Full. Build ACs AC1–AC14 as written there. AC13 and AC14 are `(live)`: Justin checks them after deploy, so you only prepare for them (README steps).
- Repo: create `/home/justin/tennis-booking` (new; personal identity `Justin <issajustin04@gmail.com>` comes from the global git config; never pass `-c user.*`, `--author` or author env vars).
- Evidence folder: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`. Write builder receipts under `builder/` there: one test-run capture and **one screenshot per AC** (a terminal capture of the test run for an AC with nothing visual), named `AC<n>-...`.
- Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the BUILDER parts) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` before you start. No project skill exists yet, so there is no project `repeat-mistakes.md`.

## Git layout
- `git init -b main`; the **base commit** on `main` holds only `.gitignore` (as the plan says, so every AC test fails on the old code). Record its SHA in your report as `base`.
- Build on branch `feat/tennis-booking` off that base, in small test-first commits. Plain `git commit -m "..."`: no `Co-Authored-By` or any AI attribution line (a hook refuses them). Never commit a `CLAUDE.md`; if one appears, add it to `.git/info/exclude`.
- Never commit secrets or real email addresses; `.env*` (except `.env.example`) ignored.

## Skills (load each with the Skill tool and say so in your first steps)
`engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the key guard, the validation, the throttle), `build-validate-apis`, `security-best-practices` (with its JavaScript frontend and backend references), `ux-frontend-workbench`, `frontend-testing-workflow`, `git-commit-rules`. Use `systematic-debugging` whenever a test fails unexpectedly.

## Known blocker: the test browser
Chrome for Testing at `~/.cache/chrome-for-testing/...` can't start yet: `libnss3 libnspr4 libasound2t64` are not installed (checked 12:55, `dpkg -s` showed none). Justin has been asked to install them (sudo; you can't). Do the endpoint and library work (node:test) first. Before the browser tests, check again with `dpkg -s libnss3 libnspr4 libasound2t64`. If they are still missing when nothing else is left, stop with `status: blocked`, `stop_reason: browser libraries missing`, and everything else committed. Don't work around it with a different browser install or LD_LIBRARY_PATH hacks unless that is trivial and leaves no system changes.

## Rules
- The plan wins on scope; don't add features. Copy text comes from the plan's copy deck, exactly. The humor is dry, never cringe.
- Confirm the two Resend field spellings (`reply_to`, the attachment content-type field) in Resend's API reference before writing the AC5 test, as the plan says. Record what you found.
- **Memory (Windows desktop):** run browser tests and any mutation run under a cap: `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill, not a result: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Long waits: Claude Code moves a foreground Bash command to the background after about 180 s, so poll in steps under 3 minutes with the Bash `timeout` set above them; don't end your turn waiting for a background job.
- Run the whole suite (unit + browser + axe) at the end and capture it.
- If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity).
- **skill_lessons:** list reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce`: `none`, or a one-line proposal for a check that would have caught a broken or nearly broken rule: kind, what it checks, where it runs). Never edit skills or memory. An empty list is normal.

## Output
`{status: ready-for-review|blocked|stopped, stop_reason, repo, branch, base, head, commits[], ac_status[{ac, test, screenshot, result}], resend_fields_confirmed, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
