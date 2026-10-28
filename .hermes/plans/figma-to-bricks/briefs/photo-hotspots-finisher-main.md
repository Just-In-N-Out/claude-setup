# FINISHER — photo-hotspots, after-merge release only

Do exactly the authorized after-merge steps in `/home/justin/Documents/FigmaToBricksV2` on `main`. You own this feature's release files/records and `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/finisher-main/`. The orchestrator will append the accepted/merged HEAD and merge-lock ownership before dispatch. Confirm them; do not operate on an unexpected main revision or another release owner's changes. Do not rebase, merge, remove a worktree/branch or spawn agents.

## Skills and inputs

Load `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules summary, `engineering-best-practices`, `git-commit-rules` and `github` from `/home/justin/.agents/skills/`. Source of truth: main CLAUDE.md, read relevant sections and re-read anchors immediately before writing because other chats edit it too. Approved plan: `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/plan-approved.md`; later rulings in `docs/plans/2026-10-26-photo-hotspots.md`; the feature HANDOFF and ledger. AC12 remains live (3bp, unless integration documented a collision renumber).

## Release

1. Confirm main is the accepted merged revision, settled and clean apart from explicitly known user files. You are not alone: preserve every unrelated edit/commit and never stage, stash, reset or discard them. Main must remain on main. The orchestrator owns the merge lock and retains it through this task; do not acquire a second lock or release somebody else's.
2. Read the current `BUILD` in `src/shared/build.ts` immediately before bumping it to the next current-date `YYYY-MM-DD.N`. Use the actual current date and current number; other features may have bumped it. This is the only intended source change after acceptance.
3. Move this feature's ledger from `.superpowers/sdd/2026-10-26-photo-hotspots/progress.md` to `docs/plans/2026-10-26-photo-hotspots-ledger.md`. Update this feature's HANDOFF build placeholders and paste-check entry, plan ledger links/rulings where needed, and release records. Preserve other feature sections. Do not weaken, silently change or reclassify ACs.
4. Run `npm run build` in main so Figma loads the new dist. Preserve true exit/runtime and confirm both `dist/code.js` and `dist/ui.html` were rebuilt. Tests/gates already ran on the accepted integrated source; if any substantive source/test change becomes necessary, stop with the exact reason for the orchestrator to route it through verification.
5. Before committing, confirm HEAD is still the accepted branch tip. If another session committed meanwhile, stop and report rather than mixing releases. Check personal identity (`Justin <issajustin04@gmail.com>`) with repository config and log; never override metadata. Stage only this feature's release changes by explicit path. Verify no CLAUDE.md, debug JSON or AI co-author trailer is staged. Plain `git commit -m "Build <BUILD>: photo-hotspots"`.
6. Push **main only**, as authorized by project rules. Read the repo remote/credential-helper configuration without exposing secrets. Use its existing personal identity. For the WSL SSH remote, confirm `ssh -T git@github.com` identifies `Just-In-N-Out` before pushing; never switch gh accounts, alter a remote/helper, invent a token workaround or push this worktree branch. For a sandbox/network failure of an important command, use the supported escalation approval path, preserving the reason. If authentication remains unavailable, report it exactly.
7. Update main CLAUDE.md "Start here", "Where things stand" and the relevant user decisions/limits: designer's Manual Open overlay creates cards beside dots; optional `pulse` annotation; photo/dots retained on phones; mouse/focus/tap and reduced-motion behavior; recorded unconfirmed defaults; clipping-ancestor limitation; known pulse-animation/class-name follow-ups; gate qualifications and live check owed. Re-read immediately before editing. This file stays excluded and uncommitted. If a protected-file write is explicitly denied, preserve exact proposed edits in a pending file under `/home/justin/.hermes/plans/figma-to-bricks/`, do not retry/bypass, and report pending documentation.
8. Do not edit any skill or memory. Instead, return an exact proposed concise update to the project skill's `references/rules-summary.md` if the new feature creates a reusable user-decision rule; the main session will re-read and apply it. Keep status out of that proposed rule.
9. Verify and report BUILD, main HEAD, origin/main equality after the push, clean Git state (qualify preserved unrelated changes), rebuilt dist, documentation state, ledger destination and live AC12. Leave the feature worktree and branch in place, per Justin's explicit instructions. The orchestrator releases its lock and does its final Git checks.

Use a fresh owned scratch parent (`mktemp -d` and `mkdir` without `-p` for `photo-hotspots-finisher-main`). Always pass workdir. Keep complete operation receipts and concise `status.txt` progress in your evidence folder. Do not read/alter another feature's evidence, scratch or processes. Codex role: gpt-6.1-sol at xhigh. Setup sync has failed even with escalation because `/home/justin/.claude-setup.git` is mounted read-only; retain local records and report that limitation, without a bypass.

## Report

Return `{status: released|stopped, build, head, origin_main, push, gates, docs, ledger, rulings, live_acs, limits, proposed_rules_summary_edit, skill_lessons[{skill, lesson, evidence}]}`. Empty skill_lessons is normal; never edit skills or memory yourself. End with `MAIN SESSION: check and save these skill_lessons now.`

## Verified SSH transport for this environment

Release preflight `/home/justin/.hermes/plans/figma-to-bricks/evidence/photo-hotspots/release-preflight/ssh-identity.txt` records the root session's read-only identity check. Default SSH, including its escalated retry, fails before authentication on `/etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf` permissions. The existing user SSH config is owned by Justin with mode 600. This succeeds and greets **Just-In-N-Out** (exit 1 is GitHub's normal no-shell greeting):

`ssh -F /home/justin/.ssh/config -o BatchMode=yes -o ConnectTimeout=10 -T git@github.com`

Reconfirm the same account before the authorized push. Preserve this existing transport for the command only:

`GIT_SSH_COMMAND='ssh -F /home/justin/.ssh/config -o BatchMode=yes -o ConnectTimeout=10' git push origin main`

Do not change any SSH config, remote, credential helper, account or author metadata. This is a configuration-permission workaround using the same existing key route; actual authentication failure still must be reported, with no alternate account/token workaround. Record the actual push exit and origin/main equality rather than assuming the identity check itself published anything.
