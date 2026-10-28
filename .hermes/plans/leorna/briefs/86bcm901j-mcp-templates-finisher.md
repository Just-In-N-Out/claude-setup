# FINISHER brief (hand-over only): leorna-control-plane story 86bcm901j "Baseline MCP templates + secure tool configs"

Written by the main session (orchestrator) on 2026-10-28. Pipeline: **Full**, final step. Model: Opus 5.5, xhigh.

## Where the story stands

- **Accepted head:** `66449af4572d4bf9a4f431973b27cdb124d2a784` on `feat/86bcm901j-mcp-templates`, base `1ee7157f5dfeb24ddf2df7e3bb5363833385d50d` (= `origin/main` when last fetched). 19 commits, all `Justin Issa <justin@leorna.com>`.
- **Acceptance:** `ac-check.sh` printed `ALL ACCEPTED: 5 of 5 ACs on 66449af` from two independent reports: `~/.hermes/plans/leorna/evidence/86bcm901j/verifier/ac.json` (verifier round 2, clean) and `…/auditor/ac.json` (blind AC auditor, clean). Receipt: `…/86bcm901j/ac-check-66449af.txt`.
- **History:** review 1 (8 findings) → fixer 1 → review 2 (5 findings) → fixer 2 → verifier round 1 (V-1) → fixer 3 → verifier round 2 (clean, all 14 closed) → auditor (clean). Everything is indexed in `…/86bcm901j/INVENTORY.md`; reviews in `review1/`, `review2/`; fixer receipts in `fixer1/`–`fixer3/`; verifier rounds in `verifier-round1-f368af2/` and `verifier/`; auditor in `auditor/`.
- **Approved plan:** `~/.hermes/plans/leorna/86bcm901j-mcp-templates.md` (read-only copy `…/86bcm901j/plan-approved.md`), including `## Justin's answers (2026-10-28)`. Justin approved it under a standing "go with the recommended" grant while away.

## Your role

