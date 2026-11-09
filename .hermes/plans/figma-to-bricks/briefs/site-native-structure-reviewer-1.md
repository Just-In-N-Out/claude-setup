# Role: reviewer (Full round 1, report only): site-native-structure

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real site or normal use hits (a captured Elementor page pasted into Bricks 2.3.9 or 2.4.2 by `npm run site --elementor`, looking like the site and
reading as Sections, Buttons and so on in Bricks' Structure panel; the plain route and Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live). Justin's ask (2026-11-09, Bricks' Structure panel showing "Div, Div, Div"): "I want the structure
  to work like the plug-in when we copy it from Figma to Bricks … I don't want it to be all div div div." The job, on the
  `--elementor` route only: every top-level Elementor container is a Section (a boxed one's inner box its Container,
  nested ones Blocks); a part root that draws and lays out nothing is left out (sections become the paste's top
  elements), otherwise it stays one labelled Block; labels (Sections their first words, Blocks their role, kept widgets
  their Elementor type); an Elementor button widget becomes one Bricks Button (text, link, no Style; an svg icon as a CSS
  mask), a divider one Divider, a linked picture one Image with Link to; a holder's padding moves onto a body that paints
  nothing; margins inside a flex/grid widget box add and collapse as the browser does — each only where a rule proves the
  same boxes within 2 px, otherwise the site's elements stay, named. The plain route and Figma designs byte-identical.
  Q1–Q11 A taken.
- Branch `site-native-structure-build2`, head `d83b68c739b0f8e997d334a4578cc92c56b41de3`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach d83b68c7…`, confirm HEAD and a
  clean status. Review `git diff fd1986dc...HEAD`.
- The builders' receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/builder/`
  (the second builder's in `cont/`). Their deviations (ledger, HANDOFF): the Button and Divider shapes come from a
  researched stand-in (Bricks' GPL `button.php`/`divider.php`), not Justin's own copies yet; a `falsified:` control's
  fixture gained a heading margin (the padding move made the old forced fold right); refusals not mutated are listed as
  follow-ups. Facts: live Bricks prints class controls as `.cls.brxe-<element>` (0,2,0); Bricks' own element defaults sit
  in `@layer bricks`, which the paste's unlayered `site-reset` cancels; staging runs Bricks 2.4.2; `reference/bricks/` is
  2.3.9. B-Dry's saved stand-in: 17 of 17 buttons become Buttons, worst row 1.02 px.

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: a real Elementor page pasting wrong in Bricks 2.3.9/2.4.2 once elements are
   Sections, Containers, Buttons, Dividers and Images (Bricks' own unlayered or theme styles moving them, a Theme Style's
   button look applying, a Section's or Container's own width/padding/flex defaults surviving the reset, the editor's
   90px empty-box size), a lifted root losing something its children inherited (fonts, colours, custom properties,
   position context, the sticky header), a Button losing its hover, icon or link, a padding or margin move shifting a
   box, the emitted Button/Divider/Image shape differing from `reference/bricks/` samples, labels wrong or huge, the
   plain route or Figma designs no longer byte-identical, tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sns-r/tmp`, its
  own per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your
  own at a time, closed after. Worktree `node_modules` may lack `.bin`: see testing-pitfalls. Run multi-step commands from
  a script file written with Write.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be earlyoom (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Waits
  under 115 s.

## Report (as text; only review.json is written as a file)
Findings one line each (id, severity, file:line, claim, scenario), `verdict`, `ac_status` (per AC: what the review saw),
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
