---
name: desktop-test-browser-libs
description: "On the WSL desktop, Chrome/Playwright lack libnss3/libnspr4/libasound; ~/.cache/chrome-libs supplies them via LD_LIBRARY_PATH, no sudo"
metadata:
  node_type: memory
  type: reference
  originSessionId: f1556db6-6159-4975-89fb-c984b55ca19a
  modified: 2026-11-21T18:31:23.387Z
---

On the Windows desktop (WSL Ubuntu 26.04), `libnss3`, `libnspr4`, `libnssutil3`, `libsmime3` and `libasound.so.2` aren't installed system-wide, so Chrome for Testing and Playwright's headless shell fail with `libnspr4.so: cannot open shared object file`. The folder `~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu` (unpacked Ubuntu packages from earlier jobs) supplies all of them: run browser tests with `LD_LIBRARY_PATH=$HOME/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`. No install or system change is needed. Try that before calling the browser blocked or asking Justin to run sudo. Proven by the tennis-booking builder on 2026-11-21: Playwright 1.65 launched Chrome 158 OK.

Related Node gotcha from the same job: on Node 22, `node --test test/` doesn't run the folder's tests. Node treats the argument as a file (MODULE_NOT_FOUND). Use `node --test "test/*.test.js"` instead.

Related: [[desktop-docker-gotchas]], [[desktop-disk-fills-c]]
