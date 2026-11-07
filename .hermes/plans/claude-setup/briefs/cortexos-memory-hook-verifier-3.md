# VERIFIER: cortexos-memory-hook (claude-setup) — Mini pipeline, re-run after the pure rebase bd89a7e -> 0a7a5dc (second pure rebase)

Role: fresh VERIFIER, read-only on the source. You never saw the build, fixes or reviews' work. Edit nothing in the worktree, the
plan or $HOME; don't commit, push or sync; never write to CortexOS (read-only calls are fine). Write only in <evidence>/verifier/
(replace the earlier verifier files there; move them into verifier/superseded-bd89a7e/ (auto mode refuses rm)) and your own scratch.

Inputs:
- Approved plan (contract, read-only): ~/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md (includes the
  approved AC2 amendment; AC15 and AC16 are (live), owed to Justin).
- Worktree /home/justin/.claude-setup-wt/cortexos-memory-hook, head 0a7a5dc9f25931108948c291fe1485ccbc11b312.
- Base 462f57b49df0bcb7fe0f04fd72fdc2466f63bfa9 (= `git -C <worktree> merge-base HEAD main`; gitdir ~/.claude-setup.git).
Evidence: /home/justin/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/

## Skills (Skill tool), one line each
`engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline`. Follow
~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md exactly (VERIFIER role).

## Job
- Re-run the gates: the whole offline cortexos-memory suite and every suite AC14 names; tallies must match base (codex-parity's 3
  pre-existing failures included).
- For each AC1–AC14: run its named test by name on head and on base (base copy via `git clone -q ~/.claude-setup.git <scratch>/base &&
  git -C <scratch>/base checkout -q --detach <base>` with head's test files copied in; never `worktree add` against the setup repo),
  logs stamped `HEAD=<sha>`, a terminal-capture PNG per AC as its screenshot. ac-check proves only the one test each ac.json row cites:
  cite the test that covers every clause of that AC (AC2: ac2_search_request_scope_and_headers; AC3: ac3_search_sends_keywords_not_prompt).
  Before judging an AC, read `git log -p <base>..HEAD -- <its test files>` against the plan.
- AC15/AC16: `"accepted": false, "not_run": "live: <why>"`.
- Write verifier/ac.json in the format at the top of scripts/ac-check.sh; self-check blind as the doc says (copy to scratch, run
  ac-check.sh without --reviews, delete the copy).

## Environment
- Scratch: fresh `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-verifier-3/` (mkdir, no -p); big files in
  ~/.cache/cortexos-memory-hook-verifier-3/; remove both by literal path. Never copy real prompts/transcripts into evidence.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. uutils `timeout` rounds times up to 100 ms; don't time under it.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}],
verifier_ac_json, skill_lessons[]}`. `clean` needs every AC accepted, the (live) ones marked not_run aside.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
