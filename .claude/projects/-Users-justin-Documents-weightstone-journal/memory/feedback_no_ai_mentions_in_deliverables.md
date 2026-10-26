---
name: no-ai-mentions-in-deliverables
description: "All user-facing deliverables (docs, PDFs, briefs) must contain zero mention of Claude/Anthropic/AI assistance"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ca757a5a-ddc0-4401-b8df-359fc4b8c470
  modified: 2026-07-31T08:36:16.836Z
---

Justin requires that generated deliverables — documents, PDFs, project briefs, anything shareable — contain no mention of Claude, Claude Code, Anthropic, or AI assistance. This extends the global CLAUDE.md rule (no AI attribution in commits) to all output artifacts.

**Why:** These artifacts are used professionally (resume material, job applications); AI attribution would undermine them.

**How to apply:** Before finalizing any shareable document, sweep with `grep -i 'claude\|anthropic'` and phrase authorship as the user's own. Cite only git-tracked files in such docs — never CLAUDE.md itself (it's gitignored and reveals tooling). Related: [[resume-project-brief]].
