# Windows desktop: Claude Code in WSL2 Ubuntu

Read `~/.github/README.md` first. It covers what syncs, the rules, and the daily flow.

**Why Ubuntu:** Justin's hooks, `ac-check.sh` and `update-skills-library.sh` are bash and rely on symlinks. Ubuntu runs them unchanged; native Windows can't.

**Where things live:**
- Claude Code, every project and the whole setup live **inside Ubuntu**, under `/home/justin`. Never under `/mnt/c`, which is slow and has the wrong permissions.
- Windows File Explorer shows the Ubuntu files under **Linux → Ubuntu → home → justin**.

## Every day

1. **Open a project from VS Code,** with Microsoft's **WSL** extension installed. Either:
   - click the **><** button in the bottom-left corner, choose **Connect to WSL**, then open the folder (e.g. `~/Leorna/leorna-client`); or
   - from an Ubuntu terminal, run `cd ~/Leorna/leorna-client && code .`

   VS Code starts Ubuntu by itself. The recent list remembers WSL folders.
2. **Check it's right:**
   - the bottom-left corner says **WSL: Ubuntu**;
   - the terminal prompt looks like `justin@DESKTOP:~/Leorna/leorna-client$`.

   If the terminal says `PS C:\…>`, the folder was opened as a plain Windows folder. Claude would then run on Windows without the hooks or sync. Close it and reopen through WSL.
3. **In the VS Code terminal, type `claude`.** Claude doesn't start by itself.
4. **Sync:** Claude runs `~/.claude/setup/sync.sh pull` before plans, and `~/.claude/setup/sync.sh` after editing synced files (rules in `~/.claude/CLAUDE.md`). You can run them yourself any time.
5. **When you close VS Code,** Ubuntu shuts down by itself after a little while.

## First-time setup

The **[Justin]** steps need admin rights, a reboot, a browser or a GUI. The agent does everything else and explains each step first.

### Part 1: Windows (PowerShell, or Claude running on Windows before Ubuntu exists)

1. **[Justin]** Check that Windows is 10 22H2+ or 11, then run in **PowerShell as Administrator**:
   `wsl --install -d Ubuntu`
   Then reboot.
2. **[Justin]** After the reboot, Ubuntu opens and asks for a username and password. Use the username **`justin`**: `projects.tsv` expects `/home/justin`.
3. **[Justin]** Install **Windows Terminal** and set **Ubuntu** as its default profile. Install **VS Code** with Microsoft's **WSL** extension.
4. Open the Ubuntu terminal and continue with Part 2 there. If an agent was helping from Windows, start a new Claude session inside Ubuntu (after Part 2, step 2) and continue.

### Part 2: tools, identity, keys, logins (inside Ubuntu)

1. **Tools:**
   ```bash
   sudo apt update && sudo apt install -y git jq curl unzip ca-certificates python3
   # GitHub CLI from GitHub's own apt repo (Ubuntu's package is old):
   sudo mkdir -p -m 755 /etc/apt/keyrings
   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
   sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
   sudo apt update && sudo apt install -y gh
   # gitleaks 8.30.1, the Mac's version. sync.sh refuses to commit without it.
   # Use linux_arm64 instead on an ARM PC.
   curl -fsSL https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz | sudo tar -xz -C /usr/local/bin gitleaks
   git --version && jq --version && gh --version | head -1 && gitleaks version
   ```
2. **Claude Code, inside Ubuntu:**
   `curl -fsSL https://claude.ai/install.sh | bash`
   Then `which claude` must point inside `/home/justin`. **[Justin]** Run `claude` once and sign in.
3. **Git identity (same as the Mac):**
   ```bash
   git config --global user.name "Justin"
   git config --global user.email "issajustin04@gmail.com"
   printf '[user]\n\tname = Justin Issa\n\temail = justin@leorna.com\n' > ~/.gitconfig-leorna
   git config --global includeIf."gitdir:~/Leorna/".path ~/.gitconfig-leorna
   ```
