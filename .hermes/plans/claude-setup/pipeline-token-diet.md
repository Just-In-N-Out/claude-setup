# pipeline-token-diet: where the pipeline's tokens go, and what to cut

Status: **analysis done, waiting for Justin's picks** (Q1 to Q7). Nothing is changed yet.
Planner: Fable 5.2 high, 2026-11-10. Brief: `~/.hermes/plans/claude-setup/briefs/pipeline-token-diet-planner.md`.

**Playback:** the bug/story pipeline uses too many tokens and you hit usage limits; you asked for a total, measured analysis of where they go, priced options, and then you decide.

## Questions for Justin (answer these to approve)

1. **Q1. Which package?** Light (about -15%), Medium (about -45%), Deep (about -55%). Details in "Packaged options". **I recommend Medium.** It keeps every guard that has an incident behind it (every fix reviewed, two AC proofs, plan approval) and cuts where the numbers show the least return.
2. **Q2. Which limit do you actually hit?** The 5-hour window or the weekly one, and the all-models limit or a Fable-only one? I could not find how the subscription weighs Fable against Opus, or cache reads against output. If the Fable limit is the one you hit, the model changes (Q3, Q4) matter most; if it is the all-models limit, the loop and baggage cuts matter most. **Please read `/usage` after your next story and tell me.**
3. **Q3. Reviewer model.** (a) Fable high for round 1, Opus high for the later delta rounds; (b) Opus high for every round; (c) keep Fable high for every round. Measured: a Fable review costs $10.21, an Opus high review $3.49; a Fable round-1 review finds 2.5 P2 and 0.5 P0/P1, Opus high finds 0.91 and 0.09, Opus xhigh 1.73 and 0.13. **I recommend (a):** the strongest reviewer reads the whole story once; the cheaper one checks the small fix diffs.
4. **Q4. Verifier model.** (a) Opus high (measured $9.26 a run, against $20.02 on Fable, n=8); (b) keep Fable high. With (a) the verifier and the auditor are both Opus, so your 2026-11-09 rule "every AC is proven once by each model" ends. **I recommend (a)** with the auditor kept: two blind proofs stay, both on Opus high.
5. **Q5. Late review rounds.** From round 3 on, when a review has only P2 findings left (no P0, no P1): (a) `review-check.sh` prints `ASK JUSTIN` with the P2 lines and you choose "fix" or "follow-up"; (b) they go to `follow-ups.md` without asking; (c) keep looping as now. Measured: reviewers from round 4 plus fixers from round 3 are 12.0% of all tokens, and 38 of the 44 blocking reviews in round 3 or later had P2 findings only. **I recommend (a).** It changes your "no round cap" rule of 2026-11-09 into "no cap, but you are asked from round 3".
6. **Q6. Orchestrator session.** `settings.json` runs the main session on Fable. Measured: a main-session call costs $0.30 on Fable and $0.13 on Opus, the main session makes 7.4 calls per agent, and three sessions grew to the 1M-token limit. (a) Run pipeline sessions on Opus high and start a fresh session when no agent is running and the context passes 300k; (b) keep as is. **I recommend (a).** This is a habit plus one line in `CLAUDE.md`, not a guard.
7. **Q7. Size of this job.** Medium and Deep change both gate scripts (`review-check.sh`, `ac-check.sh`) and five rule files. That is more than a Mini job. **I recommend Full**, or two jobs: rules and agent type (Mini), scripts (Full). Light without cut L7 fits Mini.

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

## Acceptance criteria (all proposed; written for Medium)

