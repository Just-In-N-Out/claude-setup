# Skill libraries: how agents see skills, and bringing in a skills repo

## How skills reach a session or an agent

- Every session with skill tools gets an **index** in its system prompt: one line per enabled skill (`- name: description`). The index is built when the session starts. A skill's full `SKILL.md` loads only when the agent calls `skill_view`, either because its instructions name the skill or because the task matches the description.
- **Delegated children** (`delegate_task`) get the same index, built fresh when they spawn, and load skills the same way. They can't call `delegate_task` or `clarify`, so any skill step that says "spawn a reviewer/verifier subagent" has to be run by the main chat as a separate role. Children get repo context files only when a workspace path is passed.
- **A running chat keeps old skill text.** Skill text loaded earlier stays in the chat's history, and the index changes only at the next session. After editing a skill a chat depends on, re-load it with `skill_view` before acting on it, or start a new session.
- **Index cost** is about `sum(len("    - <name>: <description>\n")) / 4` tokens on every message. Rule of thumb: 100 skills cost 2–2.5K tokens. Measure it by summing the descriptions of the names `COLUMNS=300 hermes skills list` shows as enabled.
- **Explaining it to a user:** the index is a library catalog, and `skill_view` opens one book. Agents see every title and open only the books they need.

## Routes for bringing in a skills repo

| Route | How | Fits | Catch |
|---|---|---|---|
| **Symlink chosen skills** | clone, then `ln -s <clone>/skills/<name> $HERMES_HOME/skills/<category>/<name>` | a curated subset; `git pull` updates it | agent edits to a linked skill land in the clone |
| **`skills.external_dirs`** | `hermes config set` the clone's `skills/` dir | the whole tree, nothing to maintain | full index cost on every message; local skills win name collisions |
| **Hub tap** | `hermes skills tap add <owner>/<repo>`, then `hermes skills install <owner>/<repo>/skills/<name>` | one skill at a time, with a security scan | the scan treats taps as community sources and blocks skills containing auth-header or credential-helper examples, even with `--force` |

The loader follows symlinks, and new or removed skills show up in the next session without a gateway restart.

## Curating and merging a library (procedure)

1. **Clone.** If SSH auth fails from the Hermes process, clone over HTTPS with the `gh` login: `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' clone https://github.com/<org>/<repo>.git <dest>`, then add the same helper to the clone's `.git/config` so later pulls work.
2. **Map the overlap before choosing anything:**
   - same-name skills: compare contents. `hermes skills list-modified` plus `hermes skills diff <name>` show the user's own additions to a bundled skill compared with stock; those additions have to survive any replacement;
   - same-job skills under different names: compare descriptions, and diff bodies (an identical body under a new name is a pure duplicate);
   - hub (`hermes skills list --source hub`) versus bundled versus local origin, since removal differs per origin.
3. **Choose the keep set from the user's actual work.** Read the stack from their repos. Drop other people's runbooks (hostnames, team bots, machine-specific paths), skills that need tools or folders that don't exist on this machine, and stacks they don't use. A library "primary workflow" skill competes with the user's own pipeline skills, so adopt it explicitly in the role lists or leave it out.
4. **Install from a keep-list file with an updater script.** The script links exactly the listed skills, removes every other link it owns, reports new upstream skills instead of installing them, and preserves local fixes: save `git diff` to a patch, pull, then re-apply **one file at a time** (`git apply --include=<file> <patch>`). A multi-file `git apply` is all-or-nothing, so one stale hunk would silently drop every other fix.
5. **Replacing a same-name skill:** write a real local copy (not a symlink) of the library text plus the user's additions. A bundled skill then shows as user-modified, and `hermes update` leaves it alone. Track these copies in a list so the updater can report upstream changes that need a re-merge.
6. **Removing a hub-installed duplicate:** `hermes skills uninstall <name> --yes`.
7. **Verify:**
   - `COLUMNS=300 hermes skills list` count against the `SKILL.md` folders on disk. Any missing skill is gated by `platforms` or `requires_toolsets`;
   - scan kept skills for backticked names of skills you excluded (dangling "pair with X" pointers);
   - load one linked skill and one merged skill with `skill_view`.
8. **Claude Code mirror:** link the role skills flat into `~/.claude/skills/<name>`. Plugin skills are namespaced (`superpowers:x`), so a same-named personal skill doesn't clash, but `CLAUDE.md` must say which one to use.

## Frontmatter gotchas in imported skills

- `platforms:` takes `linux`, `macos` and `windows`. `mac` doesn't match, so the skill silently disappears on macOS.
- `metadata.hermes.requires_toolsets` takes toolset names (`delegation`, `terminal`, `kanban`), not tool names. `delegate_task` there hides the skill everywhere.
- Skills with a mandatory "spawn fixer, bug-finder, verifier" loop can't run that loop inside a delegated child; map it onto main-chat pipeline roles.

## Native validation in the installed runtime

Use this recipe when a skill update needs reproducible structural/lint or custom
contract checks beyond the `skill_manage` write result.

1. Resolve the active profile, installed source root and interpreter from the real
   Hermes launcher. Use that runtime rather than assuming the shell's `python3`
   has the same dependencies. Do not change providers or start a replacement chat
   merely to execute validation.
2. Keep the read-only validator in task-owned scratch. When direct execution needs
   the installed bootstrap, run the following with the launcher's actual Python;
   supply source-root and validator paths as arguments rather than hardcoding a
   user's installation layout:

   ```python
   import runpy
   import sys

   source_root, validator_path = sys.argv[1:3]
   sys.path.insert(0, source_root)
   import hermes_bootstrap

   runpy.run_path(validator_path, run_name="__main__")
   ```

3. Inspect the installed validation API before importing it. The native checks
   used by skill management are `tools.skill_manager_tool._validate_frontmatter`
   and `_validate_content_size`, with `tools.skill_linter.lint_skill` for advisory
   findings. Apply the new-skill description budget when validating a new skill,
   verify linked resources and report hard failures separately from lint findings.
4. Keep structural checks, fixture inventory, static contract assertions, actual
   trigger evaluations and executed end-to-end behavior as separate verdicts.
   Parsing expected scenarios does not mean the model executed or passed them.
5. Fix only the validator/runtime binding when that is the failed layer; preserve
   the original validation failure and avoid changing valid skill metadata to
   appease a different client's schema.

## Pitfalls

- **Validate against the actual skill client.** New Hermes descriptions must fit 60 characters, trigger first, one sentence ending with a period. `skill_manage` rolls back the entire batch if any operation fails, so do not assume earlier reported operations persisted. Its SKILL.md limit is 100,000 characters; keep a narrow canonical procedure and short hub links instead of growing an already oversized hub. Portable/Codex validators can reject supported Hermes top-level author/version fields; use Hermes-native validation for Hermes skills.
- **A viewable imported skill may not be writable through the active-profile registry.** If `skill_view` succeeds but `skill_manage` says not found, resolve the actual installed/source scope before retrying; do not guess a profile, create an accidental duplicate, or claim the update landed. Isolate optional authoring-lesson edits from the user's core workflow batch so a missing imported target cannot roll back unrelated approved changes.

- **Never run an imported library's maintainer export step** ("sync from Hermes", "re-export") on a machine that isn't the maintainer's. It regenerates the repo from the local `~/.hermes`, deleting everyone else's skills and publishing the user's personal ones.
- **Library install scripts that use `declare -A` need bash 4 or newer.** On macOS, `env bash` resolves to bash 3.2, so call Homebrew's bash explicitly.
- **Measure the index before recommending "install everything".** A few hundred skills add about 10K tokens to every message, including every messaging-platform turn.
