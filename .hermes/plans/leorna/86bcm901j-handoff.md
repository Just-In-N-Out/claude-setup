# 86bcm901j-mcp-templates: orchestrator handoff

- Story: ClickUp 86bcm901j "Baseline MCP templates + secure tool configs", repo leorna-control-plane, **Full** pipeline (Justin's pick).
- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901j-mcp-templates`, branch `feat/86bcm901j-mcp-templates` (no upstream), base `1ee7157` = origin/main = local main (fast-forwarded at Justin's request, 2026-10-28).
- Plan: `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md` · briefs: `~/.hermes/plans/leorna/briefs/86bcm901j-mcp-templates-<role>.md` · evidence: `~/.hermes/plans/leorna/evidence/86bcm901j/`.
- Siblings in the same repo (other sessions): 86bcm901a (agent definitions), 86bcm901b (prompts collection). Never touch their worktrees, branches, test DBs or evidence folders; shared-file conflicts (delivery/stories.json, THIRD_PARTY_NOTICES.md, others the plan lists) are resolved at hand-over.

## Autonomous recommendation grant (Justin, 2026-10-28)

Justin's words: "Okay, look, I'm gonna go shower, so just keep this running, okay? Just go with the recommended stuff the agent says, alright?"

- **Reading:** this replaces the earlier "stop at the plan until I say go". When the plan returns with numbered ACs, take every ⭐ answer and the planner's proposed ACs as approved (= **go**), copy the plan to `<evidence>/plan-approved.md`, and run the Full pipeline: builder → review 1 → fixer → review 2 → fixer → verifier → AC auditor → ac-check → finisher hand-over. Agents' own recommended rulings are taken the same way.
- **Scope:** this story only.
- **Ends:** when Justin is back and says otherwise, or at the hand-over (finisher report ready).
- **Still forbidden (unchanged):** push, opening a PR, posting to ClickUp, merging. A decision that is genuinely Justin's (credentials, a security trade-off with no safe recommended option, a scope change) still stops and waits.

## Status

- 2026-10-28: planner dispatched (Opus 5.5 xhigh), plan only.
- 2026-10-28: plan returned (AC1–AC5; AC4, AC5 proposed; none live). Approved under the grant with every ⭐; Q5 Docker step owed by Justin; Q6 held for Justin (sandbox bypass = permission), option B meanwhile. Approved copy: `evidence/86bcm901j/plan-approved.md`.
- 2026-10-28: builder dispatched (Opus 5.5 xhigh), brief `briefs/86bcm901j-mcp-templates-builder.md`. Next: review 1 → fixer → review 2 → fixer → verifier → auditor → ac-check → finisher.
- 2026-10-28: builder returned ready-for-review at `7c2c35a` (3 commits, clean, Justin's identity, no AI lines; main session checked). AC1–AC5 tests pass on head, fail on base; 7 PNGs taken inside the sandbox, so Q6 isn't needed. Owed: Postgres gates + 3 catalog screenshots (Docker WSL integration still off). Builder rulings: make + Zig under `~/.local/leorna-tools`; dropped 2 unconfirmable example clauses.
- 2026-10-28: review 1 dispatched (Opus 5.5 xhigh), brief `briefs/86bcm901j-mcp-templates-review1.md`, candidate `7c2c35a`. Reviewer may run the Postgres gates with the no-sudo PostgreSQL recipe from the shared notes.
- 2026-10-28: review 1 returned **findings** on `7c2c35a` (evidence `evidence/86bcm901j/review1/`): R1-1 Major policy skips itself on decode failure; R1-2 Major Codex floor bypassable by case-variant keys + is a denylist; R1-3 Major rule P failure reason repeats a token; R1-4..R1-7 Minor (npx `=` flags, rule S blind spots, 2 surviving mutants, history doc overclaim); R1-8 Nit (WaitDelay). AC1–AC5 accepted for the shipped content; all gates green incl. Postgres via the no-sudo PostgreSQL recipe (so the Docker step no longer blocks this story; catalog UI screenshots still owed). Agreed with all 4 builder rulings.
- 2026-10-28: fixer 1 dispatched (Opus 5.5 xhigh), brief `briefs/86bcm901j-mcp-templates-fixer1.md`; stops at ready-for-next-review. Next: review 2 of the corrected code.
- 2026-10-28: fixer 1 returned ready-for-next-review at `f36285d` (9 commits on top of `7c2c35a`; main session checked identity, no AI lines, clean tree). All 8 R1 findings valid and fixed; 67/67 mutants killed; all gates green incl. Postgres (no-sudo). Fixer rulings to confirm: Claude settings may set no `env`; exact Codex/Claude allowlists (e.g. `model` not allowed for Codex yet); extra credential words in the policy only; AC2 subtest name kept.
- 2026-10-28: review 2 dispatched (Opus 5.5 xhigh), brief `briefs/86bcm901j-mcp-templates-review2.md`, candidate `f36285d`.
- 2026-10-28: review 2 returned **findings** on `f36285d` (no Critical/Major): R2-1 Minor server env PATH/LD_*/NODE_* can change what runs (real Claude Code ran a fake npx); R2-2 Minor policy reasons quote keys, so a token in a key is repeated; R2-3 Minor 9 surviving single-word mutants; R2-4 Nit camelCase credential names; R2-5 Nit wrong reason for defaultMode "manual". All AC1–AC5 accepted; R1-1..R1-8 closed; agreed with fixer 1's 4 rulings; all gates green incl. Postgres. Evidence `evidence/86bcm901j/review2/`.
- 2026-10-28: fixer 2 dispatched (Opus 5.5 xhigh), brief `briefs/86bcm901j-mcp-templates-fixer2.md`; stops at ready-for-verify. Next: verifier → AC auditor → ac-check → finisher.
