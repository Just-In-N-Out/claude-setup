# pipeline-token-diet: where the pipeline's tokens go, and what to cut

Status: **Justin picked the cuts on 2026-11-10. This plan is amended to his picks and is final for the build**: one job, on the Full pipeline, and the builder starts on the planner's report. One question is open and does not block the build (Q8).
Planner: Fable 5.2 high, 2026-11-10. Briefs: `~/.hermes/plans/claude-setup/briefs/pipeline-token-diet-planner.md` (analysis) and `pipeline-token-diet-planner-2.md` (this amendment).

**Playback:** the bug/story pipeline uses too many tokens and you hit usage limits; you asked for a total, measured analysis of where they go, priced options, and then you decide. You decided: cut by changing which model runs which role, by asking you before late fix rounds for P2-only findings, and by not proving every AC again after a pure rebase. Agent baggage stays as it is.

## Amendments (2026-11-10)

1. Your picks are recorded below. The plan now builds exactly these cuts: M1, M2, M3 for fixers only, M4, L6 and L7. L1 to L5 are out and stay as today.
2. The acceptance criteria are renumbered without gaps. Old → new: old AC1 → AC1, old AC4 → AC2, old AC5 → AC3, old AC7 → AC4, old AC8 → AC5, old AC9 → AC6. Old AC2, AC3 and AC6 are dropped with their cuts (the slim agent type and the four brief rules).
3. Three kept criteria changed in one detail each; their meaning is the same:
   - the routing criterion reads every file that states the rules, not four (you said "everywhere"), and its routing is the table in "The chosen set";
   - the rebase-receipt criterion's test moved from `scripts/ac-check.test.sh` to `scripts/review-check.test.sh`. `ac-check.test.sh` prints `ok   - <label>` with no number, a line `ac-check.sh` does not read as a pass, so a test named there could never be accepted; `review-check.test.sh` prints `ok <n> - <test>` and already holds the rebase fixtures;
   - the live cost criterion has a new target for this set of cuts, so it is marked **proposed**.
4. The two gate-script tasks (the late-round brake and the rebase receipt) are now written in full: behaviour, file formats, code, tests and the mutations each test must catch. The planner built both on scratch copies: each new test fails on today's script and passes on the changed one (receipts at the end).
5. The story cost is recomputed role by role for this set: **about $119 a story, 31% under today's $173** (between $109 and $128, depending on your answers to the round-3 question and on how many rebases are pure).

## Justin's answers (2026-11-10: "ok yes change this pipeline everywhere")

"Everywhere" means the Full pipeline, the Mini pipeline, and every file that states the rules, the generated Codex copy included.

| Question | Answer |
|---|---|
| Q1. Which package | Medium without the five agent-baggage cuts. L1 to L5 stay as today |
| Q3. Reviewer model | (a) Round 1 on Fable 5.2 high; every later round on Opus 5.5 high |
| Q4. Verifier model | (a) Opus 5.5 high. The 2026-11-09 rule that each AC is proven by both models ends; the two separate proofs (verifier, then the blind auditor) stay |
| M3. Effort of builder, fixer, auditor | Changed by you the same day: only the **fixers** drop to Opus 5.5 high. Builder and AC auditor stay on Opus 5.5 xhigh |
| Q5. Late review rounds | (a) From round 3, a review with only P2 findings left prints `ASK JUSTIN` with the P2 lines; you answer "fix" or "follow-up". "No round cap" becomes "no cap, but you are asked from round 3" |
| Q6. Orchestrator session | (a) Pipeline main sessions on Opus 5.5 high, and a fresh session when no agent is running and the context has passed 300k. How the session gets onto Opus is Q8 |
| L7. After a pure rebase | Yes: no new verifier and auditor. The finisher reruns every AC's test on the new head and writes a rebase receipt that `ac-check.sh` accepts with the earlier reports. A rebase with conflicts keeps today's full path |
| Q7. Size of this job | One job, Full pipeline. This job's own agents already use the new routing |

Stays exactly as today: planner on Fable 5.2 high; finisher on Opus 5.5 high; two full reviews in Full and one in Mini; plan approval; a fresh review of every fix; one test and one screenshot per AC; the `general-purpose` agent type, the skills each role loads, and how agents print output and report.

## Still open

- **Q8 (new; does not block the build). How a pipeline main session gets onto Opus 5.5 high.** `~/.claude/settings.json` sets `"model": "fable"` and `"effortLevel": "xhigh"` for every session on both machines, and a session can't change its own model. Two ways:
  - (a) **Rule text only.** At step 1 the orchestrator says which model and effort it is on. When that isn't Opus 5.5 high, it asks you, in the same question as Full or Mini, to type `/model opus` and `/effort high` before it dispatches anything. Nothing else changes.
  - (b) **Also change the two `settings.json` values** to `opus` and `high`. Every new session then starts on Opus high, the ones that run no pipeline too, and you type `/model fable` when you want Fable.
  - **I recommend (a), and the plan builds (a).** (b) is one line you can ask for at any time. Either way the saving of L6 only arrives in sessions that really run on Opus.
- **Q2 (not answered; not blocking). Which limit do you actually hit?** The 5-hour window or the weekly one, and the all-models limit or a Fable-only one? I could not find how the subscription weighs Fable against Opus, or cache reads against output. Please read `/usage` after your next story and tell the main session; if it is a Fable-only limit, the model changes above matter most.

## How it was measured

