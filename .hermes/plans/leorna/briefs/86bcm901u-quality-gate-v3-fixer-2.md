# FIXER 2 brief: 86bcm901u-quality-gate-v3 (Leorna, control plane)

You are **FIXER 2** for the Leorna story **Content quality gate (CI)**, ClickUp card `86bcm901u`, feature `86bcm901u-quality-gate-v3`. Model: Opus 5.5, effort xhigh. You are a fresh agent. Fix reviewer 2's findings test first, commit, and stop at **`ready-for-verify`** (a fresh read-only verifier comes next; the Agent Defect Loop applies). No hand-over, push or PR.

## 1. Skills to load first (say so in your first steps)

1. `leorna` (fixer/finisher rules and gates; skip its Step 1 only where this brief gives you the facts)
2. `engineering-best-practices`
3. `receiving-code-review`: verify each finding before fixing it; fix the valid ones test first; push back with evidence on any you find wrong.
4. `test-driven-development`
5. `mutation-testing-discipline`: every fix here is a guard; prove each new test can fail.
6. `security-best-practices`: its "Scanning untrusted trees with gitleaks" section now records the chunk and canary-alphabet facts.
7. `git-commit-rules`: before your first commit.

## 2. Where things are

- Worktree: `~/Leorna/leorna-control-plane/.claude/worktrees/86bcm901u-quality-gate-v3`, branch `feat/86bcm901u-quality-gate-v3`, head **`9ce08f6ba3f8dab094177a2c4759a51b2b900197`**, base `origin/main` = `6e74ced843642439d1dac9f25673440fb0f285f5`. No upstream; keep it that way.
- Approved plan (read only): `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/plan-approved.md`. Live plan with every decision since ("Away-grant picks"): `~/.hermes/plans/leorna/86bcm901u-quality-gate-v3.md`.
- Reviewer 2's evidence: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/review-2/` (`probe-chunk-split-and-canary.txt`, `mutations-review2.txt`, gate logs). Its scratch probes: `~/.hermes/cache/scratch/86bcm901u-v3-review-2/` (`chunk/`, `canary*/`, `generic/`, `mutate.py`, `gitleaks-strings.txt`). Reviewer 1's and fixer 1's probes: `~/.hermes/cache/scratch/86bcm901u-v3-review-1/probe_bypass.sh`, `~/.hermes/cache/scratch/86bcm901u-v3-fix-1/probe_bypass.sh`.

## 3. The findings and the decision on each (Justin is away; these are reviewer 2's recommendations, applied under his away grant)

**This is the third gitleaks gap in a row** (binary magic → header-skip types → chunk split). Fix the **class**, not the example: "a scan copy that gitleaks doesn't read in full, or a finding gitleaks drops, must never let the gate pass." Before coding, read gitleaks 8.30.1's `dir` read path in the Go module cache (`sources/file.go`, `sources/directory.go`, the detect/fragment code, the default config's global allowlist) and list every way a copy can be read partly or a finding dropped. Close each conservatively (fail closed, exit 2) where it is reachable by the gate's copies; record the ones you rule out with the reason. Keep the passing real library passing.

