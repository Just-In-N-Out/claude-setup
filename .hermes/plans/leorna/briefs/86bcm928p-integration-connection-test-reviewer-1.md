# REVIEWER brief, round 1 (full): 86bcm928p connection test for integrations

Role: REVIEWER, round 1, scope **full**. You are a fresh general-purpose agent (Fable 5.2, high effort) that never saw the build.

**Report only:**
- Change no source and commit nothing. Don't touch the worktree's files or index.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-1/`.
- Start no other agents.

## What to review
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`.
- Range: `from` = story base `4ef14efb46da789aec30fad1e5a988d8770140e2`; `head` = `9da16b86ca2607a1242b745019fa23cf893a02df`. Check HEAD is that SHA before you start. Review `git diff 4ef14ef...9da16b8`: 5 commits, 15 files.
- Approved plan (the ACs and their meaning, plus Justin's ⭐ answers Q1 A, Q2 A, Q3 A): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`.
- Builder evidence (read it, don't trust it): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/builder/` (with `REPORT.md`, the builder's hand-back), plus the 8 PNGs in the evidence root.

ACs:
- AC1: Given a configured integration, when I click Test, then reachability of the URL / MCP endpoint is checked and the result shown (without needing a user's credentials). Test: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres`.
- AC2: Given a failure, then the message says what failed (DNS, TLS, unreachable, not an MCP endpoint). Test: `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`.
- No `(live)` ACs.

Builder's ruling R1 (not yet confirmed): `internal/web/README.md` says "503 when no tester is wired or the saved settings cannot be read". Check it is true and changes no AC.

## Skills: load each with the Skill tool and say so in one line
1. `leorna`: the reviewer rules (report only; an AI review is never a human approval).
2. `engineering-best-practices`
3. `requesting-code-review`, then `code-review-practice`, with their security and quality checks. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer.
4. Specialists: `security-best-practices` (GO-SSRF-001, GO-HTTPCLIENT-001), `multi-tenant-auth-management`, `mutation-testing-discipline` (for your own mutation checks).
5. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties" and "Records") and the `review-fix-cadence` skill's severity scale.

## What to look for
- **SSRF and outbound safety** (the server fetches an admin-saved URL). Check:
  - non-public addresses are refused before dialling: private, loopback, link-local, metadata, IPv6 site-local, IPv4-mapped IPv6;
  - DNS rebinding: the name is resolved once and the checked IP is the one dialled;
  - redirects are never followed; there's no proxy from the environment; timeouts and the reply size cap are enforced;
  - no `Authorization`, cookie, credential reference or template header is sent; nothing from a reply is echoed unsafely into the page.
  Look for any path that bypasses `domain.PublicAddress`.
- **Who can run a test:** admin-only, CSRF-protected, and only for the admin's own company's saved integration. Check for no cross-tenant read or test, and that the request can't name an address (the form carries only the CSRF token). Check the concurrency limit of two tests (the third gets 429).
- **The probe's verdicts:** a 401 counts as a pass ("asks for sign-in"); a valid `initialize` result (JSON or event stream) is "Connected"; every other status or body is "Not an MCP endpoint". The four failure kinds must be classified correctly and must not bleed into each other; also check timeouts, a TLS name mismatch and an expired certificate. Check that local-command servers show "Not tested".
- **No side effects:** a test changes no saved settings and writes no audit row (per the plan).
- **The tests:**
  - Does each AC test check what its AC claims?
  - Can each one fail? The builder's 19 mutants are in `builder/mutation/`. Read them, and probe any clause no mutant covers.
  - Do the tests stay off the real internet (fake resolver and dialer)?
- **The builder's found_else** (the `?variant=` query re-rendering a different variant's form under the result): judge its severity yourself.
- **Records:** the READMEs, `delivery/stories.json` (main's entries unchanged by value, this story's appended last), and no `.github/`, contract or migration change.
- **Probing:** run tests read-only, with `go test -overlay` or a detached scratch copy (`git -C <wt> archive 9da16b8 | tar -x -C ~/.cache/86bcm928p-review-1/…`), never by editing the worktree.
  - Postgres: the builder's containers `928p-builder-pg` and `928p-builder-ch` are running. Connection settings are in `~/.cache/86bcm928p-builder/env.sh` (and its pg env file, 0600; never print the password). Use your **own** `_test` database name, never the builder's, and drop it when done.
  - Toolchain: `~/.local/leorna-toolchain` (Go, golangci-lint, govulncheck) on a task-local PATH.
  - Keep scratch in your own fresh `~/.cache/86bcm928p-review-1/` (create it with `mkdir` without `-p`), never the shared `/tmp`.

## Severity: Justin's scale
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included; anything that breaks an AC or the UI; or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.

Every P0–P2 needs a concrete real-use `scenario` of 5+ words (who does what, and what goes wrong). Without one, the referee counts it as P3.

## Your outputs
1. Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-1/review.json` in the format in `review-loop.md`:
   - `round: 1`, `scope: "full"`, `from: "4ef14efb46da789aec30fad1e5a988d8770140e2"`, `head: "9da16b86ca2607a1242b745019fa23cf893a02df"`;
   - `findings[]` with ids `R1-<k>`, each with `severity`, `file_line`, `claim` and `scenario`. Use an empty list when clean.
   Probe scripts and logs may go in the same folder. Don't write a prose report file there: return the summary in your report.
2. Self-check: run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm928p-integration-connection-test --base 4ef14efb46da789aec30fad1e5a988d8770140e2 /home/justin/.hermes/plans/leorna/evidence/86bcm928p`. Exit 2 means your file is wrong: fix it. Exits 0, 1 and 3 are the referee's verdict; don't act on them.
3. Return a report with:
   - `verdict` (`clean` or `changes_requested`);
   - the findings, each with evidence;
   - `ac_status[{ac, accepted, test, screenshot, evidence}]` for AC1–AC2;
   - `found_else[]`;
   - `skill_lessons[]`.

## Windows desktop: runaway memory
A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result. Run mutants and heavy checks under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Rules
- If you find another bug outside this story, don't fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable, don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill or `memory`. `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls of under 3 minutes each.
- End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
