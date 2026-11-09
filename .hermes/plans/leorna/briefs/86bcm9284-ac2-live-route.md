# Brief: 86bcm9284 AC2 live-route runner

**Role:** LIVE-CHECK RUNNER for Leorna card 86bcm9284 ("Predefined integration tiles: GitHub, Google Workspace, ClickUp"). You change no story source, commit nothing, push nothing and write nothing to ClickUp tasks. Justin, 2026-11-08: "For the AC that we did not run just figure it out and run test in order for it to work." Your job is to find a way to run AC2's live part with what is already on this desktop, run it once, and leave a runbook and script the verifier and the blind auditor can each re-run on their own.

**AC2 (live):** Given a predefined tile, when an admin enables it, then engineers connect with their own sign-in and a working MCP config syncs to their tools. The agent-side half is already proven: `TestPredefinedTilesAC2EnableAndSyncWithPostgres`, plus a real headless client Sync into a scratch HOME. What's owed is the live part: each tool, using the synced config, really connects to the real MCP server with an engineer's own sign-in and makes **one read-only call**. That covers GitHub (github.com variant) and ClickUp, in Claude Code and Codex, plus Cursor if feasible. Google's part is deferred by approved Q3 A, so don't attempt it.

## Read first
- Approved plan: `~/.hermes/plans/leorna/evidence/86bcm9284/plan-approved.md` (AC2, Q2 A, Q4 A, Q7 A and the vetting table).
- The builder's live kit: `~/.hermes/plans/leorna/evidence/86bcm9284/ac2-live.md`, `ac2-live/prepare.sh`, `ac2-live/synced/`, and `ac2-sync/run.sh` (the headless Sync driver).
- Memory: `~/.claude/projects/-home-justin-Leorna/memory/cursor-cli-on-desktop.md` (cursor-agent at `~/.local/bin/cursor-agent`; even `--version` writes `~/.config/cursor`, so isolate HOME and XDG), `codex-cli-offline-checks.md`, `claude-code-headless-agent-runs.md`, and `leorna-control-plane-workflow.md`.
- Story worktree (read-only): `/home/justin/Leorna/86bcm9284-predefined-integration-tiles`. A fixer is merging main into it right now: don't touch it, and read files via `git show beb5358:<path>`. The tile content (`internal/integration/tiles/*.json`) is the same either way.

## Skills to load
`leorna` (hard rules; the "Live acceptance setup" section, including step 6 on storage preflight and step 7), `engineering-best-practices`, `security-best-practices`.

## Credential and safety rules (hard)
- **GitHub:** the engineer's own token is Justin's existing `gh` login (active account `Justin-Leorna`). You may obtain it at run time with `gh auth token` and pass it **only** as `GITHUB_PERSONAL_ACCESS_TOKEN` in the environment of the tool process, inside a scratch HOME. Never print it, log it, echo it, write it to a file, or put it on a command line (pass it through the environment of a script: `GITHUB_PERSONAL_ACCESS_TOKEN="$(gh auth token)" <cmd>` inside the script, so the token isn't in the logged command). Make read-only calls only, such as `get_me` or reading a public or LeornaAI repo's metadata. No writes, issues, comments or PRs. Mask any token-shaped string in every saved log, and gitleaks-scan the folder at the end.
- **ClickUp:** OAuth, done by each tool. Never copy, export, read or symlink any credential store (Claude's credentials file, keyrings, Codex auth files). Allowed:
  - (a) Claude Code with the real HOME, where approved Q7 A lets the ClickUp sign-in live in Justin's real `~/.claude`. Claude Code already has a user-scope `clickup` MCP server signed in as Justin. Check, without reading any secret, whether a scratch project's synced `.mcp.json` (the tile's ClickUp server) connects using Claude Code's own supported OAuth flow and storage, e.g. `claude mcp list` / `claude -p` with `--mcp-config` in a scratch project dir, read-only call such as listing workspaces.
  - (b) A tool's own login command, if it needs a browser click by a human: prepare everything and report it as one exact action for Justin, instead of faking it.
  - Don't change Justin's real `~/.claude.json` MCP server list or real `~/.codex/config.toml`. Use `--mcp-config`, scratch project dirs and a scratch `CODEX_HOME`. If something unavoidably writes into a real tool home, record exactly what, and the cleanup step.
- **Cursor:** `cursor-agent` needs its own login. Only use it if it already works under an isolated HOME/XDG without a human. Otherwise mark it NOT VERIFIED with the reason.
- No auth bypass, no fake servers presented as live, no dev-login stubs. A recorded or mocked response doesn't count as the live check.
- Don't send a server domain, tenant ID, token or email into any log you keep. Public MCP endpoint URLs are fine.

## Do
1. Make a fresh scratch folder `~/.cache/86bcm9284-ac2-live/` (with `mkdir`, not `-p`; never `/tmp`).
2. Using the synced files from the builder's real client Sync (`ac2-live/synced/`, or regenerate them with `ac2-sync/run.sh` into your scratch), run per tool × service:
   - GitHub: Claude Code (`claude -p` with `--mcp-config <synced .mcp.json>` in a scratch project, or `claude mcp list` health), and Codex (scratch `CODEX_HOME` with the synced `config.toml`, `codex mcp list`, then a real tool call through `codex exec` with a probe home, per the memory note). The call must reach GitHub's hosted MCP server and return data, e.g. the authenticated user's login. Show only that the login is non-empty or that it equals `Justin-Leorna`; no email.
   - ClickUp: the same tools, via route (a) or (b) above.
   - Cursor: if feasible.
3. Each run writes a log with `HEAD=<story head it used>`, the exact command (token masked), the output, and `EXIT=`. Plus one screenshot per run (a terminal-style `<pre>` capture via the repo's chromedp overlay driver or Chrome for Testing, per `ac-verification.md`), checked for secrets.
4. Write a **runbook** `~/.hermes/plans/leorna/evidence/86bcm9284/ac2-live-route/runbook.md` and a script `run-ac2-live.sh`. The script takes the story head and an output folder, and from the synced files does every check that worked, printing one numbered TAP line per check (`ok N - ac2-live github claude-code`, …) and a final `EXIT=`. A verifier and an auditor must each be able to run it unattended into their own folder.
   - Keep your own run's receipts in `~/.hermes/plans/leorna/evidence/86bcm9284/ac2-live-route/run-1/`.
   - The runbook gives the method only, not your results, so the auditor stays blind.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Remove your scratch folder at the end.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
Per tool × service: ran live / blocked, with the reason and receipt paths. What, if anything, still needs Justin (the exact one action). Anything written to a real tool home, with its cleanup. The runbook and script paths. A `verdict` (`live-proven` / `partly` / `blocked`) and `ac_status` for AC2. skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
