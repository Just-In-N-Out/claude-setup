# CLAUDE.md — devsecops-pipeline

## Mission

Build a **reusable GitHub Actions security pipeline** that other repos consume as a library. This repo contains no application code. It contains reusable workflows, opinionated scanner configs, and documentation. Downstream repos reference these workflows from their own `.github/workflows/` using the `uses:` syntax.

This is a **production-quality reference implementation** of a centralized DevSecOps pipeline — the pattern a platform security team would ship internally. Build it that way.

## Author

Justin Issa (GitHub: `Just-In-N-Out`). All public-facing text should assume this repo will sit on his GitHub and be linked from his resume.

-----

## Scope boundaries (read before writing code)

- **Build only this repo.** Do not build a demo/consumer repo in this session. That’s a separate project.
- **No secrets. No tokens. No `.env` files.** This repo is public-safe by construction.
- **No application code.** No Python, no Node app. Just workflows, configs, scripts, docs.
- **Pin every third-party action to a full commit SHA**, not a tag. Supply-chain hygiene — the pipeline itself must model the behavior it enforces.
- **Never reference `@main` in usage examples.** Always pin to version tags (`@v1`). This is non-negotiable.

-----

## Repo structure

```
devsecops-pipeline/
├── .github/
│   └── workflows/
│       ├── full-scan.yml          # Main entry point — orchestrates all stages
│       ├── secrets-scan.yml       # Gitleaks
│       ├── sast.yml               # Semgrep
│       ├── deps-scan.yml          # Trivy (filesystem mode, deps)
│       ├── iac-scan.yml           # Checkov
│       ├── container-scan.yml     # Trivy (image mode)
│       ├── sbom.yml               # Syft
│       └── self-test.yml          # Runs full-scan against this repo itself
├── configs/
│   ├── semgrep.yml                # Semgrep ruleset
│   ├── gitleaks.toml              # Gitleaks custom rules + allowlist
│   ├── trivy-ignore.yaml          # Trivy baseline ignores
│   └── checkov.yml                # Checkov skip list + severity mapping
├── scripts/
│   ├── pr-comment.js              # Formats SARIF findings into PR comments
│   └── severity-gate.sh           # Evaluates SARIF against threshold, exits 0/1
├── docs/
│   ├── architecture.md            # How the pipeline is composed
│   ├── gating-policy.md           # Severity tiers and merge-blocking rules
│   ├── usage.md                   # Full usage guide for consumers
│   └── extending.md               # How to add a new scanner stage
├── .gitignore
├── LICENSE                         # MIT
├── README.md
└── CHANGELOG.md
```

-----

## The main entry point: `full-scan.yml`

This is the file every consumer repo references. Get this right.

### Triggers

It’s a reusable workflow, so the only trigger is `workflow_call`.

### Inputs

|Input               |Type   |Default|Description                                                                                                           |
|--------------------|-------|-------|----------------------------------------------------------------------------------------------------------------------|
|`language`          |string |`auto` |`python`, `node`, `go`, `java`, `auto`. Controls which scanners run. `auto` detects from repo contents.               |
|`severity-threshold`|string |`high` |`critical`, `high`, `medium`, `low`. Findings at or above this level fail the build.                                  |
|`skip-stages`       |string |`""`   |Comma-separated list: `secrets,sast,deps,iac,container,sbom`. Opt out of stages.                                      |
|`baseline-branch`   |string |`main` |Diff-only mode: only gate on findings not present in this branch.                                                     |
|`container-image`   |string |`""`   |Image ref (e.g. `ghcr.io/org/app:sha`) for container scan. If empty, stage is skipped even without `skip-stages` flag.|
|`fail-on-findings`  |boolean|`true` |If `false`, runs in advisory mode — reports but never fails. Useful for rollout.                                      |

### Secrets

`secrets: inherit` pattern. The workflow itself should require **no secrets** for a pure public-repo scan. Consumers pass `GITHUB_TOKEN` (auto-available), and optionally `SNYK_TOKEN` if they later swap Trivy for Snyk.

### Orchestration

Jobs run in parallel where safe. Dependency graph:

- `detect-language` runs first, outputs `language` for downstream matrix
- `secrets`, `sast`, `deps`, `iac`, `sbom` run in parallel after `detect-language`
- `container` runs only if `container-image` input is non-empty
- `gate` runs last, depends on all scan jobs, consumes their SARIF outputs via artifacts, runs `severity-gate.sh`, and either passes or fails

