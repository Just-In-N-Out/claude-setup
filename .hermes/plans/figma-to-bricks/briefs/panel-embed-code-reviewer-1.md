# Role: reviewer (Full round 1, the whole story; report only): panel-embed-code

You are a fresh reviewer who never saw the build (**Opus 5.5, high**). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com, B-Dry staging, an embed host or any live site (local fixture servers and
saved files only); never write to any WordPress site; no logins. Nothing may hide that the importer's Chrome is
automated.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"; one real-bug review per job):**
report as P0–P2 only bugs a real site or normal use hits (a capture of a real site converted in the Figma panel's
website route, or with `npm run site`, and pasted into Bricks 2.3.9 / 2.4; Figma designs converting as before), each
with a concrete real-use scenario. Edge cases are P3. **What a paste may run on the user's site is this job's guard:
any path by which a pasted Code element still carries code that is not the widget's own (a tracking tag, another
widget's script, a page script) is P0/P1.**

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/plan-approved.md`
  (AC1–AC11; AC11 live). Justin said "Panel widget code go" on 2026-11-10: the ⭐ answers Q1 A – Q5 A are taken. The
  job: on the panel's website route each third-party widget became a Code element holding a collected "snippet" that
  can carry the widget host's tracking tags from elsewhere in the page; now, on both routes, a pasted Code element runs
  only the widget's own code (the slot's own served markup; a served frame's own markup; a frame a script made, as it
  showed; a floating widget's own file's tags, kept apart in the capture's new `own` field); where a capture can't tell
  the widget's own code apart the widget becomes an empty box of its size (a floating one: listed, not pasted), with a
  note; an older capture pastes nothing collected ("capture the page again with this build").
- Branch `panel-embed-code-build`, head `4d6c64031762e6ae7a1166f25d405db184457805` (code head `1cfde472`; the last
  commit is the ledger), base `f708dfb659049db50bb45df8026faabee2ee0ad7` (`main` has since moved to `2879e496`, Build
  2026-11-10.3: a later step moves the job). In your own worktree: `git checkout --detach
  4d6c64031762e6ae7a1166f25d405db184457805`, confirm HEAD and a clean status. Review `git diff f708dfb6...HEAD`.
- The builder's receipts (read, don't trust): `evidence/panel-embed-code/builder/` (`logs/gates/`, `logs/mutants/summary.json`,
  `shots/`); the planner's probe and prototype: `evidence/panel-embed-code/planner/`. The builder's words: the shared
  rule is `src/core/snapshot/embed-code.ts`; consumers `src/core/normalise/embeds.ts`, `normalise/floating.ts`,
  `src/core/site/live.ts`; the capture side `src/web/map/snippets.ts` / `src/web/read/floating.ts` / `src/web/assemble.ts`
  records `own`; new fixture site `embeds-tracked`; tests `test/unit/embed-code.test.ts`,
  `test/unit/panel-embed-code.test.ts`, `test/web/panel-embed-code.test.ts`. Its deviations: a widget with no `how`, in
  a capture that has a code reading but no single shown frame at its slot, is "unproven" ("add it by hand"), not
  "older" ("capture again") — it followed AC1's text over the prototype's test; at Task 3's commit two older tests are
  red until Task 5 (consumer before producer); one equivalent mutant (M3f).
- Check hardest (probe with your own pages, outside the repo's fixtures; local servers only; count what the fixture
  servers received when the paste is drawn):
  - **nothing but a widget's own code in any pasted Code element, on both routes, every embed kind, both picture
    modes, every part (header, page, footer):** your own page with the widget host's tracking in `<head>`, beside each
    slot and at the end of `<body>`; an inline script that both configures the widget and calls the tracker; two
    widgets of one host; a widget and a tracker sharing one script file; a served iframe; a frame a script made; a
    floating chat bubble made by a file that also loads a tracker; a floating box only guessed from its host; `<?`
    code; a widget whose own file is loaded twice. For each: what is pasted to run, what is an empty box or listed, and
    the note's words — true and useful to Justin?
  - **widgets that worked on main still work** (web-embeds' badge, gallery, booking frame, map, reviews frame; the
    code route's live widget): or are now an empty box — which real, common widget shapes lose their live code under
    Q1 A, and is the note enough for Justin to add them by hand (rate by the importer rule: an empty box where main
    pasted a working widget is a real change for him; say how common);
  - **older captures:** Justin's saved 2026-11-09 capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json`
    and the 2026-11-04 ones under `~/.hermes/plans/figma-to-bricks/evidence/` converted by the panel route (`convert()`
    directly; the CLI refuses the 11-09 one): what each widget becomes (Trustindex reviews, the map, reCAPTCHA, the
    call button), base against head;
  - the capture's new `own` field: recorded from the served tags of the very file that made the box, never widened;
    the snippet itself unchanged (older tools still read it);
  - the code route byte for byte as base (`npm run site` on the widget fixtures and on captures without widgets);
    Figma designs byte for byte (`test/unit/plugin-convert.test.ts`, the five replays); the plugin sandbox
    (`tsconfig.sandbox.json`; `src/core` uses only the language's built-ins);
  - the tests can fail (read the mutant receipts; try one or two of your own under the 4 GB cap); the "unchanged sums"
    test recorded at Task 0 is honest;
  - the builder's AC1 deviation ("unproven" against "older"): which side is right for Justin, and does any plan line
    now read false (a P3 naming what the plan must say).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` (the embeds lines) and `references/rendering-validation.md`, the repo `CLAUDE.md`
("Architecture rules"; "Code Figma runs uses only the language's built-ins"; "Website captures") and
`reference/bricks/README.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole story for real bugs (probes on base and head).
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   f708dfb659049db50bb45df8026faabee2ee0ad7 /home/justin/.hermes/plans/figma-to-bricks/evidence/panel-embed-code` (exit
   2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/pec-r1/t1`,
  a separate one for each script you start at the same time); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`.
  One Chrome job of your own at a time, closed after. A worktree's `node_modules` may lack `.bin`, and a `git archive`
  scratch tree has neither `tsc` nor `node_modules` (put `/home/justin/Documents/FigmaToBricksV2/node_modules/.bin` on
  PATH and symlink the main folder's `node_modules` in). Scripts written with Write; probes and logs under
  `~/.cache/pec-r1/` (a restart empties `/tmp`).
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (B-Dry
  8G). Waits under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
