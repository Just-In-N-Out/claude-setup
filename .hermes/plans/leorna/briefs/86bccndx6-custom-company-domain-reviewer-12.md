# REVIEWER 12 — 86bccndx6 custom company domain (fix-commit review)

You are a fresh, independent code reviewer for a Leorna control-plane story. You have no context from the people who built it. Report only: do not edit code, commit, push, open PRs, post to ClickUp, or touch Scaleway or any cloud account.

## The story
- ClickUp 86bccndx6, "custom company domain": an admin adds a domain they own in the installer, the installer creates a Scaleway Serverless Container custom domain, shows the DNS CNAME, and once TLS is issued the server and client discovery move to that domain, while the generated `*.functions.fnc.fr-par.scw.cloud` domain keeps working.
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, branch `feat/86bccndx6-custom-company-domain`, head `ec301654c96c17204b950d1a50e542f30b0e7a21`, merge base with main `9fce72dee016b21e3d8db50225ca6aeccd542fc1`.
- Approved plan with AC1–AC6: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (read it first). AC4 is a live check only the user can run.

## Scope: round 12 reviews only the PR-record commit since review 11
`git diff e6ea3d7..ec30165` (1 docs commit, `docs(86bccndx6): record PR #115 in the delivery records`, 2 files): `delivery/custom-company-domain.md` line 3 and the 86bccndx6 entry in `delivery/stories.json`. Justin approved this commit (the `leorna` skill's step 7.8) on 2026-11-08; it will be pushed to the open PR #115 after this review. Check:
1. Only those lines changed; every other `stories.json` entry is byte-identical to e6ea3d7 and to main `9fce72d`, the file parses, and the wording matches `delivery/README.md` and step 7.8.
2. AC4 still reads as owed (live, needs a test domain); nothing claims shipped, merged or live-verified.
3. `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`, `python3 -m unittest scripts/test_release.py` and `make secrets` pass; `scripts/check-story-shippable.py 86bccndx6` blocks only because #115 is open.
A full `make check` is not needed for a docs-only delta; run it only if you find something in `delivery/` that Go code or a Make target reads.

## Load these skills first
`leorna`, `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `multi-tenant-auth-management`. Follow the repo's `AGENTS.md`.

## Gates (local only)
The checks in the scope above. For `ac_status`, AC1–AC3, AC5 and AC6 are unchanged from `ac-check-e6ea3d7.txt` unless the delta touches them; AC4 is live-owed.

## Environment
Docker is up. If Docker Desktop crashes (`/var/run/docker.sock` gone), never restart it or WSL: report the Docker-backed gates as environment-blocked. The WSL desktop has no host `pg_isready`: use `docker exec <container> pg_isready -h 127.0.0.1`. Don't touch `leorna-pg` or `ndx6-preview-*`; remove containers you start. Don't use `pkill -f`. Run #114's own tests too (`TestIntegrationGovernance*WithPostgres`, `TestContentUsageIntegrationsUnavailableWithoutWiring`, `./internal/integration`, `./internal/itembuilder`).

## Where to write
`~/.hermes/plans/leorna/evidence/86bccndx6/review-12/review.json`, in the same schema as `review-11/review.json`, with your notes and logs in `review-12/`. That folder is the only place you write. At the end, run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base 9fce72dee016b21e3d8db50225ca6aeccd542fc1 ~/.hermes/plans/leorna/evidence/86bccndx6` and confirm it accepts your record.

## Report
- `verdict`: clean / not clean, and `ac_status` per AC (accepted / not accepted / live-owed, with evidence).
- Findings ranked P0–P3, each with file:line, a concrete real-use failure scenario and a suggested fix. P0/P1: security hole, guard bypass, false AC, or a wrong block that breaks normal work. P2: a bug a real admin could plausibly hit, or a test that can't fail. P3: cosmetic, docs, or only reachable by deliberate evasion. A P0–P2 with no concrete real-use scenario is P3.
- Gate results with the commands and their output tails.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or memory yourself.
- End with: `MAIN SESSION: check and save these skill_lessons now.`
