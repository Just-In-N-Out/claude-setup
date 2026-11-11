# PLANNER brief: go-1274-toolchain-bump (no ClickUp card)

**Role:** PLANNER for a Leorna job, pipeline **Mini**. Write a short plan Justin will approve; don't build anything: no worktree, branch, code or commit. **Model:** Fable 5.2, effort high.

## The ask (rewritten)

Move both Leorna Go repos (`~/Leorna/leorna-client` and `~/Leorna/leorna-control-plane`) to Go **1.27.4**, so the standard-library advisory **GO-2026-6859** (net/http in go1.27.3, fixed in 1.27.4) stops failing `make audit` (govulncheck) locally and in CI. Today both repos pin go1.27.3 (`go.mod` / `go.work`), and CI's setup-go reads `go-version-file: go.work`, so `make audit` is red on `main` in both repos and on every PR until this lands. Done = `make audit` passes on the new head in both repos, every other gate still passes, and CI will pick up 1.27.4 from the files it already reads.

There is **no ClickUp card**: the plan is `~/.hermes/plans/leorna/go-1274-toolchain-bump.md`, the branch `feat/go-1274-toolchain-bump` in each repo, and the PR texts say there is no card (under Assumptions).

**Justin's words:** while running story 86bcxnymy, he was told GO-2026-6859 makes `make audit` fail on main in both repos and asked "Start it as a separate job?"; he answered "Yes, separate job", picked "Mini" and "No card".

Evidence that the advisory fails on base: `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/control-plane/fix-1/gates-audit-base.log` and `~/.hermes/plans/leorna/evidence/86bcxnymy-client-self-update/builder/audit-base-a7839b3.log`.

## How to work

1. Load skills and say so: `leorna` (PLANNER role), `engineering-best-practices`, `implementation-planning`. **Mini mode:** load the project skill and only the code/docs sections this touches; skip the full Step 1 context load; finish within about 15 steps. If this is bigger or riskier than a Mini job, say so in `summary` and recommend Full.
2. Base: fetch GitHub `main` for both repos over HTTPS through gh (the `leorna` skill's step 7.1 command) and record each SHA. Don't fast-forward the main checkouts. Search with `git grep` in the main checkout, not `grep -r .`.
3. Find every place the Go version is pinned in each repo: `go.mod` `go`/`toolchain` lines (every module, including workspace modules such as the control plane's `packages/contracts`), `go.work`, Dockerfiles or build scripts with a Go image/version, docs naming the version, and `.github/workflows/*` (setup-go `go-version` / `go-version-file`). **`.github/` is off limits by default** (the `leorna` skill's CI rule; `no-ci-changes.md`): if CI reads the version only from `go.work`/`go.mod`, no workflow change is needed. If a workflow pins the version itself, make that a lettered question for Justin (a story-specific CI exception), with the recommended option marked.
4. Check that go1.27.4 is real and available here: the desktop's Go is at `~/.local/leorna-toolchain/go` (`go version`), and Windows Go is at `C:\Program Files\Go\bin\go.exe`; say how the builder gets 1.27.4 locally (GOTOOLCHAIN download or an install into the role's own folder; never change the shared toolchain without saying so), and whether `govulncheck` then reports clean.
5. Name sibling work that might clash: open PRs and local `feat/` branches in both repos that touch `go.mod`/`go.work` (e.g. story 86bcxnymy's branches `feat/86bcxnymy-client-self-update` in both repos, which list `x/sys` and `yaml.v3` as direct requirements in the client's `go.mod`).

## The plan (short Mini form)

Save it to `~/.hermes/plans/leorna/go-1274-toolchain-bump.md`: questions at the top (if any, each with lettered options and the recommended one marked; write the plan as if the recommended options were chosen), playback, base SHAs, the files to change per repo, numbered ACs (AC1, AC2… never AC1a), each **proposed** (there is no card) with one named test or check each, whole on one line (for example `make audit` passing on the head with the run's log as the check, and the full gates still passing), the plan for proving each AC fails on the base, a one-line Docs & records task (PR texts, `leorna-workflow.md` status line; `delivery/stories.json` only if the repo's gate requires an entry for card-less work: check it), and an "Other things found" section.

## Rules

- You can't ask Justin anything: questions go in `questions`.
- Never send a server domain, URL or tenant ID anywhere; never print tokens.
- If you find another bug or problem, list it in `found_else` (one line each, with evidence and severity).
- **skill_lessons:** if you learn something reusable (a gotcha, an approach that worked after one failed, a skill step that was wrong, missing or stale), don't edit any skill or memory file: list it in `skill_lessons[{skill, lesson, evidence, enforce}]` and a 'Skill lessons' section of your report, naming the skill (or `memory`). `enforce` is `none`, or, when the lesson is about a rule that was broken or nearly broken, a one-line proposal for a check that would have caught it (kind, what it checks, where it runs). An empty list is the normal answer.
- **Runaway memory (Windows desktop):** a command that dies with SIGTERM, exit 143/137 or "Killed" may be an earlyoom kill: check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'` before reading it as a result, and rerun under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`.

## Return

`{name, plan_path, playback, summary, choices[], questions[{q, options[], recommended}], risks[], touches[], overlaps, found_else[], skill_lessons[]}` plus `verdict` (`plan-ready` or `blocked`) and `ac_status` (each AC `not_run`). End with `MAIN SESSION: check and save these skill_lessons now.`
