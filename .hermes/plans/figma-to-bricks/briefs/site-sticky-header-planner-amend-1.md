# Role: planner (plan amendment 1, wording only): site-sticky-header — AC4 names five rules (review 1, R1-1)

You are a fresh planner (**Fable 5.2, high**). Amend the approved plan; change no source or test, commit nothing, start no
agents; never load any live site. Work under `~/.cache/sha1/`. Load `implementation-planning`; read
`~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` (the plan-amendment paragraph:
Amendments list at the top, `[amended]` marks, `ac-check.sh`'s `ac_start`, `bad_id`, `live` regexes on old and new, ids,
live set and cited test names unchanged, no Amendments-list line starting with an AC id).

## Why
Review 1 (`/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/review-1/review.json`, R1-1, P2): the stay
class's guard `html:root, html:root > body { overflow-x: clip }` stops Bricks' `body.no-scroll{overflow:hidden}` (every
pop-up by default, nav phone menus, an Offcanvas with `noScrollBody`) from reaching the window, so with `no-scroll` on the
body the kept header leaves the window and the page behind scrolls. The fix (Justin's "go with recommended"): the stay class
also carries site-scroll-lock's two lines at the guard's weight — `html:root:has(> body.no-scroll) { overflow-y: hidden }`
and `html:root > body.no-scroll { overflow-y: visible }` (or the exact weights the fixer proves) — so it holds whether or
not site-scroll-lock is on the same paste. A fixer builds it in parallel.

## Amend
- Approved copy (read-only, your base): `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/plan-approved.md`.
- AC4: "exactly the three rules" → the five rules (name them as the class will write them; say exactly, not "includes").
- Where the plan lists the class's rules, the design and the tests: add the two `no-scroll` rules and a check that with
  `no-scroll` on the body after a scroll the bar stays and a real wheel turn doesn't move the page (AC1/AC3's Chrome tests
  gain that step, or a sentence in AC2's; cited test names unchanged).
- Write `/home/justin/.hermes/plans/figma-to-bricks/evidence/site-sticky-header/planner-amend-1/plan-amended.md` with the regex
  receipts beside it (the main session installs it, keeping the old copy as `plan-approved-v1-before-amendment-1.md`).

## Report (as text)
The amended plan's path and sha256; each change in one line; the regex receipts; `skill_lessons[]` (empty is normal),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
