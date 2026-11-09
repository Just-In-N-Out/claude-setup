# Brief: 86bcm9284 SOURCE.md re-pin reviewer, round 1 (full)

**Role:** a fresh REVIEWER, report only, for a one-commit follow-up to Leorna card 86bcm9284 (predefined integration tiles, merged as control-plane #119 and client #31). Change no source, commit nothing, push nothing, write nothing to ClickUp. The only file you may write is the `review.json` below. Scratch goes in `~/.cache/86bcm9284-repin-review-1/`, never `/tmp`; remove it at the end.

## Skills to load
`leorna` (hard rules), `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `review-fix-cadence`. The record format is in `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md`.

## What to review
- Worktree `/home/justin/Leorna/86bcm9284-source-repin`, branch `feat/86bcm9284-source-repin`, head `0df1c0339950564b613a6394f13c9a76ab3140aa`, base `d9c6aa8e7f8afb2d4dbbc1946dba467d50f7be08` (control-plane GitHub main, the merge of #119; confirm both). It's one commit changing `internal/library/render/testdata/client/SOURCE.md` only.
- **The point of the change:** `SOURCE.md` pinned the GitHub Enterprise Server fixture copies to client branch commit `6d3c3c5` with "client PR pending". Client PR #31 has merged as `f3bc96061c74510b4cd9f7a7ee0a14890f087441` on client main. The render parity rule in `SOURCE.md` says copies must come from a merged client change.
- **Check:**
  - every SHA and path the new text names exists, and says what it claims (fetch client main read-only over HTTPS via gh, or use `gh api`);
  - the fixture bytes at client `f3bc960` equal the control plane's copies, and the SHA-256 lines are still true;
  - the wording is accurate;
  - `go test ./internal/library/render/... ./internal/integration/...` and `make -s library-check` pass (toolchain from `~/.local/leorna-toolchain`);
  - the commit uses the Leorna identity with no AI-attribution lines, and no CLAUDE.md is staged.
- The fixer's evidence is in `~/.hermes/plans/leorna/evidence/86bcm9284/fixer-5/` if you want it, but check things yourself.

## Severity (Justin's scale)
- **P0/P1:** a security hole, a guard bypass, a false AC or claim, or a wrong block that breaks normal work.
- **P2:** a bug a real person or agent could plausibly hit, or a test that can't fail.
- **P3:** cosmetic or docs.

Every P0–P2 needs a concrete real-use scenario of 5+ words.

## Record
Write `~/.hermes/plans/leorna/evidence/86bcm9284-repin/review-1/review.json` with `round: 1`, `scope: "full"`, `from: "d9c6aa8e7f8afb2d4dbbc1946dba467d50f7be08"` and `head: "0df1c0339950564b613a6394f13c9a76ab3140aa"`. Ids are `R1-<k>`. Self-check with `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm9284-source-repin --base d9c6aa8e7f8afb2d4dbbc1946dba467d50f7be08 ~/.hermes/plans/leorna/evidence/86bcm9284-repin`. Exit 2 means your file is wrong.

## Desktop memory rule
A command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep 'sending SIG'` first. In a background agent, wait with foreground polls under 170 s.

## Skill lessons
If you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section. `enforce` is `none` or a one-line proposal for a check (kind, what it checks, where it runs). An empty list is normal.

## Report back
`verdict`, findings, `ac_status` (one entry: `{ac: "SOURCE.md re-pin", status, reason}`), the review.json path with its self-check exit code, and skill_lessons. End with `MAIN SESSION: check and save these skill_lessons now.`
