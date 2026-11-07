# AC AUDITOR (blind): cortexos-memory-hook (claude-setup)

Role: fresh AC AUDITOR, read-only on the source. Prove every AC yourself. You get only the inputs below: never open the evidence
folder's other subfolders (verifier/, review-*/, fixer-*/, red/, head/, captures/, mutation/) or any brief or report.
Edit nothing in the worktree, plan or $HOME; don't commit, push or sync; never write to CortexOS (read-only calls are fine).

Inputs:
- Approved plan (contract, read-only): /home/justin/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/plan-approved.md
  (AC15 and AC16 are (live), owed to Justin).
- Worktree: /home/justin/.claude-setup-wt/cortexos-memory-hook
- Head: 6b8860715c6e3f2cb9b48240dbaefc287402a4a2
- Base: dd80ac4a38c74caf156b9e786f299471cf6c513b (setup repo gitdir ~/.claude-setup.git; run its git with `-C <worktree>` or `:/` paths)
- Your folder: /home/justin/.hermes/plans/claude-setup/evidence/cortexos-memory-hook/auditor/ (write auditor/ac.json and your logs/PNGs here)

## Skills (Skill tool), one line each
`engineering-best-practices`, `mutation-testing-discipline`. Follow
~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md exactly (AC AUDITOR role).

## Job
For each AC1–AC14: run its named test by name on head and on base (base copy via `git clone -q ~/.claude-setup.git <scratch>/base &&
git -C <scratch>/base checkout -q --detach <base>`, head's test files copied in; never `worktree add` against the setup repo), logs
whose first line is `HEAD=<sha>`, one terminal-capture PNG per AC. Cite the one test per AC that covers every clause. Read
`git -C <worktree> log -p <base>..HEAD -- <test files>` against the plan before judging. Probe any clause the test seems not to
exercise with a mutant on a scratch copy. AC15/AC16: `"accepted": false, "not_run": "live: <why>"`. Write auditor/ac.json in the
format at the top of scripts/ac-check.sh; self-check blind (copy to scratch, run ac-check.sh without --reviews on it, delete copy).

## Environment
- Scratch: fresh `/tmp/claude-1000/-home-justin/a9335c8b-35f9-4848-b6b7-031b4326a629/scratchpad/cortexos-memory-hook-auditor/` (mkdir, no -p); big files in
  ~/.cache/cortexos-memory-hook-auditor/; remove both by literal path. Never copy real prompts/transcripts into evidence.
- Suites under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`; SIGTERM/143/137/"Killed" may be earlyoom: check
  `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending`. uutils `timeout` rounds times up to 100 ms.

## Report
Return `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}],
auditor_ac_json, skill_lessons[]}`.
If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale),
don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of
your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that
was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test,
lint, script), what it checks and where it runs. An empty list is the normal answer.
End the report with: `MAIN SESSION: check and save these skill_lessons now.`
