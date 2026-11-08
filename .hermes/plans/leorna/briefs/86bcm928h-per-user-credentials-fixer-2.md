# FIXER brief, round 2: Leorna story 86bcm928h-per-user-credentials

**Role:** FIXER for review round 2. You are a fresh agent: Opus 5.5, effort high.

Every rule in the round-1 fixer brief applies to you too: `~/.hermes/plans/leorna/briefs/86bcm928h-per-user-credentials-fixer-1.md`. Read it first. That covers the skills, the security properties the fix must keep, `blocked-plan` when a fix needs a design the plan doesn't allow, proving the real default program on Windows, commits and authorship, no push/PR/post, gates and evidence, mutation runs under the 4G cap, earlyoom and long waits, found_else and skill_lessons, and the return schema. It is overridden only where this file says something different:

- **Reviewed head:** `0e9659624f6577f6a575303337270d7512c64ded`. Base `7a834434d00ec7afae8464f5e7ce6cc17881bb7b`. Don't rebase.
- **Earlier records:**
  - round 1: `review-1/`, `fixer-1-report.md`
  - round 2: `review-2/review.json`, `review-2/report.md`
- **TMPDIR:** `~/.cache/86bcm928h-fixer-2/tmp`.

## The referee's lines (verbatim). Fix the P2
```
R2-1  P2  application/open_tool_windows.go:69  The new launcher finds Claude Code and Codex only at three hard-coded places: %USERPROFILE%\.local\bin\claude.exe, and the default npm prefix %APPDATA%\npm for both. A tool installed any other way is never found: npm with another global prefix (nvm-windows puts global packages under its NVM_SYMLINK folder; Volta, scoop, fnm and `npm config set prefix` do the same), Claude Code from WinGet, or Codex from its standalone installer. The engineer then sees only 'could not open Codex', because OpenTool (open_tool.go:96) replaces the starter's reason ('the tool is not installed where Leorna looks for it') with a generic one, and the Open button shows whether or not the tool can be found. For engineers whose PowerShell policy is RemoteSigned, this is a regression from e11872f: the old PowerShell route found codex.ps1 on PATH, wherever npm put it.
R2-2  P3  application/open_tool_windows.go:90  Codex is started with CODEX_MANAGED_BY_NPM=1 but without CODEX_MANAGED_PACKAGE_ROOT. codex.js 0.164 sets both (bin/codex.js:232-238), and codex.exe's installation check then reports 'npm-managed launch is missing package-root provenance. Reinstall or update Codex so the JS shim provides CODEX_MANAGED_PACKAGE_ROOT.' The code comment says codex.js sets only the first.
R2-3  P3  application/open_tool_windows_test.go:122  Nothing that CI runs pins the Codex platform package and target triple. Both CI-run Windows tests build their expected paths from codexPlatform() itself (codexTarget at :122 and :211), so a wrong package or triple name passes them. Only the opt-in LEORNA_TEST_REAL_TOOLS=1 test catches it, and CI never sets that.
R2-4  P3  application/open_tool_windows.go:48  The Codex build is picked by runtime.GOARCH, which is Leorna's own build architecture, not the machine's. Leorna ships amd64 only. On ARM64 Windows with native arm64 Node, npm installs @openai/codex-win32-arm64, while x64 Leorna (running emulated) looks only for codex-win32-x64, so Open Codex fails.
R2-5  P3  application/open_tool_windows.go:144  Without PowerShell's -NoExit, the new console closes as soon as the tool exits. If Claude Code or Codex prints an error at start (no Git for Windows, a bad config, a failed update), the window flashes and vanishes, and Leorna still says 'Opened Claude Code. It can use your GitHub sign-in.'
R2-6  P3  cmd/leorna-client/frontend/dist/integrations.js:48  The R1-3 fix holds: busy is always cleared. But act() still drops its own result when a reload landed during the action. If that reload's Integrations() call took the service lock before the action did (its catalog fetch finished first), the panel shows the earlier state, for example 'Not connected' with the token form after a successful Save token, and the action's message is replaced by the generic one.
REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at 0e96596: fix them, then review the fix commits
```
R2-2 to R2-6 are P3 and go to follow-ups. Leave them unless the R2-1 fix naturally covers them; if one does, say so. R2-2 (the missing `CODEX_MANAGED_PACKAGE_ROOT`) and R2-3 (pinning the platform package and triple) sit right next to the R2-1 change. You may fold them in only if it costs a few lines and a test each.

## Constraints for R2-1
- Keep the absolute-`.exe` rule: no PATH lookup, no `.cmd`/`.bat`/`.ps1`, no PowerShell, and no execution-policy change.
- **Don't run npm, or any shim, to discover its prefix.** Running `npm.cmd` would break the plan's no-`.cmd` rule. Find extra candidate locations without executing anything. Some possible sources:
  - npm's own config files (`%USERPROFILE%\.npmrc` `prefix=`, and the global npmrc)
  - `NVM_SYMLINK` / `NVM_HOME`
  - Volta's and scoop's documented shim/package folders
  - WinGet's and Codex's standalone install locations, where they are documented and verifiable
  - Each candidate must still be an absolute `.exe` that `os.Stat` confirms at each Start.
  - **Only add locations you can cite** from the tool's docs or the installed files on this machine. Don't guess layouts.
- **The engineer must be told why** when the tool isn't found: keep the starter's "not installed where Leorna looks for it" reason in OpenTool's message, naming the places looked. Show paths only in a form that can't leak a secret (no tokens; user paths are fine on the engineer's own screen).
- **If a correct fix needs a decision the plan doesn't cover, stop with `status: blocked-plan`** with lettered options and a recommendation. Examples: a user-set "path to the tool" setting, or reading another tool's config. Justin decides those.
- **Test first:**
  - a failing Windows test per added location source (an `.npmrc` prefix, `NVM_SYMLINK`, …), using temp folders, never the real install paths
  - a test that the message names the reason
  - mutants for the new resolution guards, under the 4G cap
- **Re-render** AC6's screenshot and log at the new head if its tests changed. Write a gates log `gates-<sha7>.txt` on the final head with every gate from the round-1 brief, including the native Windows tests.

## Return
Same schema as round 1. Use `status: ready-for-next-review` or `blocked-plan`. End with `MAIN SESSION: check and save these skill_lessons now.`