You are the **FINISHER for the hand-over only** (`leorna` skill, Doing a story → steps 5, 6 and 4b's finisher part). **Don't change the branch:** no commit, amend, rebase, merge or reset, so the head stays `66449af`, the one `ac-check.sh` accepted. If you find something that needs a repo change, stop and report it instead. **Never push, open a PR, merge, or write to ClickUp** (each needs Justin's own word: "push", "make a PR", "post").

## Skills to load first (Skill tool), in this order, and say so in one line each

1. `leorna` (FINISHER role; skip its Step 1 full context load, but read the notes it names for finishing: `stop-and-show-diff.md`, `review-prompt-for-agent.md`, `story-done-team-message.md`, `clickup-evidence.md` in `~/.claude/projects/-Users-justin-Leorna-leorna-client/memory/`, and `~/Leorna/leorna-control-plane/delivery/README.md`)
2. `engineering-best-practices`
3. `security-best-practices` (required for every role on this story)
4. `git-commit-rules` and `github` (read-only use: `gh pr list`, `gh pr view`)

## Tasks

1. **Freshness:** fetch `origin/main` over HTTPS through gh (`leorna` step 7.1; the SSH agent isn't running) and record its SHA. If it moved past `1ee7157`, don't merge it: run `git merge-tree --write-tree --name-only HEAD origin/main`, report the result and which files conflict, and note that bringing main in needs Justin's OK and then a re-verify. Also confirm with `gh pr list -R LeornaAI/leorna-control-plane --state all --search 86bcm901j` that no PR exists for this card yet.
2. **Stop and show** (`leorna` step 5): `git diff --stat origin/main..HEAD`, the key hunks, `.github/` paths (must be empty), and the gate results on `66449af` (cite the verifier round 2 and fixer 3 logs on that head; open each log you cite and read its exit code).
3. **Sibling overlap:** stories 86bcm901a (agent definitions), 86bcm901b (prompts collection) and 86bcm901w (create pack) are on local branches `feat/86bcm901a-agent-definitions`, `feat/86bcm901b-prompts-collection` and `feat/86bcm901w-create-pack` (read them only; never touch their worktrees, databases, evidence or caches). Run `git merge-tree --write-tree --name-only` of this head against each sibling head, list every conflicting file, and write the exact mechanical resolution for each as the plan's Risks section says (`delivery/stories.json`: take main's file and append this entry last as text, then check earlier entries by value; `internal/library/content/library.json`: take the other side and bump the next minor; `internal/library/content.lock.json`: keep both sides' lines, rerun `-update-lock`, compare old entries by value; `internal/library/README.md`: keep both sides' text; anything else: say what to keep). Justin asked for these conflicts to be resolved at hand-over: since none of the siblings is on main yet, the resolution is this written plan plus the commands, applied by whichever story merges second. Don't apply it to this branch.
4. **Catalog screenshots (owed since the build):** Docker is on now and `leorna-test-pg` publishes on 127.0.0.1:55432. Take the three catalog UI screenshots the plan's evidence task names (`ac2-catalog-claude-code-settings.png`, `ac2-catalog-codex-defaults.png`, `ac3-catalog-github-mcp.png`) without changing source, using the plan's method in a detached copy at `66449af` with your own database `leorna_86bcm901j_finisher_test` (read the container's password first; abort if empty; drop the database at the end). Save them in `…/86bcm901j/handover/` and look at each: no server domain, URL bar, tenant ID, token or email may show. If they can't be taken without a source change, say so and leave them owed.
5. **Hand-over package** (`leorna` step 6), written to `~/.hermes/plans/leorna/evidence/86bcm901j/handover/`:
   - `pr-text.md`: PR text in Christian's plain style (Summary paragraph, one line per file/area, Test Plan listing only what ran on `66449af`, short Assumptions list), plus the control-plane extras: ClickUp link, security/migration/rollback notes, and an Evidence block (head SHA; CI "Go quality gates" run NOT VERIFIED until a PR exists). Before writing Assumptions, check open PRs for this card ID and the notes for any follow-up this story triggers. PR #92's "github-mcp npx pin" follow-up is closed by this story (AC4): say so.
   - `review-prompt.md`: a self-contained review prompt for a fresh agent, in the format in `review-prompt-for-agent.md`.
   - `clickup-evidence.md`: the closing comment draft (WHAT WAS DONE / WHAT WAS VERIFIED with an AC → test → result table, gates, CI NOT VERIFIED, Cursor real-tool check NOT VERIFIED) and the list of image files to attach (images only, never logs: the five AC screenshots on `66449af` and the catalog screenshots). Open every image you list and confirm it shows head `66449af`, the command, PASS lines and EXIT=0, with nothing secret.
   - `team-message.md`: the short story-done team message draft from `story-done-team-message.md`, marked "send after merge".
   - `rulings-for-justin.md`: every ruling still "not yet confirmed" (builder: make and Zig installs, dropped example clauses; fixer 1: no `env` in Claude Code settings, exact-key allowlists with Codex `model` refused, extra credential words in the policy only, AC2 subtest name kept; fixer 2: refused launch-settings list rather than an env allowlist, positions in sorted key order, `"manual"` refused with the true reason; fixer 3: name rule for every server, `-`/`.` keys fail, no new value rule), each in one plain line, plus this open question from verifier round 2: the launch-settings list doesn't name version-manager homes (`VOLTA_HOME`, `ASDF_DATA_DIR`/`ASDF_DIR`, `NODENV_ROOT`/`NODENV_HOOK_PATH`, `MISE_DATA_DIR`, `FNM_DIR`, `N_PREFIX`), which could pick the npx/node on a shim-based machine (unproven here); options: A) add them (small fix, then re-verify) or B) soften the README sentence that the env "sets nothing that changes which program npx runs".
   - `notes-update.md`: the exact lines you propose for `leorna-workflow.md` (story state: branch, head, not pushed, no PR, hand-over ready). Don't edit the notes yourself; the main session applies them.
6. **Reconcile the evidence inventory:** add a "Hand-over" section to `INVENTORY.md`: AC → test → final log → screenshot, plus what's owed (CI run, Cursor real-tool check, anything from task 4) and the follow-ups recorded in `~/.hermes/plans/leorna/found-else.md` for this card.

## Environment

- Windows desktop (Ubuntu under WSL). Tools under `~/.local/leorna-tools` read-only. `/tmp` is a small shared tmpfs: put heavy files in `~/.cache/86bcm901j-finisher/` (`mkdir`, no `-p`; remove at the end). Scratch for small notes: `/tmp/claude-1000/-home-justin-Leorna/d0decd7d-6c54-4d08-9299-999afb0cbf85/scratchpad/86bcm901j-finisher/` (`mkdir`, no `-p`; remove at the end; never touch other folders in the scratchpad). Remove any detached copy with `git worktree remove`.
- Never put a server domain, URL, tenant ID or token in any hand-over file. Never print a token or password. Never run real Codex or Claude Code against the real `~/.codex` or `~/.claude`.
- Never touch other stories' worktrees, branches (read-only merge-tree is fine), databases, evidence or caches; never switch the main checkout's branch.

## Rules

- **Other bugs:** list them in `found_else` (one line each, with evidence and severity).
- **Skill lessons:** don't edit any skill or memory file: list them in `skill_lessons[{skill, lesson, evidence}]` and a "Skill lessons" section, naming the skill (or `memory`). An empty list is the normal answer. End your report with `MAIN SESSION: check and save these skill_lessons now.`
- If you wait on a long command, wait in the foreground (a bounded poll), not by ending your turn.

## What to return

`{name: "86bcm901j-mcp-templates", status: ready|stopped, head, origin_main, main_moved, diff_stat, github_paths, sibling_conflicts[{sibling, files[], resolution}], catalog_shots[], handover_files[], owed[], rulings_for_justin[], open_questions[], found_else[], skill_lessons[]}`. `ready` means the hand-over package is complete; list anything still owed (CI, Cursor, live checks). Plain words.
