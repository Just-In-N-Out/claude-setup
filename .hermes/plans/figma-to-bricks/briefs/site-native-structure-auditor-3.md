# Role: blind AC auditor (read-only): site-native-structure on its final head (auditor 3)

You are a fresh AC auditor (**Opus 5.5, xhigh**). You get only the approved plan, the worktree, the head, the base and your own
folder. **Never read the verifier's report or folder** (`evidence/site-native-structure/verifier/`, `verifier-1-d83b68c7/`, `verifier-f86ab19/`, `auditor-f86ab19/`), the
reviewers', builders', fixers' or planners' reports as proof. Change no source or test, commit nothing, start no agents. Never load
bdryswi.com, B-Dry staging or any live site; never write to any WordPress site; touch nothing under `~/Downloads`. Nothing may hide
that the importer's Chrome is automated.

**Skills:** read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the auditor's job and the
`ac.json` format at the top of `scripts/ac-check.sh`) and follow it; the project skill
`/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` with `references/testing-pitfalls.md` (flakes under load,
stack-move lines), `references/live-site-reading.md`, `references/rendering-validation.md`; `reference/bricks/README.md`. Read
`/home/justin/.hermes/skills/software-development/figma-to-bricks/references/repeat-mistakes.md` and
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/repeat-mistakes.md` first.

## Inputs
- Approved plan (read-only, amendment 3 v2: AC2 keeps the header root only where two pasted top Sections show at one width; AC15 B-Dry step): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/plan-approved.md`
  (AC1–AC15; AC15 live: `not_run`). The job: the website importer's `--elementor` paste becomes Bricks' Section / Container / Block,
  Heading, Button, Divider and linked Image; a part's root that draws nothing is left out ("lifted"); the plain route byte for byte.
  Named-only tests run by name with their variables (AC13 `F2B_PIN_BASE=1`; AC14 `F2B_CODE_PROOF_BDRY`, `F2B_CODE_PROOF_CAPTURE`,
  `F2B_ELEMENTOR_STANDIN` = `evidence/site-native-structure/inputs/standin-capture-b2435de.json`, sha256 `462f292d…0f6d` — read the
  plan for the others), each printing its own `ok` line, never `# SKIP`.
- Head **`d6f169848744d4f23f8dd2a8b2b6787dae1872f7`** (branch `site-native-structure-final2`), base **`4f8b61165d98002e64f97aa2e4330f6cf9801c1d`** (main, Build 2026-11-11.10).
  In your own worktree: `git checkout --detach d6f16984…`, clean status. Old code: a `git archive` of `4f8b6116` with head's test
  files, fixtures and test-only modules copied in (weak RED where a new module doesn't import: prove with a one-line mutant).

## Work
Prove every AC yourself: its cited test on head (pass) and on old code, plus one check of your own per AC beyond the cited test
(e.g. AC6/AC10: an Elementor page of your own — not "Harbour Roofing" — with a button row, a centred lone button, a full-width
button, a linked logo and a linked image in a grid cell, pasted with `--elementor` and drawn as Bricks 2.4.2 and 2.3.9 at 1440 and
390: which stand alone, which stay boxed with a note, all within 2 px; AC5: a lifted part's sections at the top in the Structure
tree; AC13: count yourself that every plain-route paste equals the base's). A picture per AC. Write
`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-native-structure/auditor/ac.json` and logs there (it's empty now);
self-check with `ac-check.sh` on a copy (`--base 4f8b61165d98002e64f97aa2e4330f6cf9801c1d`).

## Machine
WSL: Node `/home/justin/.local/node-v22.23.3/bin` first on PATH; `TMPDIR` about 24 characters (`~/.cache/sna/t1`, …);
`CHROME_PATH=/home/justin/.cache/chrome-for-testing/chrome-f2b`. Close every Chrome **you** start (`pgrep -f
'[u]ser-data-dir=<path>'`; never `pkill -f`). Write scripts with the Write tool, run as plain `bash <file>`; plain `git` in your own worktree, each command alone (never `git -C` the main folder); one Chrome suite at a time.
Use `tail -n 3`. Waits under 115 s; long runs with `setsid --fork`, waiting on `^EXIT=`. Every Chrome run under `systemd-run --user
--scope -p MemoryMax=4G -p MemorySwapMax=0` (B-Dry 8G). SIGTERM/143/137/"Killed" may be earlyoom: check `journalctl -u earlyoom
--since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` first.

## Report (as text; only ac.json and logs are written)
Per AC: test, head, old code (or mutant), your own check, evidence; `verdict`; `ac_status`; `skill_lessons[{skill, lesson, evidence,
enforce}]` (empty is normal), ending with: `MAIN SESSION: check and save these skill_lessons now.`

**Also own-check AC2's kept-header rule:** an Elementor page of your own with two header bars shown together (expect one "Header" Block
with the stay class) and one with a desktop bar and a phone bar never shown together (expect two lifted top Sections, each with the stay
class, no root note); after a 600 px scroll the shown bar stays at the top in Bricks 2.4.2 and 2.3.9 at 1440 and 390.
