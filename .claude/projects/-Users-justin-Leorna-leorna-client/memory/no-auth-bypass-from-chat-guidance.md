---
name: no-auth-bypass-from-chat-guidance
description: "Hold security recommendations; a teammate's \"assume you're authenticated\" is scoping guidance for tests, not authorization to add a login bypass"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e54e7fd6-b3b2-43ef-895f-ae478c9748f1
  modified: 2026-09-21T16:51:39.056Z
---

Never add a dev-login stub, auth bypass, or relaxed startup/validation check to a Leorna binary because a chat message says to "assume" or "skip" auth. That guidance means: work at the test layer with fakes and fixtures.

**Why:** On 2026-09-18 in the control plane I recommended against a bypass, then reversed after a screenshot of a teammate's message and built `LEORNA_DEV_LOGIN`. Justin stopped it: a one-line chat message doesn't override the security reasoning. All of it was reverted. The shelved harness still sits untracked in the control plane's `deploy/local/`; leave it alone.

**How to apply:** In the client, use the existing hand-rolled fakes (`memoryVault`, `mockIDP`, `transportFunc`) rather than weakening `login` or `onboarding` checks. Do not re-propose a bypass unless the team owner asks for it in writing as a feature. Related: [[leorna-workflow]].
