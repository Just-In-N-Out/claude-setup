# 86bcm901b: Curate the reusable prompts collection (plan)

ClickUp [Curate the reusable prompts collection](https://app.clickup.com/t/86bcm901b) · PI-2 · E10 Content Library · Size M · p2-medium · repo `leorna-control-plane` ("content" on the card = `internal/library/content/`) · **Full** pipeline · planned 2026-10-28 14:34 EDT on the Windows desktop (WSL Ubuntu 26.04) by the Opus 5.5 planner.

**Base:** GitHub `main` = `origin/main` = **`1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`** (Merge PR #93), fetched over HTTPS through `gh` and checked against `gh api repos/LeornaAI/leorna-control-plane/commits/main` twice (18:12 and 18:34 UTC). Every code fact below was read from a `git archive` export of that SHA, never from the main checkout.

**Approval:** Justin is away and asked to keep going with the ⭐ recommendations, so this plan is approved with every ⭐ answer. Every ⭐ below is reversible before merge and inside the card's scope. Still forbidden: push, PR, ClickUp posts, merge.

## Open questions (⭐ = recommended; the plan is written as if every ⭐ was chosen)

**Q1. AC3: the pack builder (86bcm901w) is only being planned now and starter packs (86bcm901r) don't exist. How does each prompt flag the skills it needs?**
- A ⭐ A checked `requires` list in each prompt's item.json
- B A, plus a catalog column (migration + admin page)
- C Defer AC3 to 901w/901r; list the map in the README
- D Put the prompts in a provisional starter pack now

Why A: the smallest test-backed change, no migration, no API or UI, no file 901w or 901r owns. `requires` is data in the library the pack builder reads (`Library.Required`), the content lock pins it, and a dangling name fails CI. 901w's planner was told not to build this flag, only to name where it plugs in; A gives it one clean thing to read. If B: add migration 23 (`library_items.requires text[]`), store and catalog changes, and expect conflicts with 901w on `internal/web/library*.go`. If C: AC3 stays unproven. If D: edits `internal/pack/seed.json`, which 901r owns.

**Q2. What is the `plan` command's prompt called? Claude Code 2.1.312 has a built-in `/plan` (plan mode).**
- A ⭐ `planning` (upstream's TOML name), typed `/planning`
- B `plan` (the card's name); the built-in `/plan` may hide it

Evidence: the installed binary `~/.local/share/claude/versions/2.1.312` defines `name:"plan",description:"Enable plan mode or view the current session plan"`; it defines no built-in `review`, `spec`, `test`, `build`, `ship`, `constraints`, `code-simplify` or `webperf`. Upstream names the TOML form `commands/planning.toml` (only the Claude plugin's `.claude/commands/plan.md` uses `plan`). If B: pass `--name plan` to the import and replace `planning` with `plan` in the four AC tests, the examples and the README.

**Q3. `/ship` and `/webperf` call agents (code-reviewer, security-auditor, test-engineer, web-performance-auditor) that 86bcm901a brings, and the desktop client doesn't install agents yet.**
- A ⭐ Ship all 9 now; flag skills now, agents after 901a
- B Hold `/ship` and `/webperf` until 901a merges

Why A: the card asks for all 9 and AC3 is about skills. Each example says plainly which agents a prompt asks for and that the client doesn't install agents yet. `requires` accepts `agent/<name>`, so adding the agents after 901a merges is a data-only follow-up. If B: AC1 can't pass as written (9 commands), which would need Justin to amend the AC.

**Q4. This desktop has no Go toolchain, no PostgreSQL and no running Docker engine. How do the gates get a test database?**
- A ⭐ Agents run PostgreSQL 18.6 from Ubuntu's packages
- B Justin turns on Docker Desktop's WSL integration
- C Build this story on the Mac instead

Why A: Ubuntu 26.04 ships `postgresql-18` **18.6-0ubuntu0.26.04.1**, the same 18.6 CI pins (`postgres:18.6-alpine3.23`). It runs in user space (`apt-get download` + `dpkg -x`, no sudo), listens on 127.0.0.1 only, and is undone by deleting one folder. Under A, if a shared `leorna-test-pg` already answers on 127.0.0.1:5432 when the builder starts (another session or Justin set one up), the builder uses that with this story's own databases instead. If B: Justin's GUI step, then CI's image as on the Mac. If C: the Mac recipes in the `leorna` skill apply unchanged.

## Acceptance criteria

AC1–AC4 are the card's four ACs in card order (given, not proposed). AC5 is the card's Verify, which Justin named an AC; only he can run it. Each AC's test lives in its own file so the base-commit run copies only that file.

- AC1: Given the import, then the 9 upstream commands exist as `prompt` items with source commit recorded. Test `TestAC1_NineUpstreamCommandsArePromptItemsWithSourceCommit` in `internal/library/prompts_ac1_test.go`.
- AC2: Given each prompt, then it renders as the native command/prompt form for Claude Code, Codex and Cursor (or is skipped with a reason). Test `TestAC2_EachPromptRendersAsANativeCommandOrIsSkippedWithAReason` in `internal/library/render/prompts_ac2_test.go`.
- AC3: Given each prompt, then the skills it invokes are in the same starter pack or flagged as a dependency in the pack builder. Test `TestAC3_EachPromptFlagsTheSkillsItInvokesAsDependencies` in `internal/library/prompts_ac3_test.go`.
- AC4: Given each prompt, then it passed the content quality gate. Test `TestAC4_EveryPromptPassesTheContentQualityGate` in `cmd/library-gate/prompts_ac4_test.go`.
- AC5 (live): Live run of /review and /spec in Claude Code: each runs from the rendered project files and its reply follows the prompt's own instructions. Check by Justin with the folder `TestEvidencePromptsForLiveCheck` writes.

| AC | Command that runs only its test (from the worktree root) | Fails on base `1ee7157` because | Screenshot |
| --- | --- | --- | --- |
| AC1 | `go test -v -count=1 -run '^TestAC1_NineUpstreamCommandsArePromptItemsWithSourceCommit$' ./internal/library` | no prompt is imported from agent-skills: `0 prompts are imported from agent-skills, want 9` (compiles: existing API only) | `ac1-third-party-content.png` (real admin page), fallback `ac1-test-<sha7>.png` |
| AC2 | `go test -v -count=1 -run '^TestAC2_EachPromptRendersAsANativeCommandOrIsSkippedWithAReason$' ./internal/library/render` | `the library has no prompt build` … (compiles: existing API only) | `ac2-render-<sha7>.png` |
| AC3 | `go test -v -count=1 -run '^TestAC3_EachPromptFlagsTheSkillsItInvokesAsDependencies$' ./internal/library` | build failure: `prompt.Requires` / `shipped.Required` undefined (a counted base failure) | `ac3-requires-<sha7>.png` |
| AC4 | `LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks go test -v -count=1 -run '^TestAC4_EveryPromptPassesTheContentQualityGate$' ./cmd/library-gate` | `prompt/build@1.0.0 did not pass the gate` … (compiles: uses `run`, `realLibrary`, `gitleaksForTest` from `main_test.go`, present on base) | `ac4-gate-<sha7>.png` |
| AC5 (live) | Justin, steps in `evidence/86bcm901b/ac5-checklist.md` | n/a (live) | Justin's `ac5-review.png`, `ac5-spec.png` (owed) |

No AC needs `base_exempt`. Agents mark AC5 `"accepted": false, "not_run": "live: Justin runs /review and /spec in Claude Code"`; the expected `ac-check.sh` result is **READY FOR THE USER** with AC5 owed.

**The card's "quality-gate CI run":** proven locally on the exact head by `make library-check` (inside `make check`, exit 0, log in `gates-<sha7>.txt`) plus AC4's test, which runs the gate's own `run()` with gitleaks 8.30.1 (CI's version). The hosted step "Check content library quality" in the "Go quality gates" job runs only on a PR, so it stays **NOT VERIFIED** until Justin says "make a PR"; the hand-over says so.

## Playback

Import the 9 agent-skills slash commands (build, code-simplify, constraints, plan, review, ship, spec, test, webperf; MIT) into the control plane's content library as `prompt` items, through the 86bcm945u upstream sync, with the upstream commit recorded in each item's `source`. Each prompt must render natively for Claude Code and Cursor and be skipped with a reason for Codex, flag the skills it invokes so the pack builder and starter packs can install them together, and pass the 86bcm901u content quality gate. Justin then runs `/review` and `/spec` in Claude Code. Done = AC1–AC4 proven by tests on one head, the gates green, AC5 owed to Justin, and the hand-over pack ready (no push, PR or ClickUp post).

## Skills

Loaded by the planner: `leorna` (PLANNER role, Step 1 context load done), `engineering-best-practices`, `implementation-planning`, `security-best-practices` (untrusted upstream TOML is parsed, and third-party prompt text ships to every install).

Not needed, with the reason: `api-contract-drift-guard` (no OpenAPI change: `contracts/control-plane.openapi.yaml` has no library routes), `backend-data-migrations` (no schema change: Postgres compares only the stored checksum, `internal/store/postgres/library.go:57-84`), `multi-tenant-auth-management` (no tenant-facing path changes; the admin pages that list prompts already exist).

Every later role loads `leorna`, `engineering-best-practices` and `security-best-practices`; builder adds `test-driven-development` and `mutation-testing-discipline` (the TOML key guard, the source-path rule and the `requires` checks are guards); reviewers add `requesting-code-review` + `code-review-practice`; fixers/finisher add `receiving-code-review`, `git-commit-rules`, `test-driven-development`.

**Mandatory Validation and Agent Defect Loop:** none of these skills ends with that section (checked with `grep -l '^## Mandatory Validation and Agent Defect Loop'` over `~/.hermes/skills/*/*/SKILL.md`; only unused codex-imports specialists such as `api-contract-drift-guard` and `backend-data-migrations` have it).

## Facts verified (with evidence)

1. **Dependencies are merged on `origin/main`** (`gh pr list` as `Justin-Leorna`): 86bcm9016 prompt kind #85 (`58d1095e3`), 86bcm945u upstream sync #89 (`6275a4e6a`), 86bcm901u quality gate #90 (`044e2ad2d`), 86bcm945q multi-file items #91, 86bcm9019 skills #92 (`022283b2b`). ClickUp lists all three card dependencies (9016, 901u, 945u) as complete.
2. **Prompt import does not exist yet.** The 945u sync maps `commands/<name>.toml` to a `prompt` root (`internal/library/upstream/layout.go:31,54-55`) but refuses to import it: `importableKind` returns `StepNeedsPromptKind` "not importable yet: prompts need the prompt kind (86bcm9016)" (`internal/library/upstream/importer.go:138,156-157`), `Transform` refuses every kind but skill and agent (`layout.go:132-134`), and `Source.validate` rejects a source on a prompt, "source is only supported on skill and agent items" (`internal/library/library.go:244-256`). Building that is this story's core.
3. **Upstream pin.** All 25 imported skills record source commit `aeac41d4d005999432bb7312f7ff06383a91d59d` (0.6.13), and `content/upstreams/agent-skills/upstream.json` pins the same. Upstream `HEAD` is still that commit and 0.6.13 is its newest tag (bare clone, 2026-10-28). **The prompts are pinned to the same commit**, the upstream record's default, so no `--to` is passed. That matters because each prompt tells the agent to load named skills: a prompt from another commit could name a skill that was renamed, split or changed in a way the shipped skill doesn't match. AC1 asserts prompt commit = upstream pin; the skills already sit at the pin.
4. **Upstream forms.** At `aeac41d`: `.claude/commands/<name>.md` (9, Claude-only wording: `agent-skills:<skill>` plugin names, `$ARGUMENTS`, "Read CLAUDE.md"), `commands/<name>.toml` (9, tool-neutral: plain skill names as installed, "Read AGENTS.md"), `.gemini/commands/<name>.toml` (Gemini wording). The plan command's TOML file is `commands/planning.toml`. All 9 TOML files hold exactly `description` + `prompt`, one-line trimmed descriptions, LF only, bodies 520–4,568 bytes (Python `tomllib` check); gitleaks 8.30.1 `dir` finds no leaks in them.
5. **Command → skill map** (every skill name each `commands/*.toml` body contains, matched against the library; all are in `internal/library/content/items/skill/` on main, none renamed or excluded by 9019):

   | Command | Library prompt | Skills its text invokes | Agents it asks for | Other references |
   | --- | --- | --- | --- | --- |
   | build | `build` | debugging-and-error-recovery, doubt-driven-development, incremental-implementation, planning-and-task-breakdown, test-driven-development | none | SPEC.md, tasks/plan.md |
   | code-simplify | `code-simplify` | code-review-and-quality, code-simplification | none | AGENTS.md |
   | constraints | `constraints` | constraint-driven-development | none | CONSTRAINTS.md, `$ARGUMENTS` |
   | plan | `planning` (Q2) | planning-and-task-breakdown | none | tasks/plan.md |
   | review | `review` | code-review-and-quality, performance-optimization, security-and-hardening | none | |
   | ship | `ship` | shipping-and-launch | code-reviewer, security-auditor, test-engineer | `references/orchestration-patterns.md` |
   | spec | `spec` | spec-driven-development | none | SPEC.md |
   | test | `test` | browser-testing-with-devtools, test-driven-development | none | |
   | webperf | `webperf` | none | web-performance-auditor | `npx lighthouse`, `npx -p chrome-devtools-mcp` (user-run examples) |

   The library's only agents are Leorna's demo `code-reviewer` and `test-writer` (no source). 86bcm901a imports the 4 upstream agents. The client installs no agents yet: `render.NotInstalled` returns "the desktop client does not install agents yet" (`internal/library/render/render.go:106-116`).
6. **Native forms (AC2), from 9016's renderer** (`internal/library/render/prompt.go`, a copy of client PR #20): Claude Code writes `.claude/commands/<name>.md` with frontmatter `description: <JSON-quoted>` and `disable-model-invocation: true` (only the user can run it) then the trimmed body (`prompt.go:49-77`); Cursor writes `commands/<name>.md` under the Cursor home, body only (`prompt.go:79-90`); Codex writes nothing and warns `prompt "<name>" is not installed for codex: Codex removed custom prompts in 0.117.0 and has no prompt location; skipped` (`prompt.go:20,37-47`). So every prompt renders natively for Claude Code and Cursor and is skipped with a reason for Codex. A one-prompt pack renders exactly one file for Claude Code and Cursor and none for Codex.
7. **The gate** renders every item for all three tools whatever `tools` declares (`internal/library/gate/gate.go:206-268`): a prompt on Codex is `skipped` with the reason above. The job summary shows an undeclared tool as "not declared" (`gate/report.go:154-163`); the JSON report keeps the status and reason.
8. **Postgres stores no item metadata beyond its columns and the checksum** (`internal/store/postgres/library.go:57-84`): a new `item.json` field needs no migration, and a changed checksum without a version bump is still caught. `content.lock.json` pins every item version's checksum.
9. **AC3's targets don't exist.** ClickUp: 86bcm901w "Create a pack by picking library items" is **to do**, no linked PRs; 86bcm901r "Role-based starter packs" is **to do**, no linked PRs. Git: no `feat/86bcm901r-*` branch; `feat/86bcm901w-create-pack` has a worktree (another session, created 2026-10-28) at `1ee7157` with **no commits** and no plan file yet. Its planner brief says: don't build 901b's dependency flag, name where it would plug in and list it as a follow-up. 901r's card proposes (to confirm) Backend = … + /spec /plan /build /test /review, Frontend = … + /webperf, Platform/DevOps = … + /ship, Secure coding = … + /review; /code-simplify and /constraints are in no proposed pack.
10. **Admin pages pick the prompts up with no code change:** `/admin/third-party-content` lists every item with a `source` (`internal/web/third_party_content.go:76-86`), so the 9 prompts appear with `commands/<x>.toml` and their commit; the library catalog (901v) lists prompts by kind.
11. **9019's review test covers skills only** (`internal/library/curation_test.go:99`), so prompts don't break it. ADR 0003 anticipates this story: "upstream slash commands such as `/build` … prompts (86bcm901b) … bring them later".
12. **Tests that pin today's refusal and must change with the feature:** `internal/library/upstream/diff_test.go:205` (the `not importable yet` row), `cmd/library-upstream/main_test.go:330` (`TestImportRefuses` "a prompt" case expecting `86bcm9016`), `internal/library/item_source_test.go:202` (the "source is only supported on skill and agent items" message).
13. **Machine (WSL desktop, 2026-10-28):** no `go` anywhere on disk, no PostgreSQL, the `docker` CLI isn't wired into this distro and the Windows Docker engine isn't running (`dockerDesktopLinuxEngine` pipe missing); gitleaks **8.30.1** at `/usr/local/bin/gitleaks`; Chrome for Testing **156.0.8078.47** at `~/.cache/chrome-for-testing/chrome-linux64/chrome` starts only with `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, and its `--headless=new --screenshot` hung (exit 124 at 45 s and 90 s, only dbus errors) in the planner's probe. CI pins Go from `go.work` (1.27.3), golangci-lint **2.14.0** (sha256 `ab90aeb7b066f92a33415b638a50fe5344bbb75a0d32ad30cc248d88f81032ab`), govulncheck **v1.7.0**, gitleaks 8.30.1.

## Design

### D1. Each prompt is imported from `commands/<name>.toml`

The 945u layout already makes `commands/<name>.toml` the prompt root, and its text names skills exactly as a Leorna install names them (`Invoke the code-review-and-quality skill`), while the `.claude/commands/*.md` form names plugin skills (`agent-skills:code-review-and-quality`) that don't exist in a Leorna install. The renderer builds the Claude Code form from the one body. Item description = the TOML `description`; item body = the TOML `prompt` string verbatim (after the existing CRLF→LF step). Prompts are imported verbatim (ADR 0003's default), so every upstream update is one `accept`.

### D2. Prompt import in the 945u sync

- `upstream.Transform(pack.KindPrompt, name, raw)` parses the TOML with `github.com/BurntSushi/toml` (already a direct dependency, v1.6.0; no `go.mod` change) after the existing UTF-8, NUL and 64 KiB checks. It accepts exactly the keys `description` and `prompt`, both strings. Anything else is refused with `ErrNotImportable`: another key or a table, a missing key, a non-string value, invalid TOML, a description that is empty, has surrounding spaces, spans lines or exceeds `pack.MaxDescriptionRunes`, or an all-blank prompt. Parser errors are not echoed (they can quote upstream bytes to the terminal).
- `importableKind`: `GroupPrompt` → `pack.KindPrompt`. Delete `StepNeedsPromptKind`. The `diff` report then shows prompt roots as `available to import`, and `accept` suggests itself for changed imported prompts with no other change.
- `library.Source.validate`: a prompt's source path must be `commands/<slug>.toml`; message for others becomes "source is only supported on skill, agent and prompt items".
- `ImportOptions.Requires` and the CLI flag `--requires kind/name,...` (optional, comma-separated) set the new item's `requires` (D3). `accept` keeps the current `requires`.
- `asImported`, `AdaptationDiff`, `Diff` and the network test `TestShippedImportsMatchTheRealUpstream` are kind-agnostic and cover prompts once `importableKind` accepts them.

### D3. `requires`: the dependency flag (Q1 ⭐A)

- New optional `item.json` field `requires`: a list of `kind/name` references, `kind` ∈ {`skill`, `agent`}. When present it holds 1 to `MaxRequires` (32) entries, sorted and unique, each a valid slug name, never the item itself (`Item.Validate`). Every reference must name an item in the same library (`Library.Validate`, so `Parse`, the startup load, the gate and the sync tool all refuse a dangling name). Allowed on any kind; this story sets it only on the 9 prompts, listing skills only (Q3 ⭐A).
- `Item.Requires []string`; `itemMeta.Requires` with `json:"requires,omitempty"`; written by `upstream/write.go` between `description` and `source`.
- `Item.Checksum` appends `Requires []string json:"requires,omitempty"` after `Files`, so every existing item's checksum is unchanged (proved by `TestContentLockPinsEveryItemVersion`) and a changed `requires` needs a version bump like any field.
- `func (library Library) Required(item Item) []Item` returns the referenced items in `requires` order. This is the pack builder's (901w) and starter packs' (901r) entry point.
- Not stored in Postgres (like `source`); the catalog doesn't show it. 901w reads it from `library.Embedded()`; a column is a follow-up only if 901w needs it from the database.

### D4. The nine items (all version `1.0.0`, `tools` = `claude-code,cursor` like 9016's `pr-description`, upstream `agent-skills` at the pin)

| Item | `--path` | `--category` | `--tags` | `--requires` (sorted) | Expected `upstreamSha256` |
| --- | --- | --- | --- | --- | --- |
| `build` | `commands/build.toml` | `engineering` | `implementation,tdd` | `skill/debugging-and-error-recovery,skill/doubt-driven-development,skill/incremental-implementation,skill/planning-and-task-breakdown,skill/test-driven-development` | `30860c36492d6c474e7b6919ef23052dbd53dff878b3eef6db5e4c1f79092143` |
| `code-simplify` | `commands/code-simplify.toml` | `code-quality` | `refactoring,simplicity` | `skill/code-review-and-quality,skill/code-simplification` | `a24e7f087f0c5c1ada29dde17d3fab6304e9137c51b83d517d72f9730e922158` |
| `constraints` | `commands/constraints.toml` | `engineering` | `quality,constraints` | `skill/constraint-driven-development` | `80746629e9ca7ac0edb3d0cebd8f91b0d12988c2c2acfde2dea4a3ba06fc652b` |
| `planning` | `commands/planning.toml` | `planning` | `planning,tasks` | `skill/planning-and-task-breakdown` | `af18ead13c71129e1be9514c8519eec1cb8f5db5b491fc8551c94d284a0356dc` |
| `review` | `commands/review.toml` | `code-quality` | `code-review,pull-requests` | `skill/code-review-and-quality,skill/performance-optimization,skill/security-and-hardening` | `7d5ddf2c81f07d4ff12a5a01ae6d1be5d72e8b81e1daf07011f55bd20284cde6` |
| `ship` | `commands/ship.toml` | `operations` | `release,launch` | `skill/shipping-and-launch` | `1d294bf5ab2d25100248a453f9fbb269055b3e14bfa66e3e2b215f975883f070` |
| `spec` | `commands/spec.toml` | `planning` | `specs,requirements` | `skill/spec-driven-development` | `09e9e83aada49489ff949a2e436556d276349f44870581ed571528f3790b975a` |
| `test` | `commands/test.toml` | `testing` | `tdd,tests` | `skill/browser-testing-with-devtools,skill/test-driven-development` | `dfb6ed8744d80e46a01ad8e67efb235dd2deb46535134626e13a986889625890` |
| `webperf` | `commands/webperf.toml` | `performance` | `performance,web` | (none: flag omitted) | `9c1e47fa6d1da1ec011452af6920e28f79b1a8c0561829b52fd26a861dfff6fb` |

Upstream git blob ids at `aeac41d` (the builder checks its mirror against them): build `b7a4f7f1f6ab193c3abb75690bb9df7a88024371`, code-simplify `926442b958f1f89b2b5ecdc04b4b79896b4dbf2b`, constraints `409b0093771929a20a91670d53cd057db712f4da`, planning `53a88075533c6b8b2933a48b4ca92e9d1da49be7`, review `1810870ae39bd0add7d903abbb0f94f0a2efdd99`, ship `de2f9956c2c5e4d840ecab0bed30327e775de96a`, spec `799f682b0fe450bade82da5b63a51d7817f22acd`, test `73e36f53ed289bc01d24a69c89907e32605fb519`, webperf `3532ec69d198a5d0b7e24920f50cb3e21dd41cc0`.

The expected fingerprints are an independent oracle: the planner computed `sha256` of Go's `json.Marshal({"description","body"})` from the upstream bytes with Python (HTML-escaping `<`, `>`, `&` as Go does), and the same method reproduced the recorded `upstreamSha256` of all 11 unadapted single-file skills on main. If the builder's import disagrees with this table, prove which side is right with `TestShippedImportsMatchTheRealUpstream` (network) before changing either; don't edit the table to match.

**`example.md` texts** (Leorna's; the builder writes each to `<scratch>/examples/<item>.md` exactly, LF endings, and passes it with `--example`):

- `build`: `Type /build in Claude Code or Cursor once a plan exists: the assistant implements the next task test-first and commits it. /build auto runs every task after one approval.` + blank line + `It uses the skills incremental-implementation, test-driven-development, planning-and-task-breakdown, debugging-and-error-recovery and doubt-driven-development, so put them in the same pack. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `code-simplify`: `Type /code-simplify in Claude Code or Cursor after a change works: the assistant simplifies the recent code without changing what it does and runs the tests after each step.` + blank line + `It uses the skills code-simplification and code-review-and-quality, so put them in the same pack. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `constraints`: `Type /constraints in Claude Code or Cursor to set this repository's quality bar: the assistant reads what is there, asks at most four questions and writes CONSTRAINTS.md. /constraints check, guard and ratchet run or tighten the bar later.` + blank line + `It uses the skill constraint-driven-development, so put it in the same pack. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `planning`: `Type /planning in Claude Code or Cursor after writing a spec: the assistant breaks the work into small tasks with acceptance criteria and saves tasks/plan.md and tasks/todo.md without changing code.` + blank line + `It uses the skill planning-and-task-breakdown, so put it in the same pack. It is named /planning, like upstream's TOML form, because Claude Code has a built-in /plan. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `review`: `Type /review in Claude Code or Cursor with your changes staged or committed: the assistant reviews them for correctness, readability, architecture, security and performance and labels each finding Critical, Required, Optional or Nit with its file and line.` + blank line + `It uses the skills code-review-and-quality, security-and-hardening and performance-optimization, so put them in the same pack. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `ship`: `Type /ship in Claude Code or Cursor before a release: the assistant runs a pre-launch check and ends with a go or no-go decision and a rollback plan.` + blank line + `It uses the skill shipping-and-launch, so put it in the same pack. It also asks for three agents, code-reviewer, security-auditor and test-engineer; the desktop client does not install agents yet, so the assistant does those reviews in the main session, as the prompt describes. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `spec`: `Type /spec in Claude Code or Cursor with an idea: the assistant asks about the goal, users, features, stack and boundaries, then writes SPEC.md and asks you to confirm it before any code.` + blank line + `It uses the skill spec-driven-development, so put it in the same pack. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `test`: `Type /test in Claude Code or Cursor for a feature or a bug: the assistant writes a failing test first, makes it pass and runs the suite; for a bug it first proves the bug with a test.` + blank line + `It uses the skills test-driven-development and browser-testing-with-devtools, so put them in the same pack. Codex does not receive prompts: it removed custom prompts in 0.117.0.`
- `webperf`: `Type /webperf in Claude Code or Cursor on a web app: the assistant audits its performance from the source code, or from a Lighthouse, PageSpeed or DevTools report you give it.` + blank line + `It invokes no skill. It asks for the web-performance-auditor agent, which the desktop client does not install yet. Codex does not receive prompts: it removed custom prompts in 0.117.0.`

### D5. A review record for each prompt (consistency with ADR 0003)

`internal/library/curation/curation.json` gains `"prompts"`: one review per shipped imported prompt version, the same shape as a skill review (`curation.SkillReview`: item, version, origin `upstream`, owner `Justin Issa`, reviewedOn, one answer per checklist id, notes; no `adaptation`, since all 9 are verbatim). `library.Curation` gets `Prompts []SkillReview json:"prompts,omitempty"`. For a prompt the checklist reads: `format` (the description says what it does), `accuracy`, `safety` (9019's rule; see below), `scripts` = `n/a`, `portability`, `links` (every skill it names ships in the library and is in `requires`; agents and files a Leorna install lacks are named in the notes), `tool-fit` (renders and passes the gate for Claude Code and Cursor; Codex skipped by design), `licence`. Each review's notes must mention:
- `build`: per-task commits only after tests pass; stops before auth, migrations, deploys, secrets; `/build auto` relies on the command receiving its argument.
- `constraints`: installs the tools a user picks (Semgrep, gitleaks, osv-scanner …) and adds package.json scripts only at the user's request (Justin's sample-config ruling); `$ARGUMENTS` is substituted by Claude Code, literal in Cursor.
- `ship`: asks for 3 agents a Leorna install lacks (86bcm901a; client installs no agents yet); `references/orchestration-patterns.md` does not resolve beside a prompt (the file ships inside `doubt-driven-development`'s folder); kept verbatim because it's an optional "see also", not a step the command needs.
- `webperf`: no skill; asks for `web-performance-auditor` (86bcm901a); its `npx lighthouse …` and `npx -p chrome-devtools-mcp …` lines are commands the user runs to produce a report (one-off, user-asked: accepted by 9019's rule). Per `security-best-practices`, read them as `npx -y <pkg>@latest`: check `npm view lighthouse name maintainers` and `npm view chrome-devtools-mcp name maintainers` (both Google packages; never run them) and record what you saw.
- every prompt: renders with `disable-model-invocation: true` in Claude Code, so it runs only when a user types it.

### D6. Text that goes stale when prompts ship

- `curation.json` notes of `skill/constraint-driven-development`, `skill/doubt-driven-development` and `skill/planning-and-task-breakdown` say the library "does not ship yet" the slash commands (86bcm901b). Change only that clause to say the library now ships them as prompts (86bcm901b; `/plan` as `/planning`); keep the rest, the version and `reviewedOn`. In doubt-driven-development's note keep "agents 86bcm901a" as still missing.
- `internal/library/upstream_skills_test.go:45` comment: "Agents (86bcm901a) and prompts (86bcm901b) … come later" → "Prompts (86bcm901b) are checked by their own tests; agents (86bcm901a) come later."
- `internal/library/README.md`: see task B11. ADR 0003 stays as written (a record of the decision at its time).

### D7. What does not change

OpenAPI, Postgres schema/migrations, the seed pack (`internal/pack/seed.json`, 901r's), the upstream record and `LICENSE`, `THIRD_PARTY_NOTICES.md` (the `notices` output is unchanged because the pin is unchanged; the existing `TestAC1_ThirdPartyNoticesIncludeAgentSkillsMITLicence` proves it), the client renderers, CI (`.github/` must stay untouched), ADRs.

## Choices (made by the planner; Justin can overrule any at review)

1. Source form `commands/*.toml` (D1), not `.claude/commands/*.md`.
2. `tools` = `claude-code,cursor` for every prompt, like `pr-description`: Codex has no prompt location, and the AC2 test and the gate's JSON report still show Codex skipped with its reason.
3. Prompts imported verbatim; no adaptation (ADR 0003). `/ship`'s unresolved `references/…` pointer is noted, not adapted.
4. `requires` is data in `item.json` (checksummed, validated), not a Postgres column (Q1 ⭐A).
5. Prompt review records in `curation.json` (D5): the user story asks for "approved" prompts and 9019 made the review record the approval trail.
6. `content/library.json` 0.5.0 → **0.6.0** (new items).
7. No ADR (avoids an ADR-number clash with siblings); the README carries the design.

## Assumptions

- The pack builder (901w) will read prompt dependencies from the library (`Library.Required`); if its plan names another plug-in point, `requires` is still the data it reads, and the finisher notes the plug-in point in the PR's follow-ups.
- Claude Code passes `/build auto`'s argument to the prompt text (upstream's design); not proven here and not an AC.
- The 9 agent-skills skills each prompt needs keep the names they have at `aeac41d`.
- No Leorna server is needed: AC5 runs from rendered files in a throwaway project.

## Worktree, branch and environment (task B0)

**B0.1 Fresh main and the worktree** (the `leorna-update-main-before-worktree` note; never `checkout`, `switch`, `pull` or `reset` in the main checkout):

```bash
MAIN=~/Leorna/leorna-control-plane
W=$MAIN/.claude/worktrees/86bcm901b-prompts-collection
git -C "$MAIN" -c credential.helper= -c 'credential.helper=!gh auth git-credential' \
  fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main
BASE=$(git -C "$MAIN" rev-parse origin/main)
test "$BASE" = "$(gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha)" || { echo "origin/main != GitHub main"; exit 1; }
test "$(git -C "$MAIN" symbolic-ref --short HEAD)" = main || { echo "main checkout not on main: stop"; exit 1; }
test -z "$(git -C "$MAIN" status --porcelain --untracked-files=no)" || { echo "tracked changes in main checkout: stop"; exit 1; }
git -C "$MAIN" merge --ff-only origin/main || { echo "ff-only refused: stop and report"; exit 1; }
test ! -e "$W" || { echo "$W already exists: stop"; exit 1; }
git -C "$MAIN" worktree add -b feat/86bcm901b-prompts-collection "$W" "$BASE"
test "$(git -C "$MAIN" rev-parse main)" = "$BASE" && test "$(git -C "$W" rev-parse HEAD)" = "$BASE" && echo "main = origin/main = worktree HEAD = $BASE"
```

If `$BASE` is not `1ee7157…`, run `git -C "$MAIN" diff --stat 1ee7157 "$BASE" -- internal/library cmd/library-upstream cmd/library-gate delivery THIRD_PARTY_NOTICES.md`. If a sibling (901a/901j/901w) already merged changes there, re-check before coding: the `library.json` target (next minor above main's), lock and curation edits, and whether `Source.validate`, `importer.go`, `write.go` or `curation.go` changed shape; report any conflict with this plan instead of guessing.

**B0.2 Story environment** in `~/.cache/leorna-86bcm901b/` (create with `mkdir`; if it exists, reuse it only if its `OWNER` file says `86bcm901b`). If the main session's brief names a shared toolchain or Postgres already set up for the sibling stories, use that instead (with this story's own databases) and skip the matching step.

```bash
ENV=~/.cache/leorna-86bcm901b; mkdir "$ENV" && echo 86bcm901b > "$ENV/OWNER"; mkdir "$ENV/bin"
# Go 1.27.3 (go.work), checksum from go.dev's own list
curl -fsSL 'https://go.dev/dl/?mode=json&include=all' -o "$ENV/go-dl.json"
SUM=$(python3 -I -c "import json,sys;print([f['sha256'] for r in json.load(open(sys.argv[1])) if r['version']=='go1.27.3' for f in r['files'] if f['filename']=='go1.27.3.linux-amd64.tar.gz'][0])" "$ENV/go-dl.json")
curl -fsSL https://go.dev/dl/go1.27.3.linux-amd64.tar.gz -o "$ENV/go.tgz" && echo "$SUM  $ENV/go.tgz" | sha256sum --check --strict && tar -xzf "$ENV/go.tgz" -C "$ENV"
export PATH="$ENV/go/bin:$ENV/bin:$PATH" GOTOOLCHAIN=local
# golangci-lint 2.14.0, CI's URL and checksum
curl -fsSL https://github.com/golangci/golangci-lint/releases/download/v2.14.0/golangci-lint-2.14.0-linux-amd64.tar.gz -o "$ENV/gl.tgz"
echo "ab90aeb7b066f92a33415b638a50fe5344bbb75a0d32ad30cc248d88f81032ab  $ENV/gl.tgz" | sha256sum --check --strict
tar -xzf "$ENV/gl.tgz" -C "$ENV" && cp "$ENV/golangci-lint-2.14.0-linux-amd64/golangci-lint" "$ENV/bin/"
GOBIN="$ENV/bin" go install golang.org/x/vuln/cmd/govulncheck@v1.7.0
go version; "$ENV/bin/golangci-lint" --version; "$ENV/bin/govulncheck" -version; /usr/local/bin/gitleaks version
```

PostgreSQL 18.6 in user space (Q4 ⭐A), unless a shared server answers on 127.0.0.1:5432:

```bash
mkdir "$ENV/pg" && cd "$ENV/pg" && apt-get download postgresql-18 postgresql-client-18 libpq5 && for d in *.deb; do dpkg -x "$d" root; done
BIN=$ENV/pg/root/usr/lib/postgresql/18/bin; export LD_LIBRARY_PATH=$ENV/pg/root/usr/lib/x86_64-linux-gnu
ldd "$BIN/postgres" "$BIN/initdb" | grep 'not found'   # fetch each missing library's package the same way, then re-check; stop if one has no package
( umask 077; head -c 24 /dev/urandom | base64 | tr -d '/+=' > "$ENV/pg/password" )   # never print it
"$BIN/initdb" -D "$ENV/pg/data" -U leorna --auth=scram-sha-256 --pwfile="$ENV/pg/password" -E UTF8 --locale=C.UTF-8
PORT=$(for p in $(seq 55400 55499); do ss -ltnH "sport = :$p" | grep -q . || { echo "$p"; break; }; done); [ -n "$PORT" ] || exit 1
echo "PORT=$PORT" > "$ENV/pg/pg.env"; mkdir "$ENV/pg/sock"
"$BIN/pg_ctl" -D "$ENV/pg/data" -l "$ENV/pg/server.log" -o "-c listen_addresses=127.0.0.1 -c port=$PORT -c unix_socket_directories=$ENV/pg/sock" start
PGPASSWORD="$(cat "$ENV/pg/password")" "$BIN/createdb" -h 127.0.0.1 -p "$PORT" -U leorna leorna_86bcm901b_test
```

If `initdb` can't find its share files, pass `-L "$ENV/pg/root/usr/share/postgresql/18"`. Any environment step that fails: stop and report the exact error; never change product code, `go.mod` or CI to work around it. Later roles start the server if `pg_ctl status` says it is stopped and create their own database in it; the finisher leaves it stopped and lists `~/.cache/leorna-86bcm901b/` for Justin to delete.

**Databases (all end in `_test`; never a sibling's):** builder `leorna_86bcm901b_test`, base baseline `leorna_86bcm901b_base_test`, AC1 admin-page demo `leorna_86bcm901b_demo_test`, then one per later role: `leorna_86bcm901b_review1_test`, `_fix1_test`, `_review2_test`, `_fix2_test`, `_verify_test`, `_audit_test`, `_finish_test`. Gate scripts read the password from the file into the URL inside the script and abort when it is empty; never echo the URL.

**B0.3 Upstream mirror** (data only: never checked out, never run; in the builder's own scratch folder `<scratchpad>/86bcm901b-builder/`, created with `mkdir`, no `-p`):

```bash
S="$SCRATCHPAD/86bcm901b-builder"   # SCRATCHPAD = this session's Claude Code scratchpad directory; the folder is created with mkdir (no -p)
mkdir "$S/upstream" "$S/tmp" "$S/examples"
git clone --bare --quiet https://github.com/addyosmani/agent-skills.git "$S/upstream/agent-skills.git"
git -C "$S/upstream/agent-skills.git" rev-parse --verify 'aeac41d4d005999432bb7312f7ff06383a91d59d^{commit}'
for f in build code-simplify constraints planning review ship spec test webperf; do echo "$f $(git -C "$S/upstream/agent-skills.git" rev-parse aeac41d4d005999432bb7312f7ff06383a91d59d:commands/$f.toml)"; done   # must equal the D4 blob list
```

The sync tool clones `--from` into `os.MkdirTemp("")`; run it with `TMPDIR=$S/tmp` so that clone stays in scratch.

**B0.4 Screenshot method probe** (before any capture). Make a probe page `<pre>probe EXIT=0</pre>` and get a PNG from it by the first of these that works, then record the working recipe in `evidence/86bcm901b/EVIDENCE.md`:
1. chromedp (the repo's browser driver, `github.com/chromedp/chromedp v0.16.0`) from a scratch Go module in `$S/shot/` (`go mod init shot && go get github.com/chromedp/chromedp@v0.16.0`), with `chromedp.ExecPath(~/.cache/chrome-for-testing/chrome-linux64/chrome)`, `chromedp.Env("LD_LIBRARY_PATH=…/chrome-libs/root/usr/lib/x86_64-linux-gnu")`, headless, `--no-sandbox`, a throwaway user-data dir, and `chromedp.FullScreenshot`;
2. the same with `DBUS_SESSION_BUS_ADDRESS=disabled:`;
3. Chrome for Testing's `chrome-headless-shell` 156 for linux64, downloaded into `$ENV`.
If none produces a PNG, the AC screenshots are owed: report it, never stage one. A log screenshot is a `<pre>` page holding the HTML-escaped log (command, test output, `EXIT=` line), labelled with the head SHA.

**B0.5 Base baseline** in a separate detached worktree (never the story worktree), own DB `leorna_86bcm901b_base_test`: `git -C "$MAIN" worktree add --detach $S/base-1ee7157 "$BASE"`, run the full gate script there once, keep `$S/base-gates.txt`, then `git -C "$MAIN" worktree remove --force $S/base-1ee7157`. Any failure there is a pre-existing machine or baseline failure; compare by test identity later.

## Tasks in build order (test-first)

Each task: write the test, run it and see the intended failure (not a compile error, except where noted), make the smallest change, run it green, then the package tests. Commits are scoped, `feat(86bcm901b): …` or `test(…)`/`docs(…)`, plain `git commit` (identity from the repo config, `Justin Issa <justin@leorna.com>`), no AI attribution lines. Paths are relative to the worktree.

### B1. A prompt can carry an upstream source (`library.go`)

Test first, new file `internal/library/prompt_source_test.go` (package `library`), using `sourcedTree()`, `testCommit` and `replaceMeta` from `item_source_test.go`:

```go
package library

import (
	"errors"
	"strings"
	"testing"
	"testing/fstest"
)

// promptSourcedTree adds an imported prompt to sourcedTree (story 86bcm901b).
func promptSourcedTree() fstest.MapFS {
	tree := sourcedTree()
	tree["items/prompt/plan/item.json"] = &fstest.MapFile{Data: []byte(`{"version":"1.0.0","category":"planning","tags":["planning"],"tools":["claude-code"],"description":"Plan.",` +
		`"source":{"upstream":"fixture-skills","path":"commands/plan.toml","commit":"` + testCommit + `","upstreamSha256":"` + ImportedContentSHA256("Plan.", "Plan it.\n") + `"}}`)}
	tree["items/prompt/plan/body.md"] = &fstest.MapFile{Data: []byte("Plan it.\n")}
	tree["items/prompt/plan/example.md"] = &fstest.MapFile{Data: []byte("Type /plan.\n")}
	return tree
}

func TestParseReadsPromptSource(t *testing.T) {
	library, err := Parse(promptSourcedTree())
	if err != nil {
		t.Fatalf("Parse: %v", err)
	}
	for _, item := range library.Items {
		if item.Key() == "prompt/plan@1.0.0" {
			if item.Source == nil || item.Source.Path != "commands/plan.toml" || item.Adapted() {
				t.Fatalf("prompt source = %+v, adapted %v", item.Source, item.Adapted())
			}
			return
		}
	}
	t.Fatal("prompt/plan@1.0.0 missing")
}

func TestParseRejectsMalformedPromptSource(t *testing.T) {
	const meta = "items/prompt/plan/item.json"
	for name, path := range map[string]string{
		"a skills path":      "skills/plan",
		"a Markdown command": "commands/plan.md",
		"a path climbing out": "commands/../plan.toml",
		"a nested path":      "commands/x/plan.toml",
	} {
		t.Run(name, func(t *testing.T) {
			tree := promptSourcedTree()
			replaceMeta(tree, meta, `"commands/plan.toml"`, `"`+path+`"`)
			_, err := Parse(tree)
			if !errors.Is(err, ErrInvalid) || !strings.Contains(err.Error(), "prompt/plan") ||
				!strings.Contains(err.Error(), "source path for a prompt must be commands/<name>.toml") {
				t.Fatalf("Parse error = %v", err)
			}
		})
	}
}
```

RED: `go test -count=1 -run 'PromptSource' ./internal/library` fails with "source is only supported on skill and agent items". Then in `Source.validate` (`library.go:244-256`) add before `default`:

```go
	case pack.KindPrompt:
		if !validUpstreamRoot(source.Path, "commands/", ".toml") {
			return invalid(where, "source path for a prompt must be commands/<name>.toml")
		}
	default:
		return invalid(where, "source is only supported on skill, agent and prompt items")
```

Update `item_source_test.go:202`'s expected message to "source is only supported on skill, agent and prompt items" (the config case stays a refusal). Fix the doc comment on `Source.Path`. GREEN: `go test -count=1 ./internal/library`.

### B2. Items can name the items they require (`requires`)

Test first, new file `internal/library/requires_test.go` (package `library`), using `validTree()` and `setMeta` from `library_test.go`:

```go
package library

import (
	"errors"
	"slices"
	"strings"
	"testing"
)

const writeTestsMeta = "items/skill/write-tests/item.json"

func TestParseReadsRequires(t *testing.T) {
	tree := validTree()
	setMeta(tree, writeTestsMeta, `"requires":["agent/reviewer","mcp_template/github"],`)
	if _, err := Parse(tree); err == nil || !strings.Contains(err.Error(), "requires entries must be skill/<name> or agent/<name>") {
		t.Fatalf("an MCP template requirement parsed: %v", err)
	}
	tree = validTree()
	setMeta(tree, writeTestsMeta, `"requires":["agent/reviewer"],`)
	library, err := Parse(tree)
	if err != nil {
		t.Fatalf("Parse: %v", err)
	}
	var item Item
	for _, candidate := range library.Items {
		if candidate.Key() == "skill/write-tests@1.0.0" {
			item = candidate
		}
	}
	if !slices.Equal(item.Requires, []string{"agent/reviewer"}) {
		t.Fatalf("requires = %v", item.Requires)
	}
	required := library.Required(item)
	if len(required) != 1 || required[0].Key() != "agent/reviewer@2.1.0" {
		t.Fatalf("Required = %v", required)
	}
	without := item
	without.Requires = nil
	if item.Checksum() == without.Checksum() {
		t.Fatal("requires is not covered by the checksum")
	}
}

func TestParseRejectsMalformedRequires(t *testing.T) {
	cases := map[string]struct{ requires, want string }{
		"an empty list":          {`[]`, "requires must list 1 to 32 items when present"},
		"an item outside the library": {`["skill/missing"]`, "requires skill/missing, which is not in this library"},
		"a config":               {`["config/settings"]`, "requires entries must be skill/<name> or agent/<name>"},
		"no kind":                {`["reviewer"]`, "requires entries must be skill/<name> or agent/<name>"},
		"a path in the name":     {`["skill/../reviewer"]`, "requires entries must be skill/<name> or agent/<name>"},
		"itself":                 {`["skill/write-tests"]`, "an item cannot require itself"},
		"out of order":           {`["skill/zeta","agent/reviewer"]`, "requires entries must be sorted and unique"},
		"a duplicate":            {`["agent/reviewer","agent/reviewer"]`, "requires entries must be sorted and unique"},
		"too many":               {`[` + strings.Repeat(`"agent/a",`, 32) + `"agent/b"]`, "requires must list 1 to 32 items when present"},
	}
	for name, testCase := range cases {
		t.Run(name, func(t *testing.T) {
			tree := validTree()
			setMeta(tree, writeTestsMeta, `"requires":`+testCase.requires+`,`)
			_, err := Parse(tree)
			if !errors.Is(err, ErrInvalid) || !strings.Contains(err.Error(), "skill/write-tests") || !strings.Contains(err.Error(), testCase.want) {
				t.Fatalf("Parse error = %v, want ErrInvalid naming skill/write-tests with %q", err, testCase.want)
			}
		})
	}
}
```

(RED here is a build failure, `Requires`/`Required` undefined: expected for a new field.) Also add `func(item *Item) { item.Requires = []string{"agent/reviewer"} },` to `TestChecksumCoversEveryField` (`library_test.go:192-200`).

Implementation (`internal/library/library.go`, `source.go`):

```go
// in the bounds const block
	MaxRequires = 32

// in Item, after Source
	// Requires names the library items this item needs installed beside it,
	// as sorted "kind/name" references to skills or agents (story 86bcm901b:
	// the skills a prompt invokes). The pack builder (86bcm901w) and starter
	// packs (86bcm901r) read it through Library.Required. PostgreSQL stores
	// only the checksum that covers it.
	Requires []string

// in Checksum's struct, after Files (and item.Requires appended to the literal)
		// omitempty keeps the checksum of an item without requirements exactly
		// as it was before requirements existed (story 86bcm901b).
		Requires []string `json:"requires,omitempty"`

// in Item.Validate, immediately before `if item.Source != nil {`
	if err := validateRequires(where, item.Requires); err != nil {
		return err
	}

// validateRequires checks the format of an item's requirements. Library.Validate
// checks that each one names an item in the library.
func validateRequires(where string, requires []string) error {
	if requires == nil {
		return nil
	}
	if len(requires) == 0 || len(requires) > MaxRequires {
		return invalid(where, fmt.Sprintf("requires must list 1 to %d items when present", MaxRequires))
	}
	previous := ""
	for _, ref := range requires {
		kind, name, found := strings.Cut(ref, "/")
		if !found || (pack.Kind(kind) != pack.KindSkill && pack.Kind(kind) != pack.KindAgent) || !validSlug(name) {
			return invalid(where, "requires entries must be skill/<name> or agent/<name>")
		}
		if ref == where {
			return invalid(where, "an item cannot require itself")
		}
		if ref <= previous {
			return invalid(where, "requires entries must be sorted and unique")
		}
		previous = ref
	}
	return nil
}

// in Library.Validate, after the loop that fills `seen`
	for _, item := range library.Items {
		for _, ref := range item.Requires {
			if _, known := seen[ref]; !known {
				return invalid(string(item.Kind)+"/"+item.Name, "requires "+ref+", which is not in this library")
			}
		}
	}

// Required returns the library items item.Requires names, in that order.
// Library.Validate guarantees each one exists.
func (library Library) Required(item Item) []Item {
	byRef := make(map[string]Item, len(library.Items))
	for _, candidate := range library.Items {
		byRef[string(candidate.Kind)+"/"+candidate.Name] = candidate
	}
	required := make([]Item, 0, len(item.Requires))
	for _, ref := range item.Requires {
		if found, ok := byRef[ref]; ok {
			required = append(required, found)
		}
	}
	return required
}
```

`source.go` `itemMeta`: `Requires []string `json:"requires,omitempty"`` after `Description`; the `Item{…}` literal sets `Requires: meta.Requires`. (`"requires": []` decodes to an empty non-nil slice and is refused; an absent key stays nil.) GREEN: `go test -count=1 ./internal/library` (including `TestContentLockPinsEveryItemVersion`: no recorded checksum moves). Commit B1+B2 separately.

### B3. Transform reads agent-skills command files

Tests first in `internal/library/upstream/layout_test.go` (package `upstream`):

```go
func TestTransformReadsAgentSkillsCommands(t *testing.T) {
	raw := "description = \"Review the change — five axes, \\\"quoted\\\"\"\n\nprompt = \"\"\"\nInvoke the code-review-and-quality skill.\r\n\r\nUse $ARGUMENTS.\n\"\"\"\n"
	got, err := Transform(pack.KindPrompt, "review", []byte(raw))
	if err != nil {
		t.Fatalf("Transform: %v", err)
	}
	want := Imported{Description: "Review the change — five axes, \"quoted\"", Body: "Invoke the code-review-and-quality skill.\n\nUse $ARGUMENTS.\n"}
	if got != want {
		t.Fatalf("Transform = %+v, want %+v", got, want)
	}
}

func TestTransformRefusesMalformedCommands(t *testing.T) {
	const notTOML = "the command file is not TOML with string description and prompt keys"
	const keys = "command keys must be exactly description and prompt"
	cases := map[string]struct{ raw, want string }{
		"invalid TOML":         {"prompt = \"\"\"\nunclosed\n", notTOML},
		"a number prompt":      {"description = \"d\"\nprompt = 3\n", notTOML},
		"an extra key":         {"description = \"d\"\nprompt = \"p\"\nmodel = \"x\"\n", keys},
		"a table":              {"description = \"d\"\nprompt = \"p\"\n[extra]\nkey = 1\n", keys},
		"no description":       {"prompt = \"p\"\n", keys},
		"no prompt":            {"description = \"d\"\n", keys},
		"a two-line description": {"description = \"\"\"a\nb\"\"\"\nprompt = \"p\"\n", "the command description must be one line"},
		"a padded description": {"description = \" d\"\nprompt = \"p\"\n", "the command description must be one line"},
		"an empty description": {"description = \"\"\nprompt = \"p\"\n", "the command description must be one line"},
		"a blank prompt":       {"description = \"d\"\nprompt = \"  \\n\"\n", "the command prompt is empty"},
		"a NUL byte":           {"description = \"d\"\nprompt = \"p\x00\"\n", "UTF-8 text without NUL bytes"},
	}
	for name, testCase := range cases {
		t.Run(name, func(t *testing.T) {
			_, err := Transform(pack.KindPrompt, "x", []byte(testCase.raw))
			if !errors.Is(err, ErrNotImportable) || !strings.Contains(err.Error(), testCase.want) {
				t.Fatalf("Transform error = %v, want %q", err, testCase.want)
			}
		})
	}
}
```

RED: "kind prompt cannot be imported yet". Implementation in `internal/library/upstream/layout.go` (import `"github.com/BurntSushi/toml"`):

```go
// in Transform: widen the kind check, then, right after the 64 KiB check
	if kind != pack.KindSkill && kind != pack.KindAgent && kind != pack.KindPrompt {
		return Imported{}, notImportable("kind %s cannot be imported yet", kind)
	}
	…
	if kind == pack.KindPrompt {
		return transformPrompt(text)
	}

// promptCommand is an agent-skills commands/<name>.toml file.
type promptCommand struct {
	Description string `toml:"description"`
	Prompt      string `toml:"prompt"`
}

// transformPrompt reads a command file (story 86bcm901b). The description and
// the prompt text are taken verbatim. Any other key, a table or a value that is
// not a string is refused rather than guessed: the client renders only these two.
func transformPrompt(text string) (Imported, error) {
	var command promptCommand
	metadata, err := toml.Decode(text, &command)
	if err != nil {
		// The parser's message can quote upstream bytes; keep them off the terminal.
		return Imported{}, notImportable("the command file is not TOML with string description and prompt keys")
	}
	if len(metadata.Undecoded()) > 0 || !metadata.IsDefined("description") || !metadata.IsDefined("prompt") {
		return Imported{}, notImportable("command keys must be exactly description and prompt (the client renders only these)")
	}
	description := command.Description
	if description == "" || description != strings.TrimSpace(description) || strings.ContainsAny(description, "\r\n") ||
		utf8.RuneCountInString(description) > pack.MaxDescriptionRunes {
		return Imported{}, notImportable("the command description must be one line of 1 to %d characters", pack.MaxDescriptionRunes)
	}
	if strings.TrimSpace(command.Prompt) == "" {
		return Imported{}, notImportable("the command prompt is empty")
	}
	return Imported{Description: description, Body: command.Prompt}, nil
}
```

Update `Transform`'s doc comment (name is the folder, agent file or command file name; prompts: TOML). GREEN: `go test -count=1 ./internal/library/upstream`.

### B4. Import, accept and diff take prompts; `--requires`

1. `internal/library/upstream/importer.go`: `importableKind` case `GroupPrompt` → `return pack.KindPrompt, "", nil`; delete `StepNeedsPromptKind`; `resolveRoot`'s message lists `commands/<name>.toml` as a root shape; `ImportOptions` gets `Requires []string // library items the new item needs beside it, kind/name`; in `Import`, after building `item`: `if len(options.Requires) > 0 { item.Requires = options.Requires }`.
2. `internal/library/upstream/write.go`: the item.json struct gets `Requires []string json:"requires,omitempty"` between `Description` and `Source`, filled from `item.Requires`.
3. `internal/library/upstream/diff_test.go:205`: the row becomes `"added prompt commands/plan.toml - - | available to import"` (RED first: it still prints the old step until step 1 is in).
4. `cmd/library-upstream/main.go`: `requires := flags.String("requires", "", "comma-separated library items the new item needs, e.g. skill/test-driven-development")` in `runImport`, passed as `Requires: splitList(*requires)`; the package doc and `usageText` say "skill, agent or prompt" and show `[--requires kind/name,...]`; the import success text is unchanged.
5. Tests in `cmd/library-upstream/main_test.go` (write first):
   - `TestImportCreatesPromptItemWithSourceRequiresAndLockEntry`: `newSyncFixture`, then `import --library <lib> --from <repo> --path commands/plan.toml --category planning --tags planning --tools claude-code,cursor --requires skill/alpha --example <file "Type /plan.\n">` (no `--to`: the pin `commit1`). Expect output naming `prompt/plan@1.0.0`, and `items/prompt/plan/item.json` byte-equal to:
     ```
     {
       "version": "1.0.0",
       "category": "planning",
       "tags": [
         "planning"
       ],
       "tools": [
         "claude-code",
         "cursor"
       ],
       "description": "Plan",
       "requires": [
         "skill/alpha"
       ],
       "source": {
         "upstream": "fixture-skills",
         "path": "commands/plan.toml",
         "commit": "<fixture.commit1>",
         "upstreamSha256": "<library.ImportedContentSHA256("Plan", "Plan the work.")>"
       }
     }
     ```
     `body.md` = `Plan the work.` (no newline: the fixture's TOML string has none), `example.md` = `Type /plan.\n`, the lock gains exactly `prompt/plan@1.0.0` with the parsed item's checksum, and every other file is unchanged (copy the before/after checks of `TestImportCreatesItemWithSourceAndLockEntry`, lines 286-310).
   - `TestImportRefuses` (line 312): replace the `{"a prompt", …, "86bcm9016"}` case with `{"a requirement outside the library", importArgs("commands/plan.toml", "--requires", "skill/missing"), "requires skill/missing, which is not in this library"}` and `{"a command that is not TOML", importArgs("commands/broken.toml"), "is not TOML with string description and prompt keys"}`; add `"commands/broken.toml": "prompt = \"\"\"\nunclosed\n"` to that test's 0.3.0 commit. Each case already asserts nothing was written.
   - `TestAcceptTakesAnUpstreamPromptChange`: import `commands/plan.toml` at the pin with `--requires skill/alpha`, commit 0.3.0 with `commands/plan.toml` = `description = "Plan it"\nprompt = "Plan the work in slices."\n`, run `accept --item prompt/plan --to 0.3.0`; expect version `1.1.0`, source commit = the 0.3.0 commit, `upstreamSha256` = `ImportedContentSHA256("Plan it", "Plan the work in slices.")`, the new description and body, `requires` still `["skill/alpha"]`, and both `prompt/plan@1.0.0` and `@1.1.0` in the lock.
6. GREEN: `go test -count=1 ./internal/library/... ./cmd/library-upstream`. Commit.

### B5. The four AC tests (RED before any import)

Create the four files below, run each AC command, and keep the RED logs (`$S/red-ac<n>.log`): AC1, AC2 and AC4 fail with "no prompt" assertions; AC3 now compiles (B2 landed) and fails with "the library has no prompt build".

`internal/library/prompts_ac1_test.go`:

```go
package library

import (
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// ac1Commands are the nine agent-skills slash commands the card names
// (ClickUp 86bcm901b): the library prompt each ships as, the upstream file it is
// imported from (agent-skills names the plan command's TOML form planning.toml),
// and the fingerprint of its description and prompt text at the pin, computed
// from the upstream bytes independently of the importer.
var ac1Commands = []struct{ command, item, path, upstreamSHA256 string }{
	{"build", "build", "commands/build.toml", "30860c36492d6c474e7b6919ef23052dbd53dff878b3eef6db5e4c1f79092143"},
	{"code-simplify", "code-simplify", "commands/code-simplify.toml", "a24e7f087f0c5c1ada29dde17d3fab6304e9137c51b83d517d72f9730e922158"},
	{"constraints", "constraints", "commands/constraints.toml", "80746629e9ca7ac0edb3d0cebd8f91b0d12988c2c2acfde2dea4a3ba06fc652b"},
	{"plan", "planning", "commands/planning.toml", "af18ead13c71129e1be9514c8519eec1cb8f5db5b491fc8551c94d284a0356dc"},
	{"review", "review", "commands/review.toml", "7d5ddf2c81f07d4ff12a5a01ae6d1be5d72e8b81e1daf07011f55bd20284cde6"},
	{"ship", "ship", "commands/ship.toml", "1d294bf5ab2d25100248a453f9fbb269055b3e14bfa66e3e2b215f975883f070"},
	{"spec", "spec", "commands/spec.toml", "09e9e83aada49489ff949a2e436556d276349f44870581ed571528f3790b975a"},
	{"test", "test", "commands/test.toml", "dfb6ed8744d80e46a01ad8e67efb235dd2deb46535134626e13a986889625890"},
	{"webperf", "webperf", "commands/webperf.toml", "9c1e47fa6d1da1ec011452af6920e28f79b1a8c0561829b52fd26a861dfff6fb"},
}

func TestAC1_NineUpstreamCommandsArePromptItemsWithSourceCommit(t *testing.T) {
	shipped, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	up, ok := shipped.Upstream("agent-skills")
	if !ok || up.Release != "0.6.13" || up.Commit != "aeac41d4d005999432bb7312f7ff06383a91d59d" {
		t.Fatalf("agent-skills record = %+v, %v; want release 0.6.13 at commit aeac41d…", up, ok)
	}
	lock, err := ReadLock(lockFile)
	if err != nil {
		t.Fatal(err)
	}
	prompts := map[string]Item{}
	imported := 0
	for _, item := range shipped.Items {
		if item.Kind != pack.KindPrompt {
			continue
		}
		prompts[item.Name] = item
		if item.Source != nil && item.Source.Upstream == up.Name {
			imported++
		}
	}
	if imported != len(ac1Commands) {
		t.Errorf("%d prompts are imported from agent-skills, want %d", imported, len(ac1Commands))
	}
	for _, command := range ac1Commands {
		item, found := prompts[command.item]
		if !found {
			t.Errorf("/%s: the library has no prompt %s", command.command, command.item)
			continue
		}
		source := item.Source
		if source == nil {
			t.Errorf("%s: no source recorded", item.Key())
			continue
		}
		if source.Upstream != up.Name || source.Path != command.path || source.Commit != up.Commit {
			t.Errorf("%s: source = %+v; want agent-skills %s at commit %s", item.Key(), *source, command.path, up.Commit)
		}
		if source.UpstreamSHA256 != command.upstreamSHA256 || item.Adapted() {
			t.Errorf("%s: upstreamSha256 %s, adapted %v; want %s, imported verbatim", item.Key(), source.UpstreamSHA256, item.Adapted(), command.upstreamSHA256)
		}
		if item.Version != "1.0.0" || lock[item.Key()] != item.Checksum() {
			t.Errorf("%s: version %s, lock %q; want 1.0.0 recorded with checksum %s", item.Key(), item.Version, lock[item.Key()], item.Checksum())
		}
		t.Logf("/%s -> %s from %s %s at commit %s, upstreamSha256 %s", command.command, item.Key(), source.Upstream, source.Path, source.Commit, source.UpstreamSHA256)
	}
}
```

`internal/library/render/prompts_ac2_test.go`:

```go
package render

import (
	"encoding/json"
	"maps"
	"slices"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// ac2Prompts are the library prompts imported from the nine agent-skills commands (86bcm901b).
var ac2Prompts = []string{"build", "code-simplify", "constraints", "planning", "review", "ship", "spec", "test", "webperf"}

func TestAC2_EachPromptRendersAsANativeCommandOrIsSkippedWithAReason(t *testing.T) {
	shipped, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	const codexReason = "Codex removed custom prompts in 0.117.0 and has no prompt location"
	if reason, skipped := NotInstalled(pack.KindPrompt, library.ToolCodex); !skipped || reason != codexReason {
		t.Fatalf("NotInstalled(prompt, codex) = %q, %v", reason, skipped)
	}
	for _, name := range ac2Prompts {
		var item library.Item
		found := false
		for _, candidate := range shipped.Items {
			if candidate.Kind == pack.KindPrompt && candidate.Name == name {
				item, found = candidate, true
			}
		}
		if !found {
			t.Errorf("the library has no prompt %s", name)
			continue
		}
		one := Pack{Name: shipped.Name, Version: shipped.Version, Items: []Item{FromLibrary(item)}}
		body := strings.TrimSpace(item.Body) + "\n"
		var quoted strings.Builder
		encoder := json.NewEncoder(&quoted)
		encoder.SetEscapeHTML(false)
		if err := encoder.Encode(item.Description); err != nil {
			t.Fatal(err)
		}
		want := map[library.Tool]map[string]string{
			// Claude Code: a project command /<name> that only the user can run.
			library.ToolClaudeCode: {".claude/commands/" + name + ".md": "---\ndescription: " + quoted.String() + "disable-model-invocation: true\n---\n\n" + body},
			// Cursor: a user command holding the body alone.
			library.ToolCursor: {"commands/" + name + ".md": body},
			// Codex: no prompt location, so nothing is written and a warning says why.
			library.ToolCodex: {},
		}
		for _, tool := range []library.Tool{library.ToolClaudeCode, library.ToolCodex, library.ToolCursor} {
			bundle, err := Transform(tool, one)
			if err != nil {
				t.Errorf("%s %s: %v", name, tool, err)
				continue
			}
			got := map[string]string{}
			for path, content := range bundle.Files {
				got[path] = string(content)
			}
			if !maps.Equal(got, want[tool]) {
				t.Errorf("%s %s: files %q, want %q", name, tool, got, want[tool])
			}
			wantWarnings := []string{}
			if tool == library.ToolCodex {
				wantWarnings = []string{`prompt "` + name + `" is not installed for codex: ` + codexReason + `; skipped`}
			}
			if !slices.Equal(append([]string{}, bundle.Warnings...), wantWarnings) {
				t.Errorf("%s %s: warnings %q, want %q", name, tool, bundle.Warnings, wantWarnings)
			}
			if tool == library.ToolCodex {
				t.Logf("%s %s: skipped: %s", name, tool, codexReason)
			} else {
				t.Logf("%s %s: %s", name, tool, slices.Sorted(maps.Keys(got)))
			}
		}
	}
}
```

`internal/library/prompts_ac3_test.go`:

```go
package library

import (
	"maps"
	"regexp"
	"slices"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// ac3Requires maps each prompt (86bcm901b) to the library skills its text
// invokes. webperf invokes no skill: it asks for the web-performance-auditor agent.
var ac3Requires = map[string][]string{
	"build":         {"skill/debugging-and-error-recovery", "skill/doubt-driven-development", "skill/incremental-implementation", "skill/planning-and-task-breakdown", "skill/test-driven-development"},
	"code-simplify": {"skill/code-review-and-quality", "skill/code-simplification"},
	"constraints":   {"skill/constraint-driven-development"},
	"planning":      {"skill/planning-and-task-breakdown"},
	"review":        {"skill/code-review-and-quality", "skill/performance-optimization", "skill/security-and-hardening"},
	"ship":          {"skill/shipping-and-launch"},
	"spec":          {"skill/spec-driven-development"},
	"test":          {"skill/browser-testing-with-devtools", "skill/test-driven-development"},
	"webperf":       nil,
}

func TestAC3_EachPromptFlagsTheSkillsItInvokesAsDependencies(t *testing.T) {
	shipped, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	var skills []string
	for _, item := range shipped.Items {
		if item.Kind == pack.KindSkill {
			skills = append(skills, item.Name)
		}
	}
	for _, name := range slices.Sorted(maps.Keys(ac3Requires)) {
		want := ac3Requires[name]
		var prompt Item
		found := false
		for _, item := range shipped.Items {
			if item.Kind == pack.KindPrompt && item.Name == name {
				prompt, found = item, true
			}
		}
		if !found {
			t.Errorf("the library has no prompt %s", name)
			continue
		}
		if !slices.Equal(prompt.Requires, want) {
			t.Errorf("%s requires %v, want %v", prompt.Key(), prompt.Requires, want)
		}
		// The flag matches the text: every library skill the prompt names, and no other.
		var named []string
		for _, skill := range skills {
			if regexp.MustCompile(`(^|[^a-z0-9-])` + regexp.QuoteMeta(skill) + `($|[^a-z0-9-])`).MatchString(prompt.Body) {
				named = append(named, "skill/"+skill)
			}
		}
		slices.Sort(named)
		if !slices.Equal(prompt.Requires, named) {
			t.Errorf("%s requires %v, but its text names the skills %v", prompt.Key(), prompt.Requires, named)
		}
		// Each flagged dependency resolves to a library skill that installs wherever the prompt does.
		required := shipped.Required(prompt)
		if len(required) != len(want) {
			t.Errorf("%s: Required returned %d items, want %d", prompt.Key(), len(required), len(want))
		}
		for _, skill := range required {
			if skill.Kind != pack.KindSkill {
				t.Errorf("%s requires %s, which is not a skill", prompt.Key(), skill.Key())
			}
			for _, tool := range prompt.Tools {
				if !slices.Contains(skill.Tools, tool) {
					t.Errorf("%s runs in %s but its skill %s does not", prompt.Key(), tool, skill.Key())
				}
			}
		}
		t.Logf("%s requires %v", prompt.Key(), prompt.Requires)
	}
}
```

`cmd/library-gate/prompts_ac4_test.go`:

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
)

// ac4Prompts are the nine agent-skills commands the library ships as prompts (86bcm901b).
var ac4Prompts = []string{"build", "code-simplify", "constraints", "planning", "review", "ship", "spec", "test", "webperf"}

func TestAC4_EveryPromptPassesTheContentQualityGate(t *testing.T) {
	bin := gitleaksForTest(t)
	reportPath := filepath.Join(t.TempDir(), "report.json")
	var stdout, stderr bytes.Buffer
	if code := run(context.Background(), []string{"-dir", realLibrary, "-gitleaks", bin, "-json", reportPath},
		&stdout, &stderr, gate.NewGitleaks); code != 0 {
		t.Fatalf("the library failed the gate (exit %d)\n%s%s", code, stdout.String(), stderr.String())
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
	for _, name := range ac4Prompts {
		key := "prompt/" + name + "@1.0.0"
		result, ok := results[key]
		if !ok || !result.Passed || result.Schema != "pass" || len(result.Secrets) != 0 || len(result.Tools) != 3 {
			t.Errorf("%s did not pass the gate: %+v", key, result)
			continue
		}
		for _, tool := range result.Tools {
			switch tool.Tool {
			case library.ToolClaudeCode, library.ToolCursor:
				path := "commands/" + name + ".md"
				if tool.Tool == library.ToolClaudeCode {
					path = ".claude/" + path
				}
				if !tool.Declared || tool.Status != gate.StatusRendered || !slices.Equal(tool.Files, []string{path}) {
					t.Errorf("%s %s: declared %v, status %s (%s), files %v; want rendered %s", key, tool.Tool, tool.Declared, tool.Status, tool.Reason, tool.Files, path)
				}
			case library.ToolCodex:
				if tool.Status != gate.StatusSkipped || tool.Reason != "Codex removed custom prompts in 0.117.0 and has no prompt location" {
					t.Errorf("%s codex: status %s (%s); want skipped with the reason", key, tool.Status, tool.Reason)
				}
			}
			t.Logf("%s %s: %s %s %v", key, tool.Tool, tool.Status, tool.Reason, tool.Files)
		}
		t.Logf("%s: passed, schema %s, secrets none", key, result.Schema)
	}
}
```

Check field and constant names against `internal/library/gate/gate.go` and `report.go` (`Report.Items`, `ItemResult.Key/Passed/Schema/Secrets/Tools`, `ToolResult.Tool/Declared/Status/Reason/Files`, `StatusRendered`, `StatusSkipped`) and fix only names, never the assertions. The plan's code is unchecked by a compiler (no Go on the planning machine).

### B6. Import the nine commands (GREEN for AC1–AC4)

From the worktree root, for each row of D4 (write the example first):

```bash
TMPDIR="$S/tmp" go run ./cmd/library-upstream import --from "$S/upstream/agent-skills.git" \
  --path commands/review.toml --category code-quality --tags code-review,pull-requests --tools claude-code,cursor \
  --requires skill/code-review-and-quality,skill/performance-optimization,skill/security-and-hardening \
  --example "$S/examples/review.md"
```

(`webperf`: no `--requires`.) Each run prints `Imported prompt/<item>@1.0.0 … at aeac41d4d005999432bb7312f7ff06383a91d59d` and writes the item and one lock line; nothing is checked out or run. Then set `content/library.json` `"version": "0.6.0"`. Run the four AC commands: all GREEN; then `go test -count=1 ./internal/library/... ./cmd/library-gate ./cmd/library-upstream`. If AC1 reports a fingerprint different from D4, stop and run `LEORNA_TEST_UPSTREAM_NETWORK=1 go test -count=1 -v -run '^TestShippedImportsMatchTheRealUpstream$' ./internal/library/upstream` to decide which side is wrong. Commit the AC tests, the 9 items, `content.lock.json` and `library.json` together: `feat(86bcm901b): import the nine agent-skills commands as prompts`.

### B7. Prompt review records (D5)

Test first, `internal/library/prompt_curation_test.go` (package `library`): `TestEveryImportedPromptIsReviewed` reads `filepath.Join(CurationDir, "curation.json")` with `ReadCuration` and, for every prompt in `Embedded()` with a `source`, requires exactly one entry in `record.Prompts` with that `item` (`prompt/<name>`), `version` equal to the shipped version, `origin` `upstream`, `owner` equal to `record.Owner`, `reviewedOn` matching `^\d{4}-\d{2}-\d{2}$`, an answer for every id in `record.Checklist` from `pass`, `adapted`, `n/a`, `scripts` = `n/a`, non-empty `notes`, and `adaptation` nil unless `item.Adapted()`; and no entry for an item that doesn't ship. Model it on `TestAC2_EveryImportedSkillIsReviewedWithOwnerAndAdaptationDiff` (`curation_test.go:85-168`). RED (`record.Prompts` undefined, then empty). Add `Prompts []SkillReview json:"prompts,omitempty"` to `Curation` (`curation.go`) with a comment that prompt reviews use the skill review shape; write the 9 reviews (D5 notes; `reviewedOn` = the build date) and apply D6's three note edits. GREEN: `go test -count=1 ./internal/library`. Commit.

### B8. Live-check folder for AC5

New file `cmd/library-gate/prompts_evidence_test.go`: `TestEvidencePromptsForLiveCheck` skips without `LEORNA_EVIDENCE_DIR`; refuses if `$LEORNA_EVIDENCE_DIR/ac5-install` exists; parses `realLibrary`; builds one Claude Code pack of `review`, `spec` and every item `lib.Required` returns for them (deduplicated by key; `render.FromLibrary`, setting `ScriptsApproved = true` only for an item with a script file, as `gate.renderFor` does); renders it with `render.Transform(library.ToolClaudeCode, …)`; fails on any warning; writes each file under `ac5-install/claude-code/` after the `filepath.IsLocal` check (mode 0755 when `bundle.Executable`); and writes `ac5-install/SHA256SUMS` with the SHA-256 of `.claude/commands/review.md` and `.claude/commands/spec.md` in `sha256sum` format (paths relative to `claude-code/`). Model it on `TestEvidenceSampledSkillsForManualCheck` (`cmd/library-gate/evidence_test.go`). Run it with `LEORNA_EVIDENCE_DIR=~/.hermes/plans/leorna/evidence/86bcm901b`, check the folder holds the 2 commands and the 4 skills' folders, and write `evidence/86bcm901b/ac5-checklist.md` (below). Commit the test.

`ac5-checklist.md` for Justin (5 minutes; Claude Code 2.1.312 is installed in WSL):
1. `mkdir ~/ac5-prompts && cd ~/ac5-prompts && git init -q && printf 'def add(a, b):\n    return a + b\n' > calc.py && git add calc.py && git commit -qm "add calc"`
2. `cp -r ~/.hermes/plans/leorna/evidence/86bcm901b/ac5-install/claude-code/.claude . && (cd .claude/.. && sha256sum -c ~/.hermes/plans/leorna/evidence/86bcm901b/ac5-install/SHA256SUMS)` → both `OK`.
3. Make a change to review: `sed -i 's/a + b/a - b/' calc.py && git add calc.py`.
4. Run `claude` in `~/ac5-prompts` (trust the folder if asked). Type `/` and check `review` and `spec` are listed as project commands. Run `/review`. **Pass:** the reply reviews the staged change across correctness, readability, architecture, security and performance, labels findings Critical, Required, Optional or Nit with `calc.py:<line>`, and the session shows the `code-review-and-quality` skill being used. Screenshot → `ac5-review.png`.
5. Run `/spec a command-line tool that turns a CSV file into JSON`. **Pass:** it asks about the goal and users, features and acceptance criteria, stack and boundaries before writing any code. Screenshot → `ac5-spec.png`.
6. Exit, then rerun step 2's `sha256sum -c`: both `OK` (the command files were not changed). Delete `~/ac5-prompts` when done.

### B9. Mutation checks (`mutation-testing-discipline`)

Each mutant is applied with `go test -overlay` (or a temporary edit restored right after, `git diff` empty again) and must make the named test fail; record command, mutant, failing test and restore in `evidence/86bcm901b/mutations-<sha7>.txt`:
- M1 `transformPrompt` without the `Undecoded()` clause → `TestTransformRefusesMalformedCommands/an_extra_key`.
- M2 the prompt case of `Source.validate` using suffix `""` → `TestParseRejectsMalformedPromptSource/a_Markdown_command`.
- M3 `Library.Validate` without the `requires` existence loop → `TestParseRejectsMalformedRequires/an_item_outside_the_library`.
- M4 `validateRequires` comparing `ref < previous` → `TestParseRejectsMalformedRequires/a_duplicate`.
- M5 `Checksum` without `Requires` → `TestParseReadsRequires` and `TestChecksumCoversEveryField`.
- M6 `Required` returning `nil` → `TestAC3_EachPromptFlagsTheSkillsItInvokesAsDependencies`.
- M7 `importableKind` refusing `GroupPrompt` again → `TestImportCreatesPromptItemWithSourceRequiresAndLockEntry`.

### B10. Evidence capture per AC (named task; see the next section)

### B11. Module README note and records

`internal/library/README.md`:
- `item.json` table: a `requires` row (optional; sorted `skill/<name>` or `agent/<name>` references to items in this library, 1 to 32; covered by the checksum; not stored in PostgreSQL; read with `Library.Required`).
- Library history: "Library **0.6.0** (story 86bcm901b) adds the nine agent-skills commands as prompts. See [Curated prompts](#curated-prompts-86bcm901b)."
- "The item `source` block": a prompt's `path` is `commands/<name>.toml`; drop "other kinds cannot have a source" for prompts. The sync-tool block shows `import … [--requires kind/name,...]`; the sentence "Prompts (`commands/*.toml`) … can now be imported" is now true; say what `Transform` accepts for a command file.
- New section **Curated prompts (86bcm901b)**: what ships and from where (the commit, same as the skills, and why); `/plan` ships as `/planning` (Claude Code's built-in `/plan`); how each tool receives a prompt (Claude Code `.claude/commands/<name>.md`, user-invoked only; Cursor `commands/<name>.md` in the Cursor home; Codex skipped, with the reason); `requires` and who reads it (901w, 901r); `/ship` and `/webperf` agents (86bcm901a; the client installs no agents yet); the prompt review record and how the checklist reads for a prompt; after `accept`, re-review; Verification: every test this story adds, by name.
- Commit with `delivery/stories.json` (task B13): `docs(86bcm901b): …`.

### B12. Gates (see Gates) on the final head; save `gates-<sha7>.txt`.

### B13. Docs & records (see the last section).

Stop at **ready-for-review**: clean worktree, all commits by Justin Issa, nothing pushed.

## Evidence capture per AC (task B10)

Folder `~/.hermes/plans/leorna/evidence/86bcm901b/` (builder writes at its top level; verifier only in `verifier/`, auditor only in `auditor/`). Capture each item on the final head, with the method B0.4 proved; inspect every PNG before keeping it (no DB URL, password, token, server domain or email on screen).

| AC | What it demonstrates | Capture point | Artifacts |
| --- | --- | --- | --- |
| AC1 | The admin console lists the 9 prompts under Third-party content, each with `commands/<x>.toml` and commit `aeac41d…`, licence MIT | Local dev-mode server on the final head (`go build ./cmd/control-plane`; `LEORNA_DEV_MODE=1`, listen `127.0.0.1:<free port>`, placeholder `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`, random `LEORNA_SECRET_ENCRYPTION_KEY`, DB `leorna_86bcm901b_demo_test` with `sslmode=disable`; check `internal/config/runtime.go` for any other required variable), then a chromedp capture of `/dev/login?next=%2Fadmin%2Fthird-party-content`, cropped or scrolled to the prompt rows; before-state the same page on the base (skills only) | `before-third-party-content.png`, `ac1-third-party-content.png`, `ac1-<sha7>.log`; if the server can't run here, `ac1-test-<sha7>.png` (log page) and say so |
| AC2 | Each prompt's Claude Code and Cursor files and Codex's skip reason | AC2 command with `-v` | `ac2-<sha7>.log`, `ac2-render-<sha7>.png` |
| AC3 | Each prompt's `requires`, matched to its text and resolved to installable skills | AC3 command with `-v` | `ac3-<sha7>.log`, `ac3-requires-<sha7>.png` |
| AC4 | The real gate passes every prompt (Claude Code and Cursor rendered, Codex skipped with reason, no secrets) | AC4 command with `-v`, plus `make library-check LIBRARY_REPORT=<ev>/library-report-<sha7>.json LIBRARY_SUMMARY=<ev>/library-summary-<sha7>.md` | `ac4-<sha7>.log`, `ac4-gate-<sha7>.png`; optional local rendering of the summary's 9 prompt rows labelled "local rendering" |
| AC5 (live) | `/review` and `/spec` run in Claude Code | Justin, `ac5-checklist.md` | `ac5-install/`, `ac5-checklist.md`; owed: `ac5-review.png`, `ac5-spec.png` |
| gates | Every gate on the final head | B12 | `gates-<sha7>.txt`, `gates-<sha7>.png`, `network-<sha7>.txt`, `mutations-<sha7>.txt`, `red-ac<n>.log` |

Each log starts `HEAD=<sha>` and ends `EXIT=<rc>` (the `ac-verification.md` recipe). `EVIDENCE.md` maps AC → test → log → PNG and names the screenshot method used.

## Gates (the `leorna` skill's step 4, control plane)

One script, run from the worktree on the final head, writing `gates-<sha7>.txt` with a `label EXIT=<rc>` line per step:

```bash
ENV=~/.cache/leorna-86bcm901b; export PATH="$ENV/go/bin:$ENV/bin:/usr/local/bin:/usr/bin:/bin" GOTOOLCHAIN=local
. "$ENV/pg/pg.env"; PGPW=$(cat "$ENV/pg/password"); [ -n "$PGPW" ] || { echo "empty DB password"; exit 1; }
export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:${PORT}/leorna_86bcm901b_test?sslmode=disable"
go version; golangci-lint --version; govulncheck -version; gitleaks version
GOLANGCI_LINT="$ENV/bin/golangci-lint" GOVULNCHECK="$ENV/bin/govulncheck" GITLEAKS=/usr/local/bin/gitleaks make -s check; echo "make-check EXIT=$?"
bash ./scripts/test-module-add.sh; echo "module-add EXIT=$?"
go test -json -count=1 -run WithPostgres ./... > "$S/pg.json"; echo "pg-json EXIT=$?"   # then read per test: every TestXxxWithPostgres passes; the only skips allowed are TestTeamsAPIWithPostgres's two ClickHouse subtests
python3 -m unittest discover -s scripts -p 'test_story_shippable.py'; echo "stories EXIT=$?"
gitleaks git --redact --no-banner --log-opts="$BASE..HEAD"; echo "branch-secrets EXIT=$?"
test -z "$(git diff --name-only "$BASE"...HEAD -- .github)"; echo "no-ci-change EXIT=$?"
test -z "$(git status --porcelain)"; echo "clean EXIT=$?"
```

Plus, kept in `network-<sha7>.txt` (needs network, CI skips them): `LEORNA_TEST_UPSTREAM_NETWORK=1 go test -count=1 -v -run '^TestShippedImportsMatchTheRealUpstream$' ./internal/library/upstream` (every imported item, the 9 prompts included, against real upstream at its commit) and `LEORNA_TEST_UPSTREAM_NETWORK=1 go test -count=1 -v -run '^TestAC7_DryRunSyncAgainstUpstreamHEAD$' ./cmd/library-upstream`. `make check` and `test-module-add.sh` briefly write into the tree, so read-only roles run them in a detached copy at the same SHA with their own database. Compare any failure with the base baseline by test identity before calling it a regression.

## Risks

**Sibling stories in this repo** (86bcm901a agent definitions, 86bcm901j MCP templates, 86bcm901w pack builder; all based on `1ee7157`). Files this story edits that they will probably edit too, and how the hand-over resolves each (Justin: resolve at hand-over, don't wait):

| File | Who else | Resolution at hand-over |
| --- | --- | --- |
| `delivery/stories.json` | 901a, 901j, 901w (each appends last) | Take main's file unchanged and append this story's entry last as text (`leorna` skill 7.2); check every earlier entry is unchanged by value; run `test_story_shippable.py` |
| `internal/library/content/library.json` | 901a, 901j (each bumps 0.5.0 → 0.6.0) | Bump to the next minor above main's (e.g. 0.7.0) and fix the README's "Library 0.x.0" line; no checksum depends on it |
| `internal/library/content.lock.json` | 901a, 901j (new lines) | Take main's lock, re-add this story's 9 `prompt/…@1.0.0` lines, compare entries by value (a trailing-comma diff is not a change) |
| `internal/library/README.md` | 901a, 901j, maybe 901w | Keep every story's section; fix version numbers and the Verification lists |
| `internal/library/curation/curation.json`, `curation.go` | 901a (agent reviews, demo-agent decisions; doubt-driven-development's note names 901a too) | Keep both stories' keys, fields and note clauses; re-run `go test ./internal/library` |
| `internal/library/library.go`, `source.go` (`Item`, `Validate`, `Checksum`, `Source.validate`) | 901j may add tool-declaration checks; 901a may touch agent sources | Merge both rules; both keep `omitempty` so no recorded checksum moves; run `TestContentLockPinsEveryItemVersion` |
| `internal/library/upstream/importer.go`, `layout.go`, `write.go`, `cmd/library-upstream/main.go` | 901a if it handles the `code-reviewer` name collision on import | Keep both changes; re-run `./internal/library/upstream ./cmd/library-upstream` |
| `internal/library/gate/*`, `cmd/library-gate/*` | 901j (verifying declared tools) | This story adds test files only there; re-run AC4 on the merged code |
| `internal/library/upstream_skills_test.go` (comment line 45) | 901a | Drop both stale clauses |
| `THIRD_PARTY_NOTICES.md`, `content/upstreams/agent-skills/*` | 901a, 901j if they add an upstream or move the pin | This story doesn't edit them; after merging main, the existing notices test must still pass |
| `/ship`, `/webperf` content vs 901a's agents | 901a | No file overlap; after 901a merges, a follow-up adds `agent/…` to their `requires` (version bump each) |
| 901w's library page and pack-version code | 901w | No file overlap expected; 901w reads `Library.Required` (its planner names the plug-in point) |

Whichever story merges second runs this story's gates on main's new content (a sibling can add files a strict check refuses without a text conflict) and greps for "86bcm901b", "does not ship yet" and "come later" wording that has gone stale.

Other risks:
- **Environment (Q4):** if user-space PostgreSQL or the screenshot probe fails, the builder stops and reports; it never edits product code, CI or system packages to work around it.
- **`origin/main` moves** (shared ref; four sessions in this repo): record it at fetch and recheck before final gates and captures.
- **Claude Code argument passing** (`/build auto`, `/constraints check`) isn't proven here; AC5 runs `/review` and `/spec` only.
- **Upstream changes after the pin:** `diff` now reports prompt roots, so a future `accept` path exists; after any `accept`, the prompt's review must be updated (B7's test fails until then).
- **A third-party prompt instructs agents** (commits, installs, subagents): the review records each risk; Claude Code runs them only on the user's command (`disable-model-invocation: true`).

## Follow-ups (for the PR's Assumptions)

1. **86bcm901w (pack builder):** when an admin ticks a prompt, add or warn about `Library.Required(prompt)`; if the pack builder reads library items from Postgres, add a `library_items.requires` column then.
2. **86bcm901r (starter packs):** each pack that holds a prompt holds its `requires`; the card's proposed mapping has no pack for `/code-simplify` or `/constraints`, and pairs `/webperf` with performance-optimization although `/webperf` invokes no skill.
3. **After 86bcm901a merges:** add `agent/code-reviewer,agent/security-auditor,agent/test-engineer` to `ship`'s `requires` and `agent/web-performance-auditor` to `webperf`'s (each a version bump and re-review); the client still installs no agents.
4. `delivery/stories.json` PR lists on main (see Other things found).

## Docs & records (task B13)

Updated by the build and the finish:
- `~/.hermes/plans/leorna/evidence/86bcm901b/plan-approved.md`: read-only copy of this plan (the main session, at go).
- `internal/library/README.md`: the module README note (B11).
- `internal/library/curation/curation.json`: 9 prompt reviews and the 3 stale notes (B7).
- `internal/library/content/library.json` (0.6.0), `internal/library/content.lock.json` (9 lines), `internal/library/content/items/prompt/<9 items>/` (B6).
- `delivery/stories.json`: append `"86bcm901b": {"name": "Curate the reusable prompts collection", "prs": {"LeornaAI/leorna-control-plane": []}}` last, as text; the PR number goes in only after a PR exists (Justin's "make a PR").
- `THIRD_PARTY_NOTICES.md` and `content/upstreams/agent-skills/{upstream.json,LICENSE}`: **unchanged** (pin unchanged); the existing notices test proves it on head.
- OpenAPI, migrations, seed, CI, ADRs: unchanged.
- `~/.hermes/plans/leorna/evidence/86bcm901b/EVIDENCE.md` and the artifacts above; `ac5-checklist.md`.
- `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-workflow.md`: story state (branch, head, review rounds, ac-check result, what's owed); the main session records it.
- Hand-over pack by the finisher under `evidence/86bcm901b/handover/`: stop-and-show, PR text (Christian's plain style, Assumptions with the follow-ups above and "hosted quality-gate run NOT VERIFIED until a PR"), the review prompt, the ClickUp evidence draft (AC → test → result, AC5 owed), the team message. Nothing pushed, opened or posted.

## Other things found (not fixed here)

1. **`delivery/stories.json` on `origin/main` misses merged PRs** (medium: `check-story-shippable.py` passes vacuously on an empty list): `86bcm9016` lists `[]` (PR #85 merged), `86bcm901u` `[]` (#90 merged), `86bcm9019` `[]` (#92 merged; 9019's local commit `3cd9b0f` with `[92]` was never pushed), and `86bcm945u` has no entry (#89 merged). Evidence: `delivery/stories.json` at `1ee7157` and `gh pr list`.
2. **README claims prompt import works** (low, docs): `internal/library/README.md` at `1ee7157` says "Prompts (`commands/*.toml`) and multi-file skills can now be imported", but `importer.go:156-157` refuses prompts and `library.go:255` rejects prompt sources. This story makes the sentence true.
3. **This desktop can't run the control-plane gates yet** (environment, blocks every role until B0.2): no Go, no PostgreSQL, Docker engine off and not integrated with WSL; Chrome for Testing's `--headless=new --screenshot` hangs.

## Completion contract

The builder returns `ready-for-review` with: head SHA and base, the commit list (all `Justin Issa <justin@leorna.com>`), `git status` clean, the gate summary lines with exit codes, the four AC logs (head and RED), the mutation list, the evidence inventory (with anything owed named), the environment it set up, its rulings, `found_else` and `skill_lessons`. It never pushes, opens a PR, posts to ClickUp or merges. The pipeline then runs reviewer 1 → fixer → reviewer 2 → fixer → verifier → blind AC auditor → `ac-check.sh` (expected **READY FOR THE USER**, AC5 owed to Justin) → finisher hand-over.
