# 86bcm945u: Upstream content sync + licence attribution (plan)

Card: [Upstream content sync + licence attribution](https://app.clickup.com/t/86bcm945u) · E10 Content Library · PI-2 · p1-high · size S · assignee Justin.
Pipeline: **Full** (every role a fresh Opus 5.5 xhigh agent). Planned 2026-10-24 07:17 EDT by the Opus planner.
Status: **Approved by Justin 2026-10-24** (go). This approves the plan, every ⭐ answer below, and the proposed ACs AC6 and AC7.

## Justin's answers (2026-10-24)

- **Q1 A:** control plane, `internal/library`. **Q2 A:** import `debugging-and-error-recovery` as a pilot. **Q3 A:** port lint rules to Go later; evals reference-only. **Q4 A:** new read-only "Third-party content" page now. **Q5 A:** not in this story; follow-up card for pack/client attribution.
- **AC6 (proposed)** and **AC7 (proposed)** are approved as ACs.
- **Standing grant for this story (Justin's words, 2026-10-24):** "Look ima go and leave the house you as the orchestrator just keep it going throughout the pipline and go with the recommendation if it does not have recommendation make it create one." The orchestrator runs the Full pipeline through the finisher hand-over without waiting. At any decision, the recommended option is taken; an agent facing a decision with no recommendation proposes one, records it as "My ruling, not yet confirmed", and it is taken. The grant ends when the hand-over is delivered or Justin cancels. **Unchanged boundaries:** no push, PR, ClickUp post, server work or `.github/workflows/*` change unless Justin says so.
- Earlier instruction: "start a new branch do not continue work" → new branch `feat/86bcm945u-upstream-sync` from a freshly fetched `origin/main`; nothing earlier continued.

## Questions (a bare "go" takes every ⭐)

**Q1. Where does this work go? The card says "Repo: content", but no such repo exists.**
The content library lives in the control plane: `internal/library/content/` is embedded into the control-plane binary (`internal/library/source.go:34`, `//go:embed all:content`), loaded at startup (`cmd/control-plane/main.go:95`). Story 86bcm9018 built it there.
- A ⭐ Control plane, next to the library (`internal/library`)
- B New `content` repo (team decision; would move 9018's loader)

**Q2. Import one upstream item now, as a pilot?**
Upstream HEAD is the pin today, so with no imported item the console list and the dry run are empty. `skills/debugging-and-error-recovery` is a single file with no links to other upstream files, so it imports verbatim.
- A ⭐ Yes: import `debugging-and-error-recovery` as a pilot skill
- B No: tooling only; 86bcm9019 imports the first item
(With B: drop task T11, the "shipped library" subtest in AC2 and the pilot-row check in AC7.)

**Q3. AC4's decision: how do we reuse upstream evals and validators in our quality gate?**
- A ⭐ Port lint rules to Go later; evals reference-only
- B Run upstream Tier-2 evals in CI with Node (needs a CI story)
- C Reuse nothing from upstream evals
(The answer changes only the ADR text and one field, `"decision"`. AC5 records whichever you pick.)

**Q4. Where does the admin console show source and licence?**
- A ⭐ New read-only page "Third-party content" now
- B Wait for 86bcm901v's catalog and add the fields there
(With B, AC2 waits for 901v to merge, and this story can't finish on its own.)

**Q5. Files synced to engineers' tools from an imported item: add attribution to each file?**
The notice ships in the repo, the control-plane binary, the admin console and the installer. A pack copied from the library doesn't carry `source` into the client today.
- A ⭐ Not in this story; raise a follow-up card for pack/client
- B Add an attribution line to every synced file now (client work)

## Playback

Justin wants story 86bcm945u built on the Full pipeline, on a **new** branch `feat/86bcm945u-upstream-sync` cut from a freshly fetched `origin/main`, with **one screenshot per acceptance criterion** for the ClickUp card. Nothing earlier is continued (no earlier work exists for this card).

The story: content we import from the open-source repo `addyosmani/agent-skills` (MIT, pinned at release `0.6.13`, commit `aeac41d4d005999432bb7312f7ff06383a91d59d`) must be **pinned** (we record exactly which upstream commit each item came from), **attributed** (the MIT licence and copyright ship with the product, and the admin console shows source and licence per item) and **easy to update** (a sync tool reports what changed upstream against our pin without touching our own edits, and accepting a change bumps the item's version and records the new commit). We also record a decision about reusing upstream's evals in our quality gate.

## Acceptance criteria

Card ACs are kept; card AC1 is split in two. AC6 and AC7 come from the card's **Verify** line and are **proposed**. No AC is `(live)`: an agent can run every one of them locally. Each test fails on the base commit: its own fail line, or a build/import failure of the new code (the base copy gets head's test files).

- **AC1** (card AC1, notice part): Given the distribution, then `THIRD_PARTY_NOTICES.md` at the repo root includes the agent-skills MIT licence text in full and the line `Copyright (c) 2025 Addy Osmani`, with the source repository and the pinned release and commit.
  Test `TestAC1_ThirdPartyNoticesIncludeAgentSkillsMITLicence` in `internal/library/upstream_test.go`.
  `go test -v -count=1 -run '^TestAC1_ThirdPartyNoticesIncludeAgentSkillsMITLicence$' ./internal/library`
  Base: `undefined: Upstream` / `ThirdPartyNotices` (build failure).
- **AC2** (card AC1, console part): Given the admin console, when an admin opens **Third-party content** (`GET /admin/third-party-content`), then every imported library item shows its source (upstream name, upstream path, full source commit) and its licence (`MIT` plus the copyright line), items Leorna wrote itself are not listed, a member gets 403 and a signed-out visitor is redirected to sign-in.
  Test `TestAC2_AdminConsoleShowsSourceAndLicenceForEachImportedItem` in `internal/web/third_party_content_test.go` (real Postgres).
  `LEORNA_TEST_DATABASE_URL=<builder's own _test database URL> go test -v -count=1 -run '^TestAC2_AdminConsoleShowsSourceAndLicenceForEachImportedItem$' ./internal/web`
  Base: `undefined: SetContentLibrary` (build failure). Without the env var the test skips, which `ac-check` rejects, so the variable is part of the command.
- **AC3** (card AC2): Given a new upstream release, when the sync job runs (`library-upstream diff`), then it reports added, changed and removed upstream items as a diff against our pinned commit (each imported item against its own recorded commit), marks imported items that carry Leorna adaptations, and changes no library file.
  Test `TestAC3_SyncReportsDiffAgainstPinWithoutOverwritingAdaptations` in `cmd/library-upstream/main_test.go` (local fixture git repo, no network).
  `go test -v -count=1 -run '^TestAC3_SyncReportsDiffAgainstPinWithoutOverwritingAdaptations$' ./cmd/library-upstream`
  Base: `undefined: run` and the missing `internal/library/upstream` package (build failure).
- **AC4** (card AC3): Given an upstream change we accept (`library-upstream accept`), then the library item's version is bumped, the new source commit is recorded, the new version is pinned in `content.lock.json` (old entries untouched), and an item with Leorna adaptations is never overwritten.
  Test `TestAC4_AcceptBumpsVersionAndRecordsNewSourceCommit` in `cmd/library-upstream/main_test.go`.
  `go test -v -count=1 -run '^TestAC4_AcceptBumpsVersionAndRecordsNewSourceCommit$' ./cmd/library-upstream`
  Base: build failure as AC3.
- **AC5** (card AC4): Given the upstream evals and validators, then a decision on reusing them in our quality gate is recorded: an accepted ADR, `adr/0002-reuse-of-agent-skills-evals.md`, and the matching machine-readable `evals` field in the upstream record, which the sync report prints.
  Test `TestAC5_UpstreamEvalsReuseDecisionIsRecorded` in `internal/library/upstream_test.go`.
  `go test -v -count=1 -run '^TestAC5_UpstreamEvalsReuseDecisionIsRecorded$' ./internal/library`
  Base: build failure as AC1.
- **AC6 (proposed)** (card Verify, "licence notice present in the built installer"): Given the installer built the way `make dist` builds it (`GOOS=windows GOARCH=amd64 go build ./cmd/launcher`), then the binary carries the agent-skills copyright line, the MIT permission sentence and the source repository, and `--notices` prints them.
  Test `TestAC6_BuiltInstallerCarriesAgentSkillsLicenceNotice` in `cmd/launcher/installer_notice_test.go`.
  `go test -v -count=1 -timeout 15m -run '^TestAC6_BuiltInstallerCarriesAgentSkillsLicenceNotice$' ./cmd/launcher`
  Base: the test compiles on base, builds the base installer and fails on its own assertion (the text isn't there).
- **AC7 (proposed)** (card Verify, "dry-run sync against upstream HEAD"): Given the real upstream repository, when the sync job runs as a dry run against `HEAD`, then it resolves HEAD to a commit, reports against the pinned commit `aeac41d4d005999432bb7312f7ff06383a91d59d`, lists the pilot skill as a tracked item, exits successfully and changes no library file.
  Test `TestAC7_DryRunSyncAgainstUpstreamHEAD` in `cmd/library-upstream/main_test.go`. It is the story's **only network test**: it reads the public GitHub repo, with no credentials, and runs only when `LEORNA_TEST_UPSTREAM_NETWORK=1` is set (CI skips it).
  `LEORNA_TEST_UPSTREAM_NETWORK=1 go test -v -count=1 -run '^TestAC7_DryRunSyncAgainstUpstreamHEAD$' ./cmd/library-upstream`
  Base: build failure as AC3.

**Test files per AC** (for the base run, which checks out head's test files): AC1, AC5 → `internal/library/upstream_test.go` (self-contained). AC2 → `internal/web/third_party_content_test.go` (uses `newPackFixture` from `packs_test.go`, which exists on base). AC3, AC4, AC7 → `cmd/library-upstream/main_test.go` + `cmd/library-upstream/fixture_test.go`. AC6 → `cmd/launcher/installer_notice_test.go` (standard library only, so it reaches its own assertion on base).

## Current context (verified 2026-10-24)

- **Repos:** control plane `origin/main` = `6e74ced` (PR #87 merged; local `main` is 4 behind, untracked `.claude/` and `deploy/local/`, left alone). Client `origin/main` = `ea2b8ab`. This story touches **the control plane only**.
- **Content library (86bcm9018, complete):** `internal/library/{library.go,source.go,content/,content.lock.json,README.md}`. Items are `content/items/<kind>/<name>/{item.json,body.md,example.md}`, strict JSON, append-only lock of `Item.Checksum()` per `kind/name@version`. `content/library.json` is `0.2.0` on main. Loader: `internal/store/postgres/library.go` → table `library_items` (migration 20), keyed `(kind,name,version)`, compares checksums, never rewrites.
- **Skill bodies carry no frontmatter.** The client builds `SKILL.md` frontmatter from item name and description (`leorna-client toolconnector/transform.go:61` `RenderSkill`). Agent bodies keep their frontmatter (`content/items/agent/code-reviewer/body.md`).
- **Admin console:** server-rendered `html/template` pages, admin-only via `requireSession(requireAdmin(...), true)` (`internal/web/handler.go:229-290`), nonce CSP (`admin_ui.go` `adminCSP`), shared `adminBaseCSS`. Admin HTML pages are **not** in OpenAPI (e.g. `/admin/audit`, `/admin/adoption`). The home nav line is `handler.go:737`. No library page exists on main.
- **Built installer:** `make dist` → `scripts/dist.sh` → `GOOS=windows GOARCH=amd64 go build -ldflags "-X main.version=…" -o dist/leorna-installer-windows-amd64.exe ./cmd/launcher`. The launcher picks its mode from args (`cmd/launcher/main.go` `modeFromArgs`).
- **`THIRD_PARTY_NOTICES.md`** (root) only points to the client's notices today.
- **ADRs:** `adr/0001-…` only; `0002` is free.
- **Upstream** (bare clone in `~/.hermes/cache/scratch/86bcm945u-planner/upstream`, read as data, no script run): the tag is **`0.6.13`** (no `v`), an annotated tag on `aeac41d4d005999432bb7312f7ff06383a91d59d`. **Upstream HEAD equals the pin today.** 217 files; the largest blob is 33 KB. `LICENSE` (blob `d67778ada6b9cda6227e9130da182c13e73c8b2e`) is the standard MIT text with `Copyright (c) 2025 Addy Osmani`. Layout: `skills/<name>/SKILL.md` (frontmatter `name` + one-line `description`; three skills have extra files, e.g. `idea-refine` ships a script), `agents/<name>.md` (4 personas, frontmatter), `commands/<name>.toml` (9 slash commands = prompts), `evals/cases/<skill>.json` (25 trigger + behavioural case files), `evals/plugin/<case>/{prompt.md,graders/*.md}` (5 plugin eval cases), `evals/fixtures/`, `scripts/lib/skill-lint.js` (the card's "scripts/skill-lint.js" lives under `lib/`), `scripts/validate-{skills,commands,reference-links,artifact-paths,versions}.js`, `scripts/run-evals.js`. Tier 2 evals are lexical TF-IDF (deterministic, Node); Tier 3 and plugin evals call a model.
- **Pilot:** `skills/debugging-and-error-recovery/SKILL.md` (blob `356da20365a7cd6825b4ffad14be39280c92cdfc`, 10.9 KB): frontmatter is exactly `name` + a one-line `description`, then a blank line, then the body from line 6; no `references/` or `../` links; no CR bytes.

## Approach and design

### Files and areas (control plane only)

| Area | Files | Change |
| --- | --- | --- |
| Library model | `internal/library/library.go`, `internal/library/source.go`, new `internal/library/upstream.go`, new `internal/library/lock.go` | Optional `Source` on items, upstream records, `Adapted()`, notices text, lock helpers |
| Upstream record | new `internal/library/content/upstreams/agent-skills/upstream.json`, new `…/LICENSE` | Pin, licence, copyright, layout, evals decision; verbatim upstream LICENSE |
| Pilot item (Q2-A) | new `internal/library/content/items/skill/debugging-and-error-recovery/{item.json,body.md,example.md}`, `content.lock.json` (+1 line), `content/library.json` (0.2.0 → 0.3.0) | Imported with the new tool |
| Sync tool | new package `internal/library/upstream/` (`git.go`, `layout.go`, `diff.go`, `write.go`, `importer.go`), new `cmd/library-upstream/main.go` | `diff` (dry run), `import`, `accept`, `notices` |
| Notices | `THIRD_PARTY_NOTICES.md` | New "Content library" section with the agent-skills notice |
| Installer | `cmd/launcher/main.go` | `--notices` mode prints the library's third-party notices; importing `internal/library` puts the licence text in the binary |
| Admin console | new `internal/web/third_party_content.go`, `internal/web/handler.go` (one field, one route, one nav link), `cmd/control-plane/main.go` (one setter call) | Read-only "Third-party content" page |
| Decision | new `adr/0002-reuse-of-agent-skills-evals.md` | AC5 |
| Docs | `internal/library/README.md` | New section "Upstream content (86bcm945u)" |

**Not changed:** OpenAPI (`contracts/`, `packages/contracts/`: no API change, admin HTML only), Postgres schema and migrations (the source record lives in the embedded library, not in `library_items`), `.github/workflows/*`, `Containerfile` (the notice is inside the binary), `cmd/distpack` (the portal distribution carries only `seed.json`, which has no upstream content), the client repo, `internal/pack/seed.json`.

### Data shapes

**Upstream record**: `internal/library/content/upstreams/<name>/upstream.json` plus `LICENSE`. The folder name is the upstream name (a slug). Strict JSON, unknown fields rejected, no other file allowed in the folder:

```json
{
  "repository": "https://github.com/addyosmani/agent-skills",
  "license": "MIT",
  "copyright": "Copyright (c) 2025 Addy Osmani",
  "release": "0.6.13",
  "commit": "aeac41d4d005999432bb7312f7ff06383a91d59d",
  "layout": "agent-skills",
  "evals": {
    "decision": "reference-only",
    "record": "adr/0002-reuse-of-agent-skills-evals.md"
  }
}
```

`LICENSE` is the upstream file **byte for byte** at the pinned commit. Proof: `git hash-object internal/library/content/upstreams/agent-skills/LICENSE` prints `d67778ada6b9cda6227e9130da182c13e73c8b2e`. (`internal/library/content/**` is already `text eol=lf` in `.gitattributes`.)

Validation (in `Library.Validate`, errors name the upstream like item errors do):
- `repository`: `url.Parse` OK, scheme `https`, non-empty host, no user info, no query or fragment.
- `license`: `^[A-Za-z0-9.+-]{1,64}$` (an SPDX id).
- `copyright`: one line, 1–200 characters, and it must appear verbatim in `LICENSE`.
- `release`: `^[0-9A-Za-z][0-9A-Za-z._-]{0,63}$`. `commit`: `^[0-9a-f]{40}$`.
- `layout`: only `agent-skills` (constant `library.LayoutAgentSkills`).
- `evals` is optional. When present: `decision` ∈ `reference-only`, `run-in-gate`, `not-reused`; `record` matches `^adr/[0-9]{4}-[a-z0-9-]+\.md$`.
- `LICENSE`: required, valid UTF-8, no NUL, 1 byte to 64 KiB, LF-normalised like `readText`.

Go types (new `internal/library/upstream.go`):

```go
// LayoutAgentSkills maps upstream paths the way addyosmani/agent-skills lays them out:
// skills/<name>/SKILL.md, agents/<name>.md, commands/<name>.toml.
const LayoutAgentSkills = "agent-skills"

// Upstream is an open-source project the library imports content from.
type Upstream struct {
	Name        string         // folder name under content/upstreams/
	Repository  string         // https URL
	License     string         // SPDX identifier, e.g. "MIT"
	Copyright   string         // copyright line exactly as it appears in LICENSE
	Release     string         // upstream release the library is pinned to
	Commit      string         // the pinned commit (40 hex)
	Layout      string         // LayoutAgentSkills
	Evals       *EvalsDecision // nil when the upstream ships no evals worth a decision
	LicenseText string         // LICENSE, verbatim with LF line endings
}

// EvalsDecision records whether upstream evals feed our quality gate.
type EvalsDecision struct {
	Decision string `json:"decision"` // reference-only | run-in-gate | not-reused
	Record   string `json:"record"`   // repository path of the ADR
}
```

`Library` gains `Upstreams []Upstream` (sorted by name) and `func (library Library) Upstream(name string) (Upstream, bool)`. `Parse` reads `upstreams/` when it exists; a library without it (every existing test tree) still parses.

**Item source**: an optional `source` block in `item.json`. Items Leorna wrote itself have none.

```json
"source": {
  "upstream": "agent-skills",
  "path": "skills/debugging-and-error-recovery",
  "commit": "aeac41d4d005999432bb7312f7ff06383a91d59d",
  "upstreamSha256": "<64 hex, computed by the import tool>"
}
```

```go
// Source records where an imported item came from.
type Source struct {
	Upstream       string `json:"upstream"`       // an Upstream name in this library
	Path           string `json:"path"`           // upstream item root, e.g. skills/debugging-and-error-recovery
	Commit         string `json:"commit"`         // upstream commit the content was last taken from (40 hex)
	UpstreamSHA256 string `json:"upstreamSha256"` // ImportedContentSHA256 of the content as taken at Commit
}
```

`Item` gains `Source *Source`; `itemMeta` gains `Source *Source \`json:"source,omitempty"\`` (strict decoding still rejects unknown keys inside it: decode `Source` with its own `DisallowUnknownFields` pass or keep the whole item decode strict, which already covers nested structs).

Validation: `Item.Validate` checks the format (path per layout and kind: a `skill` path is `skills/<slug>`, an `agent` path is `agents/<slug>.md`; any other kind with a source is invalid; commit 40 hex; `upstreamSha256` 64 hex). `Library.Validate` checks `source.upstream` names an upstream in this library.

**Leorna adaptation** (what the sync must never overwrite) is defined exactly:

```go
// ImportedContentSHA256 fingerprints the part of an item that comes from upstream:
// its description and body.
func ImportedContentSHA256(description, body string) string {
	canonical, err := json.Marshal(struct {
		Description string `json:"description"`
		Body        string `json:"body"`
	}{description, body})
	if err != nil {
		panic(err) // strings always marshal
	}
	return fmt.Sprintf("%x", sha256.Sum256(canonical))
}

// Adapted reports whether Leorna changed the imported description or body since it was
// last taken from upstream.
func (item Item) Adapted() bool {
	return item.Source != nil && ImportedContentSHA256(item.Description, item.Body) != item.Source.UpstreamSHA256
}
```

Category, tags, tools and `example.md` are always Leorna's; the sync tool never writes them after import.

**Checksum compatibility (must hold):** `Item.Checksum()`'s canonical struct gains a last field `Source *Source \`json:"source,omitempty"\``. Items without a source marshal exactly as before, so all 8 shipped checksums in `content.lock.json` stay identical (proved by the unchanged `TestContentLockPinsEveryItemVersion` and a new literal-pinned test, T1). A source change therefore needs a version bump, which `accept` always does. Postgres keeps only the checksum, not the source (no migration); old versions' source records live in git history.

**Notices text** (used by the launcher, the `notices` subcommand and AC1):

```go
// ThirdPartyNotices is the licence notice for every upstream, as the installer and
// THIRD_PARTY_NOTICES.md print it.
func (library Library) ThirdPartyNotices() string {
	var text strings.Builder
	text.WriteString("Third-party content in the Leorna content library\n")
	for _, upstream := range library.Upstreams {
		fmt.Fprintf(&text, "\n%s\nSource: %s\nRelease: %s (commit %s)\nLicence: %s\n\n%s",
			upstream.Name, upstream.Repository, upstream.Release, upstream.Commit, upstream.License, upstream.LicenseText)
	}
	return text.String()
}
```

**Lock helpers** (new `internal/library/lock.go`), so the tool writes the lock in exactly the format the `-update-lock` test writes: `ReadLock(path) (map[string]string, error)` (missing file → empty map) and `WriteLock(path, lock) error` (`json.MarshalIndent(lock, "", "  ")` + `"\n"`, mode 0644). The existing test is not changed.

### The sync tool: `cmd/library-upstream`

A developer CLI run from the repo root, `go run ./cmd/library-upstream <subcommand> [flags]`. `main` calls `run(args []string, stdout, stderr io.Writer) error`, prints `library-upstream: <error>` and exits 1 on error, 0 on success. Exit codes are pinned by tests on `run`, never through `make` or `go run` (which turn any failure into 2 or 1).

Common flags: `--library DIR` (default `internal/library`; the tool parses `DIR/content` with `library.Parse(os.DirFS(...))` and uses `DIR/content.lock.json`), `--upstream NAME` (default: the only upstream; an error if there are several), `--from URL-or-path` (default: the upstream's `repository`).

| Subcommand | Flags | Does | Writes |
| --- | --- | --- | --- |
| `diff` | `--to REV` (default `HEAD`) | The sync report (AC3, AC7) | **Nothing** |
| `import` | `--path P` (required), `--name N` (default: upstream name), `--category`, `--tags a,b`, `--tools t1,t2`, `--example FILE` (all required), `--to REV` (default: the upstream pin) | Creates a new item from upstream with its `source` | The new item folder + one lock entry |
| `accept` | `--item kind/name` and `--to REV` (both required), `--keep-local`, `--bump minor\|patch\|major` (default `minor`) | Takes an upstream change into an imported item (AC4) | That item's `item.json` (+ `body.md` unless `--keep-local`) + one lock entry |
| `notices` | none | Prints `ThirdPartyNotices()` (to refresh `THIRD_PARTY_NOTICES.md`) | Nothing |

There is no schedule (no CI changes allowed): the job is this command, run by a person. A weekly workflow is a follow-up. The tool does not bump `library.json`; the README says to bump it in the same change. Moving the upstream pin after a reviewed release means editing `release` and `commit` in `upstream.json` (both validated); there is no `pin` command.

**Reading upstream safely** (`internal/library/upstream/git.go`). The tool treats the upstream repo as untrusted data: it never checks out a working tree, never runs an upstream file, and never builds an output path from an upstream path.

```go
type Repo struct{ dir string }
type Blob struct {
	ID   string // 40-hex object id
	Size int64
}
type Tree map[string]Blob // upstream path -> blob; symlinks and submodules are skipped

func Clone(ctx context.Context, from, into string) (*Repo, error) // git clone --bare --quiet -- <from> <into>
func (repo *Repo) Resolve(ctx context.Context, rev string) (string, error)
// git -C <dir> rev-parse --verify --quiet --end-of-options <rev>^{commit}
func (repo *Repo) Tree(ctx context.Context, commit string) (Tree, error)
// git -C <dir> ls-tree -r -l -z --full-tree <commit>
func (repo *Repo) Read(ctx context.Context, blob Blob, limit int64) ([]byte, error)
// refuses blob.Size > limit before reading; git -C <dir> cat-file blob <id>
```

- Every git call is `exec.CommandContext("git", args...)` with an argument list, never a shell (GO-INJECT-002). Env adds `GIT_TERMINAL_PROMPT=0`, `GIT_ALLOW_PROTOCOL=file:https` (local paths for tests, https for GitHub), `GIT_CONFIG_NOSYSTEM=1`. Timeouts: clone 5 min, other calls 1 min. A missing `git` is a clear error.
- `rev` must match `^[A-Za-z0-9][A-Za-z0-9._/-]{0,199}$` (tags, branches, `HEAD`, hex) before it reaches git; `--end-of-options` stops option injection anyway. Commits and blob ids are checked against `^[0-9a-f]{40}$` (a SHA-256 repo is refused as unsupported). `ls-tree` output is capped at 50,000 entries. Blobs are read by object id, never by `commit:path`.
- The clone goes to `os.MkdirTemp("", "library-upstream-*")`, removed on exit.

**Layout** (`internal/library/upstream/layout.go`) groups upstream paths into roots:

| Upstream path | Group (report KIND) | Root | Main file |
| --- | --- | --- | --- |
| `skills/<n>/…` | `skill` | `skills/<n>` | `skills/<n>/SKILL.md` |
| `agents/<n>.md` | `agent` | `agents/<n>.md` | itself |
| `commands/<n>.toml` | `prompt` | `commands/<n>.toml` | itself (not importable until 86bcm9016) |
| `LICENSE` | `licence` | `LICENSE` | itself |
| `evals/<dir>/…` or `evals/<file>` | `tooling` | `evals/<dir>` or `evals/<file>` | none |
| `scripts/…` | `tooling` | `scripts` | none |
| anything else | not reported | counted as "other" | none |

A root's fingerprint is the SHA-256 of its files' sorted `relative path NUL blob id LF` lines, so "changed" means any file under the root changed (git object ids, no blob reads).

**Import transform** (`Transform(kind pack.Kind, raw []byte) (Imported{Description, Body string}, error)`): normalise CRLF to LF; require valid UTF-8, no NUL, at most `pack.MaxBodyBytes`; require frontmatter (`---\n` … the first `\n---\n`), parsed as `key: value` lines with unique keys.
- **skill:** frontmatter keys must be exactly `name` and `description`; `name` must equal the folder name; body = text after the closing `---\n` with leading `\n` trimmed, non-empty. (Any other key, e.g. `allowed-tools`, is refused: the client renders only name + description, so it would silently drop it.)
- **agent:** body = the whole normalised file (frontmatter kept, like Leorna's own agents); `description` is required; other keys are allowed.
- `description` must be one plain line: refused when empty, or when it starts with any of `" ' > | [ { & * ! % @` or a backtick (quoted, folded or block YAML is "import by hand").
- Any other kind: refused with "kind X cannot be imported yet".

**`diff` algorithm** (`internal/library/upstream/diff.go`, `Diff(ctx, repo, lib, upstream, targetRev) (Report, error)`, pure apart from git reads):
1. `target := Resolve(targetRev)`; `pinTree := Tree(upstream.Commit)`; `targetTree := Tree(target)`. A missing pin commit is an error.
2. Tracked items: library items whose `Source.Upstream == upstream.Name`, keyed by `Source.Path`. Each tracked item's **baseline is its own `Source.Commit`** (tree cached per commit); an untracked root's baseline is the pin. A recorded commit missing from the repo is an error naming the item.
3. For every root in the union of baseline and target roots: `added` (no baseline), `removed` (no target), `changed` (fingerprints differ), `unchanged`. Untracked unchanged roots are left out; tracked unchanged roots are shown (that's what the HEAD dry run lists today).
4. For tracked changed roots, also compare the main file's blob id: if it is the same, only supporting files changed.
5. Count changed files outside every root as "other".

Report text (`Report.WriteText(w)`, `text/tabwriter`), tests split rows with `strings.Fields` on the first six columns and compare NEXT STEP as the rest of the line:

```
Upstream: agent-skills (MIT; Copyright (c) 2025 Addy Osmani)
Repository: https://github.com/addyosmani/agent-skills
Pinned: 0.6.13 aeac41d4d005999432bb7312f7ff06383a91d59d
Target: HEAD aeac41d4d005999432bb7312f7ff06383a91d59d
Evals and validators: reference-only (adr/0002-reuse-of-agent-skills-evals.md)

CHANGE     KIND   UPSTREAM PATH                        LEORNA ITEM                               ADAPTED  NEXT STEP
unchanged  skill  skills/debugging-and-error-recovery  skill/debugging-and-error-recovery@1.0.0  no       none

Other upstream files changed (not tracked): 0
Summary: 0 added, 0 changed, 0 removed, 1 tracked unchanged, 0 adapted.
Dry run: no library files were changed.
```

Rows sort by kind (`skill`, `agent`, `prompt`, `licence`, `tooling`), then path. LEORNA ITEM and ADAPTED are `-` for untracked roots. NEXT STEP constants (tests assert them; `<target>` is the 40-hex commit):

| Row | NEXT STEP |
| --- | --- |
| tracked, unchanged | `none` |
| tracked, changed, main file changed, not adapted | `accept: go run ./cmd/library-upstream accept --item <kind/name> --to <target>` |
| tracked, changed, main file changed, adapted | `merge by hand, then: go run ./cmd/library-upstream accept --item <kind/name> --to <target> --keep-local` |
| tracked, changed, main file unchanged | `none (only supporting files changed)` |
| tracked, removed | `removed upstream: keep or retire the item by hand` |
| untracked, added | `available to import` |
| untracked, changed or removed | `not imported` |
| `licence` changed | `review THIRD_PARTY_NOTICES.md and content/upstreams/<name>/LICENSE` |
| `tooling` added/changed/removed | `evals decision: <decision> (<record>)`, or `no evals decision recorded` when `evals` is absent |

**`import`** (`internal/library/upstream/importer.go`): resolve `--to` (default: the upstream pin); the path must be a `skill` or `agent` root in that tree (`prompt` → "needs the prompt kind (86bcm9016)"; a skill folder with any file besides `SKILL.md` → "multi-file items need 86bcm945q"); the item must not exist yet; `--name` must be a slug. Read the main file (limit `pack.MaxBodyBytes`), transform, build the `library.Item` (version `1.0.0`, Leorna's category/tags/tools/example, the upstream description, `Source{Upstream, Path, Commit: resolved, UpstreamSHA256: ImportedContentSHA256(desc, body)}`), validate the whole library with the new item in memory, then write the folder and add `kind/name@1.0.0` to the lock (an existing key is an error).

**`accept`**: the item must exist and have a `source`. Resolve `--to`. If the root is gone at the target → error "removed upstream". Transform the target main file. If its `ImportedContentSHA256` equals `Source.UpstreamSHA256` → error "upstream content for X is unchanged; nothing to accept". If the item is **adapted** and `--keep-local` is not set → error "X has Leorna adaptations; merge the upstream change into body.md and the description by hand, then run accept with --keep-local" and **write nothing**. Otherwise build the new item: version bumped (`minor` default: `1.0.0` → `1.1.0`; `patch` → `1.0.1`; `major` → `2.0.0`), `Source.Commit = target`, `Source.UpstreamSHA256 = new fingerprint`, and description + body replaced by the upstream's **unless** `--keep-local` (which keeps the item's own description and body). Validate the whole library in memory, then write `item.json` (+ `body.md` when replaced) and add the new `kind/name@version` lock key. Old lock entries are never touched; an existing key with a different checksum is an error.

**Writing** (`internal/library/upstream/write.go`, `WriteItem(libraryDir string, item library.Item) error`): the folder is `filepath.Join(libraryDir, "content", "items", string(item.Kind), item.Name)` with kind and name already validated, plus a containment check (`filepath.Rel` result must not start with `..`). `item.json` is written with a `json.Encoder`, `SetIndent("", "  ")`, `SetEscapeHTML(false)`, field order `version, category, tags, tools, description, source`, trailing newline (matches the existing files). `body.md` and `example.md` are written as-is (LF). Validation happens before the first write; if a write fails part-way, the files are tracked by git, so `git checkout` restores them (say so in the error).

### `THIRD_PARTY_NOTICES.md` and the installer

- Add a section to the root file, after the existing text:

  ````
  ## Content library

  The Leorna content library (`internal/library/content`) ships items imported from the
  open-source projects below. The control plane and the installer
  (`leorna-installer-windows-amd64.exe --notices`) carry the same notice. Imported items
  are listed in the admin console under Third-party content.

  ```text
  <exact output of: go run ./cmd/library-upstream notices>
  ```
  ````
- AC1 checks the root file contains `Embedded().ThirdPartyNotices()` verbatim, so the file can't drift from the shipped record.
- **Control-plane binary:** the LICENSE is embedded with the rest of `content/` and shown on the admin page.
- **Installer:** `cmd/launcher` imports `internal/library` and gains a `notices` mode: `modeFromArgs` returns `"notices"` for `--notices` (checked first), and `run` prints `library.Embedded()`'s `ThirdPartyNotices()` to stdout and returns. That code path keeps the embedded LICENSE in the Windows binary. `internal/library` pulls in only `internal/pack`, `internal/org` and `internal/store` (no pgx), so the installer grows by the embedded content only.

### Admin console: "Third-party content" (Q4-A)

- `Handler` gains `contentLibrary *library.Library` and `func (handler *Handler) SetContentLibrary(shipped library.Library) { handler.contentLibrary = &shipped }`.
- Route in `Routes()`: `routes.Handle("GET /admin/third-party-content", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.thirdPartyContentView)), true))`. The path doesn't overlap any `/admin/library/...` route 86bcm901v may add.
- `cmd/control-plane/main.go`, after `EnsureLibrary`: `shipped, err := library.Embedded()` (return the error) and later `application.SetContentLibrary(shipped)` next to the other setters.
- Home nav (`handler.go:737`): append ` · <a href="/admin/third-party-content">Third-party content</a>`.
- New `internal/web/third_party_content.go`, modelled on `auditView` (`internal/web/audit.go:56`): nil library → `writeProblem(w, r, 503, "LIBRARY_UNAVAILABLE", "The content library is unavailable")`; otherwise a nonce'd `html/template` page with the same security headers (`Cache-Control: no-store`, `X-Content-Type-Options: nosniff`, `adminCSP(nonce)`), `adminBaseCSS`, a link back to `/admin`, h1 "Third-party content", one line of intro, then one `<section>` per upstream:
  - heading `<upstream name> · <license>`; a `<dl>` with Repository (an `<a rel="noopener noreferrer">` to the https URL), Pinned release (`release` + full `commit`), Copyright;
  - a table with columns **Item**, **Version**, **Source**, **Licence**, **Leorna changes**, one row per imported item, sorted by key: `<tr data-item="kind/name@version">`, Source = `<upstream> · <code>path</code> · commit <code>full 40-hex</code>`, Licence = `MIT · Copyright (c) 2025 Addy Osmani`, Leorna changes = `Yes` / `No` from `Adapted()`;
  - the licence text in a `<pre>`.
  - No imported items at all → "This library has no imported third-party content."
- No `template.HTML` or other trusted-type conversion; upstream text is data (GO-XSS-001). The page shows product content only (the same for every tenant), so the tenant checks are the usual admin-only guards.

### AC5: the decision record (Q3-A)

New `adr/0002-reuse-of-agent-skills-evals.md`, in ADR 0001's style, containing these lines exactly (the test looks for them): `Status: Accepted` and `Decision: reference-only`. It must name the pinned commit `aeac41d4d005999432bb7312f7ff06383a91d59d` and the upstream paths `scripts/lib/skill-lint.js`, `evals/cases` and `evals/plugin`. Content:
- **Context:** upstream's three tiers (structural validators in Node; Tier 2 trigger/routing cases run by `run-evals.js`, lexical and deterministic; Tier 3 behavioural cases and `evals/plugin/*/graders` that call a model). Our gate (86bcm901u) is Go, runs offline in "Go quality gates", and must stay deterministic.
- **Decision: reference-only.**
  - Tier 1: reuse the rules, not the code. The checks that fit Leorna items (skill name matches the folder; description at most 1024 characters and says when to use the skill; no frontmatter keys our renderers drop) may be ported to Go in the quality gate by 86bcm901u or a follow-up. Upstream JavaScript never runs in our CI.
  - Tier 2: not run. Case files stay reference data for imported skills; revisit when the library ships ten or more skills.
  - Tier 3 and plugin evals: not run in CI (model calls, credentials, cost, non-deterministic). A person may run them on demand before importing a skill.
  - `library-upstream diff` prints this decision on every report and on every changed `evals/` or `scripts/` root.
- **Consequences:** no Node or model calls in CI; porting rules is follow-up work; the record is machine-readable in `upstream.json` → `evals`.
With Q3-B the decision line becomes `Decision: run-in-gate` (and the ADR says the CI work is its own story); with Q3-C, `Decision: not-reused`.

## Tasks (build order, test-first)

Every task: write the named test, run it and see it fail for the stated reason (not a setup error), write the smallest code that passes, rerun, then run `go test ./internal/library/... ./cmd/library-upstream/... ./cmd/launcher/... ./internal/web/...` (with the Postgres env) and commit the task's files by name with `feat(86bcm945u): …`. Git identity must resolve to `Justin Issa <justin@leorna.com>` (never override). No AI attribution lines.

**T0 Preflight (no code).**
1. Fetch: `git -C ~/Leorna/leorna-control-plane -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`.
2. `git -C ~/Leorna/leorna-control-plane worktree add -b feat/86bcm945u-upstream-sync ~/Leorna/leorna-control-plane/.claude/worktrees/86bcm945u-upstream-sync origin/main`. Record the base SHA (6e74ced or newer). Never touch the main folder, `deploy/local/` or any sibling worktree.
3. `git log -1 --pretty=format:'%an <%ae>'` in the worktree after the first commit must be `Justin Issa <justin@leorna.com>`.
4. Tools: install golangci-lint **2.14.0** (CI's version, `.github/workflows/ci.yml:120`) into `~/.hermes/cache/scratch/86bcm945u-build/leorna-bin` and put it **first** in `PATH` (or bind `GOLANGCI_LINT=<abs path>`); echo `golangci-lint --version` from that PATH. Check GNU `realpath --relative-to` and Bash ≥ 4 for the workspace scripts (Homebrew `coreutils/libexec/gnubin` and `/opt/homebrew/bin` ahead in the task's PATH only). `go version` inside the worktree shows the toolchain `go.mod` selects (go1.27.3).
5. Postgres: `docker ps` shows `leorna-test-pg`. Create the story's own database `leorna_86bcm945u_test` in that container and use the URL from `leorna-control-plane-workflow.md` with that database name (it must end in `_test`). Never use or drop a sibling's database.
6. Baseline on base: `make check` and `bash ./scripts/test-module-add.sh` → `~/.hermes/plans/leorna/evidence/86bcm945u/gates-<base7>-baseline.txt` + `.json` (exit codes). Pre-existing failures are compared by identity later, not blamed on the story.
7. Clone upstream for the build: `git clone --bare --quiet https://github.com/addyosmani/agent-skills.git ~/.hermes/cache/scratch/86bcm945u-build/agent-skills.git`. Data only: never check out or run its scripts. (In zsh, quote `"${PIN}:path"`, since `$PIN:s…` is a zsh modifier.)

**T1 Item source and checksum compatibility** (`internal/library`).
- RED first: `TestChecksumWithoutSourceIsUnchanged` asserts the checksum of `validTree()`'s `skill/write-tests` item equals a literal. Get the literal by running the test once on the **base** code (it compiles there) and pasting the value; it must still pass after the change.
- `TestParseReadsSource` (a `validTree` variant with a source block and an upstream folder: every field read, `Adapted()` false when description and body match, true after editing the body).
- `TestParseRejectsMalformedSource` (table, each case its own subtest, error names the item): unknown upstream; commit not 40 hex; `upstreamSha256` not 64 hex; skill with an `agents/x.md` path; agent with a `skills/x` path; `skills/../x`; `skills/x/SKILL.md` (a file, not a root); a source on a `config` item; an unknown key inside `source`.
- `TestChecksumCoversSourceFields`: changing each source field changes the checksum.
- `TestAdaptedComparesImportedContent`: no source → false; matching fingerprint → false; changed description → true; changed body → true; changed example/tags → false.
- Code: `Source`, `Item.Source`, `itemMeta.Source`, checksum field with `omitempty`, `ImportedContentSHA256`, `Adapted`, source validation.
- The existing tests (`TestEmbeddedLibraryIsValid`, `TestContentLockPinsEveryItemVersion`, `TestParseRejectsMalformedItems`, `TestChecksumCoversEveryField`) stay green and unchanged.

**T2 Upstream records** (`internal/library`).
- RED: `TestParseReadsUpstream` (all fields, LICENSE text LF-normalised, `Library.Upstream(name)`); `TestParseRejectsMalformedUpstream` (table: http repository; repository with user info; repository with a query; bad licence id; copyright not in LICENSE; multi-line copyright; bad release; short commit; unknown layout; bad evals decision; bad evals record path; missing LICENSE; empty LICENSE; an extra file in the upstream folder; an unknown key in `upstream.json`).
- `TestLockHelpersRoundTrip`: `ReadLock("content.lock.json")` then `WriteLock` to a temp file gives identical bytes; a missing file reads as an empty map.
- Code: `upstream.go`, `lock.go`, `Parse` reads `upstreams/<name>/{upstream.json,LICENSE}`.
- Then add the real record: `internal/library/content/upstreams/agent-skills/upstream.json` (as above) and `LICENSE` from `git -C <bare clone> cat-file blob d67778ada6b9cda6227e9130da182c13e73c8b2e`. Check `git hash-object` prints that id. `TestEmbeddedLibraryIsValid` stays green.

**T3 AC1: notices.**
- RED: `TestAC1_ThirdPartyNoticesIncludeAgentSkillsMITLicence` in `internal/library/upstream_test.go`: `Embedded()` has upstream `agent-skills` with licence `MIT`, copyright `Copyright (c) 2025 Addy Osmani`, release `0.6.13`, commit `aeac41d4d005999432bb7312f7ff06383a91d59d`, repository `https://github.com/addyosmani/agent-skills`; its LICENSE text contains the copyright line and the sentence `The above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.`; `ThirdPartyNotices()` contains the name, repository, release, commit, licence and the full LICENSE text; and `os.ReadFile("../../THIRD_PARTY_NOTICES.md")` contains `ThirdPartyNotices()` verbatim (failure message: "refresh the Content library section with: go run ./cmd/library-upstream notices").
- `TestThirdPartyNoticesRendersEveryUpstream` (two fixture upstreams, sorted, each block complete).
- Code: `ThirdPartyNotices()`. Edit `THIRD_PARTY_NOTICES.md` (the `notices` subcommand doesn't exist until T8, so paste the function's output from a throwaway `go test -run … -v` log line, then confirm with the subcommand in T8).

**T4 AC5: evals decision.**
- RED: `TestAC5_UpstreamEvalsReuseDecisionIsRecorded` in `internal/library/upstream_test.go`: upstream `agent-skills` has `Evals` with `Decision == "reference-only"` and `Record == "adr/0002-reuse-of-agent-skills-evals.md"`; `os.ReadFile("../../" + Record)` succeeds; the ADR contains the lines `Status: Accepted` and `Decision: ` + the manifest decision, the pinned commit, and `scripts/lib/skill-lint.js`, `evals/cases`, `evals/plugin`.
- Write the ADR (content above).

**T5 Layout and transform** (`internal/library/upstream`).
- RED: `TestRootsGroupUpstreamPaths` (every row of the layout table, including `evals/README.md`, `scripts/lib/x.js` → `scripts`, `docs/x.md` → other, a symlink entry skipped); `TestTransformSkillSplitsFrontmatter` (description and body exact, CRLF input normalised, leading blank lines trimmed); `TestTransformAgentKeepsFileVerbatim`; `TestTransformRefuses` (table: no frontmatter; unterminated frontmatter; duplicate key; skill with `allowed-tools`; skill `name` ≠ folder; empty description; quoted, folded (`>`) and block (`|`) descriptions; empty body; invalid UTF-8; NUL; over 64 KiB; kind `config`).
- Code: `layout.go`.

**T6 Git reader** (`internal/library/upstream`, integration with a real local git repo).
- Shared test helper `newUpstreamRepo(t)` in `internal/library/upstream/git_test.go`: `t.Setenv("GIT_CONFIG_GLOBAL", os.DevNull)`, `t.Setenv("GIT_CONFIG_NOSYSTEM", "1")`, fixed `GIT_AUTHOR_*`/`GIT_COMMITTER_*` names, emails and dates, `git init -q -b main`, commits via a `commit(files map[string]string, tag string) (sha string)` helper.
- RED: `TestRepoClonesResolvesAndReads` (clone a local path; resolve `HEAD`, a tag and a full SHA; tree lists every file with blob ids; `Read` returns exact bytes); `TestRepoRejectsUnknownAndOptionLikeRevisions` (`no-such-tag` → error naming it; `--output=x` and `-x` refused before git runs); `TestRepoRefusesOversizedBlob`.
- Code: `git.go`.

**T7 Diff** (`internal/library/upstream`).
- RED: `TestDiffClassifiesTrackedAndUntrackedRoots` (fixture repo with two commits: every row kind and NEXT STEP constant from the table; untracked unchanged roots absent; other-files count); `TestDiffUsesEachTrackedItemsOwnCommit` (an item recorded at a commit newer than the pin is compared from its own commit, so a change between the pin and that commit is **not** reported for it); `TestDiffFailsWhenRecordedCommitIsMissing`; `TestReportTextLayout` (header lines, column order, summary, final "Dry run" line).
- Code: `diff.go`.

**T8 CLI `diff` and `notices`; AC3** (`cmd/library-upstream`).
- `cmd/library-upstream/fixture_test.go`: `newSyncFixture(t)` builds the **upstream fixture repo** (with the same git isolation as T6) and a **fixture library directory**:
  - upstream commit 1, tag `0.1.0` (= the pin): `LICENSE` (short MIT text, `Copyright (c) 2025 Test Author`), `skills/alpha/SKILL.md`, `skills/beta/SKILL.md`, `skills/gamma/SKILL.md` (each `---\nname: <n>\ndescription: Use when testing <n>.\n---\n\n# <N>\n\nVersion one.\n`), `agents/reviewer.md` (frontmatter + `You review.\n`), `commands/plan.toml`, `evals/cases/alpha.json`, `docs/guide.md`;
  - upstream commit 2, tag `0.2.0`: alpha and beta bodies say `Version two.`; gamma deleted; `skills/delta/SKILL.md` added; `evals/cases/alpha.json` and `docs/guide.md` changed; reviewer, `commands/plan.toml` and LICENSE unchanged;
  - library dir: `content/library.json`, `content/upstreams/fixture-skills/{upstream.json,LICENSE}` (`repository` `https://example.com/fixture-skills.git` — tests always pass `--from <fixture repo>`; `release` `0.1.0`; `commit` = commit 1; layout `agent-skills`; evals `reference-only` / `adr/0002-reuse-of-agent-skills-evals.md`), items `skill/alpha`, `skill/beta`, `skill/gamma`, `agent/reviewer` imported at commit 1 (sources computed with `upstream.Transform` + `library.ImportedContentSHA256`), `skill/beta`'s `body.md` then edited by "Leorna" (appended `\nLeorna note.\n`), and a native `skill/native` without source; finally `content.lock.json` written with `library.WriteLock` from the parsed items.
  - Helper `treeDigest(t, dir) string`: SHA-256 over every file's relative path, mode and bytes.
- RED: `TestAC3_SyncReportsDiffAgainstPinWithoutOverwritingAdaptations`: digest the library; `run([]string{"diff", "--library", lib, "--from", repo, "--to", "0.2.0"}, &out, &errOut)` returns nil; the output has `Pinned: 0.1.0 <commit1>` and `Target: 0.2.0 <commit2>`; rows (CHANGE KIND PATH ITEM ADAPTED, then NEXT STEP):
  - `changed skill skills/alpha skill/alpha@1.0.0 no` → `accept: go run ./cmd/library-upstream accept --item skill/alpha --to <commit2>`
  - `changed skill skills/beta skill/beta@1.0.0 yes` → `merge by hand, then: go run ./cmd/library-upstream accept --item skill/beta --to <commit2> --keep-local`
  - `removed skill skills/gamma skill/gamma@1.0.0 no` → `removed upstream: keep or retire the item by hand`
  - `added skill skills/delta - -` → `available to import`
  - `unchanged agent agents/reviewer.md agent/reviewer@1.0.0 no` → `none`
  - `changed tooling evals/cases - -` → `evals decision: reference-only (adr/0002-reuse-of-agent-skills-evals.md)`
  - `Other upstream files changed (not tracked): 1`, `Summary: 1 added, 3 changed, 1 removed, 1 tracked unchanged, 1 adapted.`, last line `Dry run: no library files were changed.`
  - no line mentions `skill/native`, `commands/plan.toml` or `LICENSE`;
  - the library digest is unchanged and beta's `body.md` bytes are exactly the adapted bytes.
- `TestDiffFailsOnUnknownRevisionAndWritesNothing` (DoD failure case): `--to 9.9.9` → error naming `9.9.9`; digest unchanged.
- `TestNoticesPrintsThirdPartyNotices`: `run([]string{"notices", "--library", lib}, …)` prints the fixture library's `ThirdPartyNotices()`.
- `TestUsageErrors`: no subcommand, unknown subcommand, unknown flag, two upstreams without `--upstream` → errors with usage text.
- Code: `cmd/library-upstream/main.go` (`run`, flag sets per subcommand, `diff`, `notices`). Then run `go run ./cmd/library-upstream notices` in the worktree and confirm `THIRD_PARTY_NOTICES.md` matches (AC1 green).

**T9 `import`.**
- RED: `TestImportCreatesItemWithSourceAndLockEntry` (import `skills/delta` at `0.2.0` with category/tags/tools/example flags: files written, `item.json` field order and indentation exact, source commit = commit 2, `Adapted()` false, lock gains `skill/delta@1.0.0` = its checksum, other files unchanged); `TestImportRefuses` (subtests, each leaving the digest unchanged: a `commands/plan.toml` path → "86bcm9016"; a skill folder with a second file → "86bcm945q"; an existing item; `--name ../x`; a path that isn't a root; a missing `--example`).
- Code: `importer.go` (`Import`), `write.go` (`WriteItem`), the `import` subcommand.

**T10 `accept`; AC4.**
- RED: `TestAC4_AcceptBumpsVersionAndRecordsNewSourceCommit`:
  - main path: `accept --item skill/alpha --to 0.2.0` returns nil; re-parsed alpha has version `1.1.0`, `Source.Commit == commit2`, `Source.UpstreamSHA256 == ImportedContentSHA256("Use when testing alpha.", "# Alpha\n\nVersion two.\n")`, `body.md` == `# Alpha\n\nVersion two.\n`, `Adapted()` false; the lock still has `skill/alpha@1.0.0` with its old value and now has `skill/alpha@1.1.0` == the new item's `Checksum()`; every other item folder's digest is unchanged.
  - subtest `adapted item is not overwritten`: `accept --item skill/beta --to 0.2.0` → error containing `Leorna adaptations`, whole library digest unchanged; then with `--keep-local` → beta is `1.1.0`, `Source.Commit == commit2`, `body.md` bytes equal the adapted bytes from before, `Adapted()` true, lock gains `skill/beta@1.1.0`.
  - subtest `removed upstream item is refused`: gamma → error containing `removed upstream`, digest unchanged.
- `TestAcceptRefusesUnchangedUpstreamAndUnknownItem`; `TestAcceptBumpKinds` (`patch` → `1.0.1`, `major` → `2.0.0`, bad value → error).
- Code: `Accept` in `importer.go`, the `accept` subcommand.

**T11 Pilot import (Q2-A).**
1. Write the Leorna example to a scratch file, exactly:
   ```
   Ask: "The checkout tests started failing after this morning's merge. Find out why before changing anything."
   The assistant stops feature work, reproduces the failure, narrows it to the change that caused it, fixes the root cause and adds a regression test.
   ```
2. From the worktree root: `go run ./cmd/library-upstream import --path skills/debugging-and-error-recovery --category debugging --tags debugging,root-cause,error-recovery --tools claude-code,codex,cursor --example <scratch file>` (default `--to` = the pin, `--from` = GitHub; network read only).
3. Prove the body is verbatim: `PIN=aeac41d4d005999432bb7312f7ff06383a91d59d; git -C <bare clone> show "${PIN}:skills/debugging-and-error-recovery/SKILL.md" | tail -n +6 | cmp - internal/library/content/items/skill/debugging-and-error-recovery/body.md` (no output). The description equals the upstream frontmatter's.
4. Bump `content/library.json` to `0.3.0` (if 86bcm9016 has merged by then with `0.3.0`, use `0.4.0`).
5. `go test -count=1 ./internal/library/...` green (lock test, embedded validity, AC1, AC5). Commit the four files plus the lock.

**T12 AC7.**
- `TestAC7_DryRunSyncAgainstUpstreamHEAD` in `cmd/library-upstream/main_test.go`: `t.Skip` unless `LEORNA_TEST_UPSTREAM_NETWORK=1`; `lib := filepath.Join("..", "..", "internal", "library")`; digest it; `run([]string{"diff", "--library", lib, "--to", "HEAD"}, …)` (default `--from` = the real repository) returns nil; output has `Pinned: 0.6.13 aeac41d4d005999432bb7312f7ff06383a91d59d`, a `Target: HEAD <40 hex>` line, a row for `skills/debugging-and-error-recovery` naming `skill/debugging-and-error-recovery@1.0.0`, and the `Dry run: no library files were changed.` line; the digest is unchanged. No other assertion depends on what upstream has merged since the pin.
- RED: it fails until T8/T11 exist (run it once before T11 to see the missing pilot row fail).

**T13 Admin page; AC2** (`internal/web`).
- RED: `TestAC2_AdminConsoleShowsSourceAndLicenceForEachImportedItem` in `internal/web/third_party_content_test.go`, using `newPackFixture(t)`:
  - subtest `fixture library`: build a library with `library.Parse(fstest.MapFS{…})`: upstream `fixture-skills` (MIT, `Copyright (c) 2025 Test Author`, LICENSE text containing `"AS IS"`), imported `skill/alpha@1.0.0` (fingerprint matches → `No`), imported `agent/helper@2.0.0` (fingerprint differs → `Yes`), native `skill/native@1.0.0`. `fixture.handler.SetContentLibrary(lib)`; the admin GET of `/admin/third-party-content` is 200 `text/html`, with `Content-Security-Policy` and `Cache-Control: no-store`. For each imported item, extract its `<tr data-item="…">…</tr>` with a regexp and assert **that row** contains the upstream name, the path, the full commit, `MIT` and the copyright line, and `No`/`Yes` correctly. `skill/native` appears nowhere. The licence `<pre>` contains `template.HTMLEscapeString(licenceText)`.
  - subtest `shipped library`: `SetContentLibrary(library.Embedded())`; there is at least one imported item; every imported item has its row with `agent-skills`, its path and commit, `MIT` and `Copyright (c) 2025 Addy Osmani`.
  - subtest `member is forbidden`: member session → 403.
  - subtest `signed out is sent to sign in`: no cookies → 302 to `/v1/auth/google/login` (match how existing admin page tests assert this redirect).
- `TestThirdPartyContentUnavailableWithoutLibrary` (fresh handler from the same fixture pattern without the setter → 503 `LIBRARY_UNAVAILABLE`).
- `TestAdminHomeLinksThirdPartyContent` (the `/admin` page's nav contains the link, scoped to the session card).
- `TestEvidenceThirdPartyContentPage` (evidence only): `t.Skip` unless `LEORNA_EVIDENCE_DIR` is set; same fixture, shipped library, admin GET; writes the exact response body to `$LEORNA_EVIDENCE_DIR/ac2-third-party-content.html`. Not an AC test.
- Code: `third_party_content.go`, handler field/route/nav, `main.go` setter call.

**T14 Installer notice; AC6** (`cmd/launcher`).
- RED: `TestAC6_BuiltInstallerCarriesAgentSkillsLicenceNotice` in `cmd/launcher/installer_notice_test.go`, standard library only:
  ```go
  goTool, err := exec.LookPath("go")
  if err != nil {
  	t.Fatalf("go toolchain not on PATH: %v", err)
  }
  exe := filepath.Join(t.TempDir(), "leorna-installer-windows-amd64.exe")
  ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
  defer cancel()
  // The same build as scripts/dist.sh (make dist).
  build := exec.CommandContext(ctx, goTool, "build", "-ldflags", "-X main.version=ac6-test", "-o", exe, ".")
  build.Env = append(os.Environ(), "GOOS=windows", "GOARCH=amd64", "CGO_ENABLED=0")
  if output, err := build.CombinedOutput(); err != nil {
  	t.Fatalf("build installer: %v\n%s", err, output)
  }
  binary, err := os.ReadFile(exe)
  if err != nil {
  	t.Fatal(err)
  }
  for _, want := range []string{
  	"Copyright (c) 2025 Addy Osmani",
  	"The above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.",
  	"https://github.com/addyosmani/agent-skills",
  } {
  	if !bytes.Contains(binary, []byte(want)) {
  		t.Errorf("the built installer does not carry %q", want)
  	}
  }
  ```
  No `testing.Short()` skip (a skip in the AC log is rejected; `make test` runs it too).
- `TestNoticesModePrintsThirdPartyNotices` in `cmd/launcher/notices_test.go`: `modeFromArgs([]string{"--notices"}) == "notices"`, and `printNotices(&buf)` writes exactly `library.Embedded()`'s `ThirdPartyNotices()`.
- Code: `modeFromArgs`, a `"notices"` case in `run`, `printNotices(w io.Writer) error`; update the file's top comment with the new mode.

**T15 Module README** (`internal/library/README.md`, new section "Upstream content (86bcm945u)"): the `upstreams/<name>/` folder and its fields; the item `source` block; what "Leorna adaptation" means (description + body fingerprint; category, tags, tools and example are always Leorna's); the four subcommands with copy-paste examples (`diff --to 0.6.14`, `import`, `accept` with and without `--keep-local`, `notices`); "bump `library.json`, commit the item and `content.lock.json` together"; no schedule yet; prompts and multi-file skills are reported but not importable until 86bcm9016 / 86bcm945q; the evals decision link; the admin page route; the test names that verify each point (every README sentence true as written).

**T16 Mutation checks** (`mutation-testing-discipline`; scope each edit to the function under test, restore after, log to `mutations-<sha7>.txt`). Each must make the named test fail:
- M1 remove the adapted check in `Accept` → AC4 `adapted item is not overwritten`.
- M2 `Adapted()` always returns false (use a never-true comparison so the build still compiles) → AC3 (beta row `yes`).
- M3 skip the version bump → AC4.
- M4 keep the old `Source.Commit` on accept → AC4.
- M5 drop `requireAdmin` from the new route → AC2 `member is forbidden`.
- M6 drop `omitempty` from the checksum's `Source` field → `TestContentLockPinsEveryItemVersion` and `TestChecksumWithoutSourceIsUnchanged`.
- M7 compare tracked items against the pin instead of their own commit → `TestDiffUsesEachTrackedItemsOwnCommit`.
- M8 remove the containment check in `WriteItem` and the slug check on `--name` → `TestImportRefuses/--name ../x`.

**T17 Evidence capture** (see the next section; on the final head).

**T18 Gates on the final head** (see Gates).

**T19 Docs & records** (see the last sections). Stop at `ready-for-review`.

## Evidence capture (named build task, T17)

Folder `~/.hermes/plans/leorna/evidence/86bcm945u/` (builder at the root; the verifier writes only in `verifier/`, the auditor only in `auditor/`). Nothing evidence-related is written inside the worktree (`ac-check` fails untracked files). Terminal captures use the `leorna` skill's step 4b recipe: a dedicated Terminal window started with `osascript` running `exec env -i HOME=… PATH=… PS1='$ ' bash --norc --noprofile`, wait for the `$ ` prompt in the tab's `history` before typing, `cd` first and use relative paths, run the command, `echo "EXIT=$?"`, then `screencapture -x -o -l <window id>`. Retake on the final head if a later fix changes the output. Look at every PNG before listing it: no server domain, URL bar, token or email. Each terminal PNG gets a matching `.txt` log and `.json` receipt (`{"command","head","exit_code"}`).

| AC | State to show | When | File |
| --- | --- | --- | --- |
| AC1 | Terminal: `go test -v -count=1 -run '^TestAC1_…$' ./internal/library` → `--- PASS`, then `sed -n '/^## Content library/,$p' THIRD_PARTY_NOTICES.md` showing the MIT text and `Copyright (c) 2025 Addy Osmani`, `EXIT=0` | final head | `ac1-third-party-notices.png` |
| AC2 | The real Third-party content page: run `LEORNA_EVIDENCE_DIR=<evidence> LEORNA_TEST_DATABASE_URL=… go test -count=1 -run '^TestEvidenceThirdPartyContentPage$' ./internal/web` (the real handler's response for an admin, shipped library with the pilot), then render that HTML with headless Chrome: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --user-data-dir=<scratch>/chrome-profile --window-size=1280,1500 --screenshot=<evidence>/ac2-admin-third-party-content.png file://<evidence>/ac2-third-party-content.html`. Caption it "local rendering of the real handler response". The row shows source + licence for `skill/debugging-and-error-recovery`. Optional second capture with the fixture library showing `Yes` and `No`: `ac2-admin-third-party-content-fixture.png`. | final head | `ac2-admin-third-party-content.png` (+ `.html`) |
| AC3 | Terminal, a simulated new release: in scratch, `git clone` the real upstream (non-bare, data only) to `demo-upstream/`, then in it change the pilot's `SKILL.md` body, add `skills/demo-new-skill/SKILL.md`, delete `agents/test-engineer.md`, edit `evals/cases/interview-me.json`, commit and tag `0.6.14-demo`. Copy `internal/library` to `demo-library-adapted/` and append a line to the pilot's `body.md` there (a Leorna adaptation). Run `shasum -a 256 demo-library-adapted/content/items/skill/debugging-and-error-recovery/body.md`, then `go run <worktree>/cmd/library-upstream diff --library demo-library-adapted --from demo-upstream --to 0.6.14-demo` (shows added/changed/removed, the pilot `changed … yes … merge by hand`, the evals decision row), then the same `shasum` again (identical), `EXIT=0`. Caption: simulated release in a scratch clone. | final head | `ac3-sync-diff-report.png` |
| AC4 | Terminal, same scratch upstream, a clean copy `demo-library/`: `grep -A5 '"version"\|"commit"' …/item.json` before, `go run … accept --library demo-library --from demo-upstream --item skill/debugging-and-error-recovery --to 0.6.14-demo`, the same `grep` after (`1.0.0` → `1.1.0`, commit → the demo commit), `grep debugging demo-library/content.lock.json` (both versions), then `accept` on `demo-library-adapted` without `--keep-local` refusing with "Leorna adaptations", `EXIT=0` for the first run. | final head | `ac4-accept-version-bump.png` |
| AC5 | Terminal: `go test -v … '^TestAC5_…$' ./internal/library` → PASS, then `sed -n '1,/^## Consequences/p' adr/0002-reuse-of-agent-skills-evals.md` showing `Status: Accepted` and `Decision: reference-only`, `EXIT=0` | final head | `ac5-evals-decision.png` |
| AC6 | Terminal: `OUT=<scratch>/dist bash scripts/dist.sh` (the real `make dist` script), then `grep -c -a 'Copyright (c) 2025 Addy Osmani' <scratch>/dist/leorna-installer-windows-amd64.exe` (≥ 1), then `go test -v … '^TestAC6_…$' ./cmd/launcher` → PASS, `EXIT=0` | final head | `ac6-installer-licence-notice.png` |
| AC7 | Terminal: `go run ./cmd/library-upstream diff --to HEAD` against the real GitHub repo (header `Pinned: 0.6.13 aeac41d…`, `Target: HEAD <sha>`, the pilot row, `Dry run: …`), then `git status --porcelain internal/library` (empty), then `LEORNA_TEST_UPSTREAM_NETWORK=1 go test -v … '^TestAC7_…$' ./cmd/library-upstream` → PASS, `EXIT=0` | final head | `ac7-dry-run-upstream-head.png` |

Also: `gates-<sha7>.txt` + `.json` per head the gates ran on (a failed host-tool run stays under its own suffixed name, never overwritten by the passing rerun), `story-tests-<sha7>.txt` (`go test -v -count=1 ./internal/library/... ./cmd/library-upstream/... ./cmd/launcher/... ./internal/web/...` with the Postgres env and `LEORNA_TEST_UPSTREAM_NETWORK=1`: count PASS/SKIP/FAIL), `mutations-<sha7>.txt`, and `INVENTORY.md` mapping AC → test → result → PNG → log.

## Gates (T18, on the exact final head)

1. `make check` with `LEORNA_TEST_DATABASE_URL` set (own `_test` DB) and the 2.14.0 linter bound (`GOLANGCI_LINT=<abs path> make check`). Confirm the Postgres tests ran with a separate `go test -v` run (not `GO='go -v'`). Compare with the T0 baseline by failure identity.
2. `bash ./scripts/test-module-add.sh`.
3. Story-range secret scan: `gitleaks git --redact --log-opts="origin/main..HEAD"` (and note what full `make secrets` says about other fetched branches, by identity).
4. All seven AC commands exactly as written above, each `--- PASS` with no SKIP line.
5. `git diff --name-only origin/main...HEAD | grep '^\.github/'` prints nothing (no CI exception for this story).
6. `git diff --name-only origin/main...HEAD | grep -E '^(contracts|packages/contracts|internal/store/postgres/migrations)/'` prints nothing (no API or schema change, as planned).
7. `git status --porcelain` empty; every commit author `Justin Issa <justin@leorna.com>`.

## Choices and assumptions

- **Repo:** control plane, `internal/library` (Q1-A); the card's "content" means the content library inside it.
- **Source record lives in the embedded library** (`item.json` + `upstreams/`), not in Postgres: no migration, the console reads `library.Embedded()`. The binary shows the current version's source; older versions' source is in git history.
- **Checksum covers `source`** (`omitempty`, so existing checksums don't move). A source change needs a version bump; `accept` always bumps.
- **"Leorna adaptation" = description or body changed** since import (fingerprint in `source.upstreamSha256`). Category, tags, tools and example are Leorna's and never written by `accept`.
- **Version bump on accept defaults to minor** (`--bump` overrides).
- **The sync job is a CLI run by a person**; no schedule (no CI changes allowed). A weekly workflow is a follow-up.
- **`diff` defaults to `--to HEAD`**; a release is passed by tag (`--to 0.6.14`). No "latest release" lookup.
- **No `pin` command:** after a reviewed release, edit `release` and `commit` in `upstream.json`.
- **Prompts (`commands/*.toml`) and multi-file skills are reported but not importable** until 86bcm9016 and 86bcm945q land.
- **Upstream tag is `0.6.13`**, not `v0.6.13` as the card writes it.
- **Notice placement:** root `THIRD_PARTY_NOTICES.md`, the control-plane binary (embedded LICENSE + admin page) and the installer (`--notices`). No `Containerfile` change (the binary carries it); `cmd/distpack` unchanged (its seed has no upstream content). If 86bcm9019 later puts upstream items into `seed.json`, the portal distribution needs the notice too (README note).
- **AC6 runs inside `make test`** (one cross-compile of the launcher, roughly 30–90 s on a cold CI cache) so the installer notice can't regress silently.
- **AC7 is the only network test**, opt-in through `LEORNA_TEST_UPSTREAM_NETWORK=1`; CI skips it.
- **Code identifiers use US `License`** (SPDX/JSON convention); user-facing text uses the card's "licence".
- **`library.json` 0.2.0 → 0.3.0** for the pilot (0.4.0 if 86bcm9016 lands first).
- **Admin route `/admin/third-party-content`**, a separate page (Q4-A); it doesn't overlap 86bcm901v's likely `/admin/library…` routes.
- **CI gap (no workflow change):** the network dry run (AC7) and the headless-Chrome rendering (AC2 evidence) don't run in CI.

## Risks

- **Overlap rebases** with 86bcm9016 (open PRs #85/client #20: `library.json` version, `internal/library/README.md`, lock file), 86bcm901u-v3 (README, its gate must accept the pilot and the `upstreams/` folder) and 86bcm901v-v3 (the admin nav line in `handler.go`, route block). All are small text conflicts; see Overlaps.
- **Quality gate fit:** once 86bcm901u lands, its gate renders and secret-scans every item. The pilot is plain Markdown and should pass; if not, that's a finding for whichever lands second.
- **CI time:** AC6 adds one Windows cross-build to `make test`.
- **Upstream format drift:** a future upstream with quoted or folded descriptions, extra frontmatter keys or multi-file skills is refused with a clear message rather than guessed.
- **git version:** `--end-of-options` needs git ≥ 2.24 (CI's ubuntu-latest and this Mac's 2.50 qualify).
- **Licence scope:** files synced to engineers' tools carry no per-file attribution (Q5).
- **Untrusted upstream content:** never executed (bare clone, blob reads by id, no checkout), bounded (64 KiB per body, 50,000 tree entries, timeouts), HTML-escaped in the console. Output paths come only from validated Leorna kind/name.
- **AC2 and AC7 need setup** (own Postgres `_test` DB; network). Without them the tests skip, and `ac-check` rejects a skip, so the verifier and auditor must set both variables.

## Definition of Done mapping

| DoD item | How |
| --- | --- |
| Unit tests | T1–T7, T9–T10, T13–T14 unit tests |
| Integration tests, happy path + 1 failure | Real-git CLI tests: AC3, AC4 (happy) and `TestDiffFailsOnUnknownRevisionAndWritesNothing`, `TestImportRefuses`, AC4's refusal subtests (failure); Postgres HTTP test AC2 (happy) + member 403 / signed-out redirect / 503 (failure); AC6 real installer build |
| OpenAPI updated if the API is touched | Not touched (admin HTML page only, like `/admin/audit`); gate 6 proves no `contracts/` change; `make contracts-check` passes |
| lint/format/CI green incl. gitleaks + golangci-lint | `make check` (fmt, vet, test -race, golangci-lint 2.14.0, govulncheck, gitleaks, build) + story-range gitleaks |
| Demoable in isolation | `library-upstream diff/accept` against a scratch upstream and against real HEAD; the admin page rendered from the real handler |
| Short module README note | `internal/library/README.md` section (T15) |
| No CI changes | Gate 5 |

## Skills

- Every role: `leorna` (project rules), `engineering-best-practices`.
- Builder: `test-driven-development`, `mutation-testing-discipline` (the adaptation guard, admin guard, write containment and checksum compatibility are guards), `security-best-practices` (untrusted third-party content, git subprocesses, HTML output; Go reference `golang-general-backend-security.md`: GO-INJECT-002, GO-PATH-001, GO-XSS-001), `multi-tenant-auth-management` (light: one new admin-only route on the existing guards; no tenant data shown).
- Reviewers: `requesting-code-review` + `code-review-practice` (report only), plus `security-best-practices`.
- Fixers: `receiving-code-review`, `test-driven-development`.
- Verifier and auditor: `engineering-best-practices` + `leorna`, following `feature-dispatch/references/ac-verification.md`.
- **Agent Defect Loop:** none of the skills used here has a "Mandatory Validation and Agent Defect Loop" section. The two specialists that do, `api-contract-drift-guard` and `backend-data-migrations`, are **not used**: the story changes no API and no schema (gate 6). If a reviewer finds either is needed after all, load it and run its loop.
- Every brief carries the `skill_lessons` rule.

## Overlaps with sibling stories

| Story | State (2026-10-24) | Shared files | Parallel? | Who rebases |
| --- | --- | --- | --- | --- |
| 86bcm9016 prompt kind | CP PR #85 and client #20 open | `internal/library/content/library.json` (both bump to 0.3.0), `content.lock.json` (different, non-adjacent keys), `internal/library/README.md` (different sections) | Yes | Whoever merges second: take the next library version (0.4.0) and keep both README parts. Once 9016 is in, `prompt` exists as a kind; this story's importer still refuses prompts (follow-up for 86bcm901b). |
| 86bcm901u quality gate (v3) | Planning today | `internal/library/README.md`; maybe root `README.md`/`Makefile` (this story doesn't touch those). Its gate will check the pilot item and parse `upstreams/`. AC5's ADR tells it to port skill-lint **rules**, not run upstream code. | Yes | Second to merge. If 901u lands first, run its library check on this branch before hand-over. |
| 86bcm901v catalog browser (v3) | Planning today | `internal/web/handler.go` (the nav line at 737 and the route block), maybe `cmd/control-plane/main.go` setters | Yes (separate page and route) | Second to merge resolves the one-line nav conflict. Follow-up: 901v's item view can show the same source block by looking the item up in `library.Embedded()`. |

Downstream cards (86bcm9019 skills, 86bcm901a agents, 86bcm901b prompts) import with `library-upstream import`, which records `source` and ties it to the upstream's licence automatically. Prompts need 86bcm9016; multi-file skills need 86bcm945q.

## Docs & records (T19 and the finish step)

- **Plan copy:** at "go" the orchestrator runs `mkdir -p ~/.hermes/plans/leorna/evidence/86bcm945u && install -m 444 ~/.hermes/plans/leorna/86bcm945u-upstream-sync.md ~/.hermes/plans/leorna/evidence/86bcm945u/plan-approved.md`.
- **Code docs:** `internal/library/README.md` (T15); `adr/0002-reuse-of-agent-skills-evals.md` (T4); `THIRD_PARTY_NOTICES.md` (T3); the `cmd/library-upstream` and `cmd/launcher` top comments.
- **Evidence:** `~/.hermes/plans/leorna/evidence/86bcm945u/` with the seven PNGs, logs, receipts, gate logs, mutation log and `INVENTORY.md`.
- **Shared notes** (main session or finisher): a dated status line in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md` (branch, head, stage; and that the card's "content" repo is the control plane's `internal/library`).
- **Hand-over (finisher, `leorna` step 6):** PR text in Christian's plain style at `~/.hermes/cache/scratch/leorna-pr-86bcm945u-upstream-sync.md` (Summary, one line per area, Test Plan with this head's results, Assumptions incl. the CI gaps, security/migration (none)/rollback notes, Evidence block); the review prompt for a fresh agent; the ClickUp evidence draft `~/.hermes/plans/leorna/evidence/86bcm945u/closing-comment-draft.md` (WHAT WAS DONE / WHAT WAS VERIFIED with the AC → test → PNG table / NOT VERIFIED) and the attachment list; the short team message. Never push, open a PR or post unless Justin says "push", "make a PR" or "post".
- **After a PR exists:** add `"86bcm945u": {"name": "Upstream content sync + licence attribution", "prs": {"LeornaAI/leorna-control-plane": [<PR number>]}}` to `delivery/stories.json` in one small commit on the branch (never a guessed number); after merge, `python3 scripts/check-story-shippable.py 86bcm945u`.

## Other things found (not fixed, not folded in)

1. **Server dependency notices are missing (medium).** Root `THIRD_PARTY_NOTICES.md` says only "Server dependencies retain their respective upstream licenses" and lists none, while the control-plane image and installer are distributed binaries that include MIT/BSD Go modules (e.g. chromedp, pgx). Evidence: `git show origin/main:THIRD_PARTY_NOTICES.md`. Separate licence-compliance card.
2. **Pack items lose provenance (medium, follow-up).** Copying a library item into a tenant pack (`pack_versions`) carries no source or licence, so attribution doesn't follow imported content into packs or onto engineers' machines (Q5).
3. **Card text: wrong validator path (low).** The card names `scripts/skill-lint.js`; upstream has `scripts/lib/skill-lint.js` (`git ls-tree aeac41d scripts/`).
4. **Card text: tag name (low).** The card says "Pin v0.6.13"; the upstream tag is `0.6.13` (`git rev-parse 0.6.13^{commit}` = `aeac41d…`; `v0.6.13` doesn't resolve).
5. **Upstream HEAD equals the pin today (info).** The real dry run (AC7) currently shows no upstream change; AC3's diff is proven with a fixture and a simulated scratch release.

## Completion contract (for the builder)

Stop at `ready-for-review` with: the worktree path, branch, head SHA, base SHA, `git diff --stat origin/main..HEAD`, the AC → test → result → PNG table from `INVENTORY.md`, gate results with exit codes, mutation results, anything NOT VERIFIED with its reason, `found_else[]`, and `skill_lessons[]`. Don't push, open a PR, post to ClickUp or touch any server.
