# PLANNER brief (revise mode): tennis-booking, amendment for Q1 = C

**Role:** PLANNER, revise mode. Amend the existing plan `~/.hermes/plans/tennis-booking/tennis-booking.md` for Justin's answers; build nothing, and make no repo, branch, code or commit.

Justin said **go** on 2026-11-21 with every recommended answer **except Q1: he chose C, no domain**. His answers are recorded at the bottom of the plan under `## Justin's answers (2026-11-21)`. Q8 is A (Full pipeline).

What Q1 = C means: Resend's test sender `onboarding@resend.dev` only delivers to the Resend account owner's own address (Justin). So the site emails **Justin**, and he forwards it to her. The plan itself says (line ~15 and ~285) that option C needs a small amendment and that AC13 can't pass as written.

## Do
- Revise mode: read the existing plan first, then only the sections this changes. Skip any heavy context load, and finish within about 15 steps.
- Rework the email flow for no domain: `from` is `onboarding@resend.dev` (or whatever the env var holds), `to` is `OWNER_EMAIL` only, and the email names her address and booking so Justin can forward it (`reply_to` set to her address is a sensible choice; decide, and say why). Keep the calendar file attached so the forward carries it. The confirmation she sees on screen must stay honest: it must not claim an email reached her inbox. Use dry, non-cringe copy, e.g. that the booking went through and the invite is on its way. Keep the design open to a domain later: if adding a domain is just an env-var change plus a small code path, say so, and note it as a later step. Don't build two modes unless it is trivial.
- Amend every affected AC and test name (AC5, AC12 if the env-var list changes, AC13, AC14, any others), keeping ids AC1…AC14 (no new letters; a split part takes the next number, marked proposed). All ACs stay **proposed**. Keep `(live)` tags right after the id. Keep each test name whole on one line.
- Update the README and Justin's setup steps (no DNS step, which env vars are set to what), the risks, and the Docs & records task.
- Mark the plan's Q1 answered (C) and add an `## Amendments` list at the top naming each changed line.
- Check the saved plan with ac-check's pattern as you did before: AC1…AC14 found, no bad ids, live ACs parsed.

## Rules
- Plain words. Put any new question for Justin in `questions`, with lettered options and one recommended; write the plan as if the recommended one is chosen.
- No personal names or addresses in the plan; use placeholders.
- `found_else` for anything else found (don't fix it).
- **skill_lessons:** list reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]` (`enforce`: `none` or a one-line check proposal); never edit skills or memory. An empty list is normal.
- Windows desktop: a SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill; check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`.

## Output
`{name, plan_path, summary, changed_acs[], questions[], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
