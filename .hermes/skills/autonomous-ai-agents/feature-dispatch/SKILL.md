---
name: feature-dispatch
description: "Use when Justin sends a feature: agents plan, then build."
version: 0.1.0
author: Justin (Just-In-N-Out), Hermes Agent
license: MIT
platforms: [macos]
metadata:
  hermes:
    tags: [delegation, planning, background, worktree, whatsapp, features]
    related_skills: [figma-to-bricks, leorna, receiving-code-review, subagent-driven-development]
---

# Feature Dispatch

The main chat is a dispatcher. By default, a **planner agent** researches a feature and writes its plan; the main chat shows Justin the plan; on "go", a **builder agent** builds it. Explicit autonomous authorization for named batches replaces routine plan approval for that scope, not independent review or release gates. Each agent has its own context, so features never crowd each other, and the main chat only ever holds short summaries.

This skill holds only the dispatch loop. *What* to plan and build comes from the project skill (`figma-to-bricks`, `leorna`).

## When to Use

- Justin describes a feature or fix for the Figma plugin or Leorna and doesn't say "do it here"
- A planner or builder result comes back into the chat
- Justin replies "go", gives plan changes, answers a planner's questions, or asks "what's running?"
- Don't use for: questions, quick lookups, or one-line edits (just answer); a `/bg` Justin typed himself (that's the project skill's own path)

## Pick the pipeline first: Full or Mini (Justin, 2026-10-22)

