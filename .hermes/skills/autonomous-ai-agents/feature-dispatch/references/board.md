# feature-dispatch: the board (lines moved whole from SKILL.md "The board")

## The board

```
python3 -I ~/.hermes/scripts/dispatch_board.py set <name> task="…" phase=planning agent=<id>   # new feature
python3 -I ~/.hermes/scripts/dispatch_board.py set <name> phase=building agent=<id>
python3 -I ~/.hermes/scripts/dispatch_board.py set <name> phase=awaiting-go ask="plan ready (2 q)" reply_hint="go / 1B"
python3 -I ~/.hermes/scripts/dispatch_board.py set <name> note="revising for 3B"
python3 -I ~/.hermes/scripts/dispatch_board.py rm <name>     |     show [name]
```

The helper handles this bookkeeping:
- It stamps `started` and `phase_since`.
- It stamps `asked_at` when a feature starts waiting or gets a new `ask`, and drops `asked_at`/`ask`/`reply_hint` when it stops waiting.
- It defaults `plan` and `branch`, and prunes merged/ready/verified entries older than 3 days.
- `key=` deletes a field.
- `DISPATCH_BOARD=<path>` points it at a test copy. Set it inline for a single command and never `export` it: the terminal keeps exported variables, so later real updates silently land in the test file (it warns on stderr when set).
- **Pin coordinator HOME and the absolute board after worker test environments.** The terminal can retain a worker's isolated `HOME`; `python -I` does not reset environment variables and the helper's default `~` then resolves inside that sandbox. Before the first post-worker board operation, check nonsecret HOME/HERMES_HOME/DISPATCH_BOARD and pass the intended real HOME plus the absolute authorized board path inline. Read back that exact file, preserve sibling entries, and remove only a proven accidental task-owned stub if a wrong-home write occurred; never recreate missing rows blindly.

The fields:

```json
{"faq-icons": {"project": "figma-to-bricks", "phase": "planning|awaiting-go|awaiting-answer|queued|building|reviewing|finishing|verifying|merged|checking|verified|ready|stopped",
  "task": "one plain line: what the feature does",
  "plan": "~/.hermes/plans/figma-to-bricks/faq-icons.md", "agent": "<subagent id>",
  "started": "2026-10-21T10:00Z", "phase_since": "2026-10-21T10:40Z",
  "branch": "worktree-faq-icons", "note": ""}}
```

- **Waiting on Justin:** whenever you send him a plan or a question, set `phase=awaiting-go` (a plan) or `phase=awaiting-answer` (a question mid-build), with `ask="<one line, e.g. plan ready: rotate the + into × (2 questions)>"` and `reply_hint="go / 1B / change: …"`. To re-ask in the same phase, pass a new `ask`: that restarts the reminder count. When he answers, set the next phase.
- **Move the board the moment he answers**, before any other work in that turn. The reminder cron reads the board every 2 min, so a plan he has answered but that is still marked `awaiting-go` sends him a **NEEDS YOU** right after his reply. For a requested observation such as a build banner or destination URL, replace the obsolete question with its answer in the existing plan and feature-owned handoff, then steer the current owner or dispatch a continuation at the first unresolved boundary. Preserve user-reported versus independently observed provenance; answering one question does not establish the root cause or authorize implementation. Reuse the saved brief, audit and artifacts instead of a full project-context reload or another unchanged probe cycle. Keep the acknowledgment to the received fact and confirmed next state; do not ask for evidence already supplied.
- **Track an active review and an unanswered release decision separately.** Independent review can proceed while a layout/scope choice is pending, but write the exact question and no-release boundary in the plan, reviewer brief and board note. Read the board entry back after the phase transition: the helper clears waiting-only `ask`/`reply_hint` fields in active phases, so setting them alongside `reviewing` does not preserve the question. Keep a durable pending-decision note until the answer is recorded; a clean review must not erase that hold.
  - **Ask release-blocking decisions while review or verification runs, not after it returns clean.** Collect every question the merge will need (acceptance clarifications, a pre-existing proof gap needing a per-release waiver) into one lettered message with ⭐ picks as soon as each is known, so a clean verifier can go straight to the merge finisher in the same turn. Waiting for the clean result and only then asking adds a full idle round-trip. Record the answers in the plan and carry them into the finisher brief; an unanswered question still holds the merge. When the head must move anyway (a main merge, an answered README edit), say so in a decider's brief and batch every decided change into that one fixer round, so a change costs no extra verify round (901j decider).
- `phase=queued` means approved but waiting for a named source dependency, builder slot or resource/quota condition. Put the exact condition in `note`; start its builder when that condition clears, not automatically only after a merge. Prepare its brief while it waits so the next eligible completion can launch it without another planning round.
- **Refresh resolved blockers in status notes immediately.** When a fresh check clears a storage, quota or dependency hold, update the board note and steer the live owner in the same turn; otherwise scheduled pings keep presenting an obsolete blocker. State that the new measurement cleared that condition, not that it proved the original failure's cause.
- Branch names are fixed, so progress can be read without asking the agent: Figma `worktree-<name>`, Leorna `feat/<name>`. Tell every builder to use exactly that branch name.

Plans live in `~/.hermes/plans/<project>/<name>.md` (not the scratch dir, which is pruned after 24 h).
