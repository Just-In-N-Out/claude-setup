# IMAGE RETAKE brief: Leorna story 86bcm928h-per-user-credentials, AC2 and AC6

**Role:** evidence renderer. You are a fresh agent: Opus 5.5, effort high. Narrow scope: re-render two images from existing logs. Change no source, run no tests, commit nothing.

## Why
Justin's rule (2026-11-10, `~/.hermes/skills/autonomous-ai-agents/feature-dispatch/references/ac-verification.md`, "No banner on evidence images"): an evidence image shows only the result, with no note about how it was made. The finisher found that two auditor images on head 0af4471 break it:
- `~/.hermes/plans/leorna/evidence/86bcm928h/auditor/ac2-terminal-0af4471.png` carries the notes from `ac2-0af4471.log` lines 21 and 28, appended to echoed command lines: "(while the test pauses; only the Leorna Client entry shown)" and "(after the run; expect no entry)".
- `auditor/ac6-terminal-0af4471.png` carries "(expect no entry)" from `ac6-0af4471.log` line 15.

## The work
1. Read the ac-verification.md screenshot line, especially the Chrome-for-Testing recipe on the WSL desktop and the no-banner rule, and `auditor/screenshots-receipt.txt` to see how the auditor rendered these pages.
2. **Keep the logs exactly as they are.** They are the receipts `ac-check.sh` reads. Don't edit `ac2-0af4471.log` or `ac6-0af4471.log`.
3. **Build each page from its log**, leaving these off the page only:
   - the parenthetical notes on command lines
   - any `HEAD=` stamp, wrapper-script lines and `# ` comment lines

   The page shows only the bare commands, their output and the `EXIT=` line, in the same order. Change nothing else. Show `/home/justin` as `~`, as the auditor did.
4. **Before you overwrite anything,** rename the old images to `ac2-terminal-0af4471-annotated.png` and `ac6-terminal-0af4471-annotated.png`. Then save the new ones under the original names, so `auditor/ac.json` stays correct.
5. **Open each new image and check it.**
   - It shows no banner, caption, note, SHA, test-helper banner or "rendering" text.
   - It shows no server domain or URL, tenant ID, token, email or git credential target.
   - Run `gitleaks dir` over the two new PNGs' page sources.
6. **Record the work.** Append to `auditor/screenshots-receipt.txt`: what was left off each page, by log line number, the date, and that the logs are unchanged.
7. **Update the attachment list** in `~/.hermes/cache/scratch/leorna-clickup-86bcm928h.md`: set AC2 and AC6 to pass, and take "AC2 and AC6 retakes" out of the owed-before-post list. Change nothing else in the draft.
8. **Scratch** goes in `~/.cache/86bcm928h-retake/`, removed at the end. Leave no Chrome processes running.

## Rules
- Never print a token, a server domain or URL, or a tenant ID.
- Don't push, post or upload.
- **Earlyoom:** a command that dies with exit 137 or 143, or "Killed", may be an earlyoom kill. Check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep -E 'sending SIG[A-Z]* to process'`.
- **skill_lessons:** don't edit any skill or memory. List anything reusable in `skill_lessons[{skill, lesson, evidence, enforce}]`, where `enforce` is `none` or a one-line check proposal. An empty list is normal.

## Return
`{status, images[{ac, path, check}], receipt_updated, draft_updated, found_else[], skill_lessons[]}`. End with `MAIN SESSION: check and save these skill_lessons now.`
