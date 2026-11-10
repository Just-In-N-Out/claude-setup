# Brief: dream-pass hand trial, step 1 (extraction) [claude-setup]

You are doing step 1 of a hand trial for a planned "dream pass" job. Nothing live is edited: every file you write goes under the scratch folder below. Do not edit any skill, memory file, `CLAUDE.md`, hook or setting, and do not commit anything.

Scratch folder (create it): `/tmp/claude-1000/-home-justin/e126e11b-3efb-4c0a-ba28-710cd6032a81/scratchpad/dream-trial/`

## The job
Write a small Python script `extract.py` in the scratch folder that turns one Claude Code session transcript into a compact digest, and run it on these three sessions:

1. `/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/519648e7-1ba1-46ba-a0a3-91e300b908f4.jsonl`
2. `/home/justin/.claude/projects/-home-justin-Leorna/8f17e198-9805-4134-b4ab-24a64684bbc6.jsonl`
3. `/home/justin/.claude/projects/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629.jsonl`

These files are large (up to 36 MB). Never read one into your context: inspect line shapes with small scripts (keys, counts, a few truncated samples).

## What the digest holds
For each message the user typed, in order: its line uuid, timestamp, the typed text in full, and before it the last 1,500 characters of the assistant's visible text that preceded it, clearly labelled as context. Output one file per session: `digest-1.md`, `digest-2.md`, `digest-3.md`, each starting with the session path, project folder and date range.

What counts as typed by the user:
- Lines with `type: "user"`, not `isSidechain`, not `isMeta`, whose `message.content` is a string or has `text` blocks.
- Leave out injected text: blocks that start with `<task-notification`, `<system-reminder`, `<command-name`, `<command-message`, `<local-command-stdout`, `<bash-input`, `<bash-stdout`, `[Request interrupted`, `[Image `, `Caveat:`, `This session is being continued`. Check the data for other injected shapes (hook output, skill bodies, agent messages such as "Another Claude session sent a message") and report every shape you find with a count; the list here is from a quick look and is probably incomplete. There is a `promptSource` key on user lines: report its values and whether it separates typed from injected text reliably.
- Pasted text: a `<pasted_content` block that is the whole message is kept and labelled `PASTE (whole message)`; a paste inside a typed message is dropped and replaced by `[paste omitted, N chars]`. `~/.claude/history.jsonl` records each prompt's `display` and `pastedContents` by `sessionId`; say whether it helps tell typed from pasted.
- Never include tool results, tool calls, thinking, attachments or file contents.
- Mask anything that looks like a secret (run `gitleaks` on the digests if that is simple: `/usr/local/bin/gitleaks`; otherwise a regex pass) and report whether anything was masked, without printing it.

The script must fail loudly (non-zero exit, a clear message) when a transcript with many lines yields zero typed messages, since the transcript format is internal and can change.

## Also measure, for the same three sessions (numbers only)
- Agent retries: how many times a tool call failed and a later similar call succeeded, as best a script can tell. Say how the failure is marked in these files (the string `"is_error":true` matched only 51 times across all main sessions, which looks too low) and how reliable your count is. Do the same count for these sessions' subagent transcripts (`<session-id>/subagents/*.jsonl` beside each file), with their total size.

## Report back, in plain words
- The paths of the script and the three digests, and for each digest: typed messages kept, characters, rough tokens, pastes kept and dropped, injected blocks dropped by shape.
- Anything in the transcript format that makes "typed by the user" hard to decide, with one truncated example each.
- The retry numbers and how far to trust them.
- `found_else[]`: other problems you noticed, one line each. Do not fix them.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only (a gotcha, an approach that worked after one failed); `enforce` is `none` or a one-line proposal for a check. An empty list is the normal answer. Never edit a skill or memory file yourself.
- End the report with the line `MAIN SESSION: check and save these skill_lessons now.`

Memory safety on this desktop: a command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Stream the files line by line; never load a whole transcript into memory.
