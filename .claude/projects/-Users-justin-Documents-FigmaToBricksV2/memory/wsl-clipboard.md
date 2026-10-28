---
name: wsl-clipboard
description: "WSL clipboard: PowerShell Unicode-safe readback; WSLg xsel readback does not prove Windows delivery; use a Windows copy-button file when interop fails"
metadata:
  type: reference
---

Set: `powershell.exe -NoProfile -Command "Get-Content -Raw -Encoding UTF8 '<wslpath -w file>' | Set-Clipboard"`.
Read back with `[IO.File]::WriteAllText('<win path>', (Get-Clipboard -Raw), [Text.UTF8Encoding]::new($false))` and
compare that file. Piping `Get-Clipboard -Raw` to WSL's stdout mangles ’ ® — (console code page), so the comparison
fails and the JSON looks broken although the clipboard is right (checked 2026-10-26, [[bdry-home-copy]]).

If PowerShell fails with `UtilBindVsockAnyPort` even with escalation, follow `~/.hermes/skills/software-development/figma-to-bricks/references/clipboard-delivery.md`. On 2026-10-28 the Windows preview URL was readable from WSLg, but reverse clipboard synchronization was not working: Justin reported no Windows paste despite complete 302,642-byte Linux readbacks with a persistent xsel owner. Do not claim Windows delivery from Linux readback. A detached xsel writer also yielded only 48,000 bytes later. The delivered fallback file is Windows Downloads → `Copy-All-Type-Home.html`, with a `Copy Home for Bricks` button; its file bytes were verified, but the user click and paste remain unconfirmed.

Image input into Codex (2026-10-28, CLI 0.165.0, Ubuntu/WSL2 in Windows Terminal): Justin reports Ctrl+V freezes the terminal and Alt+V closed it. Read clipboard diagnostics from `~/.codex/logs_2.sqlite` in SQLite read-only mode (`logs` table; `target LIKE 'codex_tui::clipboard%'`, fields `ts`, `level`, `target`, `feedback_log_body`), not a presumed `log/codex-tui.log`. Five attempts recorded only `paste_image_as_png: attempting clipboard image read`, with no completion or Windows fallback record. The installed binary includes a Windows PowerShell image fallback, but no successful workaround is confirmed yet. Windows Terminal's custom Ctrl+V Paste binding was removed through its Actions UI; the saved JSON has no Ctrl+V entry, not an explicit `id: null` unbinding. Do not report image paste fixed from that change. Justin wants direct screenshot copy/paste, not saved-file paths.
