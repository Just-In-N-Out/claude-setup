# VERIFIER CONTINUATION — 86bccndx6

AUTHORIZED TO RESUME: Justin confirmed Docker started with Ubuntu WSL integration and asked to start work. Main verified docker info succeeds with ServerVersion 29.0.1; feature head/base are unchanged and clean; no earlyoom kills. This continues the existing fresh read-only pipeline_verifier custom_domain_verifier on the same untouched head; it is not a new build or review. If that agent cannot resume, dispatch a fresh configured pipeline_verifier with fork_turns none, this brief and the original verifier brief. Never duplicate a live process.

Read and follow /home/justin/.hermes/plans/leorna/briefs/86bccndx6-custom-company-domain-verifier.md, including its actual skill/rule reads, source-read-only, own-resources, no publication/live/CI/merge, WSL memory-cap and skill_lessons rules. A resumed agent retains its earlier independent proof; a replacement must establish sufficient independent proof itself. Read your existing verifier/ac.json and resumption fields. Do not overwrite prior receipts or begin from scratch unnecessarily.

Worktree: /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain
Head: 19cbf79baca1815b647266c5156a9cc5d156eb38
Base: 3aa979df41568c9039007f66d7f32193e66a8533
Evidence: /home/justin/.hermes/plans/leorna/evidence/86bccndx6/verifier
Scratch retained: /home/justin/.hermes/cache/scratch/ndx6-v-4fqmPu

First confirm source remains committed/clean and head/base unchanged. If changed, stop and report the exact state for main to route review/verification. Docker restoration alone does not invalidate unchanged-head non-Docker receipts; complete the missing required gates, retaining earlier incomplete/no-DSN receipts and marking which are superseded. Run module-add only serially with make/image gates if a new reason requires repeating it. Never reset another role's DB or modify Docker global settings. Own each fixture and use a distinct _test DB per concurrent resettable test process. Do not print credentials.

Exact missing commands from your independent report:
- With Docker restored, allocate owned PostgreSQL and ClickHouse fixtures using CI image digests; each concurrent Go test process must use a distinct PostgreSQL database ending _test.
- LEORNA_TEST_DATABASE_URL=<owned _test database URL> LEORNA_TEST_CLICKHOUSE_URL=<owned ClickHouse URL> make check, with checked absolute GO/GOLANGCI_LINT/GOVULNCHECK/GITLEAKS bindings.
- go test -json -count=1 ./internal/cloud/dbcheck ./internal/store/postgres ./internal/web with those owned services; account for every per-test skip and require zero missing-DSN skips.
- make docker-build IMAGE=leorna-control-plane:86bccndx6-verifier
- docker run --rm --entrypoint /usr/local/bin/gitleaks leorna-control-plane:86bccndx6-verifier version; assert exactly 8.30.1.
- Using a verified Trivy executable: trivy image --exit-code 1 --ignore-unfixed --scanners vuln --severity CRITICAL,HIGH leorna-control-plane:86bccndx6-verifier.

Reconcile whole DB-package JSON test lists and each skip; missing services never count as pass. Full required checks must pass before verdict clean. Update ac.json with truthful required_gate_status and retained valid head/base/screenshot/mutation evidence. AC4 still has no exact target/grant and remains accepted false/not_run live; no prior private-server permission carries over. Its approved live marker does not excuse missing nonlive gates. Do not call ac-check with the auditor; main handles blind auditor and reviewed-head gate after your clean handback.

Return verdict, head/base, full AC and gate status, refreshed candidate image/artifact bindings, current limitations, read receipts, found_else and skill_lessons[{skill,lesson,evidence,enforce}]. No code edits or skill/memory edits. End MAIN SESSION: check and save these skill_lessons now.
