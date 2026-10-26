---
name: wsl-clipboard
description: "On the Windows desktop (WSL), putting a paste on the clipboard and reading it back: non-ASCII breaks the stdout readback, not the clipboard"
metadata:
  type: reference
---

Set: `powershell.exe -NoProfile -Command "Get-Content -Raw -Encoding UTF8 '<wslpath -w file>' | Set-Clipboard"`.
Read back with `[IO.File]::WriteAllText('<win path>', (Get-Clipboard -Raw), [Text.UTF8Encoding]::new($false))` and
compare that file. Piping `Get-Clipboard -Raw` to WSL's stdout mangles ’ ® — (console code page), so the comparison
fails and the JSON looks broken although the clipboard is right (checked 2026-10-26, [[bdry-home-copy]]).
