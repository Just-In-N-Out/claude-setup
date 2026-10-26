# Resume state: three Leorna sessions paused 2026-10-23 at about 20:00 EDT (23:59Z)

Collected read-only by a fresh agent from the transcripts, checked against git and the files at about 20:10 EDT. "Transcript only" marks facts not re-checked.

**Common to all three**
- All three stopped on Justin's "wait pause".
- Remote control-plane `main` is `57c7fc1`. CP PR #85 and client PR #20 (prompt kind, 86bcm9016) are both OPEN.
- The rules changed after the pause, in `~/.claude/CLAUDE.md` (first section):
  - the main session only orchestrates;
  - agents are `general-purpose`, never `Plan`;
  - every brief is saved to `~/.hermes/plans/leorna/briefs/` before dispatch;
  - step 6 adds a blind AC auditor plus `ac-check.sh` (see `feature-dispatch/references/ac-verification.md`).
- Hooks: `subagent-ac-gate.sh` (reports must carry `ac_status`), and `subagent-handback-gate.sh` for background agents.
- Files saved here because no session saved them: `86bcm901v-catalog-browser-v2-planner-output.md` (the full v2 plan), `86bcm945u-planner-brief.md`, `86bcm945u-explorer-reports-forwarded.md`.

---

## 1. Quality gate v2: 86bcm901u "Content quality gate (CI)" (old session 6850ae17, "rebuild-content-quality-gate")

**Basics**
- Repo: control plane only. Client render code was copied read-only from leorna-client `8d540f1`.
- Pipeline: Full, every role a fresh Opus 5.5 xhigh agent.
- Plan: `~/.hermes/plans/leorna/86bcm901u-quality-gate-v2.md`. A plan-mode copy is at `~/.claude/plans/pasted-content-id-43b3-okay-this-curried-conway.md`.

**Approval and answers.** Approved through ExitPlanMode, with Justin's added rule: "keep looping until all AC are accepted … take a screenshot for each AC because we are going to upload to clickup". His answers:
- Old attempt: "leave it, new branch".
- Planner: fully blind.
- Q1-A: copy the client renderer.
- Q2-A: agents count as deferred and warnings as warn; both pass.
- Q3-A: job summary plus log lines; the JSON is not uploaded.
- Q4-A: 9016 merges first, then task G1 adds prompt rendering.

**ACs**
- AC1: on a library change, CI schema-validates every item, renders it for Claude Code, Codex and Cursor, and secret-scans it.
- AC2: a render failure for a declared-supported tool fails CI and names the item and the tool.
- AC3: a passing run produces a per-item compatibility report.
- Verify: V1 the real library passes; V2 a broken render, V3 a planted secret and V4 a bad schema each fail.

