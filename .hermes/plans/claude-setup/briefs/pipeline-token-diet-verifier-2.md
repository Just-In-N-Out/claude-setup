# Brief: VERIFIER 2, story `pipeline-token-diet` (Full pipeline)

## Role
You are the fresh, **read-only verifier** for Justin's setup story `pipeline-token-diet`. You never saw the build.
- You re-run the gates, confirm the review loop closed, and prove every acceptance criterion (AC) with receipts, on the new code and on the old code.
- Change no source, make no commit, start no agents.
- Never write the live `~/.claude`, `~/.hermes/skills`, `~/.codex`, `~/Documents/FigmaToBricksV2`, global git config, `~/.claude-setup.git` refs or GitHub.
- Write only into your own folder, `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/verifier/` (new and empty), and your scratch folder.

## Skills to load first
- `engineering-best-practices`
- `mutation-testing-discipline`: use it to check that a test exercises every clause of its AC.

Read and follow `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the live one: this story runs on today's gate scripts until it is merged). It covers the run recipe, the base-commit check, screenshots, the `ac.json` format and the self-check. Also read the header of the live `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, which defines the exact `ac.json` format.

## What to verify
- **Worktree:** `/home/justin/.claude-setup-wt/pipeline-token-diet`, branch `pipeline-token-diet`, a linked worktree of the setup repo `~/.claude-setup.git`, whose main work tree is `$HOME`.
- **Head:** `c887b3b4ed19c9198cc0316f2c860f215c672ff0`.
- **Base:** `git -C <worktree> merge-base HEAD main`, which should be `b5927606c8a0b9de1e62d4565b4a74d1c43e49b1`. Record what it prints.
- **This head is the story rebased onto a newer `main`** (one conflict resolution in `references/review-loop.md`, reviewed in round 3). Earlier verifier and auditor folders were moved aside to `round1-verifier/` and `round1-auditor/`: don't open or use them. Where the plan names an older base commit, the base above is the one that counts.
- **Before you start,** confirm HEAD equals `c887b3b4` and that `git status --porcelain --untracked-files=all` is empty (the repo has `status.showUntrackedFiles=no`). If either check fails, stop and report it.
- **Approved plan:** `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/plan-approved.md` (read-only). Read its "Amendments", "Justin's answers", "The chosen set", "Acceptance criteria", "Where the rules are stated" and task 0; the analysis sections are background.
- **ACs:** AC1–AC6, one named test each (paths under `.hermes/skills/autonomous-ai-agents/feature-dispatch/`; each prints numbered TAP; run one with `bash <file> <test_name>`):
  - AC1 `routing_text_agrees` in `scripts/pipeline-rules.test.sh`;
  - AC2 `p2_only_from_round_3_asks_justin` and AC3 `pure_rebase_receipt_accepts_earlier_reports` in `scripts/review-check.test.sh`;
  - AC4 `token_report_fixture` in `scripts/token-report/token-report.test.sh`;
  - AC5 `existing_suites_pass` in `scripts/pipeline-rules.test.sh`: runs only when named and needs `PIPELINE_RULES_BASE=<folder of base tallies>`. Make **your own** base tallies the way the plan's task 0 says, in your own folder; don't reuse the builder's. It is a regression AC: if it rightly passes on base, give it a `base_exempt` reason;
  - AC6 is `(live)`: `"accepted": false, "not_run": "live: …"`.

## The work
1. **Gates on head**, all under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`: `review-check.test.sh`, `ac-check.test.sh`, `pipeline-rules.test.sh`, `token-report.test.sh`, plain and as `PATH=/usr/bin:/bin /bin/bash`; and the named run `ac11_ac_check_existing_cases_pass` with `REVIEW_LOOP_BASE=b5927606`. Two reviewers and the fixer reported that under the minimal PATH `existing_suites_pass` fails in codex-parity only because `codex` and `gitleaks` are not on that PATH, the same on the base: check that yourself and report what you see.
2. **The review loop closed:** run the live referee on the story's records and confirm the last line is `MOVE ON` at `c887b3b`:
   `bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/.claude-setup-wt/pipeline-token-diet --base <base> ~/.hermes/plans/claude-setup/evidence/pipeline-token-diet`
3. **Prove each AC** per `ac-verification.md`:
   - a log of its own test on head (`HEAD=` first line, `EXIT=` last line);
   - the same test on the base commit in a separate detached copy with head's test file, where it must fail (or carry a `base_exempt` reason);
   - one PNG terminal capture per AC;
   - for any clause the test seems not to exercise, a mutation in your own copy. AC1 says every role has the same model and effort in every file that states the rules: read the rule files against the routing table in the plan's "The chosen set" yourself, don't rely on the test alone.
4. **Write the report** to `verifier/ac.json` in the `ac-check.sh` format. Self-check it blind, as `ac-verification.md` says: `cp` your files to a scratch folder and run the live `ac-check.sh` on your report and the copy. Then delete the copy.

## Scratch and the desktop
- Scratch, `TMPDIR`, Chrome profiles and anything large in `~/.cache/pipeline-token-diet-verifier2/` (`/tmp` is a shared RAM tmpfs).
- **Memory runaways:** a command that dies with `signal: 'SIGTERM'`, exit 143 or 137, or "Killed" may be an earlyoom kill, not a test result. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` first; if earlyoom killed it, say so, find what grew, and rerun under the cap, never bare.
- **Gotchas:** in the Bash tool `grep` is ugrep: use `/usr/bin/grep` (inside `xargs`, `find -exec` or `systemd-run`, `command grep` does not work). Headless Chrome needs `env -u DISPLAY -u WAYLAND_DISPLAY` and `--disable-software-rasterizer`. Never `pkill -f`. `tail -n N`.

## Output (final message)
- `verdict`: `clean` only when every non-live AC is accepted, the gates pass and the referee says MOVE ON at head. Otherwise `not-clean`.
- `ac_status[{ac, accepted, test, log, base_log or base_exempt, screenshot, evidence}]`, the same as `ac.json`.
- `findings[{id, severity, file_line, scenario, problem, evidence}]`. Every P0–P2 finding must name a concrete real-use scenario; without one, it is P3.
- `found_else[]`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: reusable lessons only; `enforce` is `none` or a one-line check proposal. An empty list is normal. Never edit skills or memory.

End with the line `MAIN SESSION: check and save these skill_lessons now.`
