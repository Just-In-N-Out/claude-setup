---
name: no-ci-changes
description: "No CI edits in Leorna stories by default; Justin explicitly allowed necessary CI edits for story 86bcm901u only"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 748ba66f-4c02-494d-836a-b694ca1101f2
  modified: 2026-10-24T22:45:00Z
---

Never add or change CI files (`.github/workflows/*`) in either Leorna repo as part of a story by default. If a new package isn't covered by a CI job (e.g. the Windows job lists packages by name), leave it out and say so in the PR's Assumptions instead.

**Story-specific exception 2026-10-22 (Justin):** `86bcm901u` **Content quality gate (CI)** may design and, after plan approval, implement necessary CI/workflow changes. Justin said: "And do not worry about the CI stuff make an exception for this story". This exception applies only to this story, not unrelated CI cleanup or other cards. Existing security/quality gates must not be weakened. The current pick authorizes the Opus planner only; implementation waits for **go**. Push/PR/remote CI runs and credentials/permissions changes are not authorized by this exception; follow their normal approval boundaries. The gh token last checked 2026-10-22 had no `workflow` scope, so eventual publication may need a user-side auth step (not a planning blocker). **Done 2026-10-24:** Justin ran `! gh auth refresh -h github.com -s workflow`; `Justin-Leorna` now has `workflow`. When asking for this step, say up front that GitHub's "Authorize your device" page wants the 8-character code the command itself prints: no other device is involved (he was unsure).

**Status 2026-10-23 (Claude Code):** the exception carries over unchanged to Justin's from-scratch restart on branch `feat/86bcm901u-quality-gate-v2`. The approved plan changes only `.github/workflows/ci.yml` (one new step plus an env var on the test step), with nothing removed.

**Why:** On 2026-10-06 (86bbu3xmt) I added `./handoff` to the Windows CI test line. The HTTPS push via gh was rejected because the token lacks the `workflow` scope. Justin asked "why did we change the CI? Do we have to?", then said "drop the ci change and add to memory to never add ci changes". The branch was rebuilt without it before the push.

**How to apply:** For stories other than `86bcm901u`, check that `git diff --name-only main...HEAD` has no `.github/` paths. For `86bcm901u`, review each workflow change against its approved story scope and preserve the existing gates; do not reject the diff merely because it contains workflow files. Mention unaddressed CI gaps in the PR text rather than fixing them outside scope. Related: [[consistency-over-local-fixes]], [[stop-and-show-diff]], [[leorna-workflow]].
