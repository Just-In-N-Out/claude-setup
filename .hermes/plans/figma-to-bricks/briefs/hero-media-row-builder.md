# hero-media-row — BUILDER brief (Figma to Bricks V2)

You are the **BUILDER** for the Figma plugin feature **hero-media-row**. The plan is **approved**: build it, don't re-plan.

- Plan: `~/.hermes/plans/figma-to-bricks/hero-media-row.md` (read it whole first, including "Justin's answers" at the end).
- Worktree: `~/Documents/FigmaToBricksV2/.claude/worktrees/hero-media-row`, branch exactly `worktree-hero-media-row`, from local `main` (currently `b4ed333`, BUILD `2026-10-22.5`).
- Evidence the planner left: `~/.hermes/plans/figma-to-bricks/evidence/hero-media-row/` (probe scripts, measurements, header CSS, screenshots, red-on-main tests).

## What Justin approved (all ⭐ answers + his clarifications)

1. **Part 1 is the main job.** Hero = text column on the left (breadcrumb, eyebrow, big heading, paragraph, buttons) and a framed picture on the right. On desktop it's right. At **tablet portrait (≤ 991px)** and **mobile landscape (≤ 767px)** the picture frame must stay **on the right of the text**, like desktop, instead of dropping below the buttons at full width. Justin re-confirmed this with two screenshots: desktop correct, tablet with the frame stacked under the buttons = the bug.
2. **Q1 A:** upright phones (≤ 478px) stack as today (text, picture, buttons band).
3. **Q2 A:** only the page's hero (top section), on any page, found from structure.
4. **Q3 A:** hero-only rule; the held W-B decision stays held, nothing else moves (Bento grid and 553:7606 unchanged, control test).
5. **Sideways phones:** keep today's rule: hero buttons move to the band under the hero; text + picture stay side by side above it.
6. **Part 2 (header), Q4 A / Q5 A / Q6 A:** no plugin code. Deliver the tested CSS block for Justin's own header template (links fold into the menu button below 1,280px; phone number hides ≤ 767px, button hides ≤ 478px) in your report and HANDOFF, with the paste steps. Re-verify it as the plan says.
7. **Part 3 (breadcrumb):** keep it. A single word Figma broke inside a too-narrow auto-height box gets a one-line box in normalise, so "SERVICES" shares its neighbours' baseline.

## Skills (load in this order and say so in your first steps)

1. `skill_view('figma-to-bricks')` and follow it in the **BUILDER** role, Step 1 (rules-summary first, never the whole CLAUDE.md) through Step 3. Skip Step 3 item 6: the main chat runs the review.
2. `engineering-best-practices` (the project skill and Justin's rules win where they differ).
3. `test-driven-development` (a failing test before each code change).
4. `systematic-debugging` when a test fails unexpectedly or a corpus number gets worse.
5. `mutation-testing-discipline` for T3/T7 as the plan says.
6. `frontend-ui-repair`, the area specialist. It **carries the Agent Defect Loop**: you are its implementation agent. The reviewer, finisher and verifier are run by the main chat. Skip any loaded skill's "spawn a subagent" or auto-fix steps: you can't spawn agents.

Return `defect_loop_skills[]` naming the loop skills you loaded.

## Rules

- **Disk is nearly full (2.2 GiB free at dispatch).** Check `df -h ~` before making the copy and before each heavy gate (corpus, browser, snap). Use APFS clones (`cp -Rc`) as the skill says. If free space drops under about 1.5 GiB, commit what passes and stop with `status: stopped`, `stop_reason: disk`, naming what needs room. Never delete other worktrees, caches or anyone's files to make room.
- Before/after pictures: before your first code change (copy still equals `main`), run `npm run snap` on the file that shows the bug, with `--sides`, into `.superpowers/sdd/hero-media-row/shots/before`. After the last task, run the same into `shots/after`. `snap` takes one comma-separated width list (e.g. `1571,990,768,600,478,375`). Copy the section pictures that show each part's fix (hero at 990 and 600, breadcrumb at desktop) to `~/.hermes/plans/figma-to-bricks/shots/hero-media-row/` as `before-<section>-<width>.png` / `after-<section>-<width>.png`, and return their absolute paths in `shots[]`. Never commit them.
- Run the plan's widths: hero at 990/768/600/480 plus phones 375/360/320, and laptops 1366/1300/1200/1100/1024/992 compared with main (right edges, clipped pictures). Save the corpus report and the baseline `bricks.json` copies before Task 1, as the skill's pitfalls say.
- General logic only: no keying on layer names, IDs, texts or pixel values. Add the generic fixtures the plan names.
- Always pass `workdir` to terminal calls (stale-cwd pitfall). Never edit the main folder, never bump `BUILD`, never edit the copy's `CLAUDE.md`, never bare `git stash`, never push.
- You can't ask Justin anything. On a real trade-off, make the ruling and write it down as "My ruling, not yet confirmed". If it can't be decided safely, stop with `status: stopped` and list the options.
- If a test outside the plan's files contradicts the approved change, commit what passes and stop naming the exact assertion; never weaken it on your own.
- If you run low on steps, commit what passes and stop with `status: stopped`, `stop_reason: out of steps`, naming the worktree and last commit.
- Anything else you find: don't fix it or fold it in. List it in `found_else` (one line each, with evidence and severity).

## Other features in the same files (stay within this plan's Touches)

- **found-layout** (another chat, reviewing): edits `style.ts` (turnedLength block), `nudge.ts`, `place.ts`, `upright.ts`/`sizing.ts`. You touch `style.ts` only at :172 (shared `cssBreaksWord` import). If both are ready, found-layout merges first and this rebases.
- **found-tiles** Tiles-B (queued) may edit `least.ts keeps()` and `shapes.ts firmAt`: same files, different functions. If it merges first, this rebases.
- Whoever merges second rebases and keeps both HANDOFF sections. Paste check number: **take the next free number on main at merge time**, not a fixed one.

## Finish line

Stop at **`ready-for-review`**: every task committed in the copy, `npm run check` and `npm run corpus` green (corpus no worse than baseline, compared as the skill says), ledger and plan copy in the copy's `docs/plans/`, HANDOFF updated. Not merged.

Output schema: `{name, status: ready-for-review|stopped, build, summary, rulings[], steps_for_justin[], stop_reason, worktree, last_commit, shots[], defect_loop_skills[], found_else[]}`.

## Justin's words

> go

(Earlier, on the main ask:) "I am not talking about the header media take a look at the first photo it is like this on desktop. What I want is on tablet and mobile landscape I want it to be like how it is on desktop the photo media on the right and the text on the left." And on the extras: "Fix them as part of the job". In the desktop app he chose "Keep both extra fixes in this job" and "Keep today's rule: buttons move under the hero".

## Model (Justin, 2026-10-22)
Justin picked **ChatGPT Sol 6.1 xhigh for the whole pipeline** (builder, fresh reviewer, finisher, verifier) because Claude was at 90% of its 5-hour window. Disk: he chose "build anyway; stop safely if space runs low".
