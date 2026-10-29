# 86bcm901r — Role-based starter packs (plan)

ClickUp [Role-based starter packs](https://app.clickup.com/t/86bcm901r) · PI-2 · E10 Content Library · Size M · p1-high · Justin · "to do".
Repo: **`leorna-control-plane` only** (no client change). Pipeline: **Full** (away grant). Planned 2026-10-29 by a fresh Opus 5.5 xhigh planner against GitHub `main` **`6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f`** (= `origin/main` after the planner's HTTPS fetch through `gh`, checked equal to `gh api …/commits/main`; client `main` `f105e27814b6efbec67059687963e722933acec2`, read only).

**Status: approved 2026-10-29 under Justin's away grant** ("just keep everything going and follow what the recommended agent says"). Justin's answers: **Q1 A, Q2 A, Q3 A, Q4 A, Q5 A, Q6 A** (every ⭐), including the proposed AC4 (then a live check) and AC5. The grant covers this story up to the hand-over only: no push, PR, merge, ClickUp post, CI or credential change. ~~AC4 stays owed to Justin.~~ *(amended below)*

**Amended 2026-10-29: AC4 is agent-run (Justin: "Can't you do AC4 by yourself?" → "Agent does it, counts")** **Amendment approved 2026-10-29: Justin "Go"** on the rewritten AC4 below. **QA1 answered: "Fix it if a fixer runs"**: review-1 at `abc60dc` came back clean (MOVE ON), so no fixer ran; `internal/pack/README.md:300` stays a P3 docs follow-up and the PR text says how AC4 was proven.

**2026-10-29, after ALL ACCEPTED on `abc60dc`:** GitHub `main` moved to `b985422` (PR #99, 86bcm901y, merged). Justin: **"Yes, merge it in"** (this story's migration becomes **000025**, `insertVersionItems(…, false)`, a test helper renamed; the same fixer fixes `internal/pack/README.md:300` under QA1), **"Light now, full after the PR"** (a review of the merge plus the fixer's gates and all five AC checks now; the full verifier, blind auditor and `ac-check.sh` on the PR's head after it opens), and **"Yes, make a PR after"** (push + open once the merge is reviewed; never merge; no ClickUp post until "post"). **Then, while the #99 fixer ran:** Justin: "don't run verifications and everything now, because I'm gonna merge PR [100] and then we need to run verifications again here." So the #99 fixer stops after the merge commits and a build/vet sanity check; no review, verification or PR until his other PR has merged, main is brought in again, and verification runs once on that head. The #99 fixer committed merge `034156e` (migration now `000025_starter_packs`, `insertVersionItems(…, false)`, helper `mintStarterDesktopToken`) and docs `805b6cd` (QA1 README line); gofmt, build, vet and the migration check pass on `805b6cd`; nothing else ran. **Current head: `805b6cd`, unverified.**

**2026-10-29, later:** PRs #100 (86bcm9023 item editor) and #101 (86bcm902a quick start) merged; GitHub `main` is `e2254e0`. Justin: "update the main branch then rerun AC and verification and everything … get the updated main then pull the main branch". Done by the main session: local `main` fast-forwarded to `e2254e0`. Next: a fixer merges `e2254e0` into the branch (#101 took migration 000025, so this story's becomes **000026_starter_packs**; #101 ships a stand-in starter list in `internal/onboarding/starters.go` that its plan says this story "replaces"), then review-2 (full), verifier, blind auditor, `ac-check.sh`, finisher, and the PR ("Yes, make a PR after"). Justin on the #101 stand-in list: **"Separate story later"**: this PR only merges main; switching the quick start to this story's shared starter packs is a new card (a follow-up for the hand-over), and the stand-in stays as #101 shipped it.

## Amendments

Amendment 1, 2026-10-29 (Justin's decision "Agent does it, counts": the planner rewrites AC4 as an agent check; the verifier and a blind auditor each prove it on the head named in their brief, so `ac-check.sh` can print ALL ACCEPTED). Lines changed by it carry *(amended 2026-10-29)*. The pre-amendment text is the read-only approved copy `~/.hermes/plans/leorna/evidence/86bcm901r/plan-approved.md` as installed at "go" (the main session moves it aside as `plan-approved-v1-….md` before reinstalling this plan), with a byte-identical copy at `~/.hermes/plans/leorna/86bcm901r-ac4-spike/plan-before-amendment.md` (sha256 `4f36452d178a0460…`).
- What changed: the fourth acceptance criterion drops its live tag and names an agent-run check, `ac4_starter_pack_desktop_sync` (`~/.hermes/plans/leorna/86bcm901r-ac4/run.sh`). It builds a dev-mode test server from the commit under test on a fresh database of its own, does the catalog and assignment steps in headless Chrome, runs leorna-client `main` `f105e27`'s own sign-in and Sync code (not the app window) in a throwaway home and project, compares the written files with the checklist's lists, and takes the screenshots. Its ids, the other ACs and their test names are unchanged; the live set goes from {AC4} to none.
- No control-plane change: the check lives outside both repos (`~/.hermes/plans/leorna/86bcm901r-ac4/`), and `ac-check.sh` accepts it from its TAP line (`ok 1 - ac4_starter_pack_desktop_sync`), so no builder and no extra review round are needed for it.
- Proven by the planner's trial run (2026-10-29, logs in `~/.hermes/plans/leorna/86bcm901r-ac4-spike/`): `ok 1` on `398af64` and on the fixer's merge commit `abc60dc`; `not ok 1` on base `6c1709e` and on `dd006b7` (GitHub `main` after PR #98), each failing on its own lines (no Starter packs section, `starter-backend-1` not offered, "No bundle is assigned to the selected project").
- Earlier receipts that still encode the old expectation (AC4 live, owed to Justin), and what is now expected instead:
  - `evidence/86bcm901r/ac4-live/CHECKLIST.md` and `hand-over/ac4-steps.md`: Justin's manual steps. Superseded by the agent check; their expected lists (26 / 21 / 26 files) are now `86bcm901r-ac4/expected/backend-{claude-code,codex,cursor}.txt`, copied unchanged.
  - `verifier/ac.json` and `auditor/ac.json` (head `398af64`): the AC4 entry is `not_run: live`. Now each report proves it: `accepted: true` with its own `ac4-<head7>.log`, `ac4-base-<base7>.log` and `ac4-<head7>/ac4-sync.png`.
  - `INVENTORY.md`, `hand-over/stop-and-show.md`, `hand-over/pr-body.md`, `hand-over/review-prompt.md`, `hand-over/clickup-comment.md`: say AC4 is live, NOT VERIFIED or owed to Justin, and quote `READY FOR THE USER … AC4`. The finisher rewrites them from the new reports: AC4 agent-run and accepted, `ALL ACCEPTED` expected; what it doesn't cover goes under Assumptions (Risks below).

## Open question from Amendment 1 (one; ⭐ is the planner's recommendation)

**QA1 (answered: "Fix it if a fixer runs"; none ran). The branch's `internal/pack/README.md:300` (at `398af64` and `abc60dc`) says "Live: one desktop Sync of a starter pack into Claude Code, Codex and Cursor (owed to Justin)."** After this amendment that line is out of date.
- A ⭐ Leave the reviewed repo unchanged; the finisher lists the line as a follow-up (a docs-only P3) and the PR text says how AC4 was proven
- B One docs commit now ("Agent-run: a real leorna-client Sync … proven by the AC4 check"), reviewed in the same round as the fixer's merge commit

Why A: the brief prefers no repo change for this amendment, a stale "owed" note misleads nobody about the code, and B adds a commit that needs its own review, verifier and auditor. If the merge fixer's round has not been reviewed yet, B costs little: the main session decides.

## Open questions (answered by Justin's away grant, 2026-10-29: every ⭐; the plan is written as if each ⭐ was chosen)

**Flags (⭐ answers that touch a recorded decision):**
- **Q1 ⭐ A adjusts the card's mapping**, which the card marks "to confirm": `/plan` ships as `/planning` (86bcm901b Q2 decision, because Claude Code has a built-in `/plan`), and 5 required skills are added, as 86bcm901b's recorded follow-up 2 asks ("each pack that holds a prompt holds its `requires`").
- **Q4 ⭐ A narrows a recorded deferral.** 9019 (F), 86bcm901a and 86bcm901j (Q3) each left the old single starter seed (`internal/pack/seed.json` 1.2.0) "to 86bcm901r". This plan leaves the seed unchanged again and records it as a follow-up for 86bcm902a (the setup quick start) or its own card. The reasons are under Q4.

**Q1. Which packs, with which items?** The card names 28 distinct items, and 27 of them are on `main` `6c1709e`: 19 skills (9019), 6 prompts (86bcm901b) and the 2 agents `web-performance-auditor` and `security-auditor` (86bcm901a), all merged, so nothing waits on a sibling. The 28th, `/plan`, doesn't exist: 86bcm901b shipped it as `prompt/planning`.
- A ⭐ Card's mapping, `/plan`→`/planning`, plus each prompt's required skills
- B Card's mapping exactly; prompts may name skills the pack lacks
- C A, plus the 3 agents `/ship` asks for in Platform/DevOps

With A, Backend gains `doubt-driven-development` (required by `/build`), `browser-testing-with-devtools` (`/test`), and `performance-optimization` and `security-and-hardening` (`/review`). Secure coding gains `performance-optimization` (`/review`). Frontend and Platform/DevOps are exactly the card's lists. Result: Backend has 16 items (11 skills, 5 prompts). Frontend has 5 (3 skills, the `web-performance-auditor` agent, `/webperf`). Platform/DevOps has 6 (5 skills, `/ship`). Secure coding (regulated) has 8 (6 skills, the `security-auditor` agent, `/review`). Required items are added automatically when a pack resolves (`Library.Required`, followed transitively), so a later library change to a prompt's `requires` reaches the packs on the next release. `/code-simplify` and `/constraints` are in no pack (the card names none), as 86bcm901b noted.

**Q2. AC3: when a library release updates an item, what happens to teams already on that starter pack?**
- A ⭐ New starter version; teams keep theirs until an admin assigns it
- B Teams on a starter pack move to the new version on their next Sync
- C Rewrite the existing version in place

Why A: pack versions are immutable (migration 23's triggers refuse `UPDATE`/`DELETE`), assignments bind one version id (`pack_assignments.pack_version_id`), and every other path already works this way: 9016 "existing assignments stay on their current version", and 901w "teams keep their assigned version until you assign the new one". B changes what engineers run without an admin acting; it needs an assignment-to-role model and `ResolveForProject` changes, so it would be a follow-up story. C is refused by the database.

**Q3. How are starter packs stored, and do they build on 86bcm901w's packs?** 901w is **merged** (PR #96, `6c1709e`), so "wait for it" is moot: this plan builds on `main`, 901w included. But 901w's packs are per-company (`pack_lineages.tenant_id NOT NULL`, and the `pack_versions_pack_tenant` CHECK in `migrations/000023_pack_builder.up.sql`). A fresh install has no company until the first admin signs in, so a starter pack must be shared, like the seed base and the library.
- A ⭐ Shared pack versions + migration 24 (role, number, release)
- B Shared pack versions named by convention, no migration
- C A per-company copy (901w pack) made when a company first signs in

Why A: shared rows (`tenant_id` NULL) are already readable, assignable and served to the desktop by every existing path (`ListByTenant`, `resolveVersionTx`, `GetByID`), so AC2 needs no new assignment or Sync code. Three explicit columns plus CHECKs keep a starter version's identity out of the free-text version id, and the database enforces "only shared rows". B parses version ids. C needs a sign-in hook, multiplies rows per company, and makes "pick up the new version" a per-company migration.

**Q4. The old single starter seed (`seed.json` 1.2.0) still ships the demo skills and agents and `github-mcp` 2.0.0, and three siblings left it to this story. What now?**
- A ⭐ Leave it unchanged; refresh or retire it with 86bcm902a or its own card
- B Refresh it to the library's current items here (seed 1.3.0)
- C Retire it: setup loads the role starter packs instead

Why A: the card's ACs don't touch the seed. B widens this story into the setup wizard's step and the tenant pack (`/admin/packs`). It would also put upstream (MIT) items into the seed, so the portal distribution (`cmd/distpack`, which ships `seed.json`) would need the third-party notice (library README, "Where the notice ships"). And the seed's unpinned `github-mcp` is only fixed by 86bcm901j's PR #98, which is still open. C is 86bcm902a's job (its AC1: "the quick start offers role-based starter packs" after setup). This story corrects the three README sentences that say "until 86bcm901r", so nothing claims the seed changed.

**Q5. Where do admins see the starter packs (AC1's "catalog")?**
- A ⭐ A "Starter packs" section on the Content library page
- B A, plus a JSON API in OpenAPI (both repos' contract checks)
- C Their own page under Packs

Why A: the Content library page (`/admin/library`, 86bcm901v) is the catalog, and it is admin-only already. No new route, no OpenAPI change (the DoD's "OpenAPI updated if the API is touched" doesn't apply), and no client change. 86bcm902a can read the same store method for its wizard.

**Q6. AC2 says engineers sync "in all three tools". How is that proven?**
- A ⭐ Automated: the served bundle, rendered by the client's transformer copy; plus a live AC4 owed to Justin
- B Automated only; no live check
- C An agent builds and runs the desktop app against a local control plane

Why A: `internal/library/render` is a byte-for-byte copy of the client's transformers, pinned to client `main` `f105e27`, which is still client `main` today (`render/testdata/client/SOURCE.md`). So rendering exactly what `/v1/client/projects/{id}/bundles/{digest}/content` serves to a real desktop token proves which files each tool gets. The real desktop app on a real server is AC4 (live): only Justin can run it (his server, his app sign-in). C has no harness; it would be a cross-repo project.
*(amended 2026-10-29)* Amendment 1 adds a harness outside both repos after all: AC4 is now an agent-run check that runs the client's own Sync code (not the app window) against a dev-mode server built from the branch. AC2 is unchanged.

## Acceptance criteria

AC1–AC3 are the card's ACs in card order. AC4 and AC5 are **proposed** (approved with the plan). Each AC's Go test fails to build on the base commit (it uses symbols this story adds); AC4's check *(amended 2026-10-29)* builds the base and fails there on its own `not ok` line. The Postgres tests need `LEORNA_TEST_DATABASE_URL` (a database name ending `_test`) and **skip** without it, which never counts as a pass.

- AC1: Given a fresh install, then the agreed starter packs are available in the catalog. Test `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres`: `go test -v -count=1 -run '^TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres$' ./internal/web` (needs `LEORNA_TEST_DATABASE_URL`).
- AC2: Given a starter pack, when assigned to a team, then engineers sync it successfully in all three tools. Test `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres`: `go test -v -count=1 -run '^TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres$' ./internal/web` (needs `LEORNA_TEST_DATABASE_URL`).
- AC3: Given a library item update, then starter packs pick up the new version on the next library release. Test `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres`: `go test -v -count=1 -run '^TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres$' ./internal/store/postgres` (needs `LEORNA_TEST_DATABASE_URL`).
- AC4: *(amended 2026-10-29: agent-run, was Justin's manual desktop check)* Given a dev-mode test server built from the commit under test on a fresh database, where the Backend and Frontend starter packs are assigned as team defaults to two teams that each have a project, when the desktop client's own sign-in and Sync code (leorna-client `main` `f105e27`, run without its window, in a throwaway home and project) syncs each project into Claude Code, Codex and Cursor, then the Content library lists the four starter packs (`starter-<role>-1`), Pack Assignments offers and assigns `starter-backend-1` and `starter-frontend-1`, Sync completes with status success in all three tools, the Backend files on disk equal the checklist's lists (26 in the project's `.claude/commands` + `.claude/skills`, 21 in `~/.agents/skills`, 26 in `~/.cursor/commands` + `~/.cursor/skills`), Codex reports every prompt as not installed with the reason "Codex removed custom prompts in 0.117.0 and has no prompt location" and writes no prompt file, and every tool reports agent `web-performance-auditor` as not installed and writes no file for it. Test `ac4_starter_pack_desktop_sync`: `bash ~/.hermes/plans/leorna/86bcm901r-ac4/run.sh --repo <checkout> --work <new folder> --out <folder> --db leorna_86bcm901r_<role>_ac4_test` (full recipe under "AC4's check" below).
- AC5 (proposed): Given a starter pack definition that names an item the library doesn't ship, or a failed database write, when the control plane loads starter packs, then the load stops with an error naming the pack or step, writes no starter version, and a retry after the fix succeeds. Test `TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres`: `go test -v -count=1 -run '^TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres$' ./internal/store/postgres` (needs `LEORNA_TEST_DATABASE_URL`).

What each test proves:
- **AC1** runs the real startup loads, in `main.go`'s order, on a new database (`newPackFixture` makes a fresh schema with every migration). Then an admin's `/admin/library` must list exactly the four agreed packs, in order. Each must have its name, version id `starter-<role>-1`, and exactly the agreed `kind/name` items at the library's **current** version. The item lists are pinned in the test (an independent oracle); the versions are not, so a later item bump doesn't break it. A second company on the same install sees the same packs, and a member gets 403.
- **AC2** checks, for each of the four packs, that Pack Assignments offers it. It then assigns it to a team through the real form, and a real desktop token (Begin → Approve → Exchange, no bypass) reads `/bundle` and `/bundles/{digest}/content` as the app does. The served items must equal the pack's. Rendering them with `render.Transform` for Claude Code, Codex and Cursor must not fail. Every skill must land as `skills/<name>/SKILL.md` plus its supporting files (with a `.claude/` prefix for Claude Code). Every prompt must land as `.claude/commands/<name>.md` (Claude Code) or `commands/<name>.md` (Cursor). Codex prompts and every agent must write nothing and carry the renderer's reason, with an agent warning `agent "<name>" is not installed for <tool>; skipped`. Failure cases: a member's assign is refused (403) and changes nothing; another company's desktop token is refused (403).
- **AC3** loads the shipped library and starter packs, assigns `starter-backend-1` to a team, and forks it (a company's customised copy). It then loads the "next library release": the next minor version, with `skill/test-driven-development` at its next minor version and a changed body. Only Backend gets a new version, `starter-backend-2`: parent `starter-backend-1`, release = the new library version, same items except TDD at the new version with the new body. The other three packs keep version 1. `starter-backend-1`, the team's assignment and the forked copy are unchanged. A re-run changes nothing. A same-version library with changed items is **held**, and an older binary never replaces newer content.
- **AC4** *(amended 2026-10-29)* is the end-to-end run with the real desktop code. `run.sh` builds `./cmd/control-plane` from `--repo` (it checks `go version -m` shows that commit with `vcs.modified=false`) and runs it on `127.0.0.1:<free port>` with `LEORNA_DEV_MODE=1`, `LEORNA_AUTO_SETUP=1`, `LEORNA_PUBLIC_BASE_URL=https://demo.leorna.invalid` (an RFC 2606 name that resolves nowhere) and the new database `--db`; the startup log must say `starter packs loaded` with `added=4`. Headless Chrome (`browser/main.go`, chromedp) signs in through `/dev/login`, checks the Starter packs section (four cards, `starter-<role>-1`), makes "AC4 Backend team" and "AC4 Frontend team" with a project each, assigns `starter-backend-1` and `starter-frontend-1` as team defaults through the real form, and later approves the desktop sign-in on `/client/authorize`. `client-sync.go` is built inside a `git archive` copy of leorna-client `f105e27` (`go build -overlay`, the client's vendored modules) and calls exactly what the app's Sync button calls: `onboarding.HTTPResolver` + `application.ResolveDomain`, `login.Manager` Begin/Poll (device flow with PKCE), `distribution.ControlPlaneSource`, `available.DefaultRegistry`, `application.SaveSyncSelection`, `application.NewSyncEngine(...).Run` (mode `SyncConfirmed`, tools claude-code, codex, cursor) and `application.CheckSyncedFiles`. It syncs the Backend project, pauses while `run.sh` compares the files on disk with `expected/backend-*.txt`, then syncs the Frontend project. Three substitutions, printed in the log: the network path (requests for `https://demo.leorna.invalid` go to the loopback server over plain HTTP, Host header kept; any other host is refused), an in-memory credential store instead of the OS keyring (no Secret Service on WSL), and the Claude Code project folder passed in instead of the native folder picker. The base run fails at the catalog, the assignment and the Sync ("No bundle is assigned to the selected project").
- **AC5** covers two failures. A definition naming `skill/not-in-this-library` returns `library.ErrInvalid` naming `starter pack <role>` and the item, and writes nothing (resolution happens before the transaction). A forced write failure (`CHECK (false) NOT VALID` on `pack_version_items`) returns `library.ErrStarterLoad` naming `write backend version 1 items failed` and leaves no starter version (one transaction). After dropping the constraint, the retry adds all four.

## Playback

Justin's ask: pick ClickUp story 86bcm901r and keep the pipeline going on the ⭐ answers while he's away. The card: as an admin, I want role starter packs (Backend, Frontend, Platform/DevOps, Secure coding for regulated teams) so I can set up a team in minutes. Done means four curated packs from the content library that every fresh install shows in the catalog, that an admin assigns to a team like any pack version, and that engineers sync into Claude Code, Codex and Cursor; plus each library release that updates an item gives the pack a new version with it. Proven by AC1–AC3 tests (plus AC5), gates green, a hand-over pack ready, with no push, PR or ClickUp post. ~~AC4 (a real desktop Sync) is owed to Justin.~~ *(amended 2026-10-29)* AC4, the real desktop client's Sync against a server built from the branch, is agent-run: Justin asked "Can't you do AC4 by yourself?" and chose "Agent does it, counts", so the verifier and the blind auditor each prove it and `ac-check.sh` can print ALL ACCEPTED.

## What exists today (`main` `6c1709e`, file:line)

- **Library:** `internal/library/source.go:42` embeds `content/`, which ships one current version per item. Library `0.7.0` holds 26 skills, 10 prompts, 4 agents, 2 configs and 1 MCP template. `library.go:382` `Library.Required(item)` returns a prompt's required skills. It has no caller outside tests: 901w's `CreatePack` copies exactly the ticked items (`internal/store/postgres/pack_builder.go:221-262`). `internal/library/gate/gate.go:195` refuses any top-level entry in `content/` besides `library.json`, `items/` and `upstreams/`.
- **Library load:** `internal/store/postgres/library.go:16-87` (`EnsureLibrary`, rows keyed by `(kind, name, version)`, never rewritten). Startup calls `EnsureSeedBase` then `EnsureLibrary` (`cmd/control-plane/main.go:95-102`). The setup wizard reruns both under its lock (`internal/web/setup.go:317`).
- **Shared versions:** `pack_versions.tenant_id` is NULL for the seed base, with a partial unique index on `version` for shared rows (`migrations/000015_pack_versions.up.sql:12`). Every tenant reads them: `ListByTenant` (`pack_versions.go:184-218`), `GetByID`/`GetByVersion` (`:109-180`) and `resolveVersionTx` (`pack_assignments.go:92-125`, own row wins, then a pending-script check). The Pack Assignments page lists them as `<option value="{{.Version}}">{{.Name}} - {{.Version}}</option>` (`internal/web/pack_assignments.go:183,197`).
- **Immutability:** migration 23's triggers refuse `UPDATE`/`DELETE` on `pack_versions` and `pack_version_items` for every row (`000023_pack_builder.up.sql`).
- **Sync path:** `ResolveForProject` (`pack_assignments.go:168`) → `GET /v1/client/projects/{id}/bundle` (`internal/web/client_bundle.go:60-83`) → `bundle.Resolve` accepts any valid kind (`internal/bundle/bundle.go:42-47`); content by digest (`client_bundle_content.go:55-100`). The desktop renders with the transformers copied in `internal/library/render` (`render.go:90-115`; `NotInstalled`: agents in every tool, prompts in Codex). No shipped skill carries a script (only `references/*.md` files), so no starter pack needs script approval.
- **Catalog:** `/admin/library` (`internal/web/handler.go:281`, admin only), rendered by `renderLibrary` (`internal/web/library.go:133`) with `libraryTemplate` (`:236`).
- **Version ids:** tenant versions are `v<timestamp>Z` (`internal/pack/version_service.go:37-39`), so `starter-<role>-<n>` can't collide with them.
- **Locks:** transaction advisory locks named by `hashtextextended('leorna:<name>', 0)` (`internal/store/postgres/store.go:244`). Only migrations 1 and 2 are hash-pinned (`migrate.go:22-25`), so a new migration 24 needs no pin.
- **Seed:** `internal/pack/seed.json:3` version `1.2.0`, 9 items (demo skills `code-review-checklist` and `commit-message-style`, demo agents `code-reviewer@1.0.0` and `test-writer`, `github-mcp` 2.0.0, configs, `pr-description`). Unchanged by this story (Q4).
- **Client:** client `main` = `f105e27` = the commit `render` copies. The bundle carries only existing kinds, so no client change.

## Approach

1. **Definitions** (`internal/library/starter-packs.json`, embedded beside `content/`, not in it, because of the gate's layout rule): four packs, each with `role`, `name`, `description` and `items` as `kind/name`. `library.ParseStarterPacks` checks shape (strict JSON, unique roles, valid refs). `Library.ResolveStarterPack` takes the library's **current** version of each item and appends every required item (`Library.Required`, transitively, each once).
2. **Storage** (migration 24): `pack_versions` gains `starter_role`, `starter_number` and `starter_release`, with CHECKs (all three or none; only on shared rows that have no 901w `pack_id`; role slug; semver release) and `UNIQUE (starter_role, starter_number)`. Version id `starter-<role>-<n>`, name from the definition (e.g. "Backend starter pack").
3. **Load** (`(*Store).EnsureStarterPacks`, startup, right after `EnsureLibrary`): resolve every pack first, so a bad definition writes nothing. Then, in one transaction under `pg_advisory_xact_lock(hashtextextended('leorna:starter-packs', 0))`, for each role: no version yet → version 1. Items equal to the newest version's (sorted `kind/name@version`) → unchanged. Items differ **and** this library's version is newer than the newest version's `starter_release` → next number, parent = previous id. Otherwise → **held** (older binary, or a change shipped without a `library.json` bump), and startup logs a warning naming the roles. Not added to the setup wizard's step (86bcm902a owns that wizard).
4. **Read** (`(*Store).LatestStarterVersions`, tenant-scoped through `beginOrg`): the newest version of each role with items. The Content library page shows a **Starter packs** section above the builder and filters: one card per shipped definition, with name, description, version id, the library version it was built from, and a table of items with kind, version and "Installs in" (from `render.NotInstalled`, so agents and Codex prompts honestly say "Skipped in …").
5. **Assign and Sync** use the existing paths unchanged: Pack Assignments lists shared starter versions automatically, `AssignTeam` resolves them, and the desktop gets them through `ResolveForProject`.

## Skills

- Every role: `leorna` (role section), `engineering-best-practices`.
- Planner (loaded): `leorna` (PLANNER, with its Step 1 context load), `engineering-best-practices`, `implementation-planning`.
- Builder: `test-driven-development`, `backend-data-migrations` (migration 24 and the startup load), `mutation-testing-discipline` (T5's guards), `security-best-practices` (a new admin page section, a system write path, an advisory lock), `multi-tenant-auth-management` (shared rows read by every tenant; tenant-scoped reads; no cross-tenant write).
- Reviewers: `requesting-code-review` + `code-review-practice` (report only), plus the specialists above.
- Not needed: `api-contract-drift-guard` (no OpenAPI or contract change; the reviewers confirm `git diff --name-only` has no `contracts/` or `packages/contracts/` path).
- Mandatory Validation and Agent Defect Loop: checked with `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md` for the specialists above. **`backend-data-migrations` ends with that loop (also `api-contract-drift-guard`, not used here), so the hand-over waits for a clean VERIFIER: the pipeline's fixer → independent reviewer → verifier rounds are that loop (feature-dispatch → Agent Defect Loop).**

## Choices (made by the planner; reversible)

1. Control plane only. No client change: the render copy is pinned to client `main` `f105e27`, and the bundle carries only existing kinds.
2. The definitions file sits beside `content/` (the gate's layout rule). The library version is not bumped: no library item changes in this story, so `library.json`, `content.lock.json` and `curation.json` are untouched.
3. Startup-only load (after `EnsureLibrary`), with the same fail-stop rule as the library load. The setup wizard is unchanged.
4. A change with no `library.json` bump is **held** with a warning, not failed. Failing would stop a server on upgrade for a forgotten informational bump; holding waits for the next real release, which matches the card's "on the next library release".
5. No audit record for the load: it is a system step with no actor, like `EnsureSeedBase` and `EnsureLibrary`. Assigning still writes `pack.assign`.
6. The page reads through `beginOrg(…, false)`; the route stays admin-only (`requireAdmin`). There is no new route.
7. Starter item order is not stored. Pages list items by kind, then name (byte order, sorted in Go), as 901w does.
8. A role removed from a later definitions file keeps its versions (still assignable on Pack Assignments) but leaves the catalog section.

## Assumptions

- "Repo: content" means the control plane's content library area (`internal/library`). This story adds `internal/library/starter-packs.json`, with the store, web and migration code beside it.
- "Fresh install" means a new database after the control plane's startup (migrations, seed base, library, starter packs). The packs are shared, so every company on that install sees them.
- "The catalog" means the Content library page (Q5).
- "Sync successfully in all three tools" means the desktop's Sync completes for each tool: every item that tool installs is present, and items it skips by design (agents everywhere until the client installs agents, prompts in Codex) are reported with their reason, as 86bcm901a and 86bcm901b established. So Frontend's `web-performance-auditor` and Secure coding's `security-auditor` install nowhere yet.
- "The next library release" means a binary whose `internal/library/content/library.json` version is newer (the README already tells every content change to bump it).
- The pack descriptions are the planner's wording. The Secure coding description says it "does not make a project compliant with any regulation" (no compliance claim).
- ~~AC4 needs a server Justin installs from this branch himself (local image mode) and a desktop app built from client `main` ≥ `f105e27`.~~ *(amended 2026-10-29)* AC4's check builds its own dev-mode server from the commit under test and runs the client code of `main` `f105e27` (still client `main` on 2026-10-29). Older apps reject prompt items (pack README, 86bcm9016).

## Worktree, branch, databases, host

- **Worktree** `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs` on branch **`feat/86bcm901r-starter-packs`**, made by the builder in T0 from a freshly fetched `origin/main`. The main checkout is never switched; its local `main` is only fast-forwarded in T0. No client worktree.
- **Databases** in the `leorna-test-pg` container (read the port with `docker port leorna-test-pg 5432/tcp`; it was `127.0.0.1:55432`; never touch `leorna-pg` on 5432):
  - `leorna_86bcm901r_test`: the builder's tests and gates.
  - `leorna_86bcm901r_base_test`: base-commit runs, in a separate detached worktree only.
  - `leorna_86bcm901r_demo_test`: the dev-mode binary for AC1's screenshot (dropped and recreated before each capture, so it is a fresh install).
  - Later roles each get their own, `leorna_86bcm901r_<role><n>_test` (e.g. `_review1_test`, `_verify1_test`, `_audit1_test`), named in their briefs. Drop your own databases when done. Never use a sibling's.
- **Host (checked by the planner, 2026-10-29):**
  - Present: `make` (GNU Make 4.4.1), `gcc` 15.2.0 (cgo on, so `make test`'s `-race` works), `docker` with `leorna-test-pg` up, gitleaks 8.30.1 at `/usr/local/bin` (= CI), and Chrome for Testing with its libs.
  - The toolchain is in `~/.local/leorna-toolchain`: Go 1.27.3 (= `go.mod`), golangci-lint 2.14.0 (= CI `GOLANGCI_LINT_VERSION`) and govulncheck v1.7.0 (= CI). `go`, `golangci-lint` and `govulncheck` are **not** on the default PATH: use them through a task-local PATH and bind `GOLANGCI_LINT`/`GOVULNCHECK` to their absolute paths.
  - `psql` is not installed: use `docker exec leorna-test-pg psql …`. If `docker` says "permission denied", run it as `/mnt/c/Windows/System32/wsl.exe -e docker …` (memory, `leorna-control-plane-workflow.md`).
  - Nothing is missing, so there is no setup question.
- **Scratch:** keep `TMPDIR`, `GOTMPDIR`, lint caches, binaries and Chrome profiles in `~/.cache/86bcm901r-<role>/` (made with `mkdir`, no `-p`), never on `/tmp`, which is a small shared RAM disk. Remove it at the end by its literal path.

## Tasks (build order, test first)

Commit after each task with `git commit -m "<type>(86bcm901r): …"`. Never override the author; it is `Justin Issa <justin@leorna.com>`, with no AI attribution lines. Stage files by name, never `-A`. The code below was compiled, vetted, gofmt-checked and linted (golangci-lint 2.14.0, 0 issues) by the planner in a `git archive` copy of `6c1709e`. It was **not run**: the builder runs every test for the first time, RED then GREEN.

### T0. Worktree, fresh main, databases (setup)

```bash
set -euo pipefail
CP=~/Leorna/leorna-control-plane
WT="$CP/.claude/worktrees/86bcm901r-starter-packs"
EV=~/.hermes/plans/leorna/evidence/86bcm901r
mkdir -p "$EV"
mkdir ~/.cache/86bcm901r-builder ~/.cache/86bcm901r-builder/tmp
# 1. Fresh main from GitHub over HTTPS through gh (URL written out, never in a variable).
git -C "$CP" -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main
BASE=$(git -C "$CP" rev-parse origin/main)
test "$BASE" = "$(gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha)"
# 2. Did main move since the plan (6c1709e) in what this plan touches?
git -C "$CP" diff --name-only 6c1709e "$BASE" -- internal/library internal/pack internal/store/postgres internal/web cmd/control-plane delivery
ls "$CP/internal/store/postgres/migrations" | tail -2
```

- Step 2 prints nothing → go on. If it lists files: read each change against this plan. Expected and fine: 86bcm901j's PR #98 merging (`internal/library/README.md`, `content.lock.json`, `library.json` 0.8.0, config and MCP items, `gate/`; none of them in a starter pack). **Stop and report** if `main` has a migration `000024_*` (renumber this story's to the next free number and say so), or if a file this plan edits changed in a way the code below no longer fits.

```bash
# 3. Fast-forward the main checkout's local main (memory: leorna-update-main-before-worktree).
test "$(git -C "$CP" branch --show-current)" = main
test -z "$(git -C "$CP" status --porcelain --untracked-files=no)"
git -C "$CP" merge --ff-only origin/main    # if it refuses: stop and report, change nothing
# 4. The story worktree and branch from that SHA.
git -C "$CP" worktree add -b feat/86bcm901r-starter-packs "$WT" "$BASE"
test "$(git -C "$CP" rev-parse main)" = "$BASE"
test "$(git -C "$WT" rev-parse HEAD)" = "$BASE"
printf 'BASE=%s\n' "$BASE" > "$EV/base.txt"
git -C "$WT" log -1 --pretty=format:'%an <%ae>%n'     # the config this worktree will commit with
# 5. Own databases; the password never reaches a command line or a log.
PGPW=$(docker inspect leorna-test-pg --format '{{range .Config.Env}}{{println .}}{{end}}' | sed -n 's/^POSTGRES_PASSWORD=//p')
test -n "$PGPW"
PGPORT=$(docker port leorna-test-pg 5432/tcp | head -1 | sed 's/.*://')
for db in leorna_86bcm901r_test leorna_86bcm901r_base_test leorna_86bcm901r_demo_test; do
  docker exec leorna-test-pg psql -U leorna -d leorna_test -v ON_ERROR_STOP=1 -c "CREATE DATABASE $db"
done
umask 077
printf 'export LEORNA_TEST_DATABASE_URL=%q\n' "postgres://leorna:${PGPW}@127.0.0.1:${PGPORT}/leorna_86bcm901r_test?sslmode=disable" > ~/.cache/86bcm901r-builder/env.sh
```

If the session can't write the main checkout (Claude Code worktree isolation), stop and report; don't work around it.

### T1. Starter pack definitions and resolution (`internal/library`)

RED: add `internal/library/starter_test.go` (below) and run `go test -count=1 -run 'TestEmbeddedStarterPacksResolveAgainstTheShippedLibrary|TestParseStarterPacksRejectsMalformedDefinitions|TestResolveStarterPackAddsRequiredItemsOnce|TestCompareVersions' ./internal/library`. Expect `undefined: EmbeddedStarterPacks` (and the rest). GREEN: add `starter-packs.json` and `starter.go` (below), then run the same command plus `go test -count=1 ./internal/library/...`. Commit: `feat(86bcm901r): define the role starter packs`.

`internal/library/starter-packs.json`:

```json
{
  "packs": [
    {
      "role": "backend",
      "name": "Backend starter pack",
      "description": "For engineers who build services and APIs: write the spec, plan the work, build it in small test-first steps, design the interface, debug, and review the change.",
      "items": [
        "skill/spec-driven-development",
        "skill/planning-and-task-breakdown",
        "skill/incremental-implementation",
        "skill/test-driven-development",
        "skill/api-and-interface-design",
        "skill/code-review-and-quality",
        "skill/debugging-and-error-recovery",
        "prompt/spec",
        "prompt/planning",
        "prompt/build",
        "prompt/test",
        "prompt/review"
      ]
    },
    {
      "role": "frontend",
      "name": "Frontend starter pack",
      "description": "For engineers who build web interfaces: UI engineering, browser testing with DevTools and web performance, with the web performance auditor agent and the /webperf command.",
      "items": [
        "skill/frontend-ui-engineering",
        "skill/browser-testing-with-devtools",
        "skill/performance-optimization",
        "agent/web-performance-auditor",
        "prompt/webperf"
      ]
    },
    {
      "role": "platform-devops",
      "name": "Platform/DevOps starter pack",
      "description": "For platform and DevOps engineers: CI/CD, git workflow, observability, shipping and launch, and deprecation and migration, with the /ship command.",
      "items": [
        "skill/ci-cd-and-automation",
        "skill/git-workflow-and-versioning",
        "skill/observability-and-instrumentation",
        "skill/shipping-and-launch",
        "skill/deprecation-and-migration",
        "prompt/ship"
      ]
    },
    {
      "role": "secure-coding",
      "name": "Secure coding (regulated) starter pack",
      "description": "Secure coding practices for teams with strict security requirements, such as regulated industries: hardening, code review, doubt-driven and source-driven development, and decision records, with the security auditor agent and the /review command. It does not make a project compliant with any regulation.",
      "items": [
        "skill/security-and-hardening",
        "skill/code-review-and-quality",
        "skill/doubt-driven-development",
        "skill/documentation-and-adrs",
        "skill/source-driven-development",
        "agent/security-auditor",
        "prompt/review"
      ]
    }
  ]
}
```

`internal/library/starter.go`:

```go
package library

import (
	"bytes"
	"cmp"
	_ "embed"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strings"
	"unicode/utf8"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// starterPacksFile is the starter pack definitions file, embedded beside
// content/ rather than in it: the quality gate allows only library.json,
// items/ and upstreams/ at the top of content/.
const starterPacksFile = "starter-packs.json"

// MaxStarterPacks bounds the starter pack definitions.
const MaxStarterPacks = 32

//go:embed starter-packs.json
var starterPacksJSON []byte

// ErrStarterLoad reports that the starter packs could not be written. The load
// runs in one transaction, so it can safely run again.
var ErrStarterLoad = errors.New("load starter packs failed")

// StarterPack is one role's curated selection of library items (story
// 86bcm901r). Items name library items as "kind/name", like Requires. A
// starter pack always takes the library's current version of each item, so a
// library release that ships a new item version gives the pack a new version.
type StarterPack struct {
	Role        string   `json:"role"`
	Name        string   `json:"name"`
	Description string   `json:"description"`
	Items       []string `json:"items"`
}

// StarterLoadResult counts what a starter pack load did. Held names the roles
// whose items changed while the library version did not move past the one
// their newest starter version was built from, so nothing was written for them.
type StarterLoadResult struct {
	Added     int
	Unchanged int
	Held      []string
}

type starterPacksDocument struct {
	Packs []StarterPack `json:"packs"`
}

// EmbeddedStarterPacks returns the starter pack definitions shipped in this
// binary. They are checked for shape; ResolveStarterPack checks each one
// against a library.
func EmbeddedStarterPacks() ([]StarterPack, error) {
	return ParseStarterPacks(starterPacksJSON)
}

// ParseStarterPacks decodes and checks starter pack definitions. Unknown
// fields, trailing data, duplicate roles and malformed item names are refused.
func ParseStarterPacks(raw []byte) ([]StarterPack, error) {
	decoder := json.NewDecoder(bytes.NewReader(raw))
	decoder.DisallowUnknownFields()
	var document starterPacksDocument
	if err := decoder.Decode(&document); err != nil {
		return nil, invalid(starterPacksFile, fmt.Sprintf("is not valid JSON for this file (%v)", err))
	}
	if err := decoder.Decode(&struct{}{}); !errors.Is(err, io.EOF) {
		return nil, invalid(starterPacksFile, "has trailing data")
	}
	if len(document.Packs) == 0 || len(document.Packs) > MaxStarterPacks {
		return nil, invalid(starterPacksFile, fmt.Sprintf("needs 1 to %d packs", MaxStarterPacks))
	}
	roles := make(map[string]struct{}, len(document.Packs))
	for _, starter := range document.Packs {
		if err := starter.Validate(); err != nil {
			return nil, err
		}
		if _, duplicate := roles[starter.Role]; duplicate {
			return nil, invalid(starterPacksFile, "role "+starter.Role+" appears more than once")
		}
		roles[starter.Role] = struct{}{}
	}
	return document.Packs, nil
}

// Validate checks one definition's fields. Errors name the role.
func (starter StarterPack) Validate() error {
	if !validSlug(starter.Role) {
		return invalid(starterPacksFile, "role must be lowercase words joined by hyphens, at most 64 characters")
	}
	where := "starter pack " + starter.Role
	if !validText(starter.Name) || strings.TrimSpace(starter.Name) != starter.Name || starter.Name == "" || utf8.RuneCountInString(starter.Name) > 200 {
		return invalid(where, "name must be 1 to 200 characters without surrounding spaces")
	}
	if !validText(starter.Description) || strings.TrimSpace(starter.Description) == "" || utf8.RuneCountInString(starter.Description) > pack.MaxDescriptionRunes {
		return invalid(where, fmt.Sprintf("description must be 1 to %d characters", pack.MaxDescriptionRunes))
	}
	if len(starter.Items) == 0 || len(starter.Items) > pack.MaxItems {
		return invalid(where, fmt.Sprintf("needs 1 to %d items", pack.MaxItems))
	}
	seen := make(map[string]struct{}, len(starter.Items))
	for _, ref := range starter.Items {
		kind, name, ok := strings.Cut(ref, "/")
		if !ok || !pack.Kind(kind).Valid() || !validSlug(name) {
			return invalid(where, "item "+ref+" must be kind/name")
		}
		if _, duplicate := seen[ref]; duplicate {
			return invalid(where, "item "+ref+" appears more than once")
		}
		seen[ref] = struct{}{}
	}
	return nil
}

// ResolveStarterPack returns the library items the starter pack installs: each
// item it lists, then every item those require (Library.Required, followed
// transitively) that it does not list, each once, in the order first reached.
// An item the library does not ship fails, naming the role and the item.
func (library Library) ResolveStarterPack(starter StarterPack) ([]Item, error) {
	if err := starter.Validate(); err != nil {
		return nil, err
	}
	byRef := make(map[string]Item, len(library.Items))
	for _, item := range library.Items {
		byRef[string(item.Kind)+"/"+item.Name] = item
	}
	where := "starter pack " + starter.Role
	queue := append([]string(nil), starter.Items...)
	seen := make(map[string]bool, len(queue))
	resolved := make([]Item, 0, len(queue))
	for index := 0; index < len(queue); index++ {
		ref := queue[index]
		if seen[ref] {
			continue
		}
		item, ok := byRef[ref]
		if !ok {
			return nil, invalid(where, "names "+ref+", which is not in this library")
		}
		seen[ref] = true
		resolved = append(resolved, item)
		for _, required := range library.Required(item) {
			queue = append(queue, string(required.Kind)+"/"+required.Name)
		}
	}
	if len(resolved) > pack.MaxItems {
		return nil, invalid(where, fmt.Sprintf("resolves to more than %d items", pack.MaxItems))
	}
	return resolved, nil
}

// AsPackItem is the item a library item becomes in a pack version: its kind,
// name, version, description, body and supporting files.
func (item Item) AsPackItem() pack.SeedItem {
	return pack.SeedItem{Kind: item.Kind, Name: item.Name, Version: item.Version, Description: item.Description, Body: item.Body, Files: item.Files}
}

// CompareVersions compares two MAJOR.MINOR.PATCH versions number by number, as
// the catalog does (1.10.0 is newer than 1.9.0), returning -1, 0 or +1.
func CompareVersions(a, b string) (int, error) {
	if !semverPattern.MatchString(a) || !semverPattern.MatchString(b) {
		return 0, invalid("version", "must be MAJOR.MINOR.PATCH")
	}
	left, right := strings.Split(a, "."), strings.Split(b, ".")
	for part := range 3 {
		// semverPattern allows digits without leading zeros, so a longer part
		// is a larger number; equal lengths compare as text. No number overflows.
		if order := cmp.Or(cmp.Compare(len(left[part]), len(right[part])), strings.Compare(left[part], right[part])); order != 0 {
			return order, nil
		}
	}
	return 0, nil
}
```

`internal/library/starter_test.go`:

```go
package library

import (
	"errors"
	"slices"
	"strings"
	"testing"

	"github.com/LeornaAI/leorna-control-plane/internal/pack"
)

// TestEmbeddedStarterPacksResolveAgainstTheShippedLibrary is the CI check on
// the shipped definitions: each one resolves against the shipped library, and
// every item a pack holds has what it requires in the same pack.
func TestEmbeddedStarterPacksResolveAgainstTheShippedLibrary(t *testing.T) {
	shipped, err := Embedded()
	if err != nil {
		t.Fatal(err)
	}
	starters, err := EmbeddedStarterPacks()
	if err != nil {
		t.Fatal(err)
	}
	for _, starter := range starters {
		resolved, err := shipped.ResolveStarterPack(starter)
		if err != nil {
			t.Fatalf("%s: %v", starter.Role, err)
		}
		held := make(map[string]bool, len(resolved))
		for _, item := range resolved {
			held[string(item.Kind)+"/"+item.Name] = true
		}
		for _, item := range resolved {
			for _, ref := range item.Requires {
				if !held[ref] {
					t.Fatalf("%s holds %s/%s but not %s, which it requires", starter.Role, item.Kind, item.Name, ref)
				}
			}
		}
	}
}

func TestParseStarterPacksRejectsMalformedDefinitions(t *testing.T) {
	valid := `{"role":"backend","name":"Backend starter pack","description":"For backend engineers.","items":["skill/a"]}`
	cases := map[string]string{
		"not JSON":           `{`,
		"unknown field":      `{"packs":[` + valid + `],"extra":1}`,
		"unknown pack field": `{"packs":[{"role":"backend","name":"B","description":"D","items":["skill/a"],"tools":[]}]}`,
		"trailing data":      `{"packs":[` + valid + `]} {}`,
		"no packs":           `{"packs":[]}`,
		"bad role":           `{"packs":[{"role":"Back End","name":"B","description":"D","items":["skill/a"]}]}`,
		"duplicate role":     `{"packs":[` + valid + `,` + valid + `]}`,
		"blank name":         `{"packs":[{"role":"backend","name":"","description":"D","items":["skill/a"]}]}`,
		"padded name":        `{"packs":[{"role":"backend","name":" B","description":"D","items":["skill/a"]}]}`,
		"blank description":  `{"packs":[{"role":"backend","name":"B","description":" ","items":["skill/a"]}]}`,
		"no items":           `{"packs":[{"role":"backend","name":"B","description":"D","items":[]}]}`,
		"item without kind":  `{"packs":[{"role":"backend","name":"B","description":"D","items":["a"]}]}`,
		"unknown kind":       `{"packs":[{"role":"backend","name":"B","description":"D","items":["widget/a"]}]}`,
		"bad item name":      `{"packs":[{"role":"backend","name":"B","description":"D","items":["skill/Bad_Name"]}]}`,
		"duplicate item":     `{"packs":[{"role":"backend","name":"B","description":"D","items":["skill/a","skill/a"]}]}`,
	}
	for name, raw := range cases {
		t.Run(name, func(t *testing.T) {
			if _, err := ParseStarterPacks([]byte(raw)); !errors.Is(err, ErrInvalid) {
				t.Fatalf("ParseStarterPacks(%s) error = %v, want ErrInvalid", raw, err)
			}
		})
	}
	if _, err := ParseStarterPacks([]byte(`{"packs":[` + valid + `]}`)); err != nil {
		t.Fatalf("a valid definition was refused: %v", err)
	}
}

func TestResolveStarterPackAddsRequiredItemsOnce(t *testing.T) {
	skill := func(name string, requires ...string) Item {
		return Item{Kind: pack.KindSkill, Name: name, Version: "1.0.0", Requires: requires}
	}
	lib := Library{Items: []Item{
		skill("listed"),
		skill("chained", "skill/deep"),
		skill("deep"),
		{Kind: pack.KindPrompt, Name: "go", Version: "1.0.0", Requires: []string{"skill/chained", "skill/listed"}},
	}}
	starter := StarterPack{Role: "backend", Name: "Backend starter pack", Description: "D", Items: []string{"skill/listed", "prompt/go"}}
	resolved, err := lib.ResolveStarterPack(starter)
	if err != nil {
		t.Fatal(err)
	}
	var got []string
	for _, item := range resolved {
		got = append(got, string(item.Kind)+"/"+item.Name)
	}
	if want := []string{"skill/listed", "prompt/go", "skill/chained", "skill/deep"}; !slices.Equal(got, want) {
		t.Fatalf("resolved %v, want %v", got, want)
	}
	starter.Items = append(starter.Items, "skill/missing")
	if _, err := lib.ResolveStarterPack(starter); !errors.Is(err, ErrInvalid) || !strings.Contains(err.Error(), "starter pack backend") || !strings.Contains(err.Error(), "skill/missing") {
		t.Fatalf("missing item error = %v", err)
	}
}

func TestCompareVersions(t *testing.T) {
	for _, test := range []struct {
		a, b string
		want int
	}{
		{"1.10.0", "1.9.0", 1}, {"0.7.0", "0.8.0", -1}, {"2.0.0", "2.0.0", 0}, {"1.0.10", "1.0.9", 1}, {"10.0.0", "9.99.99", 1},
	} {
		if got, err := CompareVersions(test.a, test.b); err != nil || got != test.want {
			t.Fatalf("CompareVersions(%s, %s) = %d, %v; want %d", test.a, test.b, got, err, test.want)
		}
	}
	if _, err := CompareVersions("1.0", "1.0.0"); !errors.Is(err, ErrInvalid) {
		t.Fatalf("a malformed version was compared: %v", err)
	}
}
```

### T2. Migration 24 and the load and read store (`internal/pack`, `internal/store/postgres`)

RED: add `internal/store/postgres/starter_packs_test.go` (below). Run, with the env file sourced: `go test -v -count=1 -run 'TestStarterPacksAC3|TestStarterPacksAC5|TestEnsureStarterPacksWaitsForAConcurrentLoad|TestStarterColumnsAreOnlyOnSharedVersions' ./internal/store/postgres`. Expect a build failure (`undefined: ensureStarterPacks`, `pack.StarterVersionID`…).

GREEN: add `internal/pack/starter.go`, the two migration files and `internal/store/postgres/starter_packs.go`. Then run the same command, **plus** `go test -count=1 ./internal/store/postgres ./internal/pack` (`TestMigrationRoundTrip` must still pass, since migration 24's down only drops columns). Read the `-v` output and confirm no test says `SKIP`. Commit: `feat(86bcm901r): load role starter packs as shared pack versions`.

`internal/pack/starter.go`:

```go
package pack

import (
	"context"
	"fmt"

	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// StarterVersion is one immutable version of a role starter pack (story
// 86bcm901r). Starter versions are shared like the seed base (no tenant), so
// every tenant can read and assign them. Number counts a role's versions from
// 1; Release is the content library version the version was built from.
type StarterVersion struct {
	Role    string
	Number  int
	Release string
	Version PackVersion // the shared pack version and its items
}

// StarterVersionID is the version id of a role's numbered starter version: the
// string an administrator picks on Pack Assignments.
func StarterVersionID(role string, number int) string {
	return fmt.Sprintf("starter-%s-%d", role, number)
}

// StarterStore reads the newest version of every role starter pack.
type StarterStore interface {
	LatestStarterVersions(ctx context.Context, actor store.Principal) ([]StarterVersion, error)
}
```

`internal/store/postgres/migrations/000024_starter_packs.up.sql`:

```sql
-- Role starter packs (story 86bcm901r) are shared pack versions (tenant_id
-- NULL, like the seed base) built from content library items at startup. Each
-- role has its own numbered line of versions; starter_release is the content
-- library version a starter version was built from. Tenant versions and packs
-- built with the pack builder never carry these columns.
ALTER TABLE pack_versions
 ADD COLUMN starter_role text NULL CHECK (char_length(starter_role) BETWEEN 1 AND 64 AND starter_role ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
 ADD COLUMN starter_number integer NULL CHECK (starter_number >= 1),
 ADD COLUMN starter_release text NULL CHECK (starter_release ~ '^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'),
 ADD CONSTRAINT pack_versions_starter_complete CHECK ((starter_role IS NULL) = (starter_number IS NULL) AND (starter_role IS NULL) = (starter_release IS NULL)),
 ADD CONSTRAINT pack_versions_starter_shared CHECK (starter_role IS NULL OR (tenant_id IS NULL AND pack_id IS NULL)),
 ADD CONSTRAINT pack_versions_starter_number_key UNIQUE (starter_role, starter_number);
```

`internal/store/postgres/migrations/000024_starter_packs.down.sql`:

```sql
-- Starter versions stay as plain shared versions, so assignments to them keep
-- working; only their role, number and release are dropped. Prefer
-- fix-forward: after a down and an up, startup cannot add starter-<role>-1
-- again (that version id is taken) and stops, naming the step.
ALTER TABLE pack_versions
 DROP CONSTRAINT pack_versions_starter_number_key,
 DROP CONSTRAINT pack_versions_starter_shared,
 DROP CONSTRAINT pack_versions_starter_complete,
 DROP COLUMN starter_release,
 DROP COLUMN starter_number,
 DROP COLUMN starter_role;
```

`internal/store/postgres/starter_packs.go`:

```go
package postgres

import (
	"context"
	"errors"
	"fmt"
	"slices"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/jackc/pgx/v5"
)

var _ pack.StarterStore = (*Store)(nil)

// EnsureStarterPacks writes the role starter packs shipped in this binary as
// shared pack versions (story 86bcm901r). It is a system operation, run at
// startup right after EnsureLibrary, and is not tenant-scoped.
func (database *Store) EnsureStarterPacks(ctx context.Context) (library.StarterLoadResult, error) {
	shipped, err := library.Embedded()
	if err != nil {
		return library.StarterLoadResult{}, err
	}
	starters, err := library.EmbeddedStarterPacks()
	if err != nil {
		return library.StarterLoadResult{}, err
	}
	return database.ensureStarterPacks(ctx, shipped, starters)
}

// plannedStarter is one starter pack resolved against the library, before the
// transaction starts.
type plannedStarter struct {
	starter library.StarterPack
	items   []pack.SeedItem
}

// ensureStarterPacks resolves every starter pack against the library first, so
// a definition naming a missing item writes nothing. Then, in one transaction
// that replicas take in turn, it adds a role's next version only when the
// role's items differ from its newest version and this library is a newer
// release than the one that version was built from; a role with no version
// gets version 1. A re-run changes nothing, an older binary never replaces
// newer content, and existing versions, assignments and tenant versions are
// never changed.
func (database *Store) ensureStarterPacks(ctx context.Context, shipped library.Library, starters []library.StarterPack) (library.StarterLoadResult, error) {
	if err := shipped.Validate(); err != nil {
		return library.StarterLoadResult{}, err
	}
	planned := make([]plannedStarter, 0, len(starters))
	for _, starter := range starters {
		resolved, err := shipped.ResolveStarterPack(starter)
		if err != nil {
			return library.StarterLoadResult{}, err
		}
		items := make([]pack.SeedItem, 0, len(resolved))
		for _, item := range resolved {
			items = append(items, item.AsPackItem())
		}
		planned = append(planned, plannedStarter{starter: starter, items: items})
	}

	tx, err := database.pool.Begin(ctx)
	if err != nil {
		return library.StarterLoadResult{}, starterLoadError("begin")
	}
	defer func() { _ = tx.Rollback(ctx) }()
	if _, err := tx.Exec(ctx, `SELECT pg_advisory_xact_lock(hashtextextended('leorna:starter-packs', 0))`); err != nil {
		return library.StarterLoadResult{}, starterLoadError("lock")
	}
	var result library.StarterLoadResult
	for _, next := range planned {
		role := next.starter.Role
		latest, found, err := latestStarterTx(ctx, tx, role)
		if err != nil {
			return library.StarterLoadResult{}, starterLoadError("read " + role)
		}
		number, parent := 1, ""
		if found {
			stored, err := starterItemRefsTx(ctx, tx, latest.Version.ID)
			if err != nil {
				return library.StarterLoadResult{}, starterLoadError("read " + role + " items")
			}
			if slices.Equal(stored, starterItemRefs(next.items)) {
				result.Unchanged++
				continue
			}
			order, err := library.CompareVersions(shipped.Version, latest.Release)
			if err != nil {
				return library.StarterLoadResult{}, starterLoadError("compare " + role + " releases")
			}
			if order <= 0 {
				result.Held = append(result.Held, role)
				continue
			}
			number, parent = latest.Number+1, latest.Version.Version
		}
		if err := database.insertStarterVersionTx(ctx, tx, next.starter, number, shipped.Version, parent, next.items); err != nil {
			return library.StarterLoadResult{}, err
		}
		result.Added++
	}
	if err := tx.Commit(ctx); err != nil {
		return library.StarterLoadResult{}, starterLoadError("commit")
	}
	return result, nil
}

// insertStarterVersionTx writes one shared starter version and its items.
func (database *Store) insertStarterVersionTx(ctx context.Context, tx pgx.Tx, starter library.StarterPack, number int, release, parent string, items []pack.SeedItem) error {
	version := pack.StarterVersionID(starter.Role, number)
	if err := (pack.NewPackVersion{Name: starter.Name, Version: version, ParentVersion: parent, Items: items}).Validate(); err != nil {
		return err
	}
	id, err := newUUID(database.random)
	if err != nil {
		return err
	}
	if _, err := tx.Exec(ctx,
		`INSERT INTO pack_versions(id,tenant_id,name,version,parent_version,starter_role,starter_number,starter_release)
		 VALUES($1,NULL,$2,$3,$4,$5,$6,$7)`,
		id, strings.TrimSpace(starter.Name), version, parent, starter.Role, number, release,
	); err != nil {
		return starterLoadError(fmt.Sprintf("write %s version %d", starter.Role, number))
	}
	if err := database.insertVersionItems(ctx, tx, id, items); err != nil {
		return starterLoadError(fmt.Sprintf("write %s version %d items", starter.Role, number))
	}
	return nil
}

// latestStarterTx reads a role's newest starter version without its items.
func latestStarterTx(ctx context.Context, tx pgx.Tx, role string) (pack.StarterVersion, bool, error) {
	var latest pack.StarterVersion
	err := tx.QueryRow(ctx,
		`SELECT id,name,version,parent_version,created_at,starter_role,starter_number,starter_release
		 FROM pack_versions WHERE tenant_id IS NULL AND starter_role=$1
		 ORDER BY starter_number DESC LIMIT 1`, role,
	).Scan(&latest.Version.ID, &latest.Version.Name, &latest.Version.Version, &latest.Version.ParentVersion, &latest.Version.CreatedAt, &latest.Role, &latest.Number, &latest.Release)
	if errors.Is(err, pgx.ErrNoRows) {
		return pack.StarterVersion{}, false, nil
	}
	if err != nil {
		return pack.StarterVersion{}, false, err
	}
	return latest, true, nil
}

// starterItemRefsTx lists a stored version's items as sorted kind/name@version.
// Library item versions are immutable, so equal references mean equal content.
func starterItemRefsTx(ctx context.Context, tx pgx.Tx, versionID string) ([]string, error) {
	rows, err := tx.Query(ctx, `SELECT kind,name,version FROM pack_version_items WHERE pack_version_id=$1`, versionID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	refs := make([]string, 0)
	for rows.Next() {
		var kind, name, version string
		if err := rows.Scan(&kind, &name, &version); err != nil {
			return nil, err
		}
		refs = append(refs, kind+"/"+name+"@"+version)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	slices.Sort(refs)
	return refs, nil
}

// starterItemRefs lists items as sorted kind/name@version, like starterItemRefsTx.
func starterItemRefs(items []pack.SeedItem) []string {
	refs := make([]string, 0, len(items))
	for _, item := range items {
		refs = append(refs, string(item.Kind)+"/"+strings.TrimSpace(item.Name)+"@"+strings.TrimSpace(item.Version))
	}
	slices.Sort(refs)
	return refs
}

// LatestStarterVersions returns the newest version of every role starter pack
// with its items, sorted by role. Any current user of the tenant may read them;
// the routes add the admin check. Script approvals shown are the tenant's own.
func (database *Store) LatestStarterVersions(ctx context.Context, actor store.Principal) ([]pack.StarterVersion, error) {
	tx, _, err := database.beginOrg(ctx, actor, false)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	rows, err := tx.Query(ctx,
		`SELECT DISTINCT ON (starter_role) id,name,version,parent_version,created_at,starter_role,starter_number,starter_release
		 FROM pack_versions WHERE tenant_id IS NULL AND starter_role IS NOT NULL
		 ORDER BY starter_role, starter_number DESC`)
	if err != nil {
		return nil, orgError(err)
	}
	versions := make([]pack.StarterVersion, 0)
	for rows.Next() {
		var starter pack.StarterVersion
		if err := rows.Scan(&starter.Version.ID, &starter.Version.Name, &starter.Version.Version, &starter.Version.ParentVersion, &starter.Version.CreatedAt, &starter.Role, &starter.Number, &starter.Release); err != nil {
			rows.Close()
			return nil, orgError(err)
		}
		versions = append(versions, starter)
	}
	rows.Close()
	if err := rows.Err(); err != nil {
		return nil, orgError(err)
	}
	// The connection is free again, so each version's items can be read.
	for index := range versions {
		versions[index].Version.Items, err = loadVersionItems(ctx, tx, versions[index].Version.ID, string(actor.TenantID))
		if err != nil {
			return nil, orgError(err)
		}
	}
	slices.SortFunc(versions, func(a, b pack.StarterVersion) int { return strings.Compare(a.Role, b.Role) })
	return versions, nil
}

// starterLoadError keeps database details out of the message but names the
// step, like libraryLoadError.
func starterLoadError(step string) error {
	return fmt.Errorf("%w: %s failed; retry setup, it is safe to run again", library.ErrStarterLoad, step)
}
```

`internal/store/postgres/starter_packs_test.go`:

```go
package postgres

import (
	"context"
	"errors"
	"fmt"
	"slices"
	"strconv"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
)

// shippedStarterContent returns the library and starter pack definitions
// shipped in this binary.
func shippedStarterContent(t *testing.T) (library.Library, []library.StarterPack) {
	t.Helper()
	shipped, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	starters, err := library.EmbeddedStarterPacks()
	if err != nil {
		t.Fatal(err)
	}
	return shipped, starters
}

// nextLibraryRelease is the shipped library's next minor release in which the
// item ref ships its next minor version with a changed body.
func nextLibraryRelease(t *testing.T, shipped library.Library, ref string) (library.Library, library.Item) {
	t.Helper()
	bumpMinor := func(version string) string {
		parts := strings.Split(version, ".")
		minor, err := strconv.Atoi(parts[1])
		if err != nil {
			t.Fatal(err)
		}
		return fmt.Sprintf("%s.%d.0", parts[0], minor+1)
	}
	next := shipped
	next.Version = bumpMinor(shipped.Version)
	next.Items = slices.Clone(shipped.Items)
	for index, item := range next.Items {
		if string(item.Kind)+"/"+item.Name == ref {
			item.Version = bumpMinor(item.Version)
			item.Body += "\nThis line arrives with the next library release.\n"
			next.Items[index] = item
			return next, item
		}
	}
	t.Fatalf("%s is not in the shipped library", ref)
	return library.Library{}, library.Item{}
}

func starterVersionCount(t *testing.T, pool *pgxpool.Pool) int {
	t.Helper()
	var count int
	if err := pool.QueryRow(context.Background(), `SELECT count(*) FROM pack_versions WHERE starter_role IS NOT NULL`).Scan(&count); err != nil {
		t.Fatal(err)
	}
	return count
}

func starterByRole(t *testing.T, versions []pack.StarterVersion, role string) pack.StarterVersion {
	t.Helper()
	for _, version := range versions {
		if version.Role == role {
			return version
		}
	}
	t.Fatalf("no starter version for %s", role)
	return pack.StarterVersion{}
}

func itemRefs(items []pack.Item) []string {
	refs := make([]string, 0, len(items))
	for _, item := range items {
		refs = append(refs, string(item.Kind)+"/"+item.Name+"@"+item.Version)
	}
	slices.Sort(refs)
	return refs
}

func TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres(t *testing.T) {
	pool := testPool(t)
	repository := seedBaseStore(t, pool)
	ctx := context.Background()
	shipped, starters := shippedStarterContent(t)
	if _, err := repository.loadLibrary(ctx, shipped); err != nil {
		t.Fatal(err)
	}
	if first, err := repository.ensureStarterPacks(ctx, shipped, starters); err != nil || first.Added != len(starters) {
		t.Fatalf("first load = %+v, %v; want %d added", first, err, len(starters))
	}
	admin, err := repository.ResolveOrCreateGoogleUser(ctx, store.GoogleIdentity{Subject: "starter-admin", Email: "admin@example.com", DisplayName: "Admin"})
	if err != nil {
		t.Fatal(err)
	}
	scoped := store.WithTenant(ctx, admin.TenantID)
	team, err := repository.CreateTeam(scoped, admin, "Backend team")
	if err != nil {
		t.Fatal(err)
	}
	backendOne := pack.StarterVersionID("backend", 1)
	if _, err := repository.AssignTeam(scoped, admin, team.ID, backendOne); err != nil {
		t.Fatal(err)
	}
	customised, err := pack.NewVersionService(repository).Fork(scoped, admin, backendOne)
	if err != nil {
		t.Fatal(err)
	}
	before, err := repository.LatestStarterVersions(scoped, admin)
	if err != nil {
		t.Fatal(err)
	}

	// The next library release updates test-driven-development, which only the
	// Backend starter pack holds (through /test and /build's requires too).
	next, updated := nextLibraryRelease(t, shipped, "skill/test-driven-development")
	if _, err := repository.loadLibrary(ctx, next); err != nil {
		t.Fatal(err)
	}
	result, err := repository.ensureStarterPacks(ctx, next, starters)
	if err != nil {
		t.Fatal(err)
	}
	if result.Added != 1 || result.Unchanged != len(starters)-1 || len(result.Held) != 0 {
		t.Fatalf("next release load = %+v, want 1 added and the rest unchanged", result)
	}
	after, err := repository.LatestStarterVersions(scoped, admin)
	if err != nil {
		t.Fatal(err)
	}

	t.Run("the starter pack's next version holds the new item version", func(t *testing.T) {
		for _, starter := range after {
			old := starterByRole(t, before, starter.Role)
			if starter.Role != "backend" {
				if starter.Version.ID != old.Version.ID || starter.Number != 1 {
					t.Fatalf("%s changed although none of its items did", starter.Role)
				}
				continue
			}
			if starter.Number != 2 || starter.Version.Version != pack.StarterVersionID("backend", 2) || starter.Version.ParentVersion != backendOne || starter.Release != next.Version {
				t.Fatalf("backend newest = #%d %s parent %s release %s", starter.Number, starter.Version.Version, starter.Version.ParentVersion, starter.Release)
			}
			want := itemRefs(old.Version.Items)
			for index, ref := range want {
				if strings.HasPrefix(ref, "skill/test-driven-development@") {
					want[index] = "skill/test-driven-development@" + updated.Version
				}
			}
			slices.Sort(want)
			if got := itemRefs(starter.Version.Items); !slices.Equal(got, want) {
				t.Fatalf("backend #2 items = %v\nwant %v", got, want)
			}
			for _, item := range starter.Version.Items {
				if item.Name == updated.Name && item.Body != updated.Body {
					t.Fatal("backend #2 does not carry the updated body")
				}
			}
		}
	})
	t.Run("the earlier version, the team's assignment and the company's customised copy stay as they were", func(t *testing.T) {
		kept, err := repository.GetByVersion(scoped, admin, backendOne)
		if err != nil {
			t.Fatal(err)
		}
		if !slices.Equal(itemRefs(kept.Items), itemRefs(starterByRole(t, before, "backend").Version.Items)) {
			t.Fatal("starter version 1 changed")
		}
		assignments, err := repository.ListAssignments(scoped, admin)
		if err != nil {
			t.Fatal(err)
		}
		if len(assignments) != 1 || assignments[0].Version != backendOne {
			t.Fatalf("assignment moved: %+v", assignments)
		}
		copied, err := repository.GetByID(scoped, admin, customised.ID)
		if err != nil {
			t.Fatal(err)
		}
		if !slices.Equal(itemRefs(copied.Items), itemRefs(customised.Items)) {
			t.Fatal("the company's customised copy changed")
		}
	})
	t.Run("a re-run of the same release changes nothing", func(t *testing.T) {
		again, err := repository.ensureStarterPacks(ctx, next, starters)
		if err != nil || again.Added != 0 || again.Unchanged != len(starters) {
			t.Fatalf("re-run = %+v, %v", again, err)
		}
	})
	t.Run("changed items without a newer library version are held", func(t *testing.T) {
		sameRelease, _ := nextLibraryRelease(t, next, "skill/spec-driven-development")
		sameRelease.Version = next.Version
		if _, err := repository.loadLibrary(ctx, sameRelease); err != nil {
			t.Fatal(err)
		}
		held, err := repository.ensureStarterPacks(ctx, sameRelease, starters)
		if err != nil || held.Added != 0 || !slices.Equal(held.Held, []string{"backend"}) {
			t.Fatalf("same-release load = %+v, %v; want backend held", held, err)
		}
	})
	t.Run("an older binary never replaces newer content", func(t *testing.T) {
		older, err := repository.ensureStarterPacks(ctx, shipped, starters)
		if err != nil || older.Added != 0 || !slices.Equal(older.Held, []string{"backend"}) {
			t.Fatalf("older binary load = %+v, %v; want backend held", older, err)
		}
		if count := starterVersionCount(t, pool); count != len(starters)+1 {
			t.Fatalf("%d starter versions, want %d", count, len(starters)+1)
		}
	})
}

func TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres(t *testing.T) {
	pool := testPool(t)
	repository := seedBaseStore(t, pool)
	ctx := context.Background()
	shipped, starters := shippedStarterContent(t)
	if _, err := repository.loadLibrary(ctx, shipped); err != nil {
		t.Fatal(err)
	}
	t.Run("a pack naming an item the library does not ship", func(t *testing.T) {
		broken := slices.Clone(starters)
		last := len(broken) - 1
		broken[last].Items = append(slices.Clone(broken[last].Items), "skill/not-in-this-library")
		_, err := repository.ensureStarterPacks(ctx, shipped, broken)
		if !errors.Is(err, library.ErrInvalid) || !strings.Contains(err.Error(), "starter pack "+broken[last].Role) || !strings.Contains(err.Error(), "skill/not-in-this-library") {
			t.Fatalf("error = %v, want one naming the pack and the item", err)
		}
		if count := starterVersionCount(t, pool); count != 0 {
			t.Fatalf("a refused load wrote %d starter versions", count)
		}
	})
	t.Run("a failed write rolls everything back and a retry succeeds", func(t *testing.T) {
		if _, err := pool.Exec(ctx, `ALTER TABLE pack_version_items ADD CONSTRAINT starter_write_fails CHECK (false) NOT VALID`); err != nil {
			t.Fatal(err)
		}
		_, err := repository.ensureStarterPacks(ctx, shipped, starters)
		wantStep := fmt.Sprintf("write %s version 1 items failed", starters[0].Role)
		if !errors.Is(err, library.ErrStarterLoad) || !strings.Contains(err.Error(), wantStep) {
			t.Fatalf("error = %v, want ErrStarterLoad naming %q", err, wantStep)
		}
		if count := starterVersionCount(t, pool); count != 0 {
			t.Fatalf("a failed load left %d starter versions", count)
		}
		if _, err := pool.Exec(ctx, `ALTER TABLE pack_version_items DROP CONSTRAINT starter_write_fails`); err != nil {
			t.Fatal(err)
		}
		retry, err := repository.ensureStarterPacks(ctx, shipped, starters)
		if err != nil || retry.Added != len(starters) {
			t.Fatalf("retry = %+v, %v", retry, err)
		}
	})
}

// TestEnsureStarterPacksWaitsForAConcurrentLoadWithPostgres holds the starter
// lock in another transaction that is writing version 1 of every role, the way
// a second replica starting at the same moment would. The load must wait, then
// find that work done; without the lock it reads no versions, collides on the
// version ids and fails.
func TestEnsureStarterPacksWaitsForAConcurrentLoadWithPostgres(t *testing.T) {
	pool := testPool(t)
	repository := seedBaseStore(t, pool)
	ctx := context.Background()
	shipped, starters := shippedStarterContent(t)
	if _, err := repository.loadLibrary(ctx, shipped); err != nil {
		t.Fatal(err)
	}
	other, err := pool.Begin(ctx)
	if err != nil {
		t.Fatal(err)
	}
	var waiting sync.WaitGroup
	defer func() {
		_ = other.Rollback(ctx)
		waiting.Wait()
	}()
	if _, err := other.Exec(ctx, `SELECT pg_advisory_xact_lock(hashtextextended('leorna:starter-packs', 0))`); err != nil {
		t.Fatal(err)
	}
	for _, starter := range starters {
		resolved, err := shipped.ResolveStarterPack(starter)
		if err != nil {
			t.Fatal(err)
		}
		items := make([]pack.SeedItem, 0, len(resolved))
		for _, item := range resolved {
			items = append(items, item.AsPackItem())
		}
		if err := repository.insertStarterVersionTx(ctx, other, starter, 1, shipped.Version, "", items); err != nil {
			t.Fatal(err)
		}
	}
	type outcome struct {
		result library.StarterLoadResult
		err    error
	}
	done := make(chan outcome, 1)
	waiting.Add(1)
	go func() {
		defer waiting.Done()
		result, err := repository.ensureStarterPacks(ctx, shipped, starters)
		done <- outcome{result, err}
	}()
	deadline := time.Now().Add(5 * time.Second)
	for {
		var blocked bool
		if err := pool.QueryRow(ctx, `SELECT EXISTS (SELECT 1 FROM pg_stat_activity
			WHERE wait_event_type = 'Lock' AND query LIKE '%pg_advisory_xact_lock%' AND pid <> pg_backend_pid())`).Scan(&blocked); err != nil {
			t.Fatal(err)
		}
		if blocked {
			break
		}
		if time.Now().After(deadline) {
			t.Fatal("the load never waited for the starter lock")
		}
		time.Sleep(20 * time.Millisecond)
	}
	if err := other.Commit(ctx); err != nil {
		t.Fatal(err)
	}
	got := <-done
	if got.err != nil || got.result.Added != 0 || got.result.Unchanged != len(starters) {
		t.Fatalf("waiting load = %+v, %v; want every role unchanged", got.result, got.err)
	}
	if count := starterVersionCount(t, pool); count != len(starters) {
		t.Fatalf("%d starter versions, want %d", count, len(starters))
	}
}

// TestStarterColumnsAreOnlyOnSharedVersionsWithPostgres pins migration 24's
// constraints: only a shared version can be a starter version, the three
// starter columns come together, and a role has one version per number.
func TestStarterColumnsAreOnlyOnSharedVersionsWithPostgres(t *testing.T) {
	pool := testPool(t)
	repository := seedBaseStore(t, pool)
	ctx := context.Background()
	admin, err := repository.ResolveOrCreateGoogleUser(ctx, store.GoogleIdentity{Subject: "starter-columns", Email: "admin@example.com", DisplayName: "Admin"})
	if err != nil {
		t.Fatal(err)
	}
	insert := `INSERT INTO pack_versions(id,tenant_id,name,version,starter_role,starter_number,starter_release) VALUES(gen_random_uuid(),$1,'Pack',$2,$3,$4,$5)`
	if _, err := pool.Exec(ctx, insert, nil, "starter-backend-1", "backend", 1, "0.7.0"); err != nil {
		t.Fatalf("a complete shared starter version was refused: %v", err)
	}
	for name, test := range map[string]struct {
		tenant  any
		version string
		role    any
		number  any
		release any
		code    string
	}{
		"a company's version":          {admin.TenantID, "company-1", "backend", 2, "0.7.0", "23514"},
		"a role without number":        {nil, "starter-backend-x", "backend", nil, "0.7.0", "23514"},
		"a role without release":       {nil, "starter-backend-y", "backend", 3, nil, "23514"},
		"a malformed release":          {nil, "starter-backend-z", "backend", 4, "0.7", "23514"},
		"a malformed role":             {nil, "starter-Back-1", "Back End", 1, "0.7.0", "23514"},
		"a second version 1 of a role": {nil, "starter-backend-again", "backend", 1, "0.8.0", "23505"},
		"number zero":                  {nil, "starter-backend-0", "backend", 0, "0.7.0", "23514"},
	} {
		t.Run(name, func(t *testing.T) {
			_, err := pool.Exec(ctx, insert, test.tenant, test.version, test.role, test.number, test.release)
			var pgErr *pgconn.PgError
			if !errors.As(err, &pgErr) || pgErr.Code != test.code {
				t.Fatalf("insert error = %v, want SQLSTATE %s", err, test.code)
			}
		})
	}
}
```

Notes for the builder:
- The concurrency test makes the race happen on purpose (memory, `leorna-control-plane-workflow.md`: a test that runs after the row exists never races). Another transaction holds the starter lock while writing version 1 of every role. The test waits until the load is blocked on `pg_advisory_xact_lock` (`pg_stat_activity`, `LIKE`), commits, then expects every role unchanged. Its deferred rollback waits for the goroutine on every exit.
- Under load on this desktop, a 5 s wait can time out once. Run that test alone and rerun it before calling it a regression.

### T3. The catalog section, AC1 and AC2 (`internal/web`)

RED: add `internal/web/starter_packs_test.go` (below) and run `go test -v -count=1 -run 'TestStarterPacksAC1|TestStarterPacksAC2' ./internal/web` (env sourced). Expect a build failure (`undefined: (*Handler).SetStarterPacks` / `EnsureStarterPacks`). GREEN: add `internal/web/starter_packs.go` and the `library.go` and `handler.go` edits (diff in T4). Then run the same command and `go test -count=1 ./internal/web`; the existing library page tests must still pass, because without `SetStarterPacks` there is no section. Commit: `feat(86bcm901r): list the starter packs in the content library`.

`internal/web/starter_packs.go`:

```go
package web

import (
	"cmp"
	"context"
	"slices"
	"strings"

	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/render"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
)

// starterPackReader reads the newest shared version of each role starter pack.
type starterPackReader interface {
	LatestStarterVersions(ctx context.Context, actor store.Principal) ([]pack.StarterVersion, error)
}

// SetStarterPacks binds the role starter packs the Content library page lists,
// in the order of the definitions shipped in the binary (story 86bcm901r).
// Without it the page has no Starter packs section.
func (handler *Handler) SetStarterPacks(reader starterPackReader, definitions []library.StarterPack) {
	handler.starterPacks = reader
	handler.starterDefinitions = definitions
}

// starterSection is the Starter packs section of the Content library page.
type starterSection struct {
	Packs []starterPackRow
}

type starterPackRow struct {
	Role, Name, Description, Version, Release string
	Items                                     []starterItemRow
}

type starterItemRow struct {
	Kind              pack.Kind
	KindLabel         string
	Name, Version     string
	Installs, Skipped []string // tool labels; "<tool>: <reason>" for a tool that skips the kind
}

// starterSectionFor builds the section: one row per shipped definition with a
// loaded version, in definition order, items by kind and then name.
func (handler *Handler) starterSectionFor(ctx context.Context, actor store.Principal) (*starterSection, error) {
	versions, err := handler.starterPacks.LatestStarterVersions(ctx, actor)
	if err != nil {
		return nil, err
	}
	byRole := make(map[string]pack.StarterVersion, len(versions))
	for _, version := range versions {
		byRole[version.Role] = version
	}
	section := &starterSection{}
	for _, definition := range handler.starterDefinitions {
		version, loaded := byRole[definition.Role]
		if !loaded {
			continue
		}
		row := starterPackRow{Role: definition.Role, Name: version.Version.Name, Description: definition.Description, Version: version.Version.Version, Release: version.Release}
		items := slices.Clone(version.Version.Items)
		slices.SortFunc(items, func(a, b pack.Item) int {
			return cmp.Or(strings.Compare(string(a.Kind), string(b.Kind)), strings.Compare(a.Name, b.Name))
		})
		for _, item := range items {
			installs, skipped := starterInstallNotes(item.Kind)
			row.Items = append(row.Items, starterItemRow{Kind: item.Kind, KindLabel: item.Kind.Label(), Name: item.Name, Version: item.Version, Installs: installs, Skipped: skipped})
		}
		section.Packs = append(section.Packs, row)
	}
	return section, nil
}

// starterInstallNotes says which tools the desktop app installs a kind into,
// and why it skips the others (render.NotInstalled, the client's own rule).
func starterInstallNotes(kind pack.Kind) (installs, skipped []string) {
	for _, tool := range library.Tools() {
		if reason, skip := render.NotInstalled(kind, tool); skip {
			skipped = append(skipped, tool.Label()+": "+reason)
			continue
		}
		installs = append(installs, tool.Label())
	}
	return installs, skipped
}
```

`internal/web/starter_packs_test.go`:

```go
package web

import (
	"context"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"html"
	"net/http"
	"net/url"
	"regexp"
	"slices"
	"strings"
	"testing"
	"time"

	"github.com/LeornaAI/leorna-control-plane/internal/clientauth"
	"github.com/LeornaAI/leorna-control-plane/internal/library"
	"github.com/LeornaAI/leorna-control-plane/internal/library/render"
	"github.com/LeornaAI/leorna-control-plane/internal/pack"
	"github.com/LeornaAI/leorna-control-plane/internal/store"
	"github.com/LeornaAI/leorna-control-plane/internal/store/postgres"
	contracts "github.com/LeornaAI/leorna-control-plane/packages/contracts"
	"github.com/google/uuid"
)

// agreedStarterPacks is the approved mapping for story 86bcm901r (plan Q1): the
// card's proposal, with /plan shipped as /planning (86bcm901b) and each
// prompt's required skills added. Items are sorted by kind, then name, as the
// catalog lists them. Versions are not pinned here: a starter pack always takes
// the library's current version of an item.
var agreedStarterPacks = []struct {
	role, name string
	items      []string
}{
	{"backend", "Backend starter pack", []string{
		"prompt/build", "prompt/planning", "prompt/review", "prompt/spec", "prompt/test",
		"skill/api-and-interface-design", "skill/browser-testing-with-devtools", "skill/code-review-and-quality",
		"skill/debugging-and-error-recovery", "skill/doubt-driven-development", "skill/incremental-implementation",
		"skill/performance-optimization", "skill/planning-and-task-breakdown", "skill/security-and-hardening",
		"skill/spec-driven-development", "skill/test-driven-development",
	}},
	{"frontend", "Frontend starter pack", []string{
		"agent/web-performance-auditor", "prompt/webperf",
		"skill/browser-testing-with-devtools", "skill/frontend-ui-engineering", "skill/performance-optimization",
	}},
	{"platform-devops", "Platform/DevOps starter pack", []string{
		"prompt/ship",
		"skill/ci-cd-and-automation", "skill/deprecation-and-migration", "skill/git-workflow-and-versioning",
		"skill/observability-and-instrumentation", "skill/shipping-and-launch",
	}},
	{"secure-coding", "Secure coding (regulated) starter pack", []string{
		"agent/security-auditor", "prompt/review",
		"skill/code-review-and-quality", "skill/documentation-and-adrs", "skill/doubt-driven-development",
		"skill/performance-optimization", "skill/security-and-hardening", "skill/source-driven-development",
	}},
}

var (
	starterArticle     = regexp.MustCompile(`(?s)<article class="starter" id="starter-([a-z0-9-]+)">(.*?)</article>`)
	starterItemRowHTML = regexp.MustCompile(`<tr class="starter-item" data-kind="([a-z_]+)" data-name="([a-z0-9-]+)" data-version="([0-9.]+)">`)
	starterVersionHTML = regexp.MustCompile(`<code class="starter-version">([^<]+)</code>`)
)

// newStarterFixture is newPackFixture with the library and the shipped starter
// pack definitions wired, as cmd/control-plane wires them.
func newStarterFixture(t *testing.T) packFixture {
	t.Helper()
	definitions, err := library.EmbeddedStarterPacks()
	if err != nil {
		t.Fatal(err)
	}
	return newPackFixture(t, func(handler *Handler, repository *postgres.Store) {
		handler.SetLibrary(repository)
		handler.SetStarterPacks(repository, definitions)
	})
}

// loadShippedContent runs the control plane's startup loads in its order
// (cmd/control-plane/main.go): seed base, content library, starter packs.
func loadShippedContent(t *testing.T, fixture packFixture) library.StarterLoadResult {
	t.Helper()
	ctx := context.Background()
	if err := fixture.repository.EnsureSeedBase(ctx); err != nil {
		t.Fatal(err)
	}
	if _, err := fixture.repository.EnsureLibrary(ctx); err != nil {
		t.Fatal(err)
	}
	result, err := fixture.repository.EnsureStarterPacks(ctx)
	if err != nil {
		t.Fatal(err)
	}
	return result
}

func TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres(t *testing.T) {
	fixture := newStarterFixture(t)
	result := loadShippedContent(t, fixture)
	if result.Added != len(agreedStarterPacks) || result.Unchanged != 0 || len(result.Held) != 0 {
		t.Fatalf("fresh install starter load = %+v, want %d added", result, len(agreedStarterPacks))
	}
	shipped, err := library.Embedded()
	if err != nil {
		t.Fatal(err)
	}
	current := make(map[string]string, len(shipped.Items))
	for _, item := range shipped.Items {
		current[string(item.Kind)+"/"+item.Name] = item.Version
	}
	checkCatalog := func(t *testing.T, body string) {
		t.Helper()
		if !strings.Contains(body, `id="starter-packs"`) {
			t.Fatal("the Content library page has no Starter packs section")
		}
		articles := starterArticle.FindAllStringSubmatch(body, -1)
		if len(articles) != len(agreedStarterPacks) {
			t.Fatalf("catalog lists %d starter packs, want %d", len(articles), len(agreedStarterPacks))
		}
		for index, want := range agreedStarterPacks {
			role, article := articles[index][1], articles[index][2]
			if role != want.role {
				t.Fatalf("starter pack %d is %q, want %q", index, role, want.role)
			}
			if !strings.Contains(article, "<h3>"+html.EscapeString(want.name)+"</h3>") {
				t.Fatalf("%s: name %q missing", role, want.name)
			}
			if version := starterVersionHTML.FindStringSubmatch(article); version == nil || version[1] != pack.StarterVersionID(role, 1) {
				t.Fatalf("%s: version id = %v, want %s", role, version, pack.StarterVersionID(role, 1))
			}
			var got []string
			for _, row := range starterItemRowHTML.FindAllStringSubmatch(article, -1) {
				ref := row[1] + "/" + row[2]
				got = append(got, ref)
				if row[3] != current[ref] {
					t.Fatalf("%s: %s is version %s, want the library's current %s", role, ref, row[3], current[ref])
				}
			}
			if !slices.Equal(got, want.items) {
				t.Fatalf("%s items = %v\nwant %v", role, got, want.items)
			}
		}
	}

	t.Run("the catalog lists exactly the agreed packs at the library's current item versions", func(t *testing.T) {
		admin := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
		body := fixture.get(t, admin, "/admin/library", http.StatusOK)
		checkCatalog(t, body)
		// The page says honestly which tools skip a kind (render.NotInstalled).
		frontend := starterArticle.FindAllStringSubmatch(body, -1)[1][2]
		for _, want := range []string{"Skipped in Codex: ", "Skipped in Claude Code: the desktop client does not install agents yet"} {
			if !strings.Contains(frontend, want) {
				t.Fatalf("the Frontend starter pack does not say %q", want)
			}
		}
		t.Logf("starter packs section:\n%s", starterArticle.FindAllString(body, -1))
	})
	t.Run("every company on the install sees the same packs", func(t *testing.T) {
		other := fixture.login(t, fixture.other, strings.Repeat("d", 43))
		checkCatalog(t, fixture.get(t, other, "/admin/library", http.StatusOK))
	})
	t.Run("a member is refused", func(t *testing.T) {
		member := fixture.login(t, fixture.member, strings.Repeat("b", 43))
		if body := fixture.get(t, member, "/admin/library", http.StatusForbidden); strings.Contains(body, "starter-packs") {
			t.Fatal("refused page leaked the starter packs")
		}
	})
}

// mintDesktopToken signs a desktop client in with the real Begin, Approve and
// Exchange service, like TestPromptItemPublishToClientBundleWithPostgres.
func mintDesktopToken(t *testing.T, fixture packFixture, principal store.Principal) string {
	t.Helper()
	ctx := context.Background()
	service := clientauth.New(fixture.repository, time.Now)
	verifier := base64.RawURLEncoding.EncodeToString(make([]byte, 32))
	proof := sha256.Sum256([]byte(verifier))
	grant, err := service.Begin(ctx, principal.TenantID, base64.RawURLEncoding.EncodeToString(proof[:]))
	if err != nil {
		t.Fatal(err)
	}
	if err := service.Approve(ctx, grant.UserCode, principal); err != nil {
		t.Fatal(err)
	}
	credentials, err := service.Exchange(ctx, grant.DeviceCode, verifier)
	if err != nil {
		t.Fatal(err)
	}
	return credentials.AccessToken
}

func TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres(t *testing.T) {
	fixture := newStarterFixture(t)
	ctx := context.Background()
	scoped := store.WithTenant(ctx, fixture.admin.TenantID)
	fixture.handler.SetPackVersions(pack.NewVersionService(fixture.repository))
	fixture.handler.SetPackAssignments(fixture.repository)
	fixture.handler.SetBundleServer(fixture.repository)
	fixture.handler.SetClientAuth(fixture.repository)
	fixture.handler.SetTeams(fixture.repository)
	fixture.handler.SetProjects(fixture.repository)
	fixture.handler.discovery = &contracts.ClientDiscovery{BackendUrl: "https://cp.example", TenantId: uuid.MustParse(string(fixture.admin.TenantID)), TenantName: "Example"}
	loadShippedContent(t, fixture)
	team, err := fixture.repository.CreateTeam(scoped, fixture.admin, "Starter team")
	if err != nil {
		t.Fatal(err)
	}
	if err := fixture.repository.AddTeamMember(scoped, fixture.admin, team.ID, string(fixture.admin.UserID)); err != nil {
		t.Fatal(err)
	}
	project, err := fixture.repository.CreateProject(scoped, fixture.admin, team.ID, "Starter project", time.Now().Add(time.Hour))
	if err != nil {
		t.Fatal(err)
	}
	adminClient := fixture.login(t, fixture.admin, strings.Repeat("a", 43))
	memberClient := fixture.login(t, fixture.member, strings.Repeat("b", 43))
	desktop, otherDesktop := mintDesktopToken(t, fixture, fixture.admin), mintDesktopToken(t, fixture, fixture.other)
	post := func(client *http.Client, path string, form url.Values, want int) {
		t.Helper()
		form.Set("csrfToken", fixture.csrf)
		response := request(t, client, http.MethodPost, fixture.server.URL+path, "application/x-www-form-urlencoded", form.Encode())
		assertStatus(t, response, want)
		closeBody(t, response)
	}
	getBearer := func(token, path string, want int) string {
		t.Helper()
		outgoing, err := http.NewRequest(http.MethodGet, fixture.server.URL+path, nil)
		if err != nil {
			t.Fatal(err)
		}
		outgoing.Header.Set("Authorization", "Bearer "+token)
		response, err := fixture.server.Client().Do(outgoing)
		if err != nil {
			t.Fatal(err)
		}
		assertStatus(t, response, want)
		return readBody(t, response)
	}
	starters, err := fixture.repository.LatestStarterVersions(scoped, fixture.admin)
	if err != nil {
		t.Fatal(err)
	}
	if len(starters) != len(agreedStarterPacks) {
		t.Fatalf("loaded %d starter packs, want %d", len(starters), len(agreedStarterPacks))
	}
	for _, starter := range starters {
		t.Run(starter.Role, func(t *testing.T) {
			version := starter.Version.Version
			options := fixture.get(t, adminClient, "/admin/packs/assignments", http.StatusOK)
			if !strings.Contains(options, `<option value="`+version+`">`+html.EscapeString(starter.Version.Name)+` - `+version+`</option>`) {
				t.Fatalf("Pack Assignments does not offer %s", version)
			}
			post(adminClient, "/admin/packs/assignments/team", url.Values{"team_id": {team.ID}, "version": {version}}, http.StatusSeeOther)

			var metadata contracts.ClientBundle
			if err := json.Unmarshal([]byte(getBearer(desktop, "/v1/client/projects/"+project.ID+"/bundle", http.StatusOK)), &metadata); err != nil {
				t.Fatal(err)
			}
			if metadata.Status != contracts.Assigned || metadata.Manifest.PackVersion != version {
				t.Fatalf("bundle = %s %s, want assigned %s", metadata.Status, metadata.Manifest.PackVersion, version)
			}
			var content contracts.ClientBundleContent
			if err := json.Unmarshal([]byte(getBearer(desktop, "/v1/client/projects/"+project.ID+"/bundles/"+metadata.Lockfile.Digest+"/content", http.StatusOK)), &content); err != nil {
				t.Fatal(err)
			}
			served := render.Pack{Name: content.PackName, Version: content.PackVersion}
			var servedRefs, wantRefs []string
			for _, item := range content.Items {
				rendered := render.Item{Kind: pack.Kind(item.Kind), Name: item.Name, Version: item.Version, Description: item.Description, Body: item.Body}
				if item.ScriptsApproved != nil {
					rendered.ScriptsApproved = *item.ScriptsApproved
				}
				if item.Files != nil {
					for _, file := range *item.Files {
						support := render.SupportFile{Path: file.Path, Body: file.Body}
						support.Script = file.Script != nil && *file.Script
						support.Executable = file.Executable != nil && *file.Executable
						rendered.Files = append(rendered.Files, support)
					}
				}
				served.Items = append(served.Items, rendered)
				servedRefs = append(servedRefs, string(rendered.Kind)+"/"+rendered.Name+"@"+rendered.Version)
			}
			for _, item := range starter.Version.Items {
				wantRefs = append(wantRefs, string(item.Kind)+"/"+item.Name+"@"+item.Version)
			}
			slices.Sort(servedRefs)
			slices.Sort(wantRefs)
			if !slices.Equal(servedRefs, wantRefs) {
				t.Fatalf("desktop received %v\nwant %v", servedRefs, wantRefs)
			}
			for _, tool := range library.Tools() {
				bundle, err := render.Transform(tool, served)
				if err != nil {
					t.Fatalf("%s: sync fails: %v", tool, err)
				}
				prefix := ""
				if tool == library.ToolClaudeCode {
					prefix = ".claude/"
				}
				for _, item := range served.Items {
					reason, skipped := render.NotInstalled(item.Kind, tool)
					switch {
					case item.Kind == pack.KindSkill:
						for _, path := range append([]string{"SKILL.md"}, supportPaths(item)...) {
							if _, ok := bundle.Files[prefix+"skills/"+item.Name+"/"+path]; !ok {
								t.Fatalf("%s: skill %s file %s missing", tool, item.Name, path)
							}
						}
					case item.Kind == pack.KindPrompt && !skipped:
						path := map[library.Tool]string{library.ToolClaudeCode: ".claude/commands/", library.ToolCursor: "commands/"}[tool] + item.Name + ".md"
						if _, ok := bundle.Files[path]; !ok {
							t.Fatalf("%s: prompt %s file %s missing", tool, item.Name, path)
						}
					case skipped:
						for path := range bundle.Files {
							if strings.Contains(path, "/"+item.Name+".") || strings.Contains(path, "/"+item.Name+"/") {
								t.Fatalf("%s: %s %s should be skipped (%s) but wrote %s", tool, item.Kind, item.Name, reason, path)
							}
						}
						if item.Kind == pack.KindAgent && !slices.Contains(bundle.Warnings, `agent "`+item.Name+`" is not installed for `+string(tool)+`; skipped`) {
							t.Fatalf("%s: agent %s skipped without a warning: %v", tool, item.Name, bundle.Warnings)
						}
					default:
						t.Fatalf("%s: unexpected %s item %s in a starter pack", tool, item.Kind, item.Name)
					}
				}
				paths := make([]string, 0, len(bundle.Files))
				for path := range bundle.Files {
					paths = append(paths, path)
				}
				slices.Sort(paths)
				t.Logf("%s on %s: %d files written, warnings %v\n  %s", version, tool, len(paths), bundle.Warnings, strings.Join(paths, "\n  "))
			}
		})
	}
	t.Run("a member cannot assign a starter pack", func(t *testing.T) {
		before, err := fixture.repository.ListAssignments(scoped, fixture.admin)
		if err != nil {
			t.Fatal(err)
		}
		post(memberClient, "/admin/packs/assignments/team", url.Values{"team_id": {team.ID}, "version": {pack.StarterVersionID("backend", 1)}}, http.StatusForbidden)
		after, err := fixture.repository.ListAssignments(scoped, fixture.admin)
		if err != nil {
			t.Fatal(err)
		}
		if len(before) != 1 || len(after) != 1 || after[0].Version != before[0].Version {
			t.Fatalf("member changed the assignment: before %+v after %+v", before, after)
		}
	})
	t.Run("another company's desktop cannot read the assigned pack", func(t *testing.T) {
		getBearer(otherDesktop, "/v1/client/projects/"+project.ID+"/bundle", http.StatusForbidden)
	})
}

func supportPaths(item render.Item) []string {
	paths := make([]string, 0, len(item.Files))
	for _, file := range item.Files {
		paths = append(paths, file.Path)
	}
	return paths
}
```

### T4. Edits to existing files (`internal/web/library.go`, `internal/web/handler.go`, `cmd/control-plane/main.go`)

Apply exactly these hunks. The `library.go` and `handler.go` hunks belong to T3's GREEN step. `main.go` is its own commit: `feat(86bcm901r): load and show starter packs at startup`.

```diff
--- a/cmd/control-plane/main.go
+++ b/cmd/control-plane/main.go
@@ -100,6 +100,14 @@
 		return err
 	}
 	logger.Info("content library loaded", "trace_id", startupTraceID, "added", libraryLoad.Added, "unchanged", libraryLoad.Unchanged)
+	starterLoad, err := repository.EnsureStarterPacks(ctx)
+	if err != nil {
+		return err
+	}
+	logger.Info("starter packs loaded", "trace_id", startupTraceID, "added", starterLoad.Added, "unchanged", starterLoad.Unchanged)
+	if len(starterLoad.Held) > 0 {
+		logger.Warn("starter packs held: their items changed but the content library version is not newer than their newest version; bump internal/library/content/library.json to release them", "trace_id", startupTraceID, "roles", starterLoad.Held)
+	}
 	shippedLibrary, err := library.Embedded()
 	if err != nil {
 		return err
@@ -183,6 +191,11 @@
 	}
 	application.SetPacks(repository, seed)
 	application.SetLibrary(repository)
+	starterPacks, err := library.EmbeddedStarterPacks()
+	if err != nil {
+		return err
+	}
+	application.SetStarterPacks(repository, starterPacks)
 	versions := pack.NewVersionService(repository)
 	application.SetPackVersions(versions)
 	application.SetItemBuilder(itembuilder.New(versions, gate.NewGitleaks("gitleaks")))
--- a/internal/web/library.go
+++ b/internal/web/library.go
@@ -85,6 +85,7 @@
 	Total                          int
 	FilterError                    string
 	Builder                        *libraryBuilder // nil: no pack builder controls
+	Starters                       *starterSection // nil: no Starter packs section
 }
 
 type libraryItemPageData struct {
@@ -150,6 +151,13 @@
 		page.Items = nil
 		page.FilterError = libraryFilterHelp
 	}
+	if handler.starterPacks != nil {
+		page.Starters, err = handler.starterSectionFor(r.Context(), teamActor(r))
+		if err != nil {
+			handler.libraryResult(w, r, err)
+			return
+		}
+	}
 	if cookie, err := r.Cookie(csrfCookieName); handler.packBuilder != nil && err == nil && validBrowserToken(cookie.Value) {
 		packs, err := handler.packBuilder.Packs(r.Context(), teamActor(r))
 		if err != nil {
@@ -231,7 +239,7 @@
 // styles to adminBaseCSS. The [align] rules honour Markdown table alignment
 // (library.RenderMarkdown writes align attributes because the CSP refuses
 // inline styles); without them adminBaseCSS's th,td rule would override it.
-const libraryCSS = `h1{margin:.5rem 0}.lede{color:#9db0c7;max-width:48rem}.filters{display:flex;flex-wrap:wrap;align-items:end;gap:.5rem;padding:1rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem}.filters label{display:grid;gap:.35rem}.chip{display:inline-block;margin:.1rem .25rem .1rem 0;padding:.15rem .5rem;border-radius:.5rem;background:#1b2c42;color:#70d6c7;font-size:.8rem}.item-name{font-weight:700}.alert{padding:1rem 1.25rem;background:#2a1620;border:1px solid #7a3446;border-radius:.75rem}.empty{padding:1.5rem;background:#101d2e;border-radius:1rem}.eyebrow{color:#70d6c7;font-weight:700;letter-spacing:.08em;text-transform:uppercase;font-size:.8rem;margin:1.5rem 0 0}.facts{display:grid;grid-template-columns:10rem 1fr;gap:.6rem}.facts dt{color:#9db0c7}.facts dd{margin:0}.markdown{line-height:1.55}.markdown h1,.markdown h2,.markdown h3{margin:1rem 0 .5rem}.markdown code{font:13px ui-monospace,SFMono-Regular,Menlo,monospace;background:#07111f;border:1px solid #2b4058;border-radius:.3rem;padding:0 .25rem}.markdown pre code{border:0;padding:0}.markdown table{width:auto}.markdown th,.markdown td{padding:.4rem .75rem;border:1px solid #2b4058}.markdown [align=left]{text-align:left}.markdown [align=center]{text-align:center}.markdown [align=right]{text-align:right}.builder{margin:1rem 0;padding:1rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem}`
+const libraryCSS = `h1{margin:.5rem 0}.lede{color:#9db0c7;max-width:48rem}.filters{display:flex;flex-wrap:wrap;align-items:end;gap:.5rem;padding:1rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem}.filters label{display:grid;gap:.35rem}.chip{display:inline-block;margin:.1rem .25rem .1rem 0;padding:.15rem .5rem;border-radius:.5rem;background:#1b2c42;color:#70d6c7;font-size:.8rem}.item-name{font-weight:700}.alert{padding:1rem 1.25rem;background:#2a1620;border:1px solid #7a3446;border-radius:.75rem}.empty{padding:1.5rem;background:#101d2e;border-radius:1rem}.eyebrow{color:#70d6c7;font-weight:700;letter-spacing:.08em;text-transform:uppercase;font-size:.8rem;margin:1.5rem 0 0}.facts{display:grid;grid-template-columns:10rem 1fr;gap:.6rem}.facts dt{color:#9db0c7}.facts dd{margin:0}.markdown{line-height:1.55}.markdown h1,.markdown h2,.markdown h3{margin:1rem 0 .5rem}.markdown code{font:13px ui-monospace,SFMono-Regular,Menlo,monospace;background:#07111f;border:1px solid #2b4058;border-radius:.3rem;padding:0 .25rem}.markdown pre code{border:0;padding:0}.markdown table{width:auto}.markdown th,.markdown td{padding:.4rem .75rem;border:1px solid #2b4058}.markdown [align=left]{text-align:left}.markdown [align=center]{text-align:center}.markdown [align=right]{text-align:right}.builder{margin:1rem 0;padding:1rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem}.starter{margin:1rem 0;padding:1rem;background:#101d2e;border:1px solid #2b4058;border-radius:1rem}`
 
 var libraryTemplate = template.Must(template.New("library").Parse(`<!doctype html>
 <html lang="en">
@@ -246,6 +254,25 @@
   <p><a href="/admin">Admin workspace</a> · <a href="/admin/packs">Packs</a></p>
   <h1>Content library</h1>
   <p class="lede">Skills, agents, configs, MCP templates and prompts shipped with Leorna. Filter or search to find what your teams need, then open an item for its details and a preview.</p>
+  {{with .Starters}}
+  <section class="starters" id="starter-packs" aria-labelledby="starter-title">
+    <h2 id="starter-title">Starter packs</h2>
+    <p class="muted">Curated packs for common roles, built from this library. Assign one to a team on <a href="/admin/packs/assignments">Pack Assignments</a> by its version id; engineers get it on their next Sync. When a library release updates one of its items, the pack gets a new version; teams keep the version they have until you assign the new one.</p>
+    {{range .Packs}}
+    <article class="starter" id="starter-{{.Role}}">
+      <h3>{{.Name}}</h3>
+      <p>{{.Description}}</p>
+      <p class="muted">Version id <code class="starter-version">{{.Version}}</code> · built from library {{.Release}} · {{len .Items}} items</p>
+      <table>
+        <thead><tr><th scope="col">Item</th><th scope="col">Kind</th><th scope="col">Version</th><th scope="col">Installs in</th></tr></thead>
+        <tbody>{{range .Items}}
+          <tr class="starter-item" data-kind="{{.Kind}}" data-name="{{.Name}}" data-version="{{.Version}}"><td>{{.Name}}</td><td>{{.KindLabel}}</td><td>{{.Version}}</td><td>{{range .Installs}}<span class="chip">{{.}}</span>{{end}}{{range .Skipped}}<div class="muted">Skipped in {{.}}</div>{{end}}</td></tr>{{end}}
+        </tbody>
+      </table>
+    </article>
+    {{else}}<p class="muted" id="starter-empty">No starter packs are loaded yet. They load when the control plane starts.</p>{{end}}
+  </section>
+  {{end}}
   {{with .Builder}}
   <section class="builder" aria-labelledby="builder-title">
     {{if .Editing}}
--- a/internal/web/handler.go
+++ b/internal/web/handler.go
@@ -95,6 +95,8 @@
 	cloudProvisionManagedTemplate *template.Template
 	packVersions                  packVersioner
 	packBuilder                   packBuilder
+	starterPacks                  starterPackReader     // role starter packs on the Content library page (86bcm901r)
+	starterDefinitions            []library.StarterPack // shipped starter pack definitions, in display order
 	itemBuilder                   itemCreator
 	packVersionsTemplate          *template.Template
 	packAssignments               packAssigner
```

Then run `go build ./...` and `go vet ./cmd/control-plane`. The proof that startup loads and wires the packs is AC1's real-binary screenshot (task E1): it runs this `main.go` against an empty database.

### T5. Mutation checks (`mutation-testing-discipline`)

Change one thing, run the named test, see it fail on the expected line, then restore. Swap Go source with `go test -overlay` or a scratch edit you restore; keep the tree clean between mutants. Record each in `$EV/mutants.md` (mutant, command, failing line, restored).

| # | Mutant | Must fail |
|---|---|---|
| M1 | `ResolveStarterPack`: drop the `Library.Required` loop | AC1 (Backend and Secure item lists), `TestEmbeddedStarterPacksResolveAgainstTheShippedLibrary` |
| M2 | `ensureStarterPacks`: `order <= 0` → `order < 0` | AC3 "changed items without a newer library version are held" |
| M3 | `ensureStarterPacks`: delete the `pg_advisory_xact_lock` line | `TestEnsureStarterPacksWaitsForAConcurrentLoadWithPostgres` |
| M4 | `ensureStarterPacks`: `slices.Equal(stored, …)` → `false && slices.Equal(stored, …)` | AC3 "a re-run … changes nothing" |
| M5 | `latestStarterTx`: `ORDER BY starter_number DESC` → `ASC` | AC3 (Backend newest must be #2) |
| M6 | `ensureStarterPacks`: resolve inside the transaction after the first insert (move the resolve loop below `tx.Exec(lock)`) | AC5 "a pack naming an item the library does not ship" (the valid packs' versions must not be written) |
| M7 | migration 24: drop `pack_versions_starter_shared` | `TestStarterColumnsAreOnlyOnSharedVersionsWithPostgres` "a company's version" |
| M8 | `starterSectionFor`: skip the first definition | AC1 |
| M9 | `starterInstallNotes`: ignore `NotInstalled` (always "installs") | AC1 (its first subtest checks the Frontend card says `Skipped in Codex: ` and `Skipped in Claude Code: the desktop client does not install agents yet`) |
| M10 | `LatestStarterVersions`: drop `starter_role IS NOT NULL` | AC1 (the seed base becomes a "starter pack" row with an empty role, so it no longer matches) |


### T6. Docs and inventory

1. `internal/pack/README.md`: append this section (adjust it only where the build proved something different, and say so):

```markdown
## Role starter packs (86bcm901r)

Role starter packs are curated selections of content library items for common roles:
**Backend**, **Frontend**, **Platform/DevOps** and **Secure coding (regulated)**. They are
separate from the setup wizard's starter pack (the seed above), which stays as it is.

- **Definitions:** `internal/library/starter-packs.json` (embedded; read with
  `library.EmbeddedStarterPacks`) lists each pack's role, name, description and items as
  `kind/name`. It sits beside `content/` because the quality gate allows only
  `library.json`, `items/` and `upstreams/` there. `Library.ResolveStarterPack` takes the
  library's current version of each item and adds every item they require
  (`Library.Required`, followed transitively), so `/build`, `/test` and `/review` arrive
  with the skills they invoke.
- **Storage:** each pack is a line of shared, immutable pack versions (`tenant_id` NULL,
  like the seed base) marked by migration 24's `starter_role`, `starter_number` and
  `starter_release` (the library version it was built from). Version ids are
  `starter-<role>-<n>`, for example `starter-backend-1`.
- **Loading:** `EnsureStarterPacks` runs at startup right after `EnsureLibrary`, in one
  transaction under the advisory lock `leorna:starter-packs`, so replicas take turns. A
  fresh install gets version 1 of every pack. A later startup adds a pack's next version
  only when its items changed **and** `content/library.json`'s version is newer than the
  one its newest version was built from. A re-run changes nothing, an older binary never
  replaces newer content, and a change shipped without a library version bump is held
  (startup logs `starter packs held` with the roles) until the next release. A definition
  naming an item the library does not ship, or a failed write, stops startup with
  `load starter packs failed: <step> failed; …` (or the definition error) and writes nothing.
- **Catalog and assignment:** the Content library page (`/admin/library`) lists each
  pack's newest version with its items and versions, and which tools install each item
  (`render.NotInstalled`: agents are skipped in every tool for now, prompts in Codex).
  Admins assign a pack on Pack Assignments like any version; engineers get it on their
  next Sync. A new starter version never moves an assignment: teams keep their version
  until an admin assigns the new one. A company that wants changes forks a starter
  version on Pack Versions; library releases never touch its copy.
- No OpenAPI change. The load writes no audit record (a system step, like the seed base
  and library loads); assigning still records `pack.assign`.
- Rollback: migration 24's down keeps the versions as plain shared versions and drops the
  three columns. After a down and an up, startup stops because `starter-<role>-1` already
  exists. Prefer fix-forward.

Verification: `TestStarterPacksAC1FreshInstallListsTheAgreedPacksInTheCatalogWithPostgres`
and `TestStarterPacksAC2AssignedPackSyncsIntoClaudeCodeCodexAndCursorWithPostgres`
(`internal/web`, real HTTP and PostgreSQL; AC2 reads the desktop's bundle and content
endpoints with a real desktop token and renders them with `internal/library/render`, the
client's transformer copy); `TestStarterPacksAC3NextLibraryReleasePicksUpTheNewItemVersionWithPostgres`,
`TestStarterPacksAC5AFailedLoadNamesThePackOrStepAndWritesNothingWithPostgres`,
`TestEnsureStarterPacksWaitsForAConcurrentLoadWithPostgres` and
`TestStarterColumnsAreOnlyOnSharedVersionsWithPostgres` (`internal/store/postgres`); and the
unit tests in `internal/library/starter_test.go`. The PostgreSQL tests need
`LEORNA_TEST_DATABASE_URL` (a database whose name ends in `_test`) and skip without it.
Live: one desktop Sync of a starter pack into Claude Code, Codex and Cursor (owed to Justin).
Demo: run the binary in dev mode (`LEORNA_DEV_MODE=1`) against a throwaway database and open
`/admin/library`.
```

   *(amended 2026-10-29)* The "Live: … (owed to Justin)" sentence above is in the branch as written (`internal/pack/README.md:300`). Amendment 1 makes it out of date; whether to reword it is QA1 at the top (⭐ leave the repo unchanged, list it as a follow-up).

2. `internal/library/README.md`: three sentence fixes, each a small hunk away from 86bcm901j's hunks (it edits around lines 93–96 and inserts after 212):
   - Line 76: replace "so the seed still installs those two until the role packs story (86bcm901r) changes it" with "so the seed still installs those two (the role starter packs of 86bcm901r are separate and leave the seed as it is; refreshing or retiring it is a follow-up)".
   - Line 509: replace "The pack builder (86bcm901w) and the role starter packs (86bcm901r) read it with `Library.Required(item)` to install a prompt together with its skills" with "The role starter packs (86bcm901r) add each prompt's required items through `Library.Required(item)`; the pack builder (86bcm901w) copies exactly the ticked items and does not read it yet".
   - Line 579: replace "stay in `content.lock.json` and in the starter seed until 86bcm901r." with "stay in `content.lock.json` and in the starter seed (86bcm901r leaves the seed as it is)."
   - Add one line after the "Library **0.7.0**" paragraph: "Role starter packs (86bcm901r) are defined beside this folder in `starter-packs.json` and take each item's current version; see `internal/pack/README.md`."
3. `delivery/stories.json`: append, as text, after the last entry, with `"prs"` empty until a PR exists (leorna skill step 7.2):
   ```json
     "86bcm901r": {
       "name": "Role-based starter packs",
       "prs": {
         "LeornaAI/leorna-control-plane": []
       }
     }
   ```
   Check: `python3 -c 'import json;json.load(open("delivery/stories.json"))'` and `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` (from the repo root), then check every earlier entry is unchanged by value.
4. No root `README.md` route change (no new route). No ADR change: ADR 0003 line 60 names 86bcm901r as a record of its time.

Commit: `docs(86bcm901r): describe role starter packs`.

### T7. Evidence capture (named build task; one screenshot per AC)

Folder `~/.hermes/plans/leorna/evidence/86bcm901r/` (`$EV`). The builder writes at the top level; the verifier writes only in `verifier/` and the auditor only in `auditor/`. Every AC log starts `HEAD=<sha>` and ends `EXIT=<code>`, uses `go test -v` output, and its command is run with the env file sourced (never printed). This desktop has no PIL or ImageMagick: render a log in a `<pre>` page and screenshot it with Chrome for Testing (`~/.cache/chrome-for-testing/chrome-linux64/chrome`, `LD_LIBRARY_PATH=~/.cache/chrome-libs/root/usr/lib/x86_64-linux-gnu`, `env -u DISPLAY -u WAYLAND_DISPLAY`, `--headless=new --no-sandbox --disable-gpu --disable-software-rasterizer --hide-scrollbars --window-size=1280,<h> --screenshot=<png>`, its own `--user-data-dir` under `~/.cache/86bcm901r-builder/`). Judge success by "bytes written" and the PNG magic `89504e47`, not the exit code. Inspect tall PNGs in bands of ≤1,300 px. Before anything could leave the machine, grep the text sources for URLs, emails, tokens and passwords.

| AC | Shows | Capture point | Files |
|---|---|---|---|
| AC1 | The real Content library page on a fresh install: the Starter packs section with the four packs, version ids `starter-<role>-1`, items, versions and "Installs in" | After T4: build `./cmd/control-plane` from the worktree HEAD into `~/.cache/86bcm901r-builder/bin`. Drop and recreate `leorna_86bcm901r_demo_test`. Run the binary with `LEORNA_DEV_MODE=1`, a manifest copy, `127.0.0.1:<free port>`, `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`, a random `LEORNA_SECRET_ENCRYPTION_KEY` and `LEORNA_DATABASE_URL` for the demo DB with `sslmode=disable` (recipe: `evidence/86bcm901j/handover/serve.sh.txt`). Confirm its log says `starter packs loaded` with `added=4`, then screenshot `/dev/login?next=%2Fadmin%2Flibrary` (`catalog-shot.sh.txt`); no browser frame, so no URL bar | `ac1-catalog.png` (+ band crops if tall), `ac1-startup.txt` (the two `loaded` log lines, no secrets), `ac1-test.txt` + `ac1-test.png` (the AC1 test log) |
| AC2 | Per pack: assigned through the form, served to a desktop token, rendered for each tool, with the file list per tool and the skip warnings | The AC2 test run on the final head; its `t.Logf` lines print each tool's files | `ac2-sync.txt` + `ac2-sync-files.png`. Optional, if a chromedp script can create a team in the dev binary (as in `evidence/86bcm901w/verifier/capture-main.go`): `ac2-assignments.png` of Pack Assignments offering the starter versions |
| AC3 | Next release → `starter-backend-2` with TDD at its new version; others unchanged; held and older-binary cases | The AC3 test run on the final head | `ac3-next-release.txt` + `ac3-next-release.png` |
| AC4 *(amended 2026-10-29)* | The catalog's Starter packs section; the two team-default assignments; the desktop client's Sync results per tool (files, warnings) and the list of passed checks | Each role's own run of `86bcm901r-ac4/run.sh` on the head named in its brief (see "AC4's check") | In the role's folder: `ac4-<head7>.log` (the AC log), `ac4-<head7>/ac4-sync.png` (the AC's screenshot: Sync results and checks), `ac4-<head7>/ac4-catalog.png`, `ac4-<head7>/ac4-assigned.png`, the Sync and file-check JSON and file lists; `ac4-base-<base7>.log` (+ its `ac4-base-<base7>/` folder). The builder's `ac4-live/CHECKLIST.md` is superseded (its lists are now `86bcm901r-ac4/expected/`) |
| AC5 | Unknown item refused naming the pack; forced write failure rolled back naming the step; retry succeeds | The AC5 test run on the final head | `ac5-failed-load.txt` + `ac5-failed-load.png` |
| Gates | `make check`, module-add, the Postgres skip check | Each head the builder hands over | `gates-<sha7>.txt` + `gates-<sha7>.png`, `mutants.md` |

Base runs (for the verifier and auditor; the builder records one too): in a **separate detached worktree** at `BASE` with `leorna_86bcm901r_base_test`, copy in only this story's AC test files (`internal/web/starter_packs_test.go`, `internal/store/postgres/starter_packs_test.go`) and run each AC command. Expect `[build failed]` with `undefined:` lines. Never in the story worktree. *(amended 2026-10-29)* AC4 has no test file in the repo (its check lives in `~/.hermes/plans/leorna/86bcm901r-ac4/`): nothing to copy; its base run builds the base copy itself and must end `not ok 1 - ac4_starter_pack_desktop_sync`.

### AC4's check (agent-run; amended 2026-10-29)

Files, read only to every role (never edit them; a needed change goes back to the main session as a finding):
- `~/.hermes/plans/leorna/86bcm901r-ac4/run.sh`: the whole check (header comment = what it does); prints `1..1`, one `pass:`/`FAIL:` line per clause, and finally `ok 1 - ac4_starter_pack_desktop_sync` (exit 0) or `not ok 1 - ac4_starter_pack_desktop_sync` (exit 1).
- `~/.hermes/plans/leorna/86bcm901r-ac4/client-sync.go`: the desktop driver, compiled inside a `git archive` copy of leorna-client `f105e27` as `cmd/ac4-client-sync` with `go build -overlay` (no write to the client repo).
- `~/.hermes/plans/leorna/86bcm901r-ac4/browser/{main.go,go.mod,go.sum}`: the headless-Chrome driver (chromedp v0.16.0 from the module cache, `GOPROXY=off`).
- `~/.hermes/plans/leorna/86bcm901r-ac4/expected/backend-{claude-code,codex,cursor}.txt`: the 26 / 21 / 26 Backend files, copied from `evidence/86bcm901r/ac4-live/CHECKLIST.md`.

What it proves, clause by clause (each is a `pass:` line in the log and in `ac4-sync.png`): startup loaded 4 starter packs; the catalog lists the four packs with `starter-<role>-1`; Pack Assignments offers `starter-backend-1` and `starter-frontend-1` and the team-default rows exist; Backend Sync status success and each of claude-code, codex, cursor success; the files on disk equal `expected/backend-<tool>.txt` exactly; nothing in the Codex home or the Claude Code config home; Codex warns `prompt "<p>" is not installed for codex: Codex removed custom prompts in 0.117.0 and has no prompt location; skipped` for build, planning, review, spec, test and nothing else; Claude Code and Cursor warn nothing (Backend has no agent); the client's Check files is clean; Frontend Sync success with `agent "web-performance-auditor" is not installed for <tool>; skipped` in all three tools and the webperf prompt skipped in Codex; no file for the agent anywhere; `/webperf` and `frontend-ui-engineering` present; and the real home's destination paths unchanged.

Home isolation (why nothing can land in Justin's real `~/.agents/skills`, `~/.cursor`, `~/.claude`, `~/.codex` or `~/.config/Leorna`):
- The client code at `f105e27` resolves paths only through `os.UserHomeDir()` (`$HOME`: `toolconnector/available/registry.go:59,81`, `toolconnector/claudecode/claudecode.go:38`), `os.UserConfigDir()` (`$XDG_CONFIG_HOME`, else `$HOME/.config`: `application/application.go:33`), `CLAUDE_CONFIG_DIR` and `CODEX_HOME` (`registry.go:63,85`) and `os.MkdirTemp("")` (`$TMPDIR`, only in `toolinstall/install.go:43`, the Windows installer, never on the Sync path; `toolinstall.Supported()` is false off Windows). The Sync writes only below the connector roots: the selected project folder (Claude Code, `claudecode.go:210-218` `ApplyConfig` → `nativewrite.Apply(projectRoot)`), `CODEX_HOME` and `$HOME/.agents` (Codex, `codex/capture.go:159-188`), `$HOME/.cursor` (Cursor, `available/registry.go:51`); `nativewrite` refuses a path outside its root (`write.go:324-336`, `destination`) and stages temp files beside the target (`write.go:130,155`). Nothing on the path runs a program (`exec` only in `toolinstall/run_windows.go`), and the OS keyring (`login.OSVault`) is not used.
- `run.sh` starts the driver with `env -i` and `HOME`, `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`, `XDG_CACHE_HOME`, `CLAUDE_CONFIG_DIR`, `CODEX_HOME` and `TMPDIR` all inside `--work`; the driver refuses to run unless each of them, `os.UserHomeDir()`, `os.UserConfigDir()`, the project folder, the client database path and every tool's detected path resolve (symlinks followed) inside `--work`, which must hold the marker `.ac4-scratch` that `run.sh` creates in a folder it makes with `mkdir` (no `-p`).
- Passing needs the files in the work folder: the check compares `find` listings of `--work`'s home and project with the expected lists, so a client that wrote to the real home fails. `run.sh` also fingerprints the real home's paths the Sync would write (`~/.agents/skills/<name>`, `~/.cursor/{skills,commands,agents}/<name>`, `~/.claude/{skills,commands,agents}/<name>`, `~/.codex/prompts/<name>.md`, `~/.config/Leorna`) before and after, and fails if they changed.

Run it (verifier `<role>` = `verify<n>`, auditor `<role>` = `audit<n>`; `<folder>` = your own `$EV/verifier/` or `$EV/auditor/`; head and base runs can run in parallel, about 3 minutes each; run them in the background and poll the log in waits under 3 minutes):

```bash
set -u
WT=~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs
HEAD7=$(git -C "$WT" rev-parse --short=7 HEAD)          # must be the head named in your brief
BASE=$(git -C "$WT" merge-base HEAD origin/main); BASE7=${BASE:0:7}
F=<folder>; R=<role>; AC4=~/.hermes/plans/leorna/86bcm901r-ac4/run.sh
cd ~/.cache                                              # anywhere outside the repos
# head (the story worktree is only read: go build -o writes outside it)
( set -o pipefail; echo "HEAD=$(git -C "$WT" rev-parse HEAD)"; bash "$AC4" --repo "$WT" --work ~/.cache/86bcm901r-$R-ac4-head --out "$F/ac4-$HEAD7" --db leorna_86bcm901r_${R}_ac4_test; echo "EXIT=$?" ) > "$F/ac4-$HEAD7.log" 2>&1
# base: a detached copy at the base commit, nothing copied in
git -C "$WT" worktree add --detach ~/.cache/86bcm901r-$R-ac4-basecopy "$BASE"
( set -o pipefail; cd ~/.cache/86bcm901r-$R-ac4-basecopy && echo "HEAD=$(git rev-parse HEAD)"; bash "$AC4" --repo ~/.cache/86bcm901r-$R-ac4-basecopy --work ~/.cache/86bcm901r-$R-ac4-base --out "$F/ac4-base-$BASE7" --db leorna_86bcm901r_${R}_ac4base_test; echo "EXIT=$?" ) > "$F/ac4-base-$BASE7.log" 2>&1
git -C "$WT" worktree remove --force ~/.cache/86bcm901r-$R-ac4-basecopy
```

- Pass on head: the log's last lines are `ok 1 - ac4_starter_pack_desktop_sync` and `EXIT=0`, every clause line says `pass:`, and none says `FAIL:`. Fail on base: `not ok 1 - ac4_starter_pack_desktop_sync` and `EXIT=1`, with `FAIL:` lines for the catalog, the assignment and the Sync.
- The report entry: `{"ac": "AC4", "accepted": true, "test": "ac4_starter_pack_desktop_sync", "log": "ac4-<head7>.log", "base_log": "ac4-base-<base7>.log", "screenshot": "ac4-<head7>/ac4-sync.png", "evidence": "<one line>"}`. Look at `ac4-sync.png`, `ac4-catalog.png` and `ac4-assigned.png` yourself before citing them (tall images in bands of ≤1,300 px).
- `run.sh` drops its database and removes its `--work` folder itself (`--keep` keeps the folder for a diagnosis; then remove it by its literal path). If it stops early, check `docker exec leorna-test-pg psql -U leorna -d leorna_test -Atc "select datname from pg_database where datname like 'leorna_86bcm901r_${R}%'"` and drop only your own.
- A failure that is the check's own fault (a driver crash, a timeout under load) is not an AC failure: rerun once with a new `--work` and `--db`; if it repeats, report it as a finding with both logs instead of editing the check.
- Privacy: the logs and images hold no token, sign-in code, tenant id or password; `demo.leorna.invalid` is a reserved placeholder that resolves nowhere, and the signed-in name is the dev-mode "Dev Admin".

### T8. Gates (the `leorna` skill's step 4, control plane)

Run them in the story worktree, the builder only. A read-only verifier or auditor runs `make check` and module-add in a detached copy at the same SHA, because both briefly write into the tree they run in.

```bash
set -uo pipefail
WT=~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901r-starter-packs
OWN=~/.cache/86bcm901r-builder
TC=~/.local/leorna-toolchain
export PATH="$TC/go/bin:$TC/bin:/usr/local/bin:/usr/bin:/bin"
export GOLANGCI_LINT="$TC/bin/golangci-lint" GOVULNCHECK="$TC/bin/govulncheck" GITLEAKS=/usr/local/bin/gitleaks LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks
export TMPDIR="$OWN/tmp" GOTMPDIR="$OWN/tmp" GOLANGCI_LINT_CACHE="$OWN/lint-cache"
source "$OWN/env.sh"                      # LEORNA_TEST_DATABASE_URL, never printed
cd "$WT"
SHA=$(git rev-parse --short=7 HEAD); LOG=~/.hermes/plans/leorna/evidence/86bcm901r/gates-$SHA.txt
{
  echo "HEAD=$(git rev-parse HEAD)"
  go version; "$GOLANGCI_LINT" --version; "$GOVULNCHECK" -version | head -1; "$GITLEAKS" version
  make -s check;                        echo "make check EXIT=$?"
  bash ./scripts/test-module-add.sh;    echo "module-add EXIT=$?"
  go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web > "$OWN/pg.json"; echo "pg-json EXIT=$?"
  python3 - "$OWN/pg.json" <<'PY'
import json, sys, collections
out = collections.defaultdict(str); skipped = []
for line in open(sys.argv[1]):
    e = json.loads(line)
    key = (e.get("Package"), e.get("Test"))
    if e.get("Action") == "output": out[key] += e.get("Output", "")
    if e.get("Action") == "skip" and e.get("Test"): skipped.append(key)
allowed = ("LEORNA_TEST_CLICKHOUSE_URL", "LEORNA_EVIDENCE_DIR is not set", "SCW_LIVE=1 not set")
bad = [k for k in skipped if "LEORNA_TEST_DATABASE_URL" in out[k] or not any(a in out[k] for a in allowed)]
print("postgres skips:", len(skipped), "unexpected:", bad)
sys.exit(1 if bad else 0)
PY
  echo "pg-skip-check EXIT=$?"
} > "$LOG" 2>&1
grep 'EXIT=' "$LOG"
```

- Every `EXIT=` line must be 0. Read the log, not just the summary. If `TestSetupWizardWithPostgres` times out once under load, run it alone 3 times before calling it a regression (memory).
- **gitleaks:** `make check`'s `secrets` scans every ref in the shared `.git`, siblings' branches included. If it flags a commit that isn't this story's, keep that log, then run `gitleaks git --redact --log-opts="$BASE..HEAD"` for this branch and report both.
- **Image build, final head only** (verifier or finisher; CI runs it since PR #94): in a detached copy, run `docker build --no-cache --file Containerfile --tag leorna-cp-86bcm901r:<sha7> .`, check that the `RUN go build` step says DONE, then `docker run --rm --entrypoint /usr/local/bin/gitleaks leorna-cp-86bcm901r:<sha7> version` must print `8.30.1`. Remove the tag afterwards.
- **`.github/`** must be empty in `git diff --name-only "$BASE"...HEAD` (no CI change; `no-ci-changes`).

### T9. Stop at ready-for-review

Report the head SHA, `git diff --stat "$BASE"...HEAD`, each AC's test, base result, log and screenshot path, the mutants table, the gate log path and every `EXIT=` line, and any ruling you made (each one listed for the reviewers). No push, PR or ClickUp post.

## Risks

- **Sibling overlaps (resolved at hand-over, not by waiting):**
  - `delivery/stories.json`: 86bcm901j's local branch (`d723e04`, two commits past its PR #98 head `17f2ccf`) appends its entry. Whichever merges second conflicts. Take `main`'s file and append this story's entry last, as text (leorna skill step 7.2), then check earlier entries by value.
  - `internal/library/README.md`: #98 edits around lines 93–96 and inserts about 141 lines after line 212. This story edits lines 76, ~95 (one added line after the 0.7.0 paragraph, which **is** next to #98's hunk, so expect a conflict there: keep both lines) and 509, 579. Merge-tree at hand-over.
  - Migration number `000024`: no open PR adds a migration (#98 doesn't). If another merges first, renumber at hand-over (T0 checks).
  - `internal/web/library.go`, `internal/web/handler.go`, `cmd/control-plane/main.go`, `internal/pack/README.md`: no open sibling touches them. 86bcm901y (remove or reorder, not started) and 86bcm902a (quick start, depends on this) may later.
- **Terminology:** "starter pack" already names the setup wizard's seed (root README, `internal/web/README.md`, onboarding). Docs say "role starter packs"; the page section is "Starter packs" with role names. 86bcm902a should settle the wording when it reworks setup.
- **The Assignments list grows:** every starter version that changes stays listed (shared versions are all visible), so after many releases the dropdown is long. Follow-up: hide superseded starter versions from new assignments.
- **Startup stop:** a broken definitions file stops startup (fail-stop, like the library). `TestEmbeddedStarterPacksResolveAgainstTheShippedLibrary` catches it in CI first.
- **Forgotten `library.json` bump:** the change is held with a warning, not lost. It ships with the next bump. No test forces the bump (found-else 1).
- **Rollback:** migration 24's down plus an up makes the next startup stop on `write backend version 1 failed`, because `starter-backend-1` already exists as a plain shared version. Fix-forward (documented).
- **Agents install nowhere yet:** Frontend's and Secure coding's agent are skipped in every tool until the client installs agents (86bcm901a follow-up). The page and AC4's check say so (AC4 asserts the agent warning for Frontend's `web-performance-auditor`; *amended 2026-10-29*).
- ~~**AC4 depends on Justin** (server install from this branch in local image mode, desktop app ≥ `f105e27`). It stays owed; it never blocks the automated ACs.~~ *(amended 2026-10-29)* **AC4 is agent-run** and now blocks acceptance like the others. Its check needs Docker with `leorna-test-pg`, gcc (cgo for the client's SQLite), Chrome for Testing and the chromedp modules in the Go module cache, all present on this desktop (proven by the planner's runs). Under heavy load a run takes longer (about 2.5 minutes each when two ran in parallel); its waits are 4 minutes for the browser setup, 3 for the sign-in, 8 for the whole client run.
- **What AC4 still doesn't cover** *(amended 2026-10-29)*: the Windows app window itself (Wails UI, native folder picker) and Justin's real sign-in (OS keyring, his own server over HTTPS and real DNS); the check substitutes loopback HTTP, an in-memory credential store and a given project folder, and the dev-mode admin is the desktop user (the member-engineer path is AC2's test).
- **The expected lists are pinned to today's library** *(amended 2026-10-29)*: a later library release that changes a Backend item's files changes the lists; then `expected/*.txt` must be regenerated from AC2's log (`ac2-sync.txt`) by the main session, not edited by a verifier.
- **WSL load:** parallel sessions slow Postgres tests. The concurrency test's 5 s wait and `TestSetupWizardWithPostgres`'s wait can time out once; rerun alone before calling it a regression.

## Notes for later roles

- Reviewers: check that `beginOrg(…, false)` keeps the page tenant-scoped, and that no write path takes a tenant actor. Check that `ensureStarterPacks` can't touch tenant rows (it inserts only `tenant_id` NULL). Check the CHECKs in migration 24, the held and older-binary logic, and the rule that resolution happens before the transaction. Check that the README claims are true as written.
- Verifier and auditor: ~~AC4 is `(live)`, so mark it `"accepted": false, "not_run": "live: needs Justin's server and desktop app"`.~~ *(amended 2026-10-29)* each of you proves AC4 yourself on the head named in your brief (the fixer's merge commit after PR #98, not `398af64`), with your own server, database, client copy and home, following "AC4's check" in T7: databases `leorna_86bcm901r_verify<n>_ac4_test` / `leorna_86bcm901r_verify<n>_ac4base_test` (auditor: `audit<n>`), work folders `~/.cache/86bcm901r-verify<n>-ac4-head` / `-ac4-base` / `-ac4-basecopy` (auditor: `audit<n>`), all made fresh and removed at the end; never another role's. The base is `git merge-base HEAD origin/main` (after the merge, GitHub `main` `dd006b7`, not `6c1709e`). AC4 is accepted only with `ok 1` on head and `not ok 1` on base in your own folder; no AC is `not_run` any more. Each AC's base run uses the detached base worktree and `leorna_86bcm901r_<role>_base_test`. Run `make check` and module-add in a detached copy.
- Finisher: PR text Assumptions should carry Q1's mapping changes, Q2's "teams keep their version", Q4's seed follow-up, the agents-and-Codex skips, and found-else 1. Merge-tree against PR #98's head (fetched read-only as `pull/98/head`; check `FETCH_HEAD`). Hand-over pack in `$EV/hand-over/`.

## Docs & records (every file the build and finish update)

- Plan: `~/.hermes/plans/leorna/86bcm901r-starter-packs.md` (this file). The orchestrator makes the read-only copy `$EV/plan-approved.md`.
- Code: `internal/library/{starter-packs.json,starter.go,starter_test.go}`, `internal/pack/starter.go`, `internal/store/postgres/{starter_packs.go,starter_packs_test.go}`, `internal/store/postgres/migrations/000024_starter_packs.{up,down}.sql`, `internal/web/{starter_packs.go,starter_packs_test.go,library.go,handler.go}`, `cmd/control-plane/main.go`.
- Module README notes: `internal/pack/README.md` (new section) and `internal/library/README.md` (3 fixes + 1 line).
- Inventory: `delivery/stories.json` (the entry now; the PR number only after a PR exists and Justin says "push").
- Evidence: `$EV/` (base.txt, ac1–ac5 files, ac4-live/CHECKLIST.md (superseded by the agent check, *amended 2026-10-29*), gates-<sha7>.txt/.png, mutants.md; then `verifier/`, `auditor/` (each with its own `ac4-<head7>.log`, `ac4-<head7>/`, `ac4-base-<base7>.log`, `ac4-base-<base7>/`), `hand-over/`).
- AC4's check *(amended 2026-10-29)*: `~/.hermes/plans/leorna/86bcm901r-ac4/` (`run.sh`, `client-sync.go`, `browser/`, `expected/`), read only to every role; the planner's trial logs in `~/.hermes/plans/leorna/86bcm901r-ac4-spike/`.
- Shared memory (main session only): `leorna-workflow.md` status lines. `leorna-control-plane-workflow.md` only if the build proves a new gotcha.
- Hand-over (finisher): PR text `~/.hermes/cache/scratch/leorna-pr-86bcm901r-starter-packs.md` (or `$EV/hand-over/pr-text.md` on this desktop, where `~/.hermes/cache/scratch` doesn't exist), review prompt, ClickUp evidence draft (AC → test → screenshot table; ~~AC4 NOT VERIFIED until Justin runs it~~ *amended 2026-10-29:* AC4 agent-run and accepted, with `ac4-sync.png`, `ac4-catalog.png` and `ac4-assigned.png` from the verifier's or auditor's `ac4-<head7>/` folder, and one Assumptions line on what it doesn't cover, from Risks), team message draft, merge notes for PR #98. The hand-over files that still say AC4 is live or owed (listed under Amendments) are rewritten, and `ac4-steps.md` is dropped from the hand-over. Follow-ups go to `$EV/hand-over/followups.md` (QA1's README line if ⭐ A).
- Never: a ClickUp post, push or PR without Justin's word. No change to `.github/` or the seed.

## Follow-ups (for the PR's Assumptions)

1. Refresh or retire the single setup seed `seed.json` 1.2.0 (demo items, unpinned `github-mcp` 2.0.0): with 86bcm902a's quick start, or its own card (Q4).
2. Teams that should follow a starter pack's newest version automatically (Q2 B).
3. Hide superseded starter versions from new assignments.
4. When the desktop client installs agents: the two auditor agents start installing with no starter-pack change. Then 86bcm901a's follow-up adds agents to `/ship`'s and `/webperf`'s `requires`, and the packs pick that up on the next release.
5. 86bcm901w's builder doesn't add a ticked prompt's `requires` (86bcm901b follow-up 1); starter packs do.

## Other things found

1. **P3, process gap:** nothing forces a `content/library.json` bump when an item version changes. The README tells authors to bump it, and the 86bcm901a finisher noted "library.json's version is informational ... no Go test pins it". This story's AC3 rule reads that version as "the release", so a forgotten bump holds starter updates until the next one (with a warning, no outage). A test comparing `content.lock.json`'s new lines with a `library.json` change would close it. Not fixed here.
2. Already recorded elsewhere, not new: the seed's `github-mcp` 2.0.0 (86bcm901j found-else 2, P2); 901w's builder ignoring `requires` (86bcm901b follow-up 1).

## Planning receipt

Forecast 60–100 min; actual about 60–70 min of planning (2026-10-29, ~09:05–10:10 UTC). Planned against `6c1709e`. The drafted code was compiled, vetted, gofmt-checked and linted in a `git archive` export (`~/.cache/86bcm901r-planner/`, removed afterwards); no test was run. The mapping closure was checked with a script reading every `item.json` `requires`.

Amendment 1 receipt (2026-10-29, ~12:57–13:20 EDT, a fresh Opus 5.5 xhigh planner; forecast 2–3 h, actual about 25 minutes because the client's sign-in, registry and Sync entry points take injected dependencies): route read in leorna-client `f105e27`, check written in `~/.hermes/plans/leorna/86bcm901r-ac4/`, trial runs in `~/.hermes/plans/leorna/86bcm901r-ac4-spike/`: `head-398af64-try1.log` (first try: the route worked end to end, two harness bugs, a `go version -m` parse and JSON `null` warnings, fixed), `ac4-398af64.log` (`ok 1`), `ac4-base-6c1709e.log` (`not ok 1`), `ac4-abc60dc.log` (`ok 1`, the fixer's merge commit at the time) and `ac4-base-dd006b7.log` (`not ok 1`), each with its output folder. `ac-check.sh` on copies of the `abc60dc` / `dd006b7` receipts printed `AC4  ACCEPTED` with this plan and "isn't a test the approved plan names" with the pre-amendment copy. gitleaks found no leaks in either folder. The planner's databases (`leorna_86bcm901r_plan4_*_test`), detached copies and scratch were removed; no repo was written.
