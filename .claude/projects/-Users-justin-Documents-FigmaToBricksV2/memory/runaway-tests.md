---
name: runaway-tests
description: "A test or mutant that grows without end (15–17 GB) is stopped by earlyoom; agents must read it as a stopped run, never a normal failure; the orchestrator watches for it and tells the agent"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8e80bfe0-369d-4e32-84a6-8d63e5215658
  modified: 2026-11-03T01:22:16.941Z
---

On 2026-11-02 the phone-menu builder's unit test (`node test/unit/phone-menu.test.ts`, a mutation run) grew to
15–17 GB four times (17:07, 17:17, 17:17, 17:18) until earlyoom stopped it (`journalctl -u earlyoom`: "sending
SIGTERM to process … VmRSS …"). Cause (builder, same day): not a loop, but node's `assert.deepEqual` diff of two
whole IR trees once a mutant made them differ; the tests now compare lengths. Justin noticed and asked to check; that builder read the stops correctly, but "an agent
could misread a stopped test as a normal failure. The stop signal always shows in the output." He asked for this in the
main memory "for future chats and everything", and for the orchestrator to check if it happens again and notify the
agents.

**Why:** a runaway run takes the whole PC's memory (the desktop froze or restarted several times that day), and a
misread stop either hides a real runaway in the product code or counts a crash as a caught mutant.

**How to apply:**
- Every brief: bound mutation runs and probes (`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0` plus
  `--test-timeout`, as `mutation-testing-discipline` says); a run stopped by a signal (exit 137/143, the signal in the
  output) is a crash (`oom-kill`), never a normal failure or a behavioural kill; say why it grew and whether the real
  code can reach it.
- Standing rule since 2026-11-02 (global `~/.claude/CLAUDE.md` "Windows Desktop: Runaway Memory"): each time an agent
  returns, and before dispatching the next, run `journalctl -u earlyoom --since "<last check>" -o short-iso | grep
  sending`; match each kill's paths to an agent, message it (memory runaway, not a real result; rerun under the 4 GB
  cap), and tell Justin in one line, kills no agent owns included.
- The orchestrator also runs a watcher while agents work (`runaway-watch.sh` in the session scratchpad): it wakes the
  session when any node process passes 6 GB or earlyoom stops one, names the worktree (`agent-<id>` = the agent), and
  the orchestrator messages that agent at once: what grew, the stop, the rule above. Restart the watcher after each
  alert. See [[run-without-stopping]].
