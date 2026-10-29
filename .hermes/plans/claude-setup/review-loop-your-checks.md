# review-loop: your one live check (AC18, the Mac)

The story is merged into the setup repo and pushed. On the Mac:
1. `~/.claude/setup/sync.sh pull` (a new session also does it).
2. Run both test suites with the Mac's own old bash and BSD tools first on PATH:
   ```
   cd ~ && env PATH="/bin:/usr/bin:$PATH" /bin/bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh ac18_mac_suites_live
   ```
   The test prints what it runs. It should end with `ok`.
3. If the pure-rebase cases exit 2, check `/usr/bin/git --version`: `patch-id --verbatim` needs git 2.39 or newer.

Also still owed from harness-guards: `harness-guards-your-checks.md` (AC21 desktop, AC22 Mac).
