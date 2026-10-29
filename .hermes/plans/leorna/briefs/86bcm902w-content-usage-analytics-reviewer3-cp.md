
# REVIEWER 3 (review only, delta) — leorna-control-plane, story 86bcm902w "Content usage analytics (which items get used)"

Role: round 3 of the review loop for the **control plane**: a **delta** review of the commits added since review 2's clean head. You are a fresh agent: you never saw the build, the earlier reviews or the fixes. Report only: change no source. Mechanics: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/review-loop.md` ("The reviewer's duties", "Records"); severity scale: `review-fix-cadence`.

## What to review
- Worktree `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics`, branch `feat/86bcm902w-content-usage-analytics` (= **PR #103**, open). Confirm the head is **`fabbec00fa8428bf7e014ba06350efe796002c1c`** (and equals `gh pr view 103 -R LeornaAI/leorna-control-plane --json headRefOid`) and the worktree is clean.
- Previous clean review: review 2 at **`de5fbe0755a41e0528815ef3b72509aeadb20c3c`** (full, from `b65f797`). The delta `de5fbe0..fabbec0` is two commits:
  - `b78905b`: `Merge branch 'main' into feat/86bcm902w-content-usage-analytics`, bringing in GitHub `main` **`8aa32a1`** (PR #101 quick start and PR #102 role-based starter packs). Only `delivery/stories.json` was hand-resolved (main's file + this story's entry appended last); `README.md` and `internal/web/handler.go` merged cleanly by git.
  - `fabbec0`: records PR #103 and client PR #23 in `delivery/stories.json`.
- **Scope:** the merge's resolution and everything where main's new code meets this story. Main's own changes (#101, #102) were reviewed and merged on their own PRs: don't review them for their own sake. In scope in particular:
  - the three both-sides files (`README.md`, `delivery/stories.json`, `internal/web/handler.go`): nothing from either side lost (routes, nav links, sections, every earlier stories.json entry unchanged by value and order);
  - no evil merge (files differing from both parents equal the both-sides set) and no duplicated migration version;
  - **interaction:** #102's role starter packs are shared pack versions with no tenant, like the seed. Check how the content usage page now shows them under Justin's rule ("Company's own pack wins": for each pack name the company's newest version, and the shared version only when the company has none), that counts per pack and per item stay right when an item sits in a starter pack too, and that #101's quick start (assigning a pack to a team) changes nothing the page relies on;
  - the stories.json record: the format main uses for two-repo stories, and that `python3 -m unittest discover -s scripts -p 'test_story_shippable.py'` passes.
  Anything else you notice outside this scope is P3.
- The PR finisher's records (claims to check, not facts): `~/.hermes/plans/leorna/evidence/86bcm902w/pr/` (gate logs, `SUMMARY.txt`, `resolve-stories.py.txt`) and the dated merge-proof section of `~/.hermes/plans/leorna/86bcm902w-handover/integration.md`.
- Earlier rounds: `~/.hermes/plans/leorna/evidence/86bcm902w/review-1/review.json`, `review-2/review.json` (and the follow-up list `follow-ups.md`). A finding that is the same defect as an earlier one sets `repeats` (with `new_fact` when you have one).
- Approved plan (read-only): `~/.hermes/plans/leorna/evidence/86bcm902w/plan-approved.md`; Justin's later pack-row rule is in the working plan `~/.hermes/plans/leorna/86bcm902w-content-usage-analytics.md`, section "Justin's answer after review 1".

## Skills (load them first and say so)
`leorna` (reviewer rules; read step 7.2's merge-proof rules), `engineering-best-practices`, `requesting-code-review` and `code-review-practice` (report only), `review-fix-cadence`, `mutation-testing-discipline`, `multi-tenant-auth-management`, `backend-data-migrations`. Skip `requesting-code-review`'s "independent reviewer subagent" and auto-fix steps: you are the fresh reviewer, and you can't start agents.

## Gates you run yourself (on `fabbec0`)
`make check` with `LEORNA_TEST_DATABASE_URL` on your own disposable DB `leorna_86bcm902w_review3_test` in `leorna-test-pg` (read the port with `docker port leorna-test-pg 5432`; never `leorna-pg`, never another role's DB) and `LEORNA_TEST_CLICKHOUSE_URL` on the ClickHouse test container `leorna-test-ch-86bcm902w` at `127.0.0.1:18123`: if it isn't running, start it exactly as the approved plan's T0.5 says (same pinned image, name and port) and **leave it running** for the verifier; start no other container. Also `bash ./scripts/test-module-add.sh`, CI's pinned golangci-lint 2.14.0 and govulncheck v1.7.0 (in `~/.local/leorna-toolchain`) bound through `GOLANGCI_LINT=`/`GOVULNCHECK=`, each AC test by name, the story-shippable unittest, and the `go test -json` check that the Postgres and ClickHouse tests really ran. **Keep `/usr/local/bin` on any PATH you narrow** (gitleaks lives only there; without it item-editor tests fail with 503 "secret scanner unavailable"). Where a merge claim rests on a test, try a mutation in your own detached copy or with `go test -overlay`.

## Your record (the referee's input)
- Write `~/.hermes/plans/leorna/evidence/86bcm902w/review-3/review.json`: `"round": 3, "scope": "delta", "from": "de5fbe0755a41e0528815ef3b72509aeadb20c3c", "head": "fabbec00fa8428bf7e014ba06350efe796002c1c"`, ids `R3-<k>`, every P0–P2 with a concrete real-use `scenario` of 5+ words (an empty list when clean).
- Self-check: `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/scripts/review-check.sh --repo /home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bcm902w-content-usage-analytics --base 8aa32a1f68fadacb8b0514566dd465ff14b883b9 ~/.hermes/plans/leorna/evidence/86bcm902w`. Exit 2 means your file is wrong: fix it. Exit 0, 1 or 3 is the referee's verdict, not yours to act on.

## Boundaries
- Change nothing in the worktree or on GitHub: no edits, commits, pushes, PR edits, merges or ClickUp writes. Mutations only in your own detached copies (`git -C <worktree> worktree add --detach ~/.cache/86bcm902w-review3/<name> <sha>`), each removed with `git worktree remove --force` on its exact path. **Never run `git worktree prune`.**
- Write only in `~/.hermes/plans/leorna/evidence/86bcm902w/review-3/` (create it) and your own scratch: a fresh `<scratchpad>/86bcm902w-review3/` (`mkdir` without `-p`) for small files; Go `TMPDIR`, binaries and copies in `~/.cache/86bcm902w-review3/` (`/tmp` is a small shared RAM tmpfs). Remove only your own folders by literal absolute path and drop your DB at the end.
- The client worktree is being fixed by another agent right now: don't read or touch it.
- Never touch other stories' worktrees, branches, DBs or evidence.
- A Claude Code foreground command moves to the background after about 180 s. Don't end your turn to wait: poll its log in the foreground in waits under 3 minutes (a bounded `node -e` poll; foreground `sleep` is refused).

## Rules for every role
- If you find any other bug or problem outside this scope, don't fold it into findings: list it in `found_else` (one line each, with evidence and severity).
- If you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file. List it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a "Skill lessons" section, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it: its kind (Claude Code hook, git hook, test, lint, script), what it checks and where it runs. An empty list is the normal answer.

## Output (your final message)
`{verdict: clean|findings, reviewed_head, findings[{id, severity: P0|P1|P2|P3, file_line, claim, scenario, repeats, new_fact, evidence, suggested_fix}], merge_checks{both_sides_kept, evil_merge, migrations_dup, stories_json}, interaction_with_starter_packs, ac_status[{ac, accepted, test, screenshot, evidence}], gates[{gate, exit, log}], review_json, self_check, found_else[], skill_lessons[]}`. Then a short plain summary. End with `MAIN SESSION: check and save these skill_lessons now.`
