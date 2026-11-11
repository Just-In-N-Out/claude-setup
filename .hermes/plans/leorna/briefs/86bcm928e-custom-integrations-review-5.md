# REVIEWER brief — 86bcm928e custom integrations, round 5 (delta: PR-number record commit)

**Role:** a fresh REVIEWER (Opus 5.5, high effort), report only, for Leorna card 86bcm928e "Custom integrations defined by the admin" (control plane, Full pipeline). Change no source, commit nothing, push nothing, write nothing to ClickUp, start no agents. The only files you may write are under `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-5/`. Scratch in `~/.cache/928e-review-5/` (never `/tmp`), removed at the end.

## Skills to load, in order (say so in one line)
`leorna` (step 7.8: the PR-number record), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `review-fix-cadence`. Before starting, read `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`. Record format: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.

## What to review
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`. Head **`31d007e577e922963ab3a669cd1bf5b60f085405`** ("feat(86bcm928e): record PR #129", local only, not pushed); previous reviewed head `57b7e9b6c087741c4e4316cdcdba5b00d30710fb` (review 4 clean; ALL ACCEPTED; pushed; PR #129 open on it). GitHub main `d3e7391c23c2518d95f11fbe77e26baeb568bb86` (the merge-base). Confirm all three, and `gh pr view 129 -R LeornaAI/leorna-control-plane --json state,headRefOid` (read-only).
- **Scope: the one commit `57b7e9b..31d007e`** (`delivery/stories.json`, 1 line). Check: only this story's entry changed, and only to add PR 129; main's entries are unchanged by value and in order with this story last; the JSON parses; the file's existing formatting is kept (no re-dump); `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` passes and `python3 scripts/check-story-shippable.py 86bcm928e` prints only the expected PR-state BLOCKED lines while #129 is open; author is the Leorna identity (don't print the address) and no AI attribution lines; nothing else in the tree changed.
- ACs are unaffected by a records-only change: report `ac_status` for AC1–AC3 as accepted with evidence "records-only delta; ALL ACCEPTED on 57b7e9b (verifier/ac.json, auditor/ac.json)" unless you find the commit touches anything else.

## Severity (Justin's scale)
P0/P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2: a bug a real person or agent could plausibly hit, anything that breaks an AC, the UI or CI. P3: cosmetic, docs. Every P0–P2 needs a concrete real-use scenario of 5+ words; without one it is P3.

## Record
Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-5/review.json` with `round: 5`, `scope: "delta"`, `from: "57b7e9b6c087741c4e4316cdcdba5b00d30710fb"`, `head: "31d007e577e922963ab3a669cd1bf5b60f085405"`, ids `R5-<k>`. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm928e-custom-integrations --base d3e7391c23c2518d95f11fbe77e26baeb568bb86 /home/justin/.hermes/plans/leorna/evidence/86bcm928e`. Exit 2 means your file is wrong; fix it.

## Rules
- earlyoom: for any 143/137/"Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Other findings: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section; never edit skills or memory. An empty list is normal.

## Report back
`{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, repeats, new_fact}], ac_status[{ac, accepted, test, screenshot, evidence}], review_json, review_check_exit, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