- Source: every transcript under `~/.claude/projects/` changed since 2026-10-20: 78 main sessions and 979 subagent transcripts (`<session>/subagents/agent-*.jsonl`, with `agent-*.meta.json` for model and effort). The oldest agent on disk started 2026-10-26, the newest 2026-11-10 (16 days).
- Each API response counted once (lines that repeat a message id are merged; a resumed session's copied history is skipped). Fields: `input_tokens`, `cache_creation_input_tokens`, `cache_read_input_tokens`, `output_tokens`.
- Agent to story and role: from the brief path in the agent's first prompt (`briefs/<story>-<role>.md`); 971 of 979 agents had one.
- Scripts, kept so every number can be rerun: `~/.cache/pipeline-token-diet-planner/scan.py`, then `analyze.py`, then `report.py` and `extras.py` (each takes section names; the whole run is under 2 minutes).
- **"API $"** in the tables is the same tokens at Anthropic's public API prices per million tokens (Opus 5.5: input 4, cache write 5, cache read 0.20, output 20; Fable 5.2: input 8, cache write 10, cache read 0.20, output 40; 1-hour cache write 8 and 16). You pay a subscription, not these dollars: it is only a way to add different token kinds and models into one number.

**Not measurable, said plainly:**
- How the subscription limit weighs models and token kinds: unknown. Raw tokens are shown beside API $.
- Whether the auditor's refusals were real bugs (I counted them, I did not judge them).
- Whether lower effort lets more bugs through: only findings per review are countable, not bugs missed.
- Full or Mini per story: taken from the word "Mini" in the planner brief, so approximate.
- The main session's share per story: its calls are given to the story of the nearest agent start or end, so approximate when stories ran in parallel.
- Which re-verifications followed a pure rebase and which followed a conflict: the brief names do not say.

## Findings

### 1. Totals for the 16 days

| | Agents (979) | Main sessions (78) |
|---|---|---|
| Uncached input | 0.20 M | 0.02 M |
| Cache write | 426 M | 60 M (1-hour kind) |
| Cache read | 27,719 M | 2,604 M |
| Output | 93.0 M | 8.4 M |
| API $ | 9,878 | 1,229 (1,106 in the 29 sessions that ran pipeline agents) |

By model: Opus agents 386 M write, 25,593 M read, 85.6 M out; Fable agents 39 M write, 2,120 M read, 7.4 M out; main on Opus 54 M / 2,319 M / 7.4 M; main on Fable 5.4 M / 283 M / 1.0 M.

Where an agent's API $ goes: **cache reads 56%, cache writes 24%, output 20%.** Almost nothing is fresh input. A cache read is the agent re-reading its whole context on every tool call, so cost is close to *context size x number of calls*. The median agent makes 85 calls with a context that starts at 72,700 tokens and ends at 313,000.

### 2. By role (share of agents + main, $10,985)

| Role | Agents | API $ | Share | Mean $ per agent | Mean calls | Mean context |
|---|---|---|---|---|---|---|
| Fixer | 168 | 2,376 | 21.6% | 14.1 | 130 | 279k |
| Builder | 93 | 2,221 | 20.2% | 23.9 | 198 | 330k |
| Reviewer | 225 | 1,549 | 14.1% | 6.9 | 71 | 218k |
| Verifier | 128 | 1,312 | 11.9% | 10.2 | 112 | 240k |
| Main session | (29 sessions) | 1,106 | 10.1% | 1.13 per agent it runs | 7.4 per agent | 331k |
| Auditor | 101 | 880 | 8.0% | 8.7 | 99 | 230k |
| Planner | 115 | 837 | 7.6% | 7.3 | 74 | 209k |
| Finisher (all kinds) | 128 | 604 | 5.5% | 4.7 | 67 | 148k |
| Other | 21 | 100 | 0.9% | 4.7 | 60 | 139k |

### 3. Stories

60 complete stories (planner, builder, at least one review, and a verifier or finisher). Median **13 agents, $121**; mean $150; one in ten over $272.

| Group | Stories | Median $ | Mean $ | Mean agents by role (plan / build / review / fix / verify / audit / finish) | Mean tokens per story (cache write / cache read / out, M) |
|---|---|---|---|---|---|
| All | 60 | 121 | 150 | 1.4 / 1.2 / 3.2 / 2.4 / 1.7 / 1.6 / 1.6 | 5.7 / 383 / 1.28 |
| Since 2026-11-09 (Fable in use) | 10 | 196 | 182 | 1.5 / 1.6 / 4.3 / 2.9 / 1.2 / 1.1 / 1.6 | 6.4 / 404 / 1.27 |
| Before | 50 | 102 | 143 | 1.4 / 1.1 / 2.9 / 2.3 / 1.8 / 1.7 / 1.7 | 5.6 / 379 / 1.28 |
| Full | 37 | 163 | 187 | 1.4 / 1.2 / 3.8 / 3.1 / 2.0 / 1.8 / 1.9 | 6.7 / 496 / 1.58 |
| Mini | 23 | 81 | 90 | 1.3 / 1.2 / 2.2 / 1.3 / 1.3 / 1.3 / 1.3 | 4.1 / 201 / 0.78 |
| Leorna | 13 | 134 | 135 | 1.0 / 1.2 / 3.3 / 3.2 / 2.4 / 2.1 / 3.2 | 5.2 / 304 / 1.37 |
| FigmaToBricksV2 | 43 | 118 | 158 | 1.5 / 1.3 / 3.0 / 2.1 / 1.5 / 1.4 / 1.1 | 6.0 / 423 / 1.23 |
| Setup repo | 4 | 109 | 110 | 1.5 / 1.0 / 4.0 / 2.8 / 2.2 / 1.8 / 2.2 | 4.3 / 216 / 1.40 |

The latest complete stories (API $ by role; rerun `report.py stories` for all 16 shown there):

| Story | Start | Agents (plan/build/review/fix/verify/audit/finish) | Agents $ | Main $ | Plan | Build | Review | Fix | Verify | Audit | Finish |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 86bctmuwy-agent-items-install | 11-08 | 1/1/7/5/3/3/5 | 171 | 19 | 18 | 9 | 43 | 41 | 27 | 15 | 19 |
| 86bcm9284 | 11-08 | 1/1/3/4/2/2/2 | 72 | 26 | 4 | 20 | 9 | 11 | 9 | 7 | 12 |
| site-slider | 11-09 | 4/2/4/3/1/1/1 | 191 | 11 | 21 | 53 | 37 | 61 | 9 | 9 | 1 |
| site-menu | 11-09 | 2/2/5/4/0/0/1 | 244 | 15 | 14 | 86 | 34 | 100 | 0 | 0 | 10 |
| staging-fit-renderer | 11-09 | 1/2/7/5/1/1/2 | 205 | 15 | 4 | 44 | 38 | 90 | 10 | 12 | 7 |
| site-reviews | 11-09 | 2/2/5/2/1/1/1 | 207 | 12 | 11 | 51 | 35 | 57 | 38 | 12 | 1 |
| staging-fit-capture | 11-09 | 0/1/3/1/1/1/1 | 140 | 23 | 0 | 23 | 18 | 67 | 12 | 17 | 2 |
| site-native-structure | 11-09 | 2/2/4/3/1/0/1 | 210 | 18 | 9 | 64 | 35 | 78 | 16 | 0 | 7 |
| site-faq | 11-09 | 1/2/3/1/1/1/1 | 162 | 7 | 7 | 26 | 15 | 15 | 48 | 51 | 1 |
| dream-trim | 11-10 | 1/1/2/1/1/1/1 | 68 | 6 | 4 | 16 | 22 | 8 | 10 | 7 | 1 |

In the stories since 2026-11-09, **Fable ran 62 of 157 agents (39%) and took 56% of the API $** ($1,075 against $840 for 95 Opus agents): its output and cache writes cost twice Opus's, and its long thinking turns let the 5-minute cache expire more often (48 rebuilds in 66 Fable agents).

### 4. Rounds, and what causes the extra ones

| Per complete story | Median | Mean | 1 in 10 has at least | Max |
|---|---|---|---|---|
| Review rounds | 2.5 | 3.2 | 7 | 10 |
| Fixers | 2 | 2.4 | 5 | 10 |
| Verifier runs | 2 | 1.7 | 3 | 6 |
| Auditor runs | 2 | 1.6 | 3 | 4 |
| Finishers | 1 | 1.6 | 3 | 7 |
| Planner runs (amendments included) | 1 | 1.4 | 2 | 4 |

From the 210 `review.json` files of 63 stories:

| Round | Reviews | Blocking (any P0-P2) | Mean P0 / P1 / P2 / P3 |
|---|---|---|---|
| 1 | 63 | 46 (73%) | 0 / 0.16 / 1.71 / 3.83 |
| 2 | 41 | 25 (61%) | 0 / 0.24 / 1.02 / 2.34 |
| 3 | 33 | 14 (42%) | 0 / 0.09 / 0.52 / 2.33 |
| 4 | 25 | 9 (36%) | 0 / 0.08 / 0.60 / 1.96 |
| 5 | 18 | 8 (44%) | 0 / 0.06 / 0.44 / 2.11 |
| 6 and later | 30 | 13 (43%) | 0 / 0 / 0.73 / 2.13 |

- **No P0 in 210 reviews. Extra rounds are driven by P2 findings:** of the 69 blocking reviews in round 2 or later, 57 had P2 only.
- A fix round keeps a steady 36 to 44% chance of producing another blocking review, however late: each fix adds new code that a fresh reviewer finds new P2s in.
- Cost of the tail: reviewers from round 3 plus fixers from round 2 are 18.5% of all tokens; reviewers from round 4 plus fixers from round 3 are 12.0%.
- Other extra agents: verifier and auditor re-runs after a rebase, PR update or stack merge (49 agents, 3.8%); rebase and bring-main finishers (26 agents, 2.1%); plan amendments (25 agents, 1.2%).
- Verifier against auditor on the same commit (115 pairs still on disk, 1,102 ACs): they agree on 1,071. The auditor refused an AC the verifier had accepted 27 times, in 13 pairs (11 of 66 stories); the reverse happened 4 times in 2 pairs.

### 5. What an agent carries before it does anything

| Role | Context at call 1 | Skills loaded | Skill text | Brief/plan/reference reads | Context at first work action |
|---|---|---|---|---|---|
| Planner | 72.8k tokens | 2.2 | 41k chars | 12k chars | 85.2k |
| Builder | 72.8k | 3.6 | 80k | 94k | 86.7k |
| Reviewer | 70.0k | 3.9 | 85k | 13k | 88.5k |
| Fixer | 69.6k | 4.8 | 94k | 9k | 91.7k |
| Verifier | 73.6k | 2.1 | 28k | 33k | 82.2k |
| Auditor | 73.5k | 1.5 | 28k | 60k | 82.0k |
| Finisher | 69.3k | 2.2 | 38k | 8k | 84.1k |

The calls spent loading (before the first work action) are only **2.9%** of agent $ (about $0.30 an agent). The cost is in **carrying** that load: it is written to the cache once and re-read on every later call. Priced that way (4.0 characters per token, fitted from the data):

| Carried on every call | Size | Share of agent $ |
|---|---|---|
| Fixed start: system prompt, tool schemas, MCP and agent lists, brief prompt | 36k tokens | 9.0% |
| Skill texts the agent loads | 18k tokens mean | 4.6% |
| FigmaToBricksV2 `CLAUDE.md` (in 691 agents) | 82 KB median in the window, 56.7 KB today | 4.4% (5.8% of Figma agents) |
| Brief, plan and reference files read at the start | 9k to 94k chars | 3.7% |
| Skill listing: 135 skills, 30 KB | 7.5k tokens | 1.9% |
| Global `~/.claude/CLAUDE.md` | 26 to 30 KB | 1.7% |
| `MEMORY.md`, nested `CLAUDE.md` copies | | 0.3% |
| **Total baggage** | | **25.7%** |

Inside the fixed start: the **`Artifact` tool's schema alone is 37 KB** (about 9,300 tokens) in every pipeline agent, none of which publishes artifacts; the `Agent` tool is 4.9 KB (pipeline agents may not start agents); the agent-type list 9.9 KB, the deferred MCP tool list 11.1 KB, MCP instructions 7.1 KB. In the skill listing, the Adobe plugin is 11.3 KB of the 30 KB, superpowers 2.9 KB, design 2.0 KB.

Most-loaded skills (loads x size): `engineering-best-practices` 706 x 28 KB, `mutation-testing-discipline` 372 x 39 KB, `leorna` 258 x 58 KB, `code-review-practice` 212 x 29 KB, `test-driven-development` 258 x 11 KB, `git-commit-rules` 219 x 9 KB.

### 6. The main session

- 10.1% of all tokens: $1,106 for 979 agents, $1.13 per agent it runs, 7.4 calls per agent.
- Mean context per call **331k tokens**; three sessions reached 965k (the 1M limit). Its $ is 42% cache reads and 41% cache writes: the 1-hour cache costs twice the 5-minute one to write, and 141 times a turn re-wrote more than half the context (36.6 M tokens).
- 922 agent hand-backs entered it, 9.7 KB each on average (8.9 M characters), and each stays in the context for the rest of the session.
- Hook send-backs cost almost nothing: 111 lessons-gate send-backs, $7 for the calls that answered them. The skill-lesson nudge (7,243 times, 1 KB each) is about 0.2%.

### 7. The five biggest costs

1. **Re-reading context on every call in builders and fixers.** Builders and fixers are 41.8% of everything; 61 to 65% of their $ is cache reads (199 and 130 calls at 330k and 279k). The dearest single agent: `site-motion-builder`, $96, 613 calls, 651k average context. The 78 agents with over 200 calls are 8% of agents and 27% of agent $.
2. **Baggage every agent carries: 25.7% of agent $** (section 5).
3. **AC proving: 19.9%** (verifier 11.9%, auditor 8.0%), of which 3.8% is re-proving after a rebase or merge.
4. **Fix rounds after the first: 18.5%** (reviewers from round 3, fixers from round 2), mostly for P2-only findings.
5. **Fable on high-volume roles:** 39% of agents, 56% of $ since 2026-11-09 (section 3).

Also measured: command output in context is 12.3% of agent $ (results of 8 to 30 KB are half of it, 6.2%); cache rebuilds are 7.3% of agent $, of which 158 (60 M tokens, about 3%) came from waiting over 5 minutes on one command and 178 (60 M) from resuming after a crash, restart or usage-limit stop; the main session 10.1%.

### 8. Model and effort, measured per agent

| Role | Fable high | Opus xhigh | Opus high | Opus medium (one day, 2026-11-04) |
|---|---|---|---|---|
| Planner | $5.71 (n=7) | $8.49 (73) | $6.28 (25) | $1.86 (8) |
| Builder | $24.87 (7) | $25.72 (58) | $23.12 (19) | $11.16 (8) |
| Reviewer | $10.21 (28) | $8.25 (120) | $3.49 (54) | $3.07 (17) |
| Fixer | $32.81 (11) | $14.15 (119) | $9.82 (29) | $2.99 (5) |
| Verifier | $20.02 (8) | $10.09 (89) | $9.26 (22) | $4.63 (7) |
| Auditor | $24.21 (3) | $8.98 (61) | $8.31 (20) | $3.41 (12) |
| Finisher | | $6.18 (70) | $2.94 (38) | $1.32 (11) |

These compare different days and stories, so read them as indications. Findings per round-1 review: Fable high 0.5 P0/P1 and 2.5 P2 (n=10); Opus xhigh 0.13 and 1.73 (n=30); Opus high 0.09 and 0.91 (n=11); Opus medium 0 and 0.5 (n=6). Lower effort is cheaper and finds less; how much of the difference is real bugs is not known.

## Candidate cuts

Savings are a share of a story's API $. "Typical story at today's rules" is $173: mean agents per role x today's routing prices (planner 8, builder 31, reviewer 33, fixer 34, verifier 34, auditor 14, finisher 5, main 14); the 10 stories since 2026-11-09 measured $182.

| Id | Cut | Measured saving | Protection lost | Files |
|---|---|---|---|---|
| L1 | A slim agent type for pipeline roles: no `Artifact` or `Agent` tool, no MCP or agent lists | Up to 17.5k of the 72.7k starting tokens: about 4% (confirm with a probe) | None known. A Leorna planner that reads the ClickUp card stays `general-purpose` | new `~/.claude/agents/pipeline-agent.md`; `CLAUDE.md`; `SKILL.md` |
| L2 | Skill loads by role: `engineering-best-practices` only for planner, builder, fixer; `mutation-testing-discipline` only when the plan tags a guard AC | About 1.5% | A reviewer or verifier no longer reads the general workflow text (they keep their review and verification skills) | `CLAUDE.md` "Skills to Load"; `SKILL.md` "Skills every agent loads" |
| L3 | Brief rule: output over about 60 lines goes to a log file in the evidence folder, the agent prints the tail and the pass/fail counts | 8 to 30 KB results carry 6.2%; if half follow the rule, about 3% | An agent may miss a failure outside the tail; the full log is kept and `ac-check.sh` reads logs, not the chat | `CLAUDE.md`; `SKILL.md` |
| L4 | Brief rule: a command expected to run over 4 minutes runs in the background and is checked before 5 minutes pass | 158 rebuilds, 60 M tokens, 3.0%; a check costs 1/25 of a rebuild: about 2% | None | same two files |
| L5 | Hand-back cap: a report is at most 40 lines; details stay in the evidence files it names | Part of the main session's 10.1%: about 1 to 2% | The orchestrator sees less detail in chat; verdict, `ac_status` and `skill_lessons` stay | `CLAUDE.md`; `SKILL.md` |
| L6 | Orchestrator on Opus high, fresh session past 300k when nothing runs (Q6) | Main call $0.30 to $0.13; up to 5% when the main session is on Fable | A new session re-reads state from the plan, briefs and evidence (already the resume path) | `CLAUDE.md` one line; `main-chat-housekeeping.md` |
| L7 | After a **pure** rebase: no new verifier and auditor. The finisher runs every AC's test on the new head and writes a rebase receipt; `ac-check.sh` accepts the earlier reports with it | Re-runs are 3.8% plus their main-session turns; upper bound 4% (some followed conflicts, which still get the full path) | A rebase onto a changed `main` could break an AC without a conflict: the receipt's AC tests on the new head catch that. Rule changed: `CLAUDE.md` step 7 "run verifier, auditor, ac-check again" | `scripts/ac-check.sh` + test; `ac-verification.md`; `CLAUDE.md` step 7 |
| M1 | Reviewer: Fable high round 1, Opus high delta rounds (Q3) | 2.2 of 3.2 reviews x ($10.21 - $3.49): 8.5% | Later rounds read by the model that finds about a third as many P2s per review. Every fix is still reviewed (harness-guards, 2026-10-28, stays covered) | `CLAUDE.md` x2; `mini-pipeline.md`; `model-routing.md`; `SKILL.md` |
| M2 | Verifier: Opus high (Q4) | 1.7 x ($20.02 - $9.26): 10.6% (Fable sample is 8 runs) | "Each AC proven once by each model" (2026-11-09) | same |
| M3 | Builder, fixer, auditor: Opus high instead of xhigh | Fixer 31%, builder 10%, auditor 7% cheaper: 8.4% | Less thinking per step; not measurable in bugs | same |
| M4 | From round 3, P2-only findings stop the loop with `ASK JUSTIN` (Q5) | Rounds past that point are 12.0%; 86% of their triggers were P2-only: up to 10%, depending on your answers | Your "no round cap" (2026-11-09). A late P2 is fixed only when you say so; nothing unreviewed is merged, because the loop stops after a review, not after a fix | `scripts/review-check.sh` + test; `review-loop.md`; `CLAUDE.md` step 5 |
| D1 | One AC proof: drop the blind auditor | 8.0% plus $1.13 of main session per auditor: about 9% | The second, blind proof (added with `ac-verification.md`). It refused 27 ACs the verifier accepted, in 11 of 66 stories | `scripts/ac-check.sh` (one-report mode) + test; `ac-verification.md`; `CLAUDE.md` step 6 |
| D2 | Reviewer Opus high in round 1 too | ($10.21 - $4.42) x 1: 3% | The only Fable read of the story | routing files |
| D3 | Verifier and finisher at Opus medium | Verifier $9.26 to $4.63: 3% | One day of medium data only | routing files |

**Measured and not worth doing:**
- One full review instead of two in Full: round 2 full reviews cost $7.19 against $5.40 for a delta round, 32 times in 16 days: 0.5%.
- One finisher instead of two: finishers are 2 to 3 dollars each; under 1%.
- Moving the orchestrator section out of global `CLAUDE.md` (10.8 KB of 29.6 KB): 0.6%, and it risks the main session not reading its rules (the 2026-10-23 incident).
- Hook send-backs and the skill-lesson nudge: under 0.3% together.

**Outside this job, worth a note:** FigmaToBricksV2's `CLAUDE.md` is loaded by every Figma agent; each 10 KB cut is about 0.7% of a Figma story. The Adobe plugin's skill listing (11.3 KB, about 0.7% of every agent) is yours to switch off with `/plugin` if you don't use it in Claude Code; it is not in `settings.json`'s `enabledPlugins`, so I could not tell where it is enabled.

## Packaged options

Cuts overlap, so each total is computed role by role on the $173 story, not by adding the rows above.

| Package | Contains | Story cost | Saving | What you give up |
|---|---|---|---|---|
| **Light** | L1 to L7 | $147 | **about 15%** | Nothing with an incident behind it. About half the saving depends on agents following brief rules (L3, L4, L5) |
| **Medium** (recommended) | Light + M1 to M4 | $96 | **about 45%** | Fable on delta reviews and on the verifier; xhigh on builder, fixer, auditor; automatic late P2 rounds |
| **Deep** | Medium + D1 to D3 | $74 to $79 | **about 55%** | Also the blind auditor and the Fable round-1 review |

Medium by role: planner 7, builder 25, reviewer 13, fixer 14, verifier 11, auditor 10, finisher 4, main 11. The model changes (M1 to M3) rest on unequal samples; the firmest parts are L7, M4, L1 and M1.

## The chosen set (2026-11-10): routing and recomputed cost

**Routing, the same for Full and Mini, in every repo:**

| Role | Model | Effort | Before |
|---|---|---|---|
| Planner | Fable 5.2 | high | the same |
| Builder | Opus 5.5 | xhigh | the same |
| Reviewer, round 1 (the whole story) | Fable 5.2 | high | the same |
| Reviewer, every later round (Full's whole-story round 2, the delta rounds, a full round the referee asks for) | Opus 5.5 | high | Fable 5.2 high |
| Fixer | Opus 5.5 | high | Opus 5.5 xhigh |
| Verifier | Opus 5.5 | high | Fable 5.2 high |
| AC auditor | Opus 5.5 | xhigh | the same |
| Finisher | Opus 5.5 | high | the same |
| Pipeline main session | Opus 5.5 | high | whatever `settings.json` gives (Fable 5.2 xhigh today) |

**Full's round 2 runs on Opus 5.5 high.** Why: the plan priced M1 as one Fable review a story (the "2.2 of 3.2 reviews" in the M1 row), and the reason you picked Q3 (a) was that the strongest reviewer reads the whole story once. Round 2 reads the corrected story with round 1's findings in hand. So the rule is one line: round 1 on Fable, every later round on Opus high. If you want round 2 on Fable as well, say so: it changes one table row and costs about $4 more a story ($10.21 - $3.49, in the 65% of stories that have a round 2).

**The routing sentence**, which every file that states the routing carries word for word (the consistency test looks for it):

`planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Fable 5.2 high, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high`

**Story cost, role by role** (mean agents per story from Findings 3, prices per agent from Findings 8, on the same $173 story as the packages above):

| Role | Today | Chosen set, expected | How |
|---|---|---|---|
| Planner | 8.0 | 8.0 | 1.4 x $5.71, unchanged |
| Builder | 30.9 | 30.9 | 1.2 x $25.72, unchanged |
| Reviewer | 32.7 | 16.1 | 1 x $10.21 on Fable + (2.2 - 0.5) x $3.49 on Opus high |
| Fixer | 34.0 | 20.6 | (2.4 - 0.3) x $9.82 at high (was x $14.15 at xhigh) |
| Verifier | 34.0 | 13.7 | (1.7 - 0.22) x $9.26 on Opus high (was x $20.02 on Fable) |
| AC auditor | 14.4 | 12.8 | (1.6 - 0.18) x $8.98, still xhigh |
| Finisher | 4.7 | 5.0 | 1.6 x $2.94, plus about $0.30 for the receipt runs |
| Main session | 14.8 | 11.4 | 11.9 agents x 7.4 calls x $0.13 on Opus (was 13.1 agents x $1.13) |
| **Story** | **173** | **119 (31% less)** | |

The numbers taken off the agent counts:
- **The round-3 question (M4).** 38 P2-only blocking reviews in round 3 or later, in 63 stories, is 0.60 a story: each "follow-up" answer saves one fixer and at least the review after it (the rounds from 4 on are 1.16 reviews a story; 86% of them is 1.0). The expected column takes half: 0.3 fixers and 0.5 reviews fewer.
- **The rebase receipt (L7).** The re-proofs after a rebase, PR update or stack merge were 49 agents in 60 stories: 0.45 verifiers and 0.37 auditors a story. The briefs don't say which followed a pure rebase, so the expected column takes half: 0.22 and 0.18 fewer.
- **The range.** If you always answer "fix" and no rebase is pure, the story costs $128 (26% less): reviewer 17.9, fixer 23.6, verifier 15.7, auditor 14.4, finisher 4.7, main 12.6. If you always answer "follow-up" and every re-proof was a pure rebase, $109 (37% less): reviewer 14.4, fixer 17.7, verifier 11.6, auditor 11.0, main 10.3.
- **Not counted:** the fresh-session rule (its effect on the main session's context was not measurable), and the extra saving when today's main sessions run on Fable (a main-session call costs $0.30 there, so today's story is nearer $187 than $173).

The model prices rest on unequal samples (Findings 8: the Fable verifier is 8 runs). The live criterion at the end checks the real result.

**The live target.** The first target was 30% for a projected 45%, two thirds of the projection. The same margin here: two thirds of 31.5% is 21%, and 21% under the $182 measured in the 10 stories since 2026-11-09 is **$144**.

## Acceptance criteria

Approved by Justin on 2026-11-10 as worded in the first plan, except where the Amendments list says otherwise. Only the last one is marked proposed.

- AC1: Given the routing in "The chosen set", when the consistency test reads every file in "Where the rules are stated" (among them `~/.claude/CLAUDE.md`'s pipeline paragraph, steps 5 to 7 and "Agent models" bullet, `SKILL.md`, `references/mini-pipeline.md` and `references/model-routing.md`), then every role has the same model and effort in all of them and no older pairing or replaced rule text remains; the Codex copy built from `CLAUDE.md` says the same. Test: `routing_text_agrees` in `scripts/pipeline-rules.test.sh`.
- AC2: Given review rounds on disk where round 3 or later has P2 findings and no P0 or P1, when `review-check.sh` runs, then its last line is `ASK JUSTIN: …` naming the P2 lines; with `justin.json` `"continue": true` for that round it is `REVIEW AGAIN`; with a P0 or P1 in that round, or the same findings in round 1 or 2, it is `REVIEW AGAIN` as today. Test: `p2_only_from_round_3_asks_justin` in `scripts/review-check.test.sh`.
- AC3: Given verifier and auditor reports accepted at head H, a HEAD that is a pure rebase of H (the same patches in the same order, no merges) and a rebase receipt whose log starts `HEAD=<new sha>`, ends `EXIT=0` and shows every AC's test passing, when `ac-check.sh` runs with the receipt, then it prints `ALL ACCEPTED` or `READY FOR THE USER`; without the receipt, with a failing or missing AC test in it, or when HEAD is not a pure rebase of H, it prints `NOT ACCEPTED`. Test: `pure_rebase_receipt_accepts_earlier_reports` in `scripts/review-check.test.sh`.
- AC4: Given a fixture folder with one main transcript and two agent transcripts (one repeating a message id), when the token report runs on it, then it prints the expected tokens per role and counts the repeated message once. Test: `token_report_fixture` in `scripts/token-report/token-report.test.sh`.
- AC5: Given the changed scripts and rule files, when the existing suites run, then `scripts/ac-check.test.sh` ends `all passed`, `scripts/review-check.test.sh` ends `failed 0` with its 15 existing tests still present, and `~/.claude/setup/codex/codex-parity.test.sh` and the suites in `~/.claude/hooks/tests/` pass as they do on the base. Test: `existing_suites_pass` in `scripts/pipeline-rules.test.sh`.
- AC6 (proposed) (live): After the next 5 complete pipeline stories, `report.py stories` shows their mean API $ at or under $144 (21% under the $182 of the 10 stories since 2026-11-09); if not, the report's role table names the role that did not drop.

Paths in the criteria are under `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/` unless they start with `~`. The last criterion is proposed because its target is new: $144 replaces the first plan's $127, which was set for the larger Medium package (arithmetic in "The chosen set"). It is live because no agent can check it: it is read from the token report after the job, by you or by the main session at your word.

Every test name above is a function its file runs by name and reports as `ok <n> - <name>`, the line `ac-check.sh` reads as a pass.

**Baseline on 2026-11-10, base commit `9ed247e`, run from the live home:**
- `bash scripts/ac-check.test.sh` ends `all passed`; `bash scripts/review-check.test.sh` ends `# passed 15, failed 0`.
- The five gate suites in `~/.claude/hooks/tests/` (`setup-sync-pull`, `skill-review-nudge`, `subagent-ac-gate`, `subagent-handback-gate`, `subagent-lessons-gate`) end `all passed`; `~/.claude/setup/sync.test.sh` ends `passed 32, failed 0`.
- Three suites **already fail on the base**: `harness-guards.test.sh` `# passed 16, failed 3` (ac11, ac17, ac20: "git tracks 0 files"; they ask git what is tracked, which finds nothing in the live home, whose repo is the bare `~/.claude-setup.git`); `cortexos-memory.test.sh` `# passed 13, failed 2` (ac4, a 300 ms timing limit that measured 325 ms; ac13, the same git cause); `codex-parity.test.sh` `# passed 15, failed 3` (ac4 "expected 17 Claude-linked names", ac7 which runs `cortexos-memory.test.sh`, and ac21 "start state is not gpt-6.1-sol/xhigh": the Codex pipeline model is `gpt-6-astra` at `high` today).
- So "as they do on the base" is compared test by test, never by "the suite passes". The builder records the base again in its own worktree (task 0): the git-tracking failures should pass there, ac21 should not.

## Where the rules are stated

Every place found by reading the files and by searching for the old pairings (`xhigh`, `Fable`, "once by each model", "no round cap", "verifier → auditor"). Line numbers are today's. While building, each `~` path is the worktree's copy of that file.

| File | Today | Change |
|---|---|---|
| `~/.claude/CLAUDE.md` line 15, "The pipeline." | Models and efforts by role; "every AC is proven once by each model" | The new routing as Agent-tool values; pipeline main session on Opus 5.5 high; the fresh-session rule in one sentence |
| same, line 16, step 1 | Play back and pick | Add the Q8 (a) model check to the same question |
| same, line 20, step 5 | "No round cap."; brakes; `ASK JUSTIN` → ask | Which model reviews which round; "No round cap; from round 3 a round with only P2 left is `ASK JUSTIN`"; his answers ("fix" → `"continue": true`, "follow-up" → `accept` and the lines go to `follow-ups.md`) |
| same, line 24, step 7 | "you run verifier → auditor → `ac-check.sh` again on it" | A pure rebase: the finisher writes the receipt and you rerun `ac-check.sh` with `--rebase-receipt`; anything else keeps today's path |
| same, line 98, "Agent models" | The 2026-11-09 routing; "once by each model"; "no round cap" | The routing sentence, dated 2026-11-10, what it replaces, and the dated *Why* notes (task 4) |
| `feature-dispatch/SKILL.md` lines 89 to 99 | Role routing quote and table | New table (two reviewer rows), the routing sentence under it |
| same, lines 107 to 109 | "Fable 5.2 high reviews, Opus 5.5 xhigh fixes"; "Fixers use the builder's model and effort (Opus 5.5 xhigh); the verifier is Fable 5.2 high"; "xhigh for builder, fixer and AC auditor" | Reworded to the table |
| same, line 159 | Verifier brief: "model: Fable 5.2 high" | Opus 5.5 high |
| same, lines 283 and 298 | "an **Opus 5.5 xhigh FIXER now**"; "From round 3 a review is focused" | Opus 5.5 high fixer; the round-3 question in one clause. Keep the words 'unless `review-check.sh` says run a full review from `<base>`' on both lines (a test pins them) |
| same, line 348, setup repo | Two one-story permissions to merge after a rebase without re-proving ("Ask before reusing") | A pure rebase now goes through the receipt on every story; the wider review-loop permission (main touched other lines of a story file) still needs asking |
| `references/mini-pipeline.md` lines 16 to 29 | Table; "not by lowering effort"; board examples | New table and sentence; drop "not by lowering effort" |
| same, lines 35 to 37 and 41 | Steps; "Opus-limit question (applies to the Mini planner, reviewer and verifier)" | Later rounds on Opus high; the round-3 question (in Mini, the review of the second fix); the receipt after a pure rebase |
| `references/model-routing.md` | No pairing stated (lines 5 and 6 are dated history) | No change; the test checks it stays free of the old pairings |
| `references/review-loop.md` lines 9 to 12, 51 to 54, 64 to 68, 75 to 77 | Rounds; `justin.json`; the referee's outcomes; after MOVE ON | Which model per round; the "fix" and "follow-up" answers; brake e in `ASK JUSTIN`; ACCEPTED P2 lines go to `follow-ups.md`; the receipt for a pure rebase |
| `references/ac-verification.md` lines 12, 31 to 40, 52, 59 to 76 | Four layers; run recipe; setup-repo note ("forces another verifier → auditor round"); steps | The receipt recipe and format; `command` in each `ac.json` row; the `--rebase-receipt` command and its `REBASE` line; the setup-repo note says "a new receipt", not a new round |
| `references/main-chat-housekeeping.md` lines 3 to 16 | "Ask to reset the main chat" (Hermes, `/new`) | Add the Claude Code rule: Opus 5.5 high, and a fresh session past 300k when nothing runs |
| `references/away-and-recovery.md` line 55 | "Fable 5.2 high or Opus 5.5 xhigh/high, SKILL.md's role table" | Still true; no change |
| `references/agent-defect-loop.md` line 17 | "There is no round cap" (the AC loop) | Still true; no change |
| `leorna/SKILL.md` lines 85 to 87 and 96 | Models by role; the review chain with "fresh Fable full review 2", "fresh Fable review of the fix commits", "fresh Fable verifier" | The routing sentence; the chain reworded; "ask Justin … on ASK JUSTIN" already covers the round-3 question |
| `review-fix-cadence/SKILL.md` lines 21, 23, 33 to 39, 51 | Default cadence; brakes a to d; "Order"; "Use a fresh Fable 5.2 high reviewer" | The routing sentence; brake (e); a pure rebase needs the receipt, not a new verifier; round 1 Fable, later rounds Opus high. Keep the section title "## Loop until a review is clean" and the pinned words (task 4) |
| `figma-to-bricks/SKILL.md` line 109 | "Full: Sol 6.1 xhigh review, fixes, then Opus 5.5 xhigh review; Mini: one Opus 5.5 xhigh review" (stale since 2026-10-22) | Point to `feature-dispatch`'s role table; name no model |
| `~/.claude/setup/codex/agents-header.md`, tool map, last row | "Opus 5.5 at high effort for every role; …" | "The per-role Claude models and efforts, and the pipeline main session on Opus 5.5 high" are Claude Code only |
| `~/.codex/AGENTS.md` | Generated, not in git: the header plus `CLAUDE.md` word for word | Never edited. `sync.sh` rebuilds it with `build-codex.sh` (task 5) |

Checked and left alone: `~/.codex/agents/pipeline-*.toml` (they name no model per role and no round rule); FigmaToBricksV2's `CLAUDE.md` line 242 and its memory note `review-round-cap.md` (that project's own tighter cap; it quotes the global "no round cap", which stays in the text); `~/.claude/dream/DREAM.md` line 84 (dream agents, not the pipeline); the memory notes `run-without-stopping.md` and `leorna-workflow.md` (dated history).

Paths without `~` in this table are under `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/` or `~/.hermes/skills/software-development/`.

## Tasks, in build order

One commit a task, test first, each commit green. The story is in the setup repo (`~/.claude-setup.git`, work tree `$HOME`): build in a worktree of it, where the files are `<worktree>/.claude/…` and `<worktree>/.hermes/…`. Evidence: `~/.hermes/plans/claude-setup/evidence/pipeline-token-diet/`. Skills: `engineering-best-practices`, `test-driven-development`, and `mutation-testing-discipline` for tasks 2 and 3. This story itself runs on today's gate scripts until it is merged.

**Rules for the three files `review-check.sh`, `ac-check.sh` and `review-check.test.sh`** (the existing test `ac16_scripts_portable_to_macos` enforces them): bash 3.2 only (no `mapfile`, `declare -A`, `${x,,}`, `|&`), no `sed -i`, `grep -P`, `readlink -f`, `date -d` or `stat -c`, no here-document inside `$( )`, `head -n 1` not `head -1` in `review-check.sh` and the test file, and none of the bare words `trim`, `pick`, `abs` (jq 1.7 names; "cherry-pick" is fine).

**0. Before any edit (10 minutes).**
- Record the base: in the worktree at the base commit, run `scripts/ac-check.test.sh`, `scripts/review-check.test.sh`, `~/.claude/setup/codex/codex-parity.test.sh`, `~/.claude/setup/sync.test.sh` and every `~/.claude/hooks/tests/*.test.sh`, twice each, with nothing else of yours running, under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0`. For each suite save the sorted names of the tests that passed in either run to `<evidence>/base-tallies/<suite>.ok`, and the two last lines to `<evidence>/base-tallies/summary.txt`.
- Confirm from `claude --help` or the Claude Code docs that `/model opus` and `/effort high` are the commands that switch a running session. If either name is different, use the real one in the rule text and say so in the report.
- Stop and report if `review-check.test.sh` does not end `# passed 15, failed 0` on the base.

**1. Token report tool** (the fourth criterion).
- Copy `scan.py`, `analyze.py`, `report.py` and `extras.py` from `~/.cache/pipeline-token-diet-planner/` to `feature-dispatch/scripts/token-report/`. Make the transcript root and the output folder arguments, with today's values as defaults.
- Add `report.py context <transcript.jsonl>`: it prints the context size of the transcript's last API response (input + cache write + cache read tokens) as one number. The fresh-session rule uses it.
- Write `token-report.test.sh` first, with a hand-made fixture folder: one main transcript and two agent transcripts with their `agent-*.meta.json`, one agent repeating a message id on two lines. `token_report_fixture` checks the printed tokens per role against numbers worked out by hand in a comment, that the repeated message is counted once, and that `context` prints the main transcript's last-response size. End the file with the runner block of `review-check.test.sh` (its `run()` and the two lines after it), so it prints `ok <n> - token_report_fixture`.
- RED: the test fails while the folder has no scripts. GREEN: `bash scripts/token-report/token-report.test.sh` ends `# passed 1, failed 0`.

**2. The late-round brake in `review-check.sh`** (the second criterion). Code: Appendix A.
- **Rule (brake e).** After the existing steps (ACCEPTED findings and no-scenario P0 to P2 taken out), when the latest round is number 3 or later, at least one P0 to P2 is left and every one left is a P2, the outcome is `ASK JUSTIN` (exit 3), unless that round's `justin.json` has `"continue": true`. It applies to full and delta rounds, in Full and Mini alike (the script can't tell them apart). In Mini round 3 is the review of the second fix.
- **Output.** The finding lines as today, then the last line. Brake e adds its reason after the reasons of brakes d and c, joined by `; `:
  `ASK JUSTIN: review-3: only P2 left from round 3 on (R3-1, R3-2): fix or follow-up?`
  `ASK JUSTIN: review-3: 1 P0-P2, no fewer than review-2's 1; only P2 left from round 3 on (R3-1): fix or follow-up?`
  The ids are the P2s still counted, in the file's order.
- **`justin.json`: no new key.** The main session writes his answer with the keys the file already has. "fix" → `{"words": "<his reply>", "continue": true}`: `REVIEW AGAIN`, a fixer, then the next review. "follow-up" → `{"words": "<his reply>", "accept": ["R3-1", "R3-2"]}`: those count as ACCEPTED, the round is clean, and the main session appends their lines to `<evidence>/follow-ups.md` beside the P3s. A mix ("fix R3-1, R3-2 is a follow-up") → both keys: `"accept": ["R3-2"], "continue": true`. With `accept` alone for some of them, the brake asks again for the rest.
- **What must keep working:** rounds 1 and 2 with only P2s are `REVIEW AGAIN`; a round 3 with a P0 or P1 is `REVIEW AGAIN` unless brake c or d trips; `"continue": true` on an earlier round answers nothing; a clean round is `MOVE ON`; the off-base rule still comes after the brakes; exit codes and every other line stay as they are.
- **Test first.** Add `p2_only_from_round_3_asks_justin` (Appendix A) before the `ac-check.sh --reviews` banner and add its name to `OFFLINE` after `ac8_referee_rejects_bad_records`. RED on the base script: `want exit 3 and last line [ASK JUSTIN: review-3: only P2 left from round 3 on (R3-1): fix or follow-up?], got exit 1`. Then apply the script change: GREEN.
- **Three existing assertions change, and only these** (the planner ran the whole referee part of the suite against the change):
  - line 240, case "3, 1, then 1": the expected line gains `; only P2 left from round 3 on (R3-1): fix or follow-up?`;
  - line 244, case "1, 3, then 2": from exit 1 `REVIEW AGAIN: 2 P0-P2 finding(s) in review-3 …` to exit 3 `ASK JUSTIN: review-3: only P2 left from round 3 on (R3-1, R3-2): fix or follow-up?`;
  - line 283, case "review-3 repeats review-1": the expected line gains `; only P2 left from round 3 on (R3-1): fix or follow-up?`.
  Any other existing assertion that fails is a bug in the change, not a test to edit.
- **Mutations the new test must catch.** Make each on a copy of the script, run the test, see `not ok`, restore:

  | Mutation | Case that fails |
  |---|---|
  | `$L >= 2` → `$L >= 1` | "P2 only in round 2" |
  | `$L >= 2` → `$L == 2` | "one P2 left in round 4" |
  | `$L >= 2` → `$L >= 3` | "one P2 left in round 3" |
  | `all($now[]; .eff == "P2")` → `all($now[]; true)` | "a P1 and a P2 in round 3" |
  | `all(` → `any(` | "a P1 and a P2 in round 3" |
  | the id list taken from `$e[$L][]`, not `$now[]` | "two P2s and a P3 in round 3" |
  | the brake tested before `continue` | "fix: continue on round 3" |
  | `$j[$L].continue` → any round's `continue` | "one P2 left in round 4" |
  | the reason left out of the last line | "one P2 left in round 3" |

  All nine were caught on the planner's prototype. One mutant is equivalent and needs no test: `.eff == "P2"` → `.severity == "P2"` (inside `$now` the two are always equal).
- Also update the script's header comment (the brake list, and "ASK JUSTIN" in the outcome list) and the test file's header comment (the test count).
- GREEN for the task: `bash scripts/review-check.test.sh` ends `# passed 16, failed 0`.

**3. The rebase receipt in `ac-check.sh`** (the third criterion). Code: Appendix B.
- **New option:** `--rebase-receipt <log>`, given before the two report paths like the other options. Without it the script prints the same bytes and exits the same as today.
- **The receipt** is one log the finisher writes after a rebase, in `<evidence>/rebase/` (never inside `verifier/` or `auditor/`), with the run recipe's shape: first line `HEAD=<the new head's 40-character sha>`, then the verbose output of every agent-run AC's test, last line `EXIT=0`:

  ```
  ( set -o pipefail; echo "HEAD=$(git -C <worktree> rev-parse HEAD)"; rc=0
    <AC1's test command> || rc=1
    <AC2's test command> || rc=1
    echo "EXIT=$rc" ) > <evidence>/rebase/receipt-<head7>.log 2>&1
  ```

  The commands are the ones the verifier ran. From now on each `ac.json` row carries them in a new, optional field `"command": "<the exact command this row's log came from>"`, which `ac-check.sh` does not read. `(live)` ACs have no line in the receipt.
- **When the receipt carries the reports.** Call the commit the verifier's `head` names RH. The reports count for HEAD when all of these hold; then the script prints `REBASE  ACCEPTED: HEAD <head7> is a pure rebase of <RH7>, and the receipt ran on it` after the AC lines and before the `REVIEWS` line:
  - RH is a commit in the worktree and is not HEAD;
  - **pure rebase**, decided as `review-check.sh` decides it: with OB = `git merge-base RH HEAD`, the patch-ids (`git diff-tree -p … | git patch-id --verbatim`) of the non-merge commits of `OB..RH`, oldest first, are a non-empty list equal to those of `--base..HEAD`, and `--base..HEAD` holds no merge commit. A conflict resolved, a commit added, dropped or reordered, or `main` merged in is not a pure rebase;
  - the receipt's `HEAD=` line is HEAD, its last line is exactly `EXIT=0`, and it has no skipped-test line.
- **Then each AC is judged as today, with three differences:** the report's `head` and each log's `HEAD=` must be RH, not HEAD; each `base_log` must have run on OB (the base RH grew from), not on `--base`; and the row's `test` must have a pass line and no fail line **in the receipt** as well as in its own log (reasons: `verifier: the rebase receipt shows no pass line for <test>`, `… shows <test> failing`).
- **When it doesn't,** the script prints `REBASE  NOT ACCEPTED: <why>` and judges as if no receipt was given, so every agent-run AC is `NOT ACCEPTED` ("verifier checked <RH7>, the worktree is at <head7>"). The reasons: `the verifier's head <h7> is not a commit in the worktree`; `HEAD <head7> is not a pure rebase of the reports' head <RH7>`; `the receipt ran on <x7 or unknown>, not HEAD <head7>`; `the receipt's last line is not EXIT=0`; `the receipt shows skipped tests (run only the ACs' tests)`.
- When the verifier's report is already for HEAD the receipt isn't needed: `REBASE  NOT NEEDED: the verifier's report is for HEAD <head7>`, and today's checks apply.
- **Exit 2** (an `error:` line): no file at the receipt's path; the receipt inside one of the two report folders; `--rebase-receipt` with no value; git failing while it computes the patch-ids (never read as "equal").
- **Checks that must keep refusing, with or without the receipt:** uncommitted changes; an AC missing from a report or listed twice; `accepted` not the boolean `true`; a test the approved plan doesn't name; a log missing, outside its report's folder or shared by hard link; a log that doesn't end `EXIT=0` or shows a fail or skip line; the base-log rules; the screenshot; a `(live)` AC an agent saw fail; and with `--reviews`, a head no clean review covers (the referee already counts a pure rebase of the reviewed head as covered).
- **Test first.** Add `pure_rebase_receipt_accepts_earlier_reports` (Appendix B) before `ac11_ac_check_existing_cases_pass` and add its name to `OFFLINE` after `ac10_ac_check_accepts_reviewed_head`. RED on the base script: its first case gets exit 2 (the usage line) where it wants exit 0 and `ALL ACCEPTED: 2 of 2 ACs on <head7>`. Then apply the script change: GREEN.
- **Mutations the new test must catch:**

  | Mutation | Case that fails |
  |---|---|
  | the pure-rebase test always true | "a commit added after the rebase" |
  | patch-ids compared after `sort` | "two commits swapped" |
  | the merge count left out | "a merge of main" |
  | the receipt's `HEAD=` not checked | "a receipt from the old head" |
  | the receipt's `EXIT=0` not checked, or any `EXIT=<n>` taken | "a receipt that exits 1" |
  | skipped tests allowed | "a receipt with a skipped test" |
  | no pass line needed per AC | "a receipt without AC2's test" |
  | a fail line ignored per AC | "a receipt where AC2's test fails once and passes once" |
  | base logs compared with `--base` | "a pure rebase with a receipt" |
  | base logs not checked in this mode | "a base log from the new base" |
  | logs compared with HEAD | "a pure rebase with a receipt" |
  | the report's head not checked in this mode | "the auditor's report for another head" |
  | a git failure read as "not pure" (exit 1) | "git patch-id fails" |
  | a receipt allowed inside a report folder | "a receipt inside the verifier's folder" |
  | the NOT NEEDED branch removed | "reports for HEAD, with a receipt" |

  All sixteen were caught on the planner's prototype. Two mutants are equivalent and need no test: dropping the `-z $pa` test (an empty list on one side can only equal an empty list on the other, and then `--base..HEAD` holds only merges, which the merge count refuses), and `pids "$mb" "$c0"` → `pids "$BASESHA" "$c0"` (both list the commits of RH that are not on the new base).
- **Regression proof for "the same bytes without the option":** `bash scripts/ac-check.test.sh` ends `all passed`, and `REVIEW_LOOP_BASE=<the story's base> bash scripts/review-check.test.sh ac11_ac_check_existing_cases_pass` is `ok` (it runs the base's `ac-check.test.sh` against the new script and compares five outputs byte for byte).
- Also update the script's header comment and its usage line (`[--reviews <evidence folder>] [--rebase-receipt <log>]`).
- GREEN for the task: `bash scripts/review-check.test.sh` ends `# passed 17, failed 0`.

**4. The rules test, then the rule text** (the first criterion), one commit.
- **Test first:** create `scripts/pipeline-rules.test.sh` with the helpers and runner of `review-check.test.sh` (`HERE`, `SRC`, `fail`, `need`, `run()`; like there, every file is read from the checkout under `$SRC`, never from the live home). `routing_text_agrees` checks, in this order:
  1. **The routing sentence** (in "The chosen set") is in each of: `.claude/CLAUDE.md`, `feature-dispatch/SKILL.md`, `references/mini-pipeline.md`, `leorna/SKILL.md`, `review-fix-cadence/SKILL.md`.
  2. **The Agent-tool values** are in the `**The pipeline.**` paragraph of `CLAUDE.md`, as these three fragments: ``planner and round-1 reviewer `model: "fable"`, `effort: "high"` ``; ``builder and AC auditor `model: "opus"`, `effort: "xhigh"` ``; ``later-round reviewers, fixers, verifier and finisher `model: "opus"`, `effort: "high"` ``.
  3. **The two role tables** (`SKILL.md` and `mini-pipeline.md`): the row starting `| Planner` has `**Fable 5.2**` and `**high**`; `| Builder` has `**Opus 5.5**` and `**xhigh**`; `| Reviewer, round 1` has `**Fable 5.2**` and `**high**`; `| Reviewer, later rounds` has `**Opus 5.5**` and `**high**`; `| Fixer` and `| Verifier` have `**Opus 5.5**` and `**high**`, and neither has `xhigh` or `Fable`; `| AC auditor` has `**Opus 5.5**` and `**xhigh**`; in `SKILL.md`, `| Finisher` has `**Opus 5.5**` and `high`.
  4. **The changed rules are stated:** `CLAUDE.md` step 5 has `only P2` and `follow-up`; step 7 has `--rebase-receipt` and `pure rebase`; the "Agent models" bullet has `2026-11-10`; `CLAUDE.md` and `main-chat-housekeeping.md` each have `300k`; `review-loop.md` has `only P2 left from round 3 on` and `follow-up`; `ac-verification.md` has `--rebase-receipt`, `REBASE  ACCEPTED` and `"command"`; `mini-pipeline.md` has `--rebase-receipt` and `only P2`; `review-fix-cadence/SKILL.md` has a brake line starting `  - (e)` with `only P2`.
  5. **None of these 21 old phrases** is left in any file of "Where the rules are stated" (each is in at least one of them today, so the test is RED on the base):
     `once by each model` · ``reviewers and verifier `model: "fable"` `` · `every reviewer and the verifier` · ``builder and fixers `model: "opus"`, `effort: "xhigh"` `` · `builder and every fixer` · `a fresh Fable 5.2 every round` · `fresh Fable review of the fix commits` · `Fable 5.2 high reviews, Opus 5.5 xhigh fixes` · `Opus 5.5 xhigh FIXER` · `xhigh for builder, fixer and AC auditor` · `Fixers use the builder's model and effort` · `the verifier is Fable 5.2 high` · `Fable verifier` · `fresh Fable full review 2` · `Use a fresh Fable 5.2 high reviewer` · `model: Fable 5.2 high, a fresh agent` · `Sol 6.1 xhigh review, fixes, then Opus 5.5 xhigh review` · `Opus 5.5 at high effort for every role` · `not by lowering effort` · ``you run verifier → auditor → `ac-check.sh` again on it`` · `forces another verifier → auditor round`
  6. **The Codex copy:** build it into a scratch folder (`CODEX_HOME=<scratch> CODEX_BUILD_RULES=$SRC/.claude/CLAUDE.md bash $SRC/.claude/setup/codex/build-codex.sh`); `<scratch>/AGENTS.md` has the routing sentence and none of the 21 phrases.
- **Then the text,** file by file as the table in "Where the rules are stated" says. Fold each change into the line that states the old rule; replace, don't append. Words that must stay because `ac12_docs_name_the_review_loop` pins them: in `CLAUDE.md` step 5, `review-check.sh`, `REVIEW AGAIN`, `MOVE ON`, `ASK JUSTIN`, `P0` to `P3`, `scenario`, `no fewer`, `new fact`, `round 3`, `No round cap`, `Mini: round 1 only` and 'unless `review-check.sh` says run a full review from `<base>`'; in step 6, `MOVE ON` and `--reviews <evidence>`; `feature-dispatch/SKILL.md` stays under 100,000 characters (74,537 today).
- **The dated notes in `CLAUDE.md`** (in the "Agent models" bullet, replacing the 2026-11-09 text; none may contain the words "once by each model"):
  - *Routing (user, 2026-11-10; replaces 2026-11-09):* the routing sentence. *Why: in the stories since 2026-11-09 Fable ran 39% of the agents and took 56% of the tokens; a Fable verifier run cost $20.02 against $9.26 on Opus high, a Fable review $10.21 against $3.49, a fixer $14.15 at xhigh against $9.82 at high. The rule that each AC is proven by both models (2026-11-09) ended with it; the two separate proofs, verifier then blind auditor, stay.*
  - *Review rounds (user, 2026-11-10; replaces "no round cap" of 2026-11-09):* no cap, but from round 3 a round with only P2 left asks the user: fix or follow-up. *Why: reviewers from round 4 plus fixers from round 3 were 12% of all pipeline tokens, and 38 of the 44 blocking reviews in round 3 or later had only P2 findings.*
  - *After a pure rebase (user, 2026-11-10):* a rebase receipt, not a new verifier and auditor. *Why: re-proving after a rebase or merge was 3.8% of all tokens.*
- **The main-session rule** (`CLAUDE.md` "The pipeline." and step 1, `main-chat-housekeeping.md`): pipeline main sessions run on Opus 5.5 high; at step 1 the orchestrator says its model and effort and, when they differ, asks for `/model opus` and `/effort high` in the same question (Q8 (a)); each time the last running agent returns, it reads its own context size (`scripts/token-report/report.py context ~/.claude/projects/<project key>/<session id>.jsonl`; both names are in its scratchpad path) and, past 300k with nothing running, asks once per quiet spell for a fresh session, after checking that every plan, brief, answer and evidence file is saved.
- RED: `bash scripts/pipeline-rules.test.sh routing_text_agrees` fails on its first check before the text changes. GREEN: it is `ok`, and `bash scripts/review-check.test.sh` still ends `# passed 17, failed 0` (its `ac12` to `ac15` read these files).

**5. The existing suites, docs and records** (the fifth criterion).
- Add `existing_suites_pass` to `scripts/pipeline-rules.test.sh`. It runs only when named (the default run is `routing_text_agrees` alone), and it needs `PIPELINE_RULES_BASE=<folder of base tallies>` (task 0's `<evidence>/base-tallies/`; it fails with a clear message without it). It checks: `ac-check.test.sh` ends `all passed`; `review-check.test.sh` ends `# passed 17, failed 0` and its `ok` lines name all 15 tests of the base's `OFFLINE` list; and for `codex-parity.test.sh` and every `~/.claude/hooks/tests/*.test.sh`, every test in the base's `<suite>.ok` is `ok` on head. A suite that fails on head is run once more alone before it counts (`cortexos-memory.test.sh` is timing-sensitive).
- Run it; keep its output as the AC's log.
- Follow-ups: append one line each to `~/.hermes/plans/claude-setup/follow-ups-review-loop.md` for the two outside notes (FigmaToBricksV2's `CLAUDE.md` size, the Adobe plugin's skill listing), for the five cuts left out (L1 to L5), and for Q8 (b).
- **After the merge (finisher):** run `~/.claude/setup/sync.sh` once. It rebuilds `~/.codex/AGENTS.md` and pushes. Check `bash ~/.claude/setup/codex/build-codex.sh --check` exits 0 and `grep -c 'reviewer round 1 Fable 5.2 high, later rounds Opus 5.5 high' ~/.codex/AGENTS.md` prints at least 1. The Mac gets all of it at its next pull. The Codex pipeline model does not change (`set-pipeline-model.sh` is not run): in Codex every role runs on the one Codex model.
- Until the merge, don't run `sync.sh` between the finisher's rebase and the `--ff-only` merge (`ac-verification.md`, setup-repo stories): each sync moves `main`.

**Touched files:** `~/.claude/CLAUDE.md`; `~/.claude/setup/codex/agents-header.md`; under `feature-dispatch/`: `SKILL.md`, `references/mini-pipeline.md`, `references/review-loop.md`, `references/ac-verification.md`, `references/main-chat-housekeeping.md`, `scripts/review-check.sh`, `scripts/review-check.test.sh`, `scripts/ac-check.sh`, `scripts/pipeline-rules.test.sh` (new), `scripts/token-report/*` (new); `leorna/SKILL.md`, `review-fix-cadence/SKILL.md`, `figma-to-bricks/SKILL.md`; `~/.hermes/plans/claude-setup/follow-ups-review-loop.md`. Generated after the merge, never edited: `~/.codex/AGENTS.md`. Not touched: `settings.json`, hooks, `ac-check.test.sh`, `model-routing.md`, the Codex role files.

## Risks

- The savings from the model changes come from comparing different days and stories. The live criterion is the real check; the token report makes it one command.
- A later-round reviewer on Opus high found about a third as many P2s per review as Fable in the measured sample. Every fix is still reviewed, and round 1 is still Fable.
- The round-3 question means some P2 findings ship as follow-ups, when you say so. They are listed for you at the finish, as P3s are today. A story you are not there to answer waits at `ASK JUSTIN`.
- A rebase onto a changed `main` can break an AC without a conflict. The receipt's test runs on the new head catch that, and the gates the finisher runs after its rebase stay as today. `patch-id --verbatim` counts context lines, so a clean rebase onto `main` text within 3 lines of a story hunk is not "pure" and takes the full path: safe, and a smaller saving than the upper bound.
- The receipt reruns the verifier's commands. Reports written before this job carry no `command` field: for those the finisher takes the commands from the plan and the logs, and a receipt that misses a test is refused, which costs the full path, not a wrong accept.
- L6 depends on you switching the session (Q8 (a)); nothing enforces it.

## Planner's receipts

**Analysis (first planner).** Forecast 60 to 90 minutes, done in about 20 (10:07 to 10:27 on 2026-11-10): the transcripts were more regular than expected (971 of 979 agents carried a brief path). Checks run: the four measurement scripts, and the two gate test suites for the baseline. Nothing but this plan and the scripts in `~/.cache/pipeline-token-diet-planner/` was written.

**Amendment (second planner).** Forecast 45 to 75 minutes from 10:44 on 2026-11-10; the end time is in the hand-back. Only this plan file was changed. Scratch, in `~/.cache/pipeline-token-diet-planner-2/` (nothing in the live setup was edited):
- `proto/`: copies of the four gate files with both script changes and both new tests applied. Run there: the referee and `ac-check` tests of `review-check.test.sh` (`ac1` to `ac10`, `ac16`) and all of `ac-check.test.sh` pass with the changes once the three assertions named in task 2 are updated; each new test fails on today's script (the RED lines quoted in tasks 2 and 3); the mutation tables of tasks 2 and 3, mutant by mutant.
- `base-tallies/`: the base runs of the hook, Codex-parity and sync suites quoted under "Baseline".
- The code in the appendices was then taken back out of this file and applied to a fresh copy of today's scripts, and both new tests passed on it: the appendices are the tested text.
- Not run: `ac11` to `ac15`, `ac17` and `ac18` of `review-check.test.sh` (they need the whole checkout or the Mac); no rule file was edited, so `routing_text_agrees` exists only as the list in task 4.

## Appendix A: the late-round brake (task 2)

Apply each diff from `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/` in the worktree with `patch -p1`. The test diff first (it adds the new test, its name in `OFFLINE`, and the three changed assertions), then the script diff.

**A1. `scripts/review-check.test.sh`**

```diff
--- a/scripts/review-check.test.sh
+++ b/scripts/review-check.test.sh
@@ -20,7 +20,7 @@
 OFFLINE="ac1_referee_moves_on_when_clean ac2_referee_reviews_again_on_p0_to_p2
 ac3_referee_counts_p2_without_scenario_as_p3 ac4_referee_asks_when_no_progress
 ac5_referee_asks_on_repeat_without_new_fact ac6_referee_records_justins_answers ac7_referee_checks_head_coverage
-ac8_referee_rejects_bad_records ac9_ac_check_refuses_unreviewed_head ac10_ac_check_accepts_reviewed_head
+ac8_referee_rejects_bad_records p2_only_from_round_3_asks_justin ac9_ac_check_refuses_unreviewed_head ac10_ac_check_accepts_reviewed_head
 ac12_docs_name_the_review_loop ac13_codex_roles_name_the_review_loop ac14_feature_dispatch_under_limit
 ac15_memory_note_retired ac16_scripts_portable_to_macos"
 
@@ -237,11 +237,11 @@
   C3=$(cm d.txt three three)
   fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"
   rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)"; judge
-  want 3 "ASK JUSTIN: review-3: 1 P0-P2, no fewer than review-2's 1" "3, 1, then 1" || return 1
+  want 3 "ASK JUSTIN: review-3: 1 P0-P2, no fewer than review-2's 1; only P2 left from round 3 on (R3-1): fix or follow-up?" "3, 1, then 1" || return 1
   fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)"
   rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)" "$(finding R2-2 P2)" "$(finding R2-3 P2)"
   rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)" "$(finding R3-2 P2)"; judge
-  want 1 "REVIEW AGAIN: 2 P0-P2 finding(s) in review-3 at ${C3:0:7}: fix them, then review the fix commits" "1, 3, then 2" || return 1
+  want 3 "ASK JUSTIN: review-3: only P2 left from round 3 on (R3-1, R3-2): fix or follow-up?" "1, 3, then 2: fewer, but only P2 left in round 3" || return 1
   done_ok
 }
 
@@ -280,7 +280,7 @@
   fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"
   rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)" "$(finding R2-2 P2)"
   rev 3 delta "$C2" "$C3" "$(finding R3-1 P2 "$SC" R1-1)"; judge
-  want 3 "ASK JUSTIN: review-3: repeats with no new fact: R3-1 repeats R1-1" "review-3 repeats review-1" || return 1
+  want 3 "ASK JUSTIN: review-3: repeats with no new fact: R3-1 repeats R1-1; only P2 left from round 3 on (R3-1): fix or follow-up?" "review-3 repeats review-1" || return 1
   # two stalls, and both brakes at once
   fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)"
   rev 2 full "$BASE" "$C2" "$(finding R2-1 P2 "$SC" R1-1)" "$(finding R2-2 P1 "$SC" R1-2)"; judge
@@ -642,6 +642,67 @@
   done_ok
 }
 
+p2_only_from_round_3_asks_justin() {
+  local C3 C4 W='"words": "R3-2 is a follow-up"'
+  need "$RC" || return 1
+  newroot; mkrepo || fail "fixture repo" || return 1
+  C3=$(cm d.txt three three) && C4=$(cm d.txt four four) || fail "fixture commits" || return 1
+  Q() { echo "ASK JUSTIN: review-$1: only P2 left from round 3 on ($2): fix or follow-up?"; }   # Q <round> <ids>
+  r12() { fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)" "$(finding R1-3 P2)" "$(finding R1-4 P2)"
+          rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)" "$(finding R2-2 P2)" "$(finding R2-3 P2)"; }   # rounds 1 and 2: 4 P2s, then 3
+  # round 3, fewer P2s than round 2 and no repeat: brakes c and d are silent, the late-round brake asks
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)"; judge
+  want 3 "$(Q 3 R3-1)" "one P2 left in round 3" || return 1
+  has "R3-1  P2  lib/x.sh:R3-1  claim of R3-1" "the finding line before ASK JUSTIN" || return 1
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)" "$(finding R3-2 P2)" "$(finding R3-3 P3)"; judge
+  want 3 "$(Q 3 "R3-1, R3-2")" "two P2s and a P3 in round 3: the line names the P2s only" || return 1
+  r12; rev 3 full "$BASE" "$C3" "$(finding R3-1 P2)"; judge
+  want 3 "$(Q 3 R3-1)" "a full round 3 asks too" || return 1
+  # later rounds too
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)" "$(finding R3-2 P2)"; justin 3 '{"words": "fix them", "continue": true}'
+  rev 4 delta "$C3" "$C4" "$(finding R4-1 P2)"; judge
+  want 3 "$(Q 4 R4-1)" "one P2 left in round 4 (round 3's continue doesn't answer it)" || return 1
+  # Justin's answers: fix = continue, follow-up = accept, or both
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)" "$(finding R3-2 P2)"; justin 3 '{"words": "fix them", "continue": true}'; judge
+  want 1 "REVIEW AGAIN: 2 P0-P2 finding(s) in review-3 at ${C3:0:7}: fix them, then review the fix commits" "fix: continue on round 3" || return 1
+  justin 3 "{$W, \"accept\": [\"R3-1\", \"R3-2\"]}"; judge "$BASE"
+  want 1 "REVIEW AGAIN: 1 commit(s) after review-3's head ${C3:0:7} are unreviewed: review ${C3:0:7}..${C4:0:7}" "follow-up: both accepted, the round is clean (HEAD is one commit on)" || return 1
+  has "R3-1  ACCEPTED  lib/x.sh:R3-1  claim of R3-1" "an accepted P2's line" || return 1
+  ing git -C "$R" checkout -q -B at3 "$C3" || fail "checkout" || return 1
+  judge; want 0 "MOVE ON: review-3 at ${C3:0:7} is clean" "follow-up: both accepted, at the reviewed head" || return 1
+  justin 3 "{$W, \"accept\": [\"R3-2\"]}"; judge
+  want 3 "$(Q 3 R3-1)" "one accepted, no continue: asks again for the one left" || return 1
+  justin 3 "{$W, \"accept\": [\"R3-2\"], \"continue\": true}"; judge
+  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-3 at ${C3:0:7}: fix them, then review the fix commits" "one accepted, the other fixed" || return 1
+  rm "$E/review-3/justin.json"; justin 2 '{"words": "go on", "continue": true}'; judge
+  want 3 "$(Q 3 "R3-1, R3-2")" "continue on round 2 doesn't answer round 3" || return 1
+  # a P0 or P1 in the round: REVIEW AGAIN as before
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P1)" "$(finding R3-2 P2)"; judge
+  want 1 "REVIEW AGAIN: 2 P0-P2 finding(s) in review-3 at ${C3:0:7}: fix them, then review the fix commits" "a P1 and a P2 in round 3" || return 1
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P0)"; judge
+  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-3 at ${C3:0:7}: fix them, then review the fix commits" "a P0 in round 3" || return 1
+  # effective severities: a P1 with no scenario counts as P3, an accepted P1 doesn't count, a no-scenario P2 leaves nothing
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P1 "edge case")" "$(finding R3-2 P2)"; judge
+  want 3 "$(Q 3 R3-2)" "a no-scenario P1 and a P2" || return 1
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P1)" "$(finding R3-2 P2)"; justin 3 "{$W, \"accept\": [\"R3-1\"]}"; judge
+  want 3 "$(Q 3 R3-2)" "an accepted P1 and a P2" || return 1
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2 "edge case")"; judge
+  want 0 "MOVE ON: review-3 at ${C3:0:7} is clean" "only a no-scenario P2 in round 3: clean, nothing to ask" || return 1
+  # rounds 1 and 2: P2-only findings are REVIEW AGAIN as before
+  fresh; rev 1 full "$BASE" "$C3" "$(finding R1-1 P2)"; judge
+  want 1 "$(fix1 1 "$C3")" "P2 only in round 1" || return 1
+  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)"; rev 2 delta "$C1" "$C3" "$(finding R2-1 P2)"; judge
+  want 1 "REVIEW AGAIN: 1 P0-P2 finding(s) in review-2 at ${C3:0:7}: fix them, then review the fix commits" "P2 only in round 2" || return 1
+  # with another brake: every reason is named
+  fresh; rev 1 full "$BASE" "$C1" "$(finding R1-1 P2)" "$(finding R1-2 P2)"; rev 2 full "$BASE" "$C2" "$(finding R2-1 P2)"
+  rev 3 delta "$C2" "$C3" "$(finding R3-1 P2 "$SC" R1-1)"; judge
+  want 3 "ASK JUSTIN: review-3: repeats with no new fact: R3-1 repeats R1-1; 1 P0-P2, no fewer than review-2's 1; only P2 left from round 3 on (R3-1): fix or follow-up?" "all three brakes" || return 1
+  # ac-check.sh --reviews refuses the head while the question is open
+  r12; rev 3 delta "$C2" "$C3" "$(finding R3-1 P2)"; acfix "$C3" "$BASE" AC1; accheck "$BASE" --reviews "$E"
+  want 1 "NOT ACCEPTED: the head ${C3:0:7} isn't covered by a clean review ($(Q 3 R3-1))" "ac-check.sh --reviews while the question is open" || return 1
+  done_ok
+}
+
 # ============================== ac-check.sh --reviews ==============================
 
 ac9_ac_check_refuses_unreviewed_head() {
```

**A2. `scripts/review-check.sh`**

```diff
--- a/scripts/review-check.sh
+++ b/scripts/review-check.sh
@@ -106,11 +106,12 @@
 | [ $now[] | . as $f | select((.repeats // "") != "")
     | select(any($e[0:$L][][]; .id == $f.repeats and (.eff | serious)))
     | select(((.new_fact // "") | words) < 5) | "\(.id) repeats \(.repeats)" ] as $stalled
-| { round: ($L + 1), now: ($now | length), prev: $prev, stalled: $stalled,
+| (if $L >= 2 and ($now | length) > 0 and all($now[]; .eff == "P2") then [ $now[] | .id | oneline ] else [] end) as $late
+| { round: ($L + 1), now: ($now | length), prev: $prev, stalled: $stalled, late: $late,
     lines: [ $e[$L][] | "\(.id | oneline)  \(.eff)  \(.file_line | oneline)  \(.claim | oneline)\(if (.repeats // "") != "" then "  (repeats \(.repeats | oneline))" else "" end)" ],
     outcome: (if ($now | length) == 0 then "clean"
               elif $j[$L].continue == true then "again"
-              elif ($stalled | length) > 0 or ($prev > 0 and ($now | length) >= $prev) then "ask"
+              elif ($stalled | length) > 0 or ($prev > 0 and ($now | length) >= $prev) or ($late | length) > 0 then "ask"
               else "again" end) }
 JQ
 
@@ -210,7 +211,8 @@
     echo "REVIEW AGAIN: $now P0-P2 finding(s) in review-$n at ${RH:0:7}: fix them, then $(next "review the fix commits")"; exit 1 ;;
   ask)
     why=$(jq -r '[ (if (.stalled | length) > 0 then "repeats with no new fact: \(.stalled | join(", "))" else empty end),
-                   (if .prev > 0 and .now >= .prev then "\(.now) P0-P2, no fewer than review-\(.round - 1)'"'"'s \(.prev)" else empty end) ]
+                   (if .prev > 0 and .now >= .prev then "\(.now) P0-P2, no fewer than review-\(.round - 1)'"'"'s \(.prev)" else empty end),
+                   (if (.late | length) > 0 then "only P2 left from round 3 on (\(.late | join(", "))): fix or follow-up?" else empty end) ]
                  | join("; ")' <<<"$v")
     echo "ASK JUSTIN: review-$n: $why"; exit 3 ;;
 esac
```

## Appendix B: the rebase receipt (task 3)

Apply after Appendix A, the same way: the test diff first, then the script diff.

**B1. `scripts/review-check.test.sh`**

```diff
--- a/scripts/review-check.test.sh
+++ b/scripts/review-check.test.sh
@@ -20,7 +20,7 @@
 OFFLINE="ac1_referee_moves_on_when_clean ac2_referee_reviews_again_on_p0_to_p2
 ac3_referee_counts_p2_without_scenario_as_p3 ac4_referee_asks_when_no_progress
 ac5_referee_asks_on_repeat_without_new_fact ac6_referee_records_justins_answers ac7_referee_checks_head_coverage
-ac8_referee_rejects_bad_records p2_only_from_round_3_asks_justin ac9_ac_check_refuses_unreviewed_head ac10_ac_check_accepts_reviewed_head
+ac8_referee_rejects_bad_records p2_only_from_round_3_asks_justin ac9_ac_check_refuses_unreviewed_head ac10_ac_check_accepts_reviewed_head pure_rebase_receipt_accepts_earlier_reports
 ac12_docs_name_the_review_loop ac13_codex_roles_name_the_review_loop ac14_feature_dispatch_under_limit
 ac15_memory_note_retired ac16_scripts_portable_to_macos"
 
@@ -777,6 +777,107 @@
   done_ok
 }
 
+pure_rebase_receipt_accepts_earlier_reports() {
+  local M1 M2 NH NB X RC1 G=$(printf '%040d' 0 | tr 0 f)
+  need "$RC" && need "$ACC" || return 1
+  newroot; mkrepo || fail "fixture repo" || return 1
+  # the story (C1, C2 on BASE) is reviewed and proven at C2; then main moves on and the story is rebased onto it
+  ing git -C "$R" checkout -q main && M1=$(cm m.txt m1 m1) && ing git -C "$R" checkout -q story \
+    && ing git -C "$R" rebase -q main >/dev/null 2>&1 && NH=$(head_) || fail "rebase" || return 1
+  RC1="$E/rebase/receipt.log"
+  receipt() { mkdir -p "$E/rebase" && printf '%s\n' "$@" >"$RC1"; }   # receipt <line>…: the finisher's rebase receipt
+  proven() { fresh; rev 1 full "$BASE" "$C2"; acfix "$C2" "$BASE" "$@"; }   # proven <AC>…: a clean review and both reports at the old head C2
+  refused() { # refused <what> <REBASE line's reason> [<text in AC1's line>]: exit 1, every AC not accepted, and the reason named
+    want 1 "NOT ACCEPTED: 2 of 2 ACs on ${NH:0:7}" "$1" && has "REBASE  NOT ACCEPTED: $2" "$1" || return 1
+    printf '%s\n' "$out" | grep -qF -- "AC1  NOT ACCEPTED: ${3:-verifier checked ${C2:0:7}, the worktree is at ${NH:0:7}}" || fail "$1: AC1's line lacks its reason: $out"
+  }
+  good() { receipt "HEAD=$NH" "ok 1 - test_AC1" "ok 2 - test_AC2" "EXIT=0"; }
+  go() { accheck "$M1" --reviews "$E" --rebase-receipt "$RC1"; }
+  proven AC1 AC2; good; go
+  want 0 "ALL ACCEPTED: 2 of 2 ACs on ${NH:0:7}" "a pure rebase with a receipt" || return 1
+  [ "$out" = "$(printf 'AC1  ACCEPTED\nAC2  ACCEPTED\nREBASE  ACCEPTED: HEAD %s is a pure rebase of %s, and the receipt ran on it\nREVIEWS  CLEAN: review-1 at %s is clean, and HEAD %s is a pure rebase of it\nALL ACCEPTED: 2 of 2 ACs on %s' \
+      "${NH:0:7}" "${C2:0:7}" "${C2:0:7}" "${NH:0:7}" "${NH:0:7}")" ] || fail "want the AC lines, the REBASE line, the REVIEWS line, then the last line: $out" || return 1
+  proven AC1 AC2:live; receipt "HEAD=$NH" "ok 1 - test_AC1" "EXIT=0"; go
+  want 0 "READY FOR THE USER: 1 of 2 ACs proven on ${NH:0:7}; live ACs owed to the user: AC2" "a live AC stays owed" || return 1
+  # without the receipt: as before the option existed
+  proven AC1 AC2; accheck "$M1" --reviews "$E"
+  want 1 "NOT ACCEPTED: 2 of 2 ACs on ${NH:0:7}" "no receipt" || return 1
+  has "AC1  NOT ACCEPTED: verifier checked ${C2:0:7}, the worktree is at ${NH:0:7}; verifier log ran on ${C2:0:7}, not ${NH:0:7}; verifier base_log didn't run on the base commit ${M1:0:7}; auditor checked ${C2:0:7}, the worktree is at ${NH:0:7}; auditor log ran on ${C2:0:7}, not ${NH:0:7}; auditor base_log didn't run on the base commit ${M1:0:7}" "no receipt: AC1's line" || return 1
+  if printf '%s\n' "$out" | grep -q '^REBASE'; then fail "a REBASE line without --rebase-receipt: $out"; return 1; fi
+  # the receipt itself: run on HEAD, EXIT=0 last, no skipped test, every AC's test passing and none failing
+  receipt "HEAD=$C2" "ok 1 - test_AC1" "ok 2 - test_AC2" "EXIT=0"; go
+  refused "a receipt from the old head" "the receipt ran on ${C2:0:7}, not HEAD ${NH:0:7}" || return 1
+  receipt "ok 1 - test_AC1" "ok 2 - test_AC2" "EXIT=0"; go
+  refused "a receipt without HEAD=" "the receipt ran on unknown, not HEAD ${NH:0:7}" || return 1
+  receipt "HEAD=$NH" "ok 1 - test_AC1" "ok 2 - test_AC2" "EXIT=1"; go
+  refused "a receipt that exits 1" "the receipt's last line is not EXIT=0" || return 1
+  receipt "HEAD=$NH" "EXIT=0" "ok 1 - test_AC1" "ok 2 - test_AC2"; go
+  refused "EXIT=0 not on the last line" "the receipt's last line is not EXIT=0" || return 1
+  receipt "HEAD=$NH" "ok 1 - test_AC1" "ok 2 - test_AC2" "ok 3 - other # SKIP no server" "EXIT=0"; go
+  refused "a receipt with a skipped test" "the receipt shows skipped tests (run only the ACs' tests)" || return 1
+  receipt "HEAD=$NH" "ok 1 - test_AC1" "EXIT=0"; go
+  want 1 "NOT ACCEPTED: 1 of 2 ACs on ${NH:0:7}" "a receipt without AC2's test" || return 1
+  has "AC1  ACCEPTED" "the AC the receipt shows" || return 1
+  has "AC2  NOT ACCEPTED: verifier: the rebase receipt shows no pass line for test_AC2; auditor: the rebase receipt shows no pass line for test_AC2" "the AC it lacks" || return 1
+  receipt "HEAD=$NH" "ok 1 - test_AC1" "not ok 2 - test_AC2" "ok 3 - test_AC2" "EXIT=0"; go
+  want 1 "NOT ACCEPTED: 1 of 2 ACs on ${NH:0:7}" "a receipt where AC2's test fails once and passes once" || return 1
+  has "AC2  NOT ACCEPTED: verifier: the rebase receipt shows test_AC2 failing; auditor: the rebase receipt shows test_AC2 failing" "the failing test" || return 1
+  # the reports: both for the one earlier head, logs from it, base logs from the base it grew from
+  good; jq --arg h "$C1" '.head = $h' "$E/auditor/ac.json" >"$S/a.json" && mv "$S/a.json" "$E/auditor/ac.json"; go
+  want 1 "NOT ACCEPTED: 2 of 2 ACs on ${NH:0:7}" "the auditor's report for another head" || return 1
+  has "AC1  NOT ACCEPTED: auditor checked ${C1:0:7}, not ${C2:0:7}, the head the rebase receipt carries" "the auditor's head" || return 1
+  proven AC1 AC2; good; jq --arg h "$G" '.head = $h' "$E/verifier/ac.json" >"$S/a.json" && mv "$S/a.json" "$E/verifier/ac.json"; go
+  refused "the verifier's head is no commit" "the verifier's head fffffff is not a commit in the worktree" "verifier checked fffffff, the worktree is at ${NH:0:7}" || return 1
+  proven AC1 AC2; good; printf 'HEAD=%s\nnot ok 1 - test_AC1\nEXIT=1\n' "$M1" >"$E/verifier/AC1-base.log"; go
+  want 1 "NOT ACCEPTED: 1 of 2 ACs on ${NH:0:7}" "a base log from the new base" || return 1
+  has "AC1  NOT ACCEPTED: verifier base_log didn't run on the base commit ${BASE:0:7}" "base logs belong to the old base" || return 1
+  proven AC1 AC2; good; printf 'HEAD=%s\nok 1 - test_AC1\nEXIT=0\n' "$NH" >"$E/verifier/AC1.log"; go
+  want 1 "NOT ACCEPTED: 1 of 2 ACs on ${NH:0:7}" "a head log from the new head under a report for the old one" || return 1
+  has "AC1  NOT ACCEPTED: verifier log ran on ${NH:0:7}, not ${C2:0:7}" "logs belong to the reports' head" || return 1
+  # the reviews still gate: a P2 open at the old head
+  proven AC1 AC2; good; rev 1 full "$BASE" "$C2" "$(finding R1-1 P2)"; go
+  want 1 "NOT ACCEPTED: the head ${NH:0:7} isn't covered by a clean review ($(fix1 1 "$C2" "$M1"))" "an open P2 in the review" || return 1
+  has "REBASE  ACCEPTED: HEAD ${NH:0:7} is a pure rebase of ${C2:0:7}, and the receipt ran on it" "the REBASE line" || return 1
+  # reports already for HEAD: the receipt isn't needed, the usual checks apply
+  fresh; rev 1 full "$BASE" "$C2"; acfix "$NH" "$M1" AC1 AC2; good; go
+  want 0 "ALL ACCEPTED: 2 of 2 ACs on ${NH:0:7}" "reports for HEAD, with a receipt" || return 1
+  has "REBASE  NOT NEEDED: the verifier's report is for HEAD ${NH:0:7}" "the REBASE line" || return 1
+  # bad usage: exit 2
+  proven AC1 AC2; good
+  accheck "$M1" --rebase-receipt "$E/rebase/none.log"; bad2 '^error: --rebase-receipt: no file at ' "a receipt that doesn't exist" || return 1
+  cp "$RC1" "$E/verifier/receipt.log"; accheck "$M1" --rebase-receipt "$E/verifier/receipt.log"
+  bad2 '^error: --rebase-receipt: the receipt must sit outside the two report folders' "a receipt inside the verifier's folder" || return 1
+  out=$(ing bash "$ACC" --repo "$R" --base "$M1" --plan "$E/plan.md" "$E/verifier/ac.json" "$E/auditor/ac.json" --rebase-receipt 2>"$S/err"); rc=$?; err=$(cat "$S/err")
+  [ "$rc" = 2 ] || fail "--rebase-receipt with no value: want exit 2, got $rc: $out $err" || return 1
+  # git can't compute the patch-ids: an error, never "equal"
+  mkdir -p "$S/fakegit" && printf '%s\n' '#!/bin/sh' 'case " $* " in *" patch-id "*) echo "error: unknown option verbatim" >&2; exit 129 ;; esac' 'exec "$REAL_GIT" "$@"' >"$S/fakegit/git" \
+    && chmod +x "$S/fakegit/git" || fail "fake git" || return 1
+  X=$(command -v git); PATH="$S/fakegit:$PATH" REAL_GIT=$X accheck "$M1" --rebase-receipt "$RC1"
+  bad2 "^error: --rebase-receipt: can't compute the patch-ids" "git patch-id fails" || return 1
+  # not a pure rebase: each of these refuses, receipt and all
+  notpure() { # notpure <what>: HEAD has moved; a receipt for it, then the check
+    X=$(head_); receipt "HEAD=$X" "ok 1 - test_AC1" "ok 2 - test_AC2" "EXIT=0"
+    accheck "$(ing git -C "$R" merge-base HEAD main)" --rebase-receipt "$RC1"
+    want 1 "NOT ACCEPTED: 2 of 2 ACs on ${X:0:7}" "$1" && has "REBASE  NOT ACCEPTED: HEAD ${X:0:7} is not a pure rebase of the reports' head ${C2:0:7}" "$1"
+  }
+  cm e.txt extra extra >/dev/null; notpure "a commit added after the rebase" || return 1
+  ing git -C "$R" reset -q --hard "$NH" && printf 'two resolved\n' >>"$R/c.txt" && ing git -C "$R" commit -q -a --amend -m two || fail "amend" || return 1
+  notpure "a patch changed (a resolved conflict)" || return 1
+  ing git -C "$R" reset -q --hard "$NH~1"; notpure "a commit dropped" || return 1
+  ing git -C "$R" checkout -q -B story main && ing git -C "$R" cherry-pick "$C2" "$C1" >/dev/null 2>&1 || fail "swap" || return 1
+  notpure "two commits swapped" || return 1
+  ing git -C "$R" checkout -q -B story "$C2"; X=$(head_); receipt "HEAD=$X" "ok 1 - test_AC1" "ok 2 - test_AC2" "EXIT=0"
+  jq --arg h "$C1" '.head = $h' "$E/verifier/ac.json" >"$S/a.json" && mv "$S/a.json" "$E/verifier/ac.json"
+  accheck "$BASE" --rebase-receipt "$RC1"
+  want 1 "NOT ACCEPTED: 2 of 2 ACs on ${C2:0:7}" "no rebase: a commit after the reports' head" || return 1
+  has "REBASE  NOT ACCEPTED: HEAD ${C2:0:7} is not a pure rebase of the reports' head ${C1:0:7}" "no rebase" || return 1
+  # main merged into the rebased story instead of a second rebase: the same patches, but a merge no review saw
+  proven AC1 AC2; ing git -C "$R" checkout -q -B story "$NH" && ing git -C "$R" checkout -q main && M2=$(cm m.txt m2 m2) \
+    && ing git -C "$R" checkout -q story && ing git -C "$R" merge -q --no-ff -m merge main >/dev/null 2>&1 || fail "merge" || return 1
+  notpure "a merge of main" || return 1
+  done_ok
+}
+
 ac11_ac_check_existing_cases_pass() {
   local base t p n o_old o_new rc_old rc_new
   need "$RC" && need "$ACC" || return 1
```

**B2. `scripts/ac-check.sh`**

```diff
--- a/scripts/ac-check.sh
+++ b/scripts/ac-check.sh
@@ -52,13 +52,14 @@
 
 usage() { echo "usage: ac-check.sh --repo <worktree> --base <base commit> --plan <approved plan> <verifier report> <auditor report>" >&2; exit 2; }
 die() { echo "error: $*" >&2; exit 2; }
-repo="" base="" plan="" reviews="" withrev=0
+repo="" base="" plan="" reviews="" withrev=0 receipt="" withrec=0
 while (($#)); do
   case $1 in
     --repo) (($# >= 2)) || usage; repo=$2; shift 2 ;;
     --base) (($# >= 2)) || usage; base=$2; shift 2 ;;
     --plan) (($# >= 2)) || usage; plan=$2; shift 2 ;;
     --reviews) (($# >= 2)) || usage; reviews=$2; withrev=1; shift 2 ;;
+    --rebase-receipt) (($# >= 2)) || usage; receipt=$2; withrec=1; shift 2 ;;
     -*) usage ;;
     *) break ;;
   esac
@@ -143,6 +144,51 @@
   return 1
 }
 
+# --rebase-receipt: the reports prove an earlier head RH. They count for HEAD only when HEAD is a pure
+# rebase of RH (review-check.sh's rule: the same patches in the same order, no merges) and the receipt
+# is a run on HEAD that ends EXIT=0 with no skipped test; judge then wants each AC's test passing in it.
+# OB is the base RH grew from: the reports' base logs ran there, not on --base.
+pids() { # pids <from> <to>: a patch-id per non-merge commit, oldest first (as in review-check.sh)
+  local c p
+  git -C "$repo" rev-list --reverse --topo-order --no-merges "$1..$2" | while IFS= read -r c; do
+    p=$(git -C "$repo" diff-tree -p --no-commit-id --full-index "$c" \
+        | git -C "$repo" patch-id --verbatim | cut -d' ' -f1) || exit 1
+    echo "${p:-empty:$(git -C "$repo" log -1 --format=%s "$c")}"
+  done
+}
+RH="" OB="" rline=""
+if ((withrec)); then
+  [[ -f $receipt ]] || die "--rebase-receipt: no file at $receipt"
+  rreal=$(realpath "$receipt" 2>/dev/null) || die "--rebase-receipt: can't read $receipt"
+  for i in 0 1; do
+    case $rreal in "${dirs[$i]}"/*) die "--rebase-receipt: the receipt must sit outside the two report folders" ;; esac
+  done
+  h0=$(jq -r '.head' "${files[0]}") c0="" rwhy=""
+  ((${#h0} >= 7)) && c0=$(commit "$h0")
+  if [[ -z $c0 ]]; then rwhy="the verifier's head ${h0:0:7} is not a commit in the worktree"
+  elif [[ $c0 == "$HEADSHA" ]]; then rline="REBASE  NOT NEEDED: the verifier's report is for HEAD ${HEADSHA:0:7}"
+  else
+    mb=$(git -C "$repo" merge-base "$c0" "$HEADSHA" 2>/dev/null) || mb=""
+    pa="" pb=""
+    if [[ -n $mb ]]; then
+      pa=$(pids "$mb" "$c0" 2>/dev/null) && pb=$(pids "$BASESHA" "$HEADSHA" 2>/dev/null) \
+        || die "--rebase-receipt: can't compute the patch-ids that compare HEAD ${HEADSHA:0:7} with the reports' head ${c0:0:7} (git diff-tree | git patch-id --verbatim failed)"
+    fi
+    x=$(ran_on "$receipt") l=$(last_line "$receipt")
+    if [[ -z $pa || $pa != "$pb" || $(git -C "$repo" rev-list --count --merges "$BASESHA..$HEADSHA") != 0 ]]; then
+      rwhy="HEAD ${HEADSHA:0:7} is not a pure rebase of the reports' head ${c0:0:7}"
+    elif [[ $x != "$HEADSHA" ]]; then y=${x:0:7}; rwhy="the receipt ran on ${y:-unknown}, not HEAD ${HEADSHA:0:7}"
+    elif [[ $l != EXIT=0 ]]; then rwhy="the receipt's last line is not EXIT=0"
+    elif grep -qE -- "$skip_any_re" "$receipt"; then rwhy="the receipt shows skipped tests (run only the ACs' tests)"
+    else
+      RH=$c0 OB=$mb
+      rline="REBASE  ACCEPTED: HEAD ${HEADSHA:0:7} is a pure rebase of ${RH:0:7}, and the receipt ran on it"
+    fi
+  fi
+  [[ -z $rwhy ]] || rline="REBASE  NOT ACCEPTED: $rwhy"
+fi
+WANT=${RH:-$HEADSHA} WBASE=${OB:-$BASESHA}   # the head the reports and their logs are for, and its base
+
 # inodes of every receipt each report cites: a hard link across reports is a shared receipt
 receipt_inodes() { # receipt_inodes <report index>
   local f=${files[$1]} dir=${dirs[$1]} p
@@ -168,7 +214,11 @@
   fi
 
   h=$(jq -r '.head' "$f")
-  ((${#h} >= 7)) && [[ $HEADSHA == "$h"* ]] || { echo "$who checked ${h:0:7}, the worktree is at ${HEADSHA:0:7}"; bad=1; }
+  if [[ -n $RH ]]; then
+    ((${#h} >= 7)) && [[ $RH == "$h"* ]] || { echo "$who checked ${h:0:7}, not ${RH:0:7}, the head the rebase receipt carries"; bad=1; }
+  else
+    ((${#h} >= 7)) && [[ $HEADSHA == "$h"* ]] || { echo "$who checked ${h:0:7}, the worktree is at ${HEADSHA:0:7}"; bad=1; }
+  fi
   t=$(get test)
   if [[ -z ${t// /} ]]; then echo "$who gives no test name"; bad=1
   elif [[ $t == *[[:cntrl:]]* ]]; then echo "$who gives a test name with control characters"; bad=1; t=""
@@ -182,7 +232,7 @@
   elif ! inside "$p" "$dir"; then echo "$who uses a receipt outside its own folder"; bad=1
   else
     x=$(ran_on "$p"); x=${x:0:7}
-    [[ $(ran_on "$p") == "$HEADSHA" ]] || { echo "$who log ran on ${x:-unknown}, not ${HEADSHA:0:7}"; bad=1; }
+    [[ $(ran_on "$p") == "$WANT" ]] || { echo "$who log ran on ${x:-unknown}, not ${WANT:0:7}"; bad=1; }
     l=$(last_line "$p")
     if [[ ! $l =~ $exit_re ]]; then echo "$who log's last line is not EXIT="; bad=1
     elif [[ ${l#EXIT=} != 0 ]]; then echo "$who log exits ${l#EXIT=}"; bad=1; fi
@@ -192,6 +242,10 @@
       elif ! grep -qE -- "$(pass_re "$t")" "$p"; then echo "$who log shows no pass line for $t"; bad=1; fi
     fi
   fi
+  if [[ -n $RH && -n ${t// /} ]]; then   # the same test, run again on HEAD after the rebase
+    if grep -qE -- "$(fail_re "$t")" "$receipt"; then echo "$who: the rebase receipt shows $t failing"; bad=1
+    elif ! grep -qE -- "$(pass_re "$t")" "$receipt"; then echo "$who: the rebase receipt shows no pass line for $t"; bad=1; fi
+  fi
 
   p=$(get base_log)
   if [[ -n $p ]]; then
@@ -200,7 +254,7 @@
     elif ! inside "$p" "$dir"; then echo "$who uses a receipt outside its own folder"; bad=1
     else
       x=$(ran_on "$p")
-      [[ -n $x && $(commit "$x") == "$BASESHA" ]] || { echo "$who base_log didn't run on the base commit ${BASESHA:0:7}"; bad=1; }
+      [[ -n $x && $(commit "$x") == "$WBASE" ]] || { echo "$who base_log didn't run on the base commit ${WBASE:0:7}"; bad=1; }
       l=$(last_line "$p")
       if [[ ! $l =~ $exit_re ]]; then echo "$who base_log's last line is not EXIT="; bad=1
       elif [[ -n ${t// /} ]] && grep -qE -- "$(pass_re "$t")" "$p"; then echo "$who: the test passes on the old code"; bad=1
@@ -256,6 +310,7 @@
   fi
 done <<<"$acs"
 
+[[ -z $rline ]] || echo "$rline"
 if ((withrev)); then
   if ((covered)); then echo "REVIEWS  CLEAN: ${rlast#MOVE ON: }"; else echo "REVIEWS  NOT ACCEPTED: $rlast"; fi
 fi
```
