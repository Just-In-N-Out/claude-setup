---
name: wsl-clipboard
description: "WSL clipboard: PowerShell Unicode-safe readback; WSLg xsel fallback needs a persistent owner and a separate full-byte check"
metadata:
  type: reference
---

Set: `powershell.exe -NoProfile -Command "Get-Content -Raw -Encoding UTF8 '<wslpath -w file>' | Set-Clipboard"`.
Read back with `[IO.File]::WriteAllText('<win path>', (Get-Clipboard -Raw), [Text.UTF8Encoding]::new($false))` and
compare that file. Piping `Get-Clipboard -Raw` to WSL's stdout mangles ’ ® — (console code page), so the comparison
fails and the JSON looks broken although the clipboard is right (checked 2026-10-26, [[bdry-home-copy]]).

If PowerShell fails with `UtilBindVsockAnyPort` even with escalation, use the WSLg fallback in `~/.hermes/skills/software-development/figma-to-bricks/references/clipboard-delivery.md`. On 2026-10-28 the preview URL was readable from WSLg, proving desktop sharing; a detached xsel writer later yielded only 48,000 of 302,642 bytes. `xsel --clipboard --input --nodetach` in a persistent exec session retained all bytes across commands. Keep that session alive until paste; verify full bytes in a separate tool call.
