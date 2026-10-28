# 86bcm901w follow-ups and other things found (consolidated, for the PR and the backlog)

**Sources:**

- the plan's Follow-ups (F1–F7) and "Other things found";
- the `86bcm901w` entries in `~/.hermes/plans/leorna/found-else.md` (lines 122–124, 136–139, 165–169, 176, 182, 184, 191 on 2026-10-28);
- the sibling drafts `leorna-pr-86bcm901a-agent-definitions.md` and `leorna-pr-86bcm901b-prompts-collection.md`;
- PR #94's body.

None of these blocks this story. Severity uses the pipeline's P-scale; "pre-existing" means it is on `main` at `1ee7157` too.

## Product follow-ups (cards or stories to pick up)

| # | What | Why / evidence | Owner / card |
| --- | --- | --- | --- |
| 1 | **Dependency flag at the pack builder's plug-in point.** When an admin ticks an item with required items (901b's prompts carry `requires`), add them or warn. | The plan's D10 and F1 put it after `ApplyChange` in `CreatePack`/`SavePackVersion`, surfaced as `PackVersionDetail.dependencyWarnings` plus a chip. 901b's PR draft names the reader `Library.Required(prompt)` (its plan said `library.Item.Requires`); use 901b's name once it merges. That draft's follow-up 1 is exactly this. | 86bcm901b AC3 / a 901w follow-up |
| 2 | **The line with 86bcm901y:** reorder items (a stored position plus an `order` field), remove items that didn't come from the library, and make the client's sync removal or flagging match the lockfile. | Versions store no order; they list items by kind, then name (`loadVersionItems`). The edit view leaves non-library items as they are ("N item(s) … are not in the library and stay as they are"). | 86bcm901y |
| 3 | **F4 (P2, pre-existing):** `Fork`, `SaveEditedVersion` and add-library-item create pack versions without a change record. PR #94's `CreateItem` uses the same path. | `internal/store/postgres/pack_versions.go` `CreateVersion` has no `appendAudit`. `internal/audit/README.md`: "Future domain mutation methods must call appendAudit inside their transaction." | team decision; fits after #94 |
| 4 | **F7:** add a **Pack** entry to `GLOSSARY.md`: "a named lineage of immutable pack versions numbered 1, 2, 3…; built from content library items". | `GLOSSARY.md` doesn't exist on `1ee7157`; PR #94 adds it. | whoever merges second of #94 / 901w, or a small follow-up |
| 5 | **F5:** carry a script approval forward to a new version when the item's script is unchanged. | Every version gets new item ids, so adding or removing any item forces re-approval of untouched script items (migration 22 comment; `pack_versions.go`). | backlog |
| 6 | **F6 (86bcm902d):** show "pack name · version N" on Assignments and Pack Versions for built packs, plus rename and delete. | Out of scope here (plan Assumption 9). Delete needs a deliberate change to migration 23's triggers (row 11). | 86bcm902d |
| 7 | **Optional client snapshot refresh:** copy the new `contracts/control-plane.openapi.yaml` into `leorna-client/api/` and run `make generate`. | The client keeps its own snapshot, so its `make contracts-check` stays green without the refresh. Refreshing adds unused types only. | client, optional |
| 8 | **(Info, new; from the 901a finisher)** The JSON API accepts any stored library item id, including older versions the catalog no longer lists. | The console picker offers only the newest version per kind and name (`ListLibraryItems`: `SELECT DISTINCT ON (kind, name) … ORDER BY kind, name, string_to_array(version, '.')::numeric[] DESC`). `loadLibraryItems` reads any `library_items` row by id. After 86bcm901a ships `agent/code-reviewer@2.0.0`, the retired `@1.0.0` rows stay and could be picked by id through `/v1/packs`. Decide whether to refuse superseded ids. | team decision, after 901a merges |

## Code and test follow-ups

