# Brief: BUILDER for figma-to-bricks feature "label-floor" (Mini pipeline)

Build the approved plan. Don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/label-floor` (branch `worktree-label-floor`, from local `main` at cd9c1c9). Work only there; never edit the main folder `/home/justin/Documents/FigmaToBricksV2`.
- Plan: `docs/plans/2026-10-26-label-floor.md` in the worktree (untracked: commit it first, as your first commit). The approved, read-only copy is `~/.hermes/plans/figma-to-bricks/evidence/label-floor/plan-approved.md`; if the two ever differ, the approved copy wins.
- Evidence folder: `~/.hermes/plans/figma-to-bricks/evidence/label-floor/builder/` (shots, terminal captures, before/after replays).
- Ledger: `.superpowers/sdd/2026-10-26-label-floor/progress.md` in the worktree.

## Skills (load first, say so in one line each)
1. Project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the BUILDER role (its `references/rules-summary.md` first; only the worktree `CLAUDE.md` sections you need, via grep + offset/limit).
2. `engineering-best-practices` (Skill tool).
3. `test-driven-development` (Skill tool): a failing test before each code change.
4. `mutation-testing-discipline` (Skill tool) for the recogniser's guards (pill shape, go-word/arrow link, the exclusions in AC4).
5. `systematic-debugging` (Skill tool) whenever a test fails unexpectedly or a corpus/lint number gets worse: find the cause, don't patch around it.

## Approved answers (Justin's standing auto-go: every ⭐)
1A: a pill = round ends, every corner ≥ 40% of its height, wider than tall. 2A: "Learn more"-style = linked go-words, or linked words with a → arrow right after them ("Call Us Now ↗" grows to 15px). 3A: pills inside a searchable list keep their drawn size. 4A: the bigger size goes on the element; the Figma style's class keeps its size (no Import-classes dialog). 5A: install Chrome for Testing under `~/.cache` with no sudo (below).

Justin's words: "Well i want something like this but when it comes to learn more or if they are in that pill form." Chosen sizes: "Pills 13px, links 15px". Pipeline: Mini. Sai Varsha (the request): "What's the size of these fonts? It just looks too tiny 😅. Can we make them a little bigger please?"

Done means: every AC1–AC8 proven by its named test (AC7 by the before/after corpus evidence), AC9 left for Justin (live), `npm run check` green, browser tests green (or the Chrome stop below), committed, status `ready-for-review`.

## This machine (Linux/WSL desktop): checks
- `corpus/corpus.json` has Mac paths, so `npm run corpus` measures **nothing** here: don't count it as a check. Measure the five files that exist directly with `npm run replay` and `npm run snap`, before (on the untouched commit) and after: `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, repo-root `figma-to-bricks-debug-page-1.json` (Repairs), `figma-to-bricks-debug-design-inspo-brainstorm.json`, and Services (`git show 2199895:figma-to-bricks-debug-page-1.json` into the evidence folder). Diff by element id; lint no worse at every width.
- No Linux Chrome. `test/browser/chrome.ts` defaults `CHROME_PATH` to the macOS app. Per 5A, install Chrome for Testing (a stable version, from Google's official `storage.googleapis.com/chrome-for-testing-public` / its JSON endpoints) under `~/.cache/chrome-for-testing/`; fetch missing libs (libnss3, libnspr4, libasound2t64 and whatever `ldd` reports missing) with `apt-get download` + `dpkg -x` into `~/.cache/chrome-libs/`; run with `CHROME_PATH=…` and `LD_LIBRARY_PATH=…`. **Never sudo**, never apt-get install, nothing outside `~/.cache` and the worktree. Write the exact env lines into the ledger so the reviewer and verifier can reuse them. If Chrome still won't start after a bounded try, commit what passes and stop with `status: stopped`, `stop_reason: chrome` (AC6/AC7 lint then go to the Mac).
- Take before shots from the untouched copy before your first code change (snap at the homepage cards: hydraulics-home at 1728, 1440, 768, 390), and after shots after the last task; return paths in `shots[]`. One test and one screenshot per AC (a terminal capture of the test run for an AC with nothing visual).

## Rules
- Commit to the branch after each passing task: plain `git commit -m "…"`, no author override, no `Co-Authored-By` or AI lines. Check `git diff --cached --name-only` before each commit: CLAUDE.md must never be staged. Don't push. Don't bump `BUILD`. Don't edit the worktree's CLAUDE.md (status notes go in `docs/HANDOFF.md` and the ledger). Never bare `git stash`.
- Stay within the plan's touched files. Existing tests that pin the old size: update only those the plan's "may pin the old size" list names, each named in the ledger with why.
- Mini pipeline: if the fix needs source files well beyond the plan's list, a new design decision, or GRO's (or any file's) lint gets worse and the plan's rule can't hold, stop with `status: stopped`, `stop_reason: escalate to full`, with shots and numbers. Don't narrow the rule to make a number pass.
- You can't ask Justin anything. On a real trade-off, make the ruling and write it as "My ruling, not yet confirmed" in `rulings[]` and in the ledger.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]`. An empty list is the normal answer.
- Stop at `ready-for-review`: no merge, no BUILD, no main-folder edits.

## Return (your final message)
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], ac_evidence[{ac, test, screenshot}], chrome_env, found_else[], defect_loop_skills[], skill_lessons[]}`. End with the line `MAIN SESSION: check and save these skill_lessons now.`
