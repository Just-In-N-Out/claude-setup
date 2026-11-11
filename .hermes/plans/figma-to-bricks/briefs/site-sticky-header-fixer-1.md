# Role: fixer (Mini fix round 1): site-sticky-header — the kept header holds while Bricks freezes the page (R1-1)

You are a fresh fixer (**Opus 5.5, high**). Load `receiving-code-review` (verify the finding first), `engineering-best-practices`,
`test-driven-development`, `mutation-testing-discipline`, the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` (with `references/testing-pitfalls.md` — the
wheel line — and `references/live-site-reading.md` "Code-route paste traps": the `no-scroll` and `.N.N` lines). Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first. Never load any live site; never
write to any WordPress site; touch nothing under `~/Downloads`. Commit to the branch only; don't push; don't bump BUILD;
don't edit the main folder or CLAUDE.md; never bare `git stash`.

## Finding (review 1: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/review-1/review.json`)
**R1-1, P2, `src/core/site/stay.ts:27`:** the guard `html:root { overflow-x: clip }` stops Bricks' `body.no-scroll{overflow:
hidden}` from reaching the window: with `no-scroll` on the body after a 600 px scroll, the bar's top goes 0 → −600 and a real
wheel turn scrolls the page 600 → 900 (base: stays 600). Bricks adds `no-scroll` for every pop-up by default, nav phone
menus, and an Offcanvas the importer writes with `noScrollBody` (`src/core/site/opens.ts:102`). Probes:
`review-1/probes/wheel.log`, `probe.log`. site-scroll-lock's class (`html:has(> body.no-scroll){overflow-y:hidden}` +
`body.no-scroll{overflow-y:visible}`) closes it on a merged paste.

## Do
1. Branch `site-sticky-header-build` (head `ad041d3d8a73b34eaa2f3de2ab941013f0238e1b`): continue it in your own worktree
   (`git checkout -B site-sticky-header-fix1 ad041d3d…`).
2. RED first: extend the Chrome tests (AC1 in page, AC3 Header template; AC2 with the Additional CSS rule) with a step: after
   the 600 px scroll add `no-scroll` to the body and turn a real wheel (`Input.dispatchMouseEvent` `mouseWheel`, raced with a
   timer; never `scrollTo`): the bar stays at 0 and the page stays at 600, at 1440 and 390, Bricks 2.3.9 and 2.4.2. Cited
   test names unchanged.
3. GREEN: the stay class also writes the two `no-scroll` rules at the guard's weight (e.g. `html:root:has(> body.no-scroll)
   { overflow-y: hidden }`, `html:root > body.no-scroll { overflow-y: visible }`); prove they still win with site-scroll-lock's
   class and with `html, body { overflow-x: hidden }` in Additional CSS. Tighten AC4's unit test to **exactly** the five rules
   (R1-4: no `includes()`). A planner is amending AC4's wording to five rules at the same time
   (`evidence/site-sticky-header/planner-amend-1/`); match it.
4. R1-5 if cheap: `tools/site-sticky-header-sums.ts` proves "nothing else changed" against a sums file it hasn't rewritten.
5. Mutants: drop each new rule → the wheel step fails. Regenerate the code-page sums only by the helper with its per-variant
   proof (the class's CSS changed).
6. `npm run check` (8G scope) exit 0; the job's Chrome files and `site-cli`, `site-check-cli` under 4G scopes. Stop at
   `ready-for-next-review` with the head SHA.

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/shf/t1`);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). Piped/chained git commands may be refused (script files, `bash <file>`; `git -C
<absolute path>`). Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. Many agents run
at once: a timeout under load reruns alone. SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom --since
"-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text)
Branch, head; R1-1 verified, RED, GREEN; the five rules; mutants; gates; `skill_lessons[{skill, lesson, evidence, enforce}]`
(empty is normal; never edit skills or memory), ending with: `MAIN SESSION: check and save these skill_lessons now.`
