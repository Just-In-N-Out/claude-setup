---
name: desktop-docker-gotchas
description: "Windows desktop (WSL) container gotchas — root-owned bind-mount files, /tmp is RAM, no host Rust, port 5432 taken by leorna-pg"
metadata:
  node_type: memory
  type: project
  originSessionId: a9335c8b-35f9-4848-b6b7-031b4326a629
  modified: 2026-11-07T01:28:42.691Z
---

- Containers that run as root write root-owned files into bind-mounted host folders; the host user then can't delete them (`Permission denied`). Pass HOST_UID/HOST_GID and `chown` in an EXIT trap inside the container.
- `/tmp` is a 9.8 GB RAM-backed tmpfs: cargo `target/` dirs and big build output belong in docker volumes or under `/home`, not `/tmp` (it competes with the 20 GB WSL cap, see [[desktop-freezes-under-agent-load]]).
- coreutils here are uutils 0.8.0 (`/usr/lib/cargo/bin/coreutils`: mkdir, realpath). `mkdir dir` is NOT atomic under contention (two racers both succeeded 29/300; python os.mkdir 0/300), so a mkdir-based shell lock can have two holders. Use bash noclobber `(set -C; printf '%s\n' $$ >lock) 2>/dev/null` (O_EXCL). `~/.claude/setup/sync.sh:86` still uses a mkdir lock (follow-up offered 2026-11-07). uutils `timeout` adds ~100 ms per call even for `true` (it polls): in latency-budgeted hooks bound a child with a sleep-and-kill watchdog instead.
- No Rust toolchain on the host; Rust builds run in a capped `rust:*` container.
- Host port 5432 is held by the `leorna-pg` container (leorna-control-plane dev DB); CortexOS's local stack uses 5433 via an untracked `local/docker-compose.dev.yml`.

**Why:** the CortexOS planner (2026-11-06) hit the permission error on artifacts written by a root container, and the first CortexOS start failed on the 5432 clash.
**How to apply:** brief agents running containers on the desktop with these.
