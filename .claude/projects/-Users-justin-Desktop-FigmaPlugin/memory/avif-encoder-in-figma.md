---
name: avif-encoder-in-figma
description: Figma's plugin panel has no WebCodecs (not a secure context); AVIF photos come from jSquash's libaom WASM in classic blob workers, hash-pinned from jsDelivr
metadata:
  type: project
---

Build 2026-09-30.4. Photos upload (or embed) as AVIF by default ("Photos as" in ui.html).

- **Figma's plugin panel is a sandboxed null-origin data: frame, not a secure context**: `VideoEncoder` (WebCodecs) and `crypto.subtle` are undefined there, and module workers fail to start. Classic `new Worker(blobURL)` works, as do WebAssembly, fetch to CDNs, and dynamic import. Headless Chrome on a normal page is NOT a valid stand-in: test inside `<iframe sandbox="allow-scripts" src="data:...">` (tests/tools/avif-check.js does this). Build 2026-09-30.3 shipped a WebCodecs encoder that worked in headless Chrome and gave the user 22 placeholders in Figma.
- The encoder: @jsquash/avif 2.1.1 `codec/enc/avif_enc.js` + `.wasm` from cdn.jsdelivr.net, SHA-256 pinned (JS sha256 in ui.html, since crypto.subtle is missing). The ES-module glue is turned into a classic worker script (`avifWorkerSource`: import.meta.url → var, export dropped), wasm passed as `wasmBinary`. 3 workers, 8x8 probe encode at start.
- Photo test (`isPhoto`): visible pixels only (alpha >= 128), >= 256 distinct colours and the 16 most common < 50% of them; transparency allowed, alpha kept lossless (qualityAlpha 100). Real design: photos 873-3346 colours / 2-27% flat; maps ~200 / 70%; logos <= 34 / 92-100%. Small gradient emblems count as photos (accepted).
- Settings: quality 80, speed 10 → ~0.4 s per 2560px photo, PSNR ~40-43 dB, about half of JPEG 0.9's size. First download + check ~2.5 s, then cached for the session.
- WordPress 6.8+ refuses AVIF on servers without AVIF support: `400 rest_upload_image_type_not_supported`.

User decisions: see [[no-silent-format-fallback]]. Related: [[headless-chrome-bricks-check]].
