# Role: planner (plan amendment 1: split milestone M2 out): bricks-icons

You are a fresh planner (**Fable 5.2, high**). Change no source or test, commit nothing, start no agents; never load any live site. Work
under `~/.cache/bia1/`. Load `implementation-planning`; read `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`
(the plan-amendment paragraph; `ac-check.sh`'s `ac_start`, `bad_id`, `plan_acs`, `live` regexes).

## Why
`/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/plan-approved.md` holds two milestones: M1 (Figma plugin, AC1–AC7, AC7 live)
is built, reviewed clean twice (fix round 1 replaced the `min-width` floor with `overflow: clip`, `height: auto` at zero weight, no
`aspect-ratio`; HANDOFF records it) and goes to the verifier now; M2 (website importer, AC8–AC12, AC12 live) waits for site-no-div and
site-shared-styles. `ac-check.sh` needs every AC of the plan proven on one head, so M1 can't be accepted while AC8–AC12 sit in its plan.

## Do
1. **Amend** the approved plan to M1 only: AC1–AC7 unchanged (ids, cited test names, live set {AC7}); M2's ACs, tasks and M2-only text move
   out, replaced by one line pointing at the new plan; also bring the plan's prose (~lines 110–114, ~300) to the fixer's rules (overflow
   clip, zero-weight `height: auto`, no `aspect-ratio`) as an `[amended]` record, no AC wording changed. Write
   `/home/justin/.hermes/plans/figma-to-bricks/evidence/bricks-icons/planner-amend-1/plan-amended.md` with regex receipts (old vs new: AC8–AC12
   removed on purpose, AC1–AC7 lines byte for byte).
2. **New plan** `/home/justin/.hermes/plans/figma-to-bricks/bricks-icons-site.md` (job **bricks-icons-site**, the importer half): M2's ACs
   renumbered AC1–AC5 (AC5 live), its tasks, its overlaps and order (after site-no-div and site-shared-styles; on top of bricks-icons M1's
   shapes), with the M1 fixer's svg rules carried over, and the ⭐ answers as approved (Justin's "go with recommended").

## Report (as text)
Both paths and sha256s; each change in one line; the regex receipts; `skill_lessons[]`, ending with: `MAIN SESSION: check and save these
skill_lessons now.`
