# BUILDER + PR brief: leorna-client Go toolchain 1.27.4 (GO-2026-6859)

**Role:** builder and publisher of one small PR. You are a fresh agent: Opus 5.5, effort high. You start in your own isolated worktree of `leorna-client`, at `origin/main`.

**Skills** (say so in your first steps):
- `leorna`: the hard rules; Doing a story → step 7 "make a PR"
- `git-commit-rules`
- `github`
- `engineering-best-practices`

## Why
"Go quality gates" fails on every leorna-client PR, and on main, at `make lint audit`. The cause is GO-2026-6859, a Go standard library advisory (`net/http`) fixed in go1.27.4. The client's `go.mod` pins `toolchain go1.27.3`, and CI's `actions/setup-go` reads `go-version-file: go.mod`. The control plane fixed the same thing in LeornaAI/leorna-control-plane#124, "Upgrade Go to 1.27.4 (GO-2026-6859)". Look at its diff (`gh pr diff 124 -R LeornaAI/leorna-control-plane`) for the pattern.

**Justin, 2026-11-11:** "yes do the pr to up it". That authorizes this one branch: push it and open its PR. Never merge it.

## The work
1. **Branch from fresh GitHub main.**
   - Fetch main with the `leorna` 7.1 HTTPS-through-gh command, with the URL written out. Record its SHA. It should be `a7839b3`, unless main has moved.
   - Create the branch `feat/go-1.27.4-toolchain` from it. There is no ClickUp card, so say that under the PR's Assumptions.
   - Check that the branch doesn't already exist on GitHub, and that no open PR already does this bump.
2. **Change:** in `go.mod`, change `toolchain go1.27.3` to `toolchain go1.27.4`.
   - `git grep -n '1\.27\.3'` outside `vendor/`, and update any other pin or doc that names the toolchain version, as #124 did.
   - Don't touch `.github/`. CI already reads go.mod.
   - Don't change the `go` directive or any dependency, and don't run `go mod tidy` or `vendor` unless the build requires it. If it does, say why.
3. **Gates, with go1.27.4 first on a task-local PATH:**
   - Go: `~/.local/leorna-toolchain/go1.27.4/bin`
   - golangci-lint 2.14.0: `~/.local/leorna-tools/golangci-lint-2.14.0-linux-amd64/`
   - govulncheck v1.7.0: `~/.local/leorna-tools/bin/govulncheck`
   - Make: `~/.local/leorna-tools/make-4.4.1` if needed
   - Use a TMPDIR under `~/.cache/go-1.27.4-builder/`, and set `GOTOOLCHAIN=local`.

   Run, echoing the versions:
   - `make check`
   - `node --test scripts/*-ui.test.cjs`
   - `make lint audit`, which must now pass GO-2026-6859
   - `GOOS=windows go vet` with Zig cgo: `CGO_ENABLED=1 GOOS=windows CC='<zig under ~/.local/leorna-tools> cc -target x86_64-windows-gnu'`
   - gitleaks over `origin/main..HEAD`

   Also show the audit **failing** on main with go1.27.3. Write each gate's exit code to `~/.hermes/plans/leorna/evidence/go-1.27.4-client/gates.txt`.
4. **Commit** with plain `git commit`: `fix: upgrade Go toolchain to 1.27.4 (GO-2026-6859)`.
   - The author must be Justin Issa <justin@leorna.com>.
   - No AI attribution or Co-Authored-By lines.
   - Never override author metadata.
5. **PR text** in Christian's plain style, body only, written to `~/.hermes/cache/scratch/leorna-pr-go-1.27.4-client.md`. It has:
   - a one-paragraph Summary covering the advisory, why CI fails, and the one-line fix
   - the file list
   - a Test Plan naming the head and each gate's result
   - Assumptions: no card; the control plane did the same in #124; open client PRs (#33, #29) need a CI re-run after this merges.
6. **Push and open the PR** (`leorna` 7.6–7.7):
   - Push: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push https://github.com/LeornaAI/leorna-client.git feat/go-1.27.4-toolchain:refs/heads/feat/go-1.27.4-toolchain`
   - Fetch it back and set the upstream.
   - `gh pr create -R LeornaAI/leorna-client --base main --head feat/go-1.27.4-toolchain --title "Upgrade Go to 1.27.4 (GO-2026-6859)" --body-file <file>`
   - Read it back with `gh pr view <n> --json number,url,state,headRefOid,mergeable,mergeStateStatus`.
   - `git-guard.sh` will ask Justin to approve the push; he has authorized it.
7. **Wait for CI** with `gh pr checks`, up to about 25 minutes, using bounded long-wait polling. Report each check.
   - If a job fails while others are still running, read its log with `gh api repos/LeornaAI/leorna-client/actions/jobs/<job id>/logs --allow-escape-sequences`.
   - Don't fix anything else in this PR.

## Rules
- Never merge or force-push, and don't change `.github/`. Never print a token, a server domain or URL, or a tenant ID. Don't write to ClickUp.
- **Earlyoom:** a command that dies with exit 137 or 143, or "Killed", may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before you read it as pass or fail. If earlyoom killed it, rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`, quoting env assignments.
- **Long waits:** don't end your turn to wait. Use `cmd >log 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` with the Bash timeout at 175000.
- **skill_lessons:** don't edit skills or memory. List reusable lessons in `skill_lessons[{skill, lesson, evidence, enforce}]`, where `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status, branch, main_sha, commit, files[], gates[{name, exit, log}], audit_on_main_old{exit}, pr{number, url, head, state}, ci[{check, result}], found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
