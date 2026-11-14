---
name: desktop-disk-fills-c
description: "2026-11-13 C: hit 100% on the Windows desktop; what grows, what is safe to clear, and why Linux deletes don't free C:"
metadata:
  node_type: memory
  type: project
  originSessionId: d1054df6-8252-4b2e-9fa2-fa63b23b5d3d
  modified: 2026-11-14T02:15:25.734Z
---

On 2026-11-13 C: filled up (894G, 256M free; PowerShell couldn't start because the page file had no room). Ubuntu's disk file `C:\Users\Admin\AppData\Local\wsl\{b1e2e4de-c8ec-4f1b-b0a4-4abf2f407c02}\ext4.vhdx` had grown to 569G. Docker Desktop's `...\Local\Docker\wsl\disk\docker_data.vhdx` was 107G.

What grows without limit as pipelines run:
- `~/Documents/FigmaToBricksV2/.claude/worktrees`: 597 agent worktrees, 89G
- `~/.cache/<job>-<role>`: about 480 folders, 230G
- `~/.cache/go-build`: 53G
- `~/.hermes/cache/scratch`: 50G, kept at the user's choice

Cleared that day: 520 worktrees (only ones clean, on a branch, idle for 2+ days, removed with `git worktree remove` without `--force`), 374 job caches, go-build, Docker images and build cache, and the user's Recycle Bin and Temp. Ubuntu went from 506G used to 202G.

Kept: tool caches in `~/.cache` (chrome-for-testing, chrome-libs, google-chrome-for-testing-headless, fontconfig, go-1.27.4-builder, goimports, zig, ubuntu-insights, figma-to-bricks, ssh, token-report, hg-live, claude) and the harness test caches (harness-guards-tests, dream-tests, trim-tests, cortexos-memory-tests, codex-parity-tests).

**Why:** deleting inside Linux doesn't shrink the vhdx. C: only gets the space back after `fstrim`, `wsl --shutdown` and diskpart `compact vdisk`, and Docker's vhdx needs the same.

**How to apply:** when C: is low, check these folders first and compact afterwards. See [[desktop-freezes-under-agent-load]].
