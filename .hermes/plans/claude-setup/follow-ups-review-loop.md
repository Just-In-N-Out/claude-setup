# review-loop: follow-ups (P3s left out of scope)

From review 1 (2026-10-29):
- **R1-3:** the pure-rebase check is inconsistent for in-place rewrites (it fails closed): take the reviewed side from `merge-base(reviewed head, --base)`.
- **R1-6:** the REVIEW AGAIN message doesn't say whether the fixer has already committed. Add "HEAD has <k> commit(s) since <sha7>".
- **R1-7 (design question for Justin):** a repeat of an accepted finding with a new fact and a higher severity gives MOVE ON without asking. Should it count at its own severity?
- **R1-8:** the FigmaToBricksV2 repo's own CLAUDE.md still describes two reviews and a finish step that re-verifies without reviewing. Edit it in that repo (on the Mac).

From fixer 1:
- AC16's heredoc-in-`$(` check reads one line at a time, so it misses a heredoc in a `$(` opened on an earlier line, and a `case` inside `$(`. The strict scan (`fix-1/comsub32_all.py`) catches both but isn't in the suite.
- `review-fix-cadence` SKILL.md:32 says "(Mini: round 1); from round 3" without "(Mini: round 2)". It's implied, but worth spelling out.

From review 2:
- R2-2: the R1-4 fix silences git's stderr and always blames the git version. Capture git's first stderr line into the `error:` line, and pin diff-tree's `2>/dev/null` with a test (mutant R2M1 survived).

From fixer 2:
- In the rare sync-rewrite case, the finisher's rebase still costs one extra delta review: `pids` compares `merge-base..RH`, which includes B0, with `--base..HEAD`. A possible fix is to drop reviewed patches that are already upstream, as `git cherry` does.

Round 3: brake c fired. It was answered under Justin's "keep pushing and doing everything" (`review-3/justin.json`); the finding is R3-1, a P2.

From review 4 (clean at aff26c8). P3s:
- **R4-1:** `review-loop.md:47` says a gone `from` gives REVIEW AGAIN. That's true only for an earlier full round; when the latest round is the full one, it exits 2 ("not a commit"). This needs `git gc` to prune the base, so it's rare.
- **R4-2:** CLAUDE.md step 5, feature-dispatch `SKILL.md:345/360` and `review-fix-cadence:32` don't mention the "run a full review from `<base>`" exception to delta rounds. Add "(unless review-check.sh says run a full review from <base>)".
- **MR4 survived:** git's `fatal:` line from `merge-base --is-ancestor` on a gone `from` isn't silenced or tested. It's cosmetic.

From review 5 (the second full review, at aff26c8): R5-1 (P2), plus R5-2 through R5-7. The R5 P3s, R4-1 and R4-2 go to fixer 4.
- **Info:** AC18 on the Mac uses Apple's `/usr/bin/git`. `patch-id --verbatim` needs git 2.39 or later, so check `/usr/bin/git --version` if the pure-rebase rows exit 2.
- **jq 1.6 was never run,** only checked by reading the code; Docker has jq 1.8.2.

From fixer 4:
- **Full vs Mini:** the referee still can't tell a Full story from a Mini one, so a delta round 2 recorded by mistake in Full still ends MOVE ON. Enforcing it needs a pipeline field in the records (offered on `enforce-backlog.md`).

From review 6 (clean at aba3093). P3s:
- **R6-1:** `mini-pipeline.md:36` (Mini step 4) and `review-fix-cadence:51` (procedure step 4) still give the delta default with no "run a full review from <base>" exception. `review-fix-cadence:51` also lacks the Mini exception.
- **R6-2:** `review-fix-cadence:32` says "anything else a delta reviewer notices is P3", which doesn't match `review-loop.md:11`, where a rejected P0–P2 is re-raised at its severity.

From verifier 1 (clean at aba3093):
- **V1-1 (P3):** AC8's "blank `file_line` or `claim` exits 2" has no test case (mutant M1 survives). Add `bad '.findings[0].claim = "   "'` and the same for `file_line`.
- **Docs:** the `ac-check.sh` usage line leaves out `--reviews`, on purpose for AC11. The header documents it.

