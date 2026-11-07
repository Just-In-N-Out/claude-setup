# Role: reviewer (round 4, report only: the R3-1 fix, at Justin's word): elementor-map

You are a fresh reviewer who never saw the build (Opus 5.5, xhigh). Review only: change no source or test, commit nothing,
start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read them by
absolute path or `git show`). Never load bdryswi.com; no logins; never write to any WordPress site.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real
site or normal use hits, each with a concrete real-use scenario; edge cases are P3. Justin allowed this one extra round
(`evidence/elementor-map/review-3/justin.json`) to check only the R3-1 fix.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`.
- Branch `worktree-agent-a93c32bbf9bbc5ed4`, head `c0538d8e3e7acf5dc0f03bca6aae9cdeaf901930`, base `c920728a` (web-code-page's
  final head). In your own worktree: `git checkout --detach c0538d8e…`, confirm `git rev-parse HEAD` and a clean status.
- R3-1 (`evidence/elementor-map/review-3/review.json`): with `--elementor`, classes shared a name and id with the whole-page
  paste's classes but held other settings, so Bricks' Import classes broke one paste either way.
- The fix since the last review (head `2afc42e7` then): a rebase onto `c920728a` (one conflict, `src/core/site/parts.ts`
  imports; check with `git range-diff 95097213..2afc42e7 c920728a..6e67f3e2`), then `06b9df04` (names after their rules,
  `classes.ts` `versioned`, `Prepared.elementor`), `b5ebfa03` (open look's path map filtered to the site's element),
  `c0538d8e` (HANDOFF: AC10's Import classes steps). Fixer evidence: `evidence/elementor-map/fixer-2/` (read, don't trust).
- Review only that delta and what it touches: does any pair of the importer's pastes of one capture still share a name with
  other settings; does Bricks' paste handle the new names (Import classes by name vs id, `reference/bricks/README.md`); is the
  code method byte-identical without the flag; are AC10's new steps right (Accept only for `site-text`/`site-flat`/
  `site-accordion`); can the new test fail. A finding repeated with no new fact sets `repeats`.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-4/review.json` (ids `R4-<k>`; delta from
`2afc42e7`), then self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your
worktree> --base c920728a2355240119304f890236bdf315a21176 /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map`.

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-r4/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time (another job's
  verifier runs Chrome too: a browser failure seen beside it is rerun alone before judging).
- Runaway memory: SIGTERM, 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o short-iso | grep
  sending`); heavy runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. A foreground Bash call
  goes to the background at 120 s: keep waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending with
`MAIN SESSION: check and save these skill_lessons now.`
