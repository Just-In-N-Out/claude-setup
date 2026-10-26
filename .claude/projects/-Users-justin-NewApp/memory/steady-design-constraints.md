---
name: steady-design-constraints
description: Non-negotiable design rules for the Steady stutter-practice app at /Users/justin/NewApp
metadata: 
  node_type: memory
  type: project
  originSessionId: b758b016-c62e-4f7c-aceb-6d1970a3d057
  modified: 2026-07-26T03:54:15.437Z
---

Steady (iOS app at `/Users/justin/NewApp`) is a daily read-aloud practice app Justin is building for his own stutter. Three constraints govern every feature and are easy to violate by accident:

1. **Never grade speech.** No speech recognition, no accuracy scoring, no failure states. Scoring a block as an error teaches the opposite of what fluency work needs. Completion is the only metric.
2. **Tongue twisters are reframed as slow practice, not articulation drills.** Default pace is 90 WPM (conversation is ~150). Anything that rewards speed works against the app's purpose.
3. **Forgiving by construction.** The streak allows one miss per rolling 7 days; the daily set always includes one deliberate easy win alongside two hard-sound lines. Guilt makes stuttering worse.

Also: fully offline, no account/server, and voice recordings never leave the device — this is a privacy requirement, not a default that can be traded away.

**Why:** These came out of a design conversation on 2026-07-26, not from the code, and a future change could plausibly "improve" the app straight through them (e.g. adding pronunciation scoring or a strict streak).

**How to apply:** Reject or flag any feature that scores speech, rewards faster reading, punishes a missed day, or uploads recordings.
