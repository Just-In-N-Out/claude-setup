---
name: lead-status-with-story-name
description: "Justin re-asks \"which story is this / are we done\" — start every story status reply with the card title + ID and a done/not-done verdict"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 8f17e198-9805-4134-b4ab-24a64684bbc6
  modified: 2026-11-08T20:34:23.950Z
---

Start every status reply about a Leorna story with the card's title and ID (a ClickUp link), then a one-word verdict: done, or not done plus who acts next.

**Why:** on 2026-11-08 (86bcm9284), across a restarted session, Justin asked "is this a user story and are we done?", "is this done or does it need to be continued?", "are we done" and "what US is this". Replies that began with the pipeline state didn't name the story, so he had to keep asking.

**How to apply:** first line `[<card title>](<url>) (<id>): not done, waiting on you for X` or `done`. Details go after that line. See [[leorna-no-reverify-while-main-moves]] for what "done" means after ALL ACCEPTED.