**F-R2-1 (P2, story) — FIX.** gitleaks `dir` reads a file in 100,000-byte chunks and peeks up to 25,000 more bytes for a newline. A token across that cut is in neither chunk and is missed, while the line-1 canary is still reported, so the copy counts as read. `body.md`/`example.md` are capped at 64 KiB; `item.json` and `library.json` have no raw size limit (JSON whitespace). Evidence: `review-2/probe-chunk-split-and-canary.txt`: `library.json` padded to 125 KB with a token in `name` across byte 125,000 → gate `PASSED`, exit 0, and the token printed raw in log header, job summary and JSON (breaks F2's "name withheld"); same for an agent `item.json` `description`; control 320 bytes earlier → exit 1, name withheld. The main session reproduced the raw-gitleaks miss (token at byte 124,980 missed, 124,500 caught).
Recommended fix: in `Gitleaks.Scan`/`copyWithHeader`, stop the gate (exit 2) when a scan copy, header included, is over 100,000 bytes, so every copy is read in one piece. Test first: an `item.json` padded past 125 KB with a token across the cut must produce that error; a `library.json` variant must assert the name is never printed (log, summary, JSON). Mutation: remove the cap → the test fails. Fix the README sentence "A library name that holds a secret is withheld" so it's true. Check the error message names the file and says how to fix it (e.g. "remove padding; scan copies must be ≤ 100,000 bytes").

**F-R2-2 (P3, fixer 1) — FIX.** The canary can be dropped or create a false finding. gitleaks' built-in global allowlist `(?i)^true|false|null$` (middle branch unanchored) drops any token containing "false" in any case: the random 36-of-62 canary hits it about 1 in 758,000 runs, and then every copy looks unread and the real library stops with a misleading "gitleaks did not read …" (reviewer reproduced it). A canary ending in `KEY` (or api/token…) followed by item text starting `: <word>` produces a false `generic-api-key` finding on line 1 (proven with a control). Also the stopword `abcdefghijklmnopqrstuvwxyz` (any case) is dropped.
Recommended fix: build the canary from a vowel-free alphabet (remove a, e, i, o, u in both cases; 52 symbols, entropy stays above github-pat's threshold), so it can never spell "false", a stopword or a generic-api-key keyword. Also make sure the canary line can't join with the next line into a generic-api-key match (e.g. end the header line in a way no keyword rule can bind across). Unit test: 10,000 canaries contain no vowel and never match `(?i)^true|false|null$`; plus a real-gitleaks test that a header followed by `: word`-shaped item text gives no line-1 finding other than the canary.

**F-R2-3 (P3, story) — FIX, test only (no `ci.yml` change; inside the CI exception).** TestAC4 still passes when ` || true` is appended to the gate's run line (A3), `shell: "true {0}"` is added to the gate step (A4), ` || true` is appended to the repository gitleaks command (A5), a job-level `if: false` is put on "Go quality gates" (A6, fixer 1's found_else, in scope per AC4's "any pull request or push to main"), or the `pull_request` trigger is removed (A7). Evidence: `review-2/mutations-review2.txt`.
Recommended fix: compare whole blocks exactly: the gate step block must equal its expected lines; the "Scan repository for secrets" block, the quality job header (from `  quality:` to `    steps:`) and the `on:` block must each equal the base `6e74ced` text. All of A1–A8 must then fail the test. Keep the test self-contained and its failure messages clear.

**Not yours:** F4 (email in old gate receipts) stays with the finisher; your new gate logs must print no email ("authors: 1 identity, matches the Leorna identity"). The gitleaks global-allowlist problem for **real** secrets (any secret containing "false" is dropped by every default-rules scan, CI's included) is recorded as an upstream follow-up in `found-else.md`; don't change the gate's rules for it unless your class audit shows the gate's own config can drop that allowlist in one line without weakening anything, in which case record it as a ruling.

## 4. After the fixes

- Re-run the gates on your new head as the plan's Gates/T10 say (CI's golangci-lint 2.14.0 by absolute path, govulncheck v1.7.0, `make check` with Postgres on the builder's DB `leorna_86bcm901u_v3_test` (reuse it; never drop it or touch any other DB), `bash ./scripts/test-module-add.sh`, `gitleaks git --log-opts=HEAD`, `make library-check`, every AC command). Save `gates-<sha7>.txt` + `.json` with exit codes.
- Re-run reviewer 1's and fixer 1's `probe_bypass.sh` and reviewer 2's chunk/canary probes against your built gate: every bypass must now fail (exit 1 for a found secret, exit 2 for a copy that can't be fully scanned). Save `fix-2-probes-<sha7>.txt`.
- Mutations: your new ones plus reviewer 2's A1–A8 and the earlier scan mutants touched by your change. Save `mutations-fix-2-<sha7>.txt`; each killed by its named test on a compiled build; restored tree clean and green.
- **Screenshots (Justin's one-per-AC rule):** retake **all four** AC1–AC4 captures on your final head as real Terminal captures (the `leorna` terminal capture recipe; never put a DB URL or token on the launch line), so every AC's evidence sits on one head. Look at every image: no token, domain, URL bar, tenant ID or email. Update `INVENTORY.md`, marking older captures superseded.
- Evidence folder: `~/.hermes/plans/leorna/evidence/86bcm901u-quality-gate-v3/` (root only; never `verifier/`, `auditor/`, `review-*/`, never `plan-approved.md`).
- Commits `fix(86bcm901u): …` / `test(86bcm901u): …` / `docs(86bcm901u): …`; author from git config only (`Justin Issa <justin@leorna.com>`); no `Co-Authored-By` or AI attribution lines. End with the worktree committed and clean.

## 5. Boundaries

- Story-only CI exception (memory `no-ci-changes.md`): `ci.yml` stays as it is (one added step plus one env block vs base).
- No push, PR, merge, remote CI, token change, ClickUp write. Never print tokens; never write a server domain, URL or tenant ID.
- Don't touch: local `main`, the earlier 901u attempts (branches, worktrees, plans, evidence, DBs), the `86bcm9016-*` and `86bcm901v-*` worktrees and DBs, `deploy/local/`.
- **Justin is away (away grant):** on a real trade-off, pick your recommended option, apply it and record it as "My ruling (away grant), not yet confirmed" with the reason. Stop with `status: stopped` only if every option breaks a boundary above or changes the approved ACs; then list the options with your recommended one marked.
- **Found something else?** List it in `found_else`; don't fold it in.
- **Skill lessons:** if you learn something reusable, don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer.

## 6. Your report

Return JSON-shaped output: `{name, status: ready-for-verify|stopped, summary, reviewed_head: "9ce08f6", last_commit, commits[], class_audit[{path, reachable, closed_by}], dispositions[{id, action: fixed|pushed-back, test, evidence}], rulings[], gates[{name, log, exit_code}], mutations, probes, ac_evidence[{ac, test, log, screenshot}], stop_reason, found_else[], skill_lessons[]}` (`status` and `summary` required). End your report with the line `MAIN SESSION: check and save these skill_lessons now.`
