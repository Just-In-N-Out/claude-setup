# Review loop: review → fix until a fresh review is clean

Justin, 2026-10-28. The rule (severities, brakes, order) lives in `review-fix-cadence` ("Loop until a review is clean"); this file holds the mechanics: the records, the referee `scripts/review-check.sh`, and what the main session does with each outcome. Applies to Full and Mini, every repo.

*Why:* the pipeline used to stop reviewing after two rounds. In harness-guards, code from fix rounds 2–4 only ever got AC checks, and a fixer found two real bugs by luck. Justin wants it to "help out a ton, but isn't going to be infinite": loop until a review is clean, with brakes that stop a loop that isn't converging.

## Rounds and scope

- Round 1 is a full review of the whole story (`--base..HEAD`). Full: round 2 is full too. Mini: round 2 onward are delta rounds.
- From round 3 (Mini: round 2), a round reviews only the fix commits since the last review (`<previous round's head>..HEAD`) and what they touch. Anything else the reviewer notices is P3.
- Each reviewer is a fresh agent that never saw the build or an earlier review's work. Rounds after the first get every earlier `review-<k>/review.json` and the fixer's answer to each finding (fixed with test and commit, or rejected with evidence).
- Fixers don't rebase; the finisher does, at the end. If a rebase inside the loop can't be avoided, the next delta reviewer reviews `git range-diff <old base>..<previous head> <new base>..HEAD` instead of `from..head`, and `from` is still the previous round's head.

## The reviewer's duties

- **Report only:** change no source, commit nothing, and write only into `<evidence>/review-<n>/`, the folder the brief names.
- **Justin's scale** (`review-fix-cadence`): P0/P1, P2 or P3. Every P0–P2 names a concrete real-use `scenario`, 5+ words: who does what, and what goes wrong. With none, the referee counts it as P3.
- **Repeats:** when a finding is the same defect as an earlier round's, set `"repeats": "<earlier id>"`, and `"new_fact"` (5+ words) when you have one, such as "the round-2 fix covers --no-verify but not its =value form". A repeat with no new fact asks Justin.
- **`review.json` is the referee's input**, like `ac.json` is `ac-check.sh`'s, so writing it is allowed: it is not a report file.
- **Self-check** before handing back: run `review-check.sh` on the evidence folder. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.
- Return the usual report as well: `verdict`, the findings, `ac_status` and `skill_lessons`.

## Records

`<evidence>/review-<n>/review.json`, written by the round's reviewer:

```json
{
  "round": 3,
  "scope": "delta",
  "from": "<40-hex sha: full review = the story base; delta = the previous round's head>",
  "head": "<40-hex sha this review covered>",
  "findings": [
    {
      "id": "R3-1",
      "severity": "P2",
      "file_line": ".claude/hooks/git-guard.sh:412",
      "claim": "--no-verify=1 is not read as --no-verify",
      "scenario": "An agent runs git commit --no-verify=1 in a Leorna worktree and the hooks are skipped",
      "repeats": "R2-4",
      "new_fact": "the round-2 fix covers --no-verify but not its =value form"
    }
  ]
}
```

- `round` is the folder's number; folders run `review-1`, `review-2`, … with no gaps. Round 1 is `full`. A full round's `from` is `--base` or an older commit of it (the base it reviewed from, before a rebase); a delta round's `from` is the previous round's `head`.
- `id` is `R<round>-<k>`, unique in the file. `severity` is `P0`–`P3`. `file_line` and `claim` are required. `scenario`, `repeats` and `new_fact` are text; `repeats` names an earlier round's id.

`<evidence>/review-<n>/justin.json`, written by the main session after an ASK JUSTIN: `{"words": "<Justin's reply, verbatim>", "accept": ["R3-1"]}` or `{"words": "…", "continue": true}`. It needs `words` and at least one of `accept` (a list) or `continue` (`true` or `false`); anything else exits 2.
- `accept`: known limits. Those findings, and later findings that `repeats` them, count as ACCEPTED: not fixed, not counted.
- `"continue": true`: keep going. That round's ASK JUSTIN becomes REVIEW AGAIN.
- When he accepts some and wants the rest fixed, write both. With `accept` alone, the brakes judge the round again on what is left, and may ask again.

## The referee

```
~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence>
```

`<base>` is `git -C <worktree> merge-base HEAD <integration branch>`. It prints one line per finding of the latest round (`<id>  <effective severity>  <file_line>  <claim>  (repeats <id>)`), then the outcome as its last line:

- **`REVIEW AGAIN`** (exit 1): P0–P2 findings are left, or the round is clean but HEAD has commits it didn't cover. A fixer brief gets the printed lines verbatim and the evidence folder; the fixer verifies each P0–P2 (`receiving-code-review`), fixes the valid ones test-first and stops `ready-for-next-review`. Then the next reviewer's brief gives round n+1, `from` = this round's head, and the earlier folders. For "commits after the reviewed head", dispatch just that delta review.
- **`MOVE ON`** (exit 0): the latest round has no P0–P2 and its head is HEAD, or HEAD is a pure rebase of it (the same patches in the same order, no merges). Append its P3 lines to `<evidence>/follow-ups.md`, then dispatch the verifier (`ac-verification.md`).
- **`ASK JUSTIN`** (exit 3): brake c (no fewer P0–P2 than the round before) or brake d (a repeat with no new fact) tripped. Ask him with the line and the finding lines, dispatch nothing until he answers, write his answer to `review-<n>/justin.json`, and rerun the referee.
- **Exit 2:** bad usage or a bad record, with an `error:` line on stderr. Send the file back to the reviewer that wrote it (SendMessage), or fix the command.

The main session never rules on a finding's severity, and never drops or rewrites a finding: the reviewers and the script do that.

## After MOVE ON

Every later commit, even a records-only one, needs a fresh delta review before the verifier runs on it: a verifier finding, a NOT ACCEPTED round, a rebase that resolved conflicts. `ac-check.sh --reviews <evidence>` enforces it: it runs the referee and refuses a head that no clean review covers. Fixers batch records into their fix commit to keep these reviews few.

Mini: the same loop and brakes, with round 1 the only full round (`mini-pipeline.md`).
