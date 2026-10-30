You are reviewing one Leorna control-plane story on its own. Don't trust anyone's summary, PR text or the shared memory notes: check everything yourself in the code and with real commands. **Review only:** no commits, pushes, PRs or ClickUp changes. Restore anything you change, and leave `deploy/local/` and every other story's worktree, branch and database alone.

## What to review

- Repo: `~/Leorna/leorna-control-plane` (Go, on Justin's Windows desktop inside WSL Ubuntu).
- Branch: `feat/86bcm901z-customise-shipped-item`, head `4904333a8fe0def527ad32603e115f2499c6cef8`, 19 commits on base `b65f797ff6cdc56a802dfaf417b0adec96463317`. **Local only, not pushed**, so run on this machine.
- Get the code: make your own detached copy, e.g. `git -C ~/Leorna/leorna-control-plane worktree add --detach ~/.cache/86bcm901z-review/tree 4904333a8fe0def527ad32603e115f2499c6cef8`. Never check anything out in `~/Leorna/leorna-control-plane` itself: other sessions share it. When done, `git worktree remove --force <your exact path>`. Never run `git worktree prune`.
- The range to read: `git diff b65f797...4904333` (34 files, about +5,500/−100).

## The card: "Customise a shipped item (company variant)"

As an admin, I want to make a company version of a shipped skill/agent/prompt, so that I can adapt it while staying close to the original. Context: variants keep a link to the upstream library item and version.

Acceptance criteria (each has a test named after it, in `internal/web`):
- AC1: Given a library item, when I customise it, then a tenant-owned variant is created linked to the upstream item + version. Test `TestVariantAC1CustomiseCreatesATenantOwnedVariantLinkedToTheUpstreamItemAndVersionWithPostgres`.
- AC2: Given a newer upstream version, then the admin sees an 'update available' notice with a diff and can merge or ignore. Test `TestVariantAC2NewerUpstreamVersionShowsAnUpdateNoticeWithADiffThenMergeOrIgnoreWithPostgres`.
- AC3: Given a variant, then it is used in packs exactly like a library item. Test `TestVariantAC3VariantIsUsedInPacksExactlyLikeALibraryItemWithPostgres`.
- AC4 (proposed by the planner, approved by Justin): Given a variant request that is invalid or not allowed, it is refused with a clear status or inline alert, nothing is written (no variant row change, no audit record, no pack version), a suspected secret is never echoed back, and one company never sees, changes or packs another company's variant. Refused requests include: a member, a bad CSRF token, signed out, another company's variant, a config or MCP template, a name the company's variants or a shipped item of that kind already use, a malformed name, a stale or unchanged edit, a suspected secret in the text, a merge or ignore with no newer upstream version or after upstream moved on, and an unknown id. Test `TestVariantAC4RefusedVariantRequestsWriteNothingAndStayInsideTheTenantWithPostgres`.

Verify: unit tests for variant lineage + upstream-diff; UI demo.
Definition of Done: unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.

## Decisions Justin already made (check they're implemented; don't re-argue them)

- Q1 A: a variant has its own name, prefilled `<name>-custom`. It is one more catalog row; a pack can hold the shipped item, the variant, or both.
- Q2 A: Merge is a three-way line merge. Where both sides changed the same lines nothing is saved; the admin resolves `<<<<<<< your variant` / `>>>>>>> upstream …` markers in a text box, and that save is the merge.
- Q3 A: Ignore records that version only. A newer upstream version shows the notice again.
- Q4 A: admins edit the description and main text. Supporting files follow upstream, and a merge takes upstream's files.
- Only skills, agents and prompts can be customised. Configs and MCP templates are refused, because their policy gate runs only on shipped content.
- Admins only. Every save runs the item editor's gate (`itembuilder` validation plus `gate.CheckTenantItem`: renders for Claude Code, Codex and Cursor, plus gitleaks).
- After review 2, Justin folded a fix to the **existing item editor** (`internal/web/item_create.go` create mode, `internal/web/pack_versions.go` edit mode) into this story. A suspected-secret refusal clears every typed field, not only the one the scanner names. Then: "Mark cleared file boxes required". A supporting-file text box a refusal emptied comes back `required`, so the browser won't resubmit it empty; choosing an upload lifts that.
- The migration is `000025_library_variants`. GitHub `main` has since taken 25 (`quick_starts`, #101) and 26 (`starter_packs`, #102). The renumber to 27 happens when main is brought in, which hasn't happened yet: don't report the number clash as a defect of this head, but do check the merge risk (below).

## Earlier findings and the claimed fixes (check each fix holds)

- R1-1 (P2): an unedited **agent** variant couldn't merge an upstream description change, because the customise rename of the agent's frontmatter name counted as a company change. Claimed fix (`c5bd6be`, `b534978`): `Variant.UneditedBody` (upstream with the frontmatter name set to the variant's) is the merge base and "theirs", and "Your changes" leaves the rename out.
- R2-1 (P2): a suspected secret in an agent variant's description was shown back in the main-text box. Claimed fix (`1e9e8fe`): every typed text on the variant page is cleared on a secret refusal. Same fix for the item editor in `08c09b8`.
- R3-1 (P2): after the item editor cleared supporting-file text, resubmitting saved 0-byte files. Claimed fix (`4904333`): those boxes come back `required data-cleared` with a note.
- Known P3s, left as follow-ups: the 2,000-line diff cap is untested (`internal/web/library_variants.go:263`); in runs of identical lines a clean merge can drop one company deletion (`internal/textdiff/textdiff.go:95`); a token typed as a file *path* is shown back in the item editor.

## Commands (all from your detached copy)

```bash
TOOLS=$HOME/.local/leorna-toolchain
export PATH="$TOOLS/go/bin:$TOOLS/bin:/usr/local/bin:/usr/bin:/bin" GOTOOLCHAIN=local
mkdir ~/.cache/86bcm901z-review/tmp; export TMPDIR=~/.cache/86bcm901z-review/tmp   # /tmp is a small RAM disk here
export GOLANGCI_LINT=$TOOLS/bin/golangci-lint GOVULNCHECK=$TOOLS/bin/govulncheck   # CI's 2.14.0 and v1.7.0; check with --version
export GITLEAKS=/usr/local/bin/gitleaks LEORNA_TEST_GITLEAKS_BIN=/usr/local/bin/gitleaks
PGPW=$(/usr/bin/docker exec leorna-test-pg printenv POSTGRES_PASSWORD); [ -n "$PGPW" ] || echo "STOP: empty password"
PGPORT=$(/usr/bin/docker port leorna-test-pg 5432 | head -1 | sed 's/.*://')
/usr/bin/docker exec leorna-test-pg psql -U leorna -d postgres -c 'CREATE DATABASE leorna_86bcm901z_review_test'   # your own DB; the name must end in _test
export LEORNA_TEST_DATABASE_URL="postgres://leorna:${PGPW}@127.0.0.1:${PGPORT}/leorna_86bcm901z_review_test?sslmode=disable"   # never print it
make check; echo "EXIT=$?"
bash ./scripts/test-module-add.sh; echo "EXIT=$?"
go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web ./internal/variant ./internal/textdiff > pg.json
```

- Read `pg.json` per test (Action plus that test's own Output), not `-v` text. No skip may name `LEORNA_TEST_DATABASE_URL`. The only accepted skips are `TestEvidenceThirdPartyContentPage` ("LEORNA_EVIDENCE_DIR is not set"), `TestProvisionManagedPostgresLive` ("SCW_LIVE=1 not set") and the two ClickHouse subtests of `TestTeamsAPIWithPostgres`.
- Run each AC test by name with `go test -v -count=1 -run '^<name>$' ./internal/web`.
- Prove each fails on base: copy the head's test files into a detached copy of `b65f797` and run them; they should fail to build.
- Drop your database when done: `DROP DATABASE leorna_86bcm901z_review_test WITH (FORCE)`. Never touch another `_test` database (`leorna_86bcm901z_test` is the builder's).
- Optional UI demo: build the head binary (`go build ./cmd/control-plane`) and run it in dev mode on loopback with your own database (see `README.md`), then customise `incident-postmortem` on `/admin/library/items/<id>`. For an update, build a second binary from a scratch copy with `skill/incident-postmortem` bumped to 1.2.0 (`internal/library/content`, plus `go test ./internal/library -run TestContentLock -update-lock`) and restart it on the same database. Never commit that change.

## Mutations to try (each must still compile; use `go test -overlay`, never edit the real files)

- Drop `tenant_id` from a variant query in `internal/store/postgres/library_variants.go`, or from `loadCatalogItems` in `internal/store/postgres/pack_builder.go`. AC4's other-company subtest or `TestPackBuilderCopiesOnlyTheTenantsOwnVariantsWithPostgres` must fail.
- Pass `false` instead of `true` to `beginOrg` in a variant write (dropping the admin re-check). Check whether a test catches it, given that the route's `requireAdmin` also guards.
- Skip the expected-version check in `internal/variant/service.go` (`Edit`, `Merge`, `Delete`) or the expected-upstream check in `Merge`/`Ignore`.
- Make `Customisable` accept configs, or skip the shipped-name check.
- Skip the gate in `Service.check`, or put typed text back on the page after a secret refusal (variant page and item editor).
- Make `textdiff.HasConflictMarkers` return false, or make `Merge3` keep only "ours".
- Remove `required` from the cleared file boxes in the item editor template. Note that Go tests only see markup: check whether a real browser blocks the resubmit (a chromedp probe through `-overlay` on the package's own fixture works).

## Also check

- **Security and tenant isolation:**
  - every new route is `requireSession` + `requireAdmin`; every form checks CSRF;
  - every store write re-checks the admin role in its transaction;
  - another company's variant id is a 404, refused in a pack, and absent from the other company's library;
  - SQL is parameterized; the variant preview uses the bounded renderer (`renderBoundedItem`), not the library's unbounded one;
  - audit records hold no description, body or files;
  - no suspected secret is echoed anywhere (look at the page HTML, not just the boxes).
- **Docs claims true as written:** `internal/library/README.md` "Company variants", `internal/pack/README.md`, `internal/web/README.md` (routes, statuses, the clearing and `required` rule), `internal/audit/README.md`, `GLOSSARY.md`.
- **OpenAPI:** description-only change. Run `make contracts-check`; the desktop client needs no change.
- **`delivery/stories.json`:** the `86bcm901z` entry is last with an empty PR list (no PR exists yet). Every earlier entry is unchanged by value against `b65f797`. `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` passes.
- **Commits:**
  - every author and committer in `git log b65f797..4904333` is Justin's Leorna identity (report "1 identity, Leorna OK", never the address);
  - no body matches `^co-authored-by:|generated with|noreply@anthropic|🤖`;
  - no `.github/` path and no `CLAUDE.md` in the diff.
- **Migration:** additive, one table. The down file drops it. An older binary refuses to start on a database that still records it, so the rollback order is down first, then the deploy. Check that the PR notes say so.
- **Merge risk with main:**
  - fetch GitHub main read-only with `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`, then compare with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`;
  - run `git merge-tree --write-tree --name-only 4904333 origin/main`. Expected: conflicts in `delivery/stories.json`, `internal/audit/README.md`, `internal/store/postgres/store_test.go` and `internal/web/library.go`, plus the migration number to renumber to 27;
  - say whether you see anything beyond that, including against open PRs (`gh pr list -R LeornaAI/leorna-control-plane --state open`; fetch `pull/<n>/head` read-only, and check `FETCH_HEAD` equals `headRefOid` first).

## Report format

1. A one-line verdict: Ready / Ready with nits / Not ready.
2. A table per AC and per DoD item: met or not, with the evidence (test, file:line, command output).
3. The real output of `make check`, module-add, the Postgres stream summary (counts and any skips) and each AC test.
4. Mutation results: which you tried, killed or survived, and by which test.
5. Issues, each labelled **introduced** or **pre-existing**, with severity (P0 security hole or false AC; P1 guard bypass or wrong block; P2 a bug a real user could hit; P3 cosmetic or docs), file:line, a concrete scenario and a suggested fix.
