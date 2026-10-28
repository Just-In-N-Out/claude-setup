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
