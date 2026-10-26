# Backup, Restore & Moving to a New Machine

## What syncs and what doesn't

Skills, memory, config, sessions, cron jobs, `.env` and `auth.json` are **local files under
`$HERMES_HOME`** (`~/.hermes`). Nothing syncs them to a Nous/provider account; a Portal or
provider login covers model and tool access only. Asked "will my skills follow me to a new
laptop?": the answer is no, not unless you back them up. Then give the backup/import path below.

## Move to a new machine

1. Old machine: `hermes backup` writes one zip (default `~/hermes-backup-<ts>.zip`; `-o` takes a
   file or a directory; `-k N` keeps the newest N `hermes-backup-*.zip` in that directory).
   `--quick` = only config, state.db, .env, auth and cron.
2. New machine: install Hermes, then `hermes import <zip>` (`--force` overwrites existing files).
3. After import, re-pair messaging platforms that hold device sessions (e.g. WhatsApp bridge) and
   reinstall the gateway service (`hermes gateway install`). Launchd/systemd units are per-machine.
4. Things outside `$HERMES_HOME` aren't included, e.g. Claude Code's `~/.claude` (CLAUDE.md,
   settings, skills, plans, `projects/*/memory`). Skills that read those, like `leorna`, need a
   separate copy.

Size: a full backup skips runtime trees (`hermes-agent/`, `installs/`, `tools/`, `cache/`,
`backups/`, browser profiles), so a home directory that's several GB on disk zips to tens of MB.
A full backup every few days is cheap. Don't hand-roll a tar of `~/.hermes`.

Secrets: the zip contains `.env` and `auth.json`. Whenever you suggest a backup destination,
say so (cloud drive, GitHub repo, etc.).

## Scheduled off-machine backup (the setup that worked)

Use a **script-only cron job** so it costs no tokens and stays silent unless it fails:

1. Copy `templates/scheduled-backup.sh` to `$HERMES_HOME/scripts/<name>.sh` and `chmod +x` it.
   - Use the **absolute** `hermes` path (`command -v hermes`), because the scheduler's PATH may
     not include the launcher.
   - Send output to an off-machine synced folder. On macOS that's iCloud Drive:
     `~/Library/Mobile Documents/com~apple~CloudDocs/<folder>`. A same-disk backup doesn't
     survive losing the laptop.
   - Print nothing on success and print one line on failure. With `no_agent`, empty stdout sends
     nothing, so the user only hears about failures.
2. Run the script once by hand and verify before scheduling. Check the zip lists `skills/*/SKILL.md`,
   `memories/`, `.env`, `auth.json`, `config.yaml` and `cron/jobs.json` (`unzip -l`). A full
   backup takes seconds; the scheduler's script timeout is 1 hour.
3. Create the job with `cronjob_manage`: `action=create`, `schedule="every 3d"` (interval forms
   accept `d`; avoid `*/3` day-of-month cron, which resets at month boundaries), `script=<name>.sh`,
   `no_agent=true`, and `deliver` set to the user's main gateway platform (e.g. `whatsapp` = its
   home channel) so failure alerts reach them.
4. Before creating a new job, `cronjob_manage action=list` to find an existing backup job, then
   update that job instead of adding a duplicate.

This user's setup: `~/.hermes/scripts/backup_to_icloud.sh` runs every 3 days. It writes the
Hermes zip plus a `claude-code-<ts>.tar.gz` of `~/.claude` memory/skills/settings to
`iCloud Drive/Hermes Backups`, keeps the newest 3 of each, and sends failures to WhatsApp.
Restore: `hermes import` the zip, then untar the claude archive into `~/.claude`. Ask before
writing into a live `~/.claude`.
