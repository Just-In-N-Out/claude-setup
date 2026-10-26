---
name: disk-full-recovery
description: "The Mac's 461 GB disk fills during long agent pipelines; what is safe to clear without asking, and what isn't"
metadata:
  node_type: memory
  type: reference
  originSessionId: 698cd962-9d84-4a09-af9f-c8fbef6f3f19
  modified: 2026-10-24T16:47:18.546Z
---

On 2026-10-24 the boot volume hit 268 MB free mid-pipeline (901u v3 verifier got ENOSPC). Big users then: `~/Library/Containers/com.docker.docker` 44 GB (holds the `leorna-test-pg` test DB), `~/.hermes/cache/scratch` 38 GB (Hermes' "pruned after 24 h" wasn't happening; mostly old agents' scratch from superseded attempts), `~/Library/Caches` 28 GB, `~/Downloads` 12 GB, Go build cache 9.2 GB.

- **Safe without asking:** `go clean -cache` (rebuildable compiled output; `pgrep -fl 'go (build|test)'` showed nothing on 2026-10-24 while a 945u `make check` was running, so also check `pgrep -fl 'make|golangci|go-build'` and other sessions' live agents first). It freed 9.2 GB → 9.5 GB free; it can end with "unlinkat … directory not empty" when another session is building, which is harmless to the clean but not to that build: a concurrent `make check` then fails across unrelated packages with "open ~/Library/Caches/go-build/…: no such file or directory" (945u verifier, 2026-10-24). That's a host failure: keep the log under a suffixed name and rerun the unchanged gate.
- **Ask first:** scratch folders (they belong to other sessions and to attempts Justin asked to keep untouched), Docker, Downloads, other caches.
- Agents running gates should check `df -h /` first and stop on a nearly full disk rather than report environment failures as code failures.

Related: [[zsh-bash-tool-gotchas]]
