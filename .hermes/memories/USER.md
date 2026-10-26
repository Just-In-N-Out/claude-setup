Justin (GitHub Just-In-N-Out) wants Claude-style replies on every model/surface: emoji headings, bold facts/actions, numbered lists, concise plain words; stable across model switches.
§
Justin is a developer on Leorna's team (repos ~/Leorna/leorna-client and ~/Leorna/leorna-control-plane; ClickUp stories). Its rules live in the `leorna` skill.
§
Justin's personal Figma plugin project is ~/Documents/FigmaToBricksV2 (Figma → Bricks/WordPress); its workflow lives in the `figma-to-bricks` skill.
§
Justin mostly talks to Hermes over WhatsApp, often by voice note. He wants short plain answers and minimal typing (replies like "go" or "1B"). Every feature must start with a plan he approves ("go" accepts the plan plus all recommended answers; /bg tasks are the exception); by default features are dispatched to separate planner and builder agents (`feature-dispatch` skill).
§
Justin often asks what an option in a numbered list means. Options land better in plain words with a concrete today-vs-after example. Slow agent turnaround (10+ min for a small change) frustrates him.
§
Justin wants every coding agent, in any chat or project, to load the Leorna library's role skills (engineering-best-practices first) and run its Agent Defect Loop even in dispatched features; lists in feature-dispatch → "Skills every agent loads" and ~/.claude/CLAUDE.md.