| # | Severity | What | Evidence |
| --- | --- | --- | --- |
| 9 | P3, pre-existing; by code reading, not probed | **Team and project raw-path-id audit target:** the same pattern 901w's R1-F1 fixed for packs. A save from an upper-case UUID URL is filed under that text, so the history filtered by the stored id may miss it. | `internal/web/teams_view.go:173` → `internal/store/postgres/teams.go:151,188,229,246` (team.update/delete, membership.add/remove); `internal/web/projects_view.go:91` → `internal/store/postgres/projects.go:105,116` (project.renew/delete). Review 1's lead, extended by fixer 1. Not checked whether the HTML routes accept upper-case ids. |
| 10 | P4, introduced (defence in depth) | **DB5–DB7:** three migration 23 constraints have no test: `pack_number >= 1`, the lineage name CHECK `char_length(btrim(name)) BETWEEN 1 AND 200`, and the lineage `tenant_id` FK to `tenants`. | Each mutant survives all 435 tests in store, web and dbcheck. App code validates names and numbers versions from the parent. Receipt `evidence/86bcm901w/fixer2/found-else-constraints-8a50486.txt`. |
| 11 | P4, introduced (test isolation, no defect) | **AC4 unknown-item masking:** AC4's `unknown_library_item` sends only an unknown id, so the empty-pack check masks the unknown-id guard. Mutant AC4unk (unknown id silently dropped) passes AC4; only store subtest `unknown_or_malformed_library_item_is_invalid` kills it. Add a valid-plus-unknown AC4 case. | `evidence/86bcm901w/verifier/mutations-verifier-8a50486.txt` |
| 12 | Info, introduced by design | **Migration 23's triggers make every pack version undeletable,** not only built ones (like `audit_records`). A future "delete a pack" or tenant-offboarding feature needs a deliberate path. Today no code updates or deletes pack versions, and `tenants` is `ON DELETE RESTRICT`. | Documented in `internal/pack/README.md`. The finisher grepped non-test Go and SQL for UPDATE/DELETE on `pack_versions`, `pack_version_items` or `tenants`: only migrations 18 and 21's downs delete items, and they run after 23's down has dropped the triggers. |
| 13 | P3, pre-existing | `waitForLockWait` (`internal/store/postgres/pack_versions_test.go:325-343`) matches the exact INSERT text in `pg_stat_activity`. A harmless text change to `EnsureSeedBase`'s insert makes `TestEnsureSeedBaseWithPostgres` fail with "never waited" and leaks its goroutine. | 86bcm901w builder 2. 901w's own `waitForPackLineageLock` was hardened in `bede133`. |
| 14 | P3, pre-existing | `teamForm` (`internal/web/teams_view.go:151-170`) repeats `adminForm`'s content-type, body-bound and CSRF checks instead of calling it, so changes to the shared helper (like 901w's `adminFormLimit`) don't reach team forms. Not a bug today. | 86bcm901w builder 2 |

## Plan and environment notes (no code change)

| # | Severity | What | Evidence |
| --- | --- | --- | --- |
| 15 | Low, plan text only | **The plan's E1 demo-server recipe** points `LEORNA_DATABASE_URL` at `127.0.0.1:5432` (Justin's `leorna-pg`) but creates the demo DB in `leorna-test-pg` on `55432`. Followed literally, it connects to the wrong container. The auditor and builder used 55432. Fix the template for future plans. | `86bcm901w-create-pack.md` "E1"; auditor note in `found-else.md` |
| 16 | Info | **Seed vs library name overlap after 86bcm901a:** the seed keeps demo `agent/code-reviewer@1.0.0` while the library ships `@2.0.0`. Built packs hold only library items, and starter-pack versions aren't editable here (Q2-A), so no built pack mixes them. A team assigned a built pack instead of the seed gets the library's version. | 86bcm901a PR draft, Assumptions ("86bcm901w … should know") |
| 17 | Info | `delivery/stories.json` on main lists no PR for 86bcm9016 (#85), 86bcm901u (#90) or 86bcm9019 (#92), and has no 86bcm945u entry (#89). It doesn't affect this story. | 86bcm901b PR draft, follow-up 4 |
