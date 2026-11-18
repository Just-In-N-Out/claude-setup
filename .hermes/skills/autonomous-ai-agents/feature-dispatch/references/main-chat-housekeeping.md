# feature-dispatch: main-chat housekeeping (lines moved whole from SKILL.md; load when Justin asks for status or the chat is quiet)

## Ask to reset the main chat

The main WhatsApp chat grows with every turn, and each message re-sends all of it: about a third of a day's usage. So whenever you notice that **no agent is running** (`delegate_task(action="list")` shows none live, and no board entry is in planning, building, reviewing, finishing or checking), ask once:

```
🧹 **Nothing's running.** Reset the main chat to save usage? Send **/new**.
Open items are saved: <one line, e.g. "2 plans waiting for go" or "nothing open">.
```

- Check this when the last agent's result comes in (after relaying it), and when he starts a new topic with no agents live.
- **Start queued work first.** If a `queued` feature is now unblocked, dispatch it instead of asking.
- Ask once per quiet spell. Don't repeat it on every message. Ask again only after agents have run and stopped again.
- Never ask while an agent is live: `/new` cuts running agents off.
- Before asking, make sure everything needed is saved: the board is current, every plan and his answers are in their plan files, and rulings are in HANDOFF. A fresh chat rebuilds the state from the board ("What are we working on?").

**In Claude Code (2026-11-10):** a pipeline main session runs on Opus 5.5 high. At step 1 it says which model and effort it is on and, when they differ, asks for `/model opus` and `/effort high` in the same question as Full or Mini. Each time the last running agent returns, it reads its own context size: `python3 ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/token-report/report.py context ~/.claude/projects/<project key>/<session id>.jsonl` (both names are in its scratchpad path, `/tmp/claude-<uid>/<project key>/<session id>/scratchpad`). Past 300k tokens with no agent running, it asks once per quiet spell for a fresh session, by the rules above (nothing live; every plan, brief, his answers and every evidence file saved), and the new session resumes from the plans, briefs and evidence. *Why: the main session was 10.1% of the pipeline's tokens, at 331k of context per call on average.*

## What are we working on

When Justin asks this (or "what's going on", "list the agents", "status"), answer from real state, never from memory of the chat:

1. Run `terminal(command="python3 -I ~/.hermes/scripts/dispatch_status.py --all")` for the board's phases, times and commits.
2. Call `delegate_task(action="list")` and match each live agent to its board entry by name. For an active board entry with no live agent, inspect the latest result and worktree before calling it running or failed. If already-approved work stopped only on a provider error, follow `references/away-and-recovery.md` and resume from the verified saved state when the provider is available; report the interruption and restart. Keep genuine decision, approval, quota and dependency holds separate rather than repeatedly offering to resume work the user already authorized.
3. Reply with one block per feature, grouped by phase (building → reviewing/finishing → planning → waiting for go → stopped → done in the last 3 days):
   ```
   🔨 faq-icons [Figma] — building, 25 min, 3 commits
      Task: rotate the FAQ + into × when open
      Agent: builder (live)
   📋 tabs-support [Figma] — waiting for your go (since 10:40)
   ```
4. End with what needs him: "Waiting on you: tabs-support (go?)".

**"How long did it take?"** Answer from the dispatch timestamps and each child's reported duration, not memory: wall clock from the planner's dispatch to the merge, then a small table per stage (plan, build parts, review, each fix → verifier round, release), the agent total, and the gap spent waiting on Justin. Close with the concrete reasons it ran long (decision stops, extra loop rounds, long gates).

**"Full breakdown" / "agents now and after the queue":** four parts, each line with its model and effort: 🟢 running now (role, minutes, commits); ⏭ what follows each running one (its next roles, and what its merge unblocks); ⏳ queued and approved (item count, what it waits for); 📋 the order from here. Close with the agents still to come per subscription, what merged today, and usage for both.

**"Will it update the docs / `CLAUDE.md`?"** Answer from the loop: the planner changes no files. After "go", the builder writes the plan copy, ledger and HANDOFF in its worktree, and the finisher bumps the build and updates the main `CLAUDE.md` after the merge. Point to the plan's Docs & records task, and steer the planner if that task is missing.
- **Pausing agents:** stopping a Claude Code agent (TaskStop) leaves its test runs going: `systemd-run --user --scope` units and their no-network namespaces keep Chrome and node alive (FigmaToBricksV2, 2026-11-18: 4 stopped agents left ~425 processes at load 60). After stopping, `systemctl --user stop` each `run-*.scope` and kill only processes whose paths name the agents' own TMPDIR or worktree, never every chrome/node.
