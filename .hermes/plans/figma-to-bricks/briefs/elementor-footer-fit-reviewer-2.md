# Role: reviewer (round 2: the rebased story on its new base, report only): elementor-footer-fit

You are a fresh reviewer (Opus 5.5, high). Review only: change no source or test, commit nothing, start no agents. Never
edit the main folder or other worktrees (read with `git show`). Never load any live site; no logins; never write to any
WordPress site.

**Importer rule (Justin, 2026-11-02):** report as P0–P2 only bugs a real site or normal use hits, each with a concrete
real-use scenario; edge cases are P3.

## Inputs
- Approved plan (read-only, amended): `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/plan-approved.md`.
- The reviewed head `4c9f8214b08a9242dc4d7d401116c5469d46f6c1` (on elementor-phone-fit's old head `dab961f9`) was
  rebased by a finisher (`git rebase --onto e94e0311 dab961f9`) onto elementor-phone-fit's rebased head
  `e94e0311603a70ec35b9b6348cab52747dd97d23` (itself on main `103cbb37`, Build 2026-11-09.1: capture-speed and site-motion
  merged): branch `elementor-footer-fit-final`, head `40e740fdfd025779038deb884220b29e5c1c8d9a`. In your own worktree:
  `git checkout --detach 40e740fd…`, confirm HEAD and a clean status.
- **Scope:** the whole story on its new base, `git diff e94e0311...HEAD`, checked against the reviewed story with
  `git range-diff dab961f9..4c9f8214 e94e0311..40e740fd`. The finisher reports no conflicts, patch-ids 7 of 7 equal, plus
  ledger-only commits. Check the clean merge keeps both meanings with site-motion's code now on the base (site-motion's
  AC15 wrapper-with-a-look refusal in `foldable`'s first loop and its F1 boxed Rich Text for a wrapper entrance, beside
  rule 9 `filledBoxes` — does a stretched widget with an entrance or hover still fold/refuse right on a real page?), and
  HANDOFF keeps every section and check-list entry. Review 1's P3s are in `evidence/elementor-footer-fit/follow-ups.md`.
  Finisher receipts (read, don't trust): `evidence/elementor-footer-fit/finisher-1/`.

## Work
Load `requesting-code-review` and `code-review-practice`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scope.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   e94e0311603a70ec35b9b6348cab52747dd97d23 /home/justin/.hermes/plans/figma-to-bricks/evidence/elementor-footer-fit`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/ef-r2/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`; close every Chrome you start. Heavy runs under
  `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits under 115 s.

## Report (as text; only review.json is written)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status`, then `skill_lessons[{skill,
lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
