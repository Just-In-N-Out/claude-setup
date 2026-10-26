# FINISHER (hand-over) brief — Leorna control-plane story `86bcm901v-catalog-browser-v3`

Written 2026-10-24 by the Claude Code main session (orchestrator). You are a fresh **FINISHER** (Opus 5.5, xhigh). **Verified clean under the recorded acceptance contract: run only the project's finish step**, which for Leorna is the hand-over (`leorna` skill → Doing a story → steps 5 and 6, plus 4b's finisher part). **Never push, open a PR, merge, or post to ClickUp.**

## Where things stand

- **Repo / worktree:** `~/Leorna/leorna-control-plane`, worktree `/Users/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901v-catalog-browser-v3`, branch `feat/86bcm901v-catalog-browser-v3` (local only, upstream unset on purpose).
- **Accepted head:** `2c43b3941ced883c8d4aa6f7bad7913a9043c173` on base `6e74ced843642439d1dac9f25673440fb0f285f5` (origin/main was still 6e74ced at verification; merge-tree clean). 8 commits, all by `Justin Issa <justin@leorna.com>`.
- **`ac-check.sh` result (run by the main session):** `ALL ACCEPTED: 3 of 3 ACs on 2c43b39`. Independent verifier and blind AC auditor both clean. No `(live)` ACs, so nothing is owed to Justin for acceptance.
- **Do not change the head.** No commits, rebases or edits in the worktree: the acceptance is pinned to `2c43b39`. If you find something that needs a code or docs change, stop and report it instead.
- **ClickUp card:** [Library catalog browser](https://app.clickup.com/t/86bcm901v) (`86bcm901v`), control-plane, PI-2, E11 Pack Builder. Card ACs:
  - **AC1:** Given the admin console, when I open the library, then I can filter by kind, category, tag and supported tool and search by text.
  - **AC2:** Given an item, when I open it, then I see description, example, version, supported tools and a rendered preview.
  - **AC3:** Given 200+ items, then filtering stays responsive (<300 ms server time).
  - **Verify:** UI integration test + manual demo. **DoD:** unit + integration tests (happy path + 1 failure), OpenAPI contract updated if the API is touched, lint/format/CI green (incl. gitleaks + golangci-lint), demoable in isolation, short module README note.
- **Plans:** approved copy `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/plan-approved.md` (Q1A–Q8A); working plan `~/.hermes/plans/leorna/86bcm901v-catalog-browser-v3.md` (its last sections record Justin's away grant and decision (a)=A: the Markdown preview's worst-case cost is a recorded follow-up, not fixed here).

## Evidence you can use (all in `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/`)

- Root: builder on `1571fcd` (`EVIDENCE.md`, logs, screenshots, mutations, RED logs).
- `review-r1/` (clean, 4 P3s on 1571fcd), `fix-r1/` (fixes on 266603e), `review-r2/` (clean, 1 P3 on 266603e), `fix-r2/` (README Limits line on 2c43b39; `ac3-timing-terminal-2c43b39.png`; the PR Assumptions wording is in the fixer's report summary below).
- `verifier/` and `auditor/`: independent proof on `2c43b39`, each with `ac.json`, head and base logs, and its own screenshot per AC.
- Fix-r2's wording for the PR Assumptions list: "The library item page's Markdown preview has no cost bound: goldmark pads every short table row to the header's column count, so a table's HTML grows with columns × rows (a 16 KB table renders to 80 MB of HTML in about 4 s and allocates 1.8 GiB; a body or example at the 64 KiB limit could need tens of GiB, extrapolated). Accepted for now because only content Leorna writes reaches `library_items` (the library embedded in the binary). A bound on table cells, or an escaped code view as the fallback, is a follow-up that must land before content Leorna didn't write can reach `library_items` (e.g. upstream items imported by 86bcm945u, or tenant variants). Recorded under Limits in `internal/web/README.md`."
- Logged side items: `~/.hermes/plans/leorna/found-else.md` (2026-10-24 entries for this story), including GO-2026-5932 in `golang.org/x/crypto` (uncalled, also on base, no fix) and the empty "Prompt" filter once PR #85 merges until a migration widens `library_items.kind`.

## Skills (load with the Skill tool; say so in one line each)

1. `leorna` (FINISHER role): read `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md`, `justin-profile.md` and `~/Leorna/leorna-control-plane/delivery/README.md` from the shared memory folder, plus the repo's `AGENTS.md`.
2. `engineering-best-practices`.
3. `git-commit-rules` (for the authorship checks only; you make no commits).

## What to produce (write everything into `~/.hermes/plans/leorna/evidence/86bcm901v-catalog-browser-v3/handover/`)

1. **Stop-and-show** (`stop-and-show.md`): `git diff --stat origin/main..HEAD` (refresh origin/main first with the HTTPS-through-gh fetch in `leorna` step 7.1, and say whether it moved), the key hunks, the gate results on `2c43b39` cited from the verifier's and auditor's receipts, `git diff --name-only origin/main...HEAD -- .github` (must be empty: no CI exception for this story), and the author check.
2. **PR text** (`pr-text.md`) in Christian's plain style: a Summary paragraph, one line per file/area, a Test Plan with results (only checks that ran on `2c43b39` this session, citing which agent ran them; say CI has not run because nothing is pushed), a short Assumptions list (include the preview-cost wording above, no pagination, the new goldmark v1.7.17 dependency, HTML-only pages with OpenAPI unchanged, dev-mode screenshots on 127.0.0.1, the uncalled GO-2026-5932). Control plane also needs: the ClickUp link, security / migration / rollback notes (no migration; rollback = revert the commits), and an Evidence block (head SHA; check "Go quality gates" and Actions run URL: not yet available, filled in after push).
3. **Review prompt** (`review-prompt.md`): a self-contained prompt for a fresh review agent, in the format of `review-prompt-for-agent.md`.
4. **Team message** (`team-message.md`): the short message from `story-done-team-message.md`, marked as for after the PR merges.
5. **ClickUp evidence draft** (`clickup-comment.md` plus `clickup/` attachment folder), per `clickup-evidence.md`:
   - The closing comment: WHAT WAS DONE / WHAT WAS VERIFIED with an AC → test → result table, gates, CI run (not yet: nothing pushed), and NOT VERIFIED items stated honestly (e.g. hosted CI; anything Verify asks for that no one ran).
   - **One screenshot per AC** (Justin asked for a photo for every AC for ClickUp), taken on the accepted head `2c43b39`: pick from `verifier/` or `auditor/` for AC1 and AC2, and `fix-r2/ac3-timing-terminal-2c43b39.png` (or the verifier's/auditor's AC3 capture) for AC3. Copy them into `handover/clickup/` named `ac1-library-filters.png`, `ac2-item-detail.png`, `ac3-filtering-timing.png`. Add extra shots only if they show something an AC needs.
   - **Open every attachment and check it visually** before listing it: it shows the claimed state, and no server domain, URL bar with a real host, tenant ID, token, device code or email is visible. Open every log you list, read its `EXIT=` line and match it to its `.json` receipt. Don't attach logs that print the author email (e.g. the authors/paths check logs).
   - An inventory table: AC → test → head log → base log → screenshot file.
6. **Hand-over summary** (`HANDOVER.md`): status, head, what's in each file, the follow-ups (preview-cost bound before 86bcm945u/tenant variants; Prompt kind migration after PR #85; pagination), and the next words Justin can say: **"make a PR"** (push + open), **"push"**, **"post"** (ClickUp comment + attachments). Each word authorizes only itself.

## Rules

- No push, PR, merge, ClickUp writes or posts, server/cloud actions, or `.github/` edits. No commits.
- Don't touch `86bcm901u-quality-gate-v3`, the older 901v attempts, or any peer session's worktrees, branches, DBs or Terminal windows.
- Never write a server domain, URL, tenant ID or token into any hand-over file.
- Shared memory notes and skills are updated by the main session, not you: put anything for them in your report.

## Found something else?

Any other bug or problem: `found_else` (one line each, evidence, severity).

## Skill lessons

If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section of your report, naming the skill (or `memory`). An empty list is the normal answer.

## Your final report

`{status: ready|stopped, head, origin_main, diff_stat, files[{path, what}], attachments[{file, ac, checked}], not_verified[], follow_ups[], pr_title, found_else[], skill_lessons[]}`

End the report with the line: `MAIN SESSION: check and save these skill_lessons now.`
