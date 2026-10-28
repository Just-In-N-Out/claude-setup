# Task-local Chrome 2D runtime tools

These are runtime tool assets only, copied byte-for-byte from independently qualified plain/SVG/negative capture controls. No role report, acceptance result or feature finding is included here.

Copy both `run-capture.py` and executable `chrome-capture` into your own role's evidence/tool folder, preserving bytes and executable mode. Run your own copy with a fresh receipt name:

```sh
python3 /absolute/own-folder/run-capture.py --receipt UNIQUE-NAME /absolute/own-scratch/probe.ts
```

The runner pins Node `/home/justin/.local/node-v22.23.3/bin/node`, private TMPDIR/XDG storage, and its adjacent wrapper. The wrapper adds `--use-gl=disabled` to the existing Chrome for Testing binary. Logs and recipe receipts are written beside the copied runner, so never execute this shared copy or another role's copy. Your script and all output paths remain your responsibility; close browsers in finally and retain every original assertion.

Qualified scope: local 2D HTML/CSS/SVG actual PNG capture. GPU/WebGL fidelity and application acceptance are not established by these tooling controls. Run your own actual required tests and preserve runtime/source/exit receipts. A recipe JSON or wrapper exit is not a named-test pass; retain the real child stdout/stderr and actual status in the required test-log format.

Neither tool changes repository code or global security/configuration. Use normal approval paths and never bypass denied actions. Keep all role artifacts independent, especially verifier and blind auditor folders.
