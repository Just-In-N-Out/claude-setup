# AC AUDITOR brief: 86bcm928t integration governance and usage

Role: blind AC AUDITOR. You are a fresh general-purpose agent (Opus 5.5, high effort).
**Source is read-only.**
- Change no repo file and commit nothing.
- Write only into `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/auditor/`.
- Start no other agents.
- You get only what is below. Don't open any other folder under `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/`, or any brief or report of other roles. Prove every AC yourself.

## Inputs
- Approved plan (the ACs, their tests and what each means): `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/plan-approved.md`.
- Worktree: `/home/justin/Leorna/86bcm928t-integration-governance-usage`.
- Head: `9276c33966aea25c8227ca3efe56a1bdb203012e`. Check that HEAD is that SHA and the worktree is clean.
- Base (`git merge-base HEAD origin/main`): `f0a326b83aae9d181e4f6681645685ae4b1fff91`.
- Your folder: `/home/justin/.hermes/plans/leorna/evidence/86bcm928t/auditor/`.

## Skills: load each with the Skill tool and say so in one line
1. `leorna`: Postgres test rules and the WSL host notes in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/leorna-control-plane-workflow.md` (toolchain, Chrome for Testing flags, admin-page capture, ClickHouse container).
2. `engineering-best-practices`

Read `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` in full. It has the run recipe, the head and base log formats, `base_exempt`, the `ac.json` format and the screenshot rules.

## Do
- **For every AC in the plan:**
  - Run its own named test on head from the worktree, with `HEAD=` and `EXIT=` log lines.
  - Run it on base in your own separate copy with head's test files.
  - Read its assertions against the AC text: `git log -p <base>..HEAD -- <test files>`.
  - Take one screenshot per AC from your own run into your folder.
  - Write `auditor/ac.json`.
- **An AC whose test passes on base** gets `base_exempt` with a 3+ word reason, only if the plan says so. Back it with guard mutants you run yourself (`go test -overlay`, read-only), each killed on the AC test's own assertion.
- **Toolchain:** Go 1.27.3 at `~/.local/leorna-toolchain/go/bin`, on a task-local PATH only.
- **Databases.** Find a running Postgres test container yourself (`docker ps`), or start your own with CI's pinned image (`--rm`, a memory cap, the password in a 0600 file, never on a command line). Likewise ClickHouse if a test needs `LEORNA_TEST_CLICKHOUSE_URL`.
  - Use your own `_test` database and drop it afterwards.
  - Never touch `leorna-pg` or `leorna-test-pg`.
  - Stop any container you started.
- **Screenshots:** look at every PNG before citing it. No domain, URL bar, tenant ID, token or email may be visible; redact UUIDs on a page that shows them, and say so on the image.
- **Load:** don't run your AC or mutant tests at the same time as any other heavy run of yours. Load on this machine makes timing tests flaky.

## Windows desktop: runaway memory
A command that dies with SIGTERM, exit 143 or 137, or "Killed" may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as a result. Run mutants and heavy checks under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Report
- Return:
  - `verdict` (`clean` only if every AC is accepted)
  - `ac_status[{ac, status: accepted|not_accepted|not_run, evidence}]`
  - the path of `auditor/ac.json`
  - `found_else[]`
  - `skill_lessons[]`
- If you find another bug, don't fold it in: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable, don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill or `memory`.
  - `enforce` is `none`, or a one-line proposal for a check that would have caught a broken rule: kind, what it checks, where it runs.
  - An empty list is normal.
- Don't end your turn to wait for a background command. Wait in the foreground with bounded polls under 3 minutes each.
- Clean up your scratch (on the real disk at `~/.cache/86bcm928t-auditor/`, not `/tmp`). End with `MAIN SESSION: check and save these skill_lessons now.`
