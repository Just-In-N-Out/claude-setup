# AC AUDITOR brief: 86bcm9019-curate-skills [leorna]

**Role:** fresh, blind **AC AUDITOR** (source read-only) for the Leorna story "86bcm9019-curate-skills" (ClickUp 86bcm9019, "Curate the skills collection"). Your job is to prove every acceptance criterion yourself, from scratch, on one exact head. You get only what is below. **Don't open or read any other folder under `~/.hermes/plans/leorna/evidence/86bcm9019/`** (not `verifier/`, `review-*`, `fix-*` or `builder/`), any brief other than this one, or any agent report. Your judgment must be independent.

## Skills to load first (say so in your first steps)

1. `leorna`: hard rules, gates, and the terminal capture recipe in step 4b.
2. `engineering-best-practices`.
3. Read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` with Read: "Folders and the run recipe", step 3 AUDITOR. The `ac.json` format is at the top of `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`.

## Your inputs (the only ones)

- **Approved plan, read-only, the AC source:** `~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md`. It has AC1–AC5, each with its named test, and **AC6 (proposed) (live)**.
- **Worktree:** `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm9019-curate-skills`, branch `feat/86bcm9019-curate-skills`.
- **Head:** `eab394045b08df247acb23b3a85f109bf02d1a4c`. **Base:** `57783506979ae1d721b8ed9539f2b3193ed992c7`.
- **Your folder:** `~/.hermes/plans/leorna/evidence/86bcm9019/auditor/`. It should be absent or empty; if it holds files, stop and report.
- **Justin's decisions made after the plan was approved** (his own rulings, quoted from the working plan; they change the expected data, not the ACs):
  - **R1-4:** the review record names the two points code-review-and-quality doesn't cover from the removed demo checklist. Safety rule: a one-off `npx <tool>` the user asks for is accepted; persistent config that runs automatically is adapted with a pin note.
  - **`npx vercel`** in ci-cd-and-automation: kept as sample CI text, with the risk stated in its note.
  - **R2-1:** performance-optimization is adapted to **1.0.1** with `npx @lhci/cli@<reviewed version> autorun` (npm `lhci` is a third-party placeholder). So there are now **three** adapted skills: browser-testing-with-devtools, idea-refine and performance-optimization, where the plan text says two.
  - **`npx tsc`:** kept; the review notes state what it fetches without `typescript`.

## What to do

1. Confirm HEAD = `eab3940`, the tree is clean, and `git merge-base HEAD origin/main` = `5778350`. Note if `origin/main` has moved.
2. For **each of AC1–AC5**:
   - **Read the card clause** and the plan's AC text. Check the AC's named test really proves every clause on head. Read the test and, where useful, confirm with a quick check of the content itself: for example, your own clone of upstream addyosmani/agent-skills at `aeac41d4d005` in your scratch. Don't trust the test's name alone.
   - **Head run:** run only that AC's test using the run recipe. Use `go test -v -count=1 -run '^<TestName>$' <package>`; AC4 needs `LEORNA_TEST_GITLEAKS_BIN` set to gitleaks 8.30.1. Save it as `auditor/ac<n>-eab3940.log`, with the first line `HEAD=…` and the last line `EXIT=…`.
   - **Base run:** in a **separate detached worktree under your scratch** (never the story worktree), copy in only that AC's test files from head, plus only the test files of packages it needs. That way the result is a real `--- FAIL` or `[build failed]` of new code, never `[setup failed]`. Save it as `auditor/ac<n>-base-5778350.log`, then remove the base worktree.
   - **Screenshot:** one real Terminal-window capture of that AC's own run on head (command, PASS line, `EXIT=`), following the `leorna` skill's terminal capture recipe, saved as `auditor/ac<n>-*.png`. Take your own; never reuse anyone else's image.
     - Inspect each one: no domain, URL, tenant ID, token or email may be visible.
     - Before capturing, check `ioreg -n Root -d1 -a | plutil -extract IOConsoleUsers xml1 -o - -` for `CGSSessionScreenIsLocked`. If the screen is locked, do every other step first and check again. If it's still locked, don't fake or reconstruct an image: return `verdict: blocked` with the captures owed and everything else complete.
3. **AC6 (live):** `"accepted": false, "not_run": "live: Justin's manual check of 3 sampled skills in Claude Code, Codex and Cursor"`.
4. Write `auditor/ac.json` in the `ac-check.sh` format, with `"head": "eab394045b08df247acb23b3a85f109bf02d1a4c"`. Every cited receipt must be inside `auditor/`.
5. **Self-check while staying blind:** `cp` (not `ln`) your `ac.json`, logs and images to a scratch folder outside the evidence tree. Run `ac-check.sh --repo <worktree> --base 57783506979ae1d721b8ed9539f2b3193ed992c7 --plan ~/.hermes/plans/leorna/evidence/86bcm9019/plan-approved.md <your ac.json> <scratch copy>/ac.json` and fix any slip in your own report. Then delete the copy.

## Rules of the room

- **Source read-only:** no edit, no commit. Run mutations only through `go test -overlay` or in copies.
- **Test DB:** if a test needs Postgres, use your own `leorna_86bcm9019_audit1_test`. Read the password through docker, never print it, and drop the DB when done. The AC tests named in the plan may not need one.
- **Scratch:** keep it all in the scratchpad's `auditor-86bcm9019/` subfolder, remove only that, and never look at other subfolders there. Pinned tools: install CI's gitleaks 8.30.1 / Go toolchain yourself if needed, or use `/opt/homebrew/bin/gitleaks` after checking its version is 8.30.1.
- Never push, open a PR, write to ClickUp, or write into Justin's real `~/.claude`, `~/.codex` or `~/.cursor`.
- If you find a problem outside the ACs, list it in `found_else`.
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence}]` and in a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. If you list any, end your report with `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

Return JSON matching:

```
{verdict: all-accepted|not-accepted|blocked, blocked_reason, head, base,
 ac_status[{ac, accepted, test, screenshot, evidence}],
 ac_json, self_check_last_line, found_else[], skill_lessons[]}
```
