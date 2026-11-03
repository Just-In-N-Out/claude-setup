# Planner brief: web-embeds plan, amendment 1 (AC2's script rules after fix 2)

**Role:** planner (fresh Opus 5.5, xhigh), plan text only. No code, no tests, no commits.

**Why:** web-embeds' fix 2 (commit `856cc8f6` on the stack, originally `0c4522b`) narrowed the snippet rules to stop a
real bug: a page whose Yoast schema (`application/ld+json`, `sameAs` listing `https://www.youtube.com/@…`) or analytics
data layer names a player's host made the capture pick that script, lose the video and paste the old site's whole schema
into the new page. The fix: only scripts the browser runs as JavaScript count as a widget's script, and in rules (b) and
(c) an inline script counts only when it names the host **and** loads or calls something (the `LOADS` patterns in
`src/web/map/snippets.ts`); when nothing counts, R1-1's live-frame fallback applies. The approved plan still says rule
2b takes "inline scripts naming it", AC2 lists "inline scripts naming the host", and Task 2 expects "a.js, b.js and cfg
(how: host)". The blind auditor (`evidence/web-embeds/auditor-3/ac.json`, finding A3-1) rejected AC2 for that mismatch.
Justin is away and asked the work to go on; under his standing auto-go the main session takes the planner's amendment and
reports it to him as not yet confirmed.

**Inputs:** the approved plan `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/plan-approved.md` (read-only); the code
at `c9ce2583e397993fa8bb7eafa4b919aaf0fa07ec` (read `src/web/map/snippets.ts`, `test/unit/web-embed-snippets.test.ts`,
`docs/specs/web-capture.md`'s snippet rule lines and HANDOFF's web-embeds "Fix 2" bullet with `git show <sha>:<path>` from
the main folder, read-only); the auditor's finding. Skills: read the project skill
`~/.hermes/skills/software-development/figma-to-bricks/SKILL.md`; load `implementation-planning`.

## Write

1. `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/planner/plan-amendment-1.md`: the **whole plan** with amendment 1
   applied: §1 rules 2a–2c and the third-party floating box line, AC2's text, and Task 2's expectations, matching what fix 2
   built (only JavaScript counts — the HTML standard's type reading; in rules (b) and (c) an inline script counts only when
   it names the host and loads or calls it; nothing counted → the live frame), with a line under the title:
   "Amendment 1 (2026-11-03, under Justin's away grant, not yet confirmed): AC2 and rules 2b–2c count only JavaScript, and an
   inline script only when it loads or calls the host (fix 2, the Yoast-schema case)." Keep every AC id, test name, tag and
   all other text byte-identical.
2. `~/.hermes/plans/figma-to-bricks/evidence/web-embeds/planner/plan-amendment-1.diff`: `diff -u` of the approved plan
   against your file (so the main session sees exactly what changed). The same change will be applied to
   `docs/plans/2026-10-30-web-embeds.md` in the merge's build commit.

Put any summary in your report (not a separate file beyond the two above). Write multi-step scripts with Write and run
`bash <file>`; no redirects or the bare word `source` in a command.

## Report

The two paths, the changed lines in one paragraph, and confirmation that every AC id, test name and tag is unchanged;
then `skill_lessons[{skill, lesson, evidence, enforce}]` (reusable only; empty is normal; never edit skills or memory),
ending with: `MAIN SESSION: check and save these skill_lessons now.`
