---
name: control-plane-test-branch
description: "Local-only control-plane branch test/own-server-dev-signin (main + Yan's 3 installer/dev-sign-in fixes): all real-server testing goes through it (merge latest origin/main first); control-plane stories are built on a local/ work branch on top of it, and when done a clean feat/ branch is made from origin/main with only the story commits; never push test/ or local/"
metadata:
  node_type: memory
  type: project
  originSessionId: 5c5284b3-7db9-45f0-9917-75e10c4dea95
  modified: 2026-10-06T23:39:09.815Z
---

The branch is `test/own-server-dev-signin` in `~/Leorna/leorna-control-plane`. It exists only on Justin's Mac: no upstream, and it must **never be pushed**. It is what Justin's test control plane is installed from (see [[own-control-plane-install]]), because main's installer can't produce a server the desktop client can sign in to.

**Status 2026-10-12:** Yan's PR #81 merged into control-plane main on 2026-10-09 (`0ad43a3`). All three fixes are now on origin/main: the `dev/login` redirect in `client_auth.go`, the project-ID registry name, and `authenticated.go`. Per rule step 3 below, **don't use this branch any more**. Branch and install from main, and Justin can delete `test/own-server-dev-signin` (ask first). Whether the prebuilt ghcr image includes the fixes is unchecked; `LEORNA_IMAGE_SOURCE=local` from main is the safe choice.

## When an agent uses it
**Any agent that needs a real control-plane server to test against goes to this branch.** That covers live tests of client stories, reinstalling Justin's test server, deleting it, and reading the deployed server code.
1. Check it out.
2. Merge the latest origin/main into it (rule below).
3. Then install or test from it.
Don't test from main, or from a feature branch based on main, and don't create a new test branch. Control-plane stories are built on a `local/…` work branch on top of this one (see the section below), so they can be installed and tested too. **The branch always stays local:** never push it, never set an upstream, never open a PR from it.

## What's on it (2026-10-06)
Its base is origin/main `5ccbfdd`. On top are Yan's three commits, cherry-picked from her unmerged PR #81 (branch `feat/86bbu3xhc-bundle-content`). She stays the author.
- `4360329`, originally `53d6abd`, "support desktop approval in dev mode". In dev mode, `/client/login` redirects to `/dev/login?next=…`. Files: `internal/web/client_auth.go`, `cmd/control-plane/main.go`.
- `d2b94ac`, originally `f197abe`, "make Scaleway deployment project-safe". The registry namespace name includes the project ID. Files: `internal/installer/scaleway/registry.go`, `detect.go`, `internal/launcher/server.go`, `ui_installer.go`. Main's installer looks for the old name, so it can't find or delete this branch's registry.
- `5034ec6`, originally `c903a2e`, "authenticate local registry push". It runs docker login before pushing the image. Files: `internal/installer/image/authenticated.go`, `image.go`, `cmd/launcher/main.go`.

