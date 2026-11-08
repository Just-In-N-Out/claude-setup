# REVIEWER 5 — FULL independent review, 86bcm927y

Role: fresh pipeline reviewer (Claude Code general-purpose agent, Opus, xhigh), fork_turns none. Report only. No nested agents: the main session owns the pipeline.

Story: [Integrations catalog - tiles UI in the admin console](https://app.clickup.com/t/86bcm927y)
Repo: LeornaAI/leorna-control-plane (canonical checkout /home/justin/Leorna/leorna-control-plane)
Worktree (accepted candidate, READ-ONLY): /home/justin/Leorna/86bcm927y-integrations-catalog-tiles
Branch: feat/86bcm927y-integrations-catalog-tiles
Expected HEAD: 00277865b9ac2305a2716ef2cca2dcdf6611285f
Review base (merge-base with main): 3aa979df41568c9039007f66d7f32193e66a8533
Scope: FULL review of the entire 3aa979d..0027786 range (11 commits, 27 files, +2611/-35), not only the last fix.
Evidence root: /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Own output folder: <evidence root>/review-5/ (create it; write structured evidence + review.json only there)

## Read first

1. The detailed review instructions, which are binding for this round: /home/justin/.hermes/plans/leorna/evidence/86bcm927y/finisher/review-prompt.md. Follow them in full: exact checks, owned isolated Postgres 18.6 / ClickHouse fixtures, `go test -json` skip checks, the migration 27→28→down→base→28 cycle with nonempty rows, the headless browser journey, the container/Trivy gate, the mutation probe list, and the return format.
2. Active contract: <evidence root>/plan-approved.md. Also <evidence root>/plan-approved-v1-original.md (the original implementation/gates annex) and <evidence root>/amendment-approval.json.
3. Rules: /home/justin/.claude/CLAUDE.md, the worktree AGENTS.md, any project CLAUDE.md, the delivery/README.md.
4. Dispatcher references: /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md (review.json format, referee, severities) and references/ac-verification.md.
5. Prior rounds as inputs, NOT proof: review-1 … review-4 (review.json + reports), fixer-1 … fixer-4 dispositions, acceptance-2/verifier/ac.json, acceptance-2/auditor/ac.json, ac-check-attempt-1.txt and -2.txt, follow-ups.md.

## Skills to load (Skill tool), in this order

`leorna` first (skip its Step 1 context load if it tells you to defer to the planner; you need its roles/evidence rules), then `engineering-best-practices`, `requesting-code-review`, `code-review-practice`, `security-best-practices`, `multi-tenant-auth-management`, `api-contract-drift-guard`, `backend-data-migrations`, `mutation-testing-discipline`, `receiving-code-review` (to judge earlier fixer dispositions). Add `systematic-debugging` if a check fails unexpectedly. Your independent role replaces any nested-agent or auto-fix step those skills describe. If a skill named here is missing, say so; don't skip it silently.

## Approved scope (option B), settled, don't re-argue it

GitHub and ClickUp support configuration, validation, save/update, pack selection, native previews and audit. Google stays an informational, unavailable tile with no editable form or save control. Valid authenticated, CSRF-valid Google submissions return 409 with no values echoed and no settings/revision/audit writes; service and direct-store saves refuse it too. Existing stored Google rows and snapshots are preserved, but catalog and common resolver paths deny every new selection, including same-tenant legacy IDs. Native Google client-ID support is explicitly deferred. Don't claim original Google support was delivered, and don't treat the retained failing original Google positive test as a new defect (it is dependency evidence for the deferral).

## Acceptance criteria (none is live)

- AC1: integration tiles with short descriptions and the parameters they need. Three descriptive tiles; GitHub/ClickUp forms; Google information-only and unavailable. Primary `TestIntegrationsAC1TilesWithPostgres`.
- AC2: required values validated before saving. Required and malformed values (hostname, IPv6, ports 1–65535) rejected; valid normalized saves/updates; revision checks; rejected operations write nothing. Primary `TestIntegrationsAC2ValidateWithPostgres`.
- AC3: configured integrations available in the pack builder. Supported items reach new/existing packs and native previews; snapshots/digests and tenant boundaries preserved; Google new selection denied. Primary `TestIntegrationsAC3PackBuilderWithPostgres`.
- AC4: saves and changes recorded in the audit log. Exactly one redacted configure/update event; none on rejected/no-op/stale operations; settings and audit roll back together (supporting `TestIntegrationAuditRollbackWithPostgres`). Primary `TestIntegrationsAC4AuditWithPostgres`.

Explicitly check: tenant isolation, admin authorization, CSRF, URL validation, pack generation, immutable snapshots, audit redaction, transaction rollback, OpenAPI contract and generated-comment consistency, unchanged native serializers, migration rollback and data retention, docs/README claims, commit identity (Justin Issa <justin@leorna.com>) and no AI trailers, unchanged `.github/` paths, and the delivery/stories.json entry (PR list currently empty: do not use check-story-shippable.py to claim shipped). Prior pipeline acceptance is context, not proof: examine the implementation yourself and run meaningful checks. Required DB tests must actually execute; skips are not passes.

## Constraints

- Review only. No source/test/doc edits in the candidate, no commits, rebase, push, PR, merge, CI/workflow edits, ClickUp writes, external messages, live provider sign-in or native tool-home operations. Leave `deploy/local/` and sibling work untouched.
- Verify the candidate's HEAD and full tracked/untracked cleanliness first. Run every potentially mutating gate (`make generate`, `make check`, module-add, mutations) in your OWN detached clone/worktree at the exact head under /home/justin/.hermes/cache/scratch/86bcm927y-review5-<random>/, never in the candidate worktree or the canonical checkout. Don't switch any existing checkout's branch.
- Others are running: don't touch containers you didn't create (cortexos-*, ndx6-preview-*, leorna-pg, or anything else already up), no shared DB resets, no worktree prune. Use fresh uniquely named loopback fixtures with databases ending in `_test`; Postgres must use password/SCRAM auth. Don't print credentials; never read /home/justin/.hermes/.env.
- Toolchain: /home/justin/.local/leorna-toolchain/go/bin/go (Go 1.27.3), /home/justin/.local/leorna-toolchain/bin/golangci-lint and govulncheck, gitleaks per the verifier versions receipt; Helm/OpenTofu/Trivy as the review prompt says (verify they still exist). Task-local PATH, writable on-disk GOCACHE, short on-disk TMPDIR (not RAM-backed /tmp for big data).
- Windows Desktop runaway memory: every mutation run, and any rerun after a kill, goes under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>` (session-bus fallback only when needed, as the review prompt says). A command that dies with SIGTERM / exit 143 / 137 / "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading it as pass or fail, say so in the report, find what grew, and rerun capped.
- Browser: headless, DISPLAY/WAYLAND_DISPLAY unset, owned profile, short Chrome TMPDIR, your own LEORNA_INTEGRATIONS_EVIDENCE_DIR under review-5/. Look at the screenshots yourself.
- Stop/remove only your own containers at the end; list your scratch path instead of deleting it.

## review.json and self-check

Write <evidence root>/review-5/review.json:
{"round":5,"scope":"full","from":"3aa979df41568c9039007f66d7f32193e66a8533","head":"00277865b9ac2305a2716ef2cca2dcdf6611285f","findings":[...]}
Findings use ids R5-<n>, `severity` P0–P3, `file_line`, `claim`, and for every P0–P2 a concrete real-use `scenario` (≥5 words). For a defect an earlier round raised, set `repeats` and a genuine `new_fact` where you have one. Follow the severity scale in review-loop.md / CLAUDE.md step 5 exactly (P0/P1 security hole, guard bypass, false AC, wrong block; P2 a bug a real person could plausibly hit, AC/UI breakage, or a test that can't fail; P3 cosmetic/docs/deliberate-evasion-only/setup none of Justin's machines has). The known P3 R1-4/R2-2 commit-subject wording stays a follow-up; don't rewrite history.

Self-check: /home/justin/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/86bcm927y-integrations-catalog-tiles --base 3aa979df41568c9039007f66d7f32193e66a8533 /home/justin/.hermes/plans/leorna/evidence/86bcm927y
Exit 2 means your record is malformed: fix it. Exit 0/1/3 is the referee's call, not yours.

## Return (as text in your final message; no prose report files in evidence)

One-line verdict; exact head/base and full scope; per-AC and DoD table with real commands, exit codes and screenshot paths; introduced vs pre-existing findings with severity, scenario and file:line; mutation IDs and final outcomes (compile errors never count as kills); unrun checks and accepted deferrals; `verdict`, `ac_status` (per AC: independently rerun vs inherited), `defect_loop_skills`, `found_else`, review.json path, scratch path, and
skill_lessons[{skill, lesson, evidence, enforce}]: list reusable lessons (a gotcha, an approach that worked after one failed, a skill step that was wrong or missing). Never edit skills or memory yourself. `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind: Claude Code hook, git hook, test, lint, script; what it checks; where it runs). An empty list is the normal answer. Already saved, don't repeat: short Chrome socket path, bounded serialized recording, memory-cap bus fallback, nonce-CSP real navigation.

End your report exactly with:
MAIN SESSION: check and save these skill_lessons now.
