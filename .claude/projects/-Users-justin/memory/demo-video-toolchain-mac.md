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

Related: [[leorna-local-postgres-mac]], [[leorna-short1-recording]].
