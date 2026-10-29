# 86bcm902a — other things found (one list for the PR's follow-ups)

Sources: `~/.hermes/plans/leorna/found-else.md` (the 86bcm902a planner, builder, review 1, fixer 1, review 2 and blind-auditor headings), the plan's Follow-ups F1–F5, the sibling PR drafts (`leorna-pr-86bcm901r-starter-packs.md`, `leorna-pr-86bcm901y-remove-reorder.md`) and this finisher's integration check. "PR #" is the follow-up's number in `pr.md`.

## Product and code follow-ups (in the PR)

| # | PR # | Item | Severity / kind | Evidence |
| --- | --- | --- | --- | --- |
| 1 | 1 | **If B:** switch the quick start to 86bcm901r's shared starter versions and delete the stand-in (`starters.go`, `ResolveStarters`, the reuse-by-name path), with a `quick_starts` migration that records the assigned version. With both merged and no switch, a company that runs the quick start sees its own "Backend starter pack" next to 901r's shared one. | Integration, decides A/B | plan "Pending decision for Justin"; builder found-else "High (integration)"; `leorna-pr-86bcm901r-starter-packs.md:126` |
| 2 | 2 | After 901r: decide whether setup still loads the seed "Leorna starter pack" (1.2.0, demo items, github-mcp 2.0.0) as the base pack, and settle the "starter pack" wording (the wizard's seed vs the role packs). 901r's PR text hands both to 902a or a seed card; this branch leaves the seed unchanged. | Product | plan F2; `leorna-pr-86bcm901r-starter-packs.md:92,128,137`; PR #98 body follow-up 2 |
| 3 | 3 | Let the quick start add engineers and a first project inline (today it links to Teams and Projects). | Product | plan F3 |
| 4 | 4 | 86bcm902d: Pack Assignments show the version id, not "pack name · version N". | Product (902d) | plan F4; 901w F6 |
| 5 | 5 | A JSON API for the quick start if the installer or a CLI needs one (an OpenAPI change then). | Product | plan F5 |
| 6 | 6 | `AssignTeam` appends a `pack.assign` audit record even when the team default is unchanged. The quick start no longer calls it in that case (N1), but other callers still do. | Nit, pre-existing | review 2 found-else; `review2/probes-707a4c0.log` (resubmit probe) |
| 7 | 7 | AC1 doesn't pin a starter card's role title: auditor mutant M1c (title rendered as its key) passes, because the test checks role and pack name and every pack name contains its role. Pin the role inside `<strong>`. | Low, test strength | `evidence/86bcm902a/auditor/mutants/M1c-no-role-title-ac1.log` (EXIT=0) |
| 8 | 8 | `TrySetupLock` returns the same "not run" for "another setup step is running" and "every pool slot is busy", so a caller can't tell them apart (the quick start says "busy, nothing saved" for both). | Info, pre-existing | review 1 found-else |
| 9 | 9 | A resubmit after a pick whose browser went away shows the done sentence with the 409 "team name already exists" alert above it: both true, but they read oddly together. | Nit, UX | fixer 1 found-else |
| 10 | 10 | Test helper `readBody` (`internal/web/handler_test.go:308-316`) caps replies at 64 KiB; a starter pack's `/content` (~290 KB) then decodes as "unexpected end of JSON input". The AC tests use their own 8 MiB bound (`quick_start_test.go:251-252`). | Low, pre-existing, tests only | builder found-else; also in `leorna-control-plane-workflow.md` |

## Merge mechanics (for whoever merges second; in `integration.md`, not PR follow-ups)

| # | Item | Evidence |
| --- | --- | --- |
| 11 | Migration `000024` is also added by 86bcm901r and 86bcm901y. The later merger renames its pair to the next free number (24/25/26 by merge order) and its "migration 24" mentions; for 902a that is `internal/onboarding/README.md:51`. | `integration.md`; review1 `trial-merge-901r.txt`, `trial-merge-901y.txt` |
| 12 | With 86bcm901y: `internal/web/quick_start_test.go:1146` calls `SaveVersion(…, []string{added}, nil)`; after 901y it must pass `pack.VersionChange{AddLibraryItemIDs: []string{added}}`. It merges clean, but `go vet` and the `internal/web` test build fail until changed (proven in this finisher's trial tree, then green with the fix). | `integration.md`; review 2 found-else; `leorna-pr-86bcm901y-remove-reorder.md:113,120` |
| 13 | `delivery/stories.json`: every sibling appends last, so the second merger takes the first's file unchanged and appends its own entry as text, then checks every earlier entry by value. | `integration.md` |
| 14 | 86bcm901r and 86bcm901y also conflict with each other (`stories.json`, `internal/pack/README.md`, `internal/web/library.go`) and each declares a `mintDesktopToken` test helper in `internal/web`. That's for their finishers, not this story. | review 1 and review 2 found-else |

## Evidence and process notes (no code change)

| # | Item | Status |
| --- | --- | --- |
| 15 | The plan's E1 capture recipe uses `LEORNA_PUBLIC_BASE_URL=https://pending.leorna.invalid`, which turns client discovery off (503), so the desktop sign-in can't run. The builder, verifier and auditor used `https://demo.leorna.invalid` (or another reserved `.invalid` name) instead. | Info; already in `leorna-control-plane-workflow.md` (auditor found-else) |
| 16 | Starter card CSS: the builder's first cards ran role, pack name, item count and description together on one line. | Done: review 1 F8, fixed in `707a4c0` (`.starter .meta { display: block; }`); the AC1 image shows separate lines |
| 17 | The approved plan's risk R1 command has no `.up.sql` filter, so it lists every migration version as duplicated. | Done: the `leorna` skill line now carries the filter; this finisher used it (review 1 found-else) |
| 18 | No gates screenshot (`gates-9a9bdec.png`) exists in the story's evidence, although `clickup-evidence.md` (memory) asks for one. The verifier's gate log is clean and can be rendered before "post". | Open, process (this finisher) |
| 19 | For 86bcm901r's card: "/plan" ships as prompt `planning` (Claude Code has a built-in `/plan`), and its "Repo: content" is likely this repo's `internal/library`. | Info (planner found-else) |

## Added after round-3 review (2026-10-29, main session; from evidence/86bcm902a/follow-ups.md)
- R3-1 (P3, test gap): the "same pick again" team-default check is tested only with one-row assignment lists; add a case with [team default, project override of that team, another team's default] (review-3 probe TestReview3SamePickWithMoreAssignmentRows).
- R3-2 (P3, test gap): TestQuickStartPickIsBoundedAndReleasesTheLockWithPostgres checks the advisory lock from the pool (re-entrant per session); probe from a fresh session like setup_lock_test.go lockFree (review-3 probe TestReview3BoundedPickLockFreeFromAFreshSession).
- Pre-existing (story 86bbu3xr4): setup_lock.go:41 unlock on WithoutCancel drops the 30 s deadline.
