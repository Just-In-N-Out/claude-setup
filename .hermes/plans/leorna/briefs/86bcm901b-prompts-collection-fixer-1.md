# FIXER 1 brief: 86bcm901b-prompts-collection [leorna]

**Role:** FIXER 1 (intermediate fix pass) for the Leorna story "86bcm901b-prompts-collection", Full pipeline. You are a fresh agent. Verify each of reviewer 1's findings, fix the valid ones test-first, push back with evidence on the rest, re-run the gates, commit, and **stop at `ready-for-next-review`**. After you: a fresh reviewer 2 of the whole corrected feature, a fixer, a verifier and a blind AC auditor. No hand-over work in this pass.

**Machine:** Justin's Windows desktop (WSL Ubuntu 26.04, `/home/justin`), not the Mac. Mac-only recipes in the skills don't apply.

## Skills to load first, in this order (say so in your first steps)

1. `leorna` (FINISHER role for the fix pass, with its Step 1 context load for the control plane).
2. `engineering-best-practices`.
3. `receiving-code-review`: verify each finding before fixing it.
4. `test-driven-development`: a failing test before each change.
5. `git-commit-rules`.
6. `security-best-practices` (untrusted upstream TOML) and `mutation-testing-discipline` (F2 is about guard tests; its item 4 now covers F1's class).

Also `systematic-debugging` whenever a test fails unexpectedly.

## Inputs

- **Worktree:** `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm901b-prompts-collection`, branch `feat/86bcm901b-prompts-collection`, reviewed head **`78f13a7605e72735c2be6b7461422c1926048650`**, base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d`.
- **Plan:** `/home/justin/.hermes/plans/leorna/86bcm901b-prompts-collection.md` (read-only approved copy: `evidence/86bcm901b/plan-approved.md`). Its "Justin's answers (2026-10-28)" section now also holds the **Review 1 F4 ruling** (below).
- **Reviewer 1's full report:** `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/review-1/report.md`, with its receipts, probes and mutation scripts in `review-1/` and `review-1/tools/`. Use its probes and mutants to prove each fix (RED before, killed after).

## Reviewer 1's findings (verbatim in substance; verify each)

**F1 (minor, introduced): the command-file key guard accepts case-variant keys, and the import result is then random.** `internal/library/upstream/layout.go:203-209`: `transformPrompt` decodes into a struct, then checks `Undecoded()` and `IsDefined`. BurntSushi/toml v1.6.0 `decode.go:307-319` matches struct fields with a `strings.EqualFold` fallback and marks the variant decoded, ranging over a map in random order. Probe `review-1/probe-case-keys.log`: `description = "d"`, `prompt = "benign"`, `Prompt = "other"` refused 0/200; body `benign` 23, `other` 177; `DESCRIPTION` beside `description` 30/170. Breaks plan D2 (exactly `description` and `prompt`, anything else refused) and `README.md:271-276` ("refused rather than guessed"). **Fix the class, not the two examples:** the guard must accept exactly the key set {`description`, `prompt`}, both strings, and refuse every other key however it differs (case variants, extra keys, tables, arrays). Suggested: `len(metadata.Keys()) == 2` plus the existing checks, or decode into a map and require the exact set. Add RED-first cases to `TestTransformRefusesMalformedCommands` at least for a case-variant `prompt` key and a case-variant `description` key, and confirm the reviewer's probe now refuses 200/200. Check whether any other decode this story added (TOML or JSON, e.g. the `requires` field in item.json, `curation.json`) has the same loose-matching gap; fix it in the same way if it does, or say why not.

**F2 (minor, introduced): three guard mutants survive.** R1: `len(requires) >= MaxRequires` at `library.go:261` (no test accepts exactly 32; `requires_test.go:54` uses 33). R2: widening the kind check at `library.go:267` to also accept `prompt/<name>` (no negative case names a prompt). R3: dropping the description length bound at `layout.go:213` (equivalent end to end via `Item.Validate`, but the README credits `Transform` with it and no test proves it). Add: 32 distinct sorted refs asserting the existence error and not the count error; `["prompt/x"]` expecting "requires entries must be skill/<name> or agent/<name>"; a 2001-rune description expecting "the command description must be one line". Re-run R1–R3 (from `review-1/tools/`, via `go test -overlay`) and show each is now KILLED by the intended test.

**F3 (nit, introduced): a TOML-escaped NUL gets past the prompt transform, and the eventual refusal message is misleading.** The NUL/UTF-8 check runs on the raw text before decoding (`layout.go:139-141`), so a TOML escape for NUL inside `prompt` comes out of `transformPrompt` with a NUL in the body (probe: `err=<nil> body="p\x00q"`); the import is still refused later, but with "body.md must be non-empty and at most 64 KiB" (`library.go:221-223`). Apply the check to the decoded strings (description and prompt) too, and add an "an escaped NUL" case (and an escaped-NUL description case).

**F4 (nit, introduced): `/ship`'s fallback is described more strongly than the prompt supports.** `curation.json` (entry `prompt/ship`, about line 626) says "the prompt's own fallback applies: the assistant runs the three reviews itself in the main session"; `items/prompt/ship/example.md` says "as the prompt describes". The body's fallback covers only "If subagents are unavailable in the current CLI version, invoke each persona's system prompt sequentially". **Main-session ruling under Justin's away grant (recorded in the plan):** correct both texts so they say only what the body says (the fallback covers a CLI without subagents; what Claude Code does with `/ship` isn't verified by this story). If a test, the lock file or a checksum pins `example.md`, update it through the repo's own tooling and keep every AC test green.

**F5 (nit, introduced): the constraints review cites a ruling that has no record.** `curation.json` (entry `prompt/constraints`, about line 572) ends with "(the plan's sample-config ruling for this prompt)". Cite the rule that exists (86bcm9019's safety rule in the library README checklist: a one-off tool the user asks for is accepted) or drop the parenthetical.

Push back with evidence if you find a finding invalid; don't make edits a finding doesn't need. Keep every existing behaviour the plan approved.

## Gates and evidence

- After the fixes, run the full gates on your final head exactly as the builder did (`evidence/86bcm901b/builder-tools/gates.sh` and `INVENTORY.md`: `make -s check` with the `GOLANGCI_LINT`, `GOVULNCHECK`, `GITLEAKS` bindings, `scripts/test-module-add.sh`, the `go test -json -run WithPostgres` per-test read, the stories unittest, branch gitleaks, no `.github` change, clean tree), plus the four AC tests on the final head. The worktree must end clean.
- Write your logs to `/home/justin/.hermes/plans/leorna/evidence/86bcm901b/fix-1/` (`gates-<sha7>.txt`, `ac-<sha7>.log`, `mutations-fix1-<sha7>.txt`, probe logs). Don't edit the builder's files or `review-1/`, and never write in `verifier/` or `auditor/`. Refreshing the AC screenshots for the final head is the finisher's job, not yours.
- **Environment:** `export PATH=$HOME/.cache/leorna-86bcm901b/go/bin:$HOME/.cache/leorna-86bcm901b/bin:/usr/local/bin:/usr/bin:/bin GOTOOLCHAIN=local` (Go, make, gcc wrapper, golangci-lint, govulncheck are there). PostgreSQL 18.6 runs on 127.0.0.1:55400 (`~/.cache/leorna-86bcm901b/pg/pg.env`, password in `pg/password`); use or create databases named `leorna_86bcm901b_fix1_*_test` and drop any you create. Never print the password or a DB URL. Never touch any sibling story's database.
- **Shell gotcha:** in this Bash tool `grep` is a function running Claude Code's ugrep: it skips gitignored and binary files, and bounded repeats like `.\{0,200\}` fail. Use `command grep` in gate scripts.

## Boundaries

- Commits `fix(86bcm901b): …` or `test(86bcm901b): …`. Let git use the repo identity (`Justin Issa <justin@leorna.com>`); never `-c user.*`, `--author` or AI attribution lines. Never commit a `CLAUDE.md`.
- Never push, open a PR, merge or write to ClickUp. Don't touch the main checkout at `~/Leorna/leorna-control-plane` (no checkout, pull, reset or edits) or any sibling story's worktree, branch, database or evidence (86bcm901a, 86bcm901j, 86bcm901w). Don't do hand-over work (sibling merges, `stories.json` PR number, PR text).
- Scratch: `/tmp/claude-1000/-home-justin-Leorna/b389a035-8205-4322-8956-053806a4a6b1/scratchpad/86bcm901b-fixer-1/`, created fresh with `mkdir` (no `-p`); never touch other folders there; remove yours at the end.
- You can't ask Justin anything and can't start other agents. A real trade-off: make the ruling, write "My ruling, not yet confirmed" in `rulings[]` and in your own section of `evidence/86bcm901b/INVENTORY.md`. If a fix needs a design change outside the plan, stop with `status: stopped` and the options.
- Don't write a report file (Claude Code refuses report files from subagents): return the report as your final message.
- Other bugs: `found_else` (one line each, evidence, severity). Reusable lessons: don't edit any skill or memory file; list them in `skill_lessons[{skill, lesson, evidence}]` (an empty list is normal) and end your report with the line `MAIN SESSION: check and save these skill_lessons now.`

## Output (final message)

JSON matching `{status: ready-for-next-review|stopped, summary, reviewed_head, new_head, commits[], dispositions[{id, verdict: fixed|pushback, test, evidence}], gates[{name, exit}], ac_logs[{ac, log, result}], mutations[], rulings[], stop_reason, found_else[], skill_lessons[]}`. `status` and `summary` are required.
