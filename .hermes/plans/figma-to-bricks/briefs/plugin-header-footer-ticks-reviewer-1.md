# Role: reviewer (Mini round 1: the one full review, plus the verifier's AC work; report only): plugin-header-footer-ticks

You are a fresh reviewer who never saw the build (**Fable 5.2, high**). Review only: change no source or test, commit nothing, start no
agents. Never edit the main folder or other worktrees. Never load any live site; no logins; never write to any WordPress site.

**Rule:** report as P0–P2 only bugs a real person using the Figma panel hits (ticking/unticking the boxes, converting, pasting into
Bricks), each with a concrete scenario; edge cases P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/plan-approved.md` (AC1–AC6;
  AC6 live: `not_run`). The job (Justin: "When a user says to not include the header or the footer it is including it in the paste";
  the planner found a TICKED box leaves a part out, an empty one keeps it by design, and the panel's words and its "leaves these out"
  line misled): each box now says its action ("Leave the header out of the paste…"), the line under the boxes says what the next paste
  does in all four states, every note names a box by those words; no paste changes by a byte.
- Branch `plugin-header-footer-ticks-build`, head `c0e04ef4` (full SHA with `git rev-parse`; last code `2e1dc215`), base main
  `e61c0ca091413adfdca3c9b3abe4757ef2fd521f`. Review `git diff e61c0ca0...HEAD`. Builder receipts (read, don't trust):
  `evidence/plugin-header-footer-ticks/builder/` (shots before/after, logs).

## Check hardest
1. The panel as a person uses it: a file with saved ticks opened; ticking, unticking, switching pages, a site-connected vs not
   connected panel, the capture box's hint beside the boxes; is the line ever wrong (says left out while kept, or the reverse)? Is
   anything still saying the old words a person would read (panel, notes, warnings, `index.html`'s first paint)?
2. Byte-for-byte: every Figma paste and every capture paste at the four states equals the base's (AC5 with `F2B_BASE_TREE` = a `git
   archive` of the base); `src/plugin/convert.ts` ≡ replay; Figma's sandbox rules (built-ins only; no `import` followed by `(`, `//`,
   `/*`; no `<!--`/`-->`) — `npm run build` passes its bundle check.
3. The old-word tests changed only their expected strings.

## Verifier's AC work (Mini)
Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and follow it: every AC's cited test on head
(pass) and on old code (a `git archive` of `e61c0ca0` with head's test files copied in; AC3 `base_exempt` with a mutant as the plan
says), AC5 by name with `F2B_BASE_TREE`, a picture per AC (the panel at the four states), AC6 `not_run`. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/verifier/ac.json` and logs there (check it's empty
first). Gates: `npm run check` on head (8G scope); `test/browser/panel.test.ts` alone (4G).

## Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/review-1/review.json` (round 1, full SHA), self-checked
with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
e61c0ca091413adfdca3c9b3abe4757ef2fd521f /home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks`. Load
`requesting-code-review` and `code-review-practice`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`; read both `repeat-mistakes.md` files first.

## Machine
Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/phr/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start; **one Chrome suite at a time**, each
under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. Write scripts with the Write tool, run as `bash <file>`; `git -C
<absolute path>`. Use `tail -n 3`. Waits under 115 s. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since
"-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only review.json, ac.json and logs are written)
Findings one line each (id, P0–P3, file:line, scenario) or "none"; per AC: test, head, old code, evidence; `verdict`; `ac_status`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