- AC1 (proposed): Given the routing chosen in Q3, Q4 and Q6, when the consistency test reads `~/.claude/CLAUDE.md` (pipeline paragraph and "Agent models" bullet), `references/mini-pipeline.md`, `references/model-routing.md` and `SKILL.md` "Which model runs which agent", then every role has the same model and effort in all of them and no older pairing remains. Test: `routing_text_agrees` in `scripts/pipeline-rules.test.sh`.
- AC2 (proposed): Given `~/.claude/agents/pipeline-agent.md`, when the test reads its frontmatter, then its tool list has no `Artifact` and no `Agent`, it names no model (the orchestrator passes model and effort per role), and `CLAUDE.md` and `SKILL.md` name this type for every role except a planner that must read a ClickUp card. Test: `pipeline_agent_type_is_slim` in `scripts/pipeline-rules.test.sh`.
- AC3 (proposed) (live): When the orchestrator dispatches the next story's first `pipeline-agent` from `~`, then `report.py startup` shows its context at call 1 at or under 32,000 tokens (42,700 today with no project `CLAUDE.md`).
- AC4 (proposed): Given review rounds on disk where round 3 or later has P2 findings and no P0 or P1, when `review-check.sh` runs, then its last line is `ASK JUSTIN: …` naming the P2 lines; with `justin.json` `"continue": true` for that round it is `REVIEW AGAIN`; with a P0 or P1 in that round, or the same findings in round 1 or 2, it is `REVIEW AGAIN` as today. Test: `p2_only_from_round_3_asks_justin` in `scripts/review-check.test.sh`.
- AC5 (proposed): Given verifier and auditor reports accepted at head H, a HEAD that is a pure rebase of H (the same patches in the same order, no merges) and a rebase receipt whose log starts `HEAD=<new sha>`, ends `EXIT=0` and shows every AC's test passing, when `ac-check.sh` runs with the receipt, then it prints `ALL ACCEPTED` or `READY FOR THE USER`; without the receipt, with a failing or missing AC test in it, or when HEAD is not a pure rebase of H, it prints `NOT ACCEPTED`. Test: `pure_rebase_receipt_accepts_earlier_reports` in `scripts/ac-check.test.sh`.
- AC6 (proposed): Given the rule files, when the test greps them, then `CLAUDE.md` ("Every brief names…") and `SKILL.md` each state the four brief rules (long output to a log with the tail printed; commands over 4 minutes in the background; hand-back at most 40 lines; skills by role) and `CLAUDE.md` "Skills to Load" lists `engineering-best-practices` for planner, builder and fixer only. Test: `brief_rules_present` in `scripts/pipeline-rules.test.sh`.
- AC7 (proposed): Given a fixture folder with one main transcript and two agent transcripts (one repeating a message id), when the token report runs on it, then it prints the expected tokens per role and counts the repeated message once. Test: `token_report_fixture` in `scripts/token-report/token-report.test.sh`.
- AC8 (proposed): Given the changed scripts and rule files, when the existing suites run, then `scripts/ac-check.test.sh` ends `all passed`, `scripts/review-check.test.sh` ends `failed 0` with its 15 existing tests still present, and `~/.claude/setup/codex/codex-parity.test.sh` and the suites in `~/.claude/hooks/tests/` pass as they do on the base. Test: `existing_suites_pass` in `scripts/pipeline-rules.test.sh`.
- AC9 (proposed) (live): After the next 5 complete pipeline stories, `report.py stories` shows their mean API $ at or under $127 (30% under the $182 of the 10 stories since 2026-11-09); if not, the report's role table names the role that did not drop.

Paths in the ACs are under `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/` unless they start with `~`.

**Under the other packages:** Light has no late-round brake, so the fourth criterion is dropped; the first one only checks that the files agree on today's routing; the ninth's target becomes $155 (15% under $182). Deep adds one criterion: `ac-check.sh` given a single verifier report and a `--single-proof` flag accepts on that report alone, and without the flag still requires two (test `single_proof_mode` in `scripts/ac-check.test.sh`); the ninth criterion's target becomes $91 (50% under $182). The third and ninth are tagged live because no agent can check them: they are read from the token report after the job, by you or by the main session at your word.

**Baseline today (2026-11-10, run by the planner):** `bash scripts/ac-check.test.sh` ends `all passed`; `bash scripts/review-check.test.sh` ends `# passed 15, failed 0`. Not run by the planner: `codex-parity.test.sh` and `hooks/tests/*`; the builder records their tallies on the base before changing anything.

## Tasks (for Medium; a fresh builder can follow them once Q1 to Q7 are answered)

Each task is one commit, test first. The script tasks (4 and 5) change guards: the builder loads `mutation-testing-discipline` for them and proves each new test fails on the base script.

