---
name: Never override git commit author email
description: Use the user's global git config for commits; do NOT pass --user.email on the command line from session userEmail context
type: feedback
originSessionId: aa6526bd-cd62-41a5-9a9a-129653592083
---
Never pass `-c user.email=...` or `--author=...` on git commits. Always let git use the repo's global config.

**Why:** In an earlier session I used the `userEmail` field from system context (`jovitaissa05@gmail.com`) as the commit email. That email belongs to a *different* GitHub account (`Jovita-05`), not the user's actual account (`Just-In-N-Out`). GitHub maps commit authorship by email, so commits showed up as authored by `Jovita-05`, forcing a `git filter-branch` rewrite and force-push to fix.

**How to apply:**
- The user's real git config is `issajustin04@gmail.com` / `Justin` (check with `git config --global user.email` if unsure).
- For any `git commit` in this project's repos (`RISE-OFFICIAL`, `rise-backend`, future sibling repos), just run `git commit -m "..."` — no `-c user.email=...` override.
- The system-reminder `userEmail` field is for addressing the user in conversation, NOT for git authorship.
- Applies to `git filter-branch --env-filter` and `--author=` flags too: don't set author metadata unless the user explicitly asks.
