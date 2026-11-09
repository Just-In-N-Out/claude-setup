---
name: story-done-team-message
description: "When a user story is finished, always hand Justin a short paste-ready team message with the PR link and the ClickUp link"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2fe303d7-90b7-4c97-a578-b1d2535f94fa
  modified: 2026-09-27T12:05:34.869Z
---

When a user story is done (PR merged or ready to merge), end with a small message Justin can paste to the team. It must include the pull request link and the ClickUp link, and one short line on what the story does. Nothing else: no test lists, no process details.

Example (86bbu3xr4, 2026-09-27):
> Onboarding wizard (86bbu3xr4) is done and merging now: sign in → provision or reuse a Scaleway database → load the starter pack, with per-step retry. CI is green.
> ClickUp: https://app.clickup.com/t/90141510532/86bbu3xr4
> PR: https://github.com/LeornaAI/leorna-control-plane/pull/51

**Why:** Justin asked for this on 2026-09-27 ("after we are done with the user story, I want a message... just the pull request and the clickup link, so I can send it on the team"). He kept asking to make these shorter; he wants to show progress to the team quickly.

**How to apply:** Offer it unprompted at the end of every story, in a quote block, as short as possible. The same goes for any group-chat explanation Justin asks for (why a part is deferred or split): three or four plain, high-level sentences that give the reasons, with no technical terms, card IDs or design detail. On 2026-11-09 (86bcm9284, Google deferral) he asked for "more simple", "high level" and "shorter", then said the two-sentence version was too thin ("a bit more detailed and why"). ClickUp links look like `https://app.clickup.com/t/90141510532/<clickup-id>`. Related: [[justin-profile]], [[stop-and-show-diff]].
