# FIXER brief, round 1: tennis-booking (Full pipeline)

**Role:** FIXER. Fix the three P2 findings from review round 1, test first, then stop at `ready-for-next-review`. Don't merge, push or deploy.

## Inputs
- Repo: `/home/justin/tennis-booking`, branch `feat/tennis-booking`, head `e2eab490f094cafc6ef9fb9a2e4189b9edb06185`, base `5e43cee03dde1f838dc4b168ec6f95749e1dc669`.
- Approved plan (contract, read-only): `~/.hermes/plans/tennis-booking/evidence/tennis-booking/plan-approved.md`.
- Review: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/review-1/review.json`. The reviewer's probes are in `/home/justin/.cache/tennis-booking-reviewer-1/` (`probe1.mjs`, `probe2.mjs`, `probe3.mjs`, screenshot `probe-long-email-375.png`).
- Read first: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the fixer's answer to each finding) and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Skills (load each with the Skill tool and say so)
`engineering-best-practices`, `receiving-code-review` (verify each finding before fixing it; push back with evidence when one doesn't hold), `test-driven-development`, `mutation-testing-discipline` (R1-1 touches the send guard), `git-commit-rules`.

## Fix these (P2)
- **R1-1** `lib/handler.js:102-128`: the same booking sent again (same email, day and time) gets Resend's 409 `invalid_idempotent_request` for 24 hours, because the payload differs (`DTSTAMP` is the send time; her address's case or `COURT_LOCATION` too), and the page wrongly says the email didn't go out. Make a repeat of the same booking behave honestly and sensibly. Options to weigh: make the payload deterministic for the same key (e.g. DTSTAMP and every field derived from the key's inputs, normalised address), and/or treat a 409 idempotency conflict as a send that already happened. Pick, say why, and pin it with a failing test first against a fake Resend that follows the documented rule (same key + same body → same answer; same key + other body → 409). Fix `README.md:143-144` to match.
- **R1-2** `public/styles.css:335` / `public/app.js:110`: a long email address (41+ characters) makes the confirmation scroll sideways at 375 px. Break long words there (and anywhere else she sees her own address). Extend the AC11 test (or add a test under AC11's name) with a long address, about 60 characters, at 375 px and 360 px, failing first.
- **R1-3** `public/app.js:219-221`: a valid key added to the URL fragment in the same tab is ignored until a reload. Handle `hashchange` (show the form when a valid key arrives; decide sensibly what happens if the key is removed). Add a test, failing first.

## Not in this round
R1-4 and R1-5 are P3: leave them (they go to follow-ups). Don't widen scope.

## Rules
- One commit per finding, test first; plain `git commit -m "..."`, no `Co-Authored-By` or AI lines, never `-c user.*` or `--author`. Never commit a `CLAUDE.md`.
- Keep every AC test name exactly as the plan spells it (`ac-check.sh` matches names line by line). Run the whole suite at the end and capture it to `~/.hermes/plans/tennis-booking/evidence/tennis-booking/fix-1/` (one log of the full gate, plus a screenshot of the long-address confirmation at 375 px). Write nothing else into the evidence folder.
- Browser tests need `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, and always run under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 env -u DISPLAY -u WAYLAND_DISPLAY ...`. Use `node --test "test/*.test.js"`, never `node --test test/`. Scratch files go in `~/.cache/tennis-booking-fixer-1/`.
- A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Poll long waits in steps under 3 minutes; don't end your turn waiting.
- `found_else` for anything else found (don't fix it).
- **skill_lessons:** `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce`: `none` or a one-line check proposal). Never edit skills or memory. An empty list is normal.

## Output
`{status: ready-for-next-review|blocked, head, commits[], answers[{id, action: fixed|rejected, test, commit, evidence}], gate_log, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
