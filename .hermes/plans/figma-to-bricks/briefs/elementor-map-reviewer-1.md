# Role: reviewer (Full round 1, report only): elementor-map

You are a fresh reviewer who never saw the build (Opus 5.5, xhigh). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them by absolute path or `git show`).

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** one review per job; report as
P0–P2 only bugs a real site or normal use hits (an Elementor site's captured page pasted into Bricks with `--elementor`;
the code method without the flag; any Figma design converting as before), each with a concrete real-use scenario. Edge
cases go in as P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/plan-approved.md`
  (AC1–AC10; AC9 and AC10 live, Justin's). The job: with `--elementor`, Elementor's element ids and widget types (kept in
  the capture's `marks`) fold Elementor's wrappers so each Elementor element is one Bricks element, and accordions
  (Elementor's and ElementsKit's) become one native Accordion (Nestable), while the captured CSS keeps the look within
  `site:check`'s 2 px; the capture keeps hidden parts of shown elements; without the flag, pastes are byte-identical.
- Branch `worktree-agent-a93c32bbf9bbc5ed4`, head `220cb331ba80e5c795896a7a2d6af12c721d431f`, base
  `fdcda54c78cb0ef9dc5825d320a876e6903694aa` (a commit of `web-code-page-build`, which is reviewed as its own job; review
  only this job's commits). In your own worktree: `git checkout --detach 220cb331ba80e5c795896a7a2d6af12c721d431f`, confirm
  `git rev-parse HEAD` and a clean `git status --porcelain --untracked-files=all`. Review `git diff fdcda54c...HEAD`.
- The builder's receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/builder/`.
  The builder changed `test/web/lib/site-check.ts` `settle` (a web-code-page file): review it too. Its whole-page record
  says 4 of 30 B-Dry sections are worse with `--elementor` (HANDOFF); judge whether any is a bug normal use would hit
  rather than a known limit of an opt-in step.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` and
`references/live-site-reading.md`, the repo `CLAUDE.md` (architecture rules; "Build general logic": nothing keyed on
B-Dry's ids, words or class names) and `reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` (the `review.json` format).
1. Review the whole diff for real bugs: wrong folds (a fold that moves or drops CSS a real Elementor page needs), the
   shared-class scoping of the open look, hidden parts kept in the capture (pop-ups or off-canvas content leaking into a
   paste), the flag-off byte identity, the accordion's markup against `reference/bricks/` samples and Bricks 2.3.9, the
   WXR reader (read-only, no dependency), tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fdcda54c78cb0ef9dc5825d320a876e6903694aa /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-map` (exit 2
   means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/em-r/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time. The worktree's
  `node_modules` may lack `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Never load bdryswi.com; never write to any WordPress site; no logins.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
