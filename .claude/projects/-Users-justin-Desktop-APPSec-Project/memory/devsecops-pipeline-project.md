---
name: devsecops-pipeline-project
description: "Project state — local dir maps to Just-In-N-Out/devsecops-pipeline on GitHub, released v1.0.0 2026-06-11; plus a verified GitHub Actions context gotcha"
metadata: 
  node_type: memory
  type: project
  originSessionId: ab071ebb-4226-4d7f-9a7d-4ad116b3ea2e
  modified: 2026-07-31T08:35:15.436Z
---

This directory is the source of `https://github.com/Just-In-N-Out/devsecops-pipeline` (reusable GitHub Actions security pipeline; spec in repo CLAUDE.md, which is excluded from git via `.git/info/exclude`). Released through v1.1.1 on 2026-06-11 (v1.1.0 added the HTML report stage; v1.1.1 fixed the quickstart to set top-level `permissions: contents: read`). Floating tags `v0`/`v1` are moved by `release.yml` on tag pushes. Self-test green, Security tab populated by all four SARIF stages.

**Demo repo:** `https://github.com/Just-In-N-Out/devsecops-pipeline-demo` (separate dir `/Users/justin/Desktop/devsecops-pipeline-demo`) — clean Flask app on `main` (green, consumes `@v1`), open PR #1 `demo/planted-findings` with one finding per scanner (red gate verified live). Building it surfaced `CKV2_GHA_1`: a consumer workflow with no top-level `permissions` block fails the pipeline's own Checkov stage — hence the v1.1.1 quickstart fix. To push workflow files use plain `git push` (keyring token has `workflow` scope); `gh repo create --push` uses an OAuth token that does NOT.

**Verified live (2026-06-11):** inside a reusable-workflow job, `github.job_workflow_ref` evaluates to **empty** — the working property is `job.workflow_ref` (gives `owner/repo/.github/workflows/file.yml@ref` of the *called* workflow). All workflows use a two-candidate cascade; don't "simplify" it back to the github context. Also: the semgrep container (Alpine) has no bash/jq/gh, so `sast.yml` splits scan (container job) from gate (ubuntu job) — keep that structure.

**Re-verified live 2026-07-31:** self-test green on `main` (latest run 2026-06-23); demo PR #1 still open — all scan-stage jobs pass, `security / severity gate` fails red (designed behavior, good portfolio evidence). Released through v1.1.2 (secrets findings reclassified critical).

**Known unfixed bug (found 2026-07-31, code-verified):** `scripts/severity-gate.sh` derives the stage name from the SARIF parent dir (`sarif-*` prefix strip) and never consults the `STAGE_NAME` env var. Standalone stage workflows use `SARIF_DIR: sarif-out`, which matches the glob → stage becomes `"out"`, so the v1.1.2 secrets→critical override does NOT fire on standalone `secrets-scan.yml` runs (secret floors at medium, passes a `high` gate) and stage labels are wrong in summary/comment/report. `full-scan.yml` path unaffected (`sarif/sarif-<stage>/`). Fix: prefer `STAGE_NAME` over the directory heuristic.

**Resume brief (2026-07-31):** `project-brief.md` + `devsecops-pipeline.pdf` live in the repo root but are git-excluded via `.git/info/exclude` (alongside CLAUDE.md) — resume source material, must never be pushed; contains no AI/Claude mentions by explicit request. PDF toolchain on this machine: `brew install` is blocked by brew's tap-trust check on pre-existing untrusted taps (mongodb/brew, osx-cross/avr, supabase/tap) — don't `brew trust` without asking; working path is scratchpad venv (`pip install markdown pypdf`) → HTML → headless Chrome `--print-to-pdf`, with `font-variant-ligatures: none` in CSS so extracted PDF text stays ASCII-clean.
