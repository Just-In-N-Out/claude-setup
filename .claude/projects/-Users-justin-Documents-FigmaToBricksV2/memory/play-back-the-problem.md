---
name: play-back-the-problem
description: "Before asking the user to choose between technical options, restate their problem in plain words first"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 1577a39d-9084-475d-865c-45e681993eb0
  modified: 2026-10-20T19:30:09.317Z
---

When the user reports a problem, restate it in their own terms (numbered, plain words) before asking them to choose
between technical options. On 2026-10-20 I opened with a question about how to "make room for a fixed header" and the
user replied "Wait did you understand the issue?" (they were thinking of the fix as "ask, then remove the header").

**Why:** the user thinks in what they see in Bricks, not in CSS terms; a choice question before a play-back reads as
if I hadn't understood them.

**How to apply:** first message after a bug report: "Here's how I understand it: 1… 2… 3…", then name the catch (if
any) in one plain sentence, then the question. See [[user-workflow]].
