# REVIEWER brief, round 1: tennis-booking (Full pipeline)

**Role:** fresh REVIEWER, round 1, report only. You never saw the build. Review the **whole story** from base to head. Don't change any source, commit, or fix anything.

## Inputs
- Repo: `/home/justin/tennis-booking`, branch `feat/tennis-booking`
- Base: `5e43cee03dde1f838dc4b168ec6f95749e1dc669` (main: `.gitignore` only). Head: `e2eab490f094cafc6ef9fb9a2e4189b9edb06185`.
- Approved plan (the contract, with ACs AC1–AC14; AC13 and AC14 are live, Justin's): `~/.hermes/plans/tennis-booking/evidence/tennis-booking/plan-approved.md`. Note Justin's answers: Q1 = C (no domain, so the email goes to `OWNER_EMAIL` only, and he forwards it), the rest recommended.
- Evidence folder: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`. Write **only** `review-1/review.json` there (plus scratch files under `~/.cache/tennis-booking-reviewer-1/`).
- Read before you start: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the `review.json` format, severities and self-check) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`. No project skill or project repeat-mistakes file exists.

## Skills (load each with the Skill tool and say so)
`engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices` (JavaScript frontend and backend references), `frontend-accessibility-audit`, `mutation-testing-discipline` (for spot mutation checks). Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you *are* the fresh reviewer, and you can't spawn agents.

## What to look at
- Does the code do what each AC says, and can each AC's test actually fail? (The builder's mutation notes are in `builder/guard-sensitivity.md`; spot-check them, don't trust them.)
- The public endpoint `api/book.js` → `lib/*`: the key check, validation, throttle, the Resend call (`reply_to` / `content_type` fields, the idempotency key), no leaks of the key, her address or Resend's error text in logs or responses, fail-closed config.
- The calendar file (UTC times, summer and winter, RFC 5545 escaping and line folding).
- The page: keyboard use, phone width, CSP and headers in `vercel.json`, honest copy (it must never claim the email reached her; the humor stays dry, not cringe), the copy matching the plan's copy deck.
- Whether it will really run on Vercel (function shape, imports of `public/shared/*.js`, `"type": "module"`); flag real risks.
- Secrets or real addresses in tracked files.
- The builder's own calls, listed in its report: a failed send doesn't count toward the throttle; when only a day or only a time is chosen the summary shows just that part; slots that have started are disabled for today; a 20 s client timeout; the page shows 14 days but the endpoint allows today to today+14. Judge whether any of these breaks an AC or a real use.

## Running tests
- Browser tests need `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` (system libraries aren't installed), and always run under a memory cap: `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 env -u DISPLAY -u WAYLAND_DISPLAY LD_LIBRARY_PATH=... <cmd>`. Use `node --test "test/*.test.js"`, never `node --test test/`.
- A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Long waits: poll in steps under 3 minutes with the Bash `timeout` set above them; don't end your turn waiting.

## Severities (from Justin's rules)
P0/P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2: a bug a real person could plausibly hit (realistic edge cases, configs, phone browsers), anything that breaks an AC or the UI, or a test that can't fail. P3: cosmetic, docs, a hole only a deliberate evasion hits. A P0–P2 must come with a concrete real-use scenario, or it is P3.

## Self-check and output
Run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/tennis-booking --base 5e43cee03dde1f838dc4b168ec6f95749e1dc669 ~/.hermes/plans/tennis-booking/evidence/tennis-booking`. Exit 2 means your file is malformed: fix it. Any other exit is the referee's call, not yours.

- `found_else`: anything outside this story's scope (one line each, evidence, severity).
- **skill_lessons:** `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce`: `none`, or a one-line proposal for a check: kind, what, where). Never edit skills or memory. An empty list is normal.

Return `{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], review_json, found_else[], skill_lessons[]}`. Every AC gets an `ac_status` row; mark AC13 and AC14 `not_run` (live). End with `MAIN SESSION: check and save these skill_lessons now.`
