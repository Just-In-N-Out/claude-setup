# Brief: BUILDER for figma-to-bricks feature "faq-answer-space" (Mini pipeline)

You are the BUILDER. Build the approved plan; don't re-plan.

## Where
- Worktree: `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/faq-answer-space`, branch `worktree-faq-answer-space` (from local `main` at cd9c1c9). Work only there. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2`.
- Plan (approved under Justin's standing auto-go for this repo, all ⭐ answers taken: **1A** the space Figma draws on every screen, **2A** a design with no space under its answers keeps none, **3A** Justin re-pastes Home): `docs/plans/2026-10-26-faq-answer-space.md` in the worktree (uncommitted: commit it in your first commit, after adding a `## Justin's answers (2026-10-26)` line saying "auto-go: 1A 2A 3A"). The read-only approved copy the AC check reads is `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/plan-approved.md`; never edit it, and never add, rename or re-tag ACs.
- Evidence folder: `~/.hermes/plans/figma-to-bricks/evidence/faq-answer-space/` (put your shots and diffs in `builder/` there; never write in `verifier/` or `auditor/`).
- Justin's screenshot: `~/.hermes/plans/figma-to-bricks/shots/faq-answer-space-report.png`.

## Skills (load first, say so in one line each)
1. The project skill: Read `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and follow it in the BUILDER role, from its build step to ready-for-review (not its merge/finish step). Read `references/rules-summary.md`; read only the parts of the worktree's `CLAUDE.md` you need (grep, offset/limit).
2. `engineering-best-practices` (Skill tool).
3. `test-driven-development` (Skill tool): a failing test before each change; if a test fails unexpectedly or a number gets worse, go back to `systematic-debugging` instead of patching around it.

## The job
Justin: on an open FAQ item, the answer's last line sits on the divider under it; he wants clear space under the answer when it is open, in every FAQ the plugin builds. The plan's root cause: Figma's answer box (no auto layout, fixed height, words at its top) holds that space only as a min height, which fills up when the words wrap and is set to 0 from 991px down. The fix (plan "The fix"): `understand/accordion.ts` measures the space drawn under the answer's words and puts it on the Content holder as bottom padding; the answer hugs its words.

Build it test first, task by task, as the plan says. **One test per AC, its name starting with the AC id exactly as the plan names it** (`AC1 …` … `AC6 …`), so a verifier can run it alone with `node --test --test-name-pattern='^AC1 '`. Each AC test must fail on `main` (cd9c1c9) and pass on your head: prove it (check out the fix's source files from main, run, restore with `git checkout HEAD -- <files>`; never bare `git stash`). One screenshot per AC in `builder/` (the real render for AC2–AC4, a terminal capture of the run for AC1, AC5, AC6). AC7 is `(live)`: Justin checks it; leave it.

## Checks on this machine (important)
- Linux desktop (WSL). `npm run corpus` finds **no** files here (corpus.json has Mac paths): don't count it. Measure directly with `npm run replay` / `npm run snap` on `corpus/files/hydraulics-home.json`, `corpus/files/gro-home.json`, the repo-root `figma-to-bricks-debug-page-1.json`, `figma-to-bricks-debug-design-inspo-brainstorm.json`, and the Services save (`git show 2199895:figma-to-bricks-debug-page-1.json` into the evidence folder), before your first code change (main) and after the last task: pastes diffed, lint at 390/768/1024/1440/design width no worse. Don't fix corpus.json.
- **No Chrome here.** Every `test/browser` test is skipped when `hasChrome()` is false, and `npm run test:browser` still exits 0. Install a no-sudo Chrome first: `npx @puppeteer/browsers install chrome-headless-shell@stable` (into your scratch folder), add missing libs (`libnss3`, `libasound2`, …) with `apt-get download` + `dpkg -x` and `LD_LIBRARY_PATH` if it won't start (`sudo` is refused), then `export CHROME_PATH=<that binary>`. A browser run counts only when its output says `skipped 0`. Write the exact recipe that worked into the ledger and `INVENTORY.md` in the evidence folder so the reviewer, verifier and auditor can reuse it. If Chrome truly can't run here, stop with `status: stopped` and say why (don't mark browser ACs as passing).
- `npm run check` must pass, and `npm run test:browser` with `skipped 0`.

## Rules
- **Mini pipeline:** if the fix needs more than ~3 source files, a design decision, or a change to how every accordion is built, stop with `status: stopped`, `stop_reason: escalate to full`.
- Another feature, `label-floor`, is being built beside you (pill / "Learn more" font sizes: `style/typography.ts`, `normalise/label-box.ts`, `adapt/rules/label.ts`, `adapt/layout.ts`). Stay within this plan's files; whoever merges second rebases and keeps both HANDOFF sections.
- Commit to the branch after each passing task (plain `git commit -m "…"`, no author override, no AI or Co-Authored-By lines; check `git diff --cached --name-only` never lists CLAUDE.md). Don't push. Don't bump `BUILD`. Don't edit the worktree's `CLAUDE.md`: status notes go in `docs/HANDOFF.md` and the ledger. Never bare `git stash`.
- Ledger in `.superpowers/sdd/2026-10-26-faq-answer-space/progress.md`; HANDOFF section "Space under an open FAQ answer" with the paste check Justin owes (re-paste Home and Repairs; his four retyped answers come back as placeholders).
- Leave the worktree committed and clean when you stop (no untracked files: remove your scratch or keep it outside the worktree).
- You can't ask Justin anything. On a real trade-off, make the ruling, write it as "My ruling, not yet confirmed" in `rulings[]` and in the HANDOFF section. If it can't be decided safely, stop with `status: stopped` and list the options.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the last commit.
- If you find any other bug or problem, don't fix it or fold it in: list it in `found_else` (one line each, evidence, severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report. An empty list is the normal answer.

## Return (your final message)
`{name, status: ready-for-review|stopped, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], ac_tests[{ac, test_name, file, fails_on_main, passes_on_head}], chrome_recipe, found_else[], skill_lessons[]}` (only `status` and `summary` required). End with the line `MAIN SESSION: check and save these skill_lessons now.`

## Justin's words
Screenshot of the open FAQ item, the answer's last line underlined: "Can we add more space under the FAQ when it's open? Under the answer." Justin: "fix this ok?" Pipeline: "Mini (Recommended)". (No reply to the plan: the repo's standing auto-go takes the ⭐ answers.)