**Git (verified)**
- Worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v2`, branch `feat/86bcm901u-quality-gate-v2`.
- HEAD `2e8b5cd5119c4824ed5cbe51dd826d0daa3a79c2`, base `57c7fc1`.
- Commits:
  - `0a50ddd` mirror the client render step
  - `a9a3359` check every item for each tool and for secrets
  - `6795dab` run the gate in CI
  - `975da29` docs
  - `2e8b5cd` keep item keys from becoming links in the summary
- 60 files, +6051/−6. The only `.github/` change is `ci.yml` (this story has a CI exception for `ci.yml` only).
- Clean tree. All commits authored by Justin Issa <justin@leorna.com>. The branch has no upstream and has not been pushed.

**Where it stopped**
- The builder finished tasks B0–B19 and handed back `stopped`. It never formally marked `ready-for-review`.
- Its claimed gates, all exit 0: `make check`, `test-module-add`, the story tests (78 PASS, 0 SKIP), Postgres, story gitleaks, `library-check`, the baseline. 31 mutations killed; copy parity passes.
- `SUMMARY-2e8b5cd.txt` shows every gate at EXIT=0 (verified).
- The main chat checked HEAD, the clean tree, authors, receipt exit codes and that the screenshots exist. It did **not** check screenshot contents, the mutation table or the builder's 12 rulings.
- The main chat's summary to Justin was never sent.
- No agent was running, and nothing is half done.

**Evidence:** `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v2/`
- `INVENTORY.md`, `SUMMARY-2e8b5cd.txt`, the gate logs and receipts, `mutations-2e8b5cd.txt`, `parity-diff-2e8b5cd.txt`, `tdd-log.txt`.
- PNGs: three `ac1-*-2e8b5cd`, `ac2-broken-item-fails-2e8b5cd`, `ac3-report-table-2e8b5cd`.
- `superseded/` holds the 975da29 set: never attach it.

**Owed**
- Reviews, the verifier and the new AC auditor plus `ac-check`.
- The hand-over: PR text, review prompt, team message, ClickUp evidence draft.

**Not verified until a PR exists** (these don't block local acceptance): hosted CI for the Verify runs; GitHub's rendering of the AC3 summary; ClickHouse tests; CRLF checkout.

**Hold:** G1 waits on CP #85 and client #20.

**Open for Justin and the reviewers**
- The builder's 12 rulings (in its hand-back JSON in transcript 6850ae17).
- V2–V4 exit 2 through make, where the plan expected 1; the gate's own exit 1 shows on go run's line.
- found_else: gitleaks honours `<source>/.gitleaksignore` (medium-low); the repo `.gitleaks.toml` allowlist also applies to library content (low).
- Pushing a workflow change needs the SSH key unlocked or a token with workflow scope.

**Leftovers** (keep them)
- Test DB `leorna_86bcm901u_v2_test` in `leorna-test-pg`.
- Scratch `~/.hermes/cache/scratch/86bcm901u-quality-gate-v2/`.
- The old attempt, untouched: branch `feat/86bcm901u-content-quality-gate`, 6 worktrees, DBs `leorna_86bcm901u_sol_fix_r3_test` and `_r4_test`.

**Justin's standing rules here**
- All Opus.
- Loop until every AC is accepted, no round cap.
- One screenshot per AC.
- `skill_lessons` from every agent.
- No push, PR or post unless he says so.
- **Away grant** ("keep the plan going and whatever it asks just do the recommendation"): this pipeline only. It excludes push, PR, merge, remote CI, credentials, ClickUp and touching the old attempt.

**Unsaved lessons**
- The builder's lesson for `api-contract-drift-guard` (parity rebuild check) is in its hand-back.
- The zsh gotchas are now saved in memory.

---

## 2. Catalog browser v2: 86bcm901v "Library catalog browser" (old session 094ada45, "library-catalog-browser-v2")

**Basics**
- Repo: control plane.
- Pipeline: Full, every role Opus 5.5 xhigh. Fresh start, with the planner blind to the old attempt.
- Orchestration plan: `~/.claude/plans/hey-utilize-the-clickup-snoopy-aurora.md`. Approved via ExitPlanMode after "whatever the plan says just keep going ok go with the recommendation".
- **The story plan was never saved.** The planner's full output is `restart-2026-10-23/86bcm901v-catalog-browser-v2-planner-output.md`. Its first line says to save it as `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v2.md`.

**The planner's questions (all recommend A)**
- Q1-A: in-repo Markdown-subset preview.
- Q2-A: list shows the newest version; the item page links every version.
- Q3-A: filter choices built from stored items.
- Q4-A: real-Postgres test with 250 items, under 300 ms per request.
- Q5-A: local dev sign-in plus headless Chrome screenshots.

**ACs**
- AC1: filter by kind, category, tag and tool, and search by text.
- AC2: the item page shows description, example, version, tools and a rendered preview.
- AC3: with 200+ items, filtering stays under 300 ms server time.
- The plan's §4 maps each AC to tests and screenshots: `ac1-library-filters.png`, `ac2-item-detail-preview.png`, `ac3-filter-timing-test.png`.

**Git (verified):** worktree `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v2`, branch `feat/86bcm901v-catalog-browser-v2`, HEAD `57c7fc1` (0 commits), clean.

**Where it stopped**
- The planner finished after the pause. It made one blind-rule slip: a `grep` printed some lines about the old attempt.
- It returned 6 skill lessons and 7 found_else items, among them a low dev-only open redirect `/dev/login?next=/\evil` and the `readBody` 64 KiB cap.
- The main chat never took the result in.
- Evidence folder `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v2/` is empty.

**Stale records**
- No board entry for v2.
- The old `86bcm901v-library-catalog-browser` board entry still says `awaiting-answer`.
- Memory line 99 in `leorna-workflow.md` still says "PLANNING".

**Overlaps**
- The plan's Q1-D follow-up needs 901u-v2's `toolrender`.
- Merge order: #85 first, then this story.
- The admin library page overlaps 945u's AC1 (source and licence per item).

**Leftovers:** the old attempt is untouched (12 commits at `5e54c6c`, 5 worktrees).

**Justin's standing rules here**
- All Opus.
- Use the hooks; save skill lessons after each agent.
- Same rules as 901u-v2.
- No CI exception.
- **Autonomous grant:** this plan plus the story plan; every recommended answer counts as his, up to the finisher hand-over. It excludes push, PR, merge, ClickUp, his servers, cloud, real `~/.claude`/`~/.codex` tool-home writes and CI edits.

---

## 3. Upstream content sync: 86bcm945u "Upstream content sync + licence attribution" (old session 3c2e37eb, "leorna-a3")

**Basics**
- ClickUp status: to do, list E10.
- Repo undecided. The card says "content", but no such repo exists; the recommendation is control-plane `internal/library`.
- Upstream: `addyosmani/agent-skills`, MIT licence. Pin `0.6.13` = `aeac41d4d005`, still upstream HEAD.
- Full or Mini was never asked.
- No plan, no approval, no branch, no worktree, no evidence.
- The planner was killed mid-research with 0 writes, so it must be re-dispatched. Its brief and the explorers' digests are saved in this folder.

**ACs on the card**
- AC1: a THIRD_PARTY_NOTICES file carries the agent-skills MIT licence and copyright, and the admin console shows source and licence per imported item.
- AC2: the sync job reports added, changed and removed items as a diff against the pin, without overwriting Leorna adaptations.
- AC3: an accepted upstream change bumps the item version and records the new source commit.
- AC4: a decision on reusing the upstream evals in the quality gate is recorded.
- Verify: a dry-run sync against upstream HEAD, and the licence notice present in the built installer.

**Decisions for the plan's questions**
- The repo (recommended: control plane).
- Sync as a CLI only (recommended, no CI) or CLI plus a scheduled CI run, which would need a CI exception.
- How the admin console part fits with 901v-v2's `/admin/library`.
- Import items now, or build only the machinery.

**Explorer facts to pass to the planner**
- Adding new fields to an item's checksum would stop already-deployed servers from starting.
- No built artifact includes a licence file today.
- 4 of the 25 upstream skills have extra files that `parseItem` rejects.
- The upstream evals need Node or live Claude calls.
- #85 already uses migration 21, so this story takes 22 at the earliest.
- The test reset helper hard-codes its list of tables.
- New since then: 901u-v2 is built at `2e8b5cd`, and 901v-v2's plan proposes `/admin/library`.

**Justin's rules here**
- Load the right skills.
- Keep going until every AC is met.
- The main chat orchestrates; another agent writes the plan.
- No permissions were granted in this session.
