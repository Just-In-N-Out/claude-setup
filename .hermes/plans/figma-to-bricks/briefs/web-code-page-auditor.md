# BLIND AC AUDITOR (read only): web-code-page (a captured site's whole page pasted by the code method)

You are a fresh auditor (Opus 5.5, xhigh). Independently prove the approved acceptance criteria. You have never seen a
builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/` except `plan-approved.md`, `justin-q4-slider.md`
(Justin's later slider ruling), and your own `auditor/` folder; nor HANDOFF, ledgers or session notes. Source and tests are read-only; commit
nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/plan-approved.md` (AC1–AC20 with Amendments 1–4;
  AC12 and AC19 are `(live)`, owed to Justin: mark them `not_run`). Use each exact test name the plan gives (a name the plan wraps
  across lines, or one built at run time, goes through a by-name checker; find them all first with ac-check's own grep).
- Head `4ba9a1782e0d36f1efd6e2322dd23df1a90274bd` (branch `web-code-page-build`), base
  `ea5047788df61fb4338cec4fcd47574bff216032`, your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-page/auditor/` (empty).
- Named-only inputs (read-only): AC9/AC17/AC18 as the plan's Task for AC9 says (`F2B_CODE_PROOF_BDRY=$HOME/.hermes/plans/figma-to-bricks/evidence/web-code-proof/inputs/bdry-2026-10-29`;
  a fresh stand-in capture takes about 33 min), AC10 `F2B_CODE_PAGE_CAPTURE=/home/justin/Downloads/bdryswi-com-home.f2b-capture.json`
  (Justin's 11-04 capture). Read each test for its exact variables.
- **What to prove, not assume:** any Figma design converts byte for byte as before; a captured page's header, page and
  footer paste by its own elements, classes and CSS within 2 px at every width; alt text and page-builder markers kept; bold
  and italic look as on the site; every class but `site-reset-<4>`, `site-fonts`, `site-text`, `site-flat` starts with the
  page's name.

## Your copy
In your own worktree: `git checkout --detach 4ba9a1782e0d36f1efd6e2322dd23df1a90274bd`, confirm `git rev-parse HEAD` and a
clean `git status --porcelain --untracked-files=all`. Your `ac.json` names this head and base. Never write in any other
worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md` and `references/live-site-reading.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top of
its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and base runs
(log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on head and fail on base for new behaviour; a setup
failure is not RED: use a hybrid tree to reach the assertion; preservation that rightly passes on base is `base_exempt`
with a specific reason, backed by a byte-identity probe), your own mutation proof for the guards (AC2, AC4, AC11, AC13, AC14, AC20), and
a screenshot per AC (site | paste shots for AC7, AC9 and AC20, a terminal image for a non-visual AC). Run `git log -p
ea504778..HEAD -- <each AC's test files>` and read every changed assertion against the plan. Write `auditor/ac.json`, then
self-check by copying your report and receipts to a fresh scratch folder and running `ac-check.sh` on them (no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/wcp-a/tmp`);
  `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. One Chrome job of your own at a time, closed after each
  step. A browser or web run counts only with `skipped 0`. The worktree's `node_modules` may lack `.bin`: see
  testing-pitfalls. Never edit a script a background run is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0
  <cmd>`.
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls, and copy head's test files
  plus the test-only modules they import into it.
- Never load bdryswi.com; no logins; never write to any WordPress site. Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC accepted.
Empty skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with
`MAIN SESSION: check and save these skill_lessons now.`
