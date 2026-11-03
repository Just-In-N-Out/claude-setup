# Role: FIXER, round 1 — djtrees-phone-menu (DJ Trees designer note 2; Full, capped rounds)

First read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and follow it (Chrome, fonts as
`data:` URLs with a load check, ticks as a JSON string, bounded mutation runs: never `assert.deepEqual` whole IR trees,
never end your turn to wait).

Fix review 1's P2 test-first; a fresh round-2 review follows. Also take R1-5 (P3, cheap and a standing rule: reduced
motion). Leave R1-2, R1-3, R1-4 in `E/follow-ups.md` unless your fix touches their lines anyway.

## Where

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-phone-menu`; you write in `E/fixer-1/`.
- Approved plan (read-only, wins): `E/plan-approved.md`. Review: `E/review-1/review.json` with `review-1/probes/`
  (`probe-fits.log`, `shot-shortMenu-390.png`, the probe scripts).
- Job head `2153d8d4ba0e4ace4d9df4e12bd81b507ef8086c` on branch `worktree-agent-afb732edbd2ac1c70`, base `1aef12f`.
  **Task 0:** in your own worktree, `git reset --hard 2153d8d4ba0e4ace4d9df4e12bd81b507ef8086c`. Commit on your branch.
  Don't rebase.
- Ledger: append a "Review 1 fixes" section to `.superpowers/sdd/2026-11-02-djtrees-phone-menu/progress.md`; one line
  per fix in the job's HANDOFF section.

## Skills

`receiving-code-review` (verify each finding first; push back with evidence where it doesn't hold), the project skill
(FIXER role), `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`.

## The findings

1. **R1-1 · P2 · `src/core/adapt/menu-plan.ts:92`:** a proven menu bar that fits on one line at every width (a small
   mark plus four short page names) gets a ☰ from 767 down while its menu stays visible: `foldOf` returns null so
   `navigation.menu` never runs, but `planPhoneMenus` (`understand/phone-menu.ts:68`) always builds the Nav copy with
   `show: "phone"`, so `phone.swap` (`rules/phone.ts:19`) shows it at `mobile_landscape` and emit writes
   `mobileMenu: "mobile_landscape"`. AC3 is false for such bars. Remember CLAUDE.md: phone-only copies are made only at
   understand and no later stage changes an earlier one's output; the layout plan is adapt-time. Choose the fix that
   keeps that architecture (e.g. understand decides with the facts it has, or the copy is hidden at every tier when the
   plan finds no fold tier, with the payload equal to the switch-off paste for such a bar), and say why. Add the
   never-folding bar as a fixture: no ☰ at any width, the menu as on base, payload equal to the switch-off paste.
2. **R1-5 · P3 · `src/core/emit/nav.ts:49`:** the panel's 0.2s slide has no reduced-motion guard (CLAUDE.md: reduced
   motion is one of the extras the plugin always adds). Add it with a test.

Keep every approved AC test green with its meaning, the DJ Trees AC8 receipt and the blast-radius witness (six real
files plus fixtures, ticks off and on) unchanged except where R1-1's fix must change them (say which). Re-run `npm run
check` and the phone-menu browser tests (`skipped 0`).

## Return

Per finding: verified or pushed back (evidence), the fix, red→green test names and logs, mutants. New head (full SHA),
branch, gates, `found_else`, `skill_lessons`. End with `MAIN SESSION: check and save these skill_lessons now.`
