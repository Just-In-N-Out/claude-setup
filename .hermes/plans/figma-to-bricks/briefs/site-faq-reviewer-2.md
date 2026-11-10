# Role: reviewer (Mini, round 2: the fix commits only, report only): site-faq

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
- Branch `site-faq-fix1`, head `a4b74bcb87213a6403e9796b4bda9367c71b7723`, base
  `fd1986dcdbc8cf35f114b80be456e94279346743`. In your own worktree: `git checkout --detach a4b74bcb…`, confirm HEAD and a
  clean status.
- **Scope (Mini round 2): only the fix commits since round 1's head and what they touch:** `git diff 5e6cf9af3507a591aec32cb00f1e1bfbdfc3dcae..HEAD`
  (`b3b716fe` fix + tests, `0a627406` and `02635e48` unit cases, `a4b74bcb` HANDOFF + ledger), plus the code they call
  (`src/core/site/elementor-accordion.ts` `accordionShape`: `showing`, `at`, `Shape.at`, the note).
- Round 1 (`evidence/site-faq/review-2/review.json`) found R1-1 P2: an accordion the site hides at the design width
  (Hide on desktop) read "none open" and lost its open item and look. Fixer 1's rule: the open items are judged where
  the accordion's list itself is shown — the design range when it shows there, else the widest kept range showing it;
  ranges that don't show it say nothing (so R1-2's false note goes too); `Shape.at` names the deciding range in the
  note. Receipts (read, don't trust): `evidence/site-faq/fixer-1/` (its witness: 128 runs, base vs head).
- Check: the rule on real Elementor shapes (hidden on desktop, hidden on tablets only, hidden on phones only, two FAQs
  one per device, an accordion inside a hidden section vs a hidden widget), the design range still deciding when the
  accordion shows there, B-Dry's FAQ unchanged, the tests failing without the fix. Keep probe scripts under
  `~/.cache/sfq-r2/`, never the `/tmp` scratchpad (the PC loses power now and then).

## Work
Load `requesting-code-review` and `code-review-practice`; read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md`,
`references/live-site-reading.md` and `references/rendering-validation.md`, the repo `CLAUDE.md` and
`reference/bricks/README.md`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.
1. Review the scoped diff for real bugs.
2. Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/review-2/review.json`, then self-check:
   `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <your worktree> --base
   fd1986dcdbc8cf35f114b80be456e94279346743 /home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq`
   (exit 2 means your file is wrong: fix it).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfq-r2/tmp`, its
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
