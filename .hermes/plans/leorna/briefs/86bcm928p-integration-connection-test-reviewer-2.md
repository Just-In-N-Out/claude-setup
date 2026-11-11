# REVIEWER brief, round 2 (full): 86bcm928p connection test for integrations

Role: REVIEWER, round 2, scope **full** (Full pipeline: round 2 reviews the whole story again). You are a fresh general-purpose agent (Opus 5.5, high effort) that never saw the build or an earlier review's work.

**Report only:**
- Change no source and commit nothing. Don't touch the worktree's files or index.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-2/`.
- Start no other agents.

## What to review
- Worktree: `/home/justin/Leorna/86bcm928p-integration-connection-test`, branch `feat/86bcm928p-integration-connection-test`.
- Range: `from` = story base `4ef14efb46da789aec30fad1e5a988d8770140e2`; `head` = `4818a8c1592f603384b24c01d97c883d15944069`. Check HEAD is that SHA before you start. Review `git diff 4ef14ef...4818a8c`: 6 commits.
- The latest commit `4818a8c` is a test-only fix after the blind auditor rejected AC1. AC1's test couldn't fail when an entered address was never looked up, dialled or certificate-checked (mutants X1, X1c, X1b). Check the fix really closes that, and that it didn't weaken any existing assertion.
- Approved plan (the ACs and their meaning; Justin's ⭐ answers Q1 A, Q2 A, Q3 A): `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/plan-approved.md`.
- Earlier records (read them, don't trust them):
  - `review-1/review.json`: round 1, clean, six P3s;
  - `auditor/REPORT.md` and `auditor/mutants/`: the AC1 finding;
  - `fixer-1/REPORT.md`, `fixer-1/mutation/`, `fixer-1/gates-4818a8c.txt`: the fixer's answer;
  - `builder/` (`REPORT.md`, `mutation/`).

  All are under `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/`. If a finding repeats a round-1 one, set `repeats` (and `new_fact` when you have one).

ACs:
- AC1: Given a configured integration, when I click Test, then reachability of the URL / MCP endpoint is checked and the result shown (without needing a user's credentials). Test: `TestIntegrationConnectionTestAC1ReachabilityWithPostgres`.
- AC2: Given a failure, then the message says what failed (DNS, TLS, unreachable, not an MCP endpoint). Test: `TestIntegrationConnectionTestAC2FailureMessagesWithPostgres`.
- No `(live)` ACs.

## Skills: load each with the Skill tool and say so in one line
1. `leorna`: the reviewer rules (report only; an AI review is never a human approval).
2. `engineering-best-practices`
3. `requesting-code-review`, then `code-review-practice`, with their security and quality checks. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer.
4. Specialists: `security-best-practices` (GO-SSRF-001, GO-HTTPCLIENT-001), `multi-tenant-auth-management`, `mutation-testing-discipline`.
5. Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties" and "Records") and the `review-fix-cadence` skill's severity scale.

## What to look for
- **SSRF and outbound safety** (the server fetches an admin-saved URL). Check:
  - non-public addresses refused before dialling;
  - one resolve, with the checked IP being the one dialled;
  - no redirects, no proxy from the environment;
  - time and size bounds;
  - no credentials or template headers sent;
  - nothing from a reply echoed unsafely.
- **Who can run a test:** admin-only, CSRF-protected, only the admin's own company's saved integration, the request can't name an address, and a limit of two concurrent tests.
- **Verdicts:** 401 passes ("asks for sign-in"); an `initialize` result is "Connected"; the rest is "Not an MCP endpoint". The four failure kinds must be classified correctly for **both** target kinds (an entered address and an MCP endpoint). Local-command servers show "Not tested".
- **No side effects:** a test changes no saved settings and writes no audit row.
- **The tests:**
  - Does each AC test check what its AC claims?
  - Can each one fail? Probe any clause no recorded mutant covers. Look especially for other "skip a step, still report success" paths per target kind.
  - Do the tests stay off the real internet?
- **Records:** READMEs, `delivery/stories.json` (main's entries unchanged by value, this story's last), and no `.github/`, contract or migration change.
- **Probing:** run tests read-only, with `go test -overlay` or a detached scratch copy (`git -C <wt> archive 4818a8c | tar -x -C ~/.cache/86bcm928p-review-2/…`), never by editing the worktree.
  - Postgres: the containers `928p-builder-pg` and `928p-builder-ch` are running. Settings are in `~/.cache/86bcm928p-builder/env.sh` and its pg env file (0600; never print the password). Use your **own** `_test` database name, and drop it when done.
  - Toolchain: `~/.local/leorna-toolchain`.
  - Scratch: your own fresh `~/.cache/86bcm928p-review-2/` (`mkdir` without `-p`), never `/tmp`.

## Severity: Justin's scale
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included; anything that breaks an AC or the UI; or a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of Justin's machines has.

Every P0–P2 needs a concrete real-use `scenario` of 5+ words (who does what, and what goes wrong). Without one, the referee counts it as P3.

## Your outputs
1. Write `/home/justin/.hermes/plans/leorna/evidence/86bcm928p/review-2/review.json` in the format in `review-loop.md`:
   - `round: 2`, `scope: "full"`, `from: "4ef14efb46da789aec30fad1e5a988d8770140e2"`, `head: "4818a8c1592f603384b24c01d97c883d15944069"`;
   - `findings[]` with ids `R2-<k>`, each with `severity`, `file_line`, `claim` and `scenario` (plus `repeats` / `new_fact` where they apply). Use an empty list when clean.
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
- Another bug outside this story goes in `found_else` (one line each, with evidence and severity). Don't fold it in.
- If you learn something reusable, don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill or `memory`. `enforce` is `none`, or, for a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls of under 3 minutes each.
- End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
