# fable-planner-only: Fable 5.2 high plans, and nothing else (Mini)

Pipeline: **Mini**. Repo: the setup repo `~/.claude-setup.git` (work tree `$HOME`), base `main` at `7ff38333` when planned (`main` has since moved to `9b765a25`, which changed other lines of `leorna/SKILL.md`; the edits and the three tests were re-proven on it). Planned 2026-11-11.

**Questions for Justin:** none. The main session's reading holds in every file.

## Playback

Justin, 2026-11-11: "In the pipeline, only put Fable 5.2 high as the planner and remove it from the rest", then "do reviewer opus 5.5 xhigh and run mini".

Today Fable 5.2 high has two roles: the planner and the round-1 reviewer. After this job it has one. The round-1 reviewer (Full and Mini) moves to **Opus 5.5 xhigh**. Later-round reviewers stay on Opus 5.5 high, and every other role stays as it is.

The routing sentence, word for word in every file that states it:

> planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Opus 5.5 xhigh, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high

## Acceptance criteria (all proposed: the request gave none)

The three tests live in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh` (below: `$T`). Each is run as `bash <worktree>/$T <test name>` and passes when it prints `ok 1 - <test name>`. Nothing here is visual, so the evidence for each is the terminal capture of that run. No `(live)` ACs.

- AC1 (proposed): Given the story's head, when the routing check runs, then every file that states the routing (`CLAUDE.md`, feature-dispatch `SKILL.md`, `mini-pipeline.md`, `review-loop.md`, the `leorna` and `review-fix-cadence` skills, and the Codex `AGENTS.md` built from the checkout) gives round 1 to Opus 5.5 xhigh and Fable 5.2 high to the planner only, and none of the retired wordings is left. Test: `routing_text_agrees`
- AC2 (proposed): Given a copy of the story's head with Fable written onto any role but the planner (the routing sentence, the `CLAUDE.md` pipeline paragraph, a role-table row, a step, or a new sentence about a review, round 1, the AC auditor or the finisher, in a rule file or a project `CLAUDE.md` copy), when the routing check runs on that copy, then it fails and names the wrong place; an unchanged copy passes. Test: `fable_only_plans`
- AC3 (proposed): Given the new wording, when check 7 reads "round 1 on Opus 5.5 xhigh", then it passes; and given a copy of the story's head that puts xhigh on a later round, a fixer, the verifier or the main session, or plain high on round 1, when the routing check runs on that copy, then it fails. Test: `xhigh_only_where_routed`

On the base (`7ff38333` with head's `$T` copied over it) all three fail: `routing_text_agrees` with "lacks the routing sentence", the other two with "an unchanged copy of this checkout fails routing_text_agrees". Proven on the planner's prototype (see "Proof").

## What changes, file by file

All seven files are tracked directly in the setup repo. Paths are `$HOME`-relative; in the worktree they are `<worktree>/<path>`. Line numbers are today's.

| File | Lines | Change |
|---|---|---|
| `.claude/CLAUDE.md` | 15 (pipeline paragraph), 20 (step 5), 98 (Agent models) | `planner` alone gets `model: "fable"`; `builder, round-1 reviewer and AC auditor` get `"opus"`/`"xhigh"`; step 5 says round 1 on Opus 5.5 xhigh; the bullet gets the new sentence, the date `2026-11-11; replaces 2026-11-10` and a `*Why (2026-11-11): …*` note in front of the old Why, which stays |
| `.hermes/skills/autonomous-ai-agents/feature-dispatch/SKILL.md` | 29, 89, 95, 102, 110, 112, 278 | Mini summary, the dated heading, the round-1 table row, the one-line routing with a new Why, the review order, the Effort line ("every reviewer" on high is no longer true), the builder-returns step |
| `…/feature-dispatch/references/mini-pipeline.md` | 16, 22, 28, 38, 40 | Heading date, the round-1 row, the one-line routing, step 3, and one comma in step 5 (see "Check 7") |
| `…/feature-dispatch/references/review-loop.md` | 11 | Round 1 on Opus 5.5 xhigh, date 2026-11-11 |
| `.hermes/skills/software-development/leorna/SKILL.md` | 87, 88 | The routing sentence with its date; "fresh Opus full review 1" |
| `.hermes/skills/software-development/review-fix-cadence/SKILL.md` | 21, 23, 52 | The cadence line, the routing sentence with its date, step 4 |
| `…/feature-dispatch/scripts/pipeline-rules.test.sh` | throughout | The test (next section) |

**Left as they are, on purpose:**
- Lines about the planner: "The Fable planner does the architecture and design" (`SKILL.md` 105), "Preserve Fable planning" (`review-fix-cadence` 23), "Fable plan → …" in the cadence lines, `1. **Planner (Fable 5.2 high).**` and the Planner rows.
- Lines about Fable as a model, not a role: "Only these models" (`SKILL.md` 83), "the held Claude (Opus or Fable) roles" (104), the board example `model="fable-5.2 high"` (109, `mini-pipeline.md` 32), `'claude-fable-5-2'` for a Fable role (114), "Opus or Fable: any role in the table" (`model-routing.md` 9, `mini-pipeline.md` 44), "(Fable 5.2 high or Opus 5.5 xhigh/high, SKILL.md's role table)" (`away-and-recovery.md` 55: still true, the planner is the Fable one), "(Fable and Opus share the Claude subscription)" (`CLAUDE.md` 98).
- Dated history: every `*Why …*` note and "It supersedes the 2026-11-09 table (…)" (`SKILL.md` 89). They say what was true then.
- `scripts/token-report/` and its test: prices and model names, not routing.
- Project `CLAUDE.md` copies (`~/.claude/project-docs/*/CLAUDE.md`): none names a model for a review round. The Figma copy says "each on the model and effort the global routing gives its round", which stays right. So no project file needs an edit and `sync.sh`'s `copy_in` has nothing to undo.
- `~/.hermes/skills-library-local.patch` and the `~/.hermes/skills-library` clone: no routing text in either (checked: no "Fable", no "round 1" routing line), so `save_lib_patch` is not involved.
- `~/.codex/AGENTS.md`: not tracked (sync's deny list), rebuilt from `CLAUDE.md` by `build-codex.sh`. Never hand-edited; see "After acceptance".
- No hook, `sync.sh`, `sync.test.sh` or `codex-parity.test.sh` line pins the routing words (grep for `Fable`, `round-1`, `round 1`, `later-round`, `Agent models`: the only hits are Sol model pins in `codex-parity.test.sh`).

## The test, first

`pipeline-rules.test.sh` changes in six places (the diff is below, complete):

1. `ROUTING` is the new sentence (checks 1 and 8).
2. Check 2: the pipeline paragraph must hold `planner \`model: "fable"\`, \`effort: "high"\`; builder, round-1 reviewer and AC auditor \`model: "opus"\`, \`effort: "xhigh"\`` and must hold `"fable"` exactly once.
3. Check 3: the round-1 row is `**Opus 5.5**` / `**xhigh**`; the Builder, round-1 and AC auditor rows must not name Fable (later rounds, Fixer, Verifier and Finisher already must not).
4. Check 4: the Agent models bullet holds `2026-11-11` as well as `2026-11-10`.
5. Checks 5 and 6: nine retired wordings join `old_phrases`, and the eleven pinned statements that named Fable for a review now pin the Opus wording.
6. **Check 7** gets a second rule beside the old one. Old rule (kept, `Fable` now also matches lowercase `"fable"`): a clause naming a later round, a delta review, round 2, a fixer, the verifier or the main session must not name Fable or xhigh. New rule: a clause naming a review, round 1, the auditor or the finisher must not name Fable. "round 1 on Opus 5.5 xhigh" passes both, because clauses end at `;` and `,`: the round-1 clause holds no later-round word. `Builder` is not in the new rule: "builder" shares a clause with "The Fable planner" in `SKILL.md` 105; the Builder row and the routing sentence guard it instead. One existing line tripped the new rule, "(usually a Fable high re-plan or the Full review order)" in `mini-pipeline.md` 40, so it gets a comma: "(usually a Fable high re-plan, or the Full review order)".

Two new tests, run only when named (their changes name today's wording, so they would fail the next routing story if they ran by default):

- `fable_only_plans`: an unchanged copy of the checkout passes; then twelve copies, each with one change, must fail with the named message: the routing sentence in `leorna` back to Fable; the pipeline paragraph back to "planner and round-1 reviewer"; a second `"fable"` in the paragraph; the round-1 row back to Fable in `SKILL.md` and in `mini-pipeline.md`; Fable in the AC auditor row; step 5 back to Fable; Mini step 3 back to Fable; and four new sentences that no pin knows, so only check 7's new rule can refuse them ("The round 1 review can go to Fable when Opus is busy." in `review-loop.md`, "Reviews of this project run on Fable." in the Figma project copy, "The AC auditor may run on Fable 5.2 high." in `mini-pipeline.md`, "A Fable finisher does the hand-over." in `review-fix-cadence`).
- `xhigh_only_where_routed`: check 7 run directly on the new wording finds nothing, and on "round 1 on Opus 5.5 high, every later round on Opus 5.5 xhigh" finds the later-round clause; an unchanged copy passes; then seven copies must fail: a new sentence putting xhigh on a later round, the fixer, the verifier and the main session; the later-rounds row on xhigh; the round-1 row on plain high; step 5 with round 1 on plain high.

**Mutations of the test itself the builder must show are caught** (in a scratch copy of the worktree, never in the worktree; all six were caught on the planner's prototype):

| Id | Change to `pipeline-rules.test.sh` | Caught by |
|---|---|---|
| Ta | Remove check 7's new rule (the `\|\| (c[i] ~ /[Rr]eview\|…/ && c[i] ~ /[Ff]able/)` half) | `fable_only_plans`: "new-round1: routing_text_agrees still passes" |
| Tb | Old rule: `/[Ff]able\|xhigh/` → `/[Ff]able/` | `xhigh_only_where_routed`: "check 7 lets a later round on xhigh pass" |
| Tc | Remove `-- Fable` from the AC auditor row | `fable_only_plans`: "auditor-row: routing_text_agrees still passes" |
| Td | The `"fable"` count: `= 1` → `-ge 1` | `fable_only_plans`: "second-fable: it failed, but not with" |
| Te | Remove `round 1 on Fable` from `old_phrases` | `fable_only_plans`: "step5: it failed, but not with" |
| Tf | Remove `'**xhigh**'` from the round-1 row | `xhigh_only_where_routed`: "round1-high: routing_text_agrees still passes" |

The tests are light (the whole run took 8 s on the prototype, no big diffs), so no memory cap is needed; the brief's earlyoom rule still applies to any killed command.

## Tasks (builder, Opus 5.5 xhigh)

Skills: `engineering-best-practices`, `test-driven-development`, `mutation-testing-discipline` (the test is the guard here). About 20 minutes. Mini's "more than ~3 source files → escalate" does not apply: six of the seven files get wording only, from one script.

Evidence folder: `~/.hermes/plans/claude-setup/evidence/fable-planner-only/` (`E` below; logs take their folder from that path, never a shared one).

1. **Worktree.** `git --git-dir=$HOME/.claude-setup.git worktree add ~/.claude-setup-wt/fable-planner-only -b fable-planner-only main` (as the earlier setup-repo stories did). Record the base: `git -C ~/.claude-setup-wt/fable-planner-only rev-parse HEAD`. Baseline: `bash ~/.claude-setup-wt/fable-planner-only/$T` prints `ok 1 - routing_text_agrees` (it did on `7ff38333`). If `main` has moved and any old text below is no longer there, the edit script writes nothing and says which: stop and report.
2. **Red.** Save the diff block of "The test diff" to a file and apply it in the worktree: `patch -p1 --dry-run < file`, then `patch -p1 < file`. Run `bash <worktree>/$T routing_text_agrees fable_only_plans xhigh_only_where_routed`: three `not ok` ("lacks the routing sentence"; twice "an unchanged copy of this checkout fails"). Capture to `E/red.log`.
3. **Green.** Save the Python block of "The wording edits" to a file outside the worktree and run `python3 file <worktree>`: it prints `22 edits in 6 files`. Rerun step 2's command: three `ok`. Capture to `E`, one log and one terminal-capture image per AC.
4. **Mutations.** Ta to Tf, each in a fresh scratch copy of the worktree's files, each with the run that catches it. Capture to `E/mutations.log`.
5. **Scope gate and commit.** `git -C <worktree> status --porcelain --untracked-files=all` shows the seven files and nothing else (this repo hides untracked files by default). One commit of exactly those seven: `fable-planner-only: Fable plans only; round 1 reviewed on Opus 5.5 xhigh`. Plain `git commit`, no author override, no AI trailer; `CLAUDE.md` is allowed in this repo. `git -C <worktree> diff --name-only <base> HEAD` lists the seven. Stop at `ready-for-review` with the branch, the base and the head. The builder does not merge, sync or push.

The reviewer diffs `<base>..HEAD` in the worktree. This job's own round-1 reviewer already runs on Opus 5.5 xhigh (Justin's "do reviewer opus 5.5 xhigh").

## After acceptance (not the builder)

- **Finisher (Opus 5.5 high):** rebase on local `main` and, for a pure rebase, the rebase receipt (`ac-verification.md`, "Setup-repo stories": from the finisher's rebase to the merge nobody runs `sync.sh`).
- **Main session:** the `--ff-only` merge of `fable-planner-only` into the setup repo's `main` (`git --git-dir=$HOME/.claude-setup.git merge --ff-only fable-planner-only`), then **Docs & records:** run `~/.claude/setup/sync.sh` once: it rebuilds `~/.codex/AGENTS.md` from the new `CLAUDE.md` and pushes. Check: `bash ~/.claude/setup/codex/build-codex.sh --check` exits 0, `grep -c 'reviewer round 1 Opus 5.5 xhigh, later rounds Opus 5.5 high' ~/.codex/AGENTS.md` prints at least 1, and `bash ~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh` prints `ok 1 - routing_text_agrees` on `$HOME`. The Mac gets it at its next pull.
- The running main session still has the old `CLAUDE.md` loaded: from the merge on it dispatches every round-1 reviewer with `model: "opus"`, `effort: "xhigh"`.

## Risks

- Every reviewer is now on the builder's model family. The second pair of eyes from a different model on round 1 ends with this change; the separate fresh agents and the verifier-then-blind-auditor proofs stay. That is the request, noted so it is a known trade.
- `main` moves with every `sync.sh` from any session. The edit script refuses a file whose old text is not there exactly once, so a moved `main` shows up as a stop, not a wrong edit.
- Skill size: `feature-dispatch/SKILL.md` is 75,904 characters today and grows by about 250 (Hermes' limit is 100,000 a skill), so nothing needs moving to `references/`.

## Proof (planner's prototype, 2026-11-11)

In a `git archive` copy of `7ff38333`, with the two blocks below pulled from this file by a script (one `python` block and one `diff` block, counts asserted) and applied as the tasks say:
- base, the old test: `ok 1 - routing_text_agrees`;
- test diff only: `not ok` for all three tests;
- test diff and wording edits: `ok 1 - routing_text_agrees`, `ok 2 - fable_only_plans` (12 refusals), `ok 3 - xhigh_only_where_routed` (7 refusals);
- Ta to Tf: each caught by the run the table names.

## The wording edits

```python
#!/usr/bin/env python3
"""fable-planner-only: the wording edits. Usage: python3 edits.py <checkout root>
Each old text must be in its file exactly once, or nothing is written."""
import sys, pathlib

root = pathlib.Path(sys.argv[1])
FD = '.hermes/skills/autonomous-ai-agents/feature-dispatch/'
SD = '.hermes/skills/software-development/'
C, S, M, L = '.claude/CLAUDE.md', FD + 'SKILL.md', FD + 'references/mini-pipeline.md', FD + 'references/review-loop.md'
LE, R = SD + 'leorna/SKILL.md', SD + 'review-fix-cadence/SKILL.md'
TAIL = ', later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high'
OLD = 'planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Fable 5.2 high' + TAIL
NEW = 'planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Opus 5.5 xhigh' + TAIL
T1 = ' | **Fable 5.2** | **high** |'
T2 = ' | **Opus 5.5** | **xhigh** |'
ROW_S = '| Reviewer, round 1 (the whole story; separate, fresh), every repo'
ROW_M = '| Reviewer, round 1 (the one full review; separate, fresh, never saw the build)'

EDITS = [
    # ~/.claude/CLAUDE.md
    (C, '(user, 2026-11-10; "Agent models" below): planner and round-1 reviewer `model: "fable"`, `effort: "high"`; builder and AC auditor `model: "opus"`, `effort: "xhigh"`;',
        '(user, 2026-11-11; "Agent models" below): planner `model: "fable"`, `effort: "high"`; builder, round-1 reviewer and AC auditor `model: "opus"`, `effort: "xhigh"`;'),
    (C, 'report only; round 1 on Fable 5.2 high, every later round', 'report only; round 1 on Opus 5.5 xhigh, every later round'),
    (C, '- **Agent models (user, 2026-11-10; replaces 2026-11-09):** ' + OLD + '. Each role is a fresh agent. *Why: in the stories',
        '- **Agent models (user, 2026-11-11; replaces 2026-11-10):** ' + NEW + '. Each role is a fresh agent. *Why (2026-11-11): the user asked for Fable 5.2 high as the planner only ("only put Fable 5.2 high as the planner and remove it from the rest") and for the first review on Opus 5.5 xhigh ("do reviewer opus 5.5 xhigh").* *Why (2026-11-10): in the stories'),
    # feature-dispatch/SKILL.md
    (S, 'one full fresh Fable review, then', 'one full fresh Opus review, then'),
    (S, 'the pipeline-token-diet plan).** This applies',
        'the pipeline-token-diet plan; 2026-11-11: Fable only plans, and round 1 is reviewed on Opus 5.5 xhigh).** This applies'),
    (S, ROW_S + T1, ROW_S + T2),
    (S, 'In one line: ' + OLD + '. *Why (2026-11-10):',
        'In one line: ' + NEW + '. *Why (2026-11-11): Justin: "only put Fable 5.2 high as the planner and remove it from the rest", then "do reviewer opus 5.5 xhigh".* *Why (2026-11-10):'),
    (S, '(round 1 reviewed on Fable 5.2 high, later rounds on', '(round 1 reviewed on Opus 5.5 xhigh, later rounds on'),
    (S, '(xhigh for builder and AC auditor; high for planner, every reviewer, fixer, verifier and finisher)',
        '(xhigh for builder, the round-1 reviewer and AC auditor; high for planner, later-round reviewers, fixer, verifier and finisher)'),
    (S, 'a fresh **Fable 5.2 high full review**', 'a fresh **Opus 5.5 xhigh full review**'),
    # feature-dispatch/references/mini-pipeline.md
    (M, '## Roles (Justin, 2026-11-10: same routing as Full)', '## Roles (Justin, 2026-11-11: same routing as Full)'),
    (M, ROW_M + T1, ROW_M + T2),
    (M, 'In one line: ' + OLD + '.', 'In one line: ' + NEW + '.'),
    (M, '3. **Reviewer (fresh Fable 5.2 high).**', '3. **Reviewer (fresh Opus 5.5 xhigh).**'),
    (M, '(usually a Fable high re-plan or the Full review order)', '(usually a Fable high re-plan, or the Full review order)'),
    # feature-dispatch/references/review-loop.md
    (L, '- Round 1 is reviewed by a fresh Fable 5.2 high agent;', '- Round 1 is reviewed by a fresh Opus 5.5 xhigh agent;'),
    (L, 'by a fresh Opus 5.5 high agent (2026-11-10, `SKILL.md` role table)', 'by a fresh Opus 5.5 high agent (2026-11-11, `SKILL.md` role table)'),
    # leorna/SKILL.md
    (LE, '- **Models by role (Justin, 2026-11-10):** each role is a fresh agent: ' + OLD,
         '- **Models by role (Justin, 2026-11-11):** each role is a fresh agent: ' + NEW),
    (LE, '  - fresh Fable full review 1 →', '  - fresh Opus full review 1 →'),
    # review-fix-cadence/SKILL.md
    (R, '(Justin, 2026-11-10 routing; 2026-10-28: loop until clean): **Fable plan → user go → Opus build → fresh Fable full review 1 →',
        '(Justin, 2026-11-11 routing; 2026-10-28: loop until clean): **Fable plan → user go → Opus build → fresh Opus full review 1 →'),
    (R, 'on the 2026-11-10 routing: ' + OLD, 'on the 2026-11-11 routing: ' + NEW),
    (R, 'Round 1 is a fresh Fable 5.2 high reviewer;', 'Round 1 is a fresh Opus 5.5 xhigh reviewer;'),
]

texts, bad = {}, []
for f, old, new in EDITS:
    t = texts.get(f)
    if t is None:
        t = (root / f).read_text(encoding='utf-8')
    if t.count(old) != 1:
        bad.append('%s: want 1, found %d: [%s]' % (f, t.count(old), old[:70]))
    texts[f] = t.replace(old, new)
if bad:
    sys.exit('nothing written:\n' + '\n'.join(bad))
for f, t in texts.items():
    (root / f).write_text(t, encoding='utf-8')
print('%d edits in %d files' % (len(EDITS), len(texts)))
```

## The test diff

Apply from the worktree root with `patch -p1`.

```diff
--- a/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh
+++ b/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/pipeline-rules.test.sh
@@ -12,6 +12,10 @@
 # Everything under test comes from this file's own checkout (the story worktree, or $HOME once merged),
 # never from the live ~/.claude, ~/.hermes or ~/.codex. The Codex copy is built into a fresh mktemp -d
 # folder (under $TMPDIR).
+# Story fable-planner-only (2026-11-11, ~/.hermes/plans/claude-setup/fable-planner-only.md): Fable 5.2 is the
+# planner only, and round 1 is reviewed on Opus 5.5 xhigh. Its two tests, fable_only_plans and
+# xhigh_only_where_routed, change one thing in a copy of this checkout and want routing_text_agrees to refuse
+# it. Their changes name today's wording, so they run only when named.
 set -uo pipefail
 HERE=$(cd "$(dirname "$0")" && pwd)
 SRC=$(cd "$HERE/../../../../.." && pwd)     # the checkout root ($HOME-relative layout)
@@ -22,7 +26,7 @@
 SD=.hermes/skills/software-development
 CLAUDE_MD=.claude/CLAUDE.md
 # the routing sentence ("The chosen set" in the plan); every file that states the routing carries it word for word
-ROUTING='planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Fable 5.2 high, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high'
+ROUTING='planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Opus 5.5 xhigh, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high'
 # every file of "Where the rules are stated" (the Codex copy is built from CLAUDE.md and checked apart)
 RULE_FILES="$CLAUDE_MD
 $FD/SKILL.md
@@ -61,6 +65,15 @@
 fresh Fable full review 2
 Use a fresh Fable 5.2 high reviewer
 model: Fable 5.2 high, a fresh agent
+round 1 on Fable
+round-1 reviewer `model: "fable"`
+reviewer round 1 Fable
+one full fresh Fable review
+fresh Fable full review 1
+Fable 5.2 high full review
+fresh Fable 5.2 high
+reviewed on Fable
+every reviewer, fixer, verifier and finisher
 Sol 6.1 xhigh review, fixes, then Opus 5.5 xhigh review
 Opus 5.5 at high effort for every role
 not by lowering effort
@@ -90,20 +103,20 @@
 claude|The pipeline main session itself runs on Opus 5.5 high (step 1 checks it).
 claude|past 300k with nothing running, asks once per quiet spell for a fresh session
 claude|when that isn't Opus 5.5 high, ask in the same question for `/model opus` and `/effort high` before anything is dispatched
-claude|report only; round 1 on Fable 5.2 high, every later round on Opus 5.5 high)
+claude|report only; round 1 on Opus 5.5 xhigh, every later round on Opus 5.5 high)
 claude|(to the round-3 question, "fix" → `"continue": true`; "follow-up" → `"accept"` with those ids, and their lines go to `<evidence>/follow-ups.md`)
 claude|so is, from round 3, a round with only P2 left (fix or follow-up?). No round cap, but the user is asked from round 3 before a P2-only round is fixed.
 claude|if HEAD now differs from the head `ac-check.sh` accepted and the rebase resolved no conflict, the finisher also reruns every agent-run AC's test on the new head into a rebase receipt
 claude|on a pure rebase of the accepted head it accepts the earlier reports, with no new verifier or auditor. Anything else (a rebase that resolved conflicts, a `REBASE  NOT ACCEPTED` line) takes the full path
 claude|with no cap, but from round 3 a round with only P2 left asks the user: fix or follow-up.
 claude|**After a pure rebase (user, 2026-11-10):** a rebase receipt, not a new verifier and auditor.
-fd|Mini (Fable plan, Opus build, one full fresh Fable review, then the same loop of reviews of the fixes)
+fd|Mini (Fable plan, Opus build, one full fresh Opus review, then the same loop of reviews of the fixes)
 fd|The Fable planner does the architecture and design
-fd|no round cap (from round 3 a round with only P2 left asks Justin: fix or follow-up?), each role on the role table (round 1 reviewed on Fable 5.2 high, later rounds on Opus 5.5 high, fixes on Opus 5.5 high)
+fd|no round cap (from round 3 a round with only P2 left asks Justin: fix or follow-up?), each role on the role table (round 1 reviewed on Opus 5.5 xhigh, later rounds on Opus 5.5 high, fixes on Opus 5.5 high)
 fd|Fixers and the verifier run on Opus 5.5 high, the AC auditor on Opus 5.5 xhigh (Justin, 2026-11-10).
-fd|(xhigh for builder and AC auditor; high for planner, every reviewer, fixer, verifier and finisher)
+fd|(xhigh for builder, the round-1 reviewer and AC auditor; high for planner, later-round reviewers, fixer, verifier and finisher)
 fd|  - model: Opus 5.5 high, a fresh agent. Board → `verifying`.
-fd|dispatch round 1 of the review loop, a fresh **Fable 5.2 high full review**
+fd|dispatch round 1 of the review loop, a fresh **Opus 5.5 xhigh full review**
 fd|**REVIEW AGAIN** → an **Opus 5.5 high FIXER now**
 fd|then the next fresh review, on Opus 5.5 high (Full: round 2 is full;
 fd|to the round-3 question ("only P2 left from round 3 on") his "fix" is `"continue": true` and "follow-up" is `"accept"` with those ids
@@ -111,15 +124,15 @@
 fd|A pure rebase (the same patches in the same order, no merges: `ac-check.sh`'s test) needs no new verifier or auditor on any story since 2026-11-10
 mini|1. **Planner (Fable 5.2 high).**
 mini|2. **Builder (Opus 5.5 xhigh).**
-mini|3. **Reviewer (fresh Fable 5.2 high).** Round 1 of the review loop
+mini|3. **Reviewer (fresh Opus 5.5 xhigh).** Round 1 of the review loop
 mini|**REVIEW AGAIN** → an Opus 5.5 high finisher fixes the listed P0–P2
 mini|a fresh Opus 5.5 high delta reviewer (review only
 mini|from round 3 (in Mini, the review of the second fix) a round with only P2 left asks too: his "fix" → `"continue": true`, "follow-up" → `"accept"`
 mini|a pure rebase gets a rebase receipt and `ac-check.sh --rebase-receipt` (`ac-verification.md`), not a new verifier and auditor; a rebase that resolved conflicts takes the full path
 mini|no round cap, but Justin is asked from round 3 when only P2 is left
-mini|(usually a Fable high re-plan or the Full review order)
+mini|(usually a Fable high re-plan, or the Full review order)
 mini|each role runs on Full's model and effort
-loop|- Round 1 is reviewed by a fresh Fable 5.2 high agent; every later round (Full's whole-story round 2, the delta rounds, a full round the referee asks for) by a fresh Opus 5.5 high agent
+loop|- Round 1 is reviewed by a fresh Opus 5.5 xhigh agent; every later round (Full's whole-story round 2, the delta rounds, a full round the referee asks for) by a fresh Opus 5.5 high agent
 loop|"fix" → `{"words": "<his reply>", "continue": true}`, so REVIEW AGAIN
 loop|"follow-up" → `{"words": "<his reply>", "accept": ["R3-1", "R3-2"]}`, so those count as ACCEPTED
 loop|brake e (from round 3, only P2 left: the line ends `only P2 left from round 3 on (<ids>): fix or follow-up?`
@@ -132,10 +145,10 @@
 house|a pipeline main session runs on Opus 5.5 high. At step 1 it says which model and effort it is on and, when they differ, asks for `/model opus` and `/effort high`
 house|Past 300k tokens with no agent running, it asks once per quiet spell for a fresh session
 away|(Fable 5.2 high or Opus 5.5 xhigh/high, SKILL.md's role table)
-leorna|  - fresh Fable full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until `review-check.sh` prints MOVE ON (`review-fix-cadence`; `feature-dispatch` references/review-loop.md) → fresh Opus verifier → blind Opus auditor → `ac-check.sh --reviews`;
-rfc|**Fable plan → user go → Opus build → fresh Fable full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until a review is clean (`review-check.sh`: MOVE ON) → fresh Opus verifier → blind Opus auditor → `ac-check.sh --reviews`
+leorna|  - fresh Opus full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until `review-check.sh` prints MOVE ON (`review-fix-cadence`; `feature-dispatch` references/review-loop.md) → fresh Opus verifier → blind Opus auditor → `ac-check.sh --reviews`;
+rfc|**Fable plan → user go → Opus build → fresh Opus full review 1 → fresh Opus fixer → fresh Opus full review 2 → fresh Opus fixer → fresh Opus review of the fix commits → … until a review is clean (`review-check.sh`: MOVE ON) → fresh Opus verifier → blind Opus auditor → `ac-check.sh --reviews`
 rfc|**Dispatch a scoped fresh Opus fix promptly
-rfc|Round 1 is a fresh Fable 5.2 high reviewer; every later round a fresh Opus 5.5 high reviewer.
+rfc|Round 1 is a fresh Opus 5.5 xhigh reviewer; every later round a fresh Opus 5.5 high reviewer.
 rfc|**Use a fresh Opus fixer for each `REVIEW AGAIN` list**
 rfc|Returned actionable blockers advance to a fresh Opus fixer
 rfc|  - (e) from round 3, a round with only P2 left (no P0 or P1) → ASK JUSTIN: fix (`"continue": true`) or follow-up (`"accept"`, and the lines go to `follow-ups.md`) (Justin, 2026-11-10).
@@ -149,7 +162,8 @@
 EOF
 }
 wrong_pairs() { # wrong_pairs <file>…: each clause that pairs a later round, a delta review, a fixer, the verifier or
-                # the main session with Fable or xhigh. Dated history is left out: *Why …* notes, *(Superseded …)*
+                # the main session with Fable or xhigh, or a review, round 1, the auditor or the finisher with
+                # Fable (the planner is Fable's only role). Dated history is left out: *Why …* notes, *(Superseded …)*
                 # notes and "supersedes the <date> table (…)". Clauses end at ; , ( ) | → and ". ".
   # A wrapped line (indented, not a list item or table row) is read with the line it continues.
   awk 'function check(l, at,   c, n, i) {
@@ -157,7 +171,8 @@
     gsub(/supersedes the [0-9-]+ table \([^)]*\)/, "", l)
     n = split(l, c, /[;,()|]|→|\. /)
     for (i = 1; i <= n; i++)
-      if (c[i] ~ /[Ll]ater[ -]rounds?|[Dd]elta|round 2|[Ff]ixe[rs]|[Vv]erifier|main session/ && c[i] ~ /Fable|xhigh/)
+      if ((c[i] ~ /[Ll]ater[ -]rounds?|[Dd]elta|round 2|[Ff]ixe[rs]|[Vv]erifier|main session/ && c[i] ~ /[Ff]able|xhigh/) ||
+          (c[i] ~ /[Rr]eview|[Rr]ound[ -]?1|[Aa]uditor|[Ff]inisher/ && c[i] ~ /[Ff]able/))
         print at ": [" c[i] "]"
   }
   FNR == 1 { if (buf != "") check(buf, at); buf = "" }
@@ -213,19 +228,20 @@
   # 2. the Agent tool's values in CLAUDE.md's pipeline paragraph
   t=$(one $CLAUDE_MD '**The pipeline.**') || { echo "$t"; return 1; }
   holds "CLAUDE.md's **The pipeline.** paragraph" "$t" \
-    'planner and round-1 reviewer `model: "fable"`, `effort: "high"`' \
-    'builder and AC auditor `model: "opus"`, `effort: "xhigh"`' \
+    'planner `model: "fable"`, `effort: "high"`; builder, round-1 reviewer and AC auditor `model: "opus"`, `effort: "xhigh"`' \
     'later-round reviewers, fixers, verifier and finisher `model: "opus"`, `effort: "high"`' || return 1
+  [ "$(printf '%s\n' "$t" | grep -o '"fable"' | grep -c '^')" = 1 ] \
+    || { fail "CLAUDE.md's **The pipeline.** paragraph gives \"fable\" to more than the planner"; return 1; }
   echo "# 2. CLAUDE.md's pipeline paragraph gives each role its model: and effort: values"
   # 3. the two role tables
   for f in $FD/SKILL.md $FD/references/mini-pipeline.md; do
     row "$f" Planner '**Fable 5.2**' '**high**' || return 1
-    row "$f" Builder '**Opus 5.5**' '**xhigh**' || return 1
-    row "$f" 'Reviewer, round 1' '**Fable 5.2**' '**high**' || return 1
+    row "$f" Builder '**Opus 5.5**' '**xhigh**' -- Fable || return 1
+    row "$f" 'Reviewer, round 1' '**Opus 5.5**' '**xhigh**' -- Fable || return 1
     row "$f" 'Reviewer, later rounds' '**Opus 5.5**' '**high**' -- xhigh Fable || return 1
     row "$f" Fixer '**Opus 5.5**' '**high**' -- xhigh Fable || return 1
     row "$f" Verifier '**Opus 5.5**' '**high**' -- xhigh Fable || return 1
-    row "$f" 'AC auditor' '**Opus 5.5**' '**xhigh**' || return 1
+    row "$f" 'AC auditor' '**Opus 5.5**' '**xhigh**' -- Fable || return 1
   done
   row $FD/SKILL.md Finisher '**Opus 5.5**' 'high' -- xhigh Fable || return 1
   echo "# 3. the role tables of SKILL.md and mini-pipeline.md give every role its model and effort"
@@ -235,7 +251,7 @@
   t=$(one $CLAUDE_MD '7. **Finish:**') || { echo "$t"; return 1; }
   holds "CLAUDE.md step 7" "$t" '--rebase-receipt' 'pure rebase' || return 1
   t=$(one $CLAUDE_MD '- **Agent models') || { echo "$t"; return 1; }
-  holds "CLAUDE.md's Agent models bullet" "$t" '2026-11-10' || return 1
+  holds "CLAUDE.md's Agent models bullet" "$t" '2026-11-10' '2026-11-11' || return 1
   holds "CLAUDE.md" "$(cat "$SRC/$CLAUDE_MD")" '300k' || return 1
   holds "main-chat-housekeeping.md" "$(cat "$SRC/$FD/references/main-chat-housekeeping.md")" '300k' || return 1
   holds "review-loop.md" "$(cat "$SRC/$FD/references/review-loop.md")" 'only P2 left from round 3 on' 'follow-up' || return 1
@@ -243,7 +259,7 @@
   holds "mini-pipeline.md" "$(cat "$SRC/$FD/references/mini-pipeline.md")" '--rebase-receipt' 'only P2' || return 1
   t=$(one $SD/review-fix-cadence/SKILL.md '  - (e)') || { echo "$t"; return 1; }
   holds "review-fix-cadence's brake (e)" "$t" 'only P2' || return 1
-  echo "# 4. the round-3 question, the rebase receipt, the 2026-11-10 date and the 300k rule are stated"
+  echo "# 4. the round-3 question, the rebase receipt, the 2026-11-10 and 2026-11-11 dates and the 300k rule are stated"
   # 5. no older pairing or replaced rule is left, in a rule file or a project's CLAUDE.md copy
   for f in $(scan_files); do   # read flat, so a phrase wrapped over two lines is still found
     t=$(flat "$SRC/$f")
@@ -265,10 +281,11 @@
 EOF
   [ $bad = 0 ] || return 1
   echo "# 6. the $(prose | grep -c '^') prose statements of a role's model, effort or changed rule read as pinned"
-  # 7. no clause anywhere else pairs a later round, a fixer, the verifier or the main session with Fable or xhigh
+  # 7. no clause anywhere else pairs a later round, a fixer, the verifier or the main session with Fable or xhigh,
+  #    or a review, round 1, the auditor or the finisher with Fable
   p=$(cd "$SRC" && wrong_pairs $(scan_files))
   [ -z "$p" ] || { fail "a role paired with the wrong model or effort: $p"; return 1; }
-  echo "# 7. no rule file or project CLAUDE.md copy pairs a later round, a fixer, the verifier or the main session with Fable or xhigh"
+  echo "# 7. no rule file or project CLAUDE.md copy pairs a later round, a fixer, the verifier or the main session with Fable or xhigh, or a review, round 1, the auditor or the finisher with Fable"
   # 8. the Codex copy, built from this checkout's CLAUDE.md and header
   S=$(mktemp -d "${TMPDIR:-/tmp}/pipeline-rules-test.XXXXXX") || { fail "mktemp"; return 1; }
   CODEX_HOME="$S/codex" CODEX_BUILD_RULES="$SRC/$CLAUDE_MD" bash "$SRC/.claude/setup/codex/build-codex.sh" \
@@ -289,6 +306,96 @@
   rm -rf "$S"
 }
 
+# ---- story fable-planner-only: routing_text_agrees refuses a wrong pairing (these run only when named) ----
+copy_checkout() { # copy_checkout <to>: the files routing_text_agrees reads, in this checkout's layout
+  local f
+  mkdir -p "$1/.claude/setup" && cp -R "$SRC/.claude/setup/codex" "$1/.claude/setup/" || return 1
+  for f in $(scan_files) "$FD/scripts/pipeline-rules.test.sh"; do
+    mkdir -p "$1/$(dirname "$f")" && cp "$SRC/$f" "$1/$f" || return 1
+  done
+}
+swap() { # swap <file> <old> <new>: replace the one place the file has <old> (fails when it has none or several)
+  OLD=$2 NEW=$3 awk 'BEGIN { o = ENVIRON["OLD"]; w = ENVIRON["NEW"] }
+    { l = $0; out = ""
+      while ((i = index(l, o)) > 0) { out = out substr(l, 1, i - 1) w; l = substr(l, i + length(o)); n++ }
+      print out l }
+    END { exit n == 1 ? 0 : 1 }' "$1" >"$1.swap" && mv "$1.swap" "$1"
+}
+add() { printf '%s\n' "$2" >>"$1"; }   # add <file> <line>: one more line at the end of the file
+copy_passes() { # an unchanged copy passes: so each refusal below comes from its one change
+  local out
+  copy_checkout "$S/unchanged" || { fail "could not copy the checkout to $S/unchanged"; return 1; }
+  out=$(bash "$S/unchanged/$FD/scripts/pipeline-rules.test.sh" routing_text_agrees 2>&1) \
+    || { fail "an unchanged copy of this checkout fails routing_text_agrees: $out"; return 1; }
+  echo "# an unchanged copy of this checkout passes routing_text_agrees"
+}
+refuses() { # refuses <name> <want> <swap|add> <file> <args…>: a copy of this checkout with that one change fails
+            # routing_text_agrees, and the failure names <want>
+  local name=$1 want=$2 how=$3 f=$4 out; shift 4
+  copy_checkout "$S/$name" || { fail "$name: could not copy the checkout to $S/$name"; return 1; }
+  "$how" "$S/$name/$f" "$@" || { fail "$name: the change did not apply to $f"; return 1; }
+  if out=$(bash "$S/$name/$FD/scripts/pipeline-rules.test.sh" routing_text_agrees 2>&1); then
+    fail "$name: routing_text_agrees still passes with [$*] in $f"; return 1
+  fi
+  case $out in
+    *"$want"*) echo "# refused, $name: $want" ;;
+    *) fail "$name: it failed, but not with [$want]: $out"; return 1 ;;
+  esac
+}
+WRONG='a role paired with the wrong model or effort'
+R1_S='(the whole story; separate, fresh), every repo | **Opus 5.5** | **xhigh** |'
+
+fable_only_plans() { # AC2: Fable on any role but the planner is refused, wherever it is written
+  S=$(mktemp -d "${TMPDIR:-/tmp}/pipeline-rules-test.XXXXXX") || { fail "mktemp"; return 1; }
+  copy_passes || return 1
+  refuses sentence 'lacks the routing sentence' swap $SD/leorna/SKILL.md \
+    'reviewer round 1 Opus 5.5 xhigh, later rounds' 'reviewer round 1 Fable 5.2 high, later rounds' || return 1
+  refuses paragraph "CLAUDE.md's **The pipeline.** paragraph lacks" swap $CLAUDE_MD \
+    'planner `model: "fable"`, `effort: "high"`; builder, round-1 reviewer and AC auditor' \
+    'planner and round-1 reviewer `model: "fable"`, `effort: "high"`; builder and AC auditor' || return 1
+  refuses second-fable 'gives "fable" to more than the planner' swap $CLAUDE_MD \
+    'The pipeline main session itself runs on Opus 5.5 high (step 1 checks it).' \
+    'A second reviewer may use `model: "fable"`. The pipeline main session itself runs on Opus 5.5 high (step 1 checks it).' || return 1
+  refuses table 'row [| Reviewer, round 1] lacks [**Opus 5.5**]' swap $FD/SKILL.md \
+    "$R1_S" '(the whole story; separate, fresh), every repo | **Fable 5.2** | **high** |' || return 1
+  refuses mini-table 'row [| Reviewer, round 1] lacks [**Opus 5.5**]' swap $FD/references/mini-pipeline.md \
+    'never saw the build) | **Opus 5.5** | **xhigh** |' 'never saw the build) | **Fable 5.2** | **high** |' || return 1
+  refuses auditor-row 'row [| AC auditor] still has [Fable]' swap $FD/SKILL.md \
+    "never saw the build or the verifier's report | **xhigh** |" "never saw the build or the verifier's report, Fable 5.2 as a fallback | **xhigh** |" || return 1
+  refuses step5 'still has the old [round 1 on Fable]' swap $CLAUDE_MD \
+    'round 1 on Opus 5.5 xhigh, every later round' 'round 1 on Fable 5.2 high, every later round' || return 1
+  refuses mini-step3 'still has the old [fresh Fable 5.2 high]' swap $FD/references/mini-pipeline.md \
+    '3. **Reviewer (fresh Opus 5.5 xhigh).**' '3. **Reviewer (fresh Fable 5.2 high).**' || return 1
+  refuses new-round1 "$WRONG" add $FD/references/review-loop.md '- The round 1 review can go to Fable when Opus is busy.' || return 1
+  refuses new-review "$WRONG" add .claude/project-docs/figma-to-bricks/CLAUDE.md 'Reviews of this project run on Fable.' || return 1
+  refuses new-auditor "$WRONG" add $FD/references/mini-pipeline.md 'The AC auditor may run on Fable 5.2 high.' || return 1
+  refuses new-finisher "$WRONG" add $SD/review-fix-cadence/SKILL.md 'A Fable finisher does the hand-over.' || return 1
+  rm -rf "$S"
+}
+
+xhigh_only_where_routed() { # AC3: round 1 on xhigh passes; xhigh on a later round, fixer, verifier or main session is refused
+  local p
+  S=$(mktemp -d "${TMPDIR:-/tmp}/pipeline-rules-test.XXXXXX") || { fail "mktemp"; return 1; }
+  printf '%s\n' "In one line: $ROUTING." 'report only; round 1 on Opus 5.5 xhigh, every later round on Opus 5.5 high)' \
+    'Round 1 is a fresh Opus 5.5 xhigh reviewer; every later round a fresh Opus 5.5 high reviewer.' >"$S/right.md"
+  p=$(wrong_pairs "$S/right.md"); [ -z "$p" ] || { fail "check 7 refuses the round-1 xhigh wording: $p"; return 1; }
+  printf '%s\n' 'report only; round 1 on Opus 5.5 high, every later round on Opus 5.5 xhigh)' >"$S/wrong.md"
+  p=$(wrong_pairs "$S/wrong.md"); [ -n "$p" ] || { fail "check 7 lets a later round on xhigh pass"; return 1; }
+  echo "# check 7 passes round 1 on xhigh and refuses: $p"
+  copy_passes || return 1
+  refuses later-round "$WRONG" add $FD/references/review-loop.md '- A later round can be reviewed on Opus 5.5 xhigh.' || return 1
+  refuses fixer "$WRONG" add $SD/review-fix-cadence/SKILL.md 'The fixer runs on Opus 5.5 xhigh.' || return 1
+  refuses verifier "$WRONG" add $FD/references/mini-pipeline.md 'The verifier runs on Opus 5.5 xhigh.' || return 1
+  refuses main-session "$WRONG" add $CLAUDE_MD 'The pipeline main session may run on Opus 5.5 xhigh.' || return 1
+  refuses later-row 'row [| Reviewer, later rounds] lacks [**high**]' swap $FD/references/mini-pipeline.md \
+    '| **Opus 5.5**, a fresh one per round | **high** |' '| **Opus 5.5**, a fresh one per round | **xhigh** |' || return 1
+  refuses round1-high 'row [| Reviewer, round 1] lacks [**xhigh**]' swap $FD/SKILL.md \
+    "$R1_S" '(the whole story; separate, fresh), every repo | **Opus 5.5** | **high** |' || return 1
+  refuses step5-high 'lacks [report only; round 1 on Opus 5.5 xhigh' swap $CLAUDE_MD \
+    'round 1 on Opus 5.5 xhigh, every later round' 'round 1 on Opus 5.5 high, every later round' || return 1
+  rm -rf "$S"
+}
+
 # ---- the regression run: every existing suite passes on head as it did on the base, test by test ----
 oknames() { sed -nE 's/^ok( [0-9]+)? +- (.*)$/\2/p' "$@" | LC_ALL=C sort -u; }   # the tests a log shows passing
 last_of() { awk 'NF { l = $0 } END { print l }' "$1"; }
```
