---
name: docker-desktop-crash-wsl
description: On the WSL desktop Docker Desktop can crash mid-gate (docker_data.vhdx unmount error); Postgres tests then fail with connection errors; ask Justin before restarting it
metadata:
  type: reference
---

On the Windows desktop, Docker Desktop can crash in the middle of a gate run while its Windows processes keep running. WSL then loses `/var/run/docker.sock`, and every Postgres-backed test fails with "connection reset by peer / unexpected EOF / connection refused" — an environment block, not a branch failure.

- Linux `docker` only says the socket is missing. The real error: `cd /mnt/c && "/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe" info` → "Docker Desktop is unable to start … wsl.exe --unmount docker_data.vhdx: exit status 0xffffffff".
- Seen 2026-11-08 13:48 (86bccndx6 fixer 8); memory was fine (~14.5 GB free, no earlyoom kill) and it did not recover by itself; a WSL restart (14:32) brought it back with `leorna-pg` up. A restart also stops running background agents: resume or re-dispatch them from the saved briefs ([[resuming-stopped-sessions]]).
- Restarting Docker Desktop is Justin's call: shared containers (`leorna-pg`, story preview containers) live there. Agents report the gate as environment-blocked and leave their containers for removal after the restart.
- Earlier variant (2026-11-07, 86bccndx6 fixer 2/reviewer 3): Docker WSL integration vanished after an internet reconnect.

Related: [[disk-full-recovery]].
