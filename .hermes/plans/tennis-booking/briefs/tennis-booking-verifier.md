# VERIFIER brief: tennis-booking (Full pipeline)

**Role:** VERIFIER (read only, fresh), for the personal project "tennis-booking". You never saw the build, the reviews or the fixes being made. Change no source and commit nothing; write only into `<evidence>/verifier/`.

## Inputs
- Repo: `/home/justin/tennis-booking`, branch `feat/tennis-booking`, head `72c75b026cb61b7f06edbbdf26a3631993c67f22`. Base (old code): `5e43cee03dde1f838dc4b168ec6f95749e1dc669` (`main`, `.gitignore` only; `git -C /home/justin/tennis-booking merge-base HEAD main` gives it).
- Approved plan, the contract (ACs AC1–AC14; AC13 and AC14 are `(live)`, Justin's): `~/.hermes/plans/tennis-booking/evidence/tennis-booking/plan-approved.md`. Justin's answers there: Q1 = C (no domain, so the email goes to `OWNER_EMAIL` only, and he forwards it), the rest recommended.
- Evidence folder `<evidence>` = `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`. Reviews: `review-1/review.json`, `review-2/review.json` (round 2 clean, MOVE ON at 72c75b0); the fixer's answers: `fix-1/answers.md`.
- Read first, and follow it: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, the VERIFIER part (the `ac.json` format, the head and base runs, screenshots, `ac_status`, live ACs as `not_run`).

## Skills (load each with the Skill tool and say so)
`engineering-best-practices`, `adversarial-verification-loop`, `frontend-testing-workflow`, `mutation-testing-discipline`.

## Do
1. Re-run the project's gates on head yourself: `npm run check` (or what `package.json` defines: node unit tests, Playwright and axe), plus `gitleaks` on the repo.
2. Confirm each P0–P2 finding from review 1 (R1-1, R1-2, R1-3) is closed on head, and look for regressions the fixes caused.
3. For every agent-checkable AC (AC1–AC12): run its named test on **head** (must pass) and on **base** (must fail, as `ac-verification.md` describes), capture each run's log, and keep **one screenshot per AC** (the real UI for browser ACs, a terminal capture for the others). Read each AC's wording against what its test asserts; a test that passes but doesn't prove the AC's words is a not-accepted AC.
4. Mark AC13 and AC14 `not_run` (live).
5. Write `<evidence>/verifier/ac.json` in the format `ac-verification.md` gives; check it with `ac-check.sh` alone if that reference says to.

## Environment
- Browser tests: `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` (the system libraries aren't installed), always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 env -u DISPLAY -u WAYLAND_DISPLAY ...`. Use `node --test "test/*.test.js"`, never `node --test test/`.
- Running on base: use a separate checkout under `~/.cache/tennis-booking-verifier/` (e.g. `git worktree add` or `git archive`), never by changing the repo's working tree. Clean it up after.
- SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Poll long waits in steps under 3 minutes; don't end your turn waiting.

## Rules
- `found_else`: anything else found (don't fix it).
- **skill_lessons:** `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce`: `none` or a one-line check proposal). Never edit skills or memory. An empty list is normal.

## Output
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, found_else[], skill_lessons[]}`. `clean` requires every AC accepted, live ACs aside. End with `MAIN SESSION: check and save these skill_lessons now.`
