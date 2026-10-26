# Connect Claude Code to Leorna's ClickUp via MCP

## Context
Justin wants to work on a ClickUp user story and first needs Claude Code connected to the Leorna ClickUp workspace over MCP.

What I checked:
- Claude Code has no MCP servers configured: there's nothing in `~/.claude.json` (global or the `~/Leorna*` projects) and no `.mcp.json` in either repo.
- Hermes reads ClickUp through its own connector (`justin@leorna.com`, Leorna workspace `90141510532`, per `leorna-workflow.md:131`). Claude Code can't reuse it.
- The Leorna product has no MCP endpoint of its own. Its "mcp" code is pack content it hands out to tools. So "connect to Leorna via MCP" means connecting to ClickUp's Leorna workspace.
- ClickUp has an official remote MCP server for Claude Code at `https://mcp.clickup.com/mcp`. It signs in through the browser (OAuth), so no API token has to be stored.

## Steps
1. **Add the server (I run this):**
   `claude mcp add --transport http --scope user clickup https://mcp.clickup.com/mcp`
   - It's user scope because Leorna sessions start in several folders (`~/Leorna`, each repo, worktrees). Local scope would only cover one of them.
   - Then I run `claude mcp get clickup` to check it was added. It will show "needs authentication" until step 2 is done.
2. **Sign in (Justin does this, it's an interactive browser flow):**
   - Type `/mcp`, pick `clickup`, then Authenticate.
   - In the browser, sign in as **justin@leorna.com** and allow access to the **Leorna** workspace.
   - If `clickup` isn't listed in `/mcp`, restart with `claude --continue` and run `/mcp` again.
3. **Check it's the right account (read-only, I do this):**
   - Load the ClickUp tools and list the workspaces. Confirm the workspace is `90141510532`.
   - Use the find-member tool on `justin@leorna.com` to confirm the account, as the `leorna` skill describes under "Which account is connected".
   - If it's the wrong account or workspace, stop and tell Justin. Don't work around it.
4. **Record it in shared memory (standing OK from the `leorna` skill):**
   - Add a dated line to `leorna-workflow.md` near line 131: Claude Code reads ClickUp through the official `clickup` MCP server (user scope, signed in as justin@leorna.com).
   - Update its one-line entry in `MEMORY.md` if needed.
5. **Then the story:** Justin gives the card ID, or I list his PI-2 cards with whether each is ready.
   - I read the card: description, acceptance criteria, Verify, DoD.
   - Per the `leorna` skill, I send a short plan and **wait for "go"** before any branch or code.

## Rules that apply
- **Read-only in ClickUp:** no status, comment or assignee writes unless Justin asks. The closing evidence is posted only when he says "post".
- **Privacy:** no server domains, tenant IDs or tokens in chat.

## Verification
- `claude mcp get clickup` shows the server connected after sign-in.
- A live ClickUp read returns workspace `90141510532`, and `justin@leorna.com` resolves to a member.
- Reading one real card by ID returns its full text.
