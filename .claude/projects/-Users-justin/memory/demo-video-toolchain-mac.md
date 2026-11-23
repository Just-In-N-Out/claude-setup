---
name: demo-video-toolchain-mac
description: Proven Mac toolchain and gotchas for filming Leorna demo shorts with Playwright + ffmpeg + Kokoro
metadata:
  node_type: memory
  type: reference
  originSessionId: 51bd1f8e-43d3-4a53-a378-0bbfa5b778bc
  modified: 2026-11-23T20:41:44.816Z
---

Built 2026-11-23 for Short 1 (86bd39xee); output in `~/Movies/Leorna/`.

- Kokoro TTS lives in `~/.venvs/kokoro` (Python 3.12; Homebrew's pip refuses system installs). Voice `af_heart`, speed 1.05. First run downloads a spaCy model from github.com.
- Brew `ffmpeg` 9.1 has **no drawtext/subtitles**: render captions and cards as PNGs in Playwright (`omitBackground`) and `overlay` them.
- Playwright: Leorna admin's CSP blocks injected styles, so cursor/blur overlays need `bypassCSP: true`. Record at viewport 1080×1920 with `html{zoom:1.25}`; a smaller viewport gets padded into the corner, not scaled. `Promise.all([waitForLoadState, click])` returns before navigation; use `waitForNavigation`. Moving to a `<select>` and `selectOption` beats clicking it (the native popup eats the next click).
- ffmpeg `zoompan` on a `-loop 1` image never ends: feed the still without `-loop` and add `trim=duration`.
- Admin team member picker is a directory `<select>` when a directory is connected; typed emails only work without one.
- Desktop client (Short 2): drive it with System Events (`entire contents of window 1`, match role+name; Wails web `<select>` menus aren't AX menus, so click then arrow keys + Return), glide/click with a CGEvent Swift helper, film with `ffmpeg -f avfoundation -i "1:none"` + crop (Retina pixels = 2× points). Terminal needs Screen Recording + Accessibility. Sign-in off camera: press Sign in, read "Approval code", then open `/client/authorize?user_code=<code>` with the admin Playwright session and click "Approve this device".
- Codex sync fails the whole tool if the pack has a Prompt (Codex ≥0.117 has no prompts) or a skill whose name already exists unmanaged in `~/.agents/skills` (e.g. Hermes links); drop those items in the library pack builder (untick the item, "Save as version N", "Validate and save new version").
- Smoothness (Justin found the speed-ramped Short 2 "too fast and choppy"): Playwright videos are 25 fps, so cut at 25 fps, keep clips at 1x and cut dead time with short `xfade=fade` dissolves; never speed-ramp or `zoompan` moving footage (integer-pixel jitter). Pin page height (`body{padding-bottom:1800px}`) so re-rendering previews can't jump the scroll.
- Pack editor "Preview by tool" labels (added/unchanged) compare with the preview team's current assignment, not the parent version: assign the old version for the take, then restore.

Related: [[leorna-local-postgres-mac]], [[leorna-short1-recording]].
