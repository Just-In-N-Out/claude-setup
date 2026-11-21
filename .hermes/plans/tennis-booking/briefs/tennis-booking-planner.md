# PLANNER brief: tennis-booking (Mini pipeline)

**Role:** PLANNER for a new personal project, feature "tennis-booking". Write a plan Justin will approve; don't build anything. Make no repo, worktree, branch, code or commit.

## The request (rewritten)
Justin plays tennis with a friend. He wants a small website where she books their next game: she picks a date and time slot, enters her email, and gets the schedule (the booked game) sent to her by email. It should have some humor while she chooses, but **light and dry, nothing cringe**: no over-the-top themes, no forced jokes, no cheesy announcer lines. Think understated, witty microcopy (small asides, a clever confirmation line), a clean, good-looking tennis-flavoured design.

Decided already (2026-11-21):
- Pipeline: **Mini**.
- Hosting and email: **Vercel + Resend** (a server function sends the email through Resend's API, key in an env var). Justin has no Vercel CLI installed on this machine yet; deploying and creating the Resend account are his steps.
- Humor: subtle, not cringe (his words: "Nah I don't want anything cringe").

His words, verbatim: "I need to make a website for a girl I am playing with tennis we have like a joke or something that we can book game to know our schedule it should be somewhat funny or something like that while she is choosing and she puts her email and we send her the schedule or something like that so let's build it"

## Where things go
- New repo (the builder creates it): `/home/justin/tennis-booking` (Linux path, WSL desktop). Personal identity, not Leorna.
- Plan: `~/.hermes/plans/tennis-booking/tennis-booking.md`
- Evidence folder for later roles: `~/.hermes/plans/tennis-booking/evidence/tennis-booking/`
- No project skill exists yet; there is no `references/repeat-mistakes.md` for this project.

## Skills to load (say so in your first steps)
1. `engineering-best-practices`
2. `implementation-planning`
3. Specialists as relevant: `ux-frontend-workbench` (design and copy), `build-validate-apis` (the send-email endpoint), `security-best-practices` (the endpoint is public: input validation, rate limiting / abuse, no key leaks). Name the build's specialist skills in a `## Skills` section of the plan.

Mini mode: skip any heavy context load; finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.

## What the plan must contain
- Open questions right after the title, each with lettered options (A, B, C, under ~60 chars each), the recommended one marked. Write the plan as if the recommended options were chosen. Questions worth deciding (add or drop as you see fit):
  - framework (e.g. Next.js App Router vs a static page plus one Vercel function);
  - how slots work (free date+time picker vs a few preset weekly slots vs Justin's availability list);
  - whether bookings are stored anywhere (just email vs a store like Vercel KV / Upstash so both see the schedule), and whether Justin gets a copy of each booking email;
  - whether the email includes a calendar invite (.ics);
  - Resend sender: **known gotcha to check and state**: with Resend's test sender (`onboarding@resend.dev`) and no verified domain, emails only go to the Resend account owner's own address. Plan around it (verified domain, or the honest limit) and say what Justin must set up.
- Request played back, approach, tasks, tests, choices, risks, files it touches.
- **Numbered ACs near the top: AC1, AC2…** (never AC1a). None were given, so mark every one **proposed**. Each AC names its one test, whole on one line. Tag `(live)` right after the id any AC only Justin can check, e.g. `- AC5 (proposed) (live): …` (a real email arriving in her inbox, the Vercel deploy). Agent-checkable ACs must be testable locally (e.g. the email endpoint tested with Resend mocked; the UI flow in a browser test with a screenshot per AC).
- A clear list of what Justin must do himself (Resend account and API key, domain if any, Vercel import/deploy, env vars), short.
- End with a **Docs & records** task naming every file the build and finish update (README with setup and deploy steps, `.env.example`, `.git/info/exclude` for any CLAUDE.md, etc.).

## Rules
- Answer in plain words. You can't ask Justin anything: put questions in `questions`.
- Don't put Justin's or his friend's personal details (names, emails) in the code or plan; use env vars / placeholders.
- If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an "Other things found" section at the end of the plan.
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section of your report, naming the skill it belongs in (or `memory`); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- Windows desktop runaway memory: a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill, not a result; check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as pass or fail.

## Output
Return: `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` (required: `plan_path`, `summary`). End your report with `MAIN SESSION: check and save these skill_lessons now.`