0. **Discovery, 5 minutes, before any edit.** (a) Confirm this Claude Code version's agent-definition frontmatter keys (`name`, `description`, `tools`) from `claude --help` and the docs, and that the `Agent` tool's `model` and `effort` parameters still override a definition that names none. (b) Check whether `~/.claude/agents/` is in the setup repo's synced paths (`~/.claude/setup/sync.sh`, `~/.github/README.md`); if not, add it. (c) Record the base tallies of `codex-parity.test.sh` and `~/.claude/hooks/tests/*.test.sh`. Stop and report if (a) fails: criteria 2 and 3 then need a planner amendment.
1. **Token report tool.** Copy `scan.py`, `analyze.py`, `report.py`, `extras.py` from `~/.cache/pipeline-token-diet-planner/` to `feature-dispatch/scripts/token-report/`; make the transcript root and output folder arguments (defaults as now). Write `token-report.test.sh` with a hand-made fixture (criterion 7).
2. **Rules test file.** Create `scripts/pipeline-rules.test.sh` with `routing_text_agrees`, `pipeline_agent_type_is_slim`, `brief_rules_present`, `existing_suites_pass`; each fails on the base.
3. **Slim agent type.** Write `~/.claude/agents/pipeline-agent.md`: tools `Read, Edit, Write, Bash, Skill, ToolSearch, SubagentHandback` plus whatever task 0 shows a background agent needs to hand back; a short body ("You are a pipeline agent; your brief is your task"). In `CLAUDE.md` change "Every role is a fresh `general-purpose` agent" to name `pipeline-agent`, keeping `general-purpose` for a planner that reads a ClickUp card, and keeping "never the built-in `Plan` type". Check `subagent-lessons-gate.sh`'s skip list does not skip the new type.
4. **Late-round brake** in `scripts/review-check.sh`: a new brake beside brakes c and d (the `stalled` logic near the "latest round's verdict" jq block): latest round is 3 or later and its effective findings are P2 only gives `ASK JUSTIN: review-<n>: only P2 left from round 3: fix or follow-up?` with exit 3; `justin.json` `"continue": true` gives `REVIEW AGAIN` as for the other brakes. Update the header comment, `references/review-loop.md` ("The referee") and `CLAUDE.md` step 5 ("The brakes" sentence; "No round cap" becomes "No round cap; from round 3 a P2-only round asks Justin").
5. **Rebase receipt** in `scripts/ac-check.sh`: a new option `--rebase-receipt <log>`. When the reports' head is not HEAD, accept only if HEAD is a pure rebase of it (reuse `review-check.sh`'s patch comparison, the `diff-tree -p` loop) and the receipt log starts `HEAD=<HEAD sha>`, ends `EXIT=0` and holds each AC's test pass line by the same matching the script uses for logs. Update the header comment, `references/ac-verification.md` (steps and the setup-repo note about `sync.sh` moving HEAD) and `CLAUDE.md` step 7: after a pure rebase the finisher writes `<evidence>/rebase-receipt.log` by running every AC's test with the run recipe, and the orchestrator reruns `ac-check.sh --rebase-receipt` only; a rebase that resolved conflicts keeps today's path.
6. **Routing text** per the answers to Q3, Q4, Q6 and M3 in the five places criterion 1 names, plus `CLAUDE.md` "Agent models" (date the change 2026-11-10 and say what it replaces).
7. **Brief rules and skills by role** in `CLAUDE.md` ("Every brief names…" and "Skills to Load While Coding") and `SKILL.md` ("Skills every agent loads"): fold into the existing lines, don't append a new section.
8. **Docs and records:** run `~/.claude/setup/codex/build-codex.sh` to regenerate `~/.codex/AGENTS.md` and `codex-parity.test.sh`; if the Codex pipeline model must follow, `set-pipeline-model.sh`; then `~/.claude/setup/sync.sh`. Add one line to `~/.hermes/plans/claude-setup/follow-ups-review-loop.md` for the two outside notes (Figma `CLAUDE.md`, Adobe plugin).

**Touched files:** `~/.claude/CLAUDE.md`; `~/.claude/agents/pipeline-agent.md` (new); under `feature-dispatch/`: `SKILL.md`, `references/mini-pipeline.md`, `references/model-routing.md`, `references/review-loop.md`, `references/ac-verification.md`, `references/main-chat-housekeeping.md`, `scripts/review-check.sh`, `scripts/review-check.test.sh`, `scripts/ac-check.sh`, `scripts/ac-check.test.sh`, `scripts/pipeline-rules.test.sh` (new), `scripts/token-report/*` (new); generated `~/.codex/AGENTS.md`.

**Not ready until answered:** tasks 4 and 5 are specified by behaviour and test, not by final code. If the job runs as Full (Q7), the planner writes their exact code in an amendment after your picks; that is the reason I recommend Full.

## Risks

- The savings from M1 to M3 come from comparing different days and stories. Criterion 9 is the real check; the token report makes it one command.
- L3 to L5 are rules agents must follow; nothing enforces them. If criterion 9 misses, a PostToolUse hook that warns on a result over 8 KB is the next step (a separate story).
- A slim agent type may lack a tool some role needs (a screenshot through an MCP tool, for example). Task 0 and the first story show it; the fallback is `general-purpose` for that role, named in the brief.
- Fewer late fix rounds means some P2 findings ship as follow-ups. They are listed for you at the finish, as P3s are today.

## Planner's receipt

Forecast 60 to 90 minutes, done in about 20 (10:07 to 10:27 on 2026-11-10): the transcripts were more regular than expected (971 of 979 agents carried a brief path). Checks run: the four measurement scripts, and the two gate test suites for the baseline. Nothing but this plan and the scripts in `~/.cache/pipeline-token-diet-planner/` was written.
