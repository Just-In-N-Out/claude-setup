# review-loop: review → fix repeats until a fresh review is clean, with a script that referees each round

## Amendments

1. **Amendment 1 (2026-10-29): the round-1 form of the REVIEW AGAIN line, in AC2 and AC7.** The ACs keep their numbers, tags and test names; the two changed lines are marked `[amended 1]`.
   - **What changed.** AC2 and AC7 now give the REVIEW AGAIN line in two forms. When round 1 is the latest round, a line that would send a delta review names both pipelines' next round: `… review again (Full: round 2 reviews the whole story from <base7>; Mini: <the delta review>)`, where `<base7>` is `--base`'s 7-character sha. From round 2 on, the line is unchanged. This covers all three such lines: P0–P2 left (Mini: `review the fix commits`), commits after the clean head (Mini: `review <sha7>..<sha7>`) and not a pure rebase (Mini: `review what changed since <sha7>`). Nothing else in the plan changed.
   - **Why.** Rule (b) (The rule, below; `feature-dispatch/references/review-loop.md`): in a Full story, rounds 1 and 2 both review the whole story. After round 1, the referee said "fix them, then review the fix commits", so this Full story's round 2 ran as a delta review. Review 5 found it (R5-1, P2), and fixer 4 fixed it in commit `99a6694` (the `next()` helper in `review-check.sh`, used by its three delta lines; tests as at head `aba3093`). The referee can't tell Full from Mini, so it names both.
   - **On whose authority.** Justin's rule (b) and his standing instruction, "keep pushing and doing everything". The amendment brings the AC text in line with his own rule. Without it, a blind auditor reading AC2 and AC7 word for word could reject the correct new behaviour.
   - **Receipts that still encode the old expectation** (a round-1 line ending `review the fix commits`, `review <sha7>..<sha7>` or `review what changed since <sha7>`, with no `review again (Full: …; Mini: …)`):
     - the builder's `evidence/review-loop/builder/ac2-ac2_referee_reviews_again_on_p0_to_p2.txt` and `ac7-ac7_referee_checks_head_coverage.txt` at `d3f220f`, and its offline run `offline-review-check.test.sh.txt`. Its `ac9-ac9_ac_check_refuses_unreviewed_head.txt` quotes the old round-1 line inside `REVIEWS  NOT ACCEPTED:`; AC9's text quotes the referee's last line generically, so AC9 is unchanged;
     - the review rounds' and fixers' suite logs at heads before `99a6694`: `review-1/` to `review-5/` (heads `d3f220f`, `9aca235`, `2fad9c3`, `aff26c8`, `aff26c8`) and `fix-1/` to `fix-3/` (`suite-offline*.log`, `suite-bash32*.log` and their mutation logs);
     - `review-1/referee.txt`, the referee's real line after round 1 (`… fix them, then review the fix commits`), which sent round 2 out as a delta review.
     - **The difference now expected:** on code at `99a6694` or later (fix 4's logs at `aba3093` onward), a round-1 REVIEW AGAIN line ends `review again (Full: round 2 reviews the whole story from <base7>; Mini: …)`, and every round-2+ line is the old form, byte for byte. Verifiers and auditors run AC2 and AC7 on the current head and don't reuse the receipts above. The old-code check is unchanged: AC2 and AC7 still fail on base, where `review-check.sh` is missing.
   - **Pre-amendment text:** `evidence/review-loop/plan-approved.md`, the read-only copy installed at "go" (identical to this plan before amendment 1). The orchestrator moves it aside (`plan-approved-v1-before-amendment-1.md`) and reinstalls this file as `plan-approved.md` before the next reviewer or verifier.
2. **Amendment 2 (2026-10-29): the AC text matches every outcome the tests assert at head `aba3093`.** The changed lines are marked `[amended 2]`: AC1, AC2, AC3, AC5, AC6, AC7, AC8, AC9, AC10, AC12, AC13 and AC16. Their ids, tags and test names are unchanged. AC4, AC11, AC14, AC15 and AC17 were checked and need no change; the live AC18 wasn't in scope. Nothing else in the plan changed.
   - **How.** For each of AC1–AC17, every expected outcome its test function asserts at `aba309358277f1845febe2c23f87db27665bfbe6` (its `want`, `has`, `bad2`, `row`, `names`, `lacks` and `grep` checks) was listed and compared with the AC text. An AC changed where a word-for-word reading contradicts an assertion or leaves an asserted outcome out.
   - **What changed:**
     - **The off-base rule** (AC1, AC2, AC3, AC6, AC7, AC8, AC9, AC10). When the latest full round's `from` isn't `--base` or an older commit of it, the referee never says MOVE ON. A clean round ends `REVIEW AGAIN: review-<f>'s from <from7> is not on --base <base7>'s history: run a full review from <base7>`, even at HEAD and however many clean delta rounds follow. P0–P2 left end `… fix them, then run a full review from <base7> (review-<f>'s from <from7> is not on its history)`. The brakes still ask first. The MOVE ON promises of AC1, AC3, AC6 and AC10 now say they need the records on `--base`'s history; AC8 says such a record is true, not exit 2; AC9 lists it as a refused head.
     - **For AC7,** also: the patch-id failure (exit 2, one `error:` line naming git's first stderr line, no temporary file left; a missing `TMPDIR` changes no outcome) and every not-a-pure-rebase case its test lists.
     - **For AC6,** the stricter `justin.json` checks (`accept` a list, `continue` true or false, `accept` or `continue` required; `null`, `{}` and blank `words` refused), `"continue": false` as a valid answer, and that an earlier round's `continue` doesn't answer the latest round.
     - **For AC5,** brake (d) counts only an effective P0–P2 in the latest round (a no-scenario P2 that repeats doesn't stall); several stalls are listed with commas; the both-brakes line is spelled out; whitespace around the words adds none.
     - **For AC8,** the whole list of exit-2 cases its test asserts, and that only the latest round's `head` and `from` must be commits (an earlier full round's are not checked).
     - **For AC1,** only the latest round's findings are printed, and records past 128 KiB give the same outcome. **For AC2,** control characters print as one space, and `<sha7>` is the round's head. **For AC9,** the only-an-AC-failing line, the exact both-failing line, and exit 2 for an empty `--reviews` or a missing `review-check.sh`. **For AC10,** the exact output, the pure-rebase `REVIEWS  CLEAN` line, and no `REVIEWS` line without `--reviews`.
     - **For AC12 and AC13,** the doc phrases the review fixes added to their tests. **For AC16,** the scan for a here-document inside `$(`, and the jq-builtin scan covering the three whole files.
   - **Why.** The review rounds changed the referee and its tests, and the AC text didn't follow. The off-base rule came from R1-9, R2-1 and R3-1, fixed in fix rounds 1–3 (`b542847`, then `0642210`, then `aff26c8`). The `justin.json` checks came from fix round 1 (`44c5633`); the patch-id failure from fix rounds 1–3 (`89d43b5`, `2fad9c3`, `97f3a67`); the here-document scan from fix round 1 (`cf54b00`); the doc phrases from fix rounds 1 and 4 (`9aca235`, `aba3093`); the 128 KiB records and the `new_fact` whitespace from fix round 4 (`bb33a25`, `7db9f3f`). The rest (control characters, the exit-2 list, the AC9 and AC10 output details, the not-a-pure-rebase cases) the builder's tests asserted from the start (`3fd5e1c`), beyond the AC text. Without this amendment, a blind auditor reading the ACs word for word could reject correct behaviour, as amendment 1 found for the round-1 line.
   - **On whose authority.** Justin's rule (b), that the full rounds review the whole story (the off-base rule enforces it), and his standing instruction, "keep pushing and doing everything". No change adds behaviour: each states what the accepted review fixes already do.
   - **Receipts that encode the old text:**
     - the builder's AC logs and offline run at `d3f220f`: no off-base rule (`review-1/probes.txt`, P6: a full review from `HEAD~1` moves on, R1-9), `justin.json` with `words` alone accepted, no patch-id-failure exit, no here-document scan, and the AC12 and AC13 checks without the later phrases;
     - `fix-1/` and `review-2/` (at `9aca235`): a full round whose `from` is off `--base`'s history exits 2 (`b542847`'s first form; `fix-1/suite-offline.log` line 119);
     - `fix-2/` and `review-3/` (at `2fad9c3`): the off-base REVIEW AGAIN only when the latest round is itself full, so a clean delta round after an off-base full round moved on (R3-1);
     - `fix-3/`, `review-4/` and `review-5/` (at `aff26c8`): today's off-base rule, but no 128 KiB records, no 4-word `new_fact` pin, the doc phrases from before `aba3093`, and amendment 1's old round-1 line.
     - **The difference now expected:** on `aba3093` or later, every outcome in the amended lines, as fix 4's logs show (`fix-4/suite-offline.log` at `aba3093`: `# passed 15, failed 0`). Verifiers and auditors run each AC's test on the current head and don't reuse the older receipts. The old-code check is unchanged: each AC still fails on base for the reason the plan gives (`review-check.sh` missing, `--reviews` refused, the docs text missing).
   - **Pre-amendment text:** this plan with amendment 1 only is setup-repo commit `34db097` (`git --git-dir="$HOME/.claude-setup.git" show 34db097:.hermes/plans/claude-setup/review-loop.md`). The text approved at "go" is still `evidence/review-loop/plan-approved.md` (also commit `f3e0b02`). The orchestrator moves that copy aside and reinstalls this file as `plan-approved.md` before the next reviewer or verifier.

Planner: Opus 5.5 (Claude Code), 2026-10-29 03:35 EDT. Story `review-loop`, project `claude-setup`. Pre-approved by Justin ("make a plan agent and then go for it"): every ⭐ option below is the plan.
Evidence folder: `~/.hermes/plans/claude-setup/evidence/review-loop/`.
Built in a linked worktree of the setup repo: `~/.claude-setup-wt/review-loop`, branch `review-loop`, base = local `main` of `~/.claude-setup.git` (`9e27ce0` at planning time; it moves with every sync, so record the real base when the worktree is made).

## Questions for Justin (pre-approved: the plan is written as if every ⭐ option is chosen)

1. **Pipeline size.**
   - A) ⭐ **Full.** Two scripts (a new referee and an `ac-check.sh` change), one test suite with 18 ACs, and rule text in about ten files. It changes the gate every future story passes through.
   - B) Mini.
2. **Who writes each round's `review.json`.**
   - A) ⭐ The reviewer, into its own `<evidence>/review-<n>/` folder. It's the referee's input, like `ac.json` is `ac-check.sh`'s, and the reviewer checks its format by running the referee before it hands back.
   - B) The main session copies the findings out of the reviewer's report. That makes the orchestrator type findings, which the pipeline forbids.
3. **How "the same finding" is matched (brake d).**
   - A) ⭐ **The reviewer links it.** Every review after round 1 gets the earlier rounds' `review.json` files and the fixer's answer to each finding. When a finding is the same defect as an earlier one, the reviewer sets `"repeats": "<earlier id>"`, plus `"new_fact"` when it has one. The referee trusts the link and refuses an id no earlier round lists. If a reviewer forgets the link, brake (c) still catches a loop that isn't shrinking.
   - B) A fingerprint the script computes (file path plus function name). It's mechanical, but different bugs in one function look the same, and two reviewers word things differently.
   - C) Both.
