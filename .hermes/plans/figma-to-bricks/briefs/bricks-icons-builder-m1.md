# Role: builder (Full, milestone M1 only — the Figma plugin): bricks-icons — drawn icons become Bricks' Icon element

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`,
`mutation-testing-discipline` (the five Icon rules' guards), the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`,
`references/rendering-validation.md` — its new inline-svg line —, `references/planning-checks.md`,
`reference/bricks/README.md`). Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md`
and `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load any live site;
never write to any WordPress site (the panel's uploader is tested only against the repo's stand-ins); touch nothing under
`~/Downloads`. Figma's sandbox rules hold (CLAUDE.md: only the language's built-ins in `src/core`/`src/plugin`/`src/shared`;
no `import` followed by `(`/`//`/`/*`; no `<!--`/`-->`).

## The plan (approved under Justin's standing auto-go and "go with recommended": Full, Q1–Q8 ⭐ A)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md` (read-only; AC1–AC12; AC7 and AC12
live). **Build M1 only: AC1–AC7** (AC7 live, owed). M2 (AC8–AC12, the importer) waits for site-no-div and
site-shared-styles to merge; a later builder takes it on top of your branch. Copy the plan to
`docs/plans/2026-11-11-bricks-icons.md` in your branch. Planner evidence (prototype, box diffs, Bricks 2.2 source):
`~/.hermes/plans/figma-to-bricks/evidence/bricks-icons/planner/` — a head start, not proof. Build every AC test first (RED
on the base, then GREEN), each named exactly as the plan names it, one picture or terminal capture per AC in
`~/.hermes/plans/figma-to-bricks/evidence/bricks-icons/builder/` (AC4: picture vs Icon at six widths on GRO and hydraulics;
AC5: an Icon recoloured and resized).

## Where
Your own worktree (starts at `origin/main` = `0248176342c6…`, Build 2026-11-11.3): branch `bricks-icons-build`. Shared
with: plugin-parity (planning now: `emit/elements.ts`, `understand/understand.ts`; the second to merge rebases),
shared-palette (the Icon's colour goes through `out.setting()`), the site jobs (`test/browser/render.ts`: keep your renderer
rules in a new `render-icon.ts` and add them only when a paste holds an Icon, so `render.test.ts`'s golden holds).

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) and `npm run corpus` before
Task 1 and at the close (corpus no worse); the five Figma replays: with Icons off byte for byte main's (AC3); the full
`test:web` and `test:browser` file by file at the close under 4G scopes, compared with main by name (known failing on main
here: composition-clipping, fonts, hero-pair, peer-sides, pill-holder). `src/plugin/convert.ts` ≡ replay
(`test/unit/plugin-convert.test.ts`, `sandbox-convert.test.ts`). Ledger in `.superpowers/sdd/2026-11-11-bricks-icons/progress.md`;
HANDOFF section (newest first, `Build <set at merge>`, paste check "id at merge"). Commit after each passing task (plain
`git commit -m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder;
never bare `git stash`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/bib/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). Piped/chained git commands may be refused (script files, `bash <file>`; `git
-C <absolute path>`). Use `tail -n 3`. Waits under 115 s; long drivers with `setsid --fork`, waiting on `^EXIT=`. Many agents
run at once: one Chrome suite at a time, every run under a memory scope; SIGTERM/143/137/"Killed" may be earlyoom: check
`journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first and rerun alone under a cap.

## Report (as text), stop at `ready-for-review`
Branch, head and base; per AC (AC1–AC6): test, RED evidence, GREEN, picture; gates against main by name; the five replays;
`found_else`; `skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal; never edit skills or memory), ending
with: `MAIN SESSION: check and save these skill_lessons now.`
