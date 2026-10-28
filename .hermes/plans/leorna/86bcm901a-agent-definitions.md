# 86bcm901a Curate agent definitions: plan

## Questions (a bare "go" takes every ⭐)

**A. code-reviewer: ours (Leorna demo 1.0.0) vs upstream's. What happens to ours?**
- a ⭐ Replace: upstream takes the name, as 2.0.0
- b Merge: upstream plus our tools line and scope check
- c Keep ours; ship upstream's as staff-code-reviewer

Why a: upstream covers everything ours checks (correctness, edge cases, error handling, security, whether the tests really exercise the change, file:line findings with a fix, no approval while anything blocks) and adds readability, architecture and performance. It also uses the same severity labels as the `code-review-and-quality` skill we already ship. Ours adds two things upstream lacks: an explicit "flag anything that widens scope beyond the story", and a `tools: Read, Grep, Bash` line. Both are named in the recorded decision.
- With b: after T8, edit `items/agent/code-reviewer/body.md` to add `tools: Read, Grep, Glob, Bash` to the frontmatter and one Correctness bullet ("Does the change stay inside the task's scope? Flag anything that widens it."). Keep 2.0.0 (never released) and re-record only its branch-added lock line. Write `curation/diffs/agent-code-reviewer.diff` with `library-upstream adaptation --item agent/code-reviewer`, give its review `adaptation` plus `safety: adapted` and `accuracy: adapted`, and record the demoAgents decision as `merged`. Also extend the orphan-diff loop at the end of `TestAC2_EveryImportedSkillIsReviewedWithOwnerAndAdaptationDiff` (`internal/library/curation_test.go`) so diffs referenced by `record.Agents` count. Every upstream update to code-reviewer then becomes a hand merge.
- With c: T5/T6 (`--version`) drop out. Ours stays `agent/code-reviewer` 1.0.0 (reviewed, origin `leorna`, decision `kept`). Upstream imports with `--name staff-code-reviewer` and its frontmatter `name:` is adapted to `staff-code-reviewer`, because two Claude Code agents can't share a name (diff + `format: adapted`). AC5 then has 5 runs.

**B. test-writer (Leorna demo 1.0.0) vs upstream test-engineer. What happens to test-writer?**
- a ⭐ Replace: retire it; test-engineer supersedes it
- b Keep it too, with its tools line fixed (1.0.1)
- c Merge: add our 2 rules into test-engineer

Why a: test-engineer covers reading the code and nearby tests first, happy path, boundaries and failures, and Prove-It for bugs, and it adds test levels and a coverage report. Ours adds two lines it doesn't state: "prefer table-driven tests where the language supports them" and "never weaken an assertion to make a test pass". Ours also can't edit files: `tools: Read, Grep, Bash` has no Edit or Write. The decision's reason names both lines.
- With b: test-writer stays (no source). Its frontmatter becomes `tools: Read, Grep, Glob, Edit, Write, Bash` at 1.0.1 (new lock line), with a review (origin `leorna`) and decision `kept`. AC5 adds a run of test-writer.
- With c: test-writer is removed. test-engineer is adapted with the two lines under Rules (diff `agent-test-engineer.diff`, `accuracy: adapted`), the decision is `merged`, and the orphan-diff loop is extended as in A-b.

**C. AC5 (one live run per agent in Claude Code): where do the 4 agent files go?**
- a ⭐ A sample project's .claude/agents; your normal login
- b Your ~/.claude/agents for the run, then removed
- c A separate CLAUDE_CONFIG_DIR (fresh sign-in)