Every new bug/feature/story, any repo: play it back in one line, recommend **Full** or **Mini** with a one-line reason, ask (desktop `clarify`; WhatsApp **full**/**mini**). Record `pipeline=` on the board and plan. Mini (Fable plan, Opus build, one full fresh Fable review, then the same loop of reviews of the fixes) follows `references/mini-pipeline.md` and overrides the Full role table/reviewer rules below; everything else here applies to both. **Full is the same for every repo** (Justin, 2026-10-22: "not Leorna only"); every role is a fresh agent on the role table below (2026-11-10): plan → build → fresh full review → fix → fresh review → … until `scripts/review-check.sh` prints MOVE ON (Justin, 2026-10-28; `references/review-loop.md`) → fresh verifier → blind AC auditor + `scripts/ac-check.sh --reviews` (`references/ac-verification.md`) → project finish step.

**The orchestrator's only say is the pipeline recommendation** (Justin, 2026-10-22). It recommends Full or Mini **from reading the story alone** (no code reading or investigation) and Justin picks. It does not decide or suggest scope, design, fixes, acceptance gates, tests, extra review steps or models beyond the two pipeline tables; those belong to the agents and to Justin. It only routes, records Justin's answers and relays results.

## Rules for the main chat

- **Model-independent presentation (Justin):** preserve the established Claude-style output across models and surfaces: emoji-led headings, bold important facts/actions, numbered lists, concise plain words. Status sections use 🟢 Running, ⏭ Next, ⏳ Waiting, 📈 Usage. A model switch alone must not change formatting or scheduling. Explicit requests to stop updates or recurring scripts override the default announcements and scheduler cadence; use the stop procedure below and `references/status-pings.md`, not a replacement agent-generated scheduler.

- **When progress updates are enabled, announce every phase change once**, after the dispatch or board transition is confirmed: `➡️ <name> [<project>]: <old> → <new> — <model effort>; <one plain-language finding or remaining gate>`. Cover transitions caused by returning agents too. Do not send a pre-dispatch announcement and then a second final summary of the same event; keep routine completion notifications to one short message. A child-process completion notification is not a phase change: do not reply to each probe, screenshot capture or mutation run. Let the owning agent consolidate its result; report only a newly actionable blocker or a confirmed phase change. In particular, a regression-finding script can exit 0 because it successfully recorded a failing candidate, so do not call its tested cases passing without assertion-level receipts. If one notification warrants an alert, avoid repeating the same pending-review/no-merge message for subsequent checks. When a bare notification still needs a reply, send one neutral line (`<name>: agent still working; verdict pending`) and do not narrate what the probe implies: trimmed output and per-variant exit codes (a candidate failing a regression probe while base passes) are the agent's to classify, and pre-announcing "a regression" from them often turns out wrong or duplicates its final report. Never infer a passing gate from the shell wrapper's exit 0 or a final `DONE`: later copy/echo commands can mask the test command's failure. Use the gate's recorded exit/report or the owning agent's qualified result, and describe planned screenshots/tests as pending until actual artifacts or execution receipts establish completion.
- **Every question names the feature it's for:** start with `❓ <name> [<project>] needs you:`. That covers plan questions, a builder that stopped for a decision, and an unknown-project policy question. With several features waiting, number nothing globally. A WhatsApp swipe-reply arrives prefixed `[Replying to your previous message: "…"]`: route it to the feature that quoted message names, and tell Justin he can swipe-reply to pick a feature. Ask which feature in one line only when neither the quote nor his words settle it.

- **Rewrite before passing on (Justin, 2026-10-20).** Justin often sends voice notes, so his messages carry transcription slips ("big" for "bug", "third" for "first") and loose wording. Whenever you hand something of his to an agent (spawn, steer, revise, an answer to a question), rewrite it so the agent can act on it:
  - Say the ask in one clear line: a bug (what he sees vs. what he expects) or a feature (what it should do).
  - Name the element in plain terms and describe each screenshot in words (the layout, which part is wrong). Attach the image too: `images` on spawn; on steer, give the file path and the description, since steer can't attach.
  - **Disambiguate the hero from the navigation header.** When he points to text beside a large photo, call it the hero's text column and photo/media column, not just "header media". State the target relationship first (text left, photo right at the named breakpoints). Keep added navigation-logo/phone/button fixes separately numbered, because calling both areas "header" makes an otherwise correct plan look like it targets the wrong element.
  - Fix slips from context, and flag any you weren't sure of.
  - Say what "done" looks like, and add likely areas to check only if you actually know them. For an interaction-only repair, define acceptance relative to the same element's measured idle layout at each width: no extra wrapping, displacement or overflow caused by the interaction. Do not translate "the text should stay there" into "everything must share one row" without checking the idle baseline; narrow layouts may already stack intentionally. Require the planner to verify that premise before a builder brief turns it into a literal gate. If an approved literal criterion later conflicts with the baseline, acknowledge the mistaken premise and ask one scoped preserve-layout versus redesign question rather than silently weakening the criterion or commissioning unrelated layout work.
  - **Side defects you spot in his screenshots:** reply with your one-line playback of his main ask first, then list the extras as an offer ("fold into this job?") rather than declaring them out of scope. Leading with extras made him think the main ask was misread, and he usually wants them fixed in the same job.
  - Put his original message verbatim below the rewrite, labelled "Justin's words". If the rewrite and his words disagree, the agent follows his words.
  - **A new report about a different part (new screenshots, another section) is its own job** (Justin, 2026-10-29: "don't do it in the same plan. Put it in another planner"): its own name, worktree, planner and pipeline question, started in parallel at once, never queued behind the running job. **When Justin explicitly adds defects visible in the screenshots of the job in hand, keep them in the same job.** Add separately numbered parts to the existing brief and plan, each with its own root cause, tasks and checks; steer the current planner rather than starting over. Keep the original reported defect first in explanations and previews. Do not generalize one scope addition into standing permission to fix every visible defect: unrequested observations remain proposed extras or `found_else` until accepted.
  - **A short reply that could mean two things** ("move on", "it depends on Figma"): act on the safer reading (the one that drops or defers work rather than doing something risky blind), record your reading in the plan's answers, and tell him in one line what you took it to mean and what the other reading would do. He corrects in a word if needed.
- **Manager-only dispatcher (Justin's explicit correction).** The main chat gives agents clear, self-contained issue briefs, assigns the right model/role, records Justin's decisions, routes planner → builder → independent review → fixes/verification → release, and reports concise outcomes. Agents own code investigation, reproduction, test execution, debugging, evidence collection and implementation. Do not run application tests, inspect source to solve a bug, make code/test edits, or invent technical acceptance gates in the main chat unless Justin explicitly asks to do that work here. Earlier main-chat test-alignment shortcuts do not apply in manager-only mode. Keep only lightweight board/live-agent/usage/Git identity checks needed to assign work and verify release claims; delegate substantive artifact validation.
- **Resource coordination must not become an invented blocker.** Put established project gates and actual shared-file/resource conflicts in the brief, then let the assigned agent own execution. Do not hold otherwise independent work behind an idle global browser/corpus reservation, impose arbitrary extra diagnostic budgets, or split every review into source-only stages merely for dispatcher convenience. When a real conflict is demonstrated, name its owner and release condition and delegate the resolution. Changing concurrency does not waive project gates.
- **Stay thin, especially on go.** Reuse approved-plan status, answers, ownership and handoff sections; leave code appendices and role-specific references to the agent. Batch changed admission facts, record approval, finish the brief and dispatch. Reconcile feature-owned notes once after live-model verification and routing reset; repeated context loads and bookkeeping must not delay approved work.
- **One feature = one name.** Kebab-case, short, unique (check the board). Every message about it starts with that name, so Justin can tell features apart. For a story, lead with its plain card title too (e.g. **Curate the reusable prompts collection (86bcm901b)**), not the card ID alone: with several story sessions open, he asked "which user story is this?" three times when updates showed only the ID (2026-10-28).
- **End the turn after completing the current dispatch group** with a short status naming each feature and its model/effort. Dispatch independent eligible work in the same turn; do not end after the first child and strand its siblings. Never wait or poll for completion; results re-enter the chat on their own.
- **Autonomous recommendation grants** (record scope and end condition, expiry, re-checks): load `references/dispatch-edge-cases.md` → "Autonomous recommendation grants".
- **Keep the conversation intact.** Use this chat's native `delegate_task` subagents and return their plans/results here. Do not open an independent Hermes CLI session (`hermes chat`), desktop chat or replacement conversation as a routing, provider, quota or tool-failure workaround without Justin's explicit authorization. If the requested route cannot be established, hold the affected role and explain the blocker here; ask before changing its model or launch method. Never reset this conversation automatically.
- **Never build in the main chat** unless Justin asks for that feature to be done here.
- **Bold means `**double**` asterisks** in every WhatsApp message: replies, the templates below, and script output. The adapter turns a single `*x*` into italics. Put what he must act on in bold: **NEEDS YOU**, phase words, reply tokens like **go**.

## Stop, pause and notification controls

Read a stop request, cancel or pause only what it names, hold continuation and acknowledge once: follow `references/stop-controls.md`.

## The board

`~/.hermes/plans/dispatch.json` tracks every feature, so "what's running?" survives a long chat. **Update it in one step with the helper, in the same turn as the dispatch. Never hand-edit the JSON:** `read_file` plus `patch` cost 2–3 calls per phase change and made replies lag (Justin, 2026-10-20).

**Board commands, fields and phases** (`dispatch_board.py` calls, what the helper stamps, the JSON fields, waiting on Justin, `queued`, branch names, where plans live): load `references/board.md` → "The board".

## One agent per delegate_task call

Dispatch each builder, reviewer, finisher or recheck in **its own `delegate_task` call**, several calls in one turn. A batch (`tasks=[a, b]`) reports only when every child is done, so a finished builder sits waiting on its sibling and its review starts late. Batch only planners whose plans you'll show together.

**Briefs live in files:** write each agent's brief to `~/.hermes/plans/<project>/briefs/<name>-<role>.md`, and dispatch with a short context: "your full brief is in <file>, read it first". A retry after a provider drop then costs a few lines, and the brief survives a chat reset.
- **Copy reviewer and builder evidence out of the scratch dir** into `~/.hermes/plans/<project>/evidence/<name>-<role>/` in the turn the result arrives, and point the next brief there: scratch is pruned after 24 h. For a manifest-backed archive, copy its enumerated evidence with relative subpaths rather than cloning the whole scratch workspace; retain the original path as provenance and map it to the durable target. Verify destination hashes/sizes and enumerated counts before claiming archival complete. An archived probe may still embed its old scratch paths: preserve that original, then explicitly adapt a separate runnable copy or pass a new working-root argument. Copying a script does not make its absolute dependencies durable.
- **Reviewer findings go into the finisher's brief from the result message you received**, written out by you (id, severity, claim, key evidence). Never scrape them from the live transcript: its result line is cut short, so the extracted file ends up a few hundred bytes. Also paste the key evidence verbatim into the dispatch context. In Claude Code a subagent can't save its report as a file (built-in refusal: "Subagents should return findings as text, not write report files"), so no brief asks a role for `report.md`: save the hand-back into its evidence folder yourself (901b review 1).
- **Write one authoritative current-role brief in readable prose.** Use headings and numbered acceptance checks; preserve exact paths, identifiers, commands, decisions and permission boundaries. On recovery, consolidate the current role/model, source pins, completed research and outstanding work there, linking verified receipts rather than requiring a chain of superseded briefs and full transcripts. Mark earlier routing instructions historical, because competing model labels and repeated context obscure the actual assignment. Never remove spaces between ordinary words to shorten the handoff.

**Interrupted agents, away mode, stuck batches, resuming after /new:** distinguish provider failure, conversation-persistence failure and a killed tool process from code failure. Inspect saved git state, outstanding processes and evidence before resuming; include nested role-owned folders such as `resume/`, since unchanged top-level report mtimes alone do not establish a stalled agent. An interruption may leave a temporary test mutation on disk or occur after a successful merge. Check resource constraints before restarting several heavy gates, preserve the assigned model/effort and update each board owner. Never weaken release gates or claim the storage/database cause from a generic error message. **Runaway runs:** while agents work, watch memory (any test process past ~6 GB, or an OOM killer such as earlyoom stopping one: `journalctl -u earlyoom`) and message the agent whose worktree it is at once; a run stopped by a signal (exit 137/143) is a crash, never a normal failure or a caught mutant, and briefs bound mutation runs (`mutation-testing-discipline`; Justin, 2026-11-02, after a mutant reached 17 GB). Follow `references/away-and-recovery.md` for the ordered recovery checks, away-mode routine and unfinished batch handling.

## Which model runs which agent (Justin, 2026-10-21)

**Only these models.** Claude: **Opus 5.5** (`claude-opus-5-5[1m]`) and **Fable 5.2** (`claude-fable-5-2`; added 2026-11-09, verify the live child's model on its first dispatch), both his Claude subscription. ChatGPT: **Sol 6.1** (he confirmed "6.1 Sol" by voice; via `openai-codex`, his ChatGPT subscription, not API billing). Exact id: **`gpt-6.1-sol`** (connected 2026-10-21; a `gpt-6.1-sol-900k` long-context variant exists, used only if a job needs a huge context). His ChatGPT plan is **Pro Lite ($100/month, upgraded 2026-10-21 from Plus)**. On Plus, three xhigh Sol agents used up the 5-hour window in about 45 minutes; Pro Lite has much more room, so Sol can carry more of the small work.
- **Check usage for both:** `hermes usage` (Claude) and `hermes usage --provider openai-codex` (ChatGPT: 5h and weekly windows, plus banked resets)
- **Banked ChatGPT resets:** redeem one only when a live window is exhausted and approved Sol work is running or waiting. Never force redemption or spend early; tell Justin the remaining count. Use `references/usage-and-cost.md` for Python redemption and conditional credential-flag recovery, then verify usage and reconcile interrupted work before resuming. With low banked resets, run at most two Sol agents. Claude has no banked resets: use the Opus-limit question below. Report only windows the active plan exposes.

**Before every dispatch, check both subscriptions:** `hermes usage` (Claude) and `hermes usage --provider openai-codex` (ChatGPT) show how much of each window is used and when it resets.

**Role routing (Justin, 2026-11-10: "ok yes change this pipeline everywhere", the pipeline-token-diet plan).** This applies to every feature, fix and bug, in every repo: Leorna, FigmaToBricksV2 and any other, Full and Mini alike. Each role is a new, fresh agent. It supersedes the 2026-11-09 table (a Fable reviewer every round, the verifier on Fable, xhigh fixers), the all-Opus high table (2026-10-23, effort high since 2026-11-07), the 2026-10-22 Sol-builder routing, and every older "Opus plans / Opus reviews / Sol builds / Sol fixes" line in this skill and its references.

| Role | Model | Effort |
|---|---|---|
| Planner (architecture and design) | **Fable 5.2** | **high** |
| Builder | **Opus 5.5** | **xhigh** |
| Reviewer, round 1 (the whole story; separate, fresh), every repo | **Fable 5.2** | **high** |
| Reviewer, later rounds (Full's whole-story round 2, the delta rounds, a full round `review-check.sh` asks for) | **Opus 5.5**, a fresh agent each round, until a review is clean (`references/review-loop.md`) | **high** |
| Fixer (fix pass) | **Opus 5.5**, a fresh agent each round | **high** |
| Verifier (Agent Defect Loop) | **Opus 5.5**, fresh, never saw the build | **high** |
| AC auditor (blind) | **Opus 5.5**, fresh, never saw the build or the verifier's report | **xhigh** |
| Finisher (merge / hand-over) | **Opus 5.5** | high |

In one line: planner Fable 5.2 high; builder Opus 5.5 xhigh; reviewer round 1 Fable 5.2 high, later rounds Opus 5.5 high; fixer Opus 5.5 high; verifier Opus 5.5 high; AC auditor Opus 5.5 xhigh; finisher Opus 5.5 high; pipeline main session Opus 5.5 high. *Why (2026-11-10): since 2026-11-09 Fable ran 39% of the agents and took 56% of the tokens; a verifier run on Fable cost $20.02 against $9.26 on Opus high, a Fable review $10.21 against $3.49 for an Opus high later round, a fixer $14.15 at xhigh against $9.82 at high. The 2026-11-09 rule that the verifier and the auditor run on different models ended; the two separate proofs stay.*

- **Sol 6.1 is a substitute only.** When Claude is at its limit, ask Justin whether Sol should take the held Claude (Opus or Fable) roles, and never switch silently (the Opus-limit question below). Sol usage checks, banked resets and reasoning-effort mechanics stay valid for that case.
- **The planner designs, and the builder builds from the plan.** The Fable planner does the architecture and design: files and areas, interfaces and data shapes, one test per acceptance criterion, decisions, risks. Its plan must be complete enough that the builder implements it without redesigning. A builder that finds the plan wrong or missing a decision stops and reports, and the fix goes back to a planner. The builder never redesigns on its own.
- **Superseded tables, Opus or Sol at its limit, after a reset, Justin's explicit model pick, "wait":** load `references/model-routing.md` → "Limits, resets and explicit picks".
- **Usage is a soft factor** (Justin confirmed 2026-10-21: "don't worry too much about the usage limit, just keep it in mind"). The role decides the model; usage only decides *when* it starts. Mention it when a subscription is at 80% or more.
- **Every repo uses the same role routing and review order** (Justin, 2026-10-22). This replaces the old "Leorna: always Opus, never ChatGPT" rule and the Leorna-only two-review order.
- **Show it:** put each agent's model and effort on the board (`model="fable-5.2 high"`, `model="opus-5.5 xhigh"`, `model="gpt sol-6.1 high"`). The status ping prints it on every line, so he always sees which subscription is being used.
- **Full review order (every repo):** load `review-fix-cadence`. **Fresh full review → fixer → fresh full review of the corrected candidate → fixer → fresh review of the fix commits → … until `scripts/review-check.sh` prints MOVE ON**, no round cap (from round 3 a round with only P2 left asks Justin: fix or follow-up?), each role on the role table (round 1 reviewed on Fable 5.2 high, later rounds on Opus 5.5 high, fixes on Opus 5.5 high). This supersedes parallel review and waiting for both reports before fixes. Clean reviews skip no-op fixes. Carry exact reviewed/corrected revisions. Preserve project acceptance/publication holds; check actual quota and ask before replacing Opus. Do not stop another session's running reviewer merely to impose this order.
- **Reviewers:** always **separate, fresh agents** (every round of the review loop) that have never seen the code or the build, for every job size and repo. The builder or finisher never reviews its own work (Justin, 2026-10-21), and there is no "one-file fix: the finisher self-reviews" shortcut. Fixers and the verifier run on Opus 5.5 high, the AC auditor on Opus 5.5 xhigh (Justin, 2026-11-10).
- **Effort:** agents run at the role table's effort (xhigh for builder and AC auditor; high for planner, every reviewer, fixer, verifier and finisher); main-chat replies normally use medium. An explicit user pick for one feature wins. Set agent effort with `delegation.reasoning_effort` and reset it after dispatch. When asked about current chat effort, verify the session's effective reasoning setting, not a stale config value; an unrecognized-key warning is not proof the runtime uses that key. Use the supported `/reasoning` command for session changes.
- **How:** `delegate_task` has no model field, but the `delegation.provider` / `delegation.model` settings are read on every call, and running agents keep the model they started on. So:
  1. Sol: `hermes config set delegation.provider openai-codex` and `delegation.model gpt-6.1-sol`. **Opus: set it explicitly too** (`delegation.provider claude-subscription-directsdk-experimental`, `delegation.model 'claude-opus-5-5[1m]'`, or `'claude-fable-5-2'` for a Fable role): an empty setting inherits the *chat's current* model, which is Sol after a `/model` switch or a fallback, so an "inherit Claude" dispatch silently runs on Sol.
  2. dispatch the agent and wait for its dispatch result before changing these settings
  3. reset all three to empty with `hermes config set delegation.provider ''` (same for model and reasoning_effort)
  - Do it in one turn, and never leave the setting switched between turns.
  - **Checking a routing change took effect** (prepare, serialize, verify the live child, recover a mismatch, wait for the config command): load `references/model-routing.md` → "Checking a routing change took effect".
- Only after Justin has run `hermes auth add openai-codex` himself (browser login; never handle his credentials). First run: test-cleanup. Check its transcript header for the model.
- Note each agent's model on the board (`note="gpt"`), so status shows which subscription it's using.

## Things agents found

Every `found_else` item goes into `~/.hermes/plans/<project>/found-else.md` (dated heading, one line per item with severity and evidence); relay them with the plan or report. Batch-clearing, ownership matrices and closing items: `references/found-items.md`.

## Ask to reset the main chat when nothing is running (Justin, 2026-10-21)

**When and how to offer a reset** (the 🧹 message, when to ask, what to save first): load `references/main-chat-housekeeping.md` → "Ask to reset the main chat".

## Skills every agent loads (Justin, 2026-10-21: "most agents run these skills whenever I'm coding"; Leorna library versions since 2026-10-22)

Every coding agent, in any project, loads in this order and says so in its first steps:
1. the project skill;
2. `engineering-best-practices`, the Leorna library's primary workflow. The project skill and Justin's rules win where they differ (plan approval, merge/push policy, models, short replies);
3. its role skills below;
4. a specialist skill for each area it touches. Examples: `security-best-practices` + `multi-tenant-auth-management` for auth or tenant code, `api-contract-drift-guard` for OpenAPI changes, `backend-data-migrations` for schema changes, `frontend-ui-repair` for UI bugs, `gh-fix-ci` for failing checks.

Put the line for its role, with the specialists named, into every dispatch context: spawn, revise, or continuation.

- **PLANNER:** `implementation-planning` (a plan a context-free builder can follow). For a bug, also `systematic-debugging`: root cause with evidence before any fix is planned. The plan gets a `## Skills` section naming the specialist skills the build needs, marking those with the Agent Defect Loop (next section).
- **BUILDER:** `test-driven-development` (a failing test before each code change). Also `systematic-debugging` whenever a test fails unexpectedly or a corpus number gets worse (find the cause, don't patch around it), and `mutation-testing-discipline` for permission, identity or data-integrity guards.
- **REVIEWER:** `requesting-code-review` (security scan and quality gates) and `code-review-practice`, plus `mutation-testing-discipline` for its mutation checks, alongside the project skill's review rules. Report only: never apply an auto-fix. Tell it to skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: it *is* the fresh reviewer, and a child can't spawn agents.
- **FINISHER:** `receiving-code-review` and `git-commit-rules`, plus `test-driven-development` for each fix.
- **VERIFIER:** the loop skills named in the plan (see Agent Defect Loop).
- **CHECKER:** the project skill only.
- Work done in the main chat ("do it here") follows the same list for the role being played.
- **Verify skill loading, not just skill instructions.** Name the project, primary workflow, role and applicable specialist skills explicitly in every brief. If Justin asks you to ensure they load, take one early transcript snapshot with `search_files` and check actual `tool | -> skill_view(...)` calls and successful results; a kickoff prompt or a child's prose claim is not proof. Say **required in the brief** until the calls are observed, and **confirmed loaded** only for observed successes. Audit the full list again when the agent returns, report missing skills and route any unmet required work before advancing. Do not poll while waiting for a skill call.
- The same role-to-skill rules live in `~/.claude/CLAUDE.md` ("Skills to Load While Coding") for Claude Code sessions, which get the same skill files through links in `~/.claude/skills` (the list is `~/.hermes/skills-library-claude.txt`). When you change one list, change both.

## Agent Defect Loop (Justin, 2026-10-22: "always run it, even inside dispatched features")

30 installed library skills end with **"Mandatory Validation and Agent Defect Loop"**: an implementation agent, an independent problem-finder and an independent verifier, repeated until no critical issue is left. Child agents can't spawn agents, so the main chat runs the loop as pipeline roles.

- **When it applies:** the feature uses one of those skills. Check the plan's `## Skills` names with `grep -l '^## Mandatory Validation and Agent Defect Loop' ~/.hermes/skills/*/<name>/SKILL.md` (anchor on the heading: a plain `'Agent Defect Loop'` grep also matches `leorna`, which only mentions the loop). Builders and reviewers also return `defect_loop_skills[]` for any loop skill they loaded on their own. Put `loop=<skills>` in the board note.
- **Who plays which part:** implementation agent = BUILDER; problem-finder = the fresh REVIEWER every pipeline already has; fixes = FINISHER; verifier = a new fresh **VERIFIER** after the finisher.
- **The finisher holds the release:** when the loop applies, tell the finisher to fix and commit, then stop with `status: ready-for-next-review` (the fix gets a fresh review; the verifier runs after MOVE ON). Figma: no merge and no BUILD bump yet. Leorna: no hand-over yet.
  - **Records-only finishers and closing records:** load `references/agent-defect-loop.md` → "The finisher holds the release".
- **VERIFIER** (read only, fresh, never saw the build):
  - goal: `VERIFIER (read only) for <project> feature "<name>"`;
  - context: the worktree, the plan, the reviewer's findings and the finisher's answer to each. "Load the project skill, `engineering-best-practices` and each loop skill. Re-run the loop skills' Required Validation Gates and the project's gates yourself. Confirm each finding is closed, and look for regressions the fixes caused. Then follow `references/ac-verification.md` → VERIFIER: run every AC's check on head and base and write `verifier/ac.json`. Change no source; write only into `<evidence>/verifier/`.";
  - output_schema: `{verdict: clean|findings, findings[{id, severity, claim, evidence}], ac_status[{ac, accepted, test, screenshot, evidence}], skill_lessons[]}`. `clean` requires every AC accepted, `(live)` ACs aside (those it marks `not_run`, `references/ac-verification.md`);
  - model: Opus 5.5 high, a fresh agent. Board → `verifying`.
- **Baseline-only holds and accepted limits:** load `references/agent-defect-loop.md` → "Holds and accepted limits".
- **Clean:** dispatch the blind AC AUDITOR, then run `scripts/ac-check.sh … --reviews <evidence>` (`references/ac-verification.md`). `NOT ACCEPTED` counts as an AC not accepted (next bullet). On `ALL ACCEPTED` or `READY FOR THE USER` (live ACs owed to Justin), resume the FINISHER (same brief plus "verified clean under the recorded acceptance contract: run only the project's finish step", which is the merge for Figma and the hand-over for Leorna). Carry any explicitly accepted baseline limits into the finisher brief and final report; do not describe them as repaired. Board → `finishing`.
- **Verifier findings left, or any acceptance criterion not accepted:** a fresh FINISHER fix round, a fresh review of that fix until `review-check.sh` prints MOVE ON, then a new fresh VERIFIER. **Keep looping until every AC is accepted on one head (Justin, 2026-10-23; default for every story).** There is no round cap. Each reviewer and verifier returns `ac_status[{ac, accepted, test, screenshot, evidence}]`. Ask `❓ <name> [<project>] needs you:` only in two cases:
  - a fix needs Justin's decision (scope, a permission or credential, an AC wording);
  - a round made no progress (the same finding reopened with no new fact, or `review-check.sh` says ASK JUSTIN).

  "Accepted" means local acceptance: hosted CI and live checks that haven't run stay NOT VERIFIED. *(Superseded: "After 3 rounds, ask".)*
  - **A finding reopened with new witnesses** (the fix patched examples, not the class): load `references/agent-defect-loop.md` → "Reopened findings".
- **Work outside dispatch** ("do it here", `/bg`): follow the loop as the skill says. The main chat can spawn the problem-finder and verifier itself; a `/bg` session can't, so it says so in its report.
- **Usage:** each review round adds a reviewer, plus a finisher when it lists P0–P2; each verify round adds a verifier and an auditor. Count them in status and usage answers.

## Phase 1: Dispatch the planner

Before dispatch, run `~/.claude/setup/sync.sh pull` so the plan uses the newest skills from Justin's Mac and Windows desktop (on `CONFLICT`, merge both versions and rerun). Reuse the just-verified card and prerequisite snapshot unless new information requires a refresh. Resolve the named project, existing ownership, quota, model and permission boundary; delegate source investigation to the planner rather than loading every specialist or researching the solution in the main chat. Put the required skill names explicitly in the brief and let the planner validate additional specialists.

If Justin grants a bounded exception to a standing project rule, record the changed rule, permitted scope and unchanged approval gates in the brief, plan instructions and relevant project notes/handoff. Do not ask for an exception he just granted, and do not let a generic skill prohibition erase it. A policy exception is not plan approval: a story selection still dispatches only the planner, while implementation and publication wait for their normal authorization.

`delegate_task` with one task (pass any screenshots Justin sent in `images`):

- **goal:** `PLANNER for <project> feature "<name>". Write a plan Justin will approve; don't build anything.`
- **context** (self-contained; the child knows nothing):
  - Justin's request rewritten as in "Rewrite before passing on", his words verbatim below it, plus anything he clarified.
  - "First call `skill_view('<project skill>')` and follow it in the PLANNER role: load the project context (its Step 1), play the request back, and write the plan. Make no worktree, branch, code or commit."
  - "Save the plan to `~/.hermes/plans/<project>/<name>.md`. Make it self-contained: request played back, approach, tasks, tests, the choices you made, open questions, risks, the parts of the code it touches. Number the ACs near the top as AC1, AC2… (never AC1a: `ac-check.sh` refuses it, so a split part takes the next number, marked proposed), each with its test by name, whole on one line (`ac-check.sh` matches names line by line, so a wrapped name rejects that AC): the card's or request's, or, when it has none, your own marked **proposed** for Justin to approve with the plan. Tag `(live)` an AC only Justin can check (live publish → Sync, a native menu), right after its id: `- AC3 (live): …` or `- AC3 (proposed) (live): …`. Put the open questions section at the top, right after the title, with each option lettered and the recommended one marked."
  - For a bug: "Find the root cause with file/line evidence before planning the fix, and put it in the plan." Describe the screenshot in words in the context too (what it shows, which element is wrong), because a child may not read the image the way you did.
  - "End the plan with a **Docs & records** task that names every file the build and finish will update (the project skill's record-keeping steps: plan copy, ledger, HANDOFF, build number, `CLAUDE.md`)." Justin wants every plan to show this, so he can see the docs stay current before he says go.
  - If another feature for the same project is open on the board, name it: "Say whether this fix touches the same files as `<other>`, so they can be built in parallel or one after the other."
  - "Answer in plain words for a WhatsApp reader. You can't ask Justin anything: put questions in `questions`. Give every question 2–4 short options (A, B, C…, each under about 60 characters) and mark the one you recommend. Write the plan as if the recommended options were chosen, so 'go' needs no re-plan."
- "If you find any other bug or problem along the way, don't fix it or fold it in: list it in `found_else` (one line each, with evidence and severity) and in an 'Other things found' section at the end of the plan." (Justin, 2026-10-20; give builders, reviewers and finishers the same line.) Relay every `found_else` item to him with the plan or report.
- "If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill it belongs in (or `memory` for a fact); `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs." (Justin, 2026-10-23: "make it so that the agent note stuff that can be put in skills"; give every role the same line.) Children never edit skills themselves: parallel agents would overwrite each other's edits to shared skill files, and reviewers/verifiers are read-only. An empty list is the normal answer; tell children to list only what a future task needs that the skill doesn't already say. **On intake, the main chat checks each lesson** (reproduce the claim when cheap) and saves it only if it is new, reusable and proven, as a small edit to the named skill in its own style or a memory note. It drops duplicates and story-only facts (those go to the project notes). **Keep skills lean (Justin, 2026-10-24: not adding for the sake of adding):** fold a lesson into an existing line, replace the line it makes outdated or delete one it proves wrong before appending; near the 100,000-character limit, move a section into `references/`. Tell Justin in one line what was saved and what was skipped, with why; append each non-`none` `enforce` to `~/.hermes/plans/claude-setup/enforce-backlog.md` (`- <date> | <story> | <skill> | <proposal> | offered`) and offer it in that line as a story: the main chat never builds the check itself. In Claude Code, `~/.claude/hooks/skill-review-nudge.sh` also reminds each subagent every 15 of its tool calls, and a subagent that ends its turn to wait for a background command trips the SubagentStop lessons gate as a finish: it waits in the foreground instead (start the job with `cmd >/dev/null 2>&1 & echo pid=$!`, then repeated `timeout 165 tail --pid=<pid> -f /dev/null` calls, 124 = still running, cortexos-memory-hook finisher; or a bounded `node -e` poll on the log, or `python3 -I -c` under a narrowed PATH without node, as briefs prescribe on the WSL desktop, 901z auditor; foreground `sleep` is refused). Claude Code moves any foreground Bash command to the background after about 180 s whatever its `timeout` (a 540 s `gh pr checks --watch` was moved three times, 901b PR finisher), so brief a long wait, such as CI, as repeated polls of under 3 minutes each, each with the Bash `timeout` set above its bound: at the default 120 s a 170 s poll was moved too, while `timeout` 175000 kept it in the foreground (901z fixer 1).
- **output_schema:** `{name, plan_path, playback, root_cause, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}`. Require only `plan_path` and `summary`.
- A planner already running missed something (e.g. Justin adds a requirement, widens the scope or sends a new screenshot mid-plan): patch the relevant clause in its existing brief first so retries and the builder handoff preserve the change, then `delegate_task(action="steer", subagent_id=…, message=…)` pointing at that clause. Update the board's task only when the task changed, and confirm in one line. A reminder about screenshots, skills or hand-over evidence reinforces the same assignment: do not stop/restart the planner, add duplicate scope or treat the reminder as build approval. Preserve the plan-only boundary until Justin approves the resulting plan.
  - A steer lands at the child's next tool result, not at once. To confirm it landed, grep the child's live transcript for the action it asked for (e.g. `vision_analyze` on the image path you passed). Report "it has seen it" only after that shows up.

Board → `planning`. After verifying the live child's actual model, reply **"🛠 <name>: planner started — <model effort>."** State **plan only; no build until go** so dispatch cannot be mistaken for either an unstarted intention or implementation approval. If skill loading was explicitly requested, add only the verified skill confirmation or clearly label it pending. For an auto-merge project, include the established git path in one line (after **go**: its own branch off local `main` → fresh review → fast-forward merge back → push `main`). End the turn; do not bury the start confirmation beneath bookkeeping.

## Phase 2: Show the plan (when the planner returns)

Intake the saved plan without reading it whole: use `search_files` on its headings and `Docs & records`, then read the status, questions and necessary handoff sections. Verify the artifact exists, covers the requested acceptance criteria with concrete implementation/test tasks, matches the returned questions, includes the records task, and has successful required-skill transcript receipts. A draft banner, skeleton file, returned path or zero process exit is not a completed plan. Preserve incomplete work as partial and keep the build held; route missing plan work to the authorized planner rather than presenting it for approval. No numbered ACs (stated or proposed) → back to the planner; the main chat never writes them.

Refresh same-project ownership on the shared board before accepting the plan's overlap claims. If another session started a sibling while research ran, replace stale no-other-work statements in this plan with the known owner and a pre-build overlap check; do not cancel or restart that sibling. A planner's old empty-board snapshot is not a current write reservation. If Justin asked something else while the plan was out, answer him first, then show the plan in the same reply. Then send Justin:

**Tap-free answers and the approval gate.** Justin shouldn't have to type anything beyond a few characters. Every question gets lettered options, with the recommended one marked ⭐. A bare **go** accepts the plan *and* every ⭐ answer. If he explicitly requires a separate **go** before building, that stricter gate overrides equivalent replies, choice-only replies and form submission below: record choices without launching, and offer **go** or **choices + go**. Do not turn a story selection, screenshot reminder or clarification into build approval.

**Questions first (Justin, 2026-10-20):** the questions and the reply line sit at the top, right under the header, so he sees them before the explanation. Plans with no questions start with the reply line.

```
📋 <name>: plan ready (N questions)

1. <question>
   A) … ⭐
   B) …
2. <question>
   A) …
   B) … ⭐

Reply **go** = plan + all ⭐ answers
or pick, e.g. **1B 2A** (answering every question = go)
or **change: …** / **stop**

What's wrong: <one line>
The fix: <one line>
Risk: <one line>
ACs (proposed): AC1 <one line> · AC2 <one line> · AC3 (live) <one line>
Live ACs (you check them): AC3 <one line>
MEDIA:<plan path>
```

**Keep it short (Justin, 2026-10-20):** the questions, then at most 3 one-line facts. The `ACs (proposed)` line appears only when the planner wrote the ACs (none were given), and the `Live ACs` line whenever any AC is tagged `(live)`: **go** approves both, so Justin must see them. On **go**, copy the plan read-only to `<evidence>/plan-approved.md` (`mkdir -p <evidence> && install -m 444 <plan> <evidence>/plan-approved.md`); `ac-check.sh` reads that copy, so a later plan edit can't add ACs or `(live)` tags. The playback, evidence, tasks and choices stay in the plan file, which is always attached. A plan with no questions is the header, the 3 lines and "Reply **go**". Board → `awaiting-go`.
- **Pictures in a plan message follow the primary defect.** When a plan has added parts, the first fact line and any attached screenshot must be about the defect Justin originally reported (e.g. the hero's photo column), not an added part's proof. If only an added part has a picture, label it as that part and say the primary fix has no picture yet: a lone navigation-header shot under a hero plan reads as "you're fixing the wrong thing" and costs a clarification round.

**Several plans at once:** send all of them in one message.
- Prefix each feature's questions with a capital letter (P1, L1, F1, …) so one reply can answer every plan.
- Give the build order: what builds in parallel, and what is queued behind what (from the planners' `overlaps`).
- Accept **go all** (every ⭐) or a mix like **L1B go all**.
- Put every plan's `found_else` in one closing line, and attach every plan file.

- **Reading the reply:** honor the approval gate stated with the plan first. With a separate-go requirement, accept **go** or **choices + go** as approval and treat other choices as answers only. Otherwise accept `go`, `ok`, `yes`, 👍, approval-form submission or the established approval-choice tokens (`1b`, `1-B`, `1 B`, `B` only for one question); unspecified choices take ⭐.
  - **A bare "go" with no quoted message** goes to the one feature in `awaiting-go`; with several waiting, ask which in one line. Say in the reply which feature you took it for.
  - **Without a stricter explicit-go gate, answering the approval questions counts as go.** Record the picks under `## Justin's answers` and start the builder without another confirmation. Unspecified choices take ⭐. Under an explicit-go gate, record choice-only answers and wait for **go**; do not start if he adds **wait**.
  - **A pick that differs from ⭐:** re-plan (a fast revise, below) only if it changes which files or pipeline parts get touched. Otherwise record it and start the builder, telling it which answers differ from the plan text so it applies them.
    - **A pick that adds scope the plan only sketched** ("fix that leftover too") where the files are still likely the plan's own: skip the revise. In the plan's `## Justin's answers`, spell out what "done" means for that pick, and in the builder brief make it **its own last task and commit, after the core fix**. Name the boundary that turns it into a ruling or a stop (e.g. it would need breakpoint rules or change the approved look), and say the core commits land either way. A revise costs 10+ minutes; this costs nothing, and the core fix can't be blocked by the extra.
  - Anything else is free-text feedback.
- **Don't block the dispatcher** with `clarify` on WhatsApp. This WhatsApp connection (bridge, `WHATSAPP_MODE=bot`) has no buttons, so `clarify` would only send the same numbered text and hold the main chat while other agents' results wait. In the **desktop app**, `clarify` shows real clickable choices: use it there (one call, up to 5 questions, recommended option first), but only when no other agent result is due.
  - **Desktop plan flow:** first write the header, the 3 one-line facts and the `MEDIA:` plan as text, then one `clarify` call. Each question starts with `<name> Q<n>:`, and each option is plain words with a concrete effect (what changes on screen), not the planner's jargon. Use the current role-routing table and recorded per-feature override when naming the model. Add a model-choice question only for a genuine unresolved routing decision; name the exact role or remaining-pipeline scope, put the recommended authorized option first, and keep task size a scope estimate rather than a model selector. When the form is the authorized approval surface, record its picks under `## Justin's answers` and start the builder in the same turn. If Justin required a separate **go**, the form only saves choices; keep the build held until that explicit approval.
    - `clarify` holds at most 5 questions. With more, send the text format above (questions first, reply line, 3 facts) rather than splitting one plan across two forms.
- **Answers to questions, or small changes:** append them to the plan file under `## Justin's answers (<date>)` and confirm in one line. Distinguish a clarification-only form from a plan-approval form: preserving already agreed scope or explaining the same screenshot must not trigger a new approval round, while explicit **go** or answers to the actual approval questions authorize dispatch. Do not ask him to reconfirm unchanged extras merely because he restates the primary defect; first acknowledge the exact intended on-screen result.
- **Bigger changes:** dispatch the planner again in revise mode (same context plus "revise the existing plan file with this feedback: …", with the feedback rewritten and his words below it). Board → `planning`.
- **Keep revises fast:** waits of 10+ minutes frustrate Justin. A revise is a fresh agent, so by default it re-reads the whole 90 KB `CLAUDE.md` and re-researches. Tell it: "Revise mode: read the existing plan first, then only the code and docs sections the change touches. Skip the full Step 1 load. Write the revised plan within about 15 steps. Anything still unchecked becomes a builder task ('check X first')." If one passes 8 minutes, steer it to wrap up and write what it has.

## Phase 3: Dispatch the builder (on "go")

On Justin's **go**, move the board out of `awaiting-go` immediately; use `queued` with the exact outstanding preflight condition only if dispatch cannot begin yet. Replace the plan's obsolete not-approved status with `Approved by Justin <date>` and record every concrete answer under `## Justin's answers`; mark the old question block answered rather than leaving competing pending instructions. Preserve the exact permission boundaries of the approved options in the builder brief, including any narrowly authorized real-home test file or user-operated live-server prerequisite. Do not infer cloud provisioning, publication or unrelated home-directory writes from a generic **go**; carry only their explicitly approved option scopes or standing project grants. Finish the brief before entering the shared routing interval, then call `delegate_task`:

- **goal:** `BUILDER for <project> feature "<name>": build the approved plan at <plan path>.`
- **context:**
  - "First call `skill_view('<project skill>')` and follow it in the BUILDER role, from its worktree step to its finish step. The plan is approved; don't re-plan."
  - "You can't ask Justin anything. On a real trade-off, make the ruling and write it down as 'My ruling, not yet confirmed', in `rulings[]` and in your own section of the evidence `INVENTORY.md` (or HANDOFF), because rulings that live only in a report are lost before the finisher (945u). If it can't be decided safely, stop with `status: stopped` and list the options."
  - "If you run low on steps, commit what passes and stop with `status: stopped` and `stop_reason: out of steps`, naming the worktree and the last commit."
  - The ask rewritten (his picks spelled out, what "done" means) with his go message below it as "Justin's words".
  - If another feature of the same project is planned or building, name it and say: "stay within this plan's files; whoever merges second rebases and keeps both HANDOFF sections."
- **output_schema:** `{name, status: ready-for-review|ready-for-next-review|merged|stopped, build, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], defect_loop_skills[], skill_lessons[]}`. Require only `status` and `summary`.
- "Take before/after pictures as the project skill says (before your first code change, and after the last task), and return their paths in `shots[]`." The before shot must come from the untouched copy, so this goes in the first context, not a later steer.

Board → `building`. Reply "🔨 <name>: building…" and end the turn.
- **Every dispatch message names each agent's model** (Justin asks when it's missing), and for a project with auto-merge, the git path in one line: its branch off local `main`, then review → merge back → push (he asks to confirm this when it's missing). With several features started at once, send one line per feature: `🔨 <name>: building on <model effort> (<size>), reviewer <model effort>`, plus the queued ones with the model they will run on and what they wait for. Then give the order: what runs side by side and what waits, and why (shared files). Many accepted jobs merging into one `main`: line them up as a merge train (each rebased onto the previous car's head and verified with `--base` = that car, so a merge never forces a re-verification), and make the post-merge BUILD commit once per batch of consecutive cars, or rebase the not-yet-verified cars onto it first: a BUILD commit on `main` between two verified cars breaks the fast-forward (djtrees-designer batch, 2026-11-02). Each car's rebased-head gate logs and replays serve as the next car's target gates (check the log's `HEAD=` and the replay hashes), halving the load per car; one rebaser can build a chain of cars in one run. When main moves under a built train, re-rebase car N with `git rebase --onto <new car N-1> <old car N-1> <old car N>` (when main moved only by docs/BUILD, prove each car cheaply: the sorted +/- lines of `git diff <old head> <new head>` equal those of `git diff <old target> <new target>` and the real-file replays hash-equal the old ones): a plain `git rebase <new car N-1>` replays car N-1's own commits again (their HANDOFF patch-ids changed) and conflicts (cars 3–6 rebaser, 2026-11-02). An earlier car's "differs from base only in X" receipt fails read flat at every later car (later jobs' keys look unexplained): re-check it by running it against its own base on the previous car and this one and diffing the PASS/FAIL lines; the only new keys must be this car's own diff (car 9 verifier). When a merge commit edits an earlier job's AC tests, run that job's original test file on the merged source: failures only in cases both approved plans gave the sibling job mean narrowed by ruling, not weakened; mutants must still kill the edited assertions (car 8 verifier).
- **Reusing an old copy** (`git merge --ff-only main` in the brief, never `git reset --hard main`): load `references/dispatch-edge-cases.md` → "Reusing an old copy".
- **When an agent's command reaches Justin as an approval prompt** and he asks whether it's safe: check it read-only first (`git log main..HEAD | wc -l`, `git status --porcelain --untracked-files=all`), then answer in plain words: what it would destroy (with the counts), what it keeps, and why the agent needs it. End with the reply token (**/approve**).

### Phase 3b: Fresh review, then finish (automatic; don't wait for Justin)

Children can't spawn children, so the main chat runs the fresh review that both projects require.

1. **Builder returns `ready-for-review`:** built, required local gates green, committed but not merged; explicitly retain external acceptance holds. Full and Mini load `review-fix-cadence`: dispatch round 1 of the review loop, a fresh **Fable 5.2 high full review** (`references/review-loop.md`). One native call per role; verify actual models.
   - goal: `REVIEWER (review only) for <project> feature "<name>"`.
   - context:
     - the worktree path, the plan path, and "review `git diff main...HEAD` against the plan and the project skill's rules (load it with `skill_view`)";
     - "run the gates yourself, try mutations, don't trust summaries";
     - "change nothing: no commit, push or merge; restore anything you touch";
     - "write `<evidence>/review-<n>/review.json` as `references/review-loop.md` says (it's `review-check.sh`'s input)".
   - output_schema: `{verdict, findings[{id, severity, file_line, claim, scenario, repeats, new_fact}], ac_status[{ac, accepted, test, screenshot, evidence}], defect_loop_skills[], skill_lessons[]}`.

   Board → `reviewing`. If the builder returned `shots[]`, look at the main pair yourself (`vision_analyze`) and send it to Justin now as a preview with the before/after numbers. Don't wait for the merge. Lead with the primary reported defect's before/after pair; label previews of added fixes separately. Use the pair returned for the current candidate and verify its provenance, not a convenient older `after` filename left by a previous fix pass. Label sister-design fixtures and renderer picture stand-ins explicitly: they can prove column arrangement, not fidelity of the user's actual photo or installed page. If only an added fix has a preview, explicitly say the primary fix is not pictured or verified yet, because a navigation-header screenshot does not demonstrate a hero-column correction. If the pictures show some other defect, mention it in one line as an offer of a separate fix. Don't widen the current feature.
2. **Reviewer returns:** run `scripts/review-check.sh --repo <worktree> --base <base> <evidence>` and follow its last line (`references/review-loop.md`). **REVIEW AGAIN** → an **Opus 5.5 high FIXER now** for the listed P0–P2: verify and fix test-first, re-run the gates, commit and stop `ready-for-next-review`, no release; then the next fresh review, on Opus 5.5 high (Full: round 2 is full; later rounds the fix commits and what they touch, unless `review-check.sh` says run a full review from `<base>`), carrying every earlier `review.json` and the fixer's dispositions. **MOVE ON** → its P3 lines go to `<evidence>/follow-ups.md`, then the VERIFIER. **ASK JUSTIN** → ask with the line; to the round-3 question ("only P2 left from round 3 on") his "fix" is `"continue": true` and "follow-up" is `"accept"` with those ids, whose lines go to `<evidence>/follow-ups.md`. Preserve complete reports, reviewed heads and dispositions. If the review exposes an incorrect plan assumption or an unapproved product fallback, authorize only the verified correction as a fix pass and explicitly hold merge/push/BUILD/cleanup pending the user's decision. Write that release boundary in the brief, dispatch context and board note; do not let the usual automatic finisher merge override it. A review result handled during a provider outage or a busy turn is easy to drop, and the feature then sits idle looking "stopped"; when status shows a feature in `reviewing` with no live agent, check whether its reviewer already returned before anything else.
   - goal: `FINISHER for <project> feature "<name>"`.
   - context:
     - the worktree, the plan, and the reviewer's findings verbatim;
     - "load the project skill and `receiving-code-review`; verify each finding, fix the valid ones test first, push back on the rest with evidence, commit and stop at `ready-for-next-review`": the next fresh review comes before any verifier.
     - The project skill's finish step runs only after `ac-check.sh` accepts the head (Agent Defect Loop → **Clean**). For the Figma plugin that's the merge; for Leorna it's stop-and-show-diff, PR text, team message and the ClickUp evidence draft (`leorna` step 4b/6), never pushing or posting.
   - Same output schema as the builder.

   Board → `finishing`.
- **Carry evidence scope through every corrective handoff:** load `references/dispatch-edge-cases.md` → "Evidence scope in corrective handoffs".
- **Evidence-only approval blocker:** if implementation is committed and tests pass but copying evidence is pending approval, inspect the blocked script read-only and preserve its exact pending/denied state. Do not rerun it, rewrite it through another tool, or ask the reviewer to perform the same copy. A fresh reviewer may independently review the existing in-worktree evidence while archival remains explicitly blocked. Keep the worktree until permitted archival is resolved; explain which approval is needed without implying an expired prompt is still actionable. Code complete, review complete and archival complete are separate release facts.
  - **When Justin asks to show approval again:** submit the exact inspected command through the normal guarded tool path; do not change its scope or promise the tool will show a prompt. Report the actual result: pending approval, denial, or successful execution. A successful run clears that specific blocker; reconcile the board and resume the already-approved release pipeline in the same turn when possible instead of leaving a stale waiting-for-approval entry.
  - **Before release after archival resumes:** compare the archive's recorded base, source revision and reports with the final corrected/rebased worktree. A successful old archive script can save valid original evidence while omitting later fixes. Preserve that provenance, archive the final integration proof separately under the now-permitted scope, and verify its manifest before deleting the worktree.

3. **No self-review shortcut.** Every build, even a one-file fix, gets separate fresh review (the review loop). Skip the review only when Justin explicitly waives it for that feature, and say so in the report. When a review discovers a required-browser failure or the fix changes rendering/compositing, transport or product semantics, route the correction back through a fresh independent reviewer before release; a green fix pass alone does not clear that compatibility gate. Put the no-merge boundary in the brief, dispatch context and board note.
   - **From round 3 a review is focused:** the fix commits since the last review (`<last reviewed head>..<new head>`) and what they touch (unless `review-check.sh` says run a full review from `<base>`), with the earlier `review.json` files and the fixer's dispositions (`references/review-loop.md`). From round 3 a round with only P2 left is ASK JUSTIN (fix or follow-up?). Repeat until `review-check.sh` prints MOVE ON; only then the verifier. P3s go to the follow-up list; the main chat never rules on a finding (Q9: the records-only and byte-identical shortcuts are gone).
   - **When a review offers "fix it, or Justin accepts the side effect" while he is away:** choose the scoped fix, not acceptance. Prefer keeping main's exact output wherever main had no defect (e.g. restrict a layout fix to the tiers that were broken), within the feature's own files or a new file, never another queued feature's files; if that is impossible, the agent stops with options. Shipping a newly found regression is not a recommended answer.
4. **Recheck of an already-merged feature** (Justin asks for a second look):
   - Dispatch a REVIEWER with the merged commit range (`<base>..<build commit>`) and the ledger, so it doesn't re-report findings that were already fixed. Also name the known follow-ups already queued.
   - It works in a scratch export of that commit (the project skill's recipe), never in the main folder or a running copy.
   - Board → `reviewing`, with a `note`. On return, set it back to `verified`/`merged`, and offer fixes for anything it found.

## Phase 4: Report (when the builder returns)

Verify before relaying, because a child's summary is a self-report:

- **Figma plugin:** inspect `git -C ~/Documents/FigmaToBricksV2 log --oneline -3`, the committed `BUILD` (`git show HEAD:src/shared/build.ts`), working-tree status and main/origin agreement. An in-flight finisher can edit the working BUILD before its release commit exists: report that as pending, not a newer merged build. Attribute a verified release to its exact build commit even if another finisher subsequently advances main.
- **Leorna:** the branch and `git log` in the repo. The builder never pushes there; its status is `ready-for-review`.

Then send:

```
✅ <name> — build <BUILD> — merged          (or ⏸ <name> — stopped: <reason>)
<what changed, plain words>
Before → after: <one line per picture pair>
MEDIA:<before-x.png>
MEDIA:<after-x.png>
My rulings: …
Your steps: 1. … 2. …
```

**Before/after pictures (Justin, 2026-10-20):** send every pair in `shots[]` (before first, then after), so he sees the fix before opening Figma. Check that each file exists first (`search_files` with `target='files'`). If a fix doesn't change the look, send its text proof instead (e.g. each card → its link).

Board → `merged` or `stopped`. For the Figma plugin, "Your steps" always ends with "reply **pasted** + the page name (e.g. **pasted services**)" (Phase 5). A fix that works through Convert alone (no paste, e.g. one that renames media on the site) ends with "reply **converted**" instead. If Justin says it worked when he checked it himself, set the board to `verified` and skip the CHECKER.

After verifying a Figma merge, remove the feature's copy and branch (`git worktree remove .claude/worktrees/<name>`, then `git branch -d worktree-<name>`) and say so in the report. Leave a running sibling's copy alone.

## Phase 5: Live check (when Justin says "pasted")

After he pastes a merged fix and replies **pasted <page>** (or **converted**), a read-only CHECKER checks the live page: board → `checking`, then follow `references/live-check.md`.

- **Out of steps:** dispatch a new builder with "continue from worktree <path>, last commit <sha>".
- **Builder stopped on a test that pins intentionally replaced behavior:** load `references/dispatch-edge-cases.md` → "A test that pins replaced behavior".
- **Needs a decision:** ask Justin (a 1-3-1), then dispatch a new builder with his answer. When he says to test what is available, separate completed checks, unavailable proof and the release decision: run any still-useful approved checks, remove an unwanted outstanding file/input request, and say plainly whether release remains held. Do not silently substitute assets or waive a gate, but do not keep asking for the same unavailable input or rerunning already-complete checks; offer a narrowly scoped release-policy choice if that is the only remaining path.
- **When Justin asks why work is paused or says to continue:** load `references/dispatch-edge-cases.md` → "Why is it paused".

## Parallel features

Run features in parallel (Justin, 2026-10-29: "you can start multiple plans and orchestrate multiple agents"; lifts the 2026-10-28 one-agent-at-a-time limit): each moves to its next role the moment its agent returns. With two or more features in flight (planning, building or reviewing at once), load `references/parallel-features.md`: overlap checks, build order, shared files and merge order.

## Merge policy per project

Each project has one of two policies; the builder and finisher follow it. Recorded in `git-commit-rules` → "Merge policy per project".
- **Branch + PR on request** (Leorna): work stays on `feat/<name>`. Never merged into main, local or remote. When Justin says "make a PR", push and open it.
- **Auto local merge** (Figma plugin): branch from local `main` in its own worktree. When done, merge back into local `main` on its own: rebase, re-check, take the merge lock, fast-forward only. Then build and push.
- **Setup repo** (`~/.claude-setup.git`, work tree `$HOME`): `--ff-only` merge into local `main`. Other sessions' `sync.sh` commits move `main` every few minutes. A pure rebase (the same patches in the same order, no merges: `ac-check.sh`'s test) needs no new verifier or auditor on any story since 2026-11-10: the finisher writes a rebase receipt and `ac-check.sh --rebase-receipt` accepts the earlier reports (`references/ac-verification.md`). The wider review-loop permission (2026-10-29: no conflict, the story's own `+`/`-` lines byte-identical to the accepted head's, `git diff <base> <head>` with hunk headers and context dropped, and every gate passing on the new head, even when `main` touched other lines of a story file, which `patch-id --verbatim` doesn't count as pure) still needs asking before reusing it on another story. One finisher script does the rebase, the checks and the gates, rebasing onto the exact `main` sha it read, and runs the `--ff-only` merge itself the moment a round ends with `main` unchanged (review-loop finisher 4: merged on the first round after two lost races).
- **New project** (not in the table): before dispatching the planner, ask `❓ <name> [<project>] needs you: merge rule for <project>? A) like Leorna (branch, PR when you say) ⭐  B) like the Figma plugin (auto-merge into local main)`. Record his answer in `git-commit-rules` and pass it to every agent for that project.

## "What are we working on?"

**Status answers** (the board and live agents, one block per feature, "how long did it take?", "full breakdown", docs questions): load `references/main-chat-housekeeping.md` → "What are we working on".

## Pitfalls

- **`/restart`, `/new`, a gateway crash, or the Mac sleeping** can cut off running agents or lose their results. Before Justin sends `/new` or `/restart`, check the board; if anything is planning or building, warn him. A cut-off builder leaves its worktree and commits: resume with a new builder.
  - **When he says he's resetting the chat:** first rewrite `~/.hermes/plans/handoff-main-chat.md` (overwrite it, don't append): what to load, reply style, model rules, the current build, each live agent with its role, model, brief path and next roles, queued features and what they wait for, pending CLAUDE.md edits (which sections already landed), and paste checks owed. Then warn him with the verified count of live agents; do not invent finish-time estimates from elapsed time or role. Recommend waiting for actual completion messages, and give him a paste-ready first message for the new chat: read the handoff, load feature-dispatch and the project skill, check the board, live agents, git and both usages, resume cut-off agents from their briefs, then send the full agent list. Keep the handoff current as plans land after that, since he may reset later than he said.
- **Not cron, not `hermes chat -q`:** `approvals.cron_mode` and `single_query_mode` are `deny`, so a build's flagged commands would fail there. Subagents in a gateway session use the chat's approval queue, so Justin may get an approval prompt on WhatsApp; that's expected.
- **Protected documentation can require a live approval.** If a child reports an approval expired or a write was denied, preserve its exact proposed edits without retrying or bypassing that decision. When a permitted session can apply them, re-read anchors with `search_files` and paginated `read_file`, then `patch` in build order, preserving newer content. Track partial application explicitly and rename `*-claude-md-pending.md` to `*-claude-md-applied.md` only after every required section landed. Never count standing permission or a successful release as proof documentation was updated.
  - **Several pending files at once:** apply them as one pass, not file by file. Insert all new "Start here" entries in a single patch, newest first, directly above the previous newest entry, and write the build/check block once with the newest file's values; then each file's other sections. Applying files one by one makes "insert before X" stack entries oldest-first and rewrites the build line several times. If the pass stops partway, add a note at the top of every touched pending file saying which sections landed, so the next session doesn't insert them twice.
  - **Respect the actual protection result.** Standing permission does not override an explicit denial or withdrawn approval. Preserve exact pending edits and applied-section notes; do not retry a denied edit through the main chat, another tool or another agent. Apply pending edits only when a permitted approval path is available, then rename only fully applied files. Report documentation as pending rather than promising it will be written during an unrelated turn.
- **Stale terminal cwd:** after a worktree is removed, the persisted terminal session cwd can still point at the deleted copy, so commands without `workdir` fail with exit 126 (`cd: …/worktrees/<name>: No such file`). Always pass `workdir`, and say so in agent briefs.
- **`delegation.max_iterations` is 250.** A big build can run out; that's what the out-of-steps continuation is for.
- **Children can't call `clarify` or `delegate_task`.** That's why the main chat dispatches the reviewer (Phase 3b) and the verifier (Agent Defect Loop). Never tell a builder to spawn its own reviewer, and tell every child that a loaded skill's "spawn a subagent" steps are run by the main chat instead.
- **A chat that's been open a while holds stale skill text.** After this skill, a project skill or a role skill changes, the main chat still carries the old version it loaded earlier, and briefs written from it name the old role lists. Re-load the changed skills with `skill_view` before the next dispatch, or ask for `/new` once nothing is running. Children always read skills fresh from disk.
- **Results re-enter only between main-chat turns.** If Justin is mid-conversation, the result arrives right after.
- **Usage:** agents use about two-thirds of the tokens, and a long main chat re-sends its whole history every turn. When Justin asks about consumption, measure first (`hermes usage`, `hermes insights --days 1`), then offer levers. Under heavy load, check `hermes usage` before each new dispatch: finish in-flight work before starting new agents, and start nothing new above about 80% of the 5-hour window. The commands, the guard and the lever table (reasoning effort, agent model, one-file self-review) are in `references/usage-and-cost.md`.

## Verification

- Every dispatched feature is on the board, and its phase matches reality.
- After a dispatch group, read back its board entries and check the live list for the expected agent IDs and models; reset routing overrides before ending the turn. Reconcile the handoff in place: replace obsolete active statements such as "not dispatched" or "nothing running", or clearly label the whole old block historical. Appending a newer status above contradictory instructions leaves the next session with two competing queues.
- No "merged" is relayed without the git check in Phase 4.
- The main chat holds no code reads, only plans' summaries and results.
