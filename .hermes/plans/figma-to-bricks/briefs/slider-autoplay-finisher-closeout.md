# FINISHER — slider-autoplay, SSH preflight and remaining local artifact

Finish the already accepted local release. Do not change application source, tests or BUILD and do not start
agents. Justin asked why pushing was blocked and how to unblock it; inspect and test the safe documented route
below before asking him to repair system permissions.

## Skills, state and ownership
Load the project skill `/home/justin/.hermes/skills/software-development/figma-to-bricks/SKILL.md` and its rules
summary, `engineering-best-practices`, `git-commit-rules`, and `systematic-debugging` for the SSH failure.
Main: `/home/justin/Documents/FigmaToBricksV2`, build 2026-10-28.3, local release
`979c5b331cc095ed1602602fb7a49eb295fa78e0`, feature `2b55134485cdf5f2d58eec03775a658e5f0544f6`.
Independent AC1–AC12 accepted on feature/base27b787b; AC13/AC14 remain live paste check **3bo**, AC14=5800/800.
Ledger `docs/plans/2026-10-26-slider-autoplay-ledger.md`; prior release report/evidence in finisher-release/.

You are not alone: preserve all other sessions' work. Never touch headline-marker/photo-hotspots worktrees or
evidence. Your new evidence only:
`/home/justin/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/finisher-closeout/`.
Fresh scratch `/tmp/slider-autoplay-finisher-closeout-XXXXXX`, no reuse of another's folder.

## 1. Resolve the pre-authentication SSH configuration failure safely
Prior normal AND escalated `ssh -T ... git@github.com` failed before authentication:
`Bad owner or permissions on /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf`.
Read-only metadata here: /etc/ssh, its config files and /usr/bin/ssh appear owned nobody:nogroup; the problematic
file is 0644. `/home/justin/.ssh/config` is owned justin:justin, 0600. This may be the execution environment's
ownership mapping; do not assume Justin's real WSL system files need chown/chmod.

The problematic include contains ONLY systemd local-machine/unix/vsock Host patterns, not github.com.
Official primary documentation https://man.openbsd.org/ssh#F states an explicit -F configfile omits the
system-wide config. Evaluate using the existing user config explicitly for this command, preserving its Github
key/host settings and all applicable host verification/security policies. Inspect user-config includes and
relevant global defaults before deciding it is equivalent for github.com. No private-key contents in output.

If this route is equivalent and safe, test SSH identity with the existing user config explicitly; then use the
same command-scoped SSH selection for git push. This is authorization for that transient command option only.
Do NOT change SSH transport, remote, helper, gh account, keys, persistent core.sshCommand/config, or system files.
Do NOT disable host-key checking, permission checks or other security controls. Preserve original failures and
effective-setting evidence. Normal sandbox network failure gets its normal require_escalated retry; never
circumvent an approval denial. Stop on actual authentication failure or wrong account. Only the verified
`Hi Just-In-N-Out!` identity may push main; exit1 greeting is normal for Github.

## 2. Complete the approved plan's local B-Dry hero paste artifact
The plan's Docs & records explicitly requests this after the feature merges. Read project memory
`/home/justin/.claude/projects/-home-justin-Documents-FigmaToBricksV2/memory/bdry-home-copy.md` for provenance.
The base paste is `/home/justin/.hermes/plans/figma-to-bricks/evidence/bdry-paste/home-paste-v2.json`.
Read it without modifying it. Source captures are evidence/bdry-source/. Do not use other features' work areas.

Make a NEW copy in your own evidence folder, `home-paste-slider-autoplay.json`, whose hero uses precisely the
native shape/settings this plugin now emits: three Block slides, interval7500, speed2500, autoplay,
pauseOnHover/pauseOnFocus, loop (no type), arrows25 in source colour, no pagination, height auto, gap0.
Preserve the base's actual words, links, AVIF media ids, layout and every non-hero section/global class, including
any already-applied flip fix; keep home- class naming. This is an explicitly requested page artifact, never a
one-file special case in plugin code. Derive canonical settings from actual converter output/reference evidence.
Validate structure, ids/links, payload controls and renderer behavior at relevant wide/phone sizes; retain exact
before/after differences and screenshots. No live WordPress writes, new uploads, clipboard replacement or
unapproved edit to the Windows Downloads copy. If a required source artifact is genuinely absent, report the
precise missing input after exhausting the provided locations; do not fabricate it.

## 3. Finish the push and records
The orchestrator released its slider-autoplay lock after the failure; read back no assumed ownership.
Do independent read-only SSH/artifact work without a global idle reservation. When ready to update feature
records or push, use the project's merge lock as owner `slider-autoplay-closeout`; confirm completed acquisition
and read back actual owner, clean/coherent main and expected release ancestry. Release on every success/failure
path and immediately read back that your owner is gone (a sibling may acquire next).

Never stash/discard/stage another's changes. If main advanced to a sibling's unfinished release, stop and report
ownership rather than pushing its half-done state. Preserve existing transport/credentials; push MAIN only after
the verified identity. Update only this feature's HANDOFF/ledger as needed to reflect actual push/artifact facts;
plain scoped commits, configured Justin identity, no CLAUDE/AGENTS/debug files staged and no AI trailers.
Do not bump BUILD again. Do not repeat application gates for records-only changes.

The main CLAUDE edits are queued in slider-autoplay-claude-md-pending.md behind older denied/unapplied records.
Preserve that ordering and all exact pending edits. Do not bypass/retry older protected write denials. Update this
feature's pending file with true push/artifact status, but do not mark applied unless every required section landed.
The main session saved your predecessor's verified autoplay rule into the existing native-interactions line of
the real rules summary; no need to edit skills or memory yourself.

Report exact main/origin agreement, commit(s), build/dist integrity, local artifact path/hash, pending notes,
rulings and remaining live/desktop-narrow-slider/Mac-corpus limits. Keep worktree/branch intact.

## Report
Return `{status: released|stopped, build, head, push, ssh_identity, artifact, docs, locks, gates,
steps_for_justin[], skill_lessons[{skill,lesson,evidence}]}`. Source remains frozen. Empty lessons normal.
End with `MAIN SESSION: check and save these skill_lessons now.`
