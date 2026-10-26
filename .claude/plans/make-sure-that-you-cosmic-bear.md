# Round-3 review: 86bbu3xew "Connect existing database" (feat/86bbu3xew-connect-existing-db @ d092859)

## Context
This is a re-review after the round-2 fixes. The rules: review only. No commit, push, PR or ClickUp change. Restore every temporary edit. Leave `deploy/local/` alone. HEAD must still be d092859 at the end.

## Confirmed read-only so far (plan mode)
- **Branch:** HEAD d092859 has 15 commits on bdd5995. GitHub `main` is still bdd5995 (`git ls-remote`), and `merge-base --is-ancestor bdd5995 HEAD` passes, so **no merge test is needed** unless main moves before the run.
- **Commits:** all 15 are `Justin Issa <justin@leorna.com>` with empty bodies.
- **stories.json:** `86bbu3xew` → `[36, 51]`, and both PRs were merged on GitHub (checked in round 1). 17 files changed vs main; no migration or OpenAPI file.
- **Unit tests without a database, on d092859:** they all PASS: dbcheck (`ParseEndpoint`, `DefaultAllowAddress`, `Classify`, `CheckFailsBeforeReachingADatabase`), web `TestSetupIsAdvancing`, scaleway and provision. `go vet` and `gofmt` are clean.
- **Rounds 1–2 fixes** are still in place in `check.go`: the exact metadata list, the embedded-IPv4 check for ::/96 and 64:ff9b::/96, `WithZone("")`, and zoned endpoints rejected.
- **A. The #58 clash: fixed, pending the Postgres run.**
  - `renderSetup` now delegates to `renderSetupPage(..., handler.autoSetup)`, so #58's behaviour is unchanged.
  - Only the 422 and 500 renders in `setupExistingDatabase` pass `false` (`setup.go:244,249`). `autoRefresh` is only set inside that branch, so the meta refresh is off too.
  - The new subtest checks the 422, "rejected", no `http-equiv="refresh"`, and zero rows. It then attaches for real and checks that auto-setup loads the pack.
  - Follow-up for Christian (pre-existing on main): his own failure pages still auto-advance and refresh. In auto mode, a GET with Scaleway connected auto-provisions before the admin can choose "existing".
- **B. Stale comment:** fixed (`check.go:39-40`).
- **C. GCP and Azure:** fixed and accurate.
  - Google's querying-metadata doc: "The IPv6 address (only for IPv6-only instances): `http://fd20:ce::254/computeMetadata/v1`". It is in the list and tested.
  - Azure's official IMDS page documents only `169.254.169.254` and gives no IPv6 endpoint. An explicit "IPv4 only" appears only in a Microsoft Q&A answer.
- **D. PG\* reasoning:** agree. It is now accurate: empty URL params do override env (`config.go:673-675` copies them all), and `service=` in the URL triggers a service-file read, so `PGSERVICE` can't be cleared that way.
  - Side note: the stored DSN wouldn't need the extra params if you tested with a pinned DSN and returned the clean one, but that is Justin's call (already decided).

## Still to run (needs plan mode off; each step changes state)
1. **Setup:** `open -a Docker`, `docker start leorna-test-pg`, then export `LEORNA_TEST_DATABASE_URL`. `git fetch origin` and re-check ancestry; if main has moved, run the worktree merge from the prompt.
2. **Gates:**
   - `make check`
   - `bash ./scripts/test-module-add.sh`
   - the targeted `go test -race -count=1 -v` command from the prompt (it includes `TestAutoSetup` and `TestSetupIsAdvancing`), grepped for `--- SKIP` and `--- FAIL`
   - If gitleaks flags anything, name the commit and scope it with `--log-opts="origin/main..HEAD"`.
3. **SSRF probes** in a temporary `internal/cloud/dbcheck/zz_review_probe_test.go`, deleted afterwards:
   - the default guard on the 10 endpoints in the prompt, including `[fd20:ce::254]`
   - a recording guard for multi-host endpoints, URL tricks, zones and the `PG*` overrides
   - the zero-value timeout against a silent listener (about 10 s)
   - `PGSSLROOTCERT=/nonexistent` and `PGTARGETSESSIONATTRS=read-only` against the README
4. **The 23 mutations from the prompt,** including "pass handler.autoSetup instead of false". After each: Edit, run the targeted tests, record the catching test, `git checkout -- <file>`, then `git diff --quiet`. Use never-true comparisons.
5. **Clean up:** `git status` must show only `?? deploy/local/`, HEAD must be d092859, and no worktree may be left.

## Report
In this order:
1. The verdict.
2. Each previous finding and A–D marked fixed, not fixed or disagree.
3. The AC/DoD table, including auto-setup on, with CI marked local-only.
4. Trimmed output.
5. One line per mutation.
6. New issues, with a severity and file:line.