### Outputs

Each scan job uploads:

1. SARIF to `actions/upload-artifact`
1. SARIF to `github/codeql-action/upload-sarif` (this populates the Security tab)

The `gate` job uploads a consolidated `scan-summary.json` artifact.

-----

## Sub-workflow specs

Each sub-workflow is a standalone reusable workflow callable independently. They share this pattern:

- Input: `severity-threshold`, `baseline-branch`, `fail-on-findings`
- Output: SARIF file uploaded as artifact named `sarif-<stage>`
- Output: Exit code based on `fail-on-findings` and severity
- Posts PR comment via `scripts/pr-comment.js` if running on pull_request context

### `secrets-scan.yml` (Gitleaks)

- Use `gitleaks/gitleaks-action` pinned to commit SHA
- Full git history scan (fetch-depth: 0)
- Custom rules from `configs/gitleaks.toml`
- Output SARIF

### `sast.yml` (Semgrep)

- Use `returntocorp/semgrep` container, pinned digest
- Ruleset: `configs/semgrep.yml` which extends `p/security-audit`, `p/owasp-top-ten`, and language-specific packs (`p/python`, `p/javascript`, etc.) chosen by `language` input
- Output SARIF

### `deps-scan.yml` (Trivy filesystem)

- Trivy in `fs` mode, scans `package-lock.json`, `requirements.txt`, `go.sum`, `pom.xml`, etc.
- Ignore list from `configs/trivy-ignore.yaml`
- Output SARIF

### `iac-scan.yml` (Checkov)

- Checkov scans Terraform, Dockerfile, Kubernetes manifests, CloudFormation
- Framework auto-detection
- Skip list from `configs/checkov.yml`
- Output SARIF

### `container-scan.yml` (Trivy image)

- Trivy in `image` mode against `container-image` input
- Detects OS packages and language dependencies in the image
- Output SARIF

### `sbom.yml` (Syft)

- Syft generates SBOM in CycloneDX and SPDX formats
- Both uploaded as build artifacts
- Not a gate — informational only
- Tag release with SBOM if running on tag push

### `self-test.yml`

- Runs on every push to this repo
- Calls `full-scan.yml` against this repo itself
- Proves the pipeline runs cleanly on its own codebase (eat your own dog food)

-----

## Config files

### `configs/semgrep.yml`

Compose public rulesets rather than rewriting rules. Start with:

- `p/security-audit`
- `p/owasp-top-ten`
- `p/secrets`
- `p/ci`

Language packs loaded conditionally by `sast.yml` based on the `language` input.

### `configs/gitleaks.toml`

- Start from the default Gitleaks ruleset
- Add custom rules for: AWS session tokens, Stripe live keys, generic high-entropy strings with specific prefixes (`sk_live_`, `ghp_`, `xoxb-`)
- Allowlist block for `**/*_test.go`, `**/fixtures/**`, `**/testdata/**`

### `configs/trivy-ignore.yaml`

- Empty by default with a detailed comment block explaining how consumers extend it
- Example entries commented out

### `configs/checkov.yml`

- `soft-fail: false`
- `skip-check`: leave empty with documented examples
- `framework`: auto

-----

## `scripts/pr-comment.js`

Node script, zero external dependencies (use `@actions/github` which is available in Actions runtime).

Responsibilities:

1. Read SARIF files from artifact directory
1. Aggregate findings grouped by severity
1. Format a markdown table: stage | critical | high | medium | low
1. Post or update a single “sticky” PR comment (find existing by marker `<!-- devsecops-pipeline-comment -->`, update in place instead of spamming)
1. Include a collapsible `<details>` section per stage with top 10 findings (file, line, rule, message)
1. Link each finding to the GitHub Security tab

-----

## `scripts/severity-gate.sh`

Bash script. Reads `scan-summary.json`, compares against `severity-threshold` input, exits 0 or 1.

Baseline-diff logic:

- If `baseline-branch` is set, fetch that branch’s latest scan summary artifact
- Compute diff: only findings in current run AND NOT in baseline count toward the gate
- If baseline scan not found (first run), gate on all findings and log a warning

-----

## `README.md`

Must include, in this order:

1. One-sentence pitch: “Drop-in DevSecOps pipeline for GitHub Actions — secrets, SAST, dependencies, IaC, containers, and SBOM in one reusable workflow.”
1. Badge row: CI status from self-test, license, SBOM available, latest release tag
1. **Quickstart** — the 8-line YAML consumers paste into their repo, with `@v1` pinning
1. Table of all inputs with defaults and descriptions (same as the table above)
1. What each stage does in one sentence each
1. Gating policy summary (link to `docs/gating-policy.md`)
1. How to run a single stage independently (calling sub-workflows directly)
1. How to run in advisory mode during rollout (`fail-on-findings: false`)
1. FAQ: “My team has existing findings — how do I not block every PR?” → baseline-branch explanation
1. Link to `docs/extending.md` for adding scanners
1. License + author credit

Keep tone tight and technical. No marketing fluff. This reads like internal platform docs.

-----

## Documentation files

### `docs/architecture.md`

Diagram (ASCII or Mermaid) of the pipeline. Explain:

- Why reusable workflows vs actions vs composite actions
- Why SARIF as the universal exchange format
- Why a separate `gate` job at the end vs per-stage gating
- Why baseline-diff gating matters (inherited debt problem)

### `docs/gating-policy.md`

Severity tier definitions. Block/warn/inform matrix. How to override. Escape hatch for emergencies (labeled PRs, break-glass procedure).

### `docs/usage.md`

Full consumer guide. Every input documented with realistic examples. Common recipes:

- “Minimal setup for a new repo”
- “Gradual rollout on a legacy repo”
- “Python project with container”
- “Terraform-only repo”

### `docs/extending.md`

How to add a new scanner stage. Template for new sub-workflow file. PR checklist for contributions.

-----

## Versioning strategy

- Semantic versioning: `v1.0.0`, `v1.1.0`, etc.
- Floating major tag: `v1` always points to latest `v1.x.x`
- Release workflow (add as `.github/workflows/release.yml`): on tag push, generates release notes from CHANGELOG and moves the floating major tag
- Never break `v1` consumers — breaking changes require `v2`

`CHANGELOG.md` follows Keep a Changelog format. Initial entry: `v0.1.0 — Initial release`.

-----

## Testing approach

Since this repo has no app code, “testing” means:

1. **`self-test.yml`** must pass — full pipeline runs green on this repo
1. **Intentional failure test** — include a commented-out section in `self-test.yml` showing how to temporarily introduce a finding to verify the gate works. Document this in `docs/extending.md`.
1. **README examples must copy-paste cleanly.** Any YAML block in the README should be valid as-is.

-----

## Execution order for Claude Code

Build in this order. Do not skip ahead.

1. Initialize repo: `.gitignore`, `LICENSE` (MIT), empty `README.md`, empty `CHANGELOG.md`
1. `configs/` directory — all four config files with documented defaults
1. `scripts/severity-gate.sh` and `scripts/pr-comment.js`
1. Sub-workflows in this order: `secrets-scan.yml`, `sast.yml`, `deps-scan.yml`, `iac-scan.yml`, `container-scan.yml`, `sbom.yml`
1. `full-scan.yml` — the orchestrator
1. `self-test.yml`
1. `docs/architecture.md`, `docs/gating-policy.md`, `docs/usage.md`, `docs/extending.md`
1. `README.md` — written last so it accurately reflects what was built
1. Final pass: verify every action is SHA-pinned, verify every doc link resolves, verify `self-test.yml` would pass

-----

## Definition of done

- All files in the structure above exist and are non-empty
- Every third-party action is pinned to a full commit SHA with a comment showing the human-readable version
- `README.md` quickstart works verbatim when pasted into a new repo’s `.github/workflows/security.yml`
- `self-test.yml` produces zero high/critical findings
- Zero secrets, tokens, or credentials anywhere in the repo
- `docs/` contains four markdown files, each substantive (not stub placeholders)
- `CHANGELOG.md` has a `v0.1.0` entry ready for the first release tag

-----

## Style rules

- YAML: 2-space indent, no trailing whitespace, anchors only if they materially reduce duplication
- Shell: `set -euo pipefail` at the top of every script
- JavaScript: no dependencies beyond `@actions/*`, Node 20 target
- Markdown: ATX headings, reference-style links for anything referenced twice
- Comments in workflows explain **why**, not **what**. The YAML already says what.

-----

## Out of scope (do not build)

- Consumer/demo app
- Any web dashboard or UI
- Snyk, SonarQube, or other paid-tier scanners (Trivy + Semgrep + Checkov + Gitleaks + Syft is the free stack — keep it)
- Slack/email notifications (consumers can add these on top)
- Custom Semgrep rules — compose public rulesets, don’t author from scratch in v0.1