From the blind auditor (clean at aba3093). P3s:
- **A-1:** a pure-rebase empty commit is compared by its subject (`%s`), not the whole message, as AC7 words it. Use `%B`, or align the wording.
- **A-2:** AC2's "a run of control characters prints as one space" is untested (mutant M1 survives). Add a CR-LF case.
- **A-3:** AC16's here-document scan is one line at a time (a multi-line `x=$(` then `cat <<'EOF'` survives); same as fixer 1's note.
- **Info:** `git merge main` onto a reviewed head gives a delta range that includes `main`'s own commits. The plan's flow rebases, so this is only noise.

From review 7 (clean at aae49fd, the rebase). P3s:
- **R7-1:** AC12 can't tell a wrong resolution of the `ac-verification.md` step 1–2 or CLAUDE.md "Every brief" conflicts from the right one. Pin step 1's "only after review-check.sh prints MOVE ON" clause and step 2's "a fresh review of that fix".
- **R7-2:** CLAUDE.md's "Several jobs at once" second-job mode doesn't say which copy `--repo` is for `review-check.sh` and `ac-check.sh`: the copy holding the job's latest commit.
- **Info:** `main`'s feature-dispatch `SKILL.md` alone is 98,422 characters. This story's move to `references/` leaves room (93,766).

From finisher round 2 (2026-10-29 ~11:45):
- **"Pure rebase" is too strict.** The referee compares `git patch-id --verbatim`, which hashes context lines, so a conflict-free rebase that changes no story `+`/`-` line still gets REVIEW AGAIN when `main` edited text within 3 lines of a story hunk.
  - **Fix options:** compare context-free patch-ids (`git diff -U0 | git patch-id`) for the pure-rebase test, or name the differing commit and say "context only".
  - **Docs:** add this to `review-loop.md`'s MOVE ON bullet after the merge. Don't edit story files before then.
- **The REVIEW AGAIN line doesn't name the commit whose patch differs.**

From review 8 (clean at 25c2f3c):
- **R8-1 (P3, repeats R7-1):** patch 9's Report-bullet clause "(without `--reviews`: …)" in `ac-verification.md` is pinned by no test (mutant M8d survives). Pin it in ac12 together with R7-1.

From pipeline-token-diet (2026-11-10, the builder, plan task 5: outside notes and the cuts left out):
- **FigmaToBricksV2's `CLAUDE.md` size:** every Figma agent loads it (56.7 KB today, 82 KB median over the measured window); each 10 KB cut is about 0.7% of a Figma story's tokens.
- **The Adobe plugin's skill listing:** 11.3 KB of the 30 KB skill listing, about 0.7% of every agent; Justin can switch it off with `/plugin` if he doesn't use it in Claude Code (it is not in `settings.json`'s `enabledPlugins`).
- **L1 (left out 2026-11-10):** a slim agent type for pipeline roles (no `Artifact` or `Agent` tool, no MCP or agent lists): up to about 4% of agent tokens, to confirm with a probe.
- **L2 (left out 2026-11-10):** skill loads by role (`engineering-best-practices` only for planner, builder and fixer; `mutation-testing-discipline` only when the plan tags a guard AC): about 1.5%.
- **L3 (left out 2026-11-10):** a brief rule that output over about 60 lines goes to a log file in the evidence folder and the agent prints the tail and the pass/fail counts: about 3%.
- **L4 (left out 2026-11-10):** a brief rule that a command expected to run over 4 minutes runs in the background and is checked before 5 minutes pass: about 2%.
- **L5 (left out 2026-11-10):** a hand-back cap of 40 lines, details in the evidence files it names: about 1 to 2% (part of the main session's 10.1%).
- **Q8 (b) (not chosen; one line to ask for):** also set `settings.json`'s `"model": "opus"` and `"effortLevel": "high"`, so every new session starts on Opus 5.5 high and `/model fable` picks Fable.
