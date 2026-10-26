# 86bbu3xfw — last fix, push, get ready to merge

## Context
The Claude Code transformer (86bbu3xfw) is built. Branch
`feat/86bbu3xfw-claude-code-transformer` has 7 local commits on `origin/main`
`0b453fe`. The second review found one real problem, which I confirmed in the
docs: `toolconnector/claudecode/README.md` says the Claude Code docs describe
`${NAME}` expansion "only for MCP servers". That's false. The skills docs
describe `${CLAUDE_PROJECT_DIR}`, `${CLAUDE_SESSION_ID}` and others, and the
settings reference shows `${TOKEN}` in marketplace `headers`. Everything else
passed review. After the fix round: `make check` exit 0, UI tests 10/10, lint 0
issues, govulncheck clean, and the real-Claude test passed on 2.1.283.
Justin asked to push and get ready to merge.

## Steps
1. **Fix the sentence** in `toolconnector/claudecode/README.md` ("Placeholders"
   paragraph) to: "Settings values are written exactly as authored,
   placeholders included; the Claude Code docs describe no `${NAME}` expansion
   for `$schema`, `permissions`, `env` or `model`." Check with grep that no other
   README line makes the "only for MCP" claim.
   Commit: `docs(86bbu3xfw): narrow the settings placeholder statement`
   (plain `git commit`, no AI lines).
2. **Re-run the gate** (docs only, but confirm):
   `make check`, `node --test scripts/*-ui.test.cjs`, `make lint audit`, and
   `LEORNA_TEST_CLAUDE_BIN="$(command -v claude)" go test -mod=vendor -count=1 ./toolconnector/claudecode -run TestClaudeReadsGoldenConfig -v`.
   Confirm `git status` is clean, `origin/main` is still `0b453fe`, and all 8
   commits are by `Justin Issa <justin@leorna.com>`.
3. **Push** (approving this plan authorizes it):
   `git push -u origin feat/86bbu3xfw-claude-code-transformer`.
   If it fails with "Permission denied (publickey)", Justin runs
   `! ssh-add --apple-use-keychain ~/.ssh/id_ed25519_leorna` and I retry.
4. **Stop and hand over** (I don't open or merge the PR):
   - updated paste-ready PR text: add the `blockReadsOutsideWorkingDirectories`
     fix, the "writer must merge" assumption, and follow-ups (ApplyConfig
     follows symlinks and replaces whole files → writer story);
   - the compare link to open the PR on `LeornaAI/leorna-client`.

## After the PR opens (Justin's steps; I help when asked)
- Wait for PR CI "Go quality gates" and the Windows job to be green.
- AGENTS.md: the AI reviews are not human approvals. Say so in the PR. Per
  Christian (2026-09-21), Justin may merge his own PR once the story is fully
  validated; client `main` has no branch protection.
- After merge, check that CI on `main` is green, and record which test proves
  each AC with the commit.
- Control plane: add `"86bbu3xfw": {"name": "Claude Code config transformer", "prs": {"LeornaAI/leorna-client": [<PR#>]}}`
  to `delivery/stories.json` in a small control-plane PR. After both merge, run
  `python3 scripts/check-story-shippable.py 86bbu3xfw`, then mark ClickUp.
- Paste the short team message with the PR and ClickUp links.

## Verification
Gate commands in step 2. The pushed branch head must equal the local HEAD:
`git ls-remote origin feat/86bbu3xfw-claude-code-transformer`.
