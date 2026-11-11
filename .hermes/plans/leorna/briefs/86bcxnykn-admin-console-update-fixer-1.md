# FIXER brief, round 1: 86bcxnykn, update the control plane in place from the admin console (with rollback)

Role: FIXER (a fresh general-purpose agent on Opus 5.5, high effort). Fix review round 1's P0–P2 findings test-first, commit, and stop at `status: ready-for-next-review`. No rebase, push, PR, merge or ClickUp write. Start no other agents; the next fresh review comes from the main session. Don't redesign beyond what a finding needs. If a fix would change what an AC says, stop and report the options.

- Worktree: `/home/justin/Leorna/86bcxnykn-admin-console-update`, branch `feat/86bcxnykn-admin-console-update`, head `91326925e7af53413e8217578bde84e8916a4964`, base `4ef14efb46da789aec30fad1e5a988d8770140e2`.
- Approved plan (contract, read-only copy): `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/plan-approved.md`. Every ⭐ option is chosen (Q3 A: a rollback that can't happen because the database migrated says why and the admin **fixes forward**).
- Review record: `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/review-1/review.json`, with receipts in `review-1/` (`probe-web.log` probes P1–P3, `mutants-review1.txt`). Read it.
- Evidence root: `/home/justin/.hermes/plans/leorna/evidence/86bcxnykn/`. Write your receipts in `fix-1/` only. If a fix changes what an AC screenshot shows (for example the blocked page), retake that screenshot with the builder's journey recipe (`build/journey/`, INVENTORY.md), keep the old one in `superseded-9132692/`, and record the new one in INVENTORY.md. Images show the result only: no banners, labels, test names, SHAs or notes drawn on them.

## The findings to fix (the referee's lines, verbatim)
```
R1-1  P2  internal/update/service.go:201  After a blocked rollback the console can never fix forward. When Scaleway reports the failed deployment as error and the database already migrated, the row ends rollback_blocked, the page says 'Retry the update, update to a fixed release, or run the installer's resume' (internal/web/control_plane_update.go:171; internal/update/README.md:106) and still shows the 'Update to vX' form, but Service.Start refuses every start while the container status is not ready: 409 UPDATE_CONTAINER_BUSY 'still deploying; try again in a few minutes'. Scaleway keeps error until a new deployment, so the refusal never ends (plan Q3 answer A: the admin fixes forward). Probe review-1/probe-web.log P1: retry v0.3.0 -> 409; a fixed v0.3.1 is offered with its form -> 409; no new row, no Scaleway write. service_test.go:92 pins the refusal. A fix that lets error through must also cover a retry of the same version: from_image == to_image then takes the reconciler.go:203 shortcut, no PATCH is sent and LEORNA_UPDATE_ID is never set (probe P3: 0 PATCH, 1 redeploy), so that retry could never confirm.
R1-2  P2  internal/update/README.md:124  The Live check runbook (AC5) states results the code can't give. Step 2 says a local-image install 'runs LEORNA_RELEASE_VERSION=vX' and step 5 says the page 'shows vX' and ends 'Updated from vX to vX+1'. ReleaseVersionFor (internal/launcher/release_version.go:20) returns '' for every image but the installer's own digest-pinned ghcr default (local mode passes ''; release_version_test.go rows 6 to 9), so the container gets LEORNA_RELEASE_VERSION=dev, the page shows 'Running version: unknown' and the result reads 'Updated from the previous version to vX+1'. Step 2's 'local image mode pointing at the vX digest' also doesn't exist: LEORNA_IMAGE_SOURCE=local builds from source, and a digest is given with LEORNA_PREBUILT_IMAGE (internal/installer/image/image.go:74).
```
R1-3 (P3) is the same shortcut R1-1 says its fix must cover: fix it as part of R1-1 (the shortcut must also require the container's `LEORNA_UPDATE_ID` to be this update, or the same-version retry must send a PATCH that sets it). The other P3s (R1-4 to R1-10) go to follow-ups: don't fix them unless one lands in a line you're already changing and costs one line. Say which in your report.

For R1-2: make the runbook match what the code does, with steps Justin can actually follow (how vX gets its version on a local or prebuilt install, if at all; what the page shows; what the audit says). If a truthful runbook needs a small code change (for example `ReleaseVersionFor` knowing a `LEORNA_PREBUILT_IMAGE` digest's version), say so and keep it minimal and tested; otherwise fix the text.

## How to work (`receiving-code-review`)
1. Verify each finding yourself first (reproduce R1-1 with a failing test through the real service and handler, in the exact state: `rollback_blocked`, container status `error`, newer and same version). Push back with evidence on any part that doesn't hold.
2. Fix the valid ones test-first: a RED test first, then the code, then GREEN. Kill a mutant of each new guard under the memory cap (`systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, `go test -overlay`, never editing the worktree for a mutant).
3. Keep the security bar: admin-only, CSRF, owner tenant, digest-only image, one active update. Letting `error` through must not let a start race an in-progress deploy or a running update.
4. Re-run the AC tests AC1–AC4 by name on your final head (logs `fix-1/ac<n>-<head7>.log`, first line `HEAD=`, last line `EXIT=`), and the plan's Gates on the final head (`gates-<head7>.txt` in the evidence root, tools by absolute path from `~/.local/leorna-tools/`, Postgres no-skip run with `-timeout 1800s`).
5. Commit each fix as `fix(86bcxnykn): …` with plain `git commit -m` (repo identity, no author override, no AI attribution lines, never commit `CLAUDE.md`). Check `git log -1 --pretty=format:'%an <%ae>'` is `Justin Issa <justin@leorna.com>`. Leave the worktree clean.

## Skills: load each one with the Skill tool in this order, and say so in one line
`leorna` (FINISHER fix-pass rules), `engineering-best-practices`, `receiving-code-review`, `test-driven-development`, `mutation-testing-discipline`, `git-commit-rules`, then `security-best-practices`, `backend-data-migrations` (only if you touch migrations), `authorized-write-safety`. Load `systematic-debugging` if a test fails unexpectedly.

## Rules
- Postgres: your own capped container (`xnyk-fix1-pg`, `--memory 1g`, CI's pinned image, a database ending in `_test`); never use the builder's or reviewer's. Stop it when done.
- Memory (WSL desktop): follow "Windows Desktop: Runaway Memory" in `/home/justin/.claude/CLAUDE.md`. A command dying with SIGTERM, 143, 137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first. Never run mutants alongside `make check`.
- Scratch: your own `~/.cache/86bcxnykn-fix1/`, created fresh with `mkdir` (no `-p`); `TMPDIR`, Go temp and Chrome profiles there with short socket paths.
- Don't end your turn to wait for a background command; wait in the foreground with bounded polls under 3 minutes, the Bash `timeout` above each bound.
- No real Scaleway, GitHub or ClickUp writes.
- Other bugs: `found_else` (one line each, evidence, severity).
- Skill lessons: `skill_lessons[{skill, lesson, evidence, enforce}]` plus a "Skill lessons" section; never edit skills or memory. `enforce` is `none` or a one-line check proposal (kind, what it checks, where it runs). An empty list is normal.

## Return
`{status: ready-for-next-review|stopped, summary, dispositions[{id, action: fixed|rejected|deferred, test, commit, evidence}], head, commits[], gates, ac_status[{ac, test, log, passes}], screenshots_changed[], found_else[], skill_lessons[]}`, and end with the line `MAIN SESSION: check and save these skill_lessons now.`
