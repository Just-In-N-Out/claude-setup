# Status pings and re-ask reminders

These are script-only cron jobs: status reads the dispatch board and Git; reminders read waiting questions. Neither launches feature implementation. Their existence or a recent post does not establish that any worker is live.

## Identify and stop the requested schedule

1. List jobs with `cronjob_manage(action="list")`. Match the quoted post or requested function against the returned job name, script and delivery target. Discover its current `job_id`; never reuse an old example ID as authority.
2. For a stop or pause request, call `cronjob_manage(action="pause", job_id=<matched id>)`. Pausing retains its configuration without future scheduled fires; do not remove it unless deletion was requested.
3. List again and verify that exact job has `enabled: false` and `state: paused`. Only then confirm the recurring script is paused. Pausing future fires is not proof that an already in-flight delivery was recalled.
4. Leave unrelated jobs, backups and active agents unchanged. If the status and question-reminder jobs both match an explicit request to stop all dispatch notifications, pause both and verify each; a request quoting one script targets that script, not every cron job.
5. Keep the acknowledgment to one line. Resume or change cadence only when requested, using the same list → targeted action → readback procedure. A model switch or new feature does not reverse an explicit notification stop.

## Status script

- Identify by script `dispatch_status.py` and the feature-dispatch status name; resolve the current job ID and schedule from the live listing.
- The script posts its stdout verbatim and uses no model. It lists open phases, including stopped and waiting entries; pausing workers therefore does not silence its output.
- Each row reports feature, project, recorded phase, time in phase and accumulated branch commits. These are board/Git observations, not an independent live-agent roster.
- `--all` includes completed entries for an explicitly requested comprehensive snapshot.
- Keep board fields `phase`, `phase_since`, `project`, `branch` and `note` current. A new phase needs matching script icon/order/active handling.

## Question-reminder script

- Identify by script `dispatch_remind.py` and the feature-dispatch reminders name; discover its current job ID and schedule.
- For `awaiting-go` or `awaiting-answer`, it posts the saved `ask` and `reply_hint` after the configured interval, at most five times per question. The status script may continue listing the feature afterward if still enabled.
- Counts live in `~/.hermes/plans/reminders.json`; this script does not update the board.
- A new `ask` through `dispatch_board.py` restamps `asked_at` and restarts the reminder count. Record an answer promptly so an already-answered question is not reissued.

Builds never belong in these cron jobs. Notification controls and worker cancellation are separate operations; see SKILL.md → Stop, pause and notification controls.
