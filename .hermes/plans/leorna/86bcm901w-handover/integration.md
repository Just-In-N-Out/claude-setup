# 86bcm901w integration check (finisher, read-only)

- **Story head:** `8a5048694d40ee975c7b3c276ca1b8af521cae5d` on `feat/86bcm901w-create-pack` (worktree clean, 18 commits on base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`, not pushed; `gh pr list --head feat/86bcm901w-create-pack --state all` is empty).
- **Checked:** 2026-10-28 22:59:57 UTC.

## GitHub `main`: has not moved

- I fetched over HTTPS through gh: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main` (exit 0).
- `git rev-parse origin/main` = `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha` = `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- **`main_moved: false`.** `git merge-tree --write-tree --name-only HEAD origin/main` exits 0 with no conflicts. The branch sits directly on main, so no gate rerun is needed for main today.
- **Recheck before "make a PR":** `refs/remotes/origin/main` is shared by every worktree. Fetch again and run `git merge-base --is-ancestor <fresh main> HEAD` before the final gates (`leorna` step 7.1).

## Open siblings: merge-tree of this branch against each

Each sibling's head was read by ref only. No checkout, and no sibling worktree was touched.

| Against | Head | Conflicts | Auto-merged |
| --- | --- | --- | --- |
| `origin/main` | `1ee7157` | none | n/a |
| PR #94 `feat/86bcm9021-create-item-templates` (Yan, OPEN, draft, GitHub says MERGEABLE) | `fd63455` (fetched as `pull/94/head`; `FETCH_HEAD` = `gh pr view 94 --json headRefOid`, checked) | `internal/web/handler.go` (1 hunk) | `cmd/control-plane/main.go`, `delivery/stories.json`, `internal/pack/README.md` |
| `feat/86bcm901a-agent-definitions` (local only) | `9c13e02` | `delivery/stories.json` | none |
| `feat/86bcm901b-prompts-collection` (local only) | `63afe55` | `delivery/stories.json` | none |
| `feat/86bcm901j-mcp-templates` (local only) | `66449af` | `delivery/stories.json` | none |

All four siblings branch from `1ee7157`, the same base as this story.

### PR #94: `internal/web/handler.go`, one struct-field hunk

```
	packVersions                  packVersioner
<<<<<<< HEAD
	packBuilder                   packBuilder
=======
	itemBuilder                   itemCreator
>>>>>>> fd63455…
	packVersionsTemplate          *template.Template
```

- **Resolution:** keep both fields. They have the same name length, so gofmt alignment doesn't change.
- **The routes merged cleanly:**
  - #94's `GET`/`POST /admin/packs/versions/new` sit at merged lines 275–276;
  - this story's `/admin/library/packs…` and `/v1/packs…` sit at 286–291.
- **`cmd/control-plane/main.go` merged cleanly:** `SetItemBuilder(...)` comes right after `SetPackVersions`, and `SetPackBuilder(...)` after `SetBundleServer`.
- **`internal/pack/README.md` merged cleanly:** this story's "Build a pack from the library (86bcm901w)" section lands last, after #94's "Creating a tenant item from scratch". That is the order the plan asked for.
- **`delivery/stories.json` merged cleanly, as valid JSON:** #94 inserts its `86bcm9021` entry in the middle of the file and this story appends `86bcm901w` last. The keys end `…86bcm9021, 86bcm945q, 86bcm9019, 86bcm902y, 86bcm901w`.
- **Dry run of the resolution (finisher, read-only):**
  - Steps: `git archive` of the merge-tree result into my scratch folder (not a worktree), then keep both fields.
  - Results:
    - no conflict markers left;
    - `gofmt -l` empty;
    - `go build ./...` exit 0;
    - `go vet ./...` exit 0;
    - `go test -count=1 ./internal/pack/... ./internal/web/ ./packages/contracts/... ./cmd/control-plane/` all ok.
  - That test run had no `LEORNA_TEST_DATABASE_URL`, so the Postgres tests skipped. **It is a prediction, not a gate.**
- **Whichever of the two merges second** resolves the hunk this way. Then it runs its own full gates on the merged content: `make check`, `test-module-add.sh`, the per-test Postgres stream, the story gate.
- **#94 also adds `GLOSSARY.md`.** If #94 merges first, this story's follow-up F7 becomes doable: a **Pack** entry. It is not required for this PR.
- **#94's body doesn't mention 86bcm901w.** So `scripts/check-story-shippable.py 86bcm901w` won't be blocked by #94's text (checked with `gh pr view 94 --json body`).

### 901a / 901b / 901j: `delivery/stories.json` only

Each sibling appends its own entry last, just as this story does. So the two appends collide at the end of the file:

```
<<<<<<< HEAD
  "86bcm901w": {
    "name": "Create a pack by picking library items",
=======
  "86bcm901a": {
    "name": "Curate agent definitions",
>>>>>>> feat/86bcm901a-agent-definitions
```

- **Resolution (the `leorna` skill, step 7.2):** take main's file unchanged and append the second story's entry last, as text: drop the final `}`, add `,` and the entry, then close. Then check that every earlier entry is unchanged by value. Never re-dump the JSON: 945q's inline arrays would be rewritten.
- **Dry run:** I treated each sibling's file as "main", appended this story's entry as text, and checked it with `python3 -I`. All four cases (901a, 901b, 901j and PR #94 first) give valid JSON with 37 → 38 entries, `86bcm901w` last, and every earlier entry equal by value and in the same order.
- **If 901w merges first,** the sibling's finisher does the same with its own entry.
- **No other file overlaps.** 901a, 901b and 901j touch library content, curation and the upstream tool. This story touches none of those, and none of them touches this story's files.
- **After any sibling merges,** rerun this story's gates on main's new content anyway, because a sibling's new library items render on the library page:
  - `TestLibraryShowsTheShippedLibraryWithPostgres` is expected to keep passing (the checkbox cell sits before the name cell).
  - The AC tests use fixture library rows.

## Migration numbering

- This story adds `internal/store/postgres/migrations/000023_pack_builder.{up,down}.sql`. Main's last migration is 22.
- `git diff --name-only 1ee7157 <ref> -- internal/store/postgres/migrations/` is empty for PR #94, 901a, 901b and 901j. **No sibling adds a migration**, so nothing else claims `000023`.
- I also checked every `origin/feat/*` ref: none holds a `000023*` file, and the unmerged ones are old.
- None of the siblings touches `contracts/` or `packages/contracts/` either, so there is no OpenAPI merge.

## What the second-to-merge finisher does

| Merges second | File | How |
| --- | --- | --- |
| 901w after #94 | `internal/web/handler.go` | keep both struct fields (`packBuilder`, `itemBuilder`) |
| 901w after #94 | `GLOSSARY.md` (new on main) | optional: add the **Pack** entry (F7); otherwise leave it as a follow-up |
| 901w after 901a/901b/901j | `delivery/stories.json` | main's file unchanged, append the `86bcm901w` entry last as text, then check earlier entries by value |
| #94 / a sibling after 901w | same files | the mirror image: keep both fields, and append their own entry |
| 901w after anything | — | rerun the story's gates on the merged content before pushing. Bringing main in needs Justin's "bring main in" OK together with "make a PR"; per `git-commit-rules` that means `git merge origin/main` and a `Merge branch 'main' into feat/86bcm901w-create-pack` commit, with no rebase and no force-push. |
