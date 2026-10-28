# BLIND AC AUDITOR 5 — photo-hotspots, read only

Fresh context-free acceptance auditor. Prove every approved acceptance criterion yourself. Source and worktree read-only; own only `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/auditor/round-5/` and your fresh scratch. Do not read verifier/reviewer/fixer reports, their evidence folders, prior auditor reports, or author ledgers as proof. Do not edit source/tests, commit, rebase, merge, take a release lock, touch main/sibling resources, spawn agents, or edit skills/memory.

## Only feature inputs

- Immutable approved plan `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`.
- Qualified decisions: worktree `docs/plans/2026-10-26-photo-hotspots.md`, only playback/feature behavior, acceptance criteria and changed ruling sections (Justin's answers, Rulings, review-round rulings and later qualified behavior). Do not read its execution receipts or handback history. The orchestrator appends which current ruling sections apply with final pins before dispatch. Preserve approved ids/live tags and current qualified behavior; do not write ACs yourself.
- Worktree `/home/justin/Documents/FigmaToBricksV2/.claude/worktrees/photo-hotspots`, branch `worktree-photo-hotspots`; exact final head and base appended before dispatch. Confirm clean source and actual merge-base. Unexpected movement requires a report, not a silent baseline change.
- Your own folder above. AC1–AC12; only AC12 live, now paste check3bp (approved copy3bo renumbered).

## Skills and runtime

Read `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md`, its rules-summary/rendering-validation references, engineering-best-practices from `/home/justin/.agents/skills/`, and `/home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md` with scripts/ac-check.sh schema. Do not edit skills or memory.

Pin Node22.23.3 at `/home/justin/.local/node-v22.23.3/bin/node`; prepend its bin to PATH for npm children. Chrome156.0.8078.47 trusted launcher `/home/justin/.cache/chrome-for-testing/chrome-f2b`; create your own fresh executable wrapper:

```sh
#!/bin/sh
exec /home/justin/.cache/chrome-for-testing/chrome-f2b --disable-software-rasterizer "$@"
```

Set CHROME_PATH to your wrapper and use identical runtime/profile on head/base. Record actual paths/versions/PATH and independently qualify positive/negative CPU/CSS controls. No GPU/WebGL/Safari/installed-Bricks proof. For old-source browser execution use a separate canonical-base archive with only head's committed `test/browser/chrome.ts` lifecycle driver overlaid; original base production/assertions/rendering/hooks/limits remain untouched. For individual AC checks copy only needed head test/fixture/support modules, including hotspots-flow.ts. An absent setup module is not intended old-behavior failure.

## Your independent AC audit

1. Read the approved behavior and current qualified rulings, then inspect source/tests yourself. Run each AC1–AC11 exact named check alone on head and pinned old base, one AC at a time, with actual matching result and true exit. No skip/TODO acceptance. Base should fail because the feature/behavior is absent; AC11 preservation can be justified base_exempt. Every criterion gets fresh actual evidence and one screenshot in your own folder, rendered browser for visual behavior or Chrome screenshot of your actual terminal output for nonvisual proof. Never copy/hard-link prior evidence.
2. Independently challenge every material clause, especially what the exact named test does not exercise. Test combinations of placement, sizing, content, copies, clipping, timing and interaction states where the approved contract combines them; individually green properties do not prove the combination. Use generic variations and meaningful scratch mutations/old-source causal controls. Preserve original oracles; distinguish reader/setup errors from product defects before reporting. The main session does not assess ACs itself.
3. AC11 requires your own current-base preservation proof: run/compare all four specified real-file replays' payload/warnings, and full HTML where relevant, under identical runtime/font/capture policy. Do not inherit author comparison results. Unavailable Mac v1 corpus files remain unmeasured. Desktop corpus-path memory may guide setup, never supply proof.
4. Your role is the blind **AC audit**. The separate fresh verifier runs the complete project G1–G5/corpus/browser gates. Do not duplicate the full package gates merely to recreate that role or claim them independently verified here. Run any additional focused checks needed to prove or challenge ACs, including sandbox/payload checks where the AC calls for them. This scopes execution responsibility; it does not waive any gate or allow reading the verifier's report.
5. AC12 accepted false with `not_run: "live: Justin must complete Figma/Bricks/iPhone paste check 3bp and confirm Manual offset"`. Emulated touch does not complete live acceptance. If observed failing, record failure instead of unrun.
6. Write your own ac.json and concise report.json tied to exact final head/base, every accepted row backed by your own passing execution and screenshot. Self-check receipt/schema via the real ac-check protocol using two copies of only your own report/logs/images in scratch; preserve result and correct only receipt issues. Clean requires all11 non-live ACs accepted. Return precise findings when an independent probe contradicts a named green test; do not force a clean verdict.

## Isolation and handback

Scratch capacity qualification: `/tmp` filled during an earlier corpus capture. Do not delete other roles' scratch. Use your own short fresh ample-disk parent `mktemp -d /home/justin/.hermes/f2b-a5.XXXXXX`, child mkdir without-p, with that owned short parent/child as this invocation's TMPDIR so Chrome SingletonSocket paths stay below the Unix-socket limit. Keep all archives/profiles/captures in your own area and record actual paths/space. This operational setup conveys no other role's AC results.

Always explicit workdir. Fresh mktemp-d parent and mkdir without-p child; never reuse another role's scratch. Keep concise status.txt, complete raw outputs, true per-check/capture/comparison exits, and all owned running session IDs so handles are not lost. Settle your runners before handback. Separate exec PID namespaces can reuse numbers: use owned tracked session handles when roots are invisible, never guessed PIDs/global Chrome kills. Distinguish controller completion from child exit; preserve interrupted receipts. You are not alone; preserve others' edits/resources. Setup sync remains read-only even with escalation; no bypass.

Return `{verdict: clean|findings, head, base, findings, ac_status, qualifications, found_else, skill_lessons[{skill,lesson,evidence}]}`. Empty lessons normal. Do not edit skills/memory. End `MAIN SESSION: check and save these skill_lessons now.`