## Rule: update it from main before every use
Justin said on 2026-10-06 that any agent using this branch (install, teardown, or reading it as the server's code) must first bring in the latest main and fix merge conflicts. This standing OK covers a **local merge commit on this branch only**.
1. In the control-plane repo, run `git status`.
   - Leave the untracked `deploy/local/` alone.
   - If the current branch has uncommitted changes, stop and ask Justin. Never stash or discard his work.
   - Note which branch was checked out, so you can switch back afterwards.
2. Fetch main with `git fetch origin main`. If SSH fails, fetch over HTTPS through gh: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' fetch https://github.com/LeornaAI/leorna-control-plane.git main:refs/remotes/origin/main`
3. Check whether the fixes reached main. If PR #81 merged, or main has its own version of all three, **stop using this branch**.
   - Check with `gh pr view 81 --repo LeornaAI/leorna-control-plane --json state,mergedAt`.
   - Also check the code. For the dev sign-in fix: `git grep -n "dev/login" origin/main -- internal/web/client_auth.go`.
   - If all three are on main, install from main and tell Justin the branch can be deleted.
   - If only some are on main, the merge in step 4 takes main's version of those.
4. Merge: `git checkout test/own-server-dev-signin && git merge origin/main`.
   - Merge, don't rebase, so the cherry-picks keep their hashes.
   - Commit with plain `git commit` and the default merge message. No author override and no AI attribution.
5. Conflicts:
   - Keep main's new code **plus** what Yan's three fixes do.
   - Where main already has an equivalent fix, take main's version.
   - If a conflict is unclear, or touches anything beyond those fixes, stop and show Justin the conflict. Don't guess.
6. Verify before installing:
   - Run `go build ./...`.
   - Run `go test ./internal/web/... ./internal/installer/... ./internal/launcher/... ./cmd/...`. Use `make check` too if the Postgres test container is running (see [[leorna-control-plane-workflow]]).
   - After install, run the curl checks in [[own-control-plane-install]] step 7.
7. Report the new head, what conflicted and how it was resolved, and the test results.
   - **Never push and never open a PR.** The branch stays local.
   - Afterwards, switch back to the branch from step 1 if it was different. The launcher must run from this branch while it's installing or deleting.

## Control-plane story work: work branch on top, clean feat/ branch at the end
Justin's rule, 2026-10-06: a control-plane story is built on a **local work branch** that sits on top of the updated test branch, so it can be installed and tested on a real server. **When the story is done**, the agent creates the `feat/` branch from the latest main with only the story commits. The test-branch code is removed, and `feat/` is the only branch that is ever pushed.
1. **Start.**
   - Update the test branch from main (rule above, steps 1–6).
   - Then run `git checkout -b local/<clickupId>-<slug> test/own-server-dev-signin`.
   - `local/` means never pushed.
   - (Client-only stories still branch from client main. This applies to the control-plane repo.)
2. **Work on `local/…`.**
   - Install and test from it.
   - Story commits contain only the story's changes. Never edit Yan's three fixes or the test-branch merge commits inside a story commit; that's what keeps them separable.
   - If the story needs one of those fixes, say so in the PR as a dependency on Yan's PR #81. Don't copy the fix in.
3. **Need newer main mid-story?** Update the test branch (rule above), then run `git rebase test/own-server-dev-signin` on `local/…`. It replays only the story commits.
4. **Story done: create the clean `feat/` branch.**
   - Run `git fetch origin main`.
   - Run `git branch feat/<clickupId>-<slug> local/<clickupId>-<slug>`.
   - Run `git rebase --onto origin/main test/own-server-dev-signin feat/<clickupId>-<slug>`. This moves only the story commits onto the latest main.
   - **Check that nothing from the test branch is left:**
     - `git log --format='%h %an %s' origin/main..HEAD` must show only story commits: no YanXu cherry-picks (`fix(auth): support desktop approval in dev mode`, `fix(installer): make Scaleway deployment project-safe`, `fix(installer): authenticate local registry push`), and no "Merge … into test/own-server-dev-signin".
     - `git diff --stat origin/main...HEAD` must list only story files.
     - `git grep -n "dev/login" -- internal/web/client_auth.go` must match origin/main, not the test branch.
   - Conflicts during that rebase mean the story touched code that only exists on the test branch. Resolve against main's code. If that's unclear, stop and show Justin.
   - **Re-run the full gates on `feat/…`** (`make check` plus the story's tests). Main lacks Yan's fixes, so something that passed on `local/…` can fail here.
   - The team rule "branch from updated main" ([[leorna-control-plane-workflow]]) is met, because `feat/…` is based on the latest origin/main.
5. **Then follow the usual rules:** stop and show the diff, and push only `feat/…`, only when Justin says "push" ([[stop-and-show-diff]]).
   - **Never push `local/…` or the test branch.** CI's gitleaks scans every pushed ref, and a PR would carry Yan's unmerged code.
6. **After `feat/…` exists, review fixes go on `feat/…`.**
   - For a live retest, make a throwaway local branch: `git checkout -b tmp/<clickupId>-live test/own-server-dev-signin && git merge --no-edit feat/<…>`.
   - Install from it, then delete it with `git branch -D tmp/<clickupId>-live`.
   - Delete `local/…` once `feat/…` passes its gates, so there is only one copy of the story.
7. **When Yan's fixes reach main** (PR #81 merged; see step 3 of the rule above): skip all of this. Branch `feat/…` from main as usual, and tell Justin the test branch can be deleted.
