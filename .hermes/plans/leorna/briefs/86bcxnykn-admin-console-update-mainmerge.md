# MAIN-MERGE brief (fixer role): 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: FIXER doing a main merge (a fresh general-purpose agent on Opus 5.5, high effort). Justin said on 2026-11-11: "update main run tests and lets merge this final user story". That covers bringing GitHub main into the story branch, installing the Go toolchain the tests need, and running the tests. It does **not** cover push, PR, merge into main or any ClickUp write: never do those. Start no other agents.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`, head `b9f1804631fbf6ffc20d0d0d6e0e103d67dff627` (accepted by `ac-check.sh`: AC1–AC4 ACCEPTED, AC5 live owed). Not pushed.
- GitHub main is `62c6d7d5aa6ed313368c89ffb2afd347cb1e98a0`, already fetched to `origin/main` in this worktree (re-check with `gh api repos/LeornaAI/leorna-control-plane/commits/main --jq .sha`; if it moved, fetch it with the `leorna` skill's HTTPS recipe and merge the newer one).
- Approved plan (read-only): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Evidence root: `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`. Write your evidence only in `main-merge/`.
- Follow-ups already deferred: `follow-ups.md` (don't fix them here).

## What changed on main since the story's base (4ef14ef)
- #124 Go 1.27.4 (`go.mod` and `go.work` say `go 1.27.4`; fixes GO-2026-6859). The desktop has only go1.27.3 at `~/.local/leorna-tools/go`.
- #125 OIDC SSO (86bcryh0m) took migration **000032** (`000032_tenant_sso`); #129 custom integrations took **000033**; #128 client self-update took **000034**. #126 integration connection test, #127 v0.2.0 release notes.
- `git merge-tree --write-tree --name-only HEAD origin/main` conflicts: `delivery/stories.json`, `internal/audit/README.md`, `internal/store/postgres/store_test.go`, `internal/web/handler.go`. Auto-merged: `cmd/control-plane/main.go`, `cmd/launcher/main.go`, `contracts/control-plane.openapi.yaml`, `packages/contracts/controlplane.gen.go`, `packages/contracts/roundtrip_test.go`, `internal/web/README.md`.

## Your job
1. **Toolchain:** install go1.27.4 for linux-amd64 from the official go.dev download, verifying its SHA-256 against the checksum go.dev publishes, into `~/.local/leorna-tools/` without breaking anything that uses the current path (for example extract to `~/.local/leorna-tools/go1.27.4/` and repoint `~/.local/leorna-tools/go`, keeping the old tree as `go1.27.3/`). Rebuild `~/.local/leorna-tools/bin/govulncheck` with it only if the gates need that. Record the before/after `go version` in `main-merge/toolchain.txt`.
2. **Merge, don't rebase:** `git merge origin/main` (a merge commit `merge: bring main (62c6d7d) into feat/86bcxnykn-admin-console-update`). Resolve each conflict keeping both sides' meaning. Then, in a separate commit after the merge:
   - **Renumber the story's migration from 000032 to 000035** (`000035_control_plane_updates.{up,down}.sql`). Update every reference: tests, the migration list or embed, README/docs, the plan-named up/down proof, the store test cleanup list. Check that no other migration number is reused and that the down file still undoes only this story's table. Follow #128's renumber commits (`926997e`, `1af966c`) as the house pattern.
   - Fix anything else main's changes broke in the story's code (for example new route registration in `handler.go`, the audit actions list, OpenAPI regen with `make contracts` or the repo's equivalent: the spec change must stay additive).
3. **Run every gate on the new head**, as the plan's Gates section and `leorna/references/gates.md` say, with the go1.27.4 tools by absolute path: `make check` (or each part), `make audit` (should now pass), `make secrets` (attribute any hit outside the story by commit), the Postgres no-skip run with `-timeout 1800s` in your own capped container, contracts-check, the migration up/down proof for 000035, and the old binary refusing the newer schema then recovering. Save the output to `main-merge/gates-<head7>.txt`.
4. **Run each AC test on the new head**: `TestControlPlaneUpdateAC1OfferWithPostgres`, `TestControlPlaneUpdateAC2RedeployWithPostgres`, `TestControlPlaneUpdateAC3RollbackWithPostgres`, `TestControlPlaneUpdateAC4AuditWithPostgres`, logs `main-merge/ac<n>-<head7>.log` (first line `HEAD=<sha>`, last `EXIT=<rc>`). AC5 is live and owed to Justin; don't touch it.
5. Commit with the repo's identity (never override author), `feat(86bcxnykn): …`/`fix(86bcxnykn): …` style, no AI attribution lines. Never stage `CLAUDE.md`. Don't push. Don't change `.github/workflows/*`. Leave `deploy/local/` alone.
6. Check the `delivery/stories.json` entry for this story still reads correctly next to the new entries from main.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (fixer rules), `engineering-best-practices`, `receiving-code-review`, `backend-data-migrations`, `api-contract-drift-guard`, `test-driven-development`, `git-commit-rules`.
Read before starting: `~/.claude/skills/leorna/references/repeat-mistakes.md` and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md`.

## Rules
- Postgres: your own capped container (`xnyk-merge-pg`, `--memory 1g`, CI's pinned image from `.github/workflows/ci.yml`, a database ending in `_test`). Wait with TCP `docker exec <c> pg_isready -h 127.0.0.1` in a loop that **fails** when its 3-minute bound runs out. Never use anyone else's container. Stop and remove it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command dying with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Any mutant runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`.
- Scratch: your own `~/.cache/86bcxnykn-mainmerge/`, created fresh with `mkdir` (no `-p`); `TMPDIR` and Go temp there. Never `git worktree prune`; remove only your own detached copies by path.
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes each.
- No real Scaleway, GitHub or ClickUp writes. Never print tokens, server domains or tenant IDs.
- Other bugs: `found_else`. Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory; `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status: ready-for-review|stopped, head, merge_commit, renumber_commit, conflicts_resolved[{file, how}], other_changes[], toolchain, gates, ac_runs[{ac, log, exit}], found_else[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
