---
name: justin-profile
description: Who Justin is on the Leorna project and how he likes explanations and decisions handled
metadata: 
  node_type: memory
  type: user
  originSessionId: e54e7fd6-b3b2-43ef-895f-ae478c9748f1
  modified: 2026-10-06T22:13:41.146Z
---

Justin is a newer developer (intern-tagged stories) on Leorna's small team, working in both `leorna-control-plane` and `leorna-client`. He asks for plain-language explanations, wants to see things run, and asks direct questions rather than guessing. He will ask the same question again if the answer was too long to land; when that happens, answer in one line first.

He is careful about process: stops work that oversteps a story's scope, defers repo-wide decisions to the team, and opens PRs himself with text I provide. He worries about visibly showing progress to the team; concrete, paste-ready ClickUp comments help.

When he asks "which stories can I do", he wants a yes/no per card with its blocker, not a plan; he says "do not plan or do anything" when he only wants an answer. Write plans only when asked.

For hands-on checks in an interactive tool (e.g. Codex TUI), multi-step instructions confused him ("what do you want me to do"). What worked (2026-10-06): open a Terminal window for him with `osascript ... do script`, then ask one yes/no question per step, and read results from files yourself instead of asking him to copy output. Always target that window by the id `do script` returned, after checking its tab is idle, never "front window": once that typed a command into another running Claude Code session.

**How to apply:** Lead with the direct answer, keep jargon explained, give commands in copy-paste blocks. When a choice is a team decision say so, but see [[infer-and-list-assumptions]] for what to do when the team has not answered. Related: [[stop-and-show-diff]], [[leorna-workflow]].
