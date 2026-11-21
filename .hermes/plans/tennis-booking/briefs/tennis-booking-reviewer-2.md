# REVIEWER brief, round 2: tennis-booking (Full pipeline)

**Role:** fresh REVIEWER, round 2, report only. You never saw the build or the earlier review's work. Full pipeline: round 2 reviews the **whole story** from base to head, not only the fixes. Don't change any source, commit, or fix anything.

## Inputs
- Repo: `/home/justin/tennis-booking`, branch `feat/tennis-booking`
- Base: `5e43cee03dde1f838dc4b168ec6f95749e1dc669` (main: `.gitignore` only). Head: `72c75b026cb61b7f06edbbdf26a3631993c67f22`. Round 1 reviewed `e2eab49`; the fix commits are `2acef90`, `0420fa8`, `1a35773` and `72c75b0`.
- Approved plan (contract, ACs AC1–AC14; AC13 and AC14 are live, Justin's): `~/.hermes/plans/tennis-booking/evidence/tennis-booking/plan-approved.md`. Justin's answers: Q1 = C (no domain, so the email goes to `OWNER_EMAIL` only, and he forwards it), the rest recommended.
- Earlier round: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/review-1/review.json`, and the fixer's answer to each finding in `.../fix-1/answers.md`. R1-4 and R1-5 were P3 and left on purpose. Judge whether each fix really closes its finding. If a fix doesn't hold, raise it again at its severity with `repeats`.
- Evidence folder: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`. Write **only** `review-2/review.json` (scratch in `~/.cache/tennis-booking-reviewer-2/`).
- Read first: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the `review.json` format, `repeats`/`new_fact`, severities, self-check) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`. No project skill exists.

## Skills (load each with the Skill tool and say so)
`engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices` (JavaScript frontend and backend references), `frontend-accessibility-audit`, `mutation-testing-discipline`. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer.

## What to look at
- Each AC against the code, and whether its test can actually fail.
- The public endpoint `api/book.js` → `lib/*`: the key check, validation, throttle, the Resend call (fields, the idempotency key, now with a deterministic payload), no leaks of the key, her address or Resend's error text, fail-closed config.
- The calendar file (UTC, DST, escaping, folding, DTSTAMP now the game's start).
- The page: keyboard use, phone width (long addresses), the new `hashchange` handling, CSP/headers, honest copy (it never claims she got an email; the humor stays dry, not cringe).
- Whether it runs on Vercel (function shape, imports of `public/shared/*.js`, `"type": "module"`).
- Secrets or real addresses in tracked files.
- The fixer's own `found_else` in `answers.md` (409 `concurrent_idempotent_requests`, a key change mid-send, the lowercased address): rate them yourself.

## Running tests
- Browser tests: `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 env -u DISPLAY -u WAYLAND_DISPLAY ...`. Use `node --test "test/*.test.js"`, never `node --test test/`.
- SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Poll long waits in steps under 3 minutes; don't end your turn waiting.

## Severities (Justin's rules)
P0/P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2: a bug a real person could plausibly hit (realistic edge cases, configs, phone browsers), anything that breaks an AC or the UI, or a test that can't fail. P3: cosmetic, docs, a hole only a deliberate evasion hits. A P0–P2 without a concrete real-use scenario is P3. This is a two-person personal site: weigh scenarios by what Justin and his friend would really do.

## Self-check and output
Run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/tennis-booking --base 5e43cee03dde1f838dc4b168ec6f95749e1dc669 ~/.hermes/plans/tennis-booking/evidence/tennis-booking`. Exit 2 means your file is malformed: fix it. Any other exit is the referee's call.

- `found_else`: anything outside scope (one line each, evidence, severity).
- **skill_lessons:** `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce`: `none` or a one-line check proposal). Never edit skills or memory. An empty list is normal.

Return `{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, evidence, repeats?}], ac_status[{ac, accepted, test, screenshot, evidence}], review_json, found_else[], skill_lessons[]}`. Every AC gets a row; AC13 and AC14 are `not_run` (live). End with `MAIN SESSION: check and save these skill_lessons now.`
