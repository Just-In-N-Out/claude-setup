# AC AUDITOR brief: tennis-booking (Full pipeline)

**Role:** blind AC AUDITOR, read only and fresh. Prove every acceptance criterion yourself. You get only the plan, the repo, the head and the base; you never see the verifier's report or folder, nor the reviews. Change no source and commit nothing.

## Inputs
- Approved plan, the contract (ACs AC1–AC14; AC13 and AC14 are `(live)`, Justin's to check): `~/.hermes/plans/tennis-booking/evidence/tennis-booking/plan-approved.md`. Its `## Justin's answers` and `## Amendments` sections are part of it.
- Repo: `/home/justin/tennis-booking`, branch `feat/tennis-booking`. Head: `72c75b026cb61b7f06edbbdf26a3631993c67f22`. Base (old code): `5e43cee03dde1f838dc4b168ec6f95749e1dc669` (= `git -C /home/justin/tennis-booking merge-base HEAD main`; `.gitignore` only).
- Your folder: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/auditor/`. Write only there, plus scratch in `~/.cache/tennis-booking-auditor/`. **Don't open** `.../verifier/`, `review-*/` or `fix-*/`.
- Read first and follow: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, the AUDITOR part (the `ac.json` format, the head and base runs, one screenshot per AC, live ACs as `not_run`).

## Skills (load each with the Skill tool and say so)
`engineering-best-practices`, `adversarial-verification-loop`, `frontend-testing-workflow`, `mutation-testing-discipline`.

## Do
- For every agent-checkable AC (AC1–AC12): read its wording, read its named test, and judge whether the test really proves each clause. Run it on head (must pass) and on base (must fail for an honest reason, as the reference describes), capture each log, and keep one screenshot per AC (the real UI for browser ACs, a terminal capture otherwise). Where a clause looks unproven, show with a mutant on a scratch copy whether the test can fail.
- Mark AC13 and AC14 `not_run` (live).
- Write `auditor/ac.json`.

## Environment
- Browser tests: `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` (the system libraries aren't installed), always under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 env -u DISPLAY -u WAYLAND_DISPLAY ...`. Use `node --test "test/*.test.js"`, never `node --test test/`.
- The base predates the project's `package.json`: copy head's `package.json` (and `playwright.config.js` for browser specs) into your base tree, or ESM specs fail on `import.meta` for the wrong reason.
- Base and mutant runs happen in separate trees under `~/.cache/tennis-booking-auditor/` (`git worktree add --detach` or `git archive`), never in the repo's working tree; clean up after.
- SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Poll long waits in steps under 3 minutes; don't end your turn waiting.

## Rules
- `found_else`: anything else found (don't fix it).
- **skill_lessons:** `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce`: `none` or a one-line check proposal). Never edit skills or memory. An empty list is normal.

## Output
`{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], ac_json, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
