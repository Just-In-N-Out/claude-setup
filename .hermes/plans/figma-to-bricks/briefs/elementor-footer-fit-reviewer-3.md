# Role: reviewer (round 3: the rebase's conflict resolution only, report only): elementor-footer-fit

You are a fresh reviewer (Opus 5.5, high). Review only: change no source or test, commit nothing, start no agents. Never
edit the main folder or other worktrees (read with `git show`). Never load any live site; no logins; never write to any
WordPress site.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3.

## Inputs
- Approved plan (read-only, amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/plan-approved.md`.
- The verified head `40e740fdfd025779038deb884220b29e5c1c8d9a` (on elementor-phone-fit's `e94e0311`; review 2 clean)
  was rebased by a finisher onto local `main` `b06d8267d4a3f26ee8ec9b3b0f7f2b45d0a594c9` (Build 2026-11-09.2:
  elementor-phone-fit merged with its build commit): branch `elementor-footer-fit-final2`, head
  `8c45dff5810a393b9714957f381693d098c5f25d`. In your own worktree: `git checkout --detach 8c45dff5…`, confirm HEAD and a
  clean status.
- **Scope:** `git range-diff e94e0311..40e740fd b06d8267..8c45dff5` — one `docs/HANDOFF.md` conflict (top sections and
  the end-of-run list, where main's build commit filled phone-fit's 3dl and build), resolved keeping this job's block
  first and main's lines as main has them, plus ledger commits. Check HANDOFF keeps every section and entry of both and no
  code or test patch changed. Finisher receipts (read, don't trust): `evidence/elementor-footer-fit/finisher-2/`.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/review-3/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   b06d8267d4a3f26ee8ec9b3b0f7f2b45d0a594c9 /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-r3/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start. Heavy runs under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
