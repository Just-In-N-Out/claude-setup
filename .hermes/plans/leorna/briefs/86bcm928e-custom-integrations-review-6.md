# REVIEWER brief — 86bcm928e custom integrations, round 6 (delta: conflict-free merge of main 659b832)

**Role:** a fresh REVIEWER (Opus 5.5, high effort), report only, for Leorna card 86bcm928e "Custom integrations defined by the admin" (control plane, Full pipeline). Change no source, commit nothing, push nothing, write nothing to ClickUp, start no agents. The only files you may write are under `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-6/`. Scratch in `~/.cache/928e-review-6/` (never `/tmp`), removed at the end.

## Skills to load, in order (say so in one line)
`leorna` (step 7: verifying a conflict-free merge), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `review-fix-cadence`. Before starting, read `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`. Record format: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.

## What to review
- Worktree `/home/justin/Leorna/86bcm928e-custom-integrations`, branch `feat/86bcm928e-custom-integrations`. Head **`e46f93460218019ace70694d7df587be4f5504fb`** (merge commit "merge: bring main (659b832) into feat/86bcm928e-custom-integrations", local only, not pushed); previous reviewed head `31d007e577e922963ab3a669cd1bf5b60f085405` (review 5 clean; pushed; PR #129 open on it, BEHIND). GitHub main `659b832a5ed10d0318c49f7f34c2c61425be2b16` (#127, v0.2.0 release notes: `.github/release-notes/v0.2.0.md`, `README.md`, `docs/deploy/release-pipeline.md`, `scripts/release.py`, `scripts/test_release.py`). Confirm all, and `gh pr view 129 -R LeornaAI/leorna-control-plane --json state,headRefOid,mergeStateStatus` (read-only).
- **Scope: the merge `31d007e..e46f934`.** Prove it is git's clean result (`git merge-tree --write-tree 31d007e 659b832` equals `e46f934^{tree}`); no file changed on both sides since `d3e7391`; every file differs from at most one parent; no duplicate migration version; `gitleaks git 659b832..HEAD`. Check whether main's #127 changes interact with the story (release script reading `delivery/stories.json`, README or release notes that now say something false about integrations, `scripts/test_release.py` passing on the merged head). The fixer's receipts: `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/bring-main-3/` and `gates-e46f934.txt`; check, don't trust. Run AC1–AC3 by name yourself if you can do it in under 15 minutes with your own Postgres (`928e-review6-pg`, `--memory 1g`, `mirror.gcr.io/library/postgres:18.6-alpine3.23`, db ending `_test`, bounded `docker exec … pg_isready -h 127.0.0.1` wait; remove only it), Go 1.27.4 (`~/.local/leorna-toolchain/go1.27.4/bin` first on PATH); otherwise cite the fixer's logs after reading them.
- `ac_status`: AC1–AC3 from your run or the fixer's logs on `e46f934`.

## Severity (Justin's scale)
P0/P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2: a bug a real person or agent could plausibly hit, anything that breaks an AC, the UI or CI. P3: cosmetic, docs. Every P0–P2 needs a concrete real-use scenario of 5+ words; without one it is P3.

## Record
Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928e/review-6/review.json` with `round: 6`, `scope: "delta"`, `from: "31d007e577e922963ab3a669cd1bf5b60f085405"`, `head: "e46f93460218019ace70694d7df587be4f5504fb"`, ids `R6-<k>`. Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm928e-custom-integrations --base 659b832a5ed10d0318c49f7f34c2c61425be2b16 /home/justin/.hermes/plans/leorna/evidence/86bcm928e`. Exit 2 means your file is wrong; fix it.

## Rules
- earlyoom: for any 143/137/"Killed", check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.
- Other findings: `found_else`. Lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section; never edit skills or memory. An empty list is normal.

## Report back
`{verdict: clean|findings, findings[{id, severity, file_line, claim, scenario, repeats, new_fact}], ac_status[{ac, accepted, test, screenshot, evidence}], review_json, review_check_exit, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