Why a: nothing is written into `~/.claude/agents` (which doesn't exist today). You start Claude Code with `--setting-sources project`, so your user hooks (lessons gate, AC gate, nudges) don't fire on the agents under test, and your login is unchanged. Claude Code still writes its own session files under `~/.claude/projects/` and remembers that you trusted the folder, as it always does.
- With b: the builder's kit gives copy and remove commands that you run yourself. Agents don't write there.
- With c: `CLAUDE_CONFIG_DIR=<evidence>/ac5-live/claude-home claude`, then `/login`. That folder then holds a credential file; delete it after.

**D. This desktop (WSL Ubuntu) has no Go 1.27.3, make, golangci-lint, govulncheck or Postgres, and Docker's WSL integration is off. How do the gates get them?**
- a ⭐ You: Docker WSL toggle + apt make; agent adds Go/linters
- b Build this story on the Mac instead
- c You install everything first; builder only checks

With a, you do two things: (1) Docker Desktop → Settings → Resources → WSL integration → turn on "Ubuntu" → Apply & restart; (2) in Ubuntu, run `sudo apt-get install -y make`. The builder installs Go 1.27.3, golangci-lint 2.14.0 and govulncheck v1.7.0 into `~/.local/leorna-toolchain/` with checksums checked. It uses them through a task-local PATH only, starts `leorna-test-pg` from CI's pinned image if it isn't there, and creates its own `_test` database. The sibling stories can reuse all of it.
- With b: worktree, branch, gates and evidence move to the Mac, using the macOS capture recipe in `leorna` step 4b, and AC5 runs there too.
- With c: T0 only checks versions and stops with BLOCKED until they match.

## Acceptance criteria

The card's four test-backed ACs in card order, word for word, plus the card's Verify line, which Justin made a live AC. Each automated AC's test fails on the base commit `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`, with a real `--- FAIL` or a build failure of the new code where noted.

- AC1: Given the import, then the 4 upstream agents are in the library with source commit recorded.
  Meaning: for each of `agents/code-reviewer.md`, `agents/security-auditor.md`, `agents/test-engineer.md` and `agents/web-performance-auditor.md`, exactly one shipped `agent` item has `source.upstream = agent-skills`, that `source.path`, `source.commit = aeac41d4d005999432bb7312f7ff06383a91d59d` (the card's `aeac41d4d005`), a 64-hex `upstreamSha256`, a MAJOR.MINOR.PATCH version, and a `content.lock.json` entry equal to its checksum. No other agent-skills agent ships.
  Test `TestAC1_TheFourUpstreamAgentsAreInTheLibraryWithSourceCommit` (`internal/library/upstream_agents_test.go`):
  `go test -v -count=1 -run '^TestAC1_TheFourUpstreamAgentsAreInTheLibraryWithSourceCommit$' ./internal/library`
  Base: real FAIL ("4 of the 4 upstream agents are not in the library"). Uses only existing API.
- AC2: Given overlapping demo agents, then a decision (replace / keep / merge) is recorded for each.
  Meaning: `internal/library/curation/curation.json` `demoAgents` has exactly one entry with a reason for each of Leorna's demo agents (`agent/code-reviewer`, `agent/test-writer`), and nothing else. Each published 1.0.0 stays in `content.lock.json` with its original checksum. `replaced` means the replacement is a shipped, unadapted agent-skills agent, and the demo name no longer ships unless the replacement takes it at a higher version. `merged` is the same but the replacement carries a recorded adaptation. `kept` means the demo ships Leorna-authored (no source) and is reviewed.
  Test `TestAC2_EachOverlappingDemoAgentHasAReplaceKeepOrMergeDecision` (`internal/library/curation_agents_test.go`):
  `go test -v -count=1 -run '^TestAC2_EachOverlappingDemoAgentHasAReplaceKeepOrMergeDecision$' ./internal/library`
  Base: build failure of the new code (`record.Agents undefined`, `record.DemoAgents undefined`).
- AC3: Given each agent, then it renders correctly for every tool that supports agents and is skipped with a reason where unsupported.
  Meaning: the real gate over the shipped library gives every shipped agent (the 4 upstream ones by source path, plus any other) a declared result for Claude Code, Codex and Cursor. No tool installs agents at client `f105e27`, so for each tool the result is `skipped`, with the reason `render.NotInstalled` gives ("the desktop client does not install agents yet"), no files, and exactly the transformer's warning `agent "<name>" is not installed for <tool>; skipped`. A tool listed in `agentInstallingTools` would instead have to render the agent with no warning and carry its body. The test fails if `render.NotInstalled` and that list ever disagree.
  Test `TestAC3_EachAgentRendersWhereSupportedAndIsSkippedWithAReasonElsewhere` (`cmd/library-gate/agents_test.go`):
  `go test -v -count=1 -run '^TestAC3_EachAgentRendersWhereSupportedAndIsSkippedWithAReasonElsewhere$' ./cmd/library-gate`
  Base: real FAIL (the 4 upstream agents are missing). Runs with the test's clean scanner, so it needs no gitleaks.
- AC4: Given each agent, then it passed the content quality gate.
  Meaning: the real `library-gate` run (as CI runs it) with gitleaks 8.30.1 exits 0, and every shipped agent, the 4 upstream ones by source path included, is `passed`, with schema `pass`, no secret finding, no scripts and no failed declared tool.
  Test `TestAC4_EachAgentPassesTheContentQualityGate` (`cmd/library-gate/agents_test.go`):
  `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks go test -v -count=1 -run '^TestAC4_EachAgentPassesTheContentQualityGate$' ./cmd/library-gate`
  Base: real FAIL (the 4 upstream agents are missing). Without gitleaks the test SKIPs, which rejects the run, so every AC4 run sets `LEORNA_TEST_GITLEAKS_BIN`.
- AC5 (live): One live run per agent in Claude Code: given each of the 4 upstream agents as a Claude Code project agent, when Justin asks Claude Code to use it on the sample project, then Claude Code runs that agent and its reply follows the agent's own report format.
  Test: manual, Justin (`manual: AC5 one live run per agent in Claude Code`). Screenshots `ac5-agents-list.png`, `ac5-code-reviewer.png`, `ac5-security-auditor.png`, `ac5-test-engineer.png`, `ac5-web-performance-auditor.png`. Steps and pass criteria are in "Live run (AC5)" below. Agents mark it `not_run: live: only Justin can run Claude Code interactively under his login`.

## Story

ClickUp [Curate agent definitions](https://app.clickup.com/t/86bcm901a) (PI-2, E10 Content Library, size M, p2-medium, Justin). Full pipeline; every role is a fresh Opus 5.5 xhigh agent.
Repo: **leorna-control-plane only**. No client change, no OpenAPI change, no migration, no CI change.
Base: `origin/main` = GitHub main = `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (main session fetched it on 2026-10-28; T0 fetches again and records the actual base).
Branch `feat/86bcm901a-agent-definitions`, worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901a-agent-definitions`.
Evidence: `~/.hermes/plans/leorna/evidence/86bcm901a/` (excluded from setup sync by `~/.claude/setup/exclude.txt`).
Sibling sessions in this repo right now: 86bcm901b (prompts collection) and 86bcm901j (MCP templates). Never read or touch their worktrees, branches, test databases or evidence folders.

## Playback

Import the four agents that agent-skills ships under `agents/` at the pinned commit (code-reviewer, security-auditor, test-engineer, web-performance-auditor) with the existing `library-upstream import` tool, so each records its source commit and stays one `accept` away from upstream updates. Record what happens to Leorna's two demo agents: upstream code-reviewer takes our code-reviewer's name at 2.0.0, and test-engineer replaces test-writer. Prove each agent is reported per tool as "skipped: the desktop client does not install agents yet" (no tool installs agents today) and passes the quality gate. Then Justin runs each agent once in Claude Code.

## Facts verified (2026-10-28, read-only, this session)

- **Base.** `origin/main` = GitHub main = `1ee7157` (`gh api repos/LeornaAI/leorna-control-plane/commits/main`). The dependencies are merged: 9018 (#82), 945u (#89), 901u (#90), 9019 (#92, merge `022283b`). No open PRs in either repo. The client is at GitHub main `f105e27` (PR #22).
- **Upstream.** `addyosmani/agent-skills` main = tag `0.6.13` = `aeac41d4d005999432bb7312f7ff06383a91d59d` (the library's pin), with nothing ahead of it. `agents/` holds exactly 4 files: code-reviewer.md (4,058 B, blob `ea267be`), security-auditor.md (4,992 B, `efb1e4e`), test-engineer.md (3,351 B, `d207e2f`) and web-performance-auditor.md (12,278 B, `44bc45d`). Each has frontmatter keys `name` and `description` only (descriptions 170–222 chars, one plain line), LF endings and one markdown link (`[docs/agents.md](../docs/agents.md)`). No `tools`, `model`, hooks or `permissionMode`. gitleaks 8.30.1 with default rules over each file found nothing.
- **The importer takes agents as they are.** In `internal/library/upstream/layout.go:131-183` `Transform`, an agent's description is the frontmatter description and its body is the whole file. `library.go:250-252` allows an agent source path `agents/<name>.md`. The 945u fixture already imports `agents/reviewer.md`.
- **Same-name replacement is blocked today.** `Import` (`importer.go:41-82`) refuses an existing kind/name ("already exists; use accept") and always writes version `1.0.0`. `commitItem` (`importer.go:~236`) refuses a lock key that is already recorded. `agent/code-reviewer@1.0.0` is published (`content.lock.json:2`), and `accept` refuses an item without a source (`importer.go:~291`). So "upstream code-reviewer replaces ours" through the sync tool needs a new `import --version` (T5–T6).
- **Rendering.** `internal/library/render` is a byte-for-byte copy of the client transformers at `f105e27` (`render/testdata/client/SOURCE.md`). `agentWarnings` (`render/shared.go:20-31`) warns `agent %q is not installed for %s; skipped` for every agent and every tool. `NotInstalled` (`render/render.go:105-115`) returns "the desktop client does not install agents yet" for every tool. The gate (`gate/gate.go:239-270`) turns that into `StatusSkipped` with that reason, and a skipped tool never fails the gate (README "Quality gate"). The client (`toolconnector/transform.go:28` at `f105e27`) is the same. **No tool supports agents today**, so AC3 is "skipped with a reason" for all three.
- **Demo agents.** `items/agent/code-reviewer` (code-quality; tags code-review, security) and `items/agent/test-writer` (testing; tags tests, tdd) are 1.0.0, Leorna-authored with no `source`, and list all three tools. Both also sit in the starter seed `internal/pack/seed.json:28,35` (9019 left the seed to 86bcm901r). Web and catalog tests use their own fixtures (`internal/web/library_test.go:60-81`, `internal/library/catalog_test.go:14`), not the shipped agents.
- **Tests that read the shipped library** count `len(shipped.Items)` and adjust on their own: `TestEnsureLibraryWithPostgres`, `TestLibraryShowsTheShippedLibraryWithPostgres`, the setup wizard and third-party-content page tests, `TestPreviewOfEveryShippedItem`, and the gate's AC3 report test. The 9019 skill tests skip agents (`upstream_skills_test.go:44-46`; `curation_test.go` reviews `KindSkill` only). `TestShippedImportsMatchTheRealUpstream` (network) checks every imported item, so it covers the agents.
- **Catalog and loader.** `ListLibraryItems` shows the newest version per kind/name, compared number by number (`internal/store/postgres/library_catalog.go:15-30`), so code-reviewer 2.0.0 shows over 1.0.0. The loader never deletes rows, so an install that loaded test-writer keeps listing it, as 9019 noted for its demo skills.
- **Attribution.** `ThirdPartyNotices()` lists upstreams, not items (`upstream_test.go:236-251`). Same upstream and same pin, so `THIRD_PARTY_NOTICES.md` does not change. The admin page `/admin/third-party-content` lists every imported item by itself (`internal/web/third_party_content_test.go:124-148`).
- **npm names in web-performance-auditor** (registry read 2026-10-28): `lighthouse` 13.6.0 is GoogleChrome/lighthouse. `chrome-devtools-mcp` 1.12.0 (ChromeDevTools/chrome-devtools-mcp; maintainers mathias, orkon, google-wombot) ships the bins `chrome-devtools` and `chrome-devtools-mcp`, so `npx -p chrome-devtools-mcp chrome-devtools …` runs Google's CLI, not someone else's package (unlike 9019's `npx lhci`).
- **This desktop** (WSL Ubuntu, Claude Code 2.1.312): `go`, `make`, `golangci-lint`, `govulncheck`, Chrome and Postgres are not installed (`command -v` and a `find / -xdev` found none). `docker` prints "could not be found in this WSL 2 distro". Present: gitleaks 8.30.1 (`/usr/local/bin/gitleaks`, CI's version), Chrome for Testing (`~/.cache/chrome-for-testing/chrome-linux64/chrome`), python3, gh (active account `Justin-Leorna`) and git identity `Justin Issa <justin@leorna.com>`. The SSH agent is not running, so fetch over HTTPS through gh. CI pins Go from `go.work` (1.27.3), golangci-lint 2.14.0 (sha256 `ab90aeb7b066f92a33415b638a50fe5344bbb75a0d32ad30cc248d88f81032ab`), govulncheck v1.7.0, gitleaks 8.30.1 and `postgres:18.6-alpine3.23@sha256:697c180dbf244d3ce4a8f4cbc0156cde840af055c1bf8b76aebe422a4822086f` (`.github/workflows/ci.yml:47-139`).
- **Claude Code CLI** has `--setting-sources <user,project,local>` (`claude --help`). Justin's user settings carry SessionStart, PostToolUse, UserPromptSubmit, SubagentStop (`subagent-lessons-gate.sh`, `subagent-ac-gate.sh`) and PreToolUse hooks.
- **Plan code is not compiled.** This desktop has no Go, so the Go blocks below were checked by reading against the APIs at `1ee7157`, not with gofmt or vet. The builder's RED runs are the first compile.

## Approach

1. **Import with the existing sync tool**, verbatim. Agents get the same rules as skills (ADR 0003: verbatim by default, adapt only for a broken path, a security issue or a script decision). All four ship unadapted, so each upstream update stays one `accept`.
2. **Same-name replacement through the tool.** Add `--version V` to `library-upstream import`. When given, V must be MAJOR.MINOR.PATCH and above every version `content.lock.json` records for that kind/name; without it, nothing changes. Then `git rm` our code-reviewer folder and import upstream's at `--version 2.0.0`. The major bump is because the agent's report contract changes (Blocking/Important/Nit → Critical/Required/Optional/Nit with a verdict). Leorna's 1.0.0 stays in the lock.
3. **Record decisions and reviews** in `curation/curation.json`, the review record 9019 started (never shipped): `agents` holds one checklist review per shipped agent and `demoAgents` one decision per demo agent. Two new fields on `library.Curation`.
4. **Prove rendering and the gate per agent** with tests that run the real gate over the shipped library, the CI view. No renderer or gate change.
5. **Library 0.5.0 → 0.6.0.** README section, `stories.json` entry. No change to `THIRD_PARTY_NOTICES.md`, `upstream.json`, the seed or CI.
6. **AC5 kit:** the builder prepares a throwaway sample project holding byte copies of the four shipped bodies in `.claude/agents/`, seeded with one problem per agent and a checklist. Justin runs it.

## Choices

- **No client change; AC3 = skipped with a reason for every tool.** Installing agents is a desktop-client feature: the control-plane renderer may only copy merged client transformer changes (`render/render.go:1-9`). It would be cross-repo and widen the story. The card's AC already allows "skipped with a reason where unsupported". Follow-up card (Other things found 4): the client installs agents (Claude Code reads `.claude/agents/<name>.md`, the format these bodies already have).
- **Declare all three tools on each agent**, like the demo agents and every skill, so the gate gives each tool a result with the skip reason rather than "not declared".
- **No adaptations.** All four agents' Composition sections link `docs/agents.md` in upstream's repository and name upstream slash commands (`/ship`, `/review`, `/test`, `/webperf`, `/audit`). These are noted in the reviews, not adapted, the same ruling as 9019's `/build` and `skills/<name>/SKILL.md` mentions (ADR 0003 Consequences). web-performance-auditor's rule 8 names `references/performance-checklist.md`, an upstream repository path. That checklist ships inside the `performance-optimization` skill the same agent names in rule 9, so the name is enough for an agent (9019's spec-driven-development ruling). Noted, not adapted (see Assumptions for the alternative).
- **No `tools` restriction added.** Upstream agents have no `tools:` line, so Claude Code gives them the session's tools. That grants no new permission (Claude Code's own prompts still apply) and isn't a security issue under ADR 0003. It is stated in each review's notes and in the code-reviewer and test-writer decision reasons.
- **No ADR.** The README and `curation.json` record the decisions, and ADR 0003's rules are stated to apply to agents. This avoids an ADR-number clash with 86bcm901b.
- **Seed untouched** (`internal/pack/seed.json`, 86bcm901r), as in 9019.

## Skills

- Every role: `leorna`, `engineering-best-practices`.
- Builder: `test-driven-development`, `mutation-testing-discipline` (the `--version` guard, the AC2 decision rules and the AC3 tripwire are guards: prove each can fail), `security-best-practices` (third-party content, the npx/npm notes, file and lock writes in the importer).
- Reviewers (both): `requesting-code-review`, `code-review-practice`, plus `security-best-practices`.
- Fixers: `receiving-code-review`, `test-driven-development`.
- Verifier and blind AC auditor: `feature-dispatch` `references/ac-verification.md`, plus `engineering-best-practices`.
- Finisher: `receiving-code-review`, `git-commit-rules`, `test-driven-development`, `github` (only if Justin says "make a PR").
- Not needed: `api-contract-drift-guard` (OpenAPI untouched), `backend-data-migrations` (no schema change), `multi-tenant-auth-management` (no auth or tenant change), `systematic-debugging` (not a bug).

## Tasks

`$WT` = the worktree, `$EV` = `~/.hermes/plans/leorna/evidence/86bcm901a`, and `$S` = the role's own scratch folder `<scratchpad>/86bcm901a-builder/`, created fresh with `mkdir` (no `-p`) and the only thing the role removes. `$TC` = `~/.local/leorna-toolchain`. Commit as the repo's identity (plain `git commit`, no author flags, no AI attribution lines). Never push.

### T0. Fetch, fast-forward, worktree, base (main-session addendum, in this order)

1. In `~/Leorna/leorna-control-plane`:
   `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`
2. Check `git rev-parse origin/main` equals `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`. Record it as `BASE` (`refs/remotes/origin/main` is shared with the sibling sessions, so record it now).
3. Check `git -C ~/Leorna/leorna-control-plane status --porcelain --untracked-files=no` is empty (an untracked `.claude/` is just worktrees), that the checkout is on `main`, then `git merge --ff-only origin/main`. If it refuses, stop and report. Never check out another branch there.
4. `git worktree add -b feat/86bcm901a-agent-definitions .claude/worktrees/86bcm901a-agent-definitions origin/main`.
5. Confirm `git rev-parse main origin/main` and `git -C $WT rev-parse HEAD` are the same SHA = `BASE`. Write it to `$EV/base.txt`.
6. If `BASE` ≠ `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`, run `git diff --stat 1ee7157 BASE` and `git log --oneline 1ee7157..BASE`. Stop and report if any new commit touches `internal/library/**`, `cmd/library-gate/**`, `cmd/library-upstream/**`, `internal/store/postgres/library*`, `delivery/stories.json` or `THIRD_PARTY_NOTICES.md`. Otherwise note it and continue.
7. `git -C $WT log -1 --pretty=format:'%an <%ae>'` must print `Justin Issa <justin@leorna.com>` once you commit; check `git -C $WT config user.email` now.

### T0b. Toolchain (per question D; ⭐ a shown)

Stop with BLOCKED, naming exactly what is missing, until Justin's part is done: `docker ps` works in Ubuntu and `command -v make` succeeds. Then:
1. Go 1.27.3: download `https://go.dev/dl/go1.27.3.linux-amd64.tar.gz` into `$S`, check its sha256 against the `sha256` listed for that file at `https://go.dev/dl/?mode=json&include=all`, and extract it to `$TC/go`. Leave it if the folder already holds a matching `go version`.
2. golangci-lint 2.14.0: the linux-amd64 tarball from the GitHub release, checked with `printf '%s  %s\n' ab90aeb7b066f92a33415b638a50fe5344bbb75a0d32ad30cc248d88f81032ab <tarball> | sha256sum --check --strict`, with its binary in `$TC/bin`.
3. govulncheck: `GOBIN=$TC/bin $TC/go/bin/go install golang.org/x/vuln/cmd/govulncheck@v1.7.0`.
4. Task-local only, set in every gate script, never in a profile: `export PATH=$TC/go/bin:$TC/bin:$PATH`. Then bind `GOLANGCI_LINT=$TC/bin/golangci-lint GOVULNCHECK=$TC/bin/govulncheck GITLEAKS=/usr/local/bin/gitleaks`. Echo `go version`, `golangci-lint --version` and `govulncheck -version` from that same PATH into the gate log.
5. Postgres: if `docker ps -a` shows `leorna-test-pg`, reuse it (`docker start leorna-test-pg`). Otherwise run `docker run -d --name leorna-test-pg -e POSTGRES_USER=leorna -e POSTGRES_PASSWORD=ci-only-password -e POSTGRES_DB=leorna_test -p 127.0.0.1:5432:5432 mirror.gcr.io/library/postgres:18.6-alpine3.23@sha256:697c180dbf244d3ce4a8f4cbc0156cde840af055c1bf8b76aebe422a4822086f`. Create the owned DB: `docker exec leorna-test-pg psql -U leorna -d leorna_test -c 'CREATE DATABASE leorna_86bcm901a_test'`. Then `LEORNA_TEST_DATABASE_URL='postgres://leorna:ci-only-password@127.0.0.1:5432/leorna_86bcm901a_test?sslmode=disable'`. Before relying on it, check the fixture's reset guard still wants a name ending `_test`. Never drop or use another story's database.
6. Chrome for Testing for evidence: `~/.cache/chrome-for-testing/chrome-linux64/chrome --headless=new --no-sandbox --disable-gpu --user-data-dir=$S/chrome --screenshot=$S/probe.png about:blank`. If it fails on missing libraries, report it and leave screenshots owed; don't install system packages.

### T1. Baseline on base (separate detached copy, not the story worktree)

`git -C $WT worktree add --detach $S/base-<base7> BASE`, then with DB `leorna_86bcm901a_base_test` run the canonical gate there:
`( set -o pipefail; cd $S/base-<base7> && echo "HEAD=$(git rev-parse HEAD)"; make check; echo "EXIT=$?" ) > $EV/gates-base-<base7>.txt 2>&1`
plus `bash ./scripts/test-module-add.sh`. Note any baseline failure by test name (for example `make secrets` hitting a sibling branch; see Risks) before writing code. Remove the copy afterwards (`git worktree remove --force`).

### T2. Upstream clone and example files (scratch)

```sh
git clone --bare --quiet https://github.com/addyosmani/agent-skills.git $S/agent-skills.git
test "$(git -C $S/agent-skills.git rev-parse '0.6.13^{commit}')" = aeac41d4d005999432bb7312f7ff06383a91d59d
mkdir $S/examples
```

Write these four files, each ending with one newline:

`$S/examples/code-reviewer.md`
```
Ask: "Use the code-reviewer agent on my branch before I open the PR."
The agent reads the change and its tests and returns a review summary with a verdict (APPROVE or REQUEST CHANGES), findings labelled Critical, Required, Optional or Nit with file:line and a fix, and what was done well.
```
`$S/examples/security-auditor.md`
```
Ask: "Use the security-auditor agent on the new upload endpoint."
The agent starts where untrusted data enters, checks input handling, authentication and authorization, data protection, infrastructure, third-party integrations and AI features against the OWASP Top 10, and returns a security audit report with findings by severity, each with location, impact and a specific fix.
```
`$S/examples/test-engineer.md`
```
Ask: "Use the test-engineer agent to find the gaps in the tests for the retry logic in sync.go."
The agent reads the code and the nearby tests, picks the right test level and returns a coverage analysis with prioritised tests to add, or writes them; for a bug it first writes a test that fails.
```
`$S/examples/web-performance-auditor.md`
```
Ask: "Use the web-performance-auditor agent on the checkout page."
The agent identifies the framework, checks Core Web Vitals, loading, rendering and network patterns, and returns a web performance audit; without Lighthouse, CrUX or DevTools data it marks the scorecard not measured and tags each finding potential impact.
```

### T3. RED: AC1 test

Create `internal/library/upstream_agents_test.go`:

```go
package library

import (
	"regexp"
	"sort"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// upstreamAgentPaths is the card's list (ClickUp 86bcm901a): every agent that
// addyosmani/agent-skills ships under agents/ at commit aeac41d4d005.
var upstreamAgentPaths = []string{
	"agents/code-reviewer.md", "agents/security-auditor.md",
	"agents/test-engineer.md", "agents/web-performance-auditor.md",
}

// agentSkillsCardCommit is the commit the card names (aeac41d4d005), in full.
const agentSkillsCardCommit = "aeac41d4d005999432bb7312f7ff06383a91d59d"

func TestAC1_TheFourUpstreamAgentsAreInTheLibraryWithSourceCommit(t *testing.T) {
	shipped, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	up, ok := shipped.Upstream("agent-skills")
	if !ok || up.Repository != "https://github.com/addyosmani/agent-skills" || up.License != "MIT" {
		t.Fatalf("upstream record = %+v, %v; want agent-skills under MIT", up, ok)
	}
	lock, err := ReadLock(lockFile)
	if err != nil {
		t.Fatal(err)
	}
	fingerprint := regexp.MustCompile(`^[0-9a-f]{64}$`)
	// Keyed by source path, so an import under another name still counts.
	imported := map[string]Item{}
	for _, item := range shipped.Items {
		if item.Kind != pack.KindAgent || item.Source == nil || item.Source.Upstream != up.Name {
			continue
		}
		if _, duplicate := imported[item.Source.Path]; duplicate {
			t.Fatalf("%s is imported twice", item.Source.Path)
		}
		imported[item.Source.Path] = item
	}
	var missing []string
	for _, path := range upstreamAgentPaths {
		item, ok := imported[path]
		if !ok {
			missing = append(missing, path)
			continue
		}
		delete(imported, path)
		switch {
		case item.Source.Commit != agentSkillsCardCommit:
			t.Errorf("%s: source commit %s, want the card's commit %s", item.Key(), item.Source.Commit, agentSkillsCardCommit)
		case !fingerprint.MatchString(item.Source.UpstreamSHA256):
			t.Errorf("%s: upstreamSha256 %q is not a SHA-256", item.Key(), item.Source.UpstreamSHA256)
		case !semverPattern.MatchString(item.Version):
			t.Errorf("%s: version %q is not MAJOR.MINOR.PATCH", item.Key(), item.Version)
		case lock[item.Key()] != item.Checksum():
			t.Errorf("%s is not pinned in %s", item.Key(), lockFile)
		}
	}
	if len(missing) > 0 {
		t.Errorf("%d of the 4 upstream agents are not in the library: %s", len(missing), strings.Join(missing, ", "))
	}
	extra := make([]string, 0, len(imported))
	for path := range imported {
		extra = append(extra, path)
	}
	sort.Strings(extra)
	if len(extra) > 0 {
		t.Errorf("agents from agent-skills that the card does not list: %s", strings.Join(extra, ", "))
	}
}
```

RED: the AC1 command must print `--- FAIL` with "4 of the 4 upstream agents are not in the library".

### T4. RED: AC3 and AC4 tests

Create `cmd/library-gate/agents_test.go`:

```go
package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
	"github.com/LeornaAI/leorna-control-plane/internal/library/render"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// upstreamAgentRoots is the card's list (ClickUp 86bcm901a, agent-skills commit aeac41d4d005).
var upstreamAgentRoots = []string{
	"agents/code-reviewer.md", "agents/security-auditor.md",
	"agents/test-engineer.md", "agents/web-performance-auditor.md",
}

// agentInstallingTools are the tools the desktop client installs agents for:
// none at client f105e27 (render/testdata/client/SOURCE.md), where every
// transformer warns that an agent is not installed and writes nothing. When a
// copied client change installs agents for a tool, add the tool here; the AC3
// test then requires each agent to render for it.
var agentInstallingTools = map[library.Tool]bool{}

// agentGateRun runs the gate over the shipped library as CI does and returns the
// parsed library, the report by item key and the shipped agents. It fails the
// test when one of the card's upstream agents is not in the library.
func agentGateRun(t *testing.T, args []string, newScanner func(string) gate.Scanner) (library.Library, map[string]gate.ItemResult, []library.Item) {
	t.Helper()
	reportPath := filepath.Join(t.TempDir(), "report.json")
	var stdout, stderr bytes.Buffer
	args = append([]string{"-dir", realLibrary, "-json", reportPath}, args...)
	if code := run(context.Background(), args, &stdout, &stderr, newScanner); code != 0 {
		t.Fatalf("the library failed the gate (exit %d)\n%s%s", code, stdout.String(), stderr.String())
	}
	lib, err := library.Parse(os.DirFS(realLibrary))
	if err != nil {
		t.Fatal(err)
	}
	raw, err := os.ReadFile(reportPath)
	if err != nil {
		t.Fatal(err)
	}
	var report gate.Report
	if err := json.Unmarshal(raw, &report); err != nil {
		t.Fatal(err)
	}
	results := make(map[string]gate.ItemResult, len(report.Items))
	for _, result := range report.Items {
		results[result.Key] = result
	}
	var agents []library.Item
	imported := map[string]bool{}
	for _, item := range lib.Items {
		if item.Kind != pack.KindAgent {
			continue
		}
		agents = append(agents, item)
		if item.Source != nil && item.Source.Upstream == "agent-skills" {
			imported[item.Source.Path] = true
		}
	}
	for _, root := range upstreamAgentRoots {
		if !imported[root] {
			t.Errorf("upstream agent %s is not in the library, so it was never rendered or gated", root)
		}
	}
	return lib, results, agents
}

func TestAC3_EachAgentRendersWhereSupportedAndIsSkippedWithAReasonElsewhere(t *testing.T) {
	lib, results, agents := agentGateRun(t, nil, newCleanScanner)
	allTools := []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}
	for _, item := range agents {
		result, ok := results[item.Key()]
		if !ok || len(result.Tools) != len(allTools) {
			t.Errorf("%s: no per-tool result in the report: %+v", item.Key(), result)
			continue
		}
		for index, tool := range result.Tools {
			if tool.Tool != allTools[index] || !tool.Declared || !slices.Contains(item.Tools, tool.Tool) {
				t.Errorf("%s %s: declared %v; every agent lists Claude Code, Codex and Cursor", item.Key(), tool.Tool, tool.Declared)
				continue
			}
			reason, skipped := render.NotInstalled(item.Kind, tool.Tool)
			if skipped == agentInstallingTools[tool.Tool] {
				t.Errorf("%s: render.NotInstalled says skipped=%v but agentInstallingTools says installs=%v; update agentInstallingTools with the client change",
					tool.Tool, skipped, agentInstallingTools[tool.Tool])
				continue
			}
			if skipped {
				warning := fmt.Sprintf("agent %q is not installed for %s; skipped", item.Name, tool.Tool)
				if tool.Status != gate.StatusSkipped || reason == "" || tool.Reason != reason || len(tool.Files) != 0 ||
					!slices.Equal(tool.Warnings, []string{warning}) {
					t.Errorf("%s %s: status %s, reason %q, files %v, warnings %q; want skipped with the reason %q",
						item.Key(), tool.Tool, tool.Status, tool.Reason, tool.Files, tool.Warnings, reason)
				}
				continue
			}
			// A tool that installs agents renders this one with no warning, and a
			// rendered file carries its instructions.
			bundle, err := render.Transform(tool.Tool, render.Pack{Name: lib.Name, Version: lib.Version,
				Items: []render.Item{render.FromLibrary(item)}})
			carried := false
			for _, content := range bundle.Files {
				carried = carried || bytes.Contains(content, []byte(strings.TrimSpace(item.Body)))
			}
			if err != nil || tool.Status != gate.StatusRendered || !carried {
				t.Errorf("%s %s: status %s (%s), error %v, body rendered %v; want rendered", item.Key(), tool.Tool, tool.Status, tool.Reason, err, carried)
			}
		}
	}
}

func TestAC4_EachAgentPassesTheContentQualityGate(t *testing.T) {
	bin := gitleaksForTest(t)
	_, results, agents := agentGateRun(t, []string{"-gitleaks", bin}, gate.NewGitleaks)
	for _, item := range agents {
		result, ok := results[item.Key()]
		if !ok || !result.Passed || result.Schema != "pass" || len(result.Secrets) != 0 || len(result.Scripts) != 0 {
			t.Errorf("%s did not pass the gate: %+v", item.Key(), result)
			continue
		}
		for _, tool := range result.Tools {
			if tool.Declared && tool.Status == gate.StatusFailed {
				t.Errorf("%s %s: render failed: %s", item.Key(), tool.Tool, tool.Reason)
			}
		}
	}
}
```

RED: the AC3 command and the AC4 command (with `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks`) each print `--- FAIL` naming the 3 missing upstream roots plus `agents/code-reviewer.md` (ours has no source). `newCleanScanner`, `gitleaksForTest` and `realLibrary` already exist in `cmd/library-gate/main_test.go`.

### T5. RED: `import --version`

Create `cmd/library-upstream/import_version_test.go`:

```go
package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// A Leorna item retired from content/ keeps its published versions in
// content.lock.json. import --version lets an upstream item take its name at a
// higher version and leaves every recorded version alone (story 86bcm901a).
func TestImportVersionTakesTheNameOfARetiredItem(t *testing.T) {
	fixture := newSyncFixture(t)
	if err := os.RemoveAll(itemFolder(fixture.lib, "agent", "reviewer")); err != nil {
		t.Fatal(err)
	}
	lockBefore := readLock(t, fixture.lib)
	if _, recorded := lockBefore["agent/reviewer@1.0.0"]; !recorded {
		t.Fatal("the fixture should record agent/reviewer@1.0.0")
	}
	example := filepath.Join(t.TempDir(), "example.md")
	writeFile(t, example, "Ask for a review.\n")
	importArgs := func(extra ...string) []string {
		args := []string{"import", "--library", fixture.lib, "--from", fixture.repo, "--path", "agents/reviewer.md",
			"--category", "testing", "--tags", "fixture", "--tools", "claude-code", "--example", example}
		return append(args, extra...)
	}

	before := treeDigest(t, fixture.lib)
	for _, refused := range []struct {
		name string
		args []string
		want string
	}{
		{"no version", importArgs(), "agent/reviewer@1.0.0 is already recorded in content.lock.json; published versions are immutable"},
		{"the published version", importArgs("--version", "1.0.0"), "--version 1.0.0 is not above agent/reviewer@1.0.0"},
		{"a lower version", importArgs("--version", "0.9.0"), "--version 0.9.0 is not above agent/reviewer@1.0.0"},
		{"two numbers", importArgs("--version", "2.0"), `--version "2.0" is not MAJOR.MINOR.PATCH`},
		{"a leading zero", importArgs("--version", "02.0.0"), `--version "02.0.0" is not MAJOR.MINOR.PATCH`},
	} {
		t.Run(refused.name, func(t *testing.T) {
			_, _, err := runTool(t, refused.args...)
			if err == nil || !strings.Contains(err.Error(), refused.want) {
				t.Fatalf("import error = %v, want %q", err, refused.want)
			}
			if treeDigest(t, fixture.lib) != before {
				t.Fatal("a refused import changed the library")
			}
		})
	}

	out, _, err := runTool(t, importArgs("--version", "2.0.0")...)
	if err != nil {
		t.Fatalf("import --version 2.0.0: %v", err)
	}
	if !strings.Contains(out, "agent/reviewer@2.0.0") {
		t.Fatalf("import output %q does not name agent/reviewer@2.0.0", out)
	}
	reviewer := findItem(t, parseFixture(t, fixture.lib), "agent/reviewer")
	if reviewer.Version != "2.0.0" || reviewer.Source == nil || reviewer.Source.Path != "agents/reviewer.md" ||
		reviewer.Source.Commit != fixture.commit1 || reviewer.Adapted() {
		t.Fatalf("reviewer = %+v source %+v adapted %v", reviewer, reviewer.Source, reviewer.Adapted())
	}
	lock := readLock(t, fixture.lib)
	if lock["agent/reviewer@2.0.0"] != reviewer.Checksum() || len(lock) != len(lockBefore)+1 {
		t.Fatalf("lock = %v, want the old entries plus agent/reviewer@2.0.0", lock)
	}
	for key, value := range lockBefore {
		if lock[key] != value {
			t.Fatalf("lock entry %s changed", key)
		}
	}
}
```

RED: `go test -v -count=1 -run '^TestImportVersionTakesTheNameOfARetiredItem$' ./cmd/library-upstream` fails on the `--version` subtests (flag not defined). The "no version" subtest already passes; it pins today's refusal. Helpers `newSyncFixture`, `itemFolder`, `readLock`, `writeFile`, `treeDigest`, `runTool`, `findItem` and `parseFixture` exist in `cmd/library-upstream/{fixture_test.go,main_test.go}`.

### T6. GREEN: `import --version`

`internal/library/upstream/importer.go`:
1. `ImportOptions` gains `Version string // default 1.0.0; above every recorded version to take the name of a retired item (86bcm901a)`.
2. In `Import`, right after the `already exists` loop:
   ```go
   	version, err := importVersion(libraryDir, kind, name, options.Version)
   	if err != nil {
   		return library.Item{}, err
   	}
   ```
   and in the item literal, `Kind: kind, Name: name, Version: version,`.
3. Append (and add `"strconv"` to the imports):
   ```go
   // versionPattern is MAJOR.MINOR.PATCH without leading zeros, as item.json requires.
   var versionPattern = regexp.MustCompile(`^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$`)

   // importVersion is the version a new item gets: 1.0.0 by default. A chosen
   // version lets an upstream item take the name of a retired item whose versions
   // content.lock.json still records (story 86bcm901a); it must be above every
   // one of them, so the catalog shows the new item as the newest.
   func importVersion(libraryDir string, kind pack.Kind, name, chosen string) (string, error) {
   	if chosen == "" {
   		return "1.0.0", nil
   	}
   	want, ok := parseVersion(chosen)
   	if !ok {
   		return "", fmt.Errorf("--version %q is not MAJOR.MINOR.PATCH", chosen)
   	}
   	lock, err := library.ReadLock(filepath.Join(libraryDir, lockFileName))
   	if err != nil {
   		return "", err
   	}
   	prefix := string(kind) + "/" + name + "@"
   	var recorded []string
   	for key := range lock {
   		if version, found := strings.CutPrefix(key, prefix); found {
   			recorded = append(recorded, version)
   		}
   	}
   	sort.Strings(recorded)
   	for _, version := range recorded {
   		have, ok := parseVersion(version)
   		if !ok {
   			return "", fmt.Errorf("%s records %s%s, which is not MAJOR.MINOR.PATCH", lockFileName, prefix, version)
   		}
   		if !versionAbove(want, have) {
   			return "", fmt.Errorf("--version %s is not above %s%s, which %s records; published versions are immutable",
   				chosen, prefix, version, lockFileName)
   		}
   	}
   	return chosen, nil
   }

   // parseVersion splits MAJOR.MINOR.PATCH into numbers.
   func parseVersion(value string) ([3]int, bool) {
   	match := versionPattern.FindStringSubmatch(value)
   	if match == nil {
   		return [3]int{}, false
   	}
   	var parts [3]int
   	for index := range parts {
   		number, err := strconv.Atoi(match[index+1])
   		if err != nil {
   			return [3]int{}, false
   		}
   		parts[index] = number
   	}
   	return parts, true
   }

   // versionAbove reports whether a is a higher version than b, number by number.
   func versionAbove(a, b [3]int) bool {
   	for index := range a {
   		if a[index] != b[index] {
   			return a[index] > b[index]
   		}
   	}
   	return false
   }
   ```
`cmd/library-upstream/main.go`:
- In `runImport`, add `version := flags.String("version", "", "item version (default 1.0.0); above every published version to take the name of a retired item")` and pass `Version: *version` in `upstream.ImportOptions`.
- In `usageText`, change the import line to `--path P --category C --tags a,b --tools t1,t2 --example FILE [--name N] [--version V] [--to REV]`.

GREEN: the T5 command passes. Then `go test -count=1 ./cmd/library-upstream ./internal/library/upstream` passes; if a test pins the usage text, update it to the new line. Commit: `feat(86bcm901a): library-upstream import --version takes the name of a retired item` (importer.go, main.go, import_version_test.go).

### T7. RED: AC2 test, agent reviews and the record fields

Create `internal/library/curation_agents_test.go`:

```go
package library

import (
	"strconv"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// demoAgentVersions are the agents Leorna wrote and shipped before story
// 86bcm901a, with the checksum content.lock.json records for each (origin/main 1ee7157).
var demoAgentVersions = map[string]string{
	"agent/code-reviewer@1.0.0": "3c0d8f1e8542652f483b6a7acff09e021bc9877184359d2a12db1f6496bb9fc8",
	"agent/test-writer@1.0.0":   "fc7831f96228603acf97ffc11332141a4cdd347d313f5cd4fd8b649a4ed191e7",
}

func TestAC2_EachOverlappingDemoAgentHasAReplaceKeepOrMergeDecision(t *testing.T) {
	shipped, record := loadCuration(t)
	lock, err := ReadLock(lockFile)
	if err != nil {
		t.Fatal(err)
	}
	items := map[string]Item{}
	for _, item := range shipped.Items {
		items[itemRef(item)] = item
	}
	reviews := map[string]SkillReview{}
	for _, review := range record.Agents {
		reviews[review.Item] = review
	}
	decisions := map[string]DemoDecision{}
	for _, decision := range record.DemoAgents {
		if _, duplicate := decisions[decision.Item]; duplicate {
			t.Fatalf("demoAgents lists %s twice", decision.Item)
		}
		decisions[decision.Item] = decision
	}
	demo := map[string]bool{}
	for key, checksum := range demoAgentVersions {
		ref, published, _ := strings.Cut(key, "@")
		demo[ref] = true
		if lock[key] != checksum {
			t.Errorf("%s: Leorna's published version must stay in %s unchanged", key, lockFile)
		}
		decision, ok := decisions[ref]
		if !ok || strings.TrimSpace(decision.Reason) == "" {
			t.Errorf("%s has no decision with a reason", ref)
			continue
		}
		current, ships := items[ref]
		switch decision.Decision {
		case "replaced", "merged":
			replacement, ok := items[decision.Replacement]
			if !ok || replacement.Kind != pack.KindAgent || replacement.Source == nil || replacement.Source.Upstream != "agent-skills" {
				t.Errorf("%s: replacement %q is not a shipped agent-skills agent", ref, decision.Replacement)
				continue
			}
			// replaced: the upstream agent ships verbatim; merged: it carries
			// Leorna's additions as a recorded adaptation.
			merged := decision.Decision == "merged"
			if replacement.Adapted() != merged || (reviews[decision.Replacement].Adaptation != nil) != merged {
				t.Errorf("%s is %s, but %s has Adapted() %v and an adaptation record %v",
					ref, decision.Decision, decision.Replacement, replacement.Adapted(), reviews[decision.Replacement].Adaptation != nil)
			}
			switch {
			case decision.Replacement != ref && ships:
				t.Errorf("%s is %s into %s but still ships", ref, decision.Decision, decision.Replacement)
			case decision.Replacement == ref && !agentVersionAbove(current.Version, published):
				t.Errorf("%s: the upstream agent that takes its name ships as %s; it must be above Leorna's %s", ref, current.Version, published)
			}
		case "kept":
			if !ships || current.Source != nil || reviews[ref].Origin != "leorna" || decision.Replacement != "" {
				t.Errorf("%s: a kept demo agent ships as Leorna-authored (no source), is reviewed with origin leorna and names no replacement", ref)
			}
		default:
			t.Errorf("%s: decision %q, want replaced, kept or merged", ref, decision.Decision)
		}
	}
	for ref := range decisions {
		if !demo[ref] {
			t.Errorf("demoAgents entry %s is not one of Leorna's demo agents", ref)
		}
	}
}

// TestEveryShippedAgentIsReviewed holds agents to the skills' review contract
// (ADR 0003, story 86bcm901a): one review of the exact shipped version, and an
// adaptation recorded as a diff that undoes to what import took.
func TestEveryShippedAgentIsReviewed(t *testing.T) {
	shipped, record := loadCuration(t)
	reviews := map[string]SkillReview{}
	for _, review := range record.Agents {
		if _, duplicate := reviews[review.Item]; duplicate {
			t.Fatalf("%s is reviewed twice", review.Item)
		}
		reviews[review.Item] = review
	}
	for _, item := range shipped.Items {
		if item.Kind != pack.KindAgent {
			continue
		}
		review, ok := reviews[itemRef(item)]
		if !ok {
			t.Errorf("%s has no review", item.Key())
			continue
		}
		delete(reviews, itemRef(item))
		if review.Version != item.Version || strings.TrimSpace(review.Owner) == "" ||
			!datePattern.MatchString(review.ReviewedOn) || strings.TrimSpace(review.Notes) == "" {
			t.Errorf("%s: the review needs the shipped version, an owner, reviewedOn (YYYY-MM-DD) and notes", item.Key())
		}
		adapted := 0
		for _, id := range checklistIDs {
			switch review.Checks[id] {
			case "pass", "n/a":
			case "adapted":
				adapted++
			default:
				t.Errorf("%s: check %q is %q, want pass, adapted or n/a", item.Key(), id, review.Checks[id])
			}
		}
		if len(review.Checks) != len(checklistIDs) || review.Checks["scripts"] != "n/a" {
			t.Errorf("%s: answers %d checks (want %d), scripts %q (an agent bundles none: n/a)",
				item.Key(), len(review.Checks), len(checklistIDs), review.Checks["scripts"])
		}
		if item.Source == nil {
			if review.Origin != "leorna" || review.Adaptation != nil || adapted != 0 {
				t.Errorf("%s: a Leorna-authored agent has origin leorna and no adaptation", item.Key())
			}
			continue
		}
		if review.Origin != "upstream" || item.Adapted() != (review.Adaptation != nil) || item.Adapted() != (adapted > 0) {
			t.Errorf("%s: origin %q, Adapted() %v; an imported agent has origin upstream and records an adaptation exactly when it is adapted",
				item.Key(), review.Origin, item.Adapted())
			continue
		}
		if review.Adaptation == nil {
			continue
		}
		if want := "diffs/agent-" + item.Name + ".diff"; review.Adaptation.Diff != want || len(review.Adaptation.Reasons) == 0 {
			t.Errorf("%s: adaptation diff %q, want %q with at least one reason", item.Key(), review.Adaptation.Diff, want)
			continue
		}
		description, body, files := asImported(t, item, review.Adaptation.Diff)
		if got := ImportedContentWithFilesSHA256(description, body, files); got != item.Source.UpstreamSHA256 {
			t.Errorf("%s: undoing %s does not give the content taken from upstream", item.Key(), review.Adaptation.Diff)
		}
	}
	for ref := range reviews {
		t.Errorf("%s is reviewed but not shipped", ref)
	}
}

// agentVersionAbove reports whether MAJOR.MINOR.PATCH version a is above b, number by number.
func agentVersionAbove(a, b string) bool {
	if !semverPattern.MatchString(a) || !semverPattern.MatchString(b) {
		return false
	}
	as, bs := strings.Split(a, "."), strings.Split(b, ".")
	for index := range as {
		x, errX := strconv.Atoi(as[index])
		y, errY := strconv.Atoi(bs[index])
		if errX != nil || errY != nil {
			return false
		}
		if x != y {
			return x > y
		}
	}
	return false
}
```

RED 1 (build): `go test -count=1 -run 'TestAC2_|TestEveryShippedAgentIsReviewed' ./internal/library` fails to build (`record.Agents undefined`). Then edit `internal/library/curation.go`:
- `CurationDir` comment: "holds the review record of the library's skills and agents (stories 86bcm9019, 86bcm901a)".
- `Curation` gains, after `DemoSkills`:
  ```go
  	// Agents and DemoAgents: story 86bcm901a. An agent review answers the same
  	// checklist as a skill review; DemoAgents records what happened to each of
  	// Leorna's demo agents.
  	Agents     []SkillReview  `json:"agents"`
  	DemoAgents []DemoDecision `json:"demoAgents"`
  ```
- `DemoDecision` comments: "what happened to one demo skill or demo agent"; `Decision` is `"replaced"`, `"kept"` or `"merged"` (merged: agents only); `Replacement` is the kind/name of the upstream item (replaced and merged).

RED 2 (real): both tests now fail for real: no `demoAgents` entries ("has no decision with a reason") and no agent reviews ("agent/code-reviewer@1.0.0 has no review").

### T8. RED: Postgres upgrade integration test

Create `internal/store/postgres/library_agents_test.go`:

```go
package postgres

import (
	"context"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// An install that loaded Leorna's demo agents (code-reviewer and test-writer,
// 1.0.0) upgrades to this binary's library (story 86bcm901a): the catalog shows
// the upstream code-reviewer as the newest code-reviewer and lists the four
// upstream agents; the demo rows stay, because the loader never deletes.
func TestLibraryUpgradeFromTheDemoAgentsWithPostgres(t *testing.T) {
	pool := testPool(t)
	repository := seedBaseStore(t, pool)
	ctx := context.Background()
	demo := func(name string) library.Item {
		return library.Item{Kind: pack.KindAgent, Name: name, Version: "1.0.0", Category: "testing",
			Tags: []string{"demo"}, Tools: []library.Tool{library.ToolClaudeCode},
			Description: "Leorna's demo " + name + ".", Example: "Ask for it.\n", Body: "Leorna demo " + name + ".\n"}
	}
	if _, err := repository.loadLibrary(ctx, testLibrary("0.5.0", demo("code-reviewer"), demo("test-writer"))); err != nil {
		t.Fatal(err)
	}
	shipped, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	result, err := repository.loadLibrary(ctx, shipped)
	if err != nil {
		t.Fatalf("upgrade: %v", err)
	}
	if result.Added != len(shipped.Items) || result.Unchanged != 0 {
		t.Fatalf("upgrade result = %+v, want %d added", result, len(shipped.Items))
	}
	admin, err := repository.ResolveOrCreateGoogleUser(ctx, store.GoogleIdentity{Subject: "agents-admin", Email: "admin@example.com", DisplayName: "Admin"})
	if err != nil {
		t.Fatal(err)
	}
	entries, err := repository.ListLibraryItems(store.WithTenant(ctx, admin.TenantID), admin)
	if err != nil {
		t.Fatalf("ListLibraryItems: %v", err)
	}
	newest := map[string]library.Item{}
	for _, entry := range entries {
		if entry.Item.Kind == pack.KindAgent {
			newest[entry.Item.Name] = entry.Item
		}
	}
	var reviewer library.Item
	for _, item := range shipped.Items {
		if item.Kind == pack.KindAgent && item.Name == "code-reviewer" {
			reviewer = item
		}
	}
	if reviewer.Source == nil || newest["code-reviewer"].Version != reviewer.Version || newest["code-reviewer"].Description != reviewer.Description {
		t.Fatalf("catalog code-reviewer = %s %q; want the imported upstream agent %s", newest["code-reviewer"].Version, newest["code-reviewer"].Description, reviewer.Version)
	}
	for _, name := range []string{"security-auditor", "test-engineer", "web-performance-auditor", "test-writer"} {
		if _, listed := newest[name]; !listed {
			t.Errorf("the catalog does not list %s", name)
		}
	}
	rows := libraryRows(t, pool)
	for _, key := range []string{"agent/code-reviewer@1.0.0", "agent/test-writer@1.0.0"} {
		if _, kept := rows[key]; !kept {
			t.Errorf("%s was removed; the loader never deletes rows", key)
		}
	}
}
```

RED (with `LEORNA_TEST_DATABASE_URL`): `go test -v -count=1 -run '^TestLibraryUpgradeFromTheDemoAgentsWithPostgres$' ./internal/store/postgres` fails (today the shipped `code-reviewer@1.0.0` has other content than the stored demo row, so the load fails with `ErrChangedWithoutVersionBump`). Confirm it ran and did not skip (`go test -json`, read that test's own Action). This is the DoD integration test, not an AC test.

### T9. GREEN: import the four agents

From `$WT`, with the task-local PATH:

```sh
L=internal/library
git rm -r -q $L/content/items/agent/code-reviewer $L/content/items/agent/test-writer
go run ./cmd/library-upstream import --from $S/agent-skills.git --path agents/code-reviewer.md --version 2.0.0 \
  --category code-quality --tags code-review,pull-requests --tools claude-code,codex,cursor --example $S/examples/code-reviewer.md
go run ./cmd/library-upstream import --from $S/agent-skills.git --path agents/security-auditor.md \
  --category security --tags security,threat-modeling --tools claude-code,codex,cursor --example $S/examples/security-auditor.md
go run ./cmd/library-upstream import --from $S/agent-skills.git --path agents/test-engineer.md \
  --category testing --tags tests,coverage --tools claude-code,codex,cursor --example $S/examples/test-engineer.md
go run ./cmd/library-upstream import --from $S/agent-skills.git --path agents/web-performance-auditor.md \
  --category performance --tags performance,core-web-vitals --tools claude-code,codex,cursor --example $S/examples/web-performance-auditor.md
```

Each prints `Imported agent/<name>@<version> from agent-skills agents/<name>.md at aeac41d4d005999432bb7312f7ff06383a91d59d.` Then:
- Set `internal/library/content/library.json` `"version"` to `"0.6.0"`.
- Byte check: `for a in code-reviewer security-auditor test-engineer web-performance-auditor; do git -C $S/agent-skills.git show aeac41d4d005999432bb7312f7ff06383a91d59d:agents/$a.md | cmp - $L/content/items/agent/$a/body.md || echo "DIFF $a"; done` prints nothing.
- Lock is append-only: `git diff BASE -- $L/content.lock.json | grep -E '^-[^-]'` prints nothing, and exactly 4 lines are added (`agent/code-reviewer@2.0.0`, `agent/security-auditor@1.0.0`, `agent/test-engineer@1.0.0`, `agent/web-performance-auditor@1.0.0`).
- `go run ./cmd/library-upstream diff --from $S/agent-skills.git > $EV/upstream-diff-<head7>.txt` lists the four agents as `unchanged`, not adapted.

GREEN: the AC1, AC3 and AC4 commands pass, and so does T8. `go test -count=1 ./internal/library/...` and `go test -count=1 ./cmd/library-gate` (with `LEORNA_TEST_GITLEAKS_BIN`) pass apart from the two T7 tests (still RED: no records). Commit: `feat(86bcm901a): import the four agent-skills agents; upstream code-reviewer 2.0.0 replaces the demo, test-engineer replaces test-writer` (items, lock, library.json, curation.go, the four new test files).

### T10. GREEN: reviews and decisions in `curation/curation.json`

Read each imported body in full and check every claim below against it before writing; change any note the text doesn't support, and keep it plain. Append two top-level keys after `demoSkills`, keeping the existing 2-space JSON style. `reviewedOn` = the day you review (YYYY-MM-DD). Don't change `reviewMethod` or any existing entry.

```json
  "agents": [
    {
      "item": "agent/code-reviewer",
      "version": "2.0.0",
      "origin": "upstream",
      "owner": "Justin Issa",
      "reviewedOn": "<YYYY-MM-DD>",
      "checks": {"format": "pass", "accuracy": "pass", "safety": "pass", "scripts": "n/a", "portability": "pass", "links": "pass", "tool-fit": "pass", "licence": "pass"},
      "notes": "Five-axis review (correctness, readability, architecture, security, performance) with a verdict, findings labelled Critical, Required, Optional or Nit with file:line and a fix, and a verification story; it uses the same labels as the shipped code-review-and-quality skill. Imported verbatim at 2.0.0, taking the name of Leorna's demo code-reviewer, whose 1.0.0 stays in content.lock.json. It has no tools line, so Claude Code gives it the session's tools; it is report-only by instruction and Claude Code's permission prompts still apply. Its Composition section names upstream's /ship and /review commands (prompts, 86bcm901b) and links docs/agents.md in upstream's repository, which an install does not carry; the security-auditor and test-engineer agents and the code-review-and-quality skill it names ship. The gate skips it for Claude Code, Codex and Cursor: the desktop client does not install agents yet."
    },
    {
      "item": "agent/security-auditor",
      "version": "1.0.0",
      "origin": "upstream",
      "owner": "Justin Issa",
      "reviewedOn": "<YYYY-MM-DD>",
      "checks": {"format": "pass", "accuracy": "pass", "safety": "pass", "scripts": "n/a", "portability": "pass", "links": "pass", "tool-fit": "pass", "licence": "pass"},
      "notes": "Exploit-focused security review that starts from trust boundaries with STRIDE and covers input handling, authentication and authorization, data protection, infrastructure, third-party integrations and AI or LLM features (OWASP Top 10 and the LLM Top 10), with a severity table and a proof of concept for Critical and High findings. Sound; imported verbatim. No tools line (it gets the session's tools; report-only by instruction). Names upstream's /ship and a future /audit command and links docs/agents.md in upstream's repository, which an install does not carry; the code-reviewer agent it names ships. The gate skips it for Claude Code, Codex and Cursor: the desktop client does not install agents yet."
    },
    {
      "item": "agent/test-engineer",
      "version": "1.0.0",
      "origin": "upstream",
      "owner": "Justin Issa",
      "reviewedOn": "<YYYY-MM-DD>",
      "checks": {"format": "pass", "accuracy": "pass", "safety": "pass", "scripts": "n/a", "portability": "pass", "links": "pass", "tool-fit": "pass", "licence": "pass"},
      "notes": "Test strategy and writing: read the code and nearby tests first, test at the lowest level that captures the behaviour, the Prove-It pattern for bugs, a scenario table (happy path, empty input, boundaries, errors, concurrency) and a coverage report. Sound; imported verbatim. Its test sketch is JavaScript (describe and it); other languages read it as the shape. It writes tests, so it needs Edit and Write; with no tools line it gets the session's tools. Names upstream's /ship and /test commands (prompts, 86bcm901b) and links docs/agents.md in upstream's repository; the test-driven-development skill that /test runs ships. It supersedes the demo test-writer. The gate skips it for Claude Code, Codex and Cursor: the desktop client does not install agents yet."
    },
    {
      "item": "agent/web-performance-auditor",
      "version": "1.0.0",
      "origin": "upstream",
      "owner": "Justin Issa",
      "reviewedOn": "<YYYY-MM-DD>",
      "checks": {"format": "pass", "accuracy": "pass", "safety": "pass", "scripts": "n/a", "portability": "pass", "links": "pass", "tool-fit": "pass", "licence": "pass"},
      "notes": "Core Web Vitals audit (LCP 2.5 s, INP 200 ms, CLS 0.1) of loading, rendering and network, framework-aware, with a strict metric-honesty rule: without Lighthouse, PageSpeed Insights, CrUX or DevTools data the scorecard says not measured and every finding is potential impact. Sound; imported verbatim. It suggests unpinned one-off commands the user runs (npx lighthouse <url>, npx -p chrome-devtools-mcp chrome-devtools <tool>, npm i -g chrome-devtools-mcp), which pass the safety check: a one-off npx <tool> the user asks for is accepted; persistent config that runs automatically (such as an MCP server entry) is adapted with a pin note, as browser-testing-with-devtools, which it names for the MCP server, already is. Registry read 2026-10-28: npm lighthouse 13.6.0 is GoogleChrome/lighthouse, and npm chrome-devtools-mcp 1.12.0 (ChromeDevTools/chrome-devtools-mcp) ships the chrome-devtools bin. CrUX needs the user's own CRUX_API_KEY. Rule 8 names references/performance-checklist.md and rule 9 skills/performance-optimization/SKILL.md, upstream repository paths; the checklist ships inside the performance-optimization skill it names, so the name is enough for an agent (the spec-driven-development ruling) and it is not adapted. Names upstream's /webperf command (86bcm901b) and links docs/agents.md in upstream's repository. The gate skips it for Claude Code, Codex and Cursor: the desktop client does not install agents yet."
    }
  ],
  "demoAgents": [
    {
      "item": "agent/code-reviewer",
      "decision": "replaced",
      "replacement": "agent/code-reviewer",
      "reason": "The upstream agent takes the name at 2.0.0. It covers the demo's correctness, edge-case, error-handling, security and test checks, its file:line findings with a fix and its no-approval-while-blocking rule, and adds readability, architecture and performance with the same labels as the code-review-and-quality skill. It does not carry two points of the demo: an explicit check that the change does not widen scope beyond the story, and the demo's tools line (Read, Grep, Bash); the upstream agent has none, so Claude Code gives it the session's tools. Leorna's 1.0.0 stays in content.lock.json and in the starter seed until 86bcm901r."
    },
    {
      "item": "agent/test-writer",
      "decision": "replaced",
      "replacement": "agent/test-engineer",
      "reason": "test-engineer covers reading the code and nearby tests first, the happy path, boundaries and failure modes, and adds test levels, the Prove-It pattern for bugs and a coverage report. It does not state two lines of the demo: prefer table-driven tests where the language supports them, and never weaken an assertion to make a test pass. The demo also could not edit files (its tools were Read, Grep and Bash). test-writer 1.0.0 stays in content.lock.json and in the starter seed until 86bcm901r."
    }
  ]
```

GREEN: the AC2 command and `go test -v -count=1 -run '^TestEveryShippedAgentIsReviewed$' ./internal/library` pass, and so does `go test -count=1 ./internal/library/...` (including `TestReadCurationRejectsUnknownFields` and 9019's curation tests). Commit: `docs(86bcm901a): review the four agents and record the demo agent decisions`.

### T11. Docs and records

1. `internal/library/README.md` (the module README note the DoD asks for):
   - "Loading": after the 0.5.0 paragraph add: "Library **0.6.0** (story 86bcm901a) ships the four agents of agent-skills 0.6.13 and replaces the demo agents: upstream `code-reviewer` 2.0.0 takes the demo `code-reviewer`'s name, and `test-engineer` replaces `test-writer`. Both demo 1.0.0 versions stay in `content.lock.json` and in the starter seed. See [Curated agents](#curated-agents-86bcm901a)."
   - The sync tool block: add `[--version V]` to the import example and a line `# Take the name of a retired item: remove its folder, then import above its published versions (86bcm901a).`
   - New section at the end:
     ```markdown
     ## Curated agents (86bcm901a)

     Library 0.6.0 ships the four agents agent-skills 0.6.13 has under `agents/` (commit
     `aeac41d4d005999432bb7312f7ff06383a91d59d`): `code-reviewer`, `security-auditor`,
     `test-engineer` and `web-performance-auditor`. An agent's body is the whole upstream
     file with its frontmatter (`name`, `description`), which is a Claude Code subagent file
     as it is. The rules of [ADR 0003](../../adr/0003-curating-upstream-skills.md) apply to
     agents too: verbatim by default, adapt only for a broken path, a security issue or a
     script decision, and record every adaptation as a diff. All four ship verbatim.

     - `curation/curation.json` holds one review per shipped agent (`agents`) on the same
       checklist. For an agent, `scripts` is `n/a`; `links` passes when every skill and agent
       it names ships, and its notes list links into upstream's repository (`docs/agents.md`)
       and upstream slash commands; `tool-fit` passes when the gate passes it for every tool
       it lists. `demoAgents` records `replaced`, `kept` or `merged` for each demo agent.
     - Demo agents: Leorna's `code-reviewer` 1.0.0 is replaced by upstream `code-reviewer`
       2.0.0, which takes its name; `test-writer` 1.0.0 is replaced by `test-engineer`. Both
       1.0.0 versions stay in `content.lock.json` and in the starter seed until 86bcm901r.
       An install that loaded them shows `code-reviewer` 2.0.0 as the newest and keeps
       listing `test-writer` (the loader never deletes rows).
     - Rendering: the desktop client installs agents for no tool yet (`render.NotInstalled`),
       so the gate reports each agent `skipped` for Claude Code, Codex and Cursor with that
       reason. When a client change installs agents, copy it into `render/`, then add the
       tool to `agentInstallingTools` in `cmd/library-gate/agents_test.go`.

     ### Taking the name of a retired item

     `import` gives a new item version 1.0.0. To import an upstream item under the name of an
     item whose versions are already published, remove the item's folder, then import with
     `--version` above every version `content.lock.json` records for that name:

         git rm -r internal/library/content/items/agent/code-reviewer
         go run ./cmd/library-upstream import --path agents/code-reviewer.md --version 2.0.0 \
           --category code-quality --tags code-review,pull-requests --tools claude-code,codex,cursor --example <file>

     The published versions stay in the lock, and the catalog shows the new item as the newest.

     ### Verification

     - `internal/library`: `TestAC1_TheFourUpstreamAgentsAreInTheLibraryWithSourceCommit`,
       `TestAC2_EachOverlappingDemoAgentHasAReplaceKeepOrMergeDecision`,
       `TestEveryShippedAgentIsReviewed`.
     - `cmd/library-gate`: `TestAC3_EachAgentRendersWhereSupportedAndIsSkippedWithAReasonElsewhere`
       and `TestAC4_EachAgentPassesTheContentQualityGate` (needs gitleaks).
     - `cmd/library-upstream`: `TestImportVersionTakesTheNameOfARetiredItem`.
     - `internal/store/postgres` (real PostgreSQL): `TestLibraryUpgradeFromTheDemoAgentsWithPostgres`.
     - Live: one run of each agent in Claude Code (manual, owed to Justin).
     ```
     (Indent the shell lines inside the real README as a fenced `sh` block, as the README does elsewhere.)
2. `delivery/stories.json`: append, as text, after the last entry (`86bcm902y`), adding the comma after its closing brace:
   ```json
     "86bcm901a": {
       "name": "Curate agent definitions",
       "prs": {
         "LeornaAI/leorna-control-plane": []
       }
     }
   ```
   Check: `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` and `python3 -c 'import json; json.load(open("delivery/stories.json"))'`. Every earlier entry is unchanged by value.
3. Attribution: change nothing. Prove it: `go test -count=1 -run '^TestAC1_ThirdPartyNoticesIncludeAgentSkillsMITLicence$' ./internal/library` passes, `go run ./cmd/library-upstream notices` is contained verbatim in `THIRD_PARTY_NOTICES.md`, and `TestAC2_AdminConsoleShowsSourceAndLicenceForEachImportedItem` (real Postgres) passes. It now checks the four agents' rows.
4. Commit: `docs(86bcm901a): library README agents section and delivery inventory`.
5. Not the builder's: the main session saves this plan and its approved copy (`$EV/plan-approved.md`) and records story state in `leorna-workflow.md`. The builder edits no memory or skill files.

### T12. Mutation checks (`mutation-testing-discipline`)

Run each in a detached scratch copy (`git -C $WT worktree add --detach $S/mut HEAD`) or with `go test -overlay` for Go files. Never leave a change in `$WT`. Log each to `$EV/mutation-<n>.txt` with the failing line and restore.
1. `importVersion`: make `versionAbove` return `true` → the T5 test fails ("the published version" and "a lower version" subtests).
2. AC2: set the code-reviewer decision to `kept` → fails. Restore `items/agent/test-writer` from BASE → fails ("still ships"). Change the code-reviewer `2.0.0` folder and lock entry to `0.9.0` → fails ("must be above").
3. AC3: overlay `render/render.go` so `NotInstalled` returns `("", false)` for agents → fails (tripwire, plus status failed). Overlay `render/shared.go` `agentWarnings` to return an empty slice → fails (warnings).
4. AC4: in the scratch copy, add a gitleaks-detectable fake token to `items/agent/security-auditor/example.md` → fails (secrets). Never commit it and never copy it anywhere else.
5. AC1: in the scratch copy, change `items/agent/test-engineer/item.json` `source.commit` to another 40-hex value (and re-record its lock line there) → fails (commit).
6. Agent reviews: delete the web-performance-auditor review → `TestEveryShippedAgentIsReviewed` fails.

### T13. Gates on the head (task-local PATH, owned DB)

From `$WT`, one script, each step logging to `$EV/gates-<head7>/<step>.txt` with an `EXIT=` line, plus `$EV/gates-<head7>.txt` as the summary:
1. `GOLANGCI_LINT=$TC/bin/golangci-lint GOVULNCHECK=$TC/bin/govulncheck GITLEAKS=/usr/local/bin/gitleaks LEORNA_TEST_DATABASE_URL=… LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks make check`. Before trusting it, read the `test` step through a `go test -json -run WithPostgres` stream and confirm the Postgres tests ran (only the two ClickHouse subtests of `TestTeamsAPIWithPostgres` may skip). `make check` and the next step briefly write into the tree; afterwards `git status --porcelain` must be empty.
2. `bash ./scripts/test-module-add.sh`.
3. `make library-check GITLEAKS=/usr/local/bin/gitleaks LIBRARY_REPORT=$S/report.json LIBRARY_SUMMARY=$S/summary.md`. The log shows `PASS agent/<name>@<v> claude-code=skipped codex=skipped cursor=skipped secrets=clean` for each of the four, then `library-gate: PASSED`. Copy the summary to `$EV/library-gate-summary-<head7>.md`.
4. Network (evidence only, CI skips it): `LEORNA_TEST_UPSTREAM_NETWORK=1 go test -v -count=1 -run '^(TestShippedImportsMatchTheRealUpstream|TestAC7_DryRunSyncAgainstUpstreamHEAD)$' ./internal/library/upstream ./cmd/library-upstream`.
5. `git diff BASE -- internal/library/content.lock.json | grep -E '^-[^-]'` prints nothing; `git diff --name-only BASE...HEAD -- .github` prints nothing; `git log --format='%an <%ae>' BASE..HEAD | sort -u` is only `Justin Issa <justin@leorna.com>`; no `Co-Authored-By` in `git log BASE..HEAD`; `CLAUDE.md` not tracked.
6. If `make secrets` fails only on a commit outside `BASE..HEAD` (a sibling's local branch: `gitleaks git` scans every local ref), keep that log, run `gitleaks git --redact --log-opts="BASE..HEAD"` for this branch, and report it as outside the branch. Don't touch the other branch.

### T14. Evidence (one screenshot and one log per AC)

For the screenshots, render each log into a `<pre>` HTML page (HTML-escaped, showing the command, `HEAD=`, the test's `--- PASS` line and `EXIT=`) and capture it with `~/.cache/chrome-for-testing/chrome-linux64/chrome --headless=new --no-sandbox --disable-gpu --hide-scrollbars --user-data-dir=$S/chrome --window-size=1400,<height> --screenshot=$EV/<name>.png file://$S/<name>.html`. Open each PNG and check that the first line is on screen and nothing private is visible: no database password, token or URL.

| AC | Head log | Base log (or exemption) | Screenshot |
| --- | --- | --- | --- |
| AC1 | `$EV/ac1-<head7>.log` | `$EV/ac1-base-<base7>.log` (real FAIL) | `$EV/ac1-agents-imported.png` |
| AC2 | `$EV/ac2-<head7>.log` | `$EV/ac2-base-<base7>.log` (build failure: `record.Agents undefined`) | `$EV/ac2-demo-decisions.png` |
| AC3 | `$EV/ac3-<head7>.log` | `$EV/ac3-base-<base7>.log` (real FAIL) | `$EV/ac3-skipped-with-reason.png` |
| AC4 | `$EV/ac4-<head7>.log` | `$EV/ac4-base-<base7>.log` (real FAIL) | `$EV/ac4-quality-gate.png` |
| AC5 | Justin's run | — | `$EV/ac5-live/ac5-*.png` (Justin) |

- Base runs follow `references/ac-verification.md`. Use a detached copy at BASE and copy in only that AC's test file: AC1 `internal/library/upstream_agents_test.go`, AC2 `internal/library/curation_agents_test.go`, AC3 and AC4 `cmd/library-gate/agents_test.go`. AC2's base result is `[build failed]` with `record.Agents undefined`. The others are a real `--- FAIL`.
- Extra AC3/AC4 views: also capture the four `PASS agent/...` lines plus `library-gate: PASSED` from the T13 `library-check` log as `$EV/ac4-library-check.png`.
- Demo (DoD "demoable in isolation"): run the built control plane locally against a throwaway `_test` DB (`leorna_86bcm901a_demo_test`) with `LEORNA_DEV_MODE=1`, listening on `127.0.0.1:<port>` with a placeholder `https://` public URL and a random `LEORNA_SECRET_ENCRYPTION_KEY`. Read the exact variable names in `internal/config/runtime.go` first. Then headless-Chrome screenshot `/dev/login?next=%2Fadmin%2Flibrary%3Fkind%3Dagent` → `$EV/demo-library-agents.png` (4 agents, code-reviewer 2.0.0) and `/dev/login?next=%2Fadmin%2Fthird-party-content` → `$EV/demo-third-party-agents.png` (rows `agents/<name>.md` with the full commit, MIT). Only on 127.0.0.1; stop the process and drop the demo DB afterwards. If it is blocked, say so and leave it owed.
- AC5 kit: see "Live run (AC5)". The builder prepares it but never runs Claude Code itself.
- Write `$EV/README.md`: an inventory of every file with its AC, head SHA and exit code.

### T15. Stop at ready-for-review

Report: base and head SHAs, `git diff --stat BASE..HEAD`, the commit list, every gate with its exit code and log path, each AC's head and base result with its screenshot path, the mutation results, the AC5 kit path, anything owed, `found_else[]` and `skill_lessons[]`. Don't push, open a PR or post.

## Live run (AC5): what Justin does (⭐ C a)

The builder prepares `$EV/ac5-live/`:
- `sample-project/`: a small Go project, a git repo with one baseline commit made with plain `git commit` and the identity git already resolves there (never pass author flags):
  - `paginate/paginate.go`: committed correct, plus an **uncommitted** change that introduces an off-by-one (`end := start + size + 1`) and drops the upper-bound check. This is for code-reviewer.
  - `store/users.go`: `FindUser(db *sql.DB, name string)` building `SELECT … WHERE name = '` + name + `'` with `fmt.Sprintf`. This is for security-auditor.
  - No `_test.go` files anywhere. This is for test-engineer.
  - `web/index.html`: hero `<img src="hero.jpg" loading="lazy">` with no width or height, `<script src="app.js">` in `<head>` without `defer`, and a Google Fonts link without `display=swap`. This is for web-performance-auditor.
  - `.claude/agents/<name>.md` for the four agents: byte copies of the shipped `internal/library/content/items/agent/<name>/body.md` (`install -m 644`). Record `sha256sum` of each source and copy in `ac5-live/agents.sha256`. These are copied by hand: the desktop client doesn't install agents yet.
- `CHECKLIST.md` with the steps below.

Justin's steps (Ubuntu terminal, about 10 minutes):
1. `cd ~/.hermes/plans/leorna/evidence/86bcm901a/ac5-live/sample-project && claude --setting-sources project` (trust the folder when asked).
2. Type `/agents`. **Pass:** the four agents are listed under project agents. Screenshot (Win+Shift+S) and save as `ac5-agents-list.png` in `\\wsl.localhost\Ubuntu\home\justin\.hermes\plans\leorna\evidence\86bcm901a\ac5-live\`. Press Esc.
3. `Use the code-reviewer agent to review my uncommitted change.` **Pass:** Claude Code shows the code-reviewer agent running, and the reply has "Review Summary" and "Verdict:", plus the off-by-one in `paginate/paginate.go` with file:line under Critical or Required. Save `ac5-code-reviewer.png`.
4. `Use the security-auditor agent on store/users.go.` **Pass:** "Security Audit Report" with a Critical or High SQL injection finding at `store/users.go` and a parameterized-query fix. Save `ac5-security-auditor.png`.
5. `Use the test-engineer agent to analyse test coverage for the paginate package.` **Pass:** a "Test Coverage Analysis" naming the missing tests with priorities (or tests it writes inside the sample project; allow writes only there). Save `ac5-test-engineer.png`.
6. `Use the web-performance-auditor agent on web/index.html.` **Pass:** "Web Performance Audit" whose scorecard says "not measured", with findings tagged "potential impact" (for example the lazy-loaded hero image without width and height, or the render-blocking script). Save `ac5-web-performance-auditor.png`.
7. `/exit`, then tell the main session "AC5 done", or which step failed.

**Fail:** an agent is missing from `/agents`, Claude Code answers without running the named agent, or the reply ignores that agent's report format. The verifier and auditor mark AC5 `not_run` (live). After Justin's run, the finisher records the result and screenshots in the hand-over.

## Risks

1. **Toolchain absent on this desktop** (question D). The builder is blocked at T0b until Justin's part is done. The sibling sessions may hit the same gap; whoever sets it up first, the others reuse `$TC` and `leorna-test-pg` with their own `_test` databases.
2. **Overlap with 86bcm901b (prompts) and 86bcm901j (MCP templates and configs).** Files all three will likely edit, and how the finisher resolves each at hand-over (after a fresh HTTPS fetch, `git merge-tree --write-tree --name-only HEAD origin/main`, then the story's gates on the merged content; ask Justin before bringing main in):
   - `delivery/stories.json` (all three): take main's file unchanged and append this story's entry last, as text. Check every earlier entry is unchanged by value, then `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'`.
   - `internal/library/content/library.json` (all three bump 0.5.0 → 0.6.0): take main's version and bump the next minor (0.7.0 if one sibling merged first). Fix the README version line to match.
   - `internal/library/content.lock.json` (all three append): keep the union of entries. Never change or drop an existing line, then run `TestContentLockPinsEveryItemVersion`. The file is a sorted JSON map: this story's `agent/*` lines sit at the top, 901j's `config/*` and `mcp_template/*` lines right below, so a textual conflict at that boundary is likely and mechanical.
   - `internal/library/README.md` (all three): keep every section; renumber library versions.
   - `internal/library/curation/curation.json` and `internal/library/curation.go` (901b likely adds prompt reviews or demo-prompt fields): merge by value, keeping both sides' arrays and both struct fields.
   - `cmd/library-upstream/main.go` usage text and `internal/library/upstream/importer.go` (901b must enable prompt import: `importableKind`, `Transform`, and `Source.validate` in `library.go`): keep both edits. The `--version` code is self-contained functions plus 3 lines in `Import`.
   - `THIRD_PARTY_NOTICES.md` and `internal/library/content/upstreams/agent-skills/upstream.json` (the 945u attribution records): this story changes neither. If 901b moves the pin or 901j adds an upstream, take main's files. AC1 checks each agent's own `source.commit`, not the pin, so a pin move doesn't break it (9019's skill AC1 test does assert the pin).
   - `adr/`: this story adds none, so there is no number clash.
3. **Same-package test helpers can collide without a text conflict.** `cmd/library-gate` and `internal/library` tests share a package across stories. This plan's helpers carry agent names (`agentGateRun`, `upstreamAgentRoots`, `agentInstallingTools`, `upstreamAgentPaths`, `agentSkillsCardCommit`, `demoAgentVersions`, `agentVersionAbove`). After bringing main in, run the full gates: the build catches any clash.
4. **86bcm901b's `/ship` and `/webperf` prompts name these agents.** If 901b merges first, its prompts reference agents not yet in main, which is 901b's AC to handle. Note it in the PR Assumptions.
5. **`make secrets` scans every local ref**, including the siblings' branches in this clone (memory: "CI secret scan scans every branch"). See T13 step 6.
6. **Shared `refs/remotes/origin/main`.** A sibling's fetch can move it mid-task, so T0 records `BASE` and every check uses that SHA.
7. **Existing installs keep listing test-writer** (the loader never deletes rows). Same as 9019's demo skills; retiring it from the catalog belongs to 86bcm901r or a retire feature.
8. **Agents reach no tool yet.** Until the client installs agents, a pack containing them installs nothing for them. That's the honest AC3 result; the follow-up is in Other things found 4.
9. **AC5 interference.** Without `--setting-sources project`, Justin's SubagentStop hooks would ask each agent for `skill_lessons` and `ac_status`. His global `~/.claude/CLAUDE.md` still loads; the explicit "Use the <name> agent …" prompts keep it on track.
10. **WSL screenshots.** Chrome for Testing may lack system libraries; T0b step 6 finds out early.

## Assumptions

- The ⭐ answers above (A a, B a, C a, D a).
- 2.0.0 for upstream code-reviewer: a major bump because its report contract differs from the demo's.
- All four agents declare `claude-code`, `codex` and `cursor`, like the demo agents and every skill.
- Upstream text is not adapted. The alternative for web-performance-auditor's rule 8: adapt `references/performance-checklist.md` to "the performance-optimization skill's `references/performance-checklist.md`", ship 1.0.0 adapted with a diff, and answer `links: adapted`. Every upstream update then needs a hand merge. Say so in review if you want it.
- No `tools:` restriction added (ADR 0003: not a broken path, security issue or script decision; noted in the reviews).
- `reviewMethod` text in `curation.json` stays as it is; the README states that agents are reviewed the same way.
- The seed pack, the OpenAPI contract, migrations and CI are untouched. `THIRD_PARTY_NOTICES.md` and `upstream.json` are unchanged.
- The hosted "quality-gate CI run" from the card's Verify happens when Justin says "make a PR". Local `make library-check` and `make check` logs are the evidence until then.
- Example texts, categories and tags are Leorna's (README: never counted as adaptation).

## Other things found (not fixed here)

1. `delivery/stories.json` at `1ee7157` lists no PR for 86bcm901u (PR #90, merged) or 86bcm9019 (PR #92, merged): both have `"LeornaAI/leorna-control-plane": []`. So `check-story-shippable.py` passes them vacuously. Low; known (9019's `3cd9b0f` waits for "push").
2. The demo `test-writer` "writes tests" but its `tools: Read, Grep, Bash` (`items/agent/test-writer/body.md:4`) has no Edit or Write. Low; moot if it is replaced.
3. This Windows desktop (WSL Ubuntu) has no Go, make, golangci-lint, govulncheck or Postgres, and Docker Desktop's WSL integration is off. Only gitleaks 8.30.1 and Chrome for Testing exist. Medium: it blocks every control-plane build here (question D).
4. The desktop client installs agents for no tool (`toolconnector/transform.go:28` at client `f105e27`; copied in `render/shared.go:20-31`), so library agents reach no engineer through Sync. Medium (product). Suggested follow-up card: the client installs agents for Claude Code at `.claude/agents/<name>.md`, and for Codex and Cursor where they support agents; the control plane then copies the change into `render/` and lists the tools in `agentInstallingTools`.

## Forecast

Builder about 3–4.5 h of active work: toolchain 30–60 min after Justin's two steps, tests and `--version` 45–60 min, import and records 45 min, docs 20 min, gates 30–40 min, evidence and the AC5 kit 30–45 min. Then two reviews, fixes, verifier, blind auditor and `ac-check.sh`, expected to end at `READY FOR THE USER` with AC5 owed. AC5 takes Justin about 10 minutes.

## Completion contract

- Builder: stop at `ready-for-review` (T15). Nothing is pushed, opened or posted.
- Verifier and auditor: follow `references/ac-verification.md`. Use their own folders `$EV/verifier/` and `$EV/auditor/`, their own `_test` databases (`leorna_86bcm901a_verify<n>_test`, `leorna_86bcm901a_audit<n>_test`), and their own scratch `<scratchpad>/86bcm901a-<role>/`. Run `make check` and `test-module-add.sh` in a detached copy at the head, never in the story worktree.
- Finisher: fetches main again over HTTPS through gh, reconciles any newer main (merge-tree check; resolutions in Risks 2), and re-runs the gates on the final head. Hand-over per `leorna` step 6: stop-and-show, PR text, review prompt, ClickUp evidence draft with the AC → test → result table and AC5 as owed or done, and the team message. Every word ("push", "make a PR", "post") waits for Justin.