4. **How `ac-check.sh` learns about reviews.**
   - A) ⭐ A new `--reviews <evidence folder>` flag, in the orchestrator's command everywhere it's written. With it, `ac-check.sh` runs the referee and refuses a head no clean review covers. Without it, `ac-check.sh` behaves exactly as today. This keeps the verifier's and the blind auditor's self-checks blind to the reviews, and the existing tests unchanged.
   - B) Automatic whenever review records sit next to the AC reports. The auditor's self-check would then read the review outcome, and a REVIEW AGAIN would show up as a failure of its own report.
5. **Recording Justin's answer to an ASK JUSTIN.**
   - A) ⭐ The main session writes `<evidence>/review-<n>/justin.json`: `words` (his reply, verbatim), and either `accept: [ids]` (known limits: they count as accepted, and so do later repeats of them) or `continue: true` (keep going: that round's ASK becomes REVIEW AGAIN). The referee reads it, so a resumed session doesn't ask him again.
   - B) Nothing recorded: the main session remembers. A "known limit" answer then has no way to reach MOVE ON, and `ac-check.sh --reviews` would refuse forever.
6. **Mini pipeline.**
   - A) ⭐ **Same loop, same brakes, no round cap.** Only round 1 is a full review; every later round reviews the fix commits. The round-1 reviewer keeps doing the verifier's AC work. After any fix, the verifier runs once a review says MOVE ON.
   - B) Keep Mini as today: one review, then fixer → verifier with no second review.
7. **Room in feature-dispatch `SKILL.md`** (97,894 characters; Hermes' limit is 100,000).
   - A) ⭐ Move two rarely used sections into `references/`: the live-check steps of "Phase 5" (into `references/live-check.md`) and "Stop, pause and notification controls" (into `references/stop-controls.md`). Each heading stays with a one-line pointer. That saves about 4,500 characters.
   - B) Move only the live-check steps (about 2,100 characters saved).
   - C) Move the Hermes routing mechanics (about 3,800). They're read on every Hermes dispatch, so this costs a file read each time.
8. **The Leorna skill states the same review order** (`leorna/SKILL.md` lines 86–88: "full review 2 … → verifier; loop fixer → verifier").
   - A) ⭐ Update it in this story, so the two skills don't contradict each other.
   - B) Leave it, and list it as a follow-up.
9. **Two shortcuts in feature-dispatch Phase 3b let a fix skip review:** "records-only or test-only findings go straight to the finisher with your ruling", and "a small source fix to internal planning state may go to the finisher if every payload is byte-identical".
   - A) ⭐ Remove both. Every fix gets a fresh review, the main session never rules on a finding, and P3s go to the follow-up list.
   - B) Keep them as exceptions.
10. **Reuse the base-only merge rule for this story?** Justin allowed it for harness-guards (feature-dispatch "Merge policy", Setup repo line): a final rebase may merge without another verifier/auditor round when `range-diff` against the accepted head is all `=`, `main`'s new commits touch no story file, and the gates pass.
    - A) ⭐ Yes, with the same three conditions. Once this story is merged, `ac-check.sh --reviews` also accepts a pure rebase of the reviewed head by itself.
    - B) No: run verifier → auditor → `ac-check.sh` again after any rebase.
11. **The memory note `review-loop-until-clean.md`** (it becomes a duplicate once CLAUDE.md holds the rule).
    - A) ⭐ Delete it. It is tracked only in `.claude/projects/-home-justin/memory/`, and no `MEMORY.md` indexes it.
    - B) Shrink it to a one-line pointer.

## Playback

The pipeline today does exactly two review rounds (reviewer → fixer, reviewer → fixer), then stops reviewing: code from later fix rounds only ever gets AC checks. In harness-guards, fix rounds 2–4 went unreviewed until the main session added a third review by hand, and a fixer found two real bugs by luck. Justin wants review → fix to **loop until a fresh review finds no P0–P2 bug and every AC is met**, with brakes so it "helps out a ton, but isn't going to be infinite". Three parts, all in this story:

1. **Rule text** in CLAUDE.md steps 5–6, feature-dispatch (Full and Mini), `review-fix-cadence`, `ac-verification.md`, the Codex reviewer and fixer roles (and, per Q8, the Leorna skill). Codex picks CLAUDE.md up through the generated `~/.codex/AGENTS.md`. The memory note is retired (Q11).
2. **The round referee,** `feature-dispatch/scripts/review-check.sh`: it reads every round's `review.json`, applies the brakes mechanically, and prints `REVIEW AGAIN`, `MOVE ON` or `ASK JUSTIN` as its last line.
3. **`ac-check.sh --reviews`:** it refuses acceptance when the head has commits no clean review covers. All existing behaviour and tests stay green.

Out of scope (Justin passed on it): a runner that resumes the loop by itself, a per-story budget, receipts.

## The rule (as agreed; the docs below carry it)

- Review → fix repeats until a fresh reviewer's review is **clean**: no P0, P1 or P2 finding.
- **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included (inputs, configs, git operations, macOS and WSL); anything that breaks an AC or the UI; a test that can't fail.
- **P3:** cosmetic, docs, a hole only a deliberate evasion would hit, or a setup none of Justin's machines has. P3s go on the story's follow-up list, `<evidence>/follow-ups.md`.
- This scale replaces `code-review-practice`'s own P2/P3 meanings inside Justin's pipeline. That skill's P2 includes "maintainability … performance", which is P3 here unless it fails a real use.
- **Brakes:**
  - (a) every P0–P2 names a concrete real-use scenario; with none, it counts as P3;
  - (b) rounds 1 and 2 review the whole story (Mini: round 1 only); from round 3, a round covers only the fix commits since the last review and what they touch, and anything else the reviewer notices is P3;
  - (c) a round with no fewer P0–P2 than the round before (when that round had any) → ask Justin;
  - (d) the same finding again with no new fact → ask Justin.
  - There's no fixed round cap.
- **Order:** verifier → blind auditor → `ac-check.sh` only after a clean review of the current head. Any fix after that (a verifier finding, a NOT ACCEPTED round, a rebase that resolved conflicts) gets a fresh review of that fix before the verifier runs again.

## Facts checked for this plan (2026-10-29; read-only, probes in `~/.cache/review-loop-planner/` with a temp `HOME` and `GIT_CONFIG_GLOBAL`)

**Base tally** (setup repo `main` at `1953985`, the live `$HOME` checkout, `TMPDIR=~/.cache/review-loop-planner/tmp`). Everything passed:
- `ac-check.test.sh`: `all passed`, 117 `ok` lines, 0 `FAIL`;
- `harness-guards.test.sh` offline: `# passed 19, failed 0`;
- `harness-guards.test.sh ac19_existing_suites_pass`: `ok`. That covers the five hook suites (`all passed`), `sync.test.sh` (`passed 32, failed 0`), `ac-check.test.sh`, the `codex-parity.test.sh` offline run (`# passed 18, failed 0`), and the hook suites, `ac-check.test.sh` and harness-guards again with the git hooks on.

So the regression AC (AC17) starts from a green base. `main` moved to `9e27ce0` since; those three sync commits touch a Leorna memory note, a Leorna hand-over draft and one line of `ac-verification.md`, and no suite.