4. **SSH keys, new for this machine (never copied from the Mac).** Only the Leorna key is strictly needed; this repo uses HTTPS.
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_leorna -C "desktop-wsl leorna"
   ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "desktop-wsl personal"
   cat >> ~/.ssh/config <<'EOF'
   Host github.com
     HostName github.com
     User git
     IdentityFile ~/.ssh/id_ed25519
     IdentitiesOnly yes
   Host github-leorna
     HostName github.com
     User git
     IdentityFile ~/.ssh/id_ed25519_leorna
     IdentitiesOnly yes
   EOF
   chmod 600 ~/.ssh/config
   ```
5. **[Justin] GitHub CLI, both accounts.** Sign in personal first, then Leorna, so **Justin-Leorna ends up active** like on the Mac:
   ```bash
   gh auth login -h github.com -p https -s admin:public_key   # sign in as Just-In-N-Out
   gh auth login -h github.com -p https -s admin:public_key   # sign in as Justin-Leorna
   gh auth setup-git                                          # git over HTTPS uses gh (active account)
   gh auth status                                             # both listed, Justin-Leorna active
   ```
   Then add the keys to GitHub without switching accounts, and test them:
   ```bash
   GH_TOKEN="$(gh auth token --user Justin-Leorna)" gh ssh-key add ~/.ssh/id_ed25519_leorna.pub --title "Desktop WSL"
   GH_TOKEN="$(gh auth token --user Just-In-N-Out)" gh ssh-key add ~/.ssh/id_ed25519.pub --title "Desktop WSL"
   ssh -o BatchMode=yes -T git@github-leorna   # must greet Justin-Leorna
   ssh -o BatchMode=yes -T git@github.com      # must greet Just-In-N-Out
   ```

### Part 3: bring the setup down

1. **The LeornaAI skills library first,** so `attach` can apply Justin's library edits:
   ```bash
   mkdir -p ~/.hermes
   GH_TOKEN="$(gh auth token --user Justin-Leorna)" gh repo clone LeornaAI/skills-library ~/.hermes/skills-library
   ```
2. **This repo, as a bare clone, then attach it to `$HOME`:**
   ```bash
   GH_TOKEN="$(gh auth token --user Just-In-N-Out)" gh repo clone Just-In-N-Out/claude-setup ~/.claude-setup.git -- --bare
   bash <(git --git-dir="$HOME/.claude-setup.git" show main:.claude/setup/sync.sh) attach
   ```
   `attach` does five things:
   - backs up any file it would overwrite (for example the `settings.json` the Claude installer made) to `~/.claude-setup-backup/<time>/`;
   - checks every synced file out to its normal path;
   - sets the repo's GitHub auth (the Just-In-N-Out token via `gh`);
   - applies `skills-library-local.patch`;
   - creates the memory links.

   If `gh repo clone` fails on auth, use the git form instead:
   ```bash
   git -c credential.helper= -c 'credential.helper=!f() { test "$1" = get || exit 0; echo username=Just-In-N-Out; echo "password=$(gh auth token --user Just-In-N-Out)"; }; f' clone --bare https://github.com/Just-In-N-Out/claude-setup.git ~/.claude-setup.git
   ```
3. **Build the skill links** (`~/.claude/skills/*` and the library categories): `~/.hermes/scripts/update-skills-library.sh`
   Then check: `ls -l ~/.claude/skills` shows links to `/home/justin/.hermes/…`, and none are broken (`find ~/.claude/skills -xtype l` prints nothing).
4. **The Leorna code repos.** Clone them once; they are never auto-pulled:
   ```bash
   mkdir -p ~/Leorna && cd ~/Leorna
   git clone git@github-leorna:LeornaAI/leorna-client.git
   git clone git@github-leorna:LeornaAI/leorna-control-plane.git
   git clone git@github-leorna:LeornaAI/codex-skills.git
   ```
   Check the identity: `git -C ~/Leorna/leorna-client config user.email` must print `justin@leorna.com`.
5. **Personal projects (optional, when Justin wants them here).** Clone each into the `desktop_path` that `~/.claude/setup/projects.tsv` lists for it, or edit that column. Then run `~/.claude/setup/sync.sh links`, which writes each project's `CLAUDE.md` and keeps it out of that project's git.
6. **Restart Claude Code** in Ubuntu so it loads the new `~/.claude/CLAUDE.md`, `settings.json` and hooks. Then:
   - **[Justin]** in Claude, run `/plugin` and install **superpowers**, **frontend-design**, **context7** and **claude-md-management** (all from `claude-plugins-official`);
   - **[Justin]** add ClickUp: `claude mcp add --transport http --scope user clickup https://mcp.clickup.com/mcp`, then sign in through `/mcp`. The login stays on this machine.
7. **Check:**
   - `bash ~/.claude/hooks/tests/subagent-ac-gate.test.sh` and the other hook tests pass;
   - `~/.claude/setup/sync.sh status` reports no errors;
   - in Claude, `/skills` lists engineering-best-practices, leorna, code-review-practice and the rest;
   - live round trip: make a harmless one-line edit to a skill here, run `~/.claude/setup/sync.sh`, then on the Mac run `~/.claude/setup/sync.sh pull` and see it. Then the other way round.

## Desktop notes

- **Leorna client:** it's a Wails desktop app. Building or running it from WSL isn't covered here; treat it as its own task.
- **Memory:** Claude names memory folders after the project's path (`/home/justin/Leorna` → `-home-justin-Leorna`). `sync.sh links` points each desktop folder at the Mac's (`../-Users-justin-Leorna/memory`), so both machines read and write the same notes. A project not in `projects.tsv` keeps its own desktop-only notes, which sync too.
- **Hermes isn't installed here.** Its skills, scripts and plans are, which is everything Claude's pipeline needs. Hermes-only scripts like `merge_lock.sh` (Mac `stat -f`) aren't used on this machine.
