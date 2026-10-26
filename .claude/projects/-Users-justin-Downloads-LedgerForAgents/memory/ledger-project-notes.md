---
name: ledger-project-notes
description: "LedgerForAgents environment facts not in the repo - venv recreated with Python 3.13, PyCharm still points at the old 3.9 interpreter, no remote"
metadata: 
  node_type: memory
  type: project
  originSessionId: f79f5b9f-5a9e-4fdd-b5ea-707da1d9ed2d
  modified: 2026-09-13T20:33:36.501Z
---

LedgerForAgents (`/Users/justin/Downloads/LedgerForAgents`) is the append-only undo-history project built from `ledger-implementation-spec.md` on 2026-09-13.

- `venv/` was deleted and recreated with `/opt/homebrew/bin/python3.13` (the original was Xcode's Python 3.9, below the spec's 3.11 floor). The PyCharm config in `.idea/` and `LedgerForAgents.iml` still names "Python 3.9 (LedgerForAgents)"; Justin needs to re-point the interpreter in PyCharm.
- Git was initialized during the build; everything is on `main` with no remote.
- Justin referred to the spec as "agent.md"; the actual file is `ledger-implementation-spec.md`.
- The spec's design decisions and open questions are recorded in the repo's README, not here.

Related: [[build-style-parallel-subagents]].
