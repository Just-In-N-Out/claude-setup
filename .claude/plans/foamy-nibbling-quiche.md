# Ranking the 4 cards — checked against both repos

## Context
Justin asked to rank 4 ClickUp cards easiest → hardest and post "picked up 3, done by Sunday".
My first ranking used only the card text. This one checks current `main` in both repos
(client `b2eb9f1`, control plane `6763122`, fetched 2026-10-02 over HTTPS because the SSH key
isn't loaded — run `! ssh-add --apple-use-keychain ~/.ssh/id_ed25519_leorna`).

Instruction files: there is **no CLAUDE.md** in the workspace, client or control plane. Both
repos have an AGENTS.md: OpenAPI is the only cross-repo link, keep `toolconnector.Connector` and
the Claude Code connector, a story is only done when every PR in both repos is merged and main CI
is green, `delivery/stories.json` + `check-story-shippable.py`, and an AI review is never a human
approval. (The client AGENTS.md points to a "workspace AGENTS.md" that doesn't exist locally.)

## What changed since the cards were written
- **Native writer 86bbu3xg7 is merged** (client PR #9, Yan, 2026-10-01; docs PR #10):
  `toolconnector/nativewrite` — atomic writes, rollback, `.leorna.bak` backups. This unblocks
  Integrity and part of Sync.
- **Seed checksum (86bbu3xfe, PR #38) and IaCGenerator (PR #23) are both merged** → Packaging is unblocked.
- **The team dropped TrueForge.** Merged spec `docs/superpowers/specs/2026-10-01-context-ingest-handoff-api-design.md`
  (PR #72): "Leorna … does not host a chat and does not need TrueForge."
- Control plane added a GHCR image (`ghcr.io/leornaai/control-plane:<sha>`, PR #75) and
  `make dist` → Windows installer `.exe` (PR #73, `docs/deploy/packaging.md`).

## Ranking (easiest → hardest)

| # | Card | Repo | Ready? | What's really left |
|---|---|---|---|---|
| 1 | **Integrity verify (check)** — S | client only | Yes, writer merged | Hash written files, report drift by path, log to SQLite (`run_logs` table exists in `application/application.go`, nothing writes to it yet). **One decision:** which lockfile — the server lockfile hashes pack-item bodies (`<kind>/<name>`), not the transformed files on disk, so check needs a client record of what was written. |
| 2 | **Package admin-portal distribution** — M | control plane only | Yes, deps merged | Pieces exist (GHCR image, embedded seed + `seed.sha256`, IaC templates in `internal/cloud/scaleway/templates`, `scripts/dist.sh`). Missing: one versioned bundle + checksum manifest + validate + "fails if a component is missing" test. Decisions: image by digest vs tarball; IaC is Go-embedded templates, not standalone modules. |
| 3 | **Sync action end-to-end** — M (really L) | **both** | Partly | Server bundle endpoint (`GET /v1/client/projects/{id}/bundle`) sends hashes only, **no file contents** → needs a control-plane OpenAPI change first, then client HTTP + transform + write + check + SQLite + Sync button. Depends on #1. |
| — | **Deploy TrueForge + Runtime port** | neither has any code | **Probably obsolete** | No TrueForge or Runtime port exists in either repo, and the team's 10-01 spec says Leorna doesn't need TrueForge. Needs a live deploy if it's still wanted. Ask the lead before picking it up. |

## Overlap risks (ask before starting)
- **Integrity + Sync are Sonal's.** Her card notes an *unpushed* local commit `0309285`
  (`Application.SyncNative`, `TestNativeSyncAndCheckPersistAcrossReopen`) that already does
  hash check + SQLite logging — that overlaps Integrity directly. Her GitHub fetches fail, so it
  isn't on any remote branch.
- **Packaging + TrueForge are Youssef's.** Installer packaging work (#73/#75) is happening right
  next to Packaging.

## Decision (Justin, 2026-10-02): TrueForge is being dropped
Picked up: Integrity verify, Package admin-portal distribution, Sync end-to-end.

Team message:
```
Hello team, picked up 3 user stories. Planning on getting them done by Sunday.

1. Integrity verify (check) (client)
2. Package admin-portal distribution (control plane)
3. Sync action end-to-end (client + control plane)

@Sonal you have local SyncNative/check work that isn't pushed. Can we sync up so I don't redo it?
@Youssef ok if I take Packaging?
```
Note: Sync by Sunday is a stretch — it needs a server content endpoint first.

## Next step after approval
Nothing is edited. If Justin approves, I start with **Integrity verify** on a branch
`feat/<clickup-id>-integrity-check` from updated client main (needs the ClickUp ID from Justin —
don't guess it), test first.

## Verification of these claims
- `git log origin/main -- toolconnector/nativewrite` (client) → YanXu commits 2026-09-30.
- `git show origin/main:internal/bundle/README.md` (control plane) → "file contents are not part of this endpoint".
- `git grep -i trueforge origin/main` (control plane) → the 10-01 spec lines; none in client.
- `git grep 'INSERT INTO run_logs' origin/main` (client) → no hits.
