# BLIND AC AUDITOR (read only): site-faq (a pasted Elementor / ElementsKit FAQ opens what the site opens, and its open look follows the open item)

You are a fresh auditor (Fable 5.2, high). Independently prove the approved acceptance criteria. You have never seen a
builder, reviewer, fixer or verifier report. Stay blind: never open anything under
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/` except `plan-approved.md` and your own `auditor/` folder
(never `builder/`, `fixer-*`, `review-*`, `verifier*`, `planner/`, `follow-ups.md`); nor HANDOFF, ledgers or session
notes. Source and tests are read-only; commit nothing; start no agents.
**Justin (2026-11-02): "focus on building and not too much of edge cases."** An AC fails when its own text is broken (its
named test, or a realistic case its words cover); an edge case beyond its text goes in `found_else`.
**Never load bdryswi.com, B-Dry staging** or any live site (local fixture servers and saved files only); no logins; never
write to any WordPress site. Nothing may hide that the importer's Chrome is automated.

## The only inputs
- Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/plan-approved.md` (AC1–AC8; AC8 is
  `(live)`, owed to Justin: mark it `not_run`). Use each exact test name the plan gives: find them all first with
  ac-check's own grep (`command grep -E "(^|[^A-Za-z0-9_])<name>([^A-Za-z0-9_]|$)" <plan>`). Where the plan wraps a
  name over two lines, or the runner prints a prefix the plan lacks, never edit the plan: cite a phrase that sits whole
  on one plan line and run the test by its full printed name through a by-name checker, as `ac-verification.md` says.
- Head `a4b74bcb87213a6403e9796b4bda9367c71b7723` (branch `site-faq-fix1`), base
  `fd1986dcdbc8cf35f114b80be456e94279346743` (`main`, Build 2026-11-09.3), your own folder
  `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-faq/auditor/` (empty).
- AC7 is named-only on Justin's saved capture `/home/justin/f2b-test/bdryswi-com-home.f2b-capture.json` (read only; read
  the test for its variables; run it under an 8G `systemd-run` scope). Say it is a saved capture, not the live site.

## Your copy
In your own worktree: `git checkout --detach a4b74bcb87213a6403e9796b4bda9367c71b7723`, confirm `git rev-parse HEAD` and a
clean `git status --porcelain --untracked-files=all` (after a machine restart, look for tracked files of exactly 8388608
bytes and restore them with `git checkout --`). Your `ac.json` names this head and base. Never write in any other
worktree or the main folder.

## Work
Load `engineering-best-practices`; read the project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`
with `references/testing-pitfalls.md`, `references/live-site-reading.md` and `references/rendering-validation.md`;
`reference/bricks/README.md` and the accordion sample under `reference/bricks/`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` and the report format at the top
of its `scripts/ac-check.sh`; follow the blind auditor procedure there. For every runnable AC make your own head and
base runs (an AC log starts with the bare `HEAD=<sha>` and ends `EXIT=`; the named assertion must run, pass on head and
fail on base for new behaviour; a setup failure is not RED; preservation that rightly passes on base is `base_exempt`
with a specific reason, backed by your own byte-identity probe). Also:
- Your own mutation proof for the rule's guards (which answers open at load is read at the design width only; several
  open answers; the open look keyed on Bricks' open item; its weight against Bricks' class controls).
- AC4, AC5, AC7 in Chrome with Bricks' own accordion script through the repo's renderer: your own picture of the paste
  at load and after a click on another question, at each width the AC names, head and base.
- AC6: your own byte receipt, base against head (fixture captures on both routes and both picture modes; the five
  Figma replays of the repo's real files).
- A screenshot per AC (a terminal image for a non-visual AC).
- Run `git log -p fd1986dc..HEAD -- <each AC's test files>` and read every changed assertion against the plan.
Write `auditor/ac.json`, then self-check by copying your report and receipts to a fresh scratch folder and running
`ac-check.sh` on them (no `--reviews`).

## Machine
- WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` at most 38 characters (`~/.cache/sfq-a/tmp`,
  one per concurrent Chrome job); `CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Other agents run
  Chrome too: close every Chrome you start (kill by its profile path if Node dies). A browser or web run counts only
  with `skipped 0` for the AC's tests. The worktree's `node_modules` may lack `.bin`: see testing-pitfalls. Run
  multi-step commands from a script file written with Write, paths spelled out; keep scripts and logs under
  `~/.cache/sfq-a/` and copy them to `auditor/scripts` (a restart empties `/tmp`). Never edit a script a background run
  is executing.
- Runaway memory: SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill (`journalctl -u earlyoom --since "-30 min"
  -o short-iso | grep sending`); heavy and mutation runs under `systemd-run --user --scope -p MemoryMax=4G -p
  MemorySwapMax=0 <cmd>` (B-Dry renders 8G; one `bash <file>` per Bash call).
- Bash moves foreground commands to the background after about 120–180 s: keep wait loops under 115 s.
- For base runs: `git archive -o <scratch>/base.tar <base>` then `tar -xf` in separate calls into a fresh folder named
  for your role, and copy head's test files plus the test-only modules and fixtures they import into it.
- Put any summary in your report, not a file.

## Report
`{verdict: clean|findings, head, base, findings[{id,severity,claim,evidence}], ac_status[{ac,accepted,test,screenshot,
evidence}], gates, found_else[], skill_lessons[{skill,lesson,evidence,enforce}]}`. Clean needs every runnable AC accepted.
Empty skill_lessons is normal; never edit skills or memory (`enforce` is `none` or a one-line check proposal). End with
`MAIN SESSION: check and save these skill_lessons now.`
