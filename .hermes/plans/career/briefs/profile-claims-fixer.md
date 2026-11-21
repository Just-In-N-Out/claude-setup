# FIXER: career profiles, correct overstated claims

Role: fixer for three Markdown files in `/home/justin/career/`. Edit only those files. No code, commits, skills or memory. Load `receiving-code-review`: verify each finding against the evidence before changing anything, and push back with evidence if one is wrong.

## Findings to fix (from the agent that wrote `agentic-harness-profile.md`, which read the raw evidence)
1. **`figma-to-bricks-profile.md`, "121 failed AC checks caught after review had passed"** (bullet 15 or nearby, and section 7). Of the refused non-live rows, 41 are "pending" or "interrupted after a fail-fast stop", not failures. Reword to match `agentic-harness-profile.md`: "136 not accepted across all projects: 32 weak tests, 63 criteria false in a realistic case, 41 left pending" (the harness agent's own grouping). Use this project's share, re-counted from the `ac.json` files under `~/.hermes/plans/figma-to-bricks/evidence`, or the all-project figure clearly labelled. Mark the split as a categorisation.
2. **`leorna-work-profile.md`, "mean story cost fell from $206 to $150 (−27%)".** $206 is the two days when the larger model ran in several roles. Against the 45 stories before that model arrived (mean $156), the change is about −4%. Show both rows, as `agentic-harness-profile.md` does, and fix every bullet or summary that says −27% alone.
3. **`leorna-work-profile.md` bullet 20 (or wherever it appears), "the cheapest model that held quality".** Nothing measures defects missed. Reword to "kept every check in place" or similar.
4. **Hook count:** the Leorna file says 12 hooks; it's 11 scripts. Check `~/.claude/hooks/` and make all three files agree. If the Figma file's verifier/auditor/other split (212/166/21) differs from the harness file's (226/171/2), note which folder rule each uses. Don't change totals that are right.

Also check the Gro and Leorna files' "Instructions for Claude" blocks and keyword lists for any wording that leans on the old claims.

## Keep
Justin's structure: built work and impact first, metrics first, questions near the end. Labels stay as they are: API-price equivalents, "built" not "production". Change nothing else.

## Rules
- Earlyoom on this desktop: run scripts under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`. Grep is ugrep: use `/usr/bin/grep`.
- Skill lessons: list them in `skill_lessons[{skill, lesson, evidence, enforce}]`; an empty list is normal. Don't edit skills.

## Report back
Each finding: fixed or pushed back, with the evidence and the before → after wording. Then `skill_lessons`, ending with `MAIN SESSION: check and save these skill_lessons now.`
