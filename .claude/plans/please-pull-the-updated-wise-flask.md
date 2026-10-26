# Pull updated `main` — leorna-control-plane

## Context
Justin wants the local control-plane checkout updated to the latest `origin/main`.

Current state (checked read-only):
- On `main`, last synced at `0ad43a3` (Merge PR #81), no local commits, no stashes.
- Only local change: untracked `deploy/local/` (5 files from Sep 18). Pull won't touch it.
  If the new main happens to add files at the same paths, git refuses and changes nothing.
- A read-only `git ls-remote` failed with `Permission denied (publickey)`. The SSH config
  (`github-leorna` → `~/.ssh/id_ed25519_leorna`) looks right and the ssh-agent is empty. So the
  key probably needs a passphrase, or the sandbox is blocking SSH.

## Steps
1. `git pull --ff-only origin main`. `--ff-only` means it only moves forward and never creates
   a merge commit.
2. If SSH fails again, retry once outside the sandbox.
3. If it still fails, the key likely needs a passphrase. Ask Justin to run
   `! git pull --ff-only origin main` so he can type it.
4. If git refuses because of `deploy/local/` paths, stop and show the clashing files. Don't move or
   delete anything without asking.

## Verification
- `git status --short --branch` shows `main...origin/main` with nothing ahead or behind.
- `git log --oneline 0ad43a3..HEAD` lists the new commits/PRs pulled in. Report them in one short list.
- `deploy/local/` is still there, untracked.

No pushes, no branch changes and no edits.
