# FIXER 3 — slider-autoplay, blind-audit AC12 finding

You own only `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/slider-autoplay`, branch
`worktree-slider-autoplay`, currently clean at `d355109ce1850930e926a6d17ad9bafcfe4d2cf6`. Initial integration base
is `f46f8a20dec5558ce85b246db48ef83c13ca72d2`. Do not rebase: the later finisher owns integration.

## Skills and inputs
Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` plus its
rules summary, `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, and
`git-commit-rules`; use `systematic-debugging` on any surprise and mutation discipline if adding a guard.
Do not start subagents. You are not alone in the repo: preserve other sessions' work, never revert it, and
never touch headline-marker or photo-hotspots worktrees/evidence.

Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/plan-approved.md`.
AC1–AC14 apply as amended in `docs/plans/2026-10-26-slider-autoplay.md` (Justin's answers and Rulings).
AC13 and AC14 are live paste check 3bm. AC14 expects interval 5800 and speed 800. No need to re-plan.

Reports, both available to you:
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/verifier/ac.json` (runnable ACs accepted).
- `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/auditor/ac.json` (AC12 rejected).
- Auditor's independent evidence is in that auditor folder, particularly ac12-audit-red.log, ac12.png,
  ac12-causal.log and ac12-causal.patch. Inspect the evidence and verify the finding before fixing.

## Finding, verbatim
AUD-F1 (low): "AC12 fails: two slider instances with the same Figma name emit two sliders but only one panel note.
understand.ts:51 deduplicates identical messages. Removing only that deduplication in scratch makes the
independent assertion pass."

The orchestrator's ac-check result on d355109 was:
```
AC1–AC11 ACCEPTED
AC12 NOT ACCEPTED: auditor did not accept it
AC13 NOT VERIFIED (live: the user checks it)
AC14 NOT VERIFIED (live: the user checks it)
NOT ACCEPTED: 1 of 14 ACs on d355109
```

## Do
1. Verify AUD-F1 yourself. Strengthen the plan's exact named AC12 regression test to exercise two same-named
   slider instances and the clause that each slider made is named. Prove RED on current source before fixing,
   then GREEN. Decide the implementation from evidence, preserving unrelated ordinary-design note behavior.
   Do not blindly remove a global safeguard just because a causal scratch probe did so.
2. Fix the valid defect generally for any Figma file. Keep every existing behavior/ruling, especially the lifted
   sample gate, full-wait timing, 24px phone arrows, clearance and corner controls. Record any necessary ruling
   in the current plan/HANDOFF/ledger as not yet confirmed under Justin's standing auto-go.
3. Run the required project gates: npm run check; npm run corpus (classify missing Mac paths honestly); the
   complete carousel browser file with zero skips; full browser suite by exact test name versus the pinned base;
   local corpus-backed tests in own git-archive scratch trees; AC5's five replays with payload AND warnings
   byte-identical to the base. Use CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b.
4. Commit by file with plain git commit, proper configured identity, no AI trailers, no CLAUDE.md/user debug
   files staged. Update feature-owned ledger and HANDOFF, ending with ready-for-verify. Leave worktree clean.

Evidence only in `/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/fixer-3/`.
Make new own `/tmp/slider-autoplay-fixer-3-XXXXXX` scratch with mktemp or mkdir without -p; never extract into an
existing folder. Never change another role's evidence, the approved plan, main, BUILD or the worktree CLAUDE.md.
Never stash, push, merge or delete the worktree. Long gates preserve complete logs, runtime, EXIT markers and
each exit status. Send concise progress at meaningful milestones. Setup sync is unavailable because its bare
repo is mounted read-only even with escalation; do not bypass that restriction.

## Report
Return `{status: ready-for-verify|stopped, head, base, summary, findings[{id,verdict,evidence,commit}], gates,
ac_status[{ac,accepted,test,evidence}], rulings[], found_else[], skill_lessons[{skill,lesson,evidence}]}`.
Empty lessons are normal. Never edit skills/memory yourself.
End with `MAIN SESSION: check and save these skill_lessons now.`
