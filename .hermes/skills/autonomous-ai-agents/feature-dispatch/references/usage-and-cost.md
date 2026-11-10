# Provider usage and cost

Use SKILL.md for standing role routing, approval boundaries, quota thresholds and concurrency limits. This reference supplies measurement and reset recipes, not permission to change a model or weaken review.

## Measure at dispatch admission

1. Run `hermes usage` and `hermes usage --provider openai-codex` through `terminal`, batched with the lightweight admission checks.
2. Read the actual provider, plan, reported windows and reset times. If only a weekly window appears, report weekly usage and banked resets; do not infer a five-hour allowance from another subscription tier.
3. Apply SKILL.md's limit procedure to the affected provider and due role. A held Opus role does not itself prevent independently eligible Sol work. Do not import a global stop-all guard or infer permission to replace Opus.
4. Treat reset times as due, not completed: verify fresh usage before launching held roles. Preserve separate source, resource and release holds.

Use `hermes insights --days 1` for a requested cost breakdown, not every admission. Script-only status/reminder jobs do not require agent-generated replacements.

## Measure Claude Code tokens per story from disk

Subagent transcripts are `~/.claude/projects/<project>/<session>/subagents/agent-*.jsonl`, each with an `agent-*.meta.json` (model, effort, description, toolUseId); the main session is `<session>.jsonl`. Sum `message.usage` once per `message.id` (a response is written as one line per content block, each repeating the usage). Story and role come from the `briefs/<story>-<role>.md` path in the agent's first prompt. (Proven 2026-11-10, pipeline-token-diet: 971 of 979 agents mapped.)

## Redeem a banked Codex reset

Use only when a live window is exhausted and approved Sol work is running or waiting, under SKILL.md's standing permission. Never force redemption or spend early. Run through `execute_code`, which has Hermes's dependencies:

```python
import sys, os
sys.path.insert(0, os.path.expanduser("~/.hermes/hermes-agent"))
from agent.account_usage import redeem_codex_reset_credit
r = redeem_codex_reset_credit(force=False)
print(r.status, r.available_count, r.message)
```

If exhaustion marked the configured credential rate-limited and automatic selection returns no credential, use the existing pool entry without printing its values:

```python
from agent.credential_pool import load_pool
pool = load_pool("openai-codex")
if not pool._entries:
    raise RuntimeError("No configured Codex pool entry; stop reset recovery")
e = pool._entries[0]
r = redeem_codex_reset_credit(
    base_url=e.runtime_base_url,
    api_key=e.runtime_api_key,
    force=False,
)
print(r.status, r.available_count, r.message)
```

These blocks share one execution context; the second is conditional, not an unconditional second redemption. A refusal does not establish a reset. After confirmed redemption, run `hermes auth reset openai-codex` through `terminal`, verify usage and report remaining credits. Reconcile interrupted agents' actual worktrees, commits, dirty files and effects before resuming the first unmet task; do not replay the whole job. Keep recorded model scopes and all required gates.

## Reduce repeated context and recovery cost

| Lever | Procedure |
| --- | --- |
| Thin dispatcher | Read approved-plan status, answers, ownership and handoff sections; leave code appendices, investigation and role-specific references to the assigned agent. |
| Authoritative brief | Save one current-role brief with exact scope, permissions, source pins and next unmet task. Pass its path with a short context, not a chain of superseded briefs. |
| Relevant project rules | Load required project entry points, then references relevant to the role and next decision; do not restart broad discovery on a continuation. |
| Routing interval | Prepare approval records, brief and admission before route set → native dispatch → live-model verification → route reset. |
| Existing evidence | Reuse verified research and valid receipts; preserve needed owned artifacts with source/destination hashes. |
| Main-chat reset | Follow SKILL.md's idle-boundary procedure; never reset automatically or interrupt live children. |

For an authorized session-effort change, use `/reasoning` and verify effective session state. A writable configuration key with an unrecognized-key warning does not prove runtime reads it. For child effort, use the delegation setting within the verified routing interval and clear this dispatch's overrides afterward. Do not change model, effort or acceptance scope as a cost-saving shortcut.
