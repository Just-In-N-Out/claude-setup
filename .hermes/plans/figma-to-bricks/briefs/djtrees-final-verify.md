# Role: VERIFIER or AC AUDITOR (blind) — DJ cars 7–12 on main (final checks before Build .4) — one car per agent

Your prompt names your ROLE, your CAR, its **head** and its **base** (full SHAs). Read
`/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` first, then:
- **Verifier:** `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md`. Write `E/verifier/`
  fresh (move an older `E/verifier/` to `E/verifier-train-f425e79/` first, or `E/verifier-pre-main/` if that exists).
  Earlier verifier reports for this job exist (cars 7–9 on the old train; side-art's review-2 receipts; faq-art and
  phone-menu reviewer receipts): you may read them to know what to re-check, but every receipt you cite is your own run
  on YOUR head. Judge the move onto main (`E/rebase/conflicts.md`, report-only) and confirm the car's change equals its
  pre-move change.
- **Auditor (blind):** `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-auditor-common.md`. You write only
  `E/auditor/` (move an older one to `E/auditor-pre-main/` first). Don't open `E/verifier*`, `E/review-*`, `E/fixer*`,
  `E/rebase*`, `E/builder` results, follow-ups, ledger or HANDOFF results.

Both: use your own worktree, detached at the head, as `ac-check --repo`; approved plan `E/plan-approved.md`; fonts as
`data:` URLs with every FontFace "loaded" checked; ticks as a JSON string; bounded mutation runs; a named test counts
only with its own `ok` line and `# pass` ≥ 1; browser tests `skipped 0`; never end your turn to wait.

| car | job | E | live AC (owed to Justin) |
|---|---|---|---|
| 7 | djtrees-stack-gaps | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps` | AC9 (3cr) |
| 8 | djtrees-stack-lines | `…/djtrees-stack-lines` | AC8 (3co) |
| 9 | djtrees-step-sides | `…/djtrees-step-sides` | AC9 (3cp) |
| 10 | djtrees-side-art | `…/djtrees-side-art` | AC10 (3cm) |
| 11 | djtrees-faq-art | `…/djtrees-faq-art` | AC7 (3cs) |
| 12 | djtrees-phone-menu | `…/djtrees-phone-menu` | AC10 (3ck) |

Known train rulings to read correctly (verifier: confirm; auditor: just prove the ACs as written, reporting any that
fail): car 8 narrowed stack-gaps' AC3 for flat-colour lines on upright phones (both approved plans gave across tiers to
stack-lines); car 10's merge commit lets `photo.stack` override `section.top` (side-art AC9's "06 tablet top 64 → 67"
no longer applies; 06 differs by justify only); car 12's panel action pill is centred from 767 down by main's
`cta.center`. An earlier car's "differs from base only in X" receipt read at a later car shows later jobs' keys: judge
it against YOUR base (the previous car), not main.

Return verdict, `ac_status` per AC, new P0–P2 findings (P3s listed) and `skill_lessons`; end with
`MAIN SESSION: check and save these skill_lessons now.`
