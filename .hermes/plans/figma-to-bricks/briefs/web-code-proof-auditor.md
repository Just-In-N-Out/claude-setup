# BLIND AC AUDITOR (read only): web-code-proof (the site's own HTML + CSS → Bricks, one-section proof)

Independently prove the approved acceptance criteria. You have never seen a builder, reviewer, fixer or verifier report.
Stay blind: never open anything under `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/` except
`plan-approved.md` and your own `auditor/` folder, nor HANDOFF, ledgers or session notes. Source and tests are
read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken
(its named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/plan-approved.md` (AC1–AC10; AC9 is
  `(live)`, owed to Justin: mark it `not_run`). Use each exact test name the plan gives (a name the plan wraps across
  lines, or one built at run time, goes through a by-name checker).
- Head `3316940a78c2cad66b9fa660a01dadce9678594d`, base `31321bb48bebdc217d24e9fb65bf734b4fd65e2a`, your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/web-code-proof/auditor/` (new).
- **What to prove, not assume:** the paste matches the site within 2 px at every width (AC5 generic fixture, AC6 the saved
  bdryswi.com section served locally: inputs in `evidence/web-code-proof/planner/inputs/`, never load bdryswi.com), the
  checks can fail, and Figma designs convert byte for byte as on base. You may use the Opus high effort's time for AC6's
  long run (about 35 minutes, under a 4 GB cap).

## Your copy
In your own worktree: `git checkout --detach 3316940a78c2cad66b9fa660a01dadce9678594d`, confirm `git rev-parse HEAD` and a
clean `git status --porcelain --untracked-files=all`. Your `ac.json` names this head and base. Never write in any other
worktree.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md` and `references/live-site-reading.md`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top of
its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and base
runs (log `HEAD=` first and `EXIT=` last; the named assertion must run, pass on head and fail on base for changed
behaviour; a setup failure is not RED: use a hybrid tree to reach the assertion; preservation that correctly passes on
base is `base_exempt` with a specific reason), your own mutation proof that the 1:1 checks (AC5/AC6) and the isolation test (AC10) can fail (e.g. empty the reset class, drop a media block, import a Figma stage), plus one of your own on AC1–AC4,
and a screenshot (real side-by-side render shots for AC5/AC6, a terminal image for a non-visual AC). Write `auditor/ac.json`, then self-check by copying your report and
receipts to a fresh scratch folder and running `ac-check.sh` on them (no `--reviews`).

## Machine
- This machine (WSL): Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters
  (`~/.cache/wcp-a/tmp`); Chrome found by itself or `CHROME_PATH` =
  `~/.hermes/plans/figma-to-bricks/evidence/web-capture/planner/scripts/chrome-cpu.sh`. One Chrome job of your own at a
  time, closed after each step. A browser or web run counts only with `skipped 0`. The worktree's `node_modules` may lack
  `.bin`: see testing-pitfalls.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min" -o
  short-iso | grep sending`); rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.
- Worktree guard: write multi-step scripts with Write and run `bash <file>`; git commands as separate plain calls; no
  redirects or the bare word `source` in a command. For base runs, `git archive -o <scratch>/base.tar <base>` then
  `tar -xf` in separate calls, and copy head's test files plus the test-only modules they import into it.
- Never load bdryswi.com; live reads (GET only) only of `https://darksalmon-badger-335429.hostingersite.com/`
  (`?f2b=<random>`) and `https://www.letsgro.ai/`; never write to any WordPress site; never call alttext.ai. Put any
  summary in your report, not a separate summary file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC
accepted. Empty skill_lessons is normal; never edit skills or memory. End with
`MAIN SESSION: check and save these skill_lessons now.`
