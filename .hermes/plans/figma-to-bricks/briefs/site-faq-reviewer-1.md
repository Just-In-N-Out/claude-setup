# Role: reviewer (Mini, round 1, the one full review, report only): site-faq

You are a fresh reviewer who never saw the build (Fable 5.2, high). Review only: change no source or test, commit
nothing, start no agents. Never edit the main folder `/home/justin/Documents/FigmaToBricksV2` or other worktrees (read
them with `git show`). Never load bdryswi.com or any live site; never write to any WordPress site; no logins.

**Importer rule (Justin, 2026-11-02: "focus on building and not too much of edge cases"):** report as P0–P2 only bugs a real site or normal use hits (a captured Elementor page with a FAQ pasted into Bricks 2.3.9 or 2.4.2 by `npm run site --elementor`, opening and
closing like the site; Figma designs converting as before), each with a concrete real-use scenario. Edge
cases are P3 (follow-ups). A P0–P2 with no concrete real-use scenario is a P3.

## Inputs
- Approved plan (read-only): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/plan-approved.md`
  (AC1–AC8; AC8 live). The job: on the `--elementor` route an Elementor/ElementsKit FAQ pasted as Bricks' Accordion
  (Nestable) opens the item(s) the site shows open at the design width's range (`expandItem`, several as "0,2"), even
  when narrower ranges show other answers (B-Dry's styleless 768–991 read showed all five), and the open look moves
  onto Bricks' open state (`.acc > .brx-open.<item classes>`, three classes or more so it beats Bricks' printed
  `.cls.brxe-block` controls); captures whose widths agree convert byte-identically. Q1–Q5 A taken.
- Branch `site-faq-build2`, head `5e6cf9af3507a591aec32cb00f1e1bfbdfc3dcae`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach 5e6cf9af…`, confirm HEAD and a
  clean status. Review `git diff fd1986dc...HEAD`.
- The builders' receipts (read, don't trust): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/builder/`
  (the second builder's in `cont/`). Their deviations (ledger, HANDOFF): `Shape.open` is a list and `several` is gone;
  Bricks' "Expand item indexes" comma list comes from Bricks' own code, not yet round-tripped; pastes with an item-level
  look change bytes (listed by the witness). Staging runs Bricks 2.4.2 (its accordion script is byte-identical to
  2.3.9's). `found_else`: at 1440 the renderer draws B-Dry's fifth question's second line over its first on base and
  head alike (say if it is a real bug of this job or of the font stand-in).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the whole diff for real bugs: a real Elementor FAQ pasting with the wrong item open, none open, or the open
   look stuck or missing in Bricks 2.3.9/2.4.2 (front end and editor), a click not moving the look, the look beaten by
   Bricks' controls or leaking onto other accordions, an accordion with no item open on the site, toggles (several may
   open) vs accordions, nested accordions, a FAQ whose widths agree changing bytes, Figma designs no longer
   byte-identical, tests that can't fail.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/review-1/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfq-r/tmp`, its
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