**Sizes:**
- feature-dispatch `SKILL.md` is **97,894 characters** (Python `len`, what harness-guards' `ac17` measures). `wc -c` says 98,157 bytes, because of emoji and arrows.
- The live-check steps (lines 397–410) are 2,327 characters. "Stop, pause and notification controls" is 2,594 characters.
- Lines 411–415 sit under the Phase 5 heading but are general dispatcher rules ("Out of steps", "Needs a decision"…). **They stay in `SKILL.md`.**
- `figma-to-bricks/SKILL.md:104` says "see `feature-dispatch` Phase 5", so the heading stays.

**Where the old two-review order is written** (grep of every synced skill, CLAUDE.md, roles and memory):
- `CLAUDE.md:20` (step 5), `:21` (step 6), `:24` (step 7), `:26` and `:81` (Agent models);
- feature-dispatch `SKILL.md`:
  - `:29` (Full order), `:133` (reviewer row "two in order"), `:154` (Full review order), `:155` (Full: two; Mini: one);
  - `:216` and `:218` (`ready-for-verify`), `:227`, `:228` (fixer → verifier loop), `:235` (Usage), `:327` (status list);
  - `:339`, `:348`, `:353`, `:362`, `:363` (Phase 3b);
- `references/mini-pipeline.md` steps 3–4 and its role table;
- `references/ac-verification.md` Steps 1–4;
- `review-fix-cadence/SKILL.md:21` (default cadence) and procedure steps 4–5;
- `leorna/SKILL.md:85–88` (Q8).
- The Leorna memory note `review-prompt-for-agent.md` mentions "two review rounds" only as history (Justin's own extra review prompt), so it needs no change.

**Pins that must stay true** (other stories' tests):
- harness-guards `ac17` needs the feature-dispatch line `If you learn something reusable` (Phase 1), the CLAUDE.md lessons bullet, and feature-dispatch under 100,000 characters. This story doesn't touch those lines, and the moves come from other sections.
- harness-guards `ac18` needs the guard names in CLAUDE.md's Privacy, Authorship and orchestrator sentences. Untouched.
- `codex-parity.test.sh` `ac5` needs each `pipeline-reviewer|verifier|auditor.toml` to contain `verdict`, `ac_status` and "never edit", every role to contain `brief`, `skill_lessons`, `MAIN SESSION: check and save these skill_lessons now.` and `Never spawn`, and `codex doctor` to load them. `build-codex.sh` rewrites only the two model lines.
- `codex-parity` `ac7` runs every `.claude/hooks/tests/*.test.sh` in a fake home. This story adds no file there (its suite lives next to the scripts), so nothing new joins that run.

**Tools:**
- desktop: jq 1.8.1, git 2.53.0, bash 5.3;
- Mac: git 2.50.1 (harness-guards facts) and bash 3.2 at `/bin/bash`.
- **Use only jq 1.6 features:** `IN`, `splits`, `any/2`, `unique` and `startswith` are fine; the 1.7+ builtins `trim`, `ltrim`, `rtrim`, `pick`, `abs`, `toarray` and `have_decnum` are not. The Mac may have an older jq than the desktop's 1.8.1.
- `seq`, `realpath`, `git patch-id --stable` and process substitution exist on both machines.
- In the Bash tool, `grep` is ugrep, so agents use `command grep`.

**The design runs.** The planner probed a prototype of the referee in a temp `HOME` with a temp `GIT_CONFIG_GLOBAL`. It's the intended shape below; the builder makes it test-driven. It printed:
- clean at HEAD → `MOVE ON`, exit 0;
- one commit after the clean review → `REVIEW AGAIN: 1 commit(s) after review-1's head … review <a>..<b>`, exit 1;
- a pure rebase onto a newer `main` → `MOVE ON: … is a pure rebase of it`;
- a rebase with a changed patch → `REVIEW AGAIN`;
- a repeat with no new fact → `ASK JUSTIN: … repeats with no new fact: R2-1 repeats R1-2`, exit 3, even though the count dropped from 2 to 1;
- the same repeat with a new fact → `REVIEW AGAIN`;
- 2 → 2 findings → `ASK JUSTIN: … 2 P0-P2, no fewer than review-1's 2`;
- `justin.json` with `continue` → `REVIEW AGAIN`; with `accept` of both → `MOVE ON`;
- a `justin.json` without `words`, or a delta review starting at the wrong commit → exit 2 with the reason;
- a lone P2 whose scenario is "edge case" → `P3 (no scenario)`, then `MOVE ON`.

**Subagents can write `review.json`.** Claude Code refuses subagent *report* files ("return findings as text"), but a file that's input to another tool is fine: verifiers already write `ac.json`. The docs say so in those words, so a reviewer doesn't refuse.

**Hot files.** Peer sessions' lesson saves edit `feature-dispatch/SKILL.md`, `ac-verification.md` and CLAUDE.md often: `ac-verification.md` changed in sync `80556f7` while this plan was being written. The builder and finisher expect rebase conflicts in exactly the lines this story changes (risk R1).

## Approach

### 1. The round record: `<evidence>/review-<n>/review.json` (written by the reviewer)

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

- `id` is `R<round>-<k>`, unique in the file. `severity` is `P0`–`P3`. `file_line` and `claim` are required. `scenario` is "who does what, and what goes wrong" (5+ words, or brake a applies). `repeats` and `new_fact` are optional.
- `scope`: round 1 is `full` (Full: round 2 too). Later rounds are `delta` from the previous round's head. After a rebase inside the loop, the delta reviewer reviews `git range-diff` instead of `from..head`, and `from` is still the previous head.
- Fixers don't rebase; the finisher does, at the end.
- The reviewer still returns its usual report: `verdict`, the findings, `ac_status` and `skill_lessons`, as the hooks require.

`<evidence>/review-<n>/justin.json` (written by the main session, Q5): `{"words": "<Justin's reply, verbatim>", "accept": ["R3-1"]}` or `{"words": "…", "continue": true}`.

### 2. The referee: `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh`

```
review-check.sh --repo <worktree> --base <base commit> <evidence folder>
```

- It reads `review-1 … review-<n>` (no gaps) and their `justin.json`, validates everything, and judges the **latest** round.
- **Effective severity:**
  - a finding Justin accepted, or one that `repeats` an accepted one, counts as **ACCEPTED**;
  - a P0–P2 whose `scenario` has fewer than 5 words counts as **P3 (no scenario)** (brake a);
  - otherwise its own severity.
- **Outcome** (last line):
  - **MOVE ON** (exit 0): no effective P0–P2 in the latest round, and its head is HEAD, or HEAD is a **pure rebase** of it (the same `git patch-id --stable` list, in order, no merges, between `merge-base(reviewed head, HEAD)..reviewed head` and `--base..HEAD`).
  - **REVIEW AGAIN** (exit 1), in two cases:
    - effective P0–P2 remain, and no brake tripped (or `justin.json` says `continue`): "fix them, then review the fix commits";
    - the round is clean but HEAD has commits it doesn't cover: "review <reviewed>..<HEAD>".
  - **ASK JUSTIN** (exit 3), with the reason:
    - brake (c): the round before had k ≥ 1 effective P0–P2, and this one has k or more;
    - brake (d): a P0–P2 `repeats` an earlier effective P0–P2 and has no `new_fact` of 5+ words.
  - Exit 2: bad usage or bad records, with the reason on stderr.
- Before the last line it prints one line per finding of the latest round: `<id>  <effective severity>  <file_line>  <claim>  (repeats <id>)`. The P3 lines are what the main session appends to `follow-ups.md`.
- **Validation (exit 2):**
  - the record shape;
  - `round` equals its folder number; ids start `R<n>-` and are unique;
  - round 1 is full; a delta's `from` is the previous head;
  - `repeats` names an earlier id; `justin.json` has `words`, and its `accept` ids exist in that round;
  - for the latest round only, `head` and `from` are commits in the repo and a full review's `from` is an older commit of its head. Older rounds' heads may be garbage-collected after a rebase.

**Intended shape** (the planner's probed prototype; bash 3.2 + git + jq 1.6; keep both jq programs in this one file so the script syncs as one `*.sh`):

```bash
#!/usr/bin/env bash
# review-check: the round referee for the review → fix loop (the review twin of ac-check.sh).
#
#   review-check.sh --repo <worktree> --base <base commit> <evidence folder>
#
# Reads <evidence>/review-1/review.json, review-2/…, numbered without gaps (format and the
# reviewer's duties: references/review-loop.md), and Justin's recorded answers
# <evidence>/review-<n>/justin.json, then judges the LATEST round:
#   - a P0-P2 whose scenario has fewer than 5 words counts as P3 (brake a);
#   - a finding Justin accepted, or one that repeats it, counts as ACCEPTED (it isn't fixed);
#   - P0-P2 left → REVIEW AGAIN, unless brake c (no fewer P0-P2 than the round before, when that
#     round had any) or brake d (a P0-P2 that repeats an earlier P0-P2 with no new_fact of 5+ words)
#     trips → ASK JUSTIN; justin.json "continue": true answers that round's ASK with REVIEW AGAIN;
#   - none left → MOVE ON when the round's head is HEAD, or HEAD is a pure rebase of it (the same
#     patches in the same order, no merges); otherwise REVIEW AGAIN for the unreviewed commits.
# Prints one line per finding of the latest round, then the outcome as the LAST line.
# Exit 0 MOVE ON, 1 REVIEW AGAIN, 3 ASK JUSTIN, 2 bad usage or input. ac-check.sh --reviews runs it.
# Needs bash 3.2+, git, jq 1.6+. Tests: review-check.test.sh
set -uo pipefail

usage() { echo "usage: review-check.sh --repo <worktree> --base <base commit> <evidence folder>" >&2; exit 2; }
die() { echo "error: $*" >&2; exit 2; }
repo="" base=""
while (($#)); do
  case $1 in
    --repo) (($# >= 2)) || usage; repo=$2; shift 2 ;;
    --base) (($# >= 2)) || usage; base=$2; shift 2 ;;
    -*) usage ;;
    *) break ;;
  esac
done
(($# == 1)) && [[ -n $repo && -n $base ]] || usage
ev=$1
[[ -d $ev ]] || die "no evidence folder at $ev"
HEADSHA=$(git -C "$repo" rev-parse --verify -q HEAD 2>/dev/null) || die "$repo is not a git worktree"
commit() { git -C "$repo" rev-parse --verify -q "$1^{commit}" 2>/dev/null; }
BASESHA=$(commit "$base") || die "--base $base is not a commit"
[[ $BASESHA != "$HEADSHA" ]] && git -C "$repo" merge-base --is-ancestor "$BASESHA" "$HEADSHA" 2>/dev/null \
  || die "--base must be an older commit of this branch than HEAD"

VALIDATE=$(cat <<'JQ'
def str: type == "string" and length > 0;
def sha: type == "string" and test("^[0-9a-f]{40}$");
.rounds as $r | .justin as $j
| range(0; $r | length) as $i | $r[$i] as $x | ($i + 1) as $k | "review-\($k)" as $w
| ([ $r[0:$i][] | .findings[]? | .id ]) as $earlier
| if ($x | type) != "object" then "\($w)/review.json is not a JSON object" else
  (if $x.round != $k then "\($w): round is \($x.round | tojson), want \($k)" else empty end),
  (if ($x.scope | IN("full", "delta") | not) then "\($w): scope must be full or delta" else empty end),
  (if $k == 1 and $x.scope != "full" then "review-1 must be a full review" else empty end),
  (if ($x.head | sha | not) then "\($w): head must be a full 40-character sha" else empty end),
  (if ($x.from | sha | not) then "\($w): from must be a full 40-character sha" else empty end),
  (if $k > 1 and $x.scope == "delta" and $x.from != $r[$i - 1].head
   then "\($w): a delta review starts at review-\($k - 1)'s head, not \($x.from | tostring | .[0:7])" else empty end),
  (if ($x.findings | type) != "array" then "\($w): findings must be a list" else
     ($x.findings[] | . as $f
      | if type != "object" then "\($w): a finding is not an object"
        elif ($f.id | type) != "string" or ($f.id | startswith("R\($k)-") | not) then "\($w): finding id \($f.id | tojson) must start R\($k)-"
        elif ($f.severity | IN("P0", "P1", "P2", "P3") | not) then "\($w) \($f.id): severity must be P0, P1, P2 or P3"
        elif ($f.file_line | str | not) or ($f.claim | str | not) then "\($w) \($f.id): file_line and claim are required"
        elif (($f.scenario // "") | type) != "string" or (($f.new_fact // "") | type) != "string" or (($f.repeats // "") | type) != "string"
        then "\($w) \($f.id): scenario, repeats and new_fact are text"
        elif ($f.repeats // "") != "" and ([ $earlier[] | select(. == $f.repeats) ] | length) == 0
        then "\($w) \($f.id): repeats \($f.repeats | tojson), which no earlier review lists"
        else empty end),
     (if ([ $x.findings[] | .id? ] | length) != ([ $x.findings[] | .id? ] | unique | length) then "\($w): a finding id is listed twice" else empty end)
   end),
  ($j[$i] | if . == {} then empty
     elif type != "object" or (.words | str | not) then "\($w)/justin.json needs words: Justin's reply, verbatim"
     elif ((.accept // []) | type) != "array" then "\($w)/justin.json: accept must be a list of finding ids"
     else (.accept // [])[] as $a
          | if ([ $x.findings[]? | select(.id == $a) ] | length) == 0 then "\($w)/justin.json accepts \($a | tojson), which \($w) doesn't list" else empty end
     end)
  end
JQ
)
JUDGE=$(cat <<'JQ'
def words: [splits("[[:space:]]+") | select(length > 0)] | length;
def serious: . == "P0" or . == "P1" or . == "P2";
.rounds as $r | .justin as $j | ($r | length - 1) as $L
| (reduce range(0; $r | length) as $i ([];
     . as $acc | ($j[$i].accept // []) as $a
     | $acc + [ $r[$i].findings[]
                | select(.id as $id | any($a[]; . == $id)
                         or ((.repeats // "") as $p | $p != "" and any($acc[]; . == $p)))
                | .id ])) as $accepted
| [ $r[] | [ .findings[]
              | . + {eff: (if (.id as $id | any($accepted[]; . == $id)) then "ACCEPTED"
                           elif (.severity | serious) and ((.scenario // "") | words) < 5 then "P3 (no scenario)"
                           else .severity end)} ] ] as $e
| [ $e[$L][] | select(.eff | serious) ] as $now
| (if $L > 0 then [ $e[$L - 1][] | select(.eff | serious) ] | length else 0 end) as $prev
| [ $now[] | . as $f | select((.repeats // "") != "")
    | select(any($e[0:$L][][]; .id == $f.repeats and (.eff | serious)))
    | select(((.new_fact // "") | words) < 5) | "\(.id) repeats \(.repeats)" ] as $stalled
| { round: ($L + 1), head: $r[$L].head, now: ($now | length), prev: $prev, stalled: $stalled,
    lines: [ $e[$L][] | "\(.id)  \(.eff)  \(.file_line)  \(.claim)\(if (.repeats // "") != "" then "  (repeats \(.repeats))" else "" end)" ],
    outcome: (if ($now | length) == 0 then "clean"
              elif $j[$L].continue == true then "again"
              elif ($stalled | length) > 0 or ($prev > 0 and ($now | length) >= $prev) then "ask"
              else "again" end) }
JQ
)

# the rounds: review-1 … review-<n>, with no gaps
n=0
while [[ -f $ev/review-$((n + 1))/review.json ]]; do n=$((n + 1)); done
((n > 0)) || die "no review records: $ev/review-1/review.json is missing"
for d in "$ev"/review-*; do
  k=${d##*/review-}
  [[ $k =~ ^[1-9][0-9]*$ ]] && ((k > n)) && [[ -f $d/review.json ]] \
    && die "review-$k/review.json exists but review-$((n + 1))/review.json doesn't"
done
rounds="[" justin="[" sep=""
for ((k = 1; k <= n; k++)); do
  r=$(jq -c . "$ev/review-$k/review.json" 2>/dev/null) && [[ -n $r ]] || die "review-$k/review.json is not JSON"
  j='{}'
  if [[ -f $ev/review-$k/justin.json ]]; then
    j=$(jq -c . "$ev/review-$k/justin.json" 2>/dev/null) && [[ -n $j ]] || die "review-$k/justin.json is not JSON"
  fi
  rounds="$rounds$sep$r" justin="$justin$sep$j" sep=,
done
in=$(jq -nc --argjson r "$rounds]" --argjson j "$justin]" '{rounds: $r, justin: $j}') || die "can't read the review records"
bad=$(jq -r "$VALIDATE" <<<"$in" 2>&1) || die "can't check the review records: $bad"
[[ -z $bad ]] || die "$(head -n 1 <<<"$bad")"
RH=$(jq -r ".rounds[$((n - 1))].head" <<<"$in"); RF=$(jq -r ".rounds[$((n - 1))].from" <<<"$in")
[[ -n $(commit "$RH") ]] || die "review-$n's head ${RH:0:7} is not a commit in $repo"
[[ -n $(commit "$RF") ]] || die "review-$n's from ${RF:0:7} is not a commit in $repo"
if [[ $(jq -r ".rounds[$((n - 1))].scope" <<<"$in") == full ]]; then
  git -C "$repo" merge-base --is-ancestor "$RF" "$RH" 2>/dev/null && [[ $RF != "$RH" ]] \
    || die "review-$n is a full review, but its from ${RF:0:7} is not an older commit of its head ${RH:0:7}"
fi

v=$(jq -c "$JUDGE" <<<"$in") || die "can't judge the review records"
jq -r '.lines[]' <<<"$v"
outcome=$(jq -r .outcome <<<"$v") now=$(jq -r .now <<<"$v")

pids() { # pids <from> <to>: a patch-id per non-merge commit, oldest first ("empty:<subject>" for no diff)
  local c p
  git -C "$repo" rev-list --reverse --no-merges "$1..$2" | while IFS= read -r c; do
    p=$(git -C "$repo" show "$c" | git -C "$repo" patch-id --stable | cut -d' ' -f1)
    echo "${p:-empty:$(git -C "$repo" log -1 --format=%s "$c")}"
  done
}
case $outcome in
  clean)
    if [[ $RH == "$HEADSHA" ]]; then echo "MOVE ON: review-$n at ${RH:0:7} is clean"; exit 0; fi
    if git -C "$repo" merge-base --is-ancestor "$RH" "$HEADSHA" 2>/dev/null; then
      echo "REVIEW AGAIN: $(git -C "$repo" rev-list --count "$RH..$HEADSHA") commit(s) after review-$n's head ${RH:0:7} are unreviewed: review ${RH:0:7}..${HEADSHA:0:7}"
      exit 1
    fi
    mb=$(git -C "$repo" merge-base "$RH" "$HEADSHA")
    a=$(pids "$mb" "$RH") b=$(pids "$BASESHA" "$HEADSHA")
    if [[ -n $a && $a == "$b" && $(git -C "$repo" rev-list --count --merges "$BASESHA..$HEADSHA") == 0 ]]; then
      echo "MOVE ON: review-$n at ${RH:0:7} is clean, and HEAD ${HEADSHA:0:7} is a pure rebase of it"; exit 0
    fi
    echo "REVIEW AGAIN: HEAD ${HEADSHA:0:7} is not review-$n's head ${RH:0:7} or a pure rebase of it: review what changed since ${RH:0:7}"
    exit 1 ;;
  again)
    echo "REVIEW AGAIN: $now P0-P2 finding(s) in review-$n at ${RH:0:7}: fix them, then review the fix commits"; exit 1 ;;
  ask)
    why=$(jq -r '[ (if (.stalled | length) > 0 then "repeats with no new fact: \(.stalled | join(", "))" else empty end),
                   (if .prev > 0 and .now >= .prev then "\(.now) P0-P2, no fewer than review-\(.round - 1)'"'"'s \(.prev)" else empty end) ]
                 | join("; ")' <<<"$v")
    echo "ASK JUSTIN: review-$n: $why"; exit 3 ;;
esac
die "unknown outcome $outcome"
```

Notes for the builder:
- **Tests drive the details.** Possible needs: a `file_line` holding a tab, a repo path with spaces, a `merge-base` that fails. If you change a message, keep the leading keyword and the facts the ACs name.
- The AC16 scan bans the jq 1.7+ builtins, so don't reach for `trim` when you touch the jq programs.

### 3. `ac-check.sh --reviews <evidence folder>` (Q4)

- **Usage:** `ac-check.sh --repo <worktree> --base <base commit> --plan <approved plan> [--reviews <evidence folder>] <verifier report> <auditor report>`. Add `--reviews) (($# >= 2)) || usage; reviews=$2; shift 2 ;;` and `reviews=""` to the option loop.
- **After the dirty-worktree check, before the AC loop,** when `--reviews` is given:
  - run `bash "<this script's folder>/review-check.sh" --repo "$repo" --base "$base" "$reviews"`;
  - referee exit 2 → `die "--reviews: <its error line>"` (ac-check exit 2). A missing `review-check.sh` is the same `die`;
  - keep its last line; the head is covered only for exit 0 with a last line starting `MOVE ON`.
- **After the AC lines,** only with `--reviews`:
  - covered → `REVIEWS  CLEAN: <the referee's line without "MOVE ON: ">`;
  - not covered → `REVIEWS  NOT ACCEPTED: <the referee's last line>`.
- **Last line:**
  - AC failures (with or without a review failure): `NOT ACCEPTED: <bad> of <total> ACs on <sha7>`, plus `; and the head isn't covered by a clean review` when the review also fails; exit 1;
  - only the review fails: `NOT ACCEPTED: the head <sha7> isn't covered by a clean review (<the referee's last line>)`; exit 1;
  - otherwise unchanged: `ALL ACCEPTED: …` or `READY FOR THE USER: …`.
- **Without `--reviews`,** not one byte of output changes: no note, no warning. The verifier and the auditor keep self-checking without it.
- **Header comment:** add a paragraph on `--reviews`.
- **`ac-check.test.sh` is not edited.** Every new test lives in `review-check.test.sh`, so "every existing case still passes" is proven by the base file itself (AC11).

### 4. Rule text (where each part lives)

- **`review-fix-cadence/SKILL.md`: the canonical rule.**
  - Rewrite "Default cadence" as the loop.
  - Add a new section `## Loop until a review is clean (Justin, 2026-10-28)`: the four severities (and the override of `code-review-practice`'s scale), brakes (a)–(d), "No fixed round cap", the order, and `review-check.sh`.
  - Procedure step 4: rounds 1–2 full; from round 3 the fix commits since the last review, carrying every earlier `review.json` and the fixer's dispositions.
  - Procedure step 5: a fresh fixer for each `REVIEW AGAIN` list; replace "Behaviour-changing final fixes require … re-review" with "every fix gets a fresh review".
  - Validation: "No verifier starts before `review-check.sh` prints MOVE ON for the current head."
  - Three new cases in `references/scenario-checks.md`:
    - round 3 is clean → MOVE ON → verifier, no extra full review;
    - round 4 repeats round 3's P2 with no new fact → ASK JUSTIN, nothing dispatched until he answers, his answer goes in `justin.json`;
    - the verifier finds a bug after MOVE ON → fixer → fresh review of the fix → MOVE ON → verifier.
- **feature-dispatch `references/review-loop.md` (new, the mechanics):**
  - why (harness-guards), and rounds and scope (fixers don't rebase; `range-diff` after a rebase);
  - the reviewer's duties:
    - report only, writing only into `review-<n>/`;
    - Justin's scale, and a scenario for every P0–P2;
    - `repeats`/`new_fact`, and P3 for out-of-scope findings in a delta round;
    - `review.json` is the referee's input, like `ac.json`, so writing it is allowed;
    - self-check with `review-check.sh` (exit 2 = fix your file);
    - the usual `verdict`/`ac_status`/`skill_lessons`;
  - the `review.json` and `justin.json` formats, with the example above;
  - the referee command, its outcomes and exit codes, and what the main session does with each:
    - REVIEW AGAIN → a fixer brief with the printed lines verbatim and the folder; the fixer stops `ready-for-next-review`; then the next reviewer's brief gives round n+1, `from` = this head, and the earlier folders;
    - MOVE ON → append the P3 lines to `follow-ups.md`, then the verifier;
    - ASK JUSTIN → ask with the line and the finding lines, write `justin.json`, rerun the referee;
    - exit 2 → send the file back to the reviewer (SendMessage);
  - "the main session never rules on a finding's severity";
  - after MOVE ON, every later commit (even a records-only one) needs a fresh delta review; `ac-check.sh --reviews` enforces it;
  - Mini: a pointer to `mini-pipeline.md`.
- **feature-dispatch `SKILL.md`: short pointers, replacing the two-review lines** (texts in Task 9). Plus the two moves (Q7) into `references/live-check.md` and `references/stop-controls.md`.
- **`references/ac-verification.md`:**
  - a fourth "Why" layer ("reviewed head");
  - step 1: the verifier runs only after MOVE ON on the current head;
  - step 2: not clean → fixer → a fresh review of that fix → verifier;
  - step 4: the command with `--reviews <evidence>`, and NOT ACCEPTED → fixer → fresh review → referee → verifier → auditor → ac-check;
  - the self-check sentence gains "(without `--reviews`: the reviewed-head check is the orchestrator's, and the auditor never reads reviews)".
- **`references/mini-pipeline.md`** (Q6): the role table, the "fewer agents" line, steps 3–4.
- **`~/.claude/CLAUDE.md`:**
  - steps 5 and 6 rewritten;
  - step 7 gains one clause;
  - line 26 (reviewers also write `review.json`);
  - line 81 ("Agent models": the loop wording).
- **`leorna/SKILL.md`** lines 85–88 (Q8).
- **Codex roles:**
  - `pipeline-reviewer.toml` and `pipeline-fixer.toml` ROLE lines;
  - the other five are unchanged: the verifier and auditor already self-check without `--reviews`, and the orchestrator runs the order.
  - `~/.codex/AGENTS.md` is regenerated from CLAUDE.md by `sync.sh`; never edit it.
- **Memory:** delete `.claude/projects/-home-justin/memory/review-loop-until-clean.md` (Q11).

### 5. Where it's built, and how this story runs itself

- **Worktree,** as in harness-guards: `git --git-dir="$HOME/.claude-setup.git" worktree add "$HOME/.claude-setup-wt/review-loop" -b review-loop main`.
  - The `$HOME` layout means the merge is the install.
  - `~/.claude-setup-wt/` is never staged by `sync.sh`.
  - Commits use the global personal identity, with no `Co-Authored-By` line (the git hooks check it).
  - `status.showUntrackedFiles=no` is shared, so before every hand-over check that `git -C <wt> status --porcelain --untracked-files=all` is empty.
- **Every agent:**
  - `TMPDIR=~/.cache/review-loop-<role>/`, created fresh;
  - `command grep`, `tail -n N`, `touch -d` with an explicit offset;
  - git probes only through a script file with a temp `HOME` and `GIT_CONFIG_GLOBAL`. git-guard denies inline `-c core.hooksPath=` and the like: a deny is the guard working, so don't work around it.
- **The suite:** `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`, next to `ac-check.test.sh`.
  - It's in harness-guards' style: one function per AC, numbered TAP (`ok 1 - <name>`), and `bash review-check.test.sh <name> [<name>…]` runs just those.
  - The default run is the durable offline set. `ac11`, `ac17` and the live `ac18` run only when named (story-time and heavy checks).
  - `SRC=$(cd "$HERE/../../../../.." && pwd)` (the checkout root: the worktree, or `$HOME` once merged).
  - Each test makes its fixtures with `mktemp -d` and its git config with `HOME=$S/home GIT_CONFIG_GLOBAL=$S/gitconfig GIT_CONFIG_NOSYSTEM=1`, never `-c user.email`, and unsets the same `GIT_*` overrides harness-guards does.
  - Nothing touches a real repo, the real global config or GitHub.
- **This story's own loop:**
  - the reviewers write `review.json` in the format above from round 1;
  - after each review the main session runs the worktree's referee, `~/.claude-setup-wt/review-loop/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo ~/.claude-setup-wt/review-loop --base <base> ~/.hermes/plans/claude-setup/evidence/review-loop`. If it exits 2 unexpectedly or crashes, the main session applies the memory note's rule by hand and the next fixer gets that as a finding;
  - the final acceptance needs **both** the live `~/.hermes/.../ac-check.sh` (base version, no `--reviews`) and the worktree's `ac-check.sh … --reviews <evidence>`.
- **Merge:** setup repo policy: the finisher rebases on local `main` and the main session does `--ff-only`. Q10 applies. Then `~/.claude/setup/sync.sh` pushes and rebuilds Codex's AGENTS.md.

## Acceptance criteria (proposed: Justin gave none; his pre-approval covers them)

All tests are functions in `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh`. Run one as `bash <worktree>/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh <test name>`; it prints numbered TAP.

- The referee is run as `review-check.sh --repo <fixture repo> --base <fixture base> <fixture evidence>`. The fixture repo is a temp repo with a `main` base commit and a story branch.
- "5+-word scenario" means 5 or more whitespace-separated words.

- AC1 (proposed) [amended 2]: Given review records whose latest round has no P0–P2 finding (none at all, or only P3s), whose `head` is HEAD, and whose latest full round's `from` is `--base` or an older commit of it ("on `--base`'s history"; otherwise AC7's off-base `REVIEW AGAIN`), the referee prints one line per finding of the latest round only (P3s as `P3`, a P3 with no scenario too; earlier rounds' findings aren't printed) and ends `MOVE ON: review-<n> at <sha7> is clean`, exit 0, however large the records are (past 128 KiB too). Test: `ac1_referee_moves_on_when_clean`.
- AC2 (proposed) [amended 1] [amended 2]: A latest round with a P0, a P1 or a P2 finding that has a 5+-word scenario ends `REVIEW AGAIN`, exit 1, with a line per finding naming its id, severity, `file_line` and claim (a P3 in the same round printed as `P3` and not counted; a run of control characters in a field, such as a tab or a newline, printed as one space). When the latest round is round 1, the last line is `REVIEW AGAIN: <k> P0-P2 finding(s) in review-1 at <sha7>: fix them, then review again (Full: round 2 reviews the whole story from <base7>; Mini: review the fix commits)`, where `<base7>` is `--base`'s 7-character sha (not review-1's `from`); from round 2 on, it is `REVIEW AGAIN: <k> P0-P2 finding(s) in review-<n> at <sha7>: fix them, then review the fix commits`. `<sha7>` is the round's own head, not HEAD. When the latest full round's `from` is not on `--base`'s history (AC1, AC7), the last line in any round is instead `REVIEW AGAIN: <k> P0-P2 finding(s) in review-<n> at <sha7>: fix them, then run a full review from <base7> (review-<f>'s from <from7> is not on its history)`, where review-<f> is that full round (AC7's test asserts this form). Test: `ac2_referee_reviews_again_on_p0_to_p2`.
- AC3 (proposed) [amended 2]: A P0–P2 whose scenario is missing, empty, blank or under 5 words (`"edge case"`, `"see claim above"`) is printed as `P3 (no scenario)` and not counted, so a round whose only findings are such ends `MOVE ON` (its head HEAD and its records on `--base`'s history, as in AC1); the same finding with a 5+-word scenario ends `REVIEW AGAIN`. Test: `ac3_referee_counts_p2_without_scenario_as_p3`.
- AC4 (proposed): When the round before had k ≥ 1 effective P0–P2 and the latest round has k or more (k=1→1, 2→3), the last line is `ASK JUSTIN: review-<n>: <m> P0-P2, no fewer than review-<n-1>'s <k>`, exit 3; 2→1 ends `REVIEW AGAIN`; a round after a clean round (0→1) ends `REVIEW AGAIN`; counts use effective severities (a no-scenario P2 in either round doesn't count). Test: `ac4_referee_asks_when_no_progress`.
- AC5 (proposed) [amended 2]: A latest-round effective P0–P2 (not a P3, not a P2 with no scenario as in AC3, not accepted as in AC6) whose `repeats` names an earlier round's effective P0–P2 and whose `new_fact` is missing or under 5 words (whitespace around the words adds none) ends `ASK JUSTIN: review-<n>: repeats with no new fact: <id> repeats <earlier id>`, exit 3, even when the count dropped (2→1); several such findings are listed with commas (`R2-1 repeats R1-1, R2-2 repeats R1-2`); with a 5+-word `new_fact` it ends `REVIEW AGAIN`; repeating an earlier P3 (or no-scenario P2) doesn't trip it; when brakes (c) and (d) both trip, the line names both: `ASK JUSTIN: review-<n>: repeats with no new fact: <id> repeats <earlier id>; <m> P0-P2, no fewer than review-<n-1>'s <k>`. Test: `ac5_referee_asks_on_repeat_without_new_fact`.
- AC6 (proposed) [amended 2]: `review-<n>/justin.json` with `words` and `accept: [ids]` makes those findings, and later findings whose `repeats` chain reaches one of them, print as `ACCEPTED` and not count (a round whose P0–P2 are all accepted ends `MOVE ON` when its head is HEAD and its records are on `--base`'s history, as in AC1, and an accepted finding doesn't feed brake c or d); `"continue": true` turns that round's `ASK JUSTIN` into `REVIEW AGAIN` (an earlier round's `continue` doesn't), and `"continue": false` is a valid answer that changes nothing; a justin.json in any round that isn't JSON, is `null` or `{}`, lacks `words` or has blank `words`, has an `accept` that isn't a list or a `continue` that isn't true or false, records neither `accept` nor `continue`, or accepts an id that round doesn't list exits 2. Test: `ac6_referee_records_justins_answers`.
- AC7 (proposed) [amended 1] [amended 2]: With a clean latest round whose latest full round's `from` is `--base` or an older commit of it (on `--base`'s history, AC1): HEAD equal to its head ends `MOVE ON`; HEAD with commits after its head ends `REVIEW AGAIN: <c> commit(s) after review-1's head <sha7> are unreviewed: review again (Full: round 2 reviews the whole story from <base7>; Mini: review <sha7>..<sha7>)` when the latest round is round 1, and `REVIEW AGAIN: <c> commit(s) after review-<n>'s head <sha7> are unreviewed: review <sha7>..<sha7>` from round 2 on; HEAD that is a pure rebase of its head onto a newer base (same patches, same order, no merges; an empty commit compared by its message) ends `MOVE ON: … is a pure rebase of it`; a rebase that changed a patch, dropped a commit or added one ends `REVIEW AGAIN`, whose line ends `review again (Full: round 2 reviews the whole story from <base7>; Mini: review what changed since <sha7>)` when the latest round is round 1 and `review what changed since <sha7>` from round 2 on; that `REVIEW AGAIN` also covers a patch changed only in whitespace, two commits swapped, an empty commit's message changed or the empty commit dropped, a merge of main instead of a rebase, and a reviewed head on unrelated history. When the latest full round's `from` is not `--base` or an older commit of it (a full review from inside the story, a base commit a sync rebase rewrote, or, with delta rounds after it, a `from` that is no longer a commit), a clean latest round ends `REVIEW AGAIN: review-<f>'s from <from7> is not on --base <base7>'s history: run a full review from <base7>`, exit 1, even when HEAD is its head, where review-<f> is that full round; it reads only the latest full round, so it holds however many clean delta rounds follow, until a full round from `--base` or an older commit of it is the latest full round. The brakes and Justin's answers still apply first (AC4–AC6: a brake still ends `ASK JUSTIN`, and accepting every P0–P2 leaves this line), and P0–P2 left give AC2's off-base line. When git can't compute the patch-ids, it exits 2 with one stderr line, `error: can't compute the patch-ids that compare HEAD <sha7> with review-<n>'s head <sha7> (git diff-tree | git patch-id --verbatim failed: <git's first stderr line>)`, and leaves no temporary file; a `TMPDIR` that is a missing folder changes no outcome, and then that line ends `failed: git's message was lost (no temporary file in <TMPDIR>))`. `<base7>` is `--base`'s 7-character sha. Test: `ac7_referee_checks_head_coverage`.
- AC8 (proposed) [amended 2]: Bad usage and bad records exit 2 with an `error:` line on stderr and no outcome line: a missing `--repo`, `--base` or folder, a `--base` with no value, two folders or an unknown option (`error: usage: …`); a folder that doesn't exist; a `--repo` that isn't a git worktree; a `--base` that isn't a commit, or isn't an older commit of HEAD (HEAD itself, or not under it); no `review-1/review.json`; a gap (`review-1`, `review-3`); a file that isn't JSON (an empty file too) or JSON that isn't an object; `round` not matching its folder (the text `"1"` too); `scope` not `full`/`delta`; round 1 not `full`; `head` or `from` not a 40-hex sha; the latest round's `head` or `from` not a commit in the repo; a latest round that is a full review whose `from` isn't an older commit of its `head`; a delta review whose `from` isn't the previous round's `head`; `findings` not a list, or a finding not an object; an id missing, not starting `R<n>-` or listed twice; a severity outside P0–P3 (`P4`, `p2`); a missing, empty or blank `file_line` or `claim`; a non-text `scenario`, `repeats` or `new_fact`; `repeats` naming no earlier round's finding (its own round's included). Every round's record is checked, not only the latest, but only the latest round's `head` and `from` must be commits: an earlier round's may be gone after a rebase, and the records still give their outcome. A full round whose `from` is off `--base`'s history is a true record, not exit 2 (AC7). Test: `ac8_referee_rejects_bad_records`.
- AC9 (proposed) [amended 2]: Given verifier and auditor reports that prove every AC, `ac-check.sh … --reviews <evidence>` exits 1, prints a `REVIEWS  NOT ACCEPTED: <the referee's last line>` line and ends `NOT ACCEPTED: the head <sha7> isn't covered by a clean review (<the referee's last line>)` when HEAD has a commit after the last `MOVE ON` review, when the latest round is `REVIEW AGAIN`, when it is `ASK JUSTIN`, and when a clean round at HEAD follows a full round whose `from` is off `--base`'s history (AC7's off-base `REVIEW AGAIN`); with an AC also failing, the last line is `NOT ACCEPTED: <bad> of <total> ACs on <sha7>; and the head isn't covered by a clean review`; with only an AC failing, it is the usual `NOT ACCEPTED: <bad> of <total> ACs on <sha7>`, after a `REVIEWS  CLEAN: …` line; missing or bad review records, an empty `--reviews`, or no `review-check.sh` beside `ac-check.sh` exit 2 with an `error: --reviews: …` line. Test: `ac9_ac_check_refuses_unreviewed_head`.
- AC10 (proposed) [amended 2]: The same reports with `--reviews <evidence>` and a clean latest review at HEAD, its records on `--base`'s history (the referee's `MOVE ON`, AC1), end `ALL ACCEPTED: <n> of <n> ACs on <sha7>` (exit 0) after a `REVIEWS  CLEAN: review-<n> at <sha7> is clean` line (the whole output: the AC lines, that line, then the last line); with an owed `(live)` AC they end `READY FOR THE USER: …` (exit 0); a pure rebase of the reviewed head (with `--base` the new merge-base and both reports at the new head) is accepted, after `REVIEWS  CLEAN: review-<n> at <sha7> is clean, and HEAD <sha7> is a pure rebase of it`; without `--reviews` no `REVIEWS` line is printed. Test: `ac10_ac_check_accepts_reviewed_head`.
- AC11 (proposed): The base commit's `ac-check.test.sh` (from `git show <base>:…`), run in a temp folder beside a copy of the new `ac-check.sh` and the new `review-check.sh`, ends `all passed` with every `ok` label it has on base (117 at planning time); and for five fixtures (all accepted, one AC not accepted, a live AC owed, a dirty worktree, a usage error) the new `ac-check.sh` without `--reviews` gives byte-identical output and the same exit code as the base one. Runs only when named. Test: `ac11_ac_check_existing_cases_pass`.
- AC12 (proposed) [amended 2]: The rule is named in each place: CLAUDE.md step 5 names `review-check.sh`, `REVIEW AGAIN`, `MOVE ON`, `ASK JUSTIN`, `P0`, `P1`, `P2`, `P3`, `scenario`, `no fewer`, `new fact`, `round 3` and `No round cap`, and step 6 names `MOVE ON` and `--reviews <evidence>`; CLAUDE.md no longer has `a second fresh reviewer of the corrected code, then a fixer for its valid findings`; `review-fix-cadence/SKILL.md` has a `## Loop until a review is clean` section naming the four severities, `scenario`, `no fewer`, `new fact`, `fix commits`, `review-check.sh` and `MOVE ON`, and no longer says `looping fixer → verifier`; feature-dispatch `SKILL.md` names `references/review-loop.md` and `review-check.sh` and no longer says `two in order` or `second fresh full review of the corrected candidate → fixer for its valid findings`; `references/review-loop.md` names `review.json`, `justin.json`, `repeats`, `new_fact`, `scenario`, `follow-ups.md`, `REVIEW AGAIN`, `MOVE ON` and `ASK JUSTIN`; `references/ac-verification.md` names `MOVE ON` and `--reviews`; `references/mini-pipeline.md` names `review-check.sh` and `MOVE ON` and no longer says `one review instead of two`; `leorna/SKILL.md` names `review-check.sh` and no longer says `fresh Opus full review 2 of the corrected candidate → fresh Opus fixer for valid findings → fresh Opus verifier`. Since the review fixes, also: CLAUDE.md step 5 names `Mini: round 1 only` and ``unless `review-check.sh` says run a full review from `<base>` ``, and the `## Loop until a review is clean` section names that `unless …` phrase too; feature-dispatch `SKILL.md`'s `**Reviewer returns:**` line and its `**From round 3 a review is focused:**` line each hold that `unless …` phrase, and it no longer says `Otherwise dispatch the verifier`, `New behavioral fixes still require fresh re-review` or `push back on the rest with evidence, then run the project skill's finish step`; `references/review-loop.md` names ``(Full's round 2: full, `from` = `--base`)``, `A delta reviewer also judges each P0–P2 the fixer rejected` and `for an earlier full round, a commit that no longer exists`; `leorna/SKILL.md` no longer says `otherwise another fresh fixer and verifier round runs`. Test: `ac12_docs_name_the_review_loop`.
- AC13 (proposed) [amended 2]: `.codex/agents/pipeline-reviewer.toml` names `review.json`, `review-loop.md`, `P0`, `P3`, `scenario`, `repeats` and `Mini: round 1 only`, and keeps `verdict`, `ac_status`, `never edit` and `skill_lessons[{skill, lesson, evidence, enforce}]`; `.codex/agents/pipeline-fixer.toml` names `P0-P2` (or `P0–P2`) and `ready-for-next-review`; all seven `pipeline-*.toml` parse with `python3` `tomllib` and keep `MAIN SESSION: check and save these skill_lessons now.` and `Never spawn`. Test: `ac13_codex_roles_name_the_review_loop`.
- AC14 (proposed): feature-dispatch `SKILL.md` is under 100,000 characters (Python `len`); it keeps the `## Phase 5: Live check` and `## Stop, pause and notification controls` headings, each with a pointer to `references/live-check.md` / `references/stop-controls.md`; those files hold the moved text (live-check: the CHECKER `goal:`, `output_schema:` and the `🔎` report line; stop-controls: "Separate work from delivery" and "Acknowledge once"); and the general bullets "Out of steps" and "Needs a decision" are still in `SKILL.md`. Test: `ac14_feature_dispatch_under_limit`.
- AC15 (proposed): The memory note `.claude/projects/-home-justin/memory/review-loop-until-clean.md` is gone from the checkout and not tracked in git, and no tracked `MEMORY.md` names it. Test: `ac15_memory_note_retired`.
- AC16 (proposed) [amended 2]: `review-check.sh`, `ac-check.sh` and `review-check.test.sh` pass `bash -n` and contain none of `mapfile`, `readarray`, `declare -A`, `local -n`, `${x,,}`-style case changes, `[[ -v`, `|&`, `&>>`, `sed -i`, `grep -P`, `readlink -f`, `date -d`, `stat -c`; none of the three opens a here-document inside a command substitution (`$(` … `<<`; a `<<<` here-string is fine), which bash 3.2 misparses; `review-check.sh` and `review-check.test.sh` also have no `head -<n>`/`tail -<n>` short forms; and the three files (so their jq programs too) use none of the jq 1.7+ builtins `trim`, `ltrim`, `rtrim`, `pick`, `abs`, `toarray`, `have_decnum`. Test: `ac16_scripts_portable_to_macos`.
- AC17 (proposed): Regression, run only when named: the five hook suites, `harness-guards.test.sh` (offline), `sync.test.sh`, `ac-check.test.sh`, `codex-parity.test.sh` (offline) and `review-check.test.sh` (offline) pass, and the five hook suites, `ac-check.test.sh`, `harness-guards.test.sh` and `review-check.test.sh` also pass with the git hooks active (`GIT_CONFIG_GLOBAL` = a temp copy of `~/.gitconfig` plus `core.hooksPath` = the checkout's githooks); base tally at `1953985`: all green. Test: `ac17_existing_suites_pass`.
- AC18 (proposed) (live): On the Mac after `~/.claude/setup/sync.sh pull`: `env PATH="/bin:/usr/bin:$PATH" /bin/bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh` (offline set) and the same for `ac-check.test.sh` pass under bash 3.2 with the BSD tools first on `PATH`, and the function prints the bash version and the `jq --version` it used. Test: `ac18_mac_suites_live`.

**Old-code check** (`ac-verification.md`):
- ac1–ac10 and ac16 fail on base because `review-check.sh` is missing, or `ac-check.sh` refuses the unknown `--reviews` flag with exit 2. `need` fails the test; it never skips.
- ac12–ac15 fail on base: the text is missing, the moved sections are still in `SKILL.md`, the note exists.
- ac11 and ac17 keep existing behaviour: `base_exempt: "regression run of existing suites"` (ac17) and `"regression run of existing ac-check cases"` (ac11).
- ac18 is `(live)`: agents mark it `not_run: "live: needs the Mac"`. Its function checks `uname -s` is `Darwin` first and fails elsewhere with that reason.

## Tasks (in order; test first: write the AC's test, run it and see it fail for the stated reason, then build)

1. **Worktree and evidence.** Make the worktree (command in Approach 5). Record `base=$(git -C ~/.claude-setup-wt/review-loop merge-base HEAD main)` in the builder report. `mkdir -p ~/.hermes/plans/claude-setup/evidence/review-loop/builder`. `TMPDIR=~/.cache/review-loop-builder/` (made fresh).
2. **Test harness** `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.test.sh` (mode 755):
   - a header naming this plan and the run forms;
   - `OFFLINE` = ac1–ac10 and ac12–ac16;
   - `fail`/`need`/`run` copied from `harness-guards.test.sh` (numbered TAP, a subshell per test, `# passed N, failed M` and a non-zero exit on failure);
   - `newroot` (temp `$S`, fake home, test gitconfig);
   - `ing` (git with that env);
   - `mkrepo` (a `main` base commit, a story branch with two commits);
   - `rev <n> <scope> <from> <head> <finding json>…` (writes `review.json`), `finding <id> <sev> <scenario> [repeats] [new_fact]`, `justin <n> <json>`;
   - `referee` (runs the checkout's `review-check.sh`; sets `$out`, `$rc`, `$last` = the last non-empty line);
   - `acfix` (a one-AC plan with a named test, verifier and auditor folders with head/base logs, a PNG and `ac.json`, in the style of `ac-check.test.sh`'s `mklog`/`png`/`entry`; the evidence folder sits outside the repo, so the worktree stays clean).

   Write all 18 functions, run each and see RED (`not ok … missing …/review-check.sh (not built yet)`, `ac-check.sh` exit 2 on `--reviews`, docs phrases missing). Commit: `test(review-loop): acceptance tests`.
3. **Referee: usage and record validation** (AC8). Write `review-check.sh` (mode 755) with the option parsing, the round collection, `VALIDATE` and the latest-round commit checks. GREEN. Commit.
4. **Referee: judgment** (AC1–AC6): `JUDGE`, the per-finding lines and the three outcomes. GREEN on each, then re-run AC8. Commit.
5. **Referee: head coverage** (AC7): the descendant and pure-rebase checks (`pids`). GREEN, then re-run AC1–AC8. Commit.
6. **`ac-check.sh --reviews`** (AC9, AC10): the option, the referee call, the `REVIEWS` line and the last-line rules. GREEN. Then `bash ac-check.test.sh` (unchanged file) → `all passed`, and `bash review-check.test.sh ac11_ac_check_existing_cases_pass` → ok. Commit.
7. **Portability** (AC16). Fix anything the scan finds. GREEN. Commit.
8. **Make room in feature-dispatch** (AC14, Q7). Move:
   - lines 62–66 (the five numbered stop items) into `references/stop-controls.md`, under a one-line title;
   - the live-check steps (the paragraph "After he pastes a merged fix…" through the "Fail or unsure" bullet, lines 397–410) into `references/live-check.md`.

   Keep both headings, each followed by one line:
   - stop: "Read a stop request, cancel or pause only what it names, hold continuation and acknowledge once: follow `references/stop-controls.md`."
   - live: "After he pastes a merged fix and replies **pasted <page>** (or **converted**), a read-only CHECKER checks the live page: board → `checking`, then follow `references/live-check.md`."

   Lines 411–415 stay. GREEN for the move part (the size part passes already). Commit.
9. **Rule text** (AC12): the texts below, folded into existing lines wherever they replace one. Re-check `SKILL.md`'s size after it. GREEN. Commit.
10. **Codex roles** (AC13): the ROLE lines below. Then `bash .claude/setup/codex/codex-parity.test.sh ac5_roles_valid_and_load` → ok. GREEN. Commit.
11. **Memory note** (AC15): `git rm .claude/projects/-home-justin/memory/review-loop-until-clean.md` in the worktree. GREEN. Commit.
12. **Regression** (AC17): `bash …/review-check.test.sh ac17_existing_suites_pass`. Then the full offline run and an empty `git -C <wt> status --porcelain --untracked-files=all`. Stop at `ready-for-review`, with the head SHA and each AC's command.
13. **Finish** (finisher and main session, after `ac-check` accepts):
    1. the finisher rebases on local `main`, resolves conflicts keeping both meanings (hot files: R1), re-runs Task 12, re-checks `SKILL.md`'s size and reports the new HEAD;
    2. Q10's base-only rule decides whether verifier → auditor → `ac-check` run again;
    3. the main session does the `--ff-only` merge into `main` (the merge is the install: the referee, the `--reviews` flag and the rule text go live, and the memory note is removed from `$HOME`);
    4. the finisher runs the after-merge steps: `~/.claude/setup/sync.sh` (push; it also rebuilds `~/.codex/AGENTS.md`), then checks `~/.codex/AGENTS.md` contains `review-check.sh`;
    5. hand AC18 to Justin.

### Texts for Task 9 (fold into the named lines; keep their surrounding sentences unless the text says otherwise)

**`~/.claude/CLAUDE.md` step 5** (replaces line 20 whole):

> 5. **Review → fix, until a fresh review is clean** (`review-fix-cadence`; mechanics: `feature-dispatch/references/review-loop.md`). Each round a fresh reviewer (`requesting-code-review` + `code-review-practice`, report only) writes `<evidence>/review-<n>/review.json`; you run `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <worktree> --base <base> <evidence>` and act on its last line. **`REVIEW AGAIN`** → a fixer (`receiving-code-review`) fixes the P0–P2 findings it lists, then the next fresh reviewer: rounds 1 and 2 review the whole story; from round 3, only the fix commits since the last review and what they touch. **`MOVE ON`** → step 6, and its P3 lines go to `<evidence>/follow-ups.md`. **`ASK JUSTIN`** → ask the user, quoting it, and record his answer in `<evidence>/review-<n>/justin.json`. Clean means no P0, P1 or P2. P0/P1: a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work. P2: a bug a real person or agent could plausibly hit, realistic edge cases included (inputs, configs, git operations, macOS and WSL), anything that breaks an AC or the UI, or a test that can't fail. P3: cosmetic, docs, a hole only a deliberate evasion hits, or a setup none of the user's machines has. The brakes, so it always ends: a P0–P2 with no concrete real-use scenario counts as P3; a round with no fewer P0–P2 than the round before, or the same finding again with no new fact, is `ASK JUSTIN`. No round cap. Don't judge findings or severities yourself: the reviewers and the script do. *Why: in harness-guards (2026-10-28), code from fix rounds 2–4 went unreviewed.*

**Step 6** (line 21):
- Its first sentence becomes "**Verifier, then a blind check** (`ac-verification.md`), only after `MOVE ON` on the current head."
- "Not clean → fixer → verifier again" becomes "Not clean → fixer → a fresh review of that fix (step 5's loop, until `MOVE ON`) → verifier again".
- The command (line 22) becomes:
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh --repo <worktree> --base <base> --plan <evidence>/plan-approved.md --reviews <evidence> <evidence>/verifier/ac.json <evidence>/auditor/ac.json`
- After it, add "(`--reviews` refuses a head with commits no clean review covers)".
- The `NOT ACCEPTED` sentence becomes "a fixer gets those lines and both reports, then a fresh review of that fix (step 5) → verifier → auditor → ac-check again".
- "the agents and the script do that" becomes "the agents and the scripts do that".

**Step 7** (line 24): after "if HEAD now differs from the head `ac-check.sh` accepted, you run verifier → auditor → `ac-check.sh` again on it", add "(a rebase that resolved conflicts gets a fresh review of them first: `--reviews` accepts only a pure rebase of the reviewed head)".

**Line 26:** "Every reviewer, verifier and auditor returns a `verdict` and `ac_status`" becomes "Every reviewer, verifier and auditor returns a `verdict` and `ac_status`, and every reviewer also writes its `review.json`".

**Line 81:** "Fixer → verifier rounds loop until every acceptance criterion is accepted on one head, with no round cap" becomes "Review → fix rounds loop until a fresh review is clean, and fix → review → verifier rounds until every acceptance criterion is accepted on one reviewed head, with no round cap".

**`review-fix-cadence/SKILL.md`:**
- "Default cadence" (line 21) becomes: "For Leorna and every other repo (Justin, 2026-10-23: all-Opus default; 2026-10-28: loop until clean): **Opus plan → user go → Opus build → fresh Opus full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until a review is clean (`review-check.sh`: MOVE ON) → fresh Opus verifier → blind auditor → `ac-check.sh --reviews`, looping fix → review → verifier until every acceptance criterion is accepted on one reviewed head → final hand-over.**"
- The new section goes right after "Default cadence":

> ## Loop until a review is clean (Justin, 2026-10-28)
>
> Review → fix repeats until a fresh reviewer's review is clean: no P0, P1 or P2. Only then does the verifier run. *Why: in harness-guards, code from fix rounds 2–4 went unreviewed, and a fixer found two real bugs by luck. Justin: "help out a ton, but isn't going to be infinite."*
> - **Severity** (this scale replaces `code-review-practice`'s P2/P3 meanings in Justin's pipeline):
>   - **P0/P1:** a security hole, a guard bypass, a false AC, or a wrong block that breaks normal work.
>   - **P2:** a bug a real person or agent could plausibly hit, realistic edge cases included (inputs, configs, git operations, macOS and WSL); anything that breaks an AC or the UI; a test that can't fail.
>   - **P3:** cosmetic, docs, a hole only a deliberate evasion would hit, or a setup none of Justin's machines has. P3s go on the story's follow-up list (`<evidence>/follow-ups.md`), not to a fixer.
> - **Scope:** rounds 1 and 2 review the whole story (Mini: round 1); from round 3, only the fix commits since the last review and what they touch. Anything else a delta reviewer notices is P3.
> - **Brakes, so it always ends** (`feature-dispatch/scripts/review-check.sh` applies a, c and d):
>   - (a) every P0–P2 names a concrete real-use scenario (5+ words: who does what, and what goes wrong); with none, it counts as P3;
>   - (b) the scope rule above;
>   - (c) a round with no fewer P0–P2 than the round before (when that round had any) → ASK JUSTIN;
>   - (d) the same finding again (`repeats` an earlier P0–P2) with no new fact → ASK JUSTIN.
>   - No fixed round cap.
> - **Order:** verifier → blind auditor → `ac-check.sh --reviews` only after `review-check.sh` prints MOVE ON for the current head. Any fix after that (a verifier finding, a NOT ACCEPTED round, a rebase that resolved conflicts) gets a fresh review of that fix before the verifier runs again.
> - Records, formats and what the main session does with each outcome: `feature-dispatch/references/review-loop.md`.

**feature-dispatch `SKILL.md`** (exact edits):
- `:29`: "plan → build → fresh full review → fix → fresh full review of the corrected code → fix → fresh verifier → blind AC auditor + `scripts/ac-check.sh`" becomes "plan → build → fresh full review → fix → fresh review → … until `scripts/review-check.sh` prints MOVE ON (Justin, 2026-10-28; `references/review-loop.md`) → fresh verifier → blind AC auditor + `scripts/ac-check.sh --reviews`".
- `:133` row: `| Reviewer (separate, fresh), every repo | **a fresh Opus 5.5 every round**, until a review is clean (`references/review-loop.md`) | **xhigh** |`.
- `:154`: the bold order becomes "**Fresh full review → fixer → fresh full review of the corrected candidate → fixer → fresh review of the fix commits → … until `scripts/review-check.sh` prints MOVE ON**, no round cap". Delete "Final behavioural fixes retain fresh independent re-review and the applicable Opus verifier."
- `:155`: "(Full: two fresh Opus 5.5 xhigh reviews in turn; Mini: one)" becomes "(every round of the review loop)".
- `:216`: "then stop with `status: ready-for-verify`" becomes "then stop with `status: ready-for-next-review` (the fix gets a fresh review; the verifier runs after MOVE ON)".
- `:218`: "before `ready-for-verify`" becomes "before `ready-for-next-review`".
- `:227`: "then run `scripts/ac-check.sh`" becomes "then run `scripts/ac-check.sh … --reviews <evidence>`".
- `:228`: "**Critical or major findings left, or any acceptance criterion not accepted:** run another fresh FINISHER fix round, then a new fresh VERIFIER." becomes "**Verifier findings left, or any acceptance criterion not accepted:** a fresh FINISHER fix round, a fresh review of that fix until `review-check.sh` prints MOVE ON, then a new fresh VERIFIER."
- `:230`: becomes "a round made no progress (the same finding reopened with no new fact, or `review-check.sh` says ASK JUSTIN)".
- `:235`: "each loop round adds a verifier, plus a finisher when findings remain" becomes "each review round adds a reviewer, plus a finisher when it lists P0–P2; each verify round adds a verifier and an auditor".
- `:327`: `ready-for-verify` becomes `ready-for-next-review` in the status list.
- `:339`:
  - "Full, every repo, loads `review-fix-cadence`: dispatch a fresh **Opus 5.5 xhigh full review first**; a second fresh Opus full review covers the corrected candidate after any fix. Mini: one fresh Opus 5.5 xhigh review." becomes "Full and Mini load `review-fix-cadence`: dispatch round 1 of the review loop, a fresh **Opus 5.5 xhigh full review** (`references/review-loop.md`).";
  - add a context bullet, "write `<evidence>/review-<n>/review.json` as `references/review-loop.md` says (it's `review-check.sh`'s input)";
  - the output_schema findings become `findings[{id, severity, file_line, claim, scenario, repeats, new_fact}]`.
- `:348` step 2: the sentences up to "If the review exposes an incorrect plan assumption" become "**Reviewer returns:** run `scripts/review-check.sh --repo <worktree> --base <base> <evidence>` and follow its last line (`references/review-loop.md`). **REVIEW AGAIN** → an **Opus 5.5 xhigh FINISHER now** for the listed P0–P2: verify and fix test-first, re-run the gates, commit and stop `ready-for-next-review`, no release; then the next fresh review (Full: round 2 is full; later rounds the fix commits and what they touch), carrying every earlier `review.json` and the fixer's dispositions. **MOVE ON** → its P3 lines go to `<evidence>/follow-ups.md`, then the VERIFIER. **ASK JUSTIN** → ask with the line. Preserve complete reports, reviewed heads and dispositions." The rest of the bullet (the plan-assumption and outage sentences) stays.
- `:353`: becomes "Every fix pass stops at `ready-for-next-review`: the next fresh review comes before any verifier."
- `:362`: "(Full: two Opus 5.5 xhigh reviews in turn; Mini: one)" becomes "(the review loop)".
- `:363`: replace the whole sub-bullet with "**From round 3 a review is focused:** the fix commits since the last review (`<last reviewed head>..<new head>`) and what they touch, with the earlier `review.json` files and the fixer's dispositions (`references/review-loop.md`). Repeat until `review-check.sh` prints MOVE ON; only then the verifier. P3s go to the follow-up list; the main chat never rules on a finding (Q9: the records-only and byte-identical shortcuts are gone)."

**`references/ac-verification.md`:**
- add to "Why": "4. **Reviewed head:** `--reviews` refuses a head with commits no clean review covers (`review-loop.md`); a pure rebase of the reviewed head counts as covered.";
- Steps 1, 2 and 4 as in Approach 4;
- the self-check sentence gains its parenthesis.

**`references/mini-pipeline.md`:**
- table row "Reviewer": "**Opus 5.5**, a fresh one per round: round 1 full, then one per fix round";
- "Finisher (only if the review found something)" becomes "(on REVIEW AGAIN, verifier findings or NOT ACCEPTED)";
- "Verifier (only after a fix round; fresh)" becomes "(after the MOVE ON that follows a fix; fresh)";
- "(one review instead of two, …)" becomes "(one full review instead of two, …)";
- step 3: "Round 1 of the review loop: one fresh full review, every repo (Full has two full rounds) … it also writes `review-1/review.json`";
- step 4, rewritten:

> 4. Run `scripts/review-check.sh` (`review-loop.md`). **MOVE ON** at round 1 → the blind AC auditor, then `scripts/ac-check.sh --reviews` (`ac-verification.md`); on `ALL ACCEPTED` or `READY FOR THE USER`, the finisher runs only the finish step (unchanged text). **REVIEW AGAIN** → an Opus 5.5 xhigh finisher fixes the listed P0–P2 test-first (`receiving-code-review`) and stops `ready-for-next-review`; a fresh delta reviewer (review only: the fix commits and what they touch) writes the next `review.json`; repeat until MOVE ON; then a fresh verifier (with the AC work) → auditor → `ac-check.sh --reviews`. **ASK JUSTIN** → ask. **NOT ACCEPTED** or verifier findings → finisher → a fresh delta review until MOVE ON → verifier → auditor → ac-check. Same brakes as Full, no round cap. Ask Justin only for a decision that's his, on ASK JUSTIN, or when the same AC fails twice for the same reason.

**`leorna/SKILL.md`:**
- `:85` "both reviewers" becomes "every reviewer";
- `:86`: "fresh Opus full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until `review-check.sh` prints MOVE ON (`review-fix-cadence`; `feature-dispatch` references/review-loop.md) → fresh Opus verifier → blind auditor → `ac-check.sh --reviews`;"
- `:87`: "**loop until every AC is accepted on one reviewed head**, with no round cap; any fix after MOVE ON gets a fresh review first. Each reviewer/verifier returns `ac_status[]`. Ask Justin only for a decision that's his, on ASK JUSTIN, or after a round with no progress.";
- `:88` "both reviewers → `requesting-code-review`" becomes "every reviewer → `requesting-code-review`".

**Codex `pipeline-reviewer.toml` ROLE line:**

> ROLE: Report only: never edit, create or delete source files; write only into the brief's <evidence>/review-<n>/ folder. Load requesting-code-review, code-review-practice and review-fix-cadence. Review the range the brief names (rounds 1-2 the whole story; later rounds only the fix commits since the last review and what they touch). Rate findings on Justin's P0-P3 scale in review-fix-cadence; every P0-P2 names a concrete real-use scenario, or it counts as P3; mark a finding that repeats an earlier round's with repeats and new_fact. Write <evidence>/review-<n>/review.json as ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md says, and check its format with review-check.sh. Report a verdict (clean or findings), the findings with id, severity, file:line and scenario, and ac_status[{ac, accepted, test, screenshot, evidence}] for every AC (accepted true only when its test passed on that head).

**Codex `pipeline-fixer.toml` ROLE line:**

> ROLE: Load receiving-code-review. Fix the P0-P2 findings the brief lists (review-check.sh's list; P3s are follow-ups, not fixes): verify each before acting, fix the valid ones test-first, push back with evidence on the rest. Don't rebase unless the brief says so. Commit, stop at ready-for-next-review, and report per finding: fixed (test, commit) or rejected (evidence).

## Docs & records

- **Rule text:**
  - `.claude/CLAUDE.md`: steps 5, 6, 7 and lines 26, 81;
  - `.hermes/skills/software-development/review-fix-cadence/SKILL.md` and its `references/scenario-checks.md` (three cases);
  - `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`, plus new `references/review-loop.md`, `references/live-check.md` and `references/stop-controls.md`;
  - `references/ac-verification.md` and `references/mini-pipeline.md`;
  - `.hermes/skills/software-development/leorna/SKILL.md`;
  - `.codex/agents/pipeline-reviewer.toml` and `pipeline-fixer.toml`.
- **Scripts:**
  - `feature-dispatch/scripts/review-check.sh` and `review-check.test.sh` (new, mode 755);
  - `feature-dispatch/scripts/ac-check.sh` (`--reviews` and its header paragraph).
- **Memory:** delete `.claude/projects/-home-justin/memory/review-loop-until-clean.md`.
- **Story records:**
  - `~/.hermes/plans/claude-setup/evidence/review-loop/follow-ups.md`: the P3s, written by the main session as rounds return;
  - in `evidence/harness-guards/follow-ups.md`, the "FIRST after the merge: story `review-loop`" item gets "Done: story review-loop, merged <date> at <sha>" (finisher, after the merge).
- **Synced at the finish** by `~/.claude/setup/sync.sh`, which also rebuilds `~/.codex/AGENTS.md`; never edit that file.
- **Not changed:**
  - `manifest.txt`: `.hermes/skills/**` already covers the new files;
  - `ac-check.test.sh`; the hooks and `settings.json`; the other five Codex roles; `agents-header.md`.

## Touched files (`$HOME`-relative; the same paths in the worktree)

New:
- `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh`, `review-check.test.sh`;
- `.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`, `live-check.md`, `stop-controls.md`.

Changed:
- `.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`;
- `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md`, `references/ac-verification.md`, `references/mini-pipeline.md`;
- `.hermes/skills/software-development/review-fix-cadence/SKILL.md`, `references/scenario-checks.md`;
- `.hermes/skills/software-development/leorna/SKILL.md`;
- `.claude/CLAUDE.md`;
- `.codex/agents/pipeline-reviewer.toml`, `.codex/agents/pipeline-fixer.toml`.

Deleted:
- `.claude/projects/-home-justin/memory/review-loop-until-clean.md`.

Unchanged by design:
- `ac-check.test.sh`, every hook and hook test, `settings.json`, `sync.sh`, `manifest.txt`;
- `build-codex.sh`, `agents-header.md`, the other five Codex roles.

Overlap with other work: none on the board for `claude-setup`. Peer sessions' lesson saves touch the same skill files (R1).

## Risks

- **R1 (high): hot files.** Lesson saves from other sessions edit feature-dispatch `SKILL.md`, `ac-verification.md`, CLAUDE.md and the Leorna skill every few hours (sync `80556f7` changed `ac-verification.md` during planning).
  - Expect conflicts on rebase.
  - *Mitigation:* the finisher keeps both meanings, re-runs AC12/AC14 and the size check on the rebased head, and the Q10 rule then applies or not.
- **R2: brake (c) asks Justin more often early.** A full round 2 can find as many as round 1 (harness-guards: 12 → 8, so it wouldn't have). *Mitigation:* his "keep going" goes in `justin.json` as `continue`, so the loop resumes without asking again.
- **R3: a reviewer forgets `repeats`.** Brake (d) then misses a repeat. *Mitigation:* every later reviewer gets the earlier `review.json` files and dispositions, and brake (c) still stops a loop that isn't shrinking.
- **R4: the 5-word scenario test is mechanical.** A reviewer can write a hollow scenario. *Mitigation:* the reviewer brief demands a concrete real-use one, and the fixer verifies each finding (`receiving-code-review`) and may push back with evidence.
- **R5: every commit after MOVE ON, even a records-only one, needs a delta review.** That costs one short reviewer, and it keeps the rule mechanical. Fixers batch records into their fix commit.
- **R6: `--reviews` is opt-in in the script** (Q4). *Mitigation:* every written copy of the orchestrator's command has it (AC12 checks CLAUDE.md step 6 and `ac-verification.md`).
- **R7: review and Justin records don't sync between machines.** The manifest syncs only `.hermes/plans/**/*.md` and briefs, the same as `ac.json` today, so a story can't move machines mid-loop without copying its evidence folder.
- **R8: Claude Code's "no report files" reflex.** A reviewer may hesitate to write `review.json`. *Mitigation:* the brief and `review-loop.md` say it's the referee's input, like `ac.json`. If one still refuses, the referee's exit 2 sends it back.
- **R9: this story judges itself.** Its own loop runs the worktree's referee. *Mitigation:* independent reviewers, plus final acceptance through the live, unchanged `ac-check.sh` as well.
- **R10: Codex's `ac5` needs the `codex` binary** for `codex doctor`. It passed at base on this desktop.
- **Estimate** (Full, all-Opus): build about 2–3 h of agent time (18 tests, one new script, one script change, about ten doc edits); review rounds and verification about 1.5–2.5 h; Justin's Mac check about 5 min.

## Other things found (not fixed here)

- **Low:** feature-dispatch Phase 3b (`SKILL.md:363`) lets the main chat rule on findings ("records-only or test-only … goes straight to the finisher with your ruling") and lets a small source fix skip review ("byte-identical" shortcut). Both conflict with "the main session never judges" and with the new rule. Q9 removes them in this story.
- **Low:** `code-review-practice` (a read-only library skill at `~/.hermes/skills-library/skills/code-review-practice/SKILL.md:41-44`) defines P2 as "maintainability, edge case, performance, or UX issue with bounded impact", a different scale from Justin's. This story states the override in `review-fix-cadence` and the reviewer role rather than editing the library skill.
- **Info:** the merged harness-guards worktree `~/.claude-setup-wt/harness-guards` (branch `harness-guards` at `dc5d4f5`, already in `main`) is still on disk. Remove it when convenient: `git --git-dir="$HOME/.claude-setup.git" worktree remove ~/.claude-setup-wt/harness-guards`.
- **Info:** evidence `.json` files (`ac.json` now, `review.json`/`justin.json` after this story) never sync between the Mac and the desktop (`manifest.txt` has `:(glob).hermes/plans/**/*.md` and `briefs/**` only). This is existing behaviour; see R7.
- **Info:** the brief said feature-dispatch is "about 98,157 characters". That is bytes (`wc -c`); the character count Hermes and harness-guards' `ac17` use is 97,894.
