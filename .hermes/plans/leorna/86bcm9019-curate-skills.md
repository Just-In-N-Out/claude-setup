# 86bcm9019 Curate the skills collection: plan

ClickUp [Curate the skills collection](https://app.clickup.com/t/86bcm9019) (PI-2, E10 Content Library, size L, p1-high, Justin). Full pipeline, all roles Opus 5.5 xhigh. **Approved 2026-10-25: Justin said go with every ⭐ answer.**
Repo: **leorna-control-plane only** (no client change, no OpenAPI change, no migration, no CI change).
Branch: `feat/86bcm9019-curate-skills` from freshly fetched `origin/main` (`5778350`, 2026-10-25 11:14 EDT), worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`.
Evidence: `~/.hermes/plans/leorna/evidence/86bcm9019/`.

## Justin's answers (2026-10-25)

Justin: "Just go with the recommended stuff, okay?" = **go** with every ⭐: A a (exclude idea-refine.sh), B a (gate renders + scans supporting files, port client PR #22), C a (pin note in browser-testing-with-devtools), D a (keep + expand incident-postmortem 1.1.0), E a (Justin owns the reviews; agents review, he signs off in the PR), F a (seed pack untouched), G a (agent renders the AC6 folders; Justin copies them in and tries them), H a (no regulated-industry notes). AC6 (proposed) (live) approved with the plan.

**R1-4 (review record), Justin 2026-10-25: "Reword + one rule" (⭐ a).** Reword the code-review-checklist replacement reason in `curation.json` to name the two points code-review-and-quality doesn't cover (contracts/docs updated when behaviour changes; a rollback path), and add one sentence to the safety definition (README checklist) and to the affected skills' review notes: a one-off `npx <tool>` the user asks for is accepted; persistent config that runs automatically (e.g. an MCP server entry) is adapted with a pin note. No skill text changes.

**`npx vercel` edge case (ci-cd-and-automation preview/rollback jobs), Justin 2026-10-25: "Keep as example".** Sample CI text the user copies on request: safety pass, risk stated in the review note, no adaptation, no version bump.

**R2-1 (`npx lhci` / `npx migrate-check`), Justin 2026-10-25: "Adapt to @lhci/cli" (⭐ a).** performance-optimization 1.0.0 → 1.0.1: replace the bare `npx lhci autorun` with `npx @lhci/cli@<reviewed version> autorun` plus a short pin note; new lock line, stored adaptation diff, `safety: adapted`. Reword the deprecation-and-migration `npx migrate-check` review note to say the npm name is a reserved placeholder (no skill text change there). Third adaptation, for safety.

**`npx tsc` (context-engineering, git-workflow-and-versioning, incremental-implementation, ci-cd-and-automation), Justin 2026-10-25: "Keep, state it in notes".** No skill text change, no adaptation. Each of the four review notes states that without `typescript` installed, npx fetches npm `tsc` 2.0.4 (registry: "A deprecated release of the TypeScript compiler", basarat/orta), whose bin only prints a warning and exits 1, not the project's compiler (fixer 3 read the tarball) (ci-cd-and-automation's note already says so).

**V2-1 (shipping-and-launch note misses the shared accessibility-checklist nits: `npx axe-core` has no CLI; 18px should be 18pt), Justin 2026-10-25: "Hand-over follow-up".** Keep the proven head `eab3940`; name the gap in the hand-over and PR Assumptions; fix in a small follow-up or at PR time.

**Acceptance 2026-10-25:** `ac-check.sh` → `READY FOR THE USER: 5 of 6 ACs proven on eab3940; live ACs owed to the user: AC6` (verifier 2 + blind auditor 1, base `5778350`).

## Open questions (a bare "go" takes every ⭐)

**A. idea-refine bundles `scripts/idea-refine.sh` (bash; it only runs `mkdir -p docs/ideas`). What ships?**
- a ⭐ Exclude it; the skill creates docs/ideas itself
- b Ship it plus a reviewed PowerShell twin (.ps1)

(With b: T10 keeps the script, adds `scripts/idea-refine.ps1` with its own review, and the script entry becomes `"decision": "shipped", "windowsPath": "scripts/idea-refine.ps1"`. Windows' default PowerShell policy blocks unsigned `.ps1` files, so the body would have to tell people to bypass it; that is why a is recommended.)

**B. The quality gate renders and scans only SKILL.md; supporting files (`files/…`) are never rendered or secret-scanned. Fix it here?**
- a ⭐ Yes: copy client PR #22 folder rendering; scan files/
- b No: body only; record the gap as a follow-up

(With b: drop T3–T4 and the supporting-file assertion in the AC4 test.)

**C. browser-testing-with-devtools tells people to run `npx -y chrome-devtools-mcp@latest` (unpinned, auto-confirmed). Adapt it?**
- a ⭐ Yes: add a short pin-a-reviewed-version note
- b No: import unchanged; flag it in the review notes

**D. incident-postmortem has no upstream equivalent. What happens to it?**
- a ⭐ Keep as Leorna's; expand it to a full skill (1.1.0)
- b Keep as Leorna's, unchanged (1.0.0)
- c Remove it from the library

(The other two demo skills are replaced: `code-review-checklist` → `code-review-and-quality`, `commit-message-style` → `git-workflow-and-versioning`; both upstream skills cover the demo's whole content.)

**E. AC2 needs a named review owner. Who?**
- a ⭐ Justin; agents review, you sign off in the PR
- b One team owner per skill (you name them)

**F. The starter seed pack (`internal/pack/seed.json`) still installs the 3 demo skills. Change it?**
- a ⭐ No: library only; starter packs are 86bcm901r
- b Yes: swap them in seed.json too (seed 1.3.0)

**G. The card's Verify asks for a manual check of 3 sampled skills in each tool (AC6). How?**
- a ⭐ Agent renders the folders; you copy them in and try
- b Full path: local control plane + desktop client Sync
- c Skip it; the CI gate is enough (drops AC6)

**H. The card mentions "regulated-industry notes". Add any?**
- a ⭐ Not now: adapt only broken paths and security
- b Add a short regulated-teams note to 5 skills

## Acceptance criteria

The card's five ACs in card order, plus the card's Verify line as a proposed live AC. Each test fails on the base commit `5778350` (a real `--- FAIL`, or a build failure of the new code where noted).

- AC1: Given the import, then all 25 upstream skills are in the library with their upstream name, version and source commit recorded.
  Meaning: each of the card's 25 names is a `skill` item whose `source` says `upstream: agent-skills`, `path: skills/<name>` (the upstream name) and `commit: aeac41d4d005999432bb7312f7ff06383a91d59d`; the upstream record says `release: 0.6.13` (the upstream version); the item's own library version is in `item.json` and pinned in `content.lock.json`.
  Test `TestAC1_AllUpstreamSkillsAreInTheLibraryWithNameReleaseAndCommit` (`internal/library/upstream_skills_test.go`):
  `go test -v -count=1 -run '^TestAC1_AllUpstreamSkillsAreInTheLibraryWithNameReleaseAndCommit$' ./internal/library`
  Base: real FAIL (5 of 25 present). Uses only existing API.
- AC2: Given each imported skill, then it has been reviewed (owner named) and any Leorna adaptation is recorded as a diff against upstream.
  Meaning: `internal/library/curation/curation.json` has one review per shipped skill (owner, date, the 8-point checklist, notes) for the exact shipped version; an item is marked adapted exactly when `Item.Adapted()` is true; each adapted item has `curation/diffs/<kind>-<name>.diff`, and applying that diff in reverse to the shipped item gives back exactly the content taken from upstream (its fingerprint equals `source.upstreamSha256`).
  Test `TestAC2_EveryImportedSkillIsReviewedWithOwnerAndAdaptationDiff` (`internal/library/curation_test.go`):
  `go test -v -count=1 -run '^TestAC2_EveryImportedSkillIsReviewedWithOwnerAndAdaptationDiff$' ./internal/library`
  Base: build failure of the new code (`undefined: ReadCuration`).
- AC3: Given skills that bundle scripts, then each script is security-reviewed and either shipped with a Windows-compatible path or excluded with a reason.
  Meaning: every script an imported skill had upstream, and every script any shipped skill carries, has a security review (reviewer, date, findings, upstream SHA-256) and a decision: `excluded` (absent from the shipped skill, a reason, and no shipped text still names it) or `shipped` (present, with a reviewed `.ps1`/`.cmd`/`.bat`/`.py` Windows path in the same skill).
  Test `TestAC3_BundledScriptsAreSecurityReviewedAndWindowsSafeOrExcluded` (`internal/library/curation_test.go`):
  `go test -v -count=1 -run '^TestAC3_BundledScriptsAreSecurityReviewedAndWindowsSafeOrExcluded$' ./internal/library`
  Base: build failure of the new code.
- AC4: Given each skill, then it has passed the content quality gate in Claude Code, Codex and Cursor.
  Meaning: the real `library-gate` run over the shipped library passes; every skill (the 25 upstream ones by name, plus every other shipped skill) lists all three tools and is `rendered` (no warning, skip or failure) for each, with no secret finding, and each tool's output holds the skill's `SKILL.md` and every supporting file.
  Test `TestAC4_EverySkillPassesTheGateInClaudeCodeCodexAndCursor` (`cmd/library-gate/skills_test.go`):
  `LEORNA_TEST_GITLEAKS_BIN=<gitleaks 8.30.1> go test -v -count=1 -run '^TestAC4_EverySkillPassesTheGateInClaudeCodeCodexAndCursor$' ./cmd/library-gate`
  Base: real FAIL (20 skills missing; supporting files not rendered). The test skips without gitleaks, so every AC run sets `LEORNA_TEST_GITLEAKS_BIN`; a SKIP line rejects the run. CI already passes gitleaks to `make test` (ci.yml line 119).
- AC5: Given the 3 current demo skills, then each is either replaced by an upstream equivalent or kept as a Leorna-authored skill.
  Meaning: `code-review-checklist`, `commit-message-style` and `incident-postmortem` each have one decision in the record: `replaced` (no longer shipped; the replacement is a shipped agent-skills skill; its published versions stay in `content.lock.json`) or `kept` (shipped with no `source`, and reviewed).
  Test `TestAC5_EachDemoSkillIsReplacedByAnUpstreamSkillOrKeptAsLeornaAuthored` (`internal/library/curation_test.go`):
  `go test -v -count=1 -run '^TestAC5_EachDemoSkillIsReplacedByAnUpstreamSkillOrKeptAsLeornaAuthored$' ./internal/library`
  Base: build failure of the new code.
- AC6 (proposed) (live): Given three sampled skills (`code-review-and-quality`, `test-driven-development`, `security-and-hardening`) installed for Claude Code, Codex and Cursor, when Justin asks each tool to use them, then each tool lists the skill and follows it (for security-and-hardening it reads `references/hardening-patterns.md`).
  Test: manual, Justin (`manual: AC6 three sampled skills in Claude Code, Codex and Cursor`); screenshots `ac6-claude-code.png`, `ac6-codex.png`, `ac6-cursor.png`.
  Why a separate live AC: the CI gate (AC4) proves each skill renders, parses and is clean, but only the real tools show that they find and follow a skill. Codex and Cursor read skills from `$CODEX_HOME/skills` and `~/.cursor/skills`, which are Justin's real tool homes (agents may not write there without his OK), and Cursor is a GUI signed in as him. Keeping it apart lets agents fully accept AC4 while this stays visible as owed to Justin.

## Playback

Import the 20 agent-skills skills the library doesn't have yet (5 are already in: debugging-and-error-recovery from 86bcm945u; security-and-hardening, performance-optimization, constraint-driven-development and idea-refine from 86bcm945q) with the existing `library-upstream import` tool at the pinned commit. Review all 25 plus the Leorna-authored one we keep against one checklist, record owner and result per skill, and record every Leorna change as a diff that provably undoes back to upstream. Review idea-refine's bash script and drop it (the skill just tells the agent to create the folder). Make the gate check supporting files too, so "passed the gate" covers whole skill folders. Replace two demo skills with their upstream equivalents and keep and improve the third.

## Facts verified (2026-10-25, this session)

- **Dependencies are all merged on `origin/main` `5778350`** (fresh HTTPS fetch through `gh`; `gh pr view`): 86bcm9018 loader PR #82 (merged 2026-10-21), 86bcm945u upstream sync PR #89 (2026-10-24 18:28 UTC), 86bcm901u quality gate PR #90 (2026-10-24 22:44 UTC), 86bcm945q multi-file items PR #91 (2026-10-25 07:16 UTC) + client PR #22 (07:27 UTC). The 2026-10-24 note "901u PR #90 still OPEN" is stale. No open PRs in either repo.
- **Repo:** there is no `content` repo. The library is `leorna-control-plane/internal/library/content/`, embedded by `//go:embed all:content` (`internal/library/source.go:42`). 9018, 945u, 901u and 945q all put it there.
- **Library on main:** `library.json` 0.4.0; 14 items. Skills: 5 imported from agent-skills (above) and 3 Leorna demo skills. `idea-refine` is already **adapted** (1.0.1: body line `bash skills/idea-refine/scripts/idea-refine.sh` became a placeholder path) and ships `scripts/idea-refine.sh` as `executableFiles`, with no recorded security or Windows review.
- **The 3 demo skills** (no `source`, also in `internal/pack/seed.json`): `code-review-checklist` (6-line checklist), `commit-message-style` (Leorna's own commit format), `incident-postmortem` (headings only). Upstream equivalents: `code-review-and-quality` (multi-axis review, covers scope, tests, security) and `git-workflow-and-versioning` (conventional commits, atomic commits); nothing upstream covers postmortems.
- **Upstream:** tag `0.6.13` (not `v0.6.13`) = `aeac41d4d005999432bb7312f7ff06383a91d59d` = upstream HEAD today. Exactly 25 skills under `skills/`. Every SKILL.md has exactly `name` + a one-line `description` (max 880 chars), so the importer accepts all 25. Only `idea-refine` bundles a script (342 bytes; constant path, no input, no network). Repo-level `hooks/*.sh` and `scripts/*.js` belong to no skill and are not imported. 11 skills link to shared `../../references/*.md`; the importer copies those into the skill and rewrites the link.
- **Fingerprints:** recomputing the importer's fingerprint offline for the 5 imported skills matches every recorded `upstreamSha256`, idea-refine included. So the reverse-diff proof in AC2 works on existing data.
- **Secrets:** gitleaks 8.30.1 default rules over every upstream `skills/**` and `references/**` file at the pin: 0 findings.
- **Shell injection:** no `` !`cmd` `` dynamic-context patterns, `allowed-tools` or hooks in any upstream skill. One unpinned auto-run install: `browser-testing-with-devtools` line 35 (`npx -y chrome-devtools-mcp@latest`).
- **Gate gap:** `render.FromLibrary` (`internal/library/render/render.go:63`) drops `Files`, and `scanSecrets` copies only `item.json`, `body.md`, `example.md` (`internal/library/gate/scan.go:38`). Client PR #22 (merged) added `RenderSkillFolder` and supporting-file rules; the gate's copy is pinned at client `17f7c1b`, before it.
- **Removing an item** from `content/` is allowed by the lock test (it only checks shipped items), and no test ties the seed to the library. The loader never deletes rows, so an existing install keeps showing a removed item in the catalog.
- **Overlap:** no open PR or branch touches these files. 86bcm901b (prompts, to do, unassigned) will touch `library.json`, `content.lock.json` and the library README; build 9019 first. 86bcm901r (role packs) depends on this card.
- **Plan code checked statically:** the five Go blocks below parse, are gofmt-clean, and pass `go vet` and golangci-lint 2.14.0 when placed into a `git archive` copy of `origin/main` `5778350` (the AC1 and AC4 tests also compile against main alone). Nothing was run.

## Approach

1. **Gate first (B ⭐).** Copy client PR #22's skill-folder rules into `internal/library/render` (as the README requires for any merged client transformer change), carry supporting files through `FromLibrary`, render them for every tool, list scripts that need admin approval in the report, and secret-scan every supporting file. Then "passed the gate" covers the whole folder that reaches an engineer.
2. **Review record, outside the shipped content.** `internal/library/curation/curation.json` (not embedded, never shipped) holds the review of each shipped skill, the script reviews and the demo decisions. `internal/library/curation/diffs/<kind>-<name>.diff` holds each adaptation. A diff is made by a new `library-upstream adaptation --item <kind>/<name>` subcommand that reads upstream at the item's recorded commit with the importer's own code, checks the recorded fingerprint, and diffs it against the shipped item in a fixed text layout. The AC2 test applies the diff in reverse and checks the fingerprint, offline.
3. **Import with the existing tool.** `library-upstream import --from <scratch clone>` for each of the 20, with the category, tags and example below. Verbatim by default.
4. **Adapt only when needed** (H ⭐): an instruction that can't work once installed, a security issue, or a script decision. That's two skills: idea-refine (script excluded, A ⭐) and browser-testing-with-devtools (pin note, C ⭐). Every unadapted skill takes future upstream updates with one `accept`.
5. **Demo skills:** remove two folders (their lock entries stay as history), rewrite incident-postmortem as a full skill at 1.1.0 (D ⭐). Seed pack untouched (F ⭐).
6. Library version 0.4.0 → **0.5.0**.

## Skills

- Every role: `leorna`, `engineering-best-practices`.
- Builder: `test-driven-development`, `security-best-practices` (third-party content, the script review, subprocess and path handling: GO-INJECT-002, GO-PATH-001), `mutation-testing-discipline` (the AC2 reverse-diff check, the AC3 exclusion check and the gate's supporting-file scan are guards: prove each can fail).
- Reviewers: `requesting-code-review`, `code-review-practice`, plus `security-best-practices`.
- Fixers: `receiving-code-review`, `test-driven-development`.
- Verifier and auditor: `references/ac-verification.md` of feature-dispatch.
- Finisher: `receiving-code-review`, `git-commit-rules`, `test-driven-development`.
- Not needed: `api-contract-drift-guard` (OpenAPI untouched), `backend-data-migrations` (no schema or storage change), `multi-tenant-auth-management` (no auth or tenant change). **No chosen skill has a "Mandatory Validation and Agent Defect Loop" section** (only api-contract-drift-guard and backend-data-migrations do, checked with grep), so no defect loop applies.

## Choices

- Control plane only; the client already installs whole skill folders (client PR #22).
- Review record in `internal/library/curation/` as JSON, not in `item.json`: review data isn't shipped content, and touching `item.json` would force version bumps on 5 published items.
- A review covers one exact version; a later `accept` must update the review entry (README note). Owner `Justin Issa` (E ⭐); `reviewMethod` says plainly that an agent did the checklist review and Justin signs off by approving the PR (AGENTS.md: an assistant review is never a human approval).
- Diffs come from a tool, not by hand, so they are reproducible and checked against real upstream.
- The adaptation view stores executable flags in `executable.txt`, not file modes, so diffs and the reverse apply work the same on every OS.
- Versions: 20 imports at 1.0.0 (browser-testing-with-devtools adapted before its first release, so 1.0.0 is the adapted text); idea-refine 1.0.1 → 1.1.0; incident-postmortem 1.0.0 → 1.1.0. Lock entries already on `origin/main` never change.
- Gate: scripts are listed per item (`ItemResult.Scripts`) and the item is rendered as an admin-approved pack would be, so a script never turns a skill into a failure or a warning; the summary lists them as "needs admin approval".
- No `THIRD_PARTY_NOTICES.md` change: the notice is per upstream and the pin doesn't move (`library-upstream notices` output is unchanged; `TestAC1_ThirdPartyNoticesIncludeAgentSkillsMITLicence` keeps checking it). MIT attribution for all 25 is the existing `upstreams/agent-skills/` record, the admin "Third-party content" page and the installer `--notices`.

## Assumptions

- "Version" in AC1 means the upstream release (0.6.13, recorded once in `upstream.json` and tied to each item by its commit) plus the item's own library version.
- "Windows-compatible path" means a reviewed supporting file that runs on stock Windows (`.ps1`, `.cmd`, `.bat`, `.py`).
- Upstream HEAD equals the pin today; imports use the pin regardless (the tool's default revision).
- Existing installs keep showing the two replaced demo skills (the loader never deletes rows). Fine for the pilot; a "retired" flag is a follow-up.
- `spec-driven-development` names sibling skills by upstream repo path (`skills/incremental-implementation/SKILL.md`) and by name; the name is enough for an agent, so no adaptation (review note).

## Files and areas touched

- `internal/library/render/{render.go,shared.go,claudecode.go,codex.go,cursor.go,render_test.go}`, `render/testdata/client/SOURCE.md`
- `internal/library/gate/{gate.go,scan.go,report.go,gate_more_test.go}`
- `cmd/library-gate/skills_test.go` (new)
- `internal/library/{curation.go,adaptation.go}` (new), `internal/library/{curation_test.go,upstream_skills_test.go,adaptation_test.go}` (new), `internal/library/multifile_test.go`
- `internal/library/upstream/{importer.go,adaptation.go}` (`adaptation.go` new), `cmd/library-upstream/{main.go,main_test.go}`
- `internal/library/content/library.json`, `content.lock.json`, 20 new `items/skill/<name>/`, `items/skill/{idea-refine,incident-postmortem}/`, removed `items/skill/{code-review-checklist,commit-message-style}/`
- `internal/library/curation/curation.json`, `curation/diffs/skill-idea-refine.diff`, `curation/diffs/skill-browser-testing-with-devtools.diff` (new)
- `internal/library/README.md`, `adr/0003-curating-upstream-skills.md` (new), `.gitattributes`, `delivery/stories.json`

## Tasks (build order, test-first)

Commit after each task with `feat(86bcm9019): …` / `test(86bcm9019): …` / `docs(86bcm9019): …`, staging explicit paths. Plain `git commit`; author must be `Justin Issa <justin@leorna.com>`.

### T0 Setup and before-state
1. `cd ~/Leorna/leorna-control-plane && git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`; record `git rev-parse origin/main` (expect `5778350…` or newer; if newer, re-read `git log 5778350..origin/main -- internal/library cmd/library-gate cmd/library-upstream` and stop if anything there changed).
2. `git worktree add -b feat/86bcm9019-curate-skills .claude/worktrees/86bcm9019-curate-skills origin/main`. Never touch `main`, `deploy/local/` or other worktrees.
3. Scratch: `S=~/.hermes/cache/scratch/86bcm9019-builder` (mkdir). Tools into `$S/bin`: `GOBIN=$S/bin go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.14.0`, `GOBIN=$S/bin go install golang.org/x/vuln/cmd/govulncheck@v1.7.0`; gitleaks 8.30.1 (check `gitleaks version`; Homebrew's or a scratch copy). Put `$S/bin`, then gnubin (`$(brew --prefix coreutils)/libexec/gnubin`), then `/opt/homebrew/bin` first on the task's PATH; echo each tool's version.
4. Test DB: `docker start leorna-test-pg`; create an owned DB `leorna_86bcm9019_test` (name must end `_test`); `export LEORNA_TEST_DATABASE_URL=postgres://leorna:<password read via docker, never printed>@127.0.0.1:5432/leorna_86bcm9019_test?sslmode=disable`.
5. Upstream clone (data only, never run): `git clone --bare --quiet https://github.com/addyosmani/agent-skills.git $S/agent-skills.git`; check `git -C $S/agent-skills.git rev-parse '0.6.13^{commit}'` prints `aeac41d4d005999432bb7312f7ff06383a91d59d`. Every import and adaptation uses `--from $S/agent-skills.git`.
6. Before-state capture (base): terminal capture `before-library-5778350.png` of `ls internal/library/content/items/skill` and `cat internal/library/content/library.json`.

### T1 AC1 and AC4 tests (RED)
Write `internal/library/upstream_skills_test.go`:

```go
package library

import (
	"regexp"
	"sort"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// agentSkillsAtPin is the card's list (ClickUp 86bcm9019): every skill that
// addyosmani/agent-skills ships at release 0.6.13.
var agentSkillsAtPin = []string{
	"spec-driven-development", "planning-and-task-breakdown", "incremental-implementation",
	"test-driven-development", "code-review-and-quality", "code-simplification",
	"debugging-and-error-recovery", "security-and-hardening", "api-and-interface-design",
	"frontend-ui-engineering", "browser-testing-with-devtools", "performance-optimization",
	"observability-and-instrumentation", "ci-cd-and-automation", "git-workflow-and-versioning",
	"documentation-and-adrs", "deprecation-and-migration", "shipping-and-launch",
	"context-engineering", "source-driven-development", "constraint-driven-development",
	"doubt-driven-development", "idea-refine", "interview-me", "using-agent-skills",
}

func TestAC1_AllUpstreamSkillsAreInTheLibraryWithNameReleaseAndCommit(t *testing.T) {
	if len(agentSkillsAtPin) != 25 {
		t.Fatalf("the card names 25 skills, the list has %d", len(agentSkillsAtPin))
	}
	shipped, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	up, ok := shipped.Upstream("agent-skills")
	if !ok || up.Repository != "https://github.com/addyosmani/agent-skills" || up.Release != "0.6.13" ||
		up.Commit != "aeac41d4d005999432bb7312f7ff06383a91d59d" {
		t.Fatalf("upstream record = %+v, %v; want agent-skills at release 0.6.13, commit aeac41d…", up, ok)
	}
	lock, err := ReadLock(lockFile)
	if err != nil {
		t.Fatal(err)
	}
	fingerprint := regexp.MustCompile(`^[0-9a-f]{64}$`)
	imported := map[string]Item{}
	for _, item := range shipped.Items {
		// Agents (86bcm901a) and prompts (86bcm901b) from the same upstream come later.
		if item.Kind != pack.KindSkill || item.Source == nil || item.Source.Upstream != up.Name {
			continue
		}
		if _, duplicate := imported[item.Name]; duplicate {
			t.Fatalf("%s is imported twice", item.Name)
		}
		imported[item.Name] = item
	}
	var missing []string
	for _, name := range agentSkillsAtPin {
		item, ok := imported[name]
		if !ok {
			missing = append(missing, name)
			continue
		}
		delete(imported, name)
		switch {
		case item.Source.Path != "skills/"+name:
			t.Errorf("%s: source path %q, want the upstream name skills/%s", item.Key(), item.Source.Path, name)
		case item.Source.Commit != up.Commit:
			t.Errorf("%s: source commit %s, want the 0.6.13 commit %s", item.Key(), item.Source.Commit, up.Commit)
		case !fingerprint.MatchString(item.Source.UpstreamSHA256):
			t.Errorf("%s: upstreamSha256 %q is not a SHA-256", item.Key(), item.Source.UpstreamSHA256)
		case !semverPattern.MatchString(item.Version):
			t.Errorf("%s: version %q is not MAJOR.MINOR.PATCH", item.Key(), item.Version)
		case lock[item.Key()] != item.Checksum():
			t.Errorf("%s is not pinned in %s", item.Key(), lockFile)
		}
	}
	if len(missing) > 0 {
		t.Errorf("%d of the 25 upstream skills are not in the library: %s", len(missing), strings.Join(missing, ", "))
	}
	extra := make([]string, 0, len(imported))
	for name := range imported {
		extra = append(extra, name)
	}
	sort.Strings(extra)
	if len(extra) > 0 {
		t.Errorf("skills from agent-skills that the card does not list: %s", strings.Join(extra, ", "))
	}
}
```

Write `cmd/library-gate/skills_test.go` (package `main`; `realLibrary`, `gitleaksForTest` and `run` already exist in this package):

```go
package main

import (
	"bytes"
	"context"
	"encoding/json"
	"os"
	"path/filepath"
	"slices"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// upstreamSkills is the card's list (ClickUp 86bcm9019, agent-skills 0.6.13).
var upstreamSkills = []string{
	"spec-driven-development", "planning-and-task-breakdown", "incremental-implementation",
	"test-driven-development", "code-review-and-quality", "code-simplification",
	"debugging-and-error-recovery", "security-and-hardening", "api-and-interface-design",
	"frontend-ui-engineering", "browser-testing-with-devtools", "performance-optimization",
	"observability-and-instrumentation", "ci-cd-and-automation", "git-workflow-and-versioning",
	"documentation-and-adrs", "deprecation-and-migration", "shipping-and-launch",
	"context-engineering", "source-driven-development", "constraint-driven-development",
	"doubt-driven-development", "idea-refine", "interview-me", "using-agent-skills",
}

// skillRoots is where each tool's rendered files put a skill (the client's
// transformers: Claude Code renders into a project, Codex and Cursor into their homes).
var skillRoots = map[library.Tool]string{
	library.ToolClaudeCode: ".claude/skills/",
	library.ToolCodex:      "skills/",
	library.ToolCursor:     "skills/",
}

func TestAC4_EverySkillPassesTheGateInClaudeCodeCodexAndCursor(t *testing.T) {
	bin := gitleaksForTest(t)
	reportPath := filepath.Join(t.TempDir(), "report.json")
	var stdout, stderr bytes.Buffer
	if code := run(context.Background(), []string{"-dir", realLibrary, "-gitleaks", bin, "-json", reportPath},
		&stdout, &stderr, gate.NewGitleaks); code != 0 {
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
	results := map[string]gate.ItemResult{}
	for _, result := range report.Items {
		results[result.Key] = result
	}
	// The AC names the three tools, so they are written out here.
	allTools := []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor}
	shippedSkills := map[string]bool{}
	for _, item := range lib.Items {
		if item.Kind != pack.KindSkill {
			continue
		}
		shippedSkills[item.Name] = true
		result, ok := results[item.Key()]
		if !ok || !result.Passed || len(result.Secrets) != 0 {
			t.Errorf("%s did not pass the gate: %+v", item.Key(), result)
			continue
		}
		for _, tool := range allTools {
			if !slices.Contains(item.Tools, tool) {
				t.Errorf("%s does not list %s", item.Key(), tool)
			}
		}
		if len(result.Tools) != len(allTools) {
			t.Errorf("%s was rendered for %d tools, want 3", item.Key(), len(result.Tools))
			continue
		}
		for index, tool := range result.Tools {
			if tool.Tool != allTools[index] || !tool.Declared || tool.Status != gate.StatusRendered {
				t.Errorf("%s %s: declared %v, status %s (%s); want rendered", item.Key(), tool.Tool, tool.Declared, tool.Status, tool.Reason)
				continue
			}
			root := skillRoots[tool.Tool] + item.Name + "/"
			want := []string{root + "SKILL.md"}
			for _, file := range item.Files {
				want = append(want, root+file.Path)
			}
			for _, path := range want {
				if !slices.Contains(tool.Files, path) {
					t.Errorf("%s %s: %s was not rendered", item.Key(), tool.Tool, path)
				}
			}
		}
	}
	for _, name := range upstreamSkills {
		if !shippedSkills[name] {
			t.Errorf("upstream skill %s is not in the library, so it never passed the gate", name)
		}
	}
}
```

RED: run both commands from the AC list. Expected: AC1 `--- FAIL` listing 20 missing names; AC4 `--- FAIL` with "is not in the library" and, for the 4 multi-file skills, "… was not rendered". Commit `test(86bcm9019): AC1 and AC4 tests`.

### T2 Render copy: supporting-file rules from client PR #22 (B ⭐)
Source: client `origin/main` `f105e27814b6efbec67059687963e722933acec2` (merge of client PR #22). Copy verbatim, changing only package names and types:
- `render.go`: `Item` gains `Files []SupportFile \`json:"files,omitempty"\`` and `ScriptsApproved bool \`json:"scriptsApproved,omitempty"\``; new `SupportFile{Path, Body, Script, Executable}` with the client's JSON tags; `maxSupportFiles = 64`, `maxSupportTotalBytes = 512 << 10`; the client's supporting-file loop in `Validate`, `validSupportPath` and `isScriptFile` (client `toolconnector/pack.go`). `Bundle` gains `Executable map[string]bool`. `FromLibrary` copies `item.Files` field by field; `ScriptsApproved` stays false (a library item is not approved).
- `shared.go`: `RenderSkillFolder` (client `toolconnector/transform.go`).
- `claudecode.go`, `codex.go`, `cursor.go`: the client's `RenderSkillFolder` loops and `Executable` returns.
- Tests first in `render_test.go`: `TestRenderSkillFolderMatchesClientPR22` (copy of client `TestRenderSkillFolderIncludesReferencesAndApprovedScript`), `TestValidateRejectsAnUnflaggedScriptLikeTheClient` (copy of client `TestClientRejectsUnflaggedScriptEvenIfServerMislabelsIt`), `TestTransformRendersSupportingFilesForEveryTool` (one skill with `references/guide.md` and an approved `scripts/check.sh`: Claude Code `.claude/skills/x/references/guide.md`, Codex and Cursor `skills/x/references/guide.md`, script marked executable in all three).
- `SOURCE.md`: commit line → `f105e27…` (merge of client PR #22 into `6e6d332`); add "Skill folders (`RenderSkillFolder`, supporting-file rules): client PR #22". Confirm `git -C ~/Leorna/leorna-client diff --stat 17f7c1b f105e27 -- toolconnector/testdata toolconnector/claudecode/testdata toolconnector/codex/testdata toolconnector/cursor/testdata` is empty (it was on 2026-10-25), so the fixture hash list stays as is.
- GREEN: `go test -count=1 ./internal/library/render`.

### T3 Gate renders folders and lists scripts (B ⭐)
Tests first in `internal/library/gate/gate_more_test.go` (recording scanner, no gitleaks):
- `TestSupportingFilesAreRenderedForEveryTool`: sample library plus `items/skill/write-tests/files/references/checklist.md`; each tool's `Files` holds the reference at the tool's skill root; status `rendered`.
- `TestScriptsAreListedForAdminApproval`: plus `files/scripts/check.sh` (`#!/bin/sh`); item passes, every tool `rendered`, `ItemResult.Scripts == []string{"scripts/check.sh"}`; an item without scripts has `Scripts == []string{}`.
Implement in `gate.go`: `ItemResult.Scripts []string \`json:"scripts"\`` (always non-nil, sorted); in `renderFor` set `packItem := render.FromLibrary(item)` and `packItem.ScriptsApproved = len(scripts) > 0` with the comment "render as an admin-approved pack version would be; the report lists the scripts that approval covers". `report.go`: one summary line per item with scripts, `Scripts needing admin approval: <item>: <paths>`. Keep `SchemaVersion` 1 (additive field).

### T4 Gate scans supporting files (B ⭐)
Tests first: `TestSupportingFilesAreSecretScanned` (recording scanner: the scan root holds `skill/write-tests/source/files/references/checklist.md` and each tool's rendered copy) and `TestSecretInASupportingFileFailsNamingIt` (gitleaks via `gitleaksForTest`; `fakeGitHubToken()` inside `files/references/checklist.md`; failure reason contains `files/references/checklist.md: secret rule`).
Implement in `scan.go` after the three source files: for each `item.Files` entry, `write(path.Join(base, "source", "files", file.Path), []byte(file.Body), origin{item: item.Key(), file: "files/" + file.Path})`.
Mutation proof (mutation-testing-discipline): drop the new loop, see `TestSupportingFilesAreSecretScanned` and `TestSecretInASupportingFileFailsNamingIt` fail, restore. Same for the `FromLibrary` files copy and `TestTransformRendersSupportingFilesForEveryTool`.
GREEN: `go test -count=1 ./internal/library/gate ./cmd/library-gate` (AC4 still fails only on missing skills).

### T5 Review record types and the adaptation view
Tests first, `internal/library/adaptation_test.go`: `TestAdaptationViewRoundTrips` (an item with a description, body, `references/a.md` and an executable `scripts/run.sh`: write then read gives equal values and the same `ImportedContentWithFilesSHA256`), `TestAdaptationViewRejectsUnsafePaths` (`../x`, `a:b`, a name that is not a slug), `TestReadCurationRejectsUnknownFields` (an extra field and two JSON values both fail).

`internal/library/adaptation.go`:

```go
package library

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// An adaptation view is the part of an item that comes from upstream, written as
// plain files so a Leorna adaptation can be recorded as a unified diff (story
// 86bcm9019): <kind>/<name>/description.txt (the description and a newline),
// body.md, executable.txt (executable supporting files, one per line, only when
// there are any) and files/<path>. Executable flags live in executable.txt, not
// in file modes, so diffs apply the same way on every OS.

// WriteAdaptationView writes the view of description, body and files under dir.
func WriteAdaptationView(dir string, kind pack.Kind, name, description, body string, files []SupportFile) error {
	if !kind.Valid() || !slugPattern.MatchString(name) {
		return fmt.Errorf("adaptation view: %s/%s is not a valid item: %w", kind, name, ErrInvalid)
	}
	root := filepath.Join(dir, string(kind), name)
	write := func(rel, text string) error {
		full := filepath.Join(root, filepath.FromSlash(rel))
		if err := os.MkdirAll(filepath.Dir(full), 0o755); err != nil {
			return err
		}
		return os.WriteFile(full, []byte(text), 0o644)
	}
	if err := write("description.txt", description+"\n"); err != nil {
		return err
	}
	if err := write("body.md", body); err != nil {
		return err
	}
	var executable []string
	for _, file := range files {
		// GO-PATH-001: only validated relative paths reach the file system.
		if !pack.ValidSupportPath(file.Path) {
			return fmt.Errorf("adaptation view: %q is not a safe relative path: %w", file.Path, ErrInvalid)
		}
		if err := write("files/"+file.Path, file.Body); err != nil {
			return err
		}
		if file.Executable {
			executable = append(executable, file.Path)
		}
	}
	if len(executable) == 0 {
		return nil
	}
	sort.Strings(executable)
	return write("executable.txt", strings.Join(executable, "\n")+"\n")
}

// ReadAdaptationView reads a view back, detecting scripts the way the library
// parser does (path, shebang, extension or the executable flag).
func ReadAdaptationView(dir string, kind pack.Kind, name string) (string, string, []SupportFile, error) {
	if !kind.Valid() || !slugPattern.MatchString(name) {
		return "", "", nil, fmt.Errorf("adaptation view: %s/%s is not a valid item: %w", kind, name, ErrInvalid)
	}
	root := filepath.Join(dir, string(kind), name)
	rawDescription, err := os.ReadFile(filepath.Join(root, "description.txt"))
	if err != nil {
		return "", "", nil, err
	}
	description, ok := strings.CutSuffix(string(rawDescription), "\n")
	if !ok {
		return "", "", nil, fmt.Errorf("adaptation view: description.txt must end with a newline: %w", ErrInvalid)
	}
	body, err := os.ReadFile(filepath.Join(root, "body.md"))
	if err != nil {
		return "", "", nil, err
	}
	executable := map[string]bool{}
	switch list, err := os.ReadFile(filepath.Join(root, "executable.txt")); {
	case err == nil:
		for _, line := range strings.Split(strings.TrimSuffix(string(list), "\n"), "\n") {
			if !pack.ValidSupportPath(line) || executable[line] {
				return "", "", nil, fmt.Errorf("adaptation view: executable.txt line %q: %w", line, ErrInvalid)
			}
			executable[line] = true
		}
	case !errors.Is(err, fs.ErrNotExist):
		return "", "", nil, err
	}
	var files []SupportFile
	filesRoot := filepath.Join(root, "files")
	err = filepath.WalkDir(filesRoot, func(full string, entry fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			if full == filesRoot && errors.Is(walkErr, fs.ErrNotExist) {
				return fs.SkipDir
			}
			return walkErr
		}
		if entry.IsDir() {
			return nil
		}
		if !entry.Type().IsRegular() {
			return fmt.Errorf("adaptation view: %s is not a regular file: %w", full, ErrInvalid)
		}
		rel, err := filepath.Rel(filesRoot, full)
		if err != nil {
			return err
		}
		rel = filepath.ToSlash(rel)
		if !pack.ValidSupportPath(rel) {
			return fmt.Errorf("adaptation view: %q is not a safe relative path: %w", rel, ErrInvalid)
		}
		data, err := os.ReadFile(full)
		if err != nil {
			return err
		}
		files = append(files, SupportFile{Path: rel, Body: string(data),
			Script: pack.IsScriptFile(rel, string(data), executable[rel]), Executable: executable[rel]})
		delete(executable, rel)
		return nil
	})
	if err != nil {
		return "", "", nil, err
	}
	if len(executable) > 0 {
		return "", "", nil, fmt.Errorf("adaptation view: executable.txt names a missing file: %w", ErrInvalid)
	}
	sort.Slice(files, func(i, j int) bool { return files[i].Path < files[j].Path })
	return description, string(body), files, nil
}
```

`internal/library/curation.go`:

```go
package library

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
)

// CurationDir holds the review record of the library's skills (story 86bcm9019),
// relative to internal/library. It is not embedded and never ships.
const CurationDir = "curation"

// Curation is curation/curation.json.
type Curation struct {
	SchemaVersion int            `json:"schemaVersion"`
	Owner         string         `json:"owner"`
	ReviewMethod  string         `json:"reviewMethod"`
	Checklist     []string       `json:"checklist"`
	Skills        []SkillReview  `json:"skills"`
	Scripts       []ScriptReview `json:"scripts"`
	DemoSkills    []DemoDecision `json:"demoSkills"`
}

// SkillReview is the review of one shipped skill version.
type SkillReview struct {
	Item       string            `json:"item"`    // kind/name, e.g. skill/idea-refine
	Version    string            `json:"version"` // the shipped version this review covers
	Origin     string            `json:"origin"`  // "upstream" or "leorna"
	Owner      string            `json:"owner"`
	ReviewedOn string            `json:"reviewedOn"` // YYYY-MM-DD
	Checks     map[string]string `json:"checks"`     // checklist id: pass, adapted or n/a
	Notes      string            `json:"notes"`
	Adaptation *Adaptation       `json:"adaptation,omitempty"`
}

// Adaptation records why and how Leorna changed an imported item.
type Adaptation struct {
	Diff    string   `json:"diff"` // relative to CurationDir, e.g. diffs/skill-idea-refine.diff
	Reasons []string `json:"reasons"`
}

// ScriptReview is the security review of one script a skill bundles.
type ScriptReview struct {
	Item           string `json:"item"`           // kind/name
	Path           string `json:"path"`           // supporting-file path, e.g. scripts/idea-refine.sh
	UpstreamSHA256 string `json:"upstreamSha256"` // SHA-256 of the script as imported; empty for a Leorna script
	Reviewer       string `json:"reviewer"`
	ReviewedOn     string `json:"reviewedOn"`
	Findings       string `json:"findings"`
	Decision       string `json:"decision"` // "shipped" or "excluded"
	Reason         string `json:"reason"`
	WindowsPath    string `json:"windowsPath,omitempty"` // shipped only: the file that runs on stock Windows
}

// DemoDecision is what happened to one of the library's demo skills.
type DemoDecision struct {
	Item        string `json:"item"`                  // kind/name
	Decision    string `json:"decision"`              // "replaced" or "kept"
	Replacement string `json:"replacement,omitempty"` // kind/name of the upstream skill (replaced only)
	Reason      string `json:"reason"`
}

// ReadCuration reads one JSON value and rejects unknown fields.
func ReadCuration(path string) (Curation, error) {
	raw, err := os.ReadFile(path)
	if err != nil {
		return Curation{}, err
	}
	decoder := json.NewDecoder(bytes.NewReader(raw))
	decoder.DisallowUnknownFields()
	var record Curation
	if err := decoder.Decode(&record); err != nil {
		return Curation{}, fmt.Errorf("%s: %w", path, err)
	}
	if _, err := decoder.Token(); !errors.Is(err, io.EOF) {
		return Curation{}, fmt.Errorf("%s: more than one JSON value", path)
	}
	return record, nil
}
```

GREEN: `go test -count=1 -run 'TestAdaptationView|TestReadCuration' ./internal/library`.

### T6 AC2, AC3, AC5 tests (RED)
`internal/library/curation_test.go`:

```go
package library

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"slices"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

const curationFile = CurationDir + "/curation.json"

// checklistIDs is the review contract every skill review answers.
var checklistIDs = []string{"format", "accuracy", "safety", "scripts", "portability", "links", "tool-fit", "licence"}

var datePattern = regexp.MustCompile(`^20[0-9]{2}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$`)

func loadCuration(t *testing.T) (Library, Curation) {
	t.Helper()
	shipped, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	record, err := ReadCuration(curationFile)
	if err != nil {
		t.Fatal(err)
	}
	if record.SchemaVersion != 1 || !slices.Equal(record.Checklist, checklistIDs) {
		t.Fatalf("schemaVersion %d, checklist %v; want 1 and %v", record.SchemaVersion, record.Checklist, checklistIDs)
	}
	return shipped, record
}

func itemRef(item Item) string { return string(item.Kind) + "/" + item.Name }

// asImported returns what import took from upstream for item: the shipped
// content when Leorna has not changed it, otherwise the shipped content with
// the recorded diff applied in reverse.
func asImported(t *testing.T, item Item, diff string) (string, string, []SupportFile) {
	t.Helper()
	if diff == "" {
		return item.Description, item.Body, item.Files
	}
	dir := t.TempDir()
	if err := WriteAdaptationView(dir, item.Kind, item.Name, item.Description, item.Body, item.Files); err != nil {
		t.Fatal(err)
	}
	patch, err := filepath.Abs(filepath.Join(CurationDir, filepath.FromSlash(diff)))
	if err != nil {
		t.Fatal(err)
	}
	// An argument list, no shell (GO-INJECT-002). No user or system git config and
	// no repository above dir, so nothing but the patch decides the result.
	command := exec.Command("git", "-C", dir, "-c", "core.autocrlf=false", "apply", "--reverse", "-p1", "--whitespace=nowarn", patch)
	command.Env = []string{"PATH=" + os.Getenv("PATH"), "HOME=" + dir, "GIT_CONFIG_NOSYSTEM=1",
		"GIT_CONFIG_GLOBAL=" + os.DevNull, "GIT_CEILING_DIRECTORIES=" + filepath.Dir(dir)}
	if output, err := command.CombinedOutput(); err != nil {
		t.Fatalf("%s: %s does not apply in reverse to the shipped item: %v\n%s", itemRef(item), diff, err, output)
	}
	description, body, files, err := ReadAdaptationView(dir, item.Kind, item.Name)
	if err != nil {
		t.Fatal(err)
	}
	return description, body, files
}

func adaptationDiffs(record Curation) map[string]string {
	diffs := map[string]string{}
	for _, review := range record.Skills {
		if review.Adaptation != nil {
			diffs[review.Item] = review.Adaptation.Diff
		}
	}
	return diffs
}

func TestAC2_EveryImportedSkillIsReviewedWithOwnerAndAdaptationDiff(t *testing.T) {
	shipped, record := loadCuration(t)
	if strings.TrimSpace(record.Owner) == "" || strings.TrimSpace(record.ReviewMethod) == "" {
		t.Fatal("the record must name its owner and say how the review was done")
	}
	reviews := map[string]SkillReview{}
	for _, review := range record.Skills {
		if _, duplicate := reviews[review.Item]; duplicate {
			t.Fatalf("%s is reviewed twice", review.Item)
		}
		reviews[review.Item] = review
	}
	referenced := map[string]bool{}
	for _, item := range shipped.Items {
		if item.Kind != pack.KindSkill {
			continue
		}
		review, ok := reviews[itemRef(item)]
		if !ok {
			t.Errorf("%s has no review", item.Key())
			continue
		}
		delete(reviews, itemRef(item))
		if review.Version != item.Version {
			t.Errorf("%s: the review covers version %s; review the shipped version", item.Key(), review.Version)
		}
		if strings.TrimSpace(review.Owner) == "" || !datePattern.MatchString(review.ReviewedOn) || strings.TrimSpace(review.Notes) == "" {
			t.Errorf("%s: owner, reviewedOn (YYYY-MM-DD) and notes are required", item.Key())
		}
		adaptedChecks := 0
		for _, id := range checklistIDs {
			switch review.Checks[id] {
			case "pass", "n/a":
			case "adapted":
				adaptedChecks++
			default:
				t.Errorf("%s: check %q is %q, want pass, adapted or n/a", item.Key(), id, review.Checks[id])
			}
		}
		if len(review.Checks) != len(checklistIDs) {
			t.Errorf("%s: answers %d checks, the checklist has %d", item.Key(), len(review.Checks), len(checklistIDs))
		}
		if item.Source == nil {
			if review.Origin != "leorna" || review.Adaptation != nil || adaptedChecks != 0 {
				t.Errorf("%s: a Leorna-authored skill has origin leorna and no adaptation", item.Key())
			}
			continue
		}
		if review.Origin != "upstream" {
			t.Errorf("%s: origin %q, want upstream", item.Key(), review.Origin)
		}
		if item.Adapted() != (review.Adaptation != nil) || item.Adapted() != (adaptedChecks > 0) {
			t.Errorf("%s: Adapted() is %v; the review must record an adaptation and adapted checks exactly when it is", item.Key(), item.Adapted())
			continue
		}
		if review.Adaptation == nil {
			continue
		}
		wantDiff := "diffs/" + string(item.Kind) + "-" + item.Name + ".diff"
		if review.Adaptation.Diff != wantDiff || len(review.Adaptation.Reasons) == 0 {
			t.Errorf("%s: adaptation diff %q, want %q, with at least one reason", item.Key(), review.Adaptation.Diff, wantDiff)
			continue
		}
		referenced[wantDiff] = true
		description, body, files := asImported(t, item, review.Adaptation.Diff)
		if got := ImportedContentWithFilesSHA256(description, body, files); got != item.Source.UpstreamSHA256 {
			t.Errorf("%s: undoing %s does not give the content taken from upstream (fingerprint %s, recorded %s)",
				item.Key(), review.Adaptation.Diff, got, item.Source.UpstreamSHA256)
		}
	}
	for ref := range reviews {
		t.Errorf("%s is reviewed but not shipped", ref)
	}
	entries, err := os.ReadDir(filepath.Join(CurationDir, "diffs"))
	if err != nil && !errors.Is(err, fs.ErrNotExist) {
		t.Fatal(err)
	}
	for _, entry := range entries {
		if !referenced["diffs/"+entry.Name()] {
			t.Errorf("diffs/%s belongs to no adapted skill", entry.Name())
		}
	}
}

func TestAC3_BundledScriptsAreSecurityReviewedAndWindowsSafeOrExcluded(t *testing.T) {
	shipped, record := loadCuration(t)
	type key struct{ item, path string }
	reviews := map[key]ScriptReview{}
	for _, review := range record.Scripts {
		k := key{review.Item, review.Path}
		if _, duplicate := reviews[k]; duplicate {
			t.Fatalf("%s %s is reviewed twice", review.Item, review.Path)
		}
		reviews[k] = review
	}
	diffs := adaptationDiffs(record)
	windowsExtensions := []string{".ps1", ".cmd", ".bat", ".py"}
	for _, item := range shipped.Items {
		if item.Kind != pack.KindSkill {
			continue
		}
		current := map[string]SupportFile{}
		for _, file := range item.Files {
			current[file.Path] = file
		}
		upstreamScripts := map[string]SupportFile{}
		if item.Source != nil {
			_, _, files := asImported(t, item, diffs[itemRef(item)])
			for _, file := range files {
				if file.Script {
					upstreamScripts[file.Path] = file
				}
			}
		}
		bundled := map[string]bool{}
		for path := range upstreamScripts {
			bundled[path] = true
		}
		for _, file := range item.Files {
			if file.Script {
				bundled[file.Path] = true
			}
		}
		for path := range bundled {
			review, ok := reviews[key{itemRef(item), path}]
			if !ok {
				t.Errorf("%s bundles %s with no security review", item.Key(), path)
				continue
			}
			delete(reviews, key{itemRef(item), path})
			if strings.TrimSpace(review.Reviewer) == "" || !datePattern.MatchString(review.ReviewedOn) || strings.TrimSpace(review.Findings) == "" {
				t.Errorf("%s %s: reviewer, reviewedOn and findings are required", item.Key(), path)
			}
			if original, fromUpstream := upstreamScripts[path]; fromUpstream {
				sum := sha256.Sum256([]byte(original.Body))
				if review.UpstreamSHA256 != hex.EncodeToString(sum[:]) {
					t.Errorf("%s %s: the review names upstream SHA-256 %s, the imported script is %x", item.Key(), path, review.UpstreamSHA256, sum)
				}
			}
			_, shippedNow := current[path]
			switch review.Decision {
			case "excluded":
				if shippedNow || strings.TrimSpace(review.Reason) == "" {
					t.Errorf("%s %s: an excluded script is not shipped and has a reason", item.Key(), path)
				}
				for _, text := range append([]string{item.Body}, bodiesOf(item.Files)...) {
					if strings.Contains(text, path) {
						t.Errorf("%s still tells readers to use the excluded %s", item.Key(), path)
					}
				}
			case "shipped":
				windows, ok := current[review.WindowsPath]
				if !shippedNow || !ok || !slices.ContainsFunc(windowsExtensions, func(ext string) bool { return strings.HasSuffix(review.WindowsPath, ext) }) {
					t.Errorf("%s %s: a shipped script needs a shipped Windows path (.ps1, .cmd, .bat or .py), got %q", item.Key(), path, review.WindowsPath)
				} else if _, reviewed := reviews[key{itemRef(item), windows.Path}]; !reviewed && !bundled[windows.Path] {
					t.Errorf("%s: the Windows path %s has no security review", item.Key(), windows.Path)
				}
			default:
				t.Errorf("%s %s: decision %q, want shipped or excluded", item.Key(), path, review.Decision)
			}
		}
	}
	for k := range reviews {
		t.Errorf("%s %s is reviewed but no shipped skill bundles it", k.item, k.path)
	}
}

func bodiesOf(files []SupportFile) []string {
	out := make([]string, 0, len(files))
	for _, file := range files {
		out = append(out, file.Body)
	}
	return out
}

func TestAC5_EachDemoSkillIsReplacedByAnUpstreamSkillOrKeptAsLeornaAuthored(t *testing.T) {
	shipped, record := loadCuration(t)
	// The three skills the library shipped before this story with no upstream source.
	demo := []string{"skill/code-review-checklist", "skill/commit-message-style", "skill/incident-postmortem"}
	items := map[string]Item{}
	for _, item := range shipped.Items {
		items[itemRef(item)] = item
	}
	reviewed := map[string]bool{}
	for _, review := range record.Skills {
		reviewed[review.Item] = true
	}
	decisions := map[string]DemoDecision{}
	for _, decision := range record.DemoSkills {
		if _, duplicate := decisions[decision.Item]; duplicate || !slices.Contains(demo, decision.Item) {
			t.Fatalf("demoSkills entry %s is repeated or not a demo skill", decision.Item)
		}
		decisions[decision.Item] = decision
	}
	lock, err := ReadLock(lockFile)
	if err != nil {
		t.Fatal(err)
	}
	for _, ref := range demo {
		decision, ok := decisions[ref]
		if !ok || strings.TrimSpace(decision.Reason) == "" {
			t.Errorf("%s has no decision with a reason", ref)
			continue
		}
		published := false
		for key := range lock {
			published = published || strings.HasPrefix(key, ref+"@")
		}
		if !published {
			t.Errorf("%s: its published versions must stay in %s", ref, lockFile)
		}
		switch decision.Decision {
		case "replaced":
			if _, still := items[ref]; still {
				t.Errorf("%s is replaced but still ships", ref)
			}
			replacement, ok := items[decision.Replacement]
			if !ok || replacement.Kind != pack.KindSkill || replacement.Source == nil || replacement.Source.Upstream != "agent-skills" {
				t.Errorf("%s: replacement %q is not a shipped agent-skills skill", ref, decision.Replacement)
			}
		case "kept":
			item, ok := items[ref]
			if !ok || item.Source != nil || !reviewed[ref] {
				t.Errorf("%s: a kept demo skill ships as Leorna-authored (no source) and is reviewed", ref)
			}
		default:
			t.Errorf("%s: decision %q, want replaced or kept", ref, decision.Decision)
		}
	}
}
```

RED: the three AC commands fail with `curation/curation.json: no such file`. Commit `test(86bcm9019): AC2, AC3 and AC5 tests`.

### T7 `library-upstream adaptation`
Tests first in `cmd/library-upstream/main_test.go` with the existing local fixture repo:
- `TestAdaptationDiffUndoesToTheUpstreamContent`: import a fixture skill, change its `body.md` and description (bump the version, re-record the lock the way T9 does), run `run([]string{"adaptation", "--library", lib, "--from", repo, "--item", "skill/<name>"}, &out, &errOut)`; output starts with `diff --git a/skill/<name>/`; write the current view to a temp dir, `git apply --reverse -p1` the output (same env as `asImported` above), read the view back: fingerprint equals `Source.UpstreamSHA256`.
- `TestAdaptationRefuses`: an unadapted item ("has no Leorna adaptation"), a Leorna item ("has no upstream source"), a wrong `upstreamSha256` ("does not match the recorded upstreamSha256"), an unknown item; each returns an error and prints nothing on stdout.

Implement:
- `internal/library/upstream/importer.go`: move the steps of `Import` from `repo.Resolve` through `readSupportingFiles` into `func asImported(ctx context.Context, repo *Repo, revision, rootPath string) (pack.Kind, string, Imported, []library.SupportFile, error)` (returns kind, resolved commit, imported, support) and call it from `Import`. No behaviour change: the existing import tests stay green.
- `internal/library/upstream/adaptation.go`: `func AdaptationDiff(ctx context.Context, repo *Repo, item library.Item) ([]byte, error)`: refuse `item.Source == nil` and `!item.Adapted()`; `asImported(ctx, repo, item.Source.Commit, item.Source.Path)`; refuse unless `library.ImportedContentWithFilesSHA256(...) == item.Source.UpstreamSHA256`; `os.MkdirTemp`, `library.WriteAdaptationView` into `<tmp>/a` (upstream) and `<tmp>/b` (shipped); then `gitCommand(ctx, tmp, "-c", "core.quotePath=false", "diff", "--no-index", "--no-color", "--no-ext-diff", "--no-textconv", "--no-renames", "--no-prefix", "--diff-algorithm=myers", "--unified=3", "--", "a", "b")` with `GIT_CONFIG_GLOBAL=` + `os.DevNull` and `GIT_CEILING_DIRECTORIES=` + parent of tmp appended to its env; exit status 1 with output is the diff, 0 is an error ("no difference"), anything else is an error with git's first 4 KiB of stderr. Remove the temp dir on every path.
- `cmd/library-upstream/main.go`: `case "adaptation"`; flags `--item kind/name` plus the common ones; the upstream is `item.Source.Upstream`; usage text line `adaptation  print an item's Leorna adaptation as a diff against upstream\n           --item kind/name`; update `TestUsageErrors` if it pins the usage text.
GREEN: `go test -count=1 ./internal/library/upstream ./cmd/library-upstream`.

### T8 Import the 20 skills
For each row: write `$S/examples/<name>.md` (the example, one line, newline-terminated), then from the worktree root:
`go run ./cmd/library-upstream import --from $S/agent-skills.git --path skills/<name> --category <category> --tags <tags> --tools claude-code,codex,cursor --example $S/examples/<name>.md`

| Skill | Category | Tags | example.md |
| --- | --- | --- | --- |
| spec-driven-development | planning | specs,requirements | Ask the assistant to write a short spec for a new feature (objective, scope, acceptance criteria) before any code is written. |
| planning-and-task-breakdown | planning | planning,tasks | Ask the assistant to break an approved spec into small, ordered tasks, each with its own acceptance check. |
| incremental-implementation | engineering | implementation,small-changes | Ask the assistant to build the next task from the plan as one thin, tested slice and stop for review. |
| test-driven-development | testing | tdd,tests | Ask the assistant to fix a bug test-first: a failing test that reproduces it, then the smallest fix. |
| code-review-and-quality | code-quality | code-review,pull-requests | Ask: "Review my open pull request for correctness, readability, architecture, security and performance." |
| code-simplification | code-quality | refactoring,simplicity | Ask the assistant to simplify a hard-to-read function without changing what it does, keeping the tests green. |
| api-and-interface-design | architecture | api,interfaces | Ask the assistant to design the endpoints and error responses for a new resource before implementing them. |
| frontend-ui-engineering | frontend | ui,accessibility | Ask the assistant to build a responsive, accessible form component that matches the existing design system. |
| browser-testing-with-devtools | testing | browser,devtools | Ask the assistant to open the page through the Chrome DevTools MCP server, reproduce the console error and verify the fix. |
| observability-and-instrumentation | operations | observability,logging | Ask the assistant to add structured logs, a metric and an alert for a new background job. |
| ci-cd-and-automation | operations | ci-cd,automation | Ask the assistant to add a CI pipeline that runs lint, type checks and tests on every pull request. |
| git-workflow-and-versioning | workflow | git,commits | Ask the assistant to split a messy working tree into small commits with clear conventional messages. |
| documentation-and-adrs | documentation | docs,adr | Ask the assistant to record the decision to switch databases as an ADR with context, options and consequences. |
| deprecation-and-migration | engineering | deprecation,migration | Ask the assistant to plan how to retire an old API version and move its callers to the new one. |
| shipping-and-launch | operations | release,launch | Ask the assistant for a pre-launch checklist for a feature going to production next week. |
| context-engineering | ai-agents | context,agents | Ask the assistant to set up the project's rules file so new sessions start with the right context. |
| source-driven-development | engineering | documentation,verification | Ask the assistant to check the framework's official docs before choosing how to build a feature, and to cite them. |
| doubt-driven-development | code-quality | verification,review | Ask the assistant to have a fresh-context reviewer challenge your plan before you commit to it. |
| interview-me | productivity | requirements,interviews | Ask the assistant to interview you one question at a time until it understands what you actually need. |
| using-agent-skills | ai-agents | skills,agents | Ask the assistant which skill fits the task you are about to start, then follow it. |

Each import validates the whole library, writes the item and adds one lock line. Then set `content/library.json` `"version": "0.5.0"`. GREEN: AC1 passes. Also run `go test -count=1 ./internal/library` (lock, preview of every shipped item, links). Commit per few skills or all at once (`feat(86bcm9019): import the 20 remaining agent-skills skills`).

### T9 Adapt browser-testing-with-devtools (C ⭐)
In `items/skill/browser-testing-with-devtools/body.md`, insert this paragraph after the paragraph that starts `` `-y` skips the npx install confirmation. `` and before the one that starts `There is also`:

```
**In a company install:** `-y` with `@latest` downloads and runs whatever version was published most recently, without review. Pin a version your team has reviewed (`chrome-devtools-mcp@<version>`), and add the server through the MCP template your admin approved rather than editing `.mcp.json` by hand.
```

Version stays 1.0.0 (never shipped). Re-record its lock line: delete only the `skill/browser-testing-with-devtools@1.0.0` line (not on `origin/main`), run `go test ./internal/library -run TestContentLock -update-lock`. Then `go run ./cmd/library-upstream adaptation --from $S/agent-skills.git --item skill/browser-testing-with-devtools > internal/library/curation/diffs/skill-browser-testing-with-devtools.diff`.

### T10 idea-refine 1.1.0: script excluded (A ⭐)
- `git rm internal/library/content/items/skill/idea-refine/files/scripts/idea-refine.sh`.
- `body.md`: replace the block

  ````
  ```bash
  # Optional: from the project root, initialize the ideas directory.
  # Replace the placeholder with the absolute path to this installed skill folder.
  bash <installed-idea-refine-folder>/scripts/idea-refine.sh
  ```
  ````
  with the one line `Before saving the one-pager, create the \`docs/ideas/\` folder in the project root if it does not exist yet. Use your own file tools; no script is needed, so this works the same on Windows, macOS and Linux.`
- `item.json`: `"version": "1.1.0"`, remove `executableFiles`, remove the script from `managedFiles` (the other three hashes stay). `source` unchanged.
- `go test ./internal/library -run TestContentLock -update-lock` adds `skill/idea-refine@1.1.0` (1.0.1 stays).
- `go run ./cmd/library-upstream adaptation --from $S/agent-skills.git --item skill/idea-refine > internal/library/curation/diffs/skill-idea-refine.diff`.
- Script security review (goes into `curation.json` → `scripts`): `#!/bin/bash`, `set -e`, constant `IDEAS_DIR="docs/ideas"`, `mkdir -p` relative to the current directory, prints a JSON status line; no input, network, eval or privileged call; low risk. Needs `bash`, which stock Windows lacks (Codex and Cursor default to PowerShell there). Decision `excluded`, reason: "Convenience only (one folder create) that needs bash; the agent creates docs/ideas with its own file tools on every OS, and the skill no longer needs script approval." `upstreamSha256` `f02a52408a4218047c032d221483abfbb48d11f090bb4915965c7419bf2e0e47`.

### T11 Demo skills (D ⭐, F ⭐)
- `git rm -r internal/library/content/items/skill/code-review-checklist internal/library/content/items/skill/commit-message-style` (lock lines stay; `internal/pack/seed.json` untouched).
- `incident-postmortem` 1.1.0: `item.json` version `1.1.0`, description:
  `Guides a blameless postmortem after a production incident. Use when an outage, degraded service, data loss or security event has been resolved and the team needs a written record of what happened, why the system allowed it and what will change. Use when turning alerts, logs, chat and notes into a postmortem with owned action items.`
  `body.md` (complete text):

  ````markdown
  # Incident Postmortem

  ## Overview

  A postmortem turns an incident into lasting fixes. It records what happened, why the system allowed it and what will change, with an owner for every change. It is blameless: it examines systems, signals and decisions, never a person's character. People acted on what they knew at the time; the question is why the system made the wrong action easy or the right one hard.

  ## When to Use

  - An outage, degraded service, data loss or corruption, or a security event has been resolved or mitigated
  - A near miss that could have caused one of those
  - Someone asks you to write up an incident from notes, chat logs, alerts or a timeline

  **When NOT to use:** while the incident is still active (stabilise first), or for a routine bug with no user impact (write a bug report).

  ## Process

  ### 1. Gather the facts first

  Collect alerts, dashboards, logs, deploy history, chat and ticket timestamps. Convert every time to UTC. Mark anything you infer as an assumption. Do not name a root cause before the timeline is complete.

  ### 2. Write the timeline

  One line per event, in UTC: detection, escalation, each mitigation attempt, recovery, all-clear. Note how the incident was detected (alert, customer, engineer) and how long each phase took: time to detect, to mitigate, to resolve.

  ### 3. State the impact

  Who was affected, for how long and how badly: users or tenants, failed requests or jobs, data affected, money or SLA impact, security exposure. Use numbers from the evidence and say where each estimate comes from.

  ### 4. Find the root cause and contributing factors

  Ask "why" until you reach a cause in the system: a missing check, an unsafe default, a gap in tests, alerts or runbooks. "Human error" is never a root cause; ask why the system let the error through. List contributing factors (what made it worse or slower to fix) separately.

  ### 5. Record what went well and what did not

  Keep what worked (fast detection, a good runbook, a clean rollback) so it is repeated, and what slowed the response.

  ### 6. Agree action items

  Each action item has one owner, a due date and a ticket. Cover three kinds: prevent (stop it happening again), detect (find it sooner) and mitigate (limit the damage next time). A few concrete fixes beat many vague ones.

  ### 7. Review and share

  Have someone who was not involved read the draft for blame and gaps. Share it with the teams involved and track the action items to completion.

  ## Template

  ```markdown
  # Postmortem: <title> (<date, UTC>)

  ## Summary
  <two or three sentences: what happened, the impact, current status>

  ## Impact
  <who, how many, how long, data or security impact, with sources>

  ## Timeline (UTC)
  | Time | Event |
  |------|-------|

  ## Detection
  <how we found out; time to detect>

  ## Root cause
  <the system cause, found by asking why>

  ## Contributing factors

  ## What went well

  ## What went badly

  ## Action items
  | Action | Type (prevent / detect / mitigate) | Owner | Due | Ticket |
  |--------|------------------------------------|-------|-----|--------|

  ## Lessons learned
  ```

  ## Red Flags

  - Names or blame in the story ("X forgot to…") instead of system causes
  - "Human error" or "be more careful" as the root cause or as an action item
  - Action items without an owner, a due date or a ticket
  - Times without a time zone, or a timeline built from memory instead of evidence
  - Impact stated without numbers or a source

  ## Verification

  - [ ] The timeline is in UTC and every entry is backed by evidence
  - [ ] Impact has numbers and their sources
  - [ ] The root cause is a system cause; contributing factors are listed separately
  - [ ] Every action item has an owner, a due date and a ticket
  - [ ] No blame language; someone not involved has reviewed it
  ````
  `example.md` unchanged. Record the version: `go test ./internal/library -run TestContentLock -update-lock` (adds `skill/incident-postmortem@1.1.0`; 1.0.0 stays).

### T12 Review all 26 skills and write `curation.json`
Read every shipped skill in full (body and supporting files) and answer the checklist for each:

| id | Passes when |
| --- | --- |
| format | `name` matches the folder; the description says what it does and when to use it; description ≤ 1024 characters (the Agent Skills limit) |
| accuracy | advice is technically sound and current; nothing wrong or out of date found |
| safety | no instruction to run unpinned or unreviewed remote code, exfiltrate data, disable safeguards or paste secrets; no `` !`cmd` `` dynamic context, hooks or `allowed-tools` |
| scripts | every bundled script reviewed under AC3, or `n/a` when none |
| portability | nothing requires bash or a single OS to work; OS-specific examples are optional |
| links | every relative link resolves inside the installed skill folder; sibling skills it names ship in the library |
| tool-fit | renders and passes the gate for Claude Code, Codex and Cursor; no single-tool syntax that breaks the others |
| licence | upstream MIT record covers it, or it is Leorna-authored |

Value per check: `pass`, `adapted` (passes because of the recorded adaptation) or `n/a`. Notes: 1–3 plain sentences per skill. Anything else found (a real defect that isn't an adaptation trigger under H ⭐) goes into the notes and the report's found_else, not into the content.

File shape (one entry per shipped skill, sorted by `item`; 2-space JSON, newline at end):

```json
{
  "schemaVersion": 1,
  "owner": "Justin Issa",
  "reviewMethod": "Checklist review by the Claude Code builder agent for the owner (story 86bcm9019). The owner signs off by approving the pull request; an agent review is not a human approval.",
  "checklist": ["format", "accuracy", "safety", "scripts", "portability", "links", "tool-fit", "licence"],
  "skills": [
    {
      "item": "skill/idea-refine",
      "version": "1.1.0",
      "origin": "upstream",
      "owner": "Justin Issa",
      "reviewedOn": "2026-10-2x",
      "checks": {"format": "pass", "accuracy": "pass", "safety": "pass", "scripts": "adapted", "portability": "adapted", "links": "pass", "tool-fit": "pass", "licence": "pass"},
      "notes": "…",
      "adaptation": {"diff": "diffs/skill-idea-refine.diff", "reasons": ["The bundled bash script is excluded (see scripts); the body tells the agent to create docs/ideas itself, on any OS."]}
    }
  ],
  "scripts": [
    {"item": "skill/idea-refine", "path": "scripts/idea-refine.sh", "upstreamSha256": "f02a52408a4218047c032d221483abfbb48d11f090bb4915965c7419bf2e0e47", "reviewer": "Claude Code builder agent for Justin Issa", "reviewedOn": "2026-10-2x", "findings": "…", "decision": "excluded", "reason": "…"}
  ],
  "demoSkills": [
    {"item": "skill/code-review-checklist", "decision": "replaced", "replacement": "skill/code-review-and-quality", "reason": "The upstream skill covers every point of the 6-line checklist (scope, tests, security boundaries) and adds readability, architecture and performance."},
    {"item": "skill/commit-message-style", "decision": "replaced", "replacement": "skill/git-workflow-and-versioning", "reason": "The upstream skill covers conventional commit types and atomic commits; the demo's Leorna-internal rules (ClickUp IDs) don't belong in customers' libraries."},
    {"item": "skill/incident-postmortem", "decision": "kept", "reason": "No upstream skill covers postmortems; kept as Leorna-authored and expanded to a full skill in 1.1.0."}
  ]
}
```

browser-testing-with-devtools: `safety` `adapted`, reason "Unpinned `npx -y …@latest` runs unreviewed code; added a pin-a-reviewed-version note." incident-postmortem: `origin` `leorna`, no adaptation. GREEN: AC2, AC3, AC5 pass. Mutation proof: corrupt one changed line inside `skill-idea-refine.diff` → AC2 fails; add `scripts/idea-refine.sh` mention back to idea-refine's body → AC3 fails; drop the `incident-postmortem` review → AC5 fails; restore each.

### T13 Links test covers every skill
`internal/library/multifile_test.go`: in `TestShippedMultiFileSkillReferenceLinksHaveTargets`, check every shipped skill, not only the four named ones (keep the four as the minimum `want` set). GREEN: `go test -count=1 -run TestShippedMultiFileSkillReferenceLinksHaveTargets ./internal/library`.

### T14 Evidence capture (named task; see the table below)
Capture each artifact as its check runs, on the final head.
- Add `TestEvidenceSampledSkillsForManualCheck` to `cmd/library-gate/skills_test.go`: skips unless `LEORNA_EVIDENCE_DIR` is set; renders `code-review-and-quality`, `test-driven-development` and `security-and-hardening` as one pack per tool with `render.Transform` and writes the files under `$LEORNA_EVIDENCE_DIR/ac6-install/<tool>/` (0644; 0755 for `Executable`). Run it once with the evidence folder.
- Write `ac6-checklist.md` in the evidence folder: per tool, where to copy the folder, the prompt to try, what to look for, how to remove it (G ⭐):
  - Claude Code: copy `ac6-install/claude-code/.claude` into a new empty folder, `cd` there, run `claude`, ask "Which skills do you have?" then "Use code-review-and-quality to review this file: <any small file>".
  - Codex: copy `ac6-install/codex/skills/*` into `~/.codex/skills/` (your real Codex home; you do it or OK an agent to), run `codex`, ask it to use test-driven-development on a tiny function.
  - Cursor: copy `ac6-install/cursor/skills/*` into `~/.cursor/skills/`, open Cursor, ask the agent to use security-and-hardening on an input handler and check it opens `references/hardening-patterns.md`.
  - Afterwards delete exactly the three copied folders in each place.

### T15 Gates (see Gates)

### T16 Docs & records (last task; see the section at the end)

## Evidence per AC

Folder `~/.hermes/plans/leorna/evidence/86bcm9019/`. Terminal captures follow the `leorna` skill's recipe (dedicated Terminal window by id, `env -i`, `TERM`, argv, `make -s`, no DB URL or password on screen). HTML and Markdown renderings are labelled "local rendering". Nothing leaves the Mac until Justin says "post".

| AC | What it shows | Capture point | Artifact |
| --- | --- | --- | --- |
| AC1 | The admin "Third-party content" page lists all 25 skills with upstream path, full commit, MIT licence and "changed by Leorna" | after T12: `LEORNA_EVIDENCE_DIR=<dir> go test -count=1 -run '^TestEvidenceThirdPartyContentPage$' ./internal/web` (needs the test DB), then headless Chrome with a throwaway profile | `ac1-third-party-content.png` (+ `ac1-test-<sha7>.png` terminal run) |
| AC2 | AC2 test passing, the owner and result per skill, the head of the idea-refine diff | final head: the AC2 command, `jq -r '.skills[]|[.item,.version,.owner,(.adaptation!=null)]|@tsv' internal/library/curation/curation.json`, `head -30 internal/library/curation/diffs/skill-idea-refine.diff` | `ac2-review-record.png` |
| AC3 | AC3 test passing, the script review, idea-refine's files without the script | final head: the AC3 command, `jq '.scripts' …/curation.json`, `ls -R internal/library/content/items/skill/idea-refine/files` | `ac3-script-review.png` |
| AC4 | The gate's per-item compatibility table with all skills rendered for the three tools | final head: `make -s library-check LIBRARY_SUMMARY=<dir>/library-summary-<sha7>.md LIBRARY_REPORT=<dir>/library-report-<sha7>.json`, rendered offline (goldmark + headless Chrome) | `ac4-gate-summary.png` (+ `ac4-test-<sha7>.png` terminal run of the AC4 command) |
| AC5 | AC5 test passing, the demo decisions, the skill folder list | final head: the AC5 command, `jq '.demoSkills' …/curation.json`, `ls internal/library/content/items/skill` | `ac5-demo-skills.png` |
| AC6 | Each tool lists and follows the sampled skills | Justin, after the reviews and verification | `ac6-claude-code.png`, `ac6-codex.png`, `ac6-cursor.png` (prepared: `ac6-install/`, `ac6-checklist.md`) |
| gates | every gate on the final head | T15 | `gates-<sha7>.txt` + `gates-<sha7>.png` |

Before-state: `before-library-5778350.png` (T0).

## Gates (control plane only; the client is untouched)

On the exact head, with the T0 PATH (scratch bin first, then gnubin, then `/opt/homebrew/bin`) and absolute tool paths:
1. `GOLANGCI_LINT=$S/bin/golangci-lint GOVULNCHECK=$S/bin/govulncheck GITLEAKS=<gitleaks 8.30.1> LEORNA_TEST_GITLEAKS_BIN=<same> LEORNA_TEST_DATABASE_URL=<owned _test DB> make check` (workspace, contracts-check, fmt, vet, race tests, lint 2.14.0, govulncheck v1.7.0, gitleaks, library-check, build). Confirm the Postgres tests ran (a separate `go test -v -count=1 -run 'TestEnsureLibraryWithPostgres|TestLibraryShowsTheShippedLibraryWithPostgres' ./internal/store/postgres ./internal/web` shows PASS, not SKIP).
2. `bash ./scripts/test-module-add.sh`.
3. The six AC commands (AC4 with `LEORNA_TEST_GITLEAKS_BIN`), verbose, each log `HEAD=`…`EXIT=`.
4. `go run ./cmd/library-upstream notices` equals the `THIRD_PARTY_NOTICES.md` Content library block (unchanged file).
5. `git diff origin/main -- internal/library/content.lock.json | grep -E '^-[^-]'` prints nothing (published lock lines never change).
6. `git diff --name-only origin/main...HEAD -- .github` prints nothing (no CI change).
7. `git log --format='%an <%ae>' origin/main..HEAD | sort -u` is only `Justin Issa <justin@leorna.com>`.
Keep a failed run's log next to the passing rerun; read each log's `EXIT=` before citing it.

## Risks

- **Review volume:** 26 skills, about 380 KB of text. Budget the review (T12) as its own slice; notes stay short.
- **gitleaks false positives** in imported text would fail the gate and could only be fixed by an adaptation. Pre-checked: 0 findings at the pin with 8.30.1 default rules.
- **Lock immutability:** re-recording is allowed only for lock lines this branch added (gate 5 catches a slip).
- **git differences:** user or system git config could change `diff`/`apply` output; both run with no global or system config and a ceiling directory.
- **Existing installs keep the two replaced demo skills** in their catalog (the loader never deletes). Pilot-only today; follow-up for a "retired" flag.
- **Render copy drift:** T2 copies client code by hand; the parity tests and the copied client tests guard it.
- **Catalog preview has no size bound** (known, found-else 2026-10-23). Upstream tables are well formed and `TestPreviewOfEveryShippedItem` renders every shipped item.
- **Sibling 86bcm901b** would conflict on `library.json`, `content.lock.json` and the README if built at the same time; build this one first.
- **AC6 needs Justin's tool homes** (`~/.codex/skills`, `~/.cursor/skills`) for a short time; he copies and removes the folders, or OKs an agent to.
- **CI run:** the card's "quality-gate CI run" happens only after "make a PR"; the CI job summary screenshot is a hand-over item.

## Docs & records (T16, the last task)

- `~/.hermes/plans/leorna/86bcm9019-curate-skills.md`: this plan (with Justin's answers once given); the approved read-only copy `evidence/86bcm9019/plan-approved.md` (the orchestrator makes it at "go").
- `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`: dated status lines (plan, go, build, reviews, hand-over, PR, merge).
- `internal/library/README.md` (module README note): library **0.5.0** (25 agent-skills skills, 2 demo skills replaced, incident-postmortem 1.1.0 Leorna-authored); fix the sentence "its nine items are also the first library items" (the seed still installs the two replaced skills until 86bcm901r); gate section: supporting files are rendered and secret-scanned, scripts listed for admin approval, client PR #22 in the renderer copy; upstream section: the `adaptation` subcommand; new section "Curated skills (86bcm9019)": the review record, the checklist, the adaptation rule (H ⭐), how to re-review after `accept`, and the new tests in Verification.
- `adr/0003-curating-upstream-skills.md` (new, ADR 0002 format): verbatim by default; adapt only for broken paths, security or script decisions; every adaptation recorded as a diff that undoes to upstream; one review per shipped version.
- `internal/library/render/testdata/client/SOURCE.md`: client commit `f105e27` and PR #22 rules.
- `.gitattributes`: `internal/library/curation/** text eol=lf`.
- `delivery/stories.json`: append `"86bcm9019": {"name": "Curate the skills collection", "prs": {"LeornaAI/leorna-control-plane": []}}` as the last entry (`json.dumps(data, indent=2)` + newline); the PR number goes in after "make a PR".
- `THIRD_PARTY_NOTICES.md`: **not changed** (gate 4 proves the notice is current).
- No OpenAPI (`contracts/`), migration or `.github/` change.
- `~/.hermes/plans/leorna/found-else.md`: append this story's "Other things found" (main session).
- Hand-over files in `evidence/86bcm9019/handover/`: PR text (plain style), review prompt, team message, ClickUp evidence comment draft and attachment list (posted only on "post").

## Other things found (not in scope; for found-else)

- **Medium, delivery records:** `delivery/stories.json` on `origin/main` `5778350` has no `86bcm945u` entry, `86bcm901u` lists no PR and `86bcm9016` lists none in either repo, although PRs #89, #90, #85 and client #20 are merged. The local commits `f85b6fd` (945u) and `b13b922` (901u) were never pushed. `check-story-shippable.py` passes vacuously on an empty list (found-else 2026-10-24), so these stories can be marked shipped with no PR recorded.
- **Low, importer vs parser:** the importer flags a supporting file as a script only by `scripts/`, a shebang or mode 100755 (`internal/library/upstream/importer.go:147`); the parser's `pack.IsScriptFile` also counts `.sh`, `.ps1`, `.py`, `.bat`, `.cmd` (`internal/pack/pack.go:254`). An upstream `tool.py` outside `scripts/` with no shebang would import with `script: false`, then parse with `script: true`, so the item reads as adapted right after import. None of the 25 skills hits it.
- **Low, stale note:** shared notes (2026-10-24) say 901u PR #90 is open with an unpushed stories.json commit; #90 merged 2026-10-24 22:44 UTC without it.
- **Info:** the gate's render copy is pinned at client `17f7c1b`, before client PR #22; any multi-file item merged since (945q's four skills) shipped without its supporting files being rendered or secret-scanned by the gate (the repository-wide `gitleaks git` step does scan them). Fixed by T2–T4 if B ⭐.
