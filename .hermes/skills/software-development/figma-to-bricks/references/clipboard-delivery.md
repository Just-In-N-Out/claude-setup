# Clipboard delivery on WSL

Back up the current clipboard before replacing it. Write the exact UTF-8 Bricks payload and compare a readback byte-for-byte; parsing JSON alone does not establish completeness. Keep a payload file as a fallback.

PowerShell interop normally supports Set-Clipboard. If it fails with `UtilBindVsockAnyPort` even after a permitted escalation, WSLg may still expose the shared desktop clipboard through `$DISPLAY` and `/tmp/.X11-unix/X0`. Use `xsel --clipboard --output` to back it up. If xsel is absent, a verified official Ubuntu package may be extracted into the task folder without sudo; do not install unverified binaries.

Run `xsel --clipboard --input --nodetach < payload.json` in a persistent exec session. Keep that owner session alive while Justin pastes. In a separate tool call, read `xsel --clipboard --output` to a file and compare its bytes and SHA-256 with the payload, then repeat after unrelated work. Do not close the owner after successful verification.

Observed 2026-10-28: a detached writer passed an immediate 302,642-byte readback, but a later command got only 48,000 bytes. A persistent foreground owner retained the complete payload across commands. Do not infer a clipboard-manager limit or its cause from this alone, or claim that same-command readback proves a usable paste. Native readback and a successful paste into Bricks are separate evidence.
