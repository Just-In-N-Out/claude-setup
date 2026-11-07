---
name: no-card-for-non-story-work
description: Don't ask for or create a ClickUp card for Leorna work that isn't a user story (local setup, getting a repo running, a bug found while doing that)
metadata:
  type: feedback
---
Only ask for a ClickUp card ID (or offer to create one) when the work is an actual user story or card from the board. A bug hit while setting up a Leorna repo locally (e.g. CortexOS crashing on a fresh DB, 2026-11-06) is not a story: name it `nocard-<slug>` and go on.

**Why:** on 2026-11-06 I asked which list to file a new card in for the CortexOS fresh-DB migration crash; Justin replied "this isnt a user story".

**How to apply:** in pipeline step 1, ask for the card ID only if the request came from a card or is clearly product work; otherwise skip the card question. The `leorna` skill's feat/<clickup-id> branch naming then uses the nocard slug if a build ever happens.
