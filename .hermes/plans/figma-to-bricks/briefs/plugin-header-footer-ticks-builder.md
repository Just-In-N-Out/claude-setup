# Role: builder (Mini): plugin-header-footer-ticks — the panel's boxes say what they do, and the line under them says what the next paste does

You are the builder (**Opus 5.5, xhigh**). Load `engineering-best-practices`, `test-driven-development`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md`). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load any live site; never
write to any WordPress site; touch nothing under `~/Downloads`. Figma's sandbox rules hold (CLAUDE.md: built-ins only in
`src/core`/`src/plugin`/`src/shared`; no `import` followed by `(`/`//`/`/*`; no `<!--`/`-->`).

## The plan (approved under Justin's standing auto-go; he is asleep: Q1 A, Q2 taken as empty, Q3 A)
`/home/justin/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/plan-approved.md` (read-only; AC1–AC6; AC6 live).
Copy it to `docs/plans/2026-11-11-plugin-header-footer-ticks.md`. The planner's prototype and test files:
`~/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/planner/` (`prototype.diff`, `tests/`, `ticks-matrix.ts`) — a head
start, not proof. Task 1 is the plan's gate (a debug file from Justin → run `ticks-matrix.ts`; stop `escalate` if its saved ticks are
both on and a part is still kept); no debug file has arrived. Build every AC test first (RED on the base, then GREEN), each named
exactly as the plan names it; update the six existing tests that pin the old words (and `test/browser/panel.test.ts:218`) by design,
named in the ledger; one picture per AC in `~/.hermes/plans/figma-to-bricks/evidence/plugin-header-footer-ticks/builder/` (the panel's
boxes and line at the four states, drawn).

Mini pipeline: the plan names nine `src/` files, most one-line wording; the "more than ~3 files" escalation doesn't apply to those.
Stop `escalate to full` only for a change beyond the plan.

## Where
Your own worktree (starts at `origin/main` = `e61c0ca0`, Build 2026-11-11.6): branch `plugin-header-footer-ticks-build`. bricks-icons
M1 (building: `emit/elements.ts`, `understand/understand.ts`) and plugin-parity (planned) share only test files that quote a
header/footer note.

## Rules
`npm run check` (8G scope: `systemd-run --user --scope -p MemoryMax=8G -p MemorySwapMax=0`) and `npm run corpus` before Task 1 and
at the close (corpus on this desktop: repoint to the repo's files or compare replays of `corpus/files/*` base vs head byte for
byte); `test:browser` file by file at the close under 4G scopes, compared with main by name (known failing on main here:
composition-clipping, fonts, hero-pair, peer-sides, pill-holder); `src/plugin/convert.ts` ≡ replay; AC5's named-only pin with
`F2B_BASE_TREE` = a `git archive` of the base. Ledger in `.superpowers/sdd/2026-11-11-plugin-header-footer-ticks/progress.md`;
HANDOFF section (newest first, `Build <set at merge>`, paste check `<id at merge>`). Commit after each passing task (plain `git commit
-m`, no author override, no AI lines, never CLAUDE.md); don't push; don't bump BUILD; don't edit the main folder; never bare `git stash`.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/phb/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`). Write scripts with the Write tool, run as plain `bash <file>`; `git -C <absolute path>`. Use `tail -n 3`.
Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl
-u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text), stop at `ready-for-review`
Branch, head and base; Task 1's gate; per AC: test, RED, GREEN, picture; the old-word tests changed; gates by name; `found_else`;
`skill_lessons[{skill, lesson, evidence, enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`
