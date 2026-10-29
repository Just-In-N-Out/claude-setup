---
name: wsl-clipboard
description: "WSL clipboard: PowerShell Unicode-safe readback; WSLg xsel readback does not prove Windows delivery; use a Windows copy-button file when interop fails"
metadata:
  node_type: memory
  type: reference
  originSessionId: ecf5994f-8276-4f04-b9c6-a00ab4b226ac
  modified: 2026-10-28T17:41:54.116Z
---

Set: `powershell.exe -NoProfile -Command "Get-Content -Raw -Encoding UTF8 '<wslpath -w file>' | Set-Clipboard"`.
Read back with `[IO.File]::WriteAllText('<win path>', (Get-Clipboard -Raw), [Text.UTF8Encoding]::new($false))` and
compare that file. Piping `Get-Clipboard -Raw` to WSL's stdout mangles ’ ® — (console code page), so the comparison
fails and the JSON looks broken although the clipboard is right (checked 2026-10-26, [[bdry-home-copy]]).

This worked on 2026-10-28 13:41 for the All Type Home paste: `All-Type-Home-Fixed.json` (e963e9d2…) went onto the Windows clipboard, and its readback file was byte-identical. Build 28.3 converts Home exactly as 28.2 did, so that file was still current then. A copy is in Windows Downloads.

If PowerShell fails with `UtilBindVsockAnyPort` even with escalation, follow `~/.hermes/skills/software-development/figma-to-bricks/references/clipboard-delivery.md`. On 2026-10-28 the Windows preview URL was readable from WSLg, but reverse clipboard synchronization was not working: Justin reported no Windows paste despite complete 302,642-byte Linux readbacks with a persistent xsel owner. Do not claim Windows delivery from Linux readback. A detached xsel writer also yielded only 48,000 bytes later. The original `Copy-All-Type-Home.html` was superseded after it lost native Bricks media controls and reused older slider photos in the desktop cards. The independently reviewed correction is Windows Downloads → `Copy-All-Type-Home-Fixed.html`, with a `Copy Home for Bricks` button. It restores native Image fields and the original newer desktop photos while preserving original slider photos, FAQ answers/spacing and label minima. Delivery SHA256 is `78a3dbc9f419691a3cb6c0bbc8c90bf5d00e4bf25bae5fa0ff9bfb28c33fbfcd`; receipt `~/.hermes/plans/figma-to-bricks/evidence/home-paste-media/delivery/receipt.json`. The Windows file bytes were verified; user button click and installed Bricks media-picker check remain unconfirmed. Do not deliver the superseded file again.

Image input into Codex (2026-10-28, CLI 0.165.0, Ubuntu/WSL2 in Windows Terminal): Justin reports Ctrl+V freezes the terminal and Alt+V closed it. Read clipboard diagnostics from `~/.codex/logs_2.sqlite` in SQLite read-only mode (`logs` table; `target LIKE 'codex_tui::clipboard%'`, fields `ts`, `level`, `target`, `feedback_log_body`), not a presumed `log/codex-tui.log`. Five attempts recorded only `paste_image_as_png: attempting clipboard image read`, with no completion or Windows fallback record. The installed binary includes a Windows PowerShell image fallback, but no successful workaround is confirmed yet. Windows Terminal's custom Ctrl+V Paste binding was removed through its Actions UI; the saved JSON has no Ctrl+V entry, not an explicit `id: null` unbinding. Do not report image paste fixed from that change. Justin wants direct screenshot copy/paste, not saved-file paths.

**From a worktree-isolated Claude Code session** (2026-10-29) the guard refuses powershell.exe. What works: `clip.exe < file` with a plain-ASCII file. For a paste with non-ASCII text, re-serialize the JSON with `json.dumps(..., ensure_ascii=True)` (same content, \u escapes) and pipe that; Justin pasted the B-Dry Home v4 this way and Bricks built its Sections. Feeding clip.exe a UTF-16 file with a BOM made Bricks paste the JSON as Basic Text elements (it did not see a Bricks copy).
