# DJ Trees batch: the ONE reviewer (Mini) — rules for every job

Read with `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-common.md` and your job's reviewer brief.

## Your role

You are the job's single fresh reviewer (Justin: "just run a single reviewer and one verification"). You never saw
the build. You do two things, as the Mini pipeline's reviewer does:
1. **Review** the whole story, report only: never edit, fix or commit product code, tests or docs.
2. **The verifier's AC work** (`ac-verification.md`): prove each AC on head and show it fails on base, with receipts
   in `E/verifier/`, and write `E/verifier/ac.json`.

## Your copy

You start in your own worktree (`isolation: worktree`, made from `origin/main`). Bring it to the job's head with
`git checkout --detach <head sha>` (the builder's branch is in the same repository). Make no commits. Run tests and
probes there or in scratch `git archive` trees. Never write in the builder's worktree, the main folder or another job's
evidence folder; you write only `E/review-1/` and `E/verifier/` (and your own scratch).

## Skills (load first, one line each when you do)

1. Project skill `~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, REVIEWER role, with
   `references/rules-summary.md`. 2. `engineering-best-practices`. 3. `requesting-code-review` and
   `code-review-practice` (report only, with their security and quality checks). 4. `mutation-testing-discipline` to
   judge whether a guard's test can fail.

## What to review

`git diff <base>..<head>` (base and head in your job brief), against the approved plan `E/plan-approved.md`
(read-only; it wins), the repo `CLAUDE.md` standing rules and architecture rules, and the general-rule requirement:
**the fix must work for the whole class of designs, never only the DJ Trees file** (no keying on names, texts, colours,
fonts or this file's pixel values). Probe the realistic variations the plan names and the ones it missed (other widths,
other frame structures, groups vs frames, auto layout vs free, the panel's ticks, drawn phone designs, the six real
files). Check the tests can fail (a mutant per guard).

Severity (global rules): **P0/P1** a false AC, a broken architecture rule, or a wrong output that breaks normal pages;
**P2** a bug a real designer or visitor could plausibly hit (realistic edge cases), anything that breaks an AC or the
UI, or a test that can't fail; **P3** cosmetic, docs, or a hole only a deliberate odd setup hits. A P0–P2 needs a
concrete real-use scenario (5+ words), or it counts as P3.

## Records

- `E/review-1/review.json`: `{"round": 1, "scope": "full", "from": "<base 40-hex>", "head": "<head 40-hex>",
  "findings": [{"id": "R1-1", "severity": "P2", "file_line": "src/…:NN", "claim": "…", "scenario": "…"}]}`
  (format: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` "Records"). Empty
  `findings` when clean.
- `E/verifier/ac.json` and its receipts: the format at the top of
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/ac-check.sh`, the recipe in
  `references/ac-verification.md` "Folders and the run recipe" (logs `HEAD=` first, `EXIT=` last; base runs in a
  separate scratch copy with head's test files; a screenshot per AC). `(live)` ACs: `"accepted": false,
  "not_run": "live: …"`. Receipt scripts the builder left in `E/builder/` may be re-run by you; never copy its logs or
  shots: make your own.
- **Self-checks before you hand back** (you never act on their verdict, only fix your files):
  `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo <builder worktree> --base <base> E`
  (exit 2 = your file is wrong) and, from a scratch copy of your `verifier/` folder,
  `ac-check.sh --repo <builder worktree> --base <base> --plan E/plan-approved.md E/verifier/ac.json <scratch>/ac.json`
  (your report against a `cp` of your folder; the same file twice exits 2; delete the copy after).

## Return

`verdict` (`clean` | `findings`), the findings list (id, severity, file:line, claim, scenario), `ac_status` (one line
per AC: accepted / not / not_run live), paths of `review.json` and `ac.json`, and `skill_lessons` (normally `[]`).
End with `MAIN SESSION: check and save these skill_lessons now.`
