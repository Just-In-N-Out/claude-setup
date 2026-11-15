---
name: user-workflow
description: "How the user works: Figma designs from a UI designer, converted with their own plugin and pasted into Bricks; prefers plain explanations"
metadata:
  node_type: memory
  type: user
  originSessionId: f7a3c41a-53da-4665-b4dd-957fb80b6724
  modified: 2026-10-28T21:22:16.729Z
---

The user builds client websites in Bricks Builder (WordPress). A UI designer hands them desktop-only Figma mockups; they
convert them with their own Figma plugin (v1 at ~/Desktop/figmaplugin, v2 rewrite at ~/Documents/FigmaToBricksV2) and
paste the JSON into Bricks. Their site runs Bricks 2.3.9 (seen 2026-10-06).

They answer short multiple-choice questions readily and write informally; explain choices in plain words, not jargon.

When asking them to test something (2026-10-07 paste check), they got lost: they thought "test" meant running the
plugin in Figma, and expected real photos where the paste file had stand-ins. Give one concrete action at a time
(which tab, which button, what to look for), say up front what will look unfinished and why, and put files on their
clipboard with `pbcopy` rather than asking them to copy. On the Windows desktop (WSL): `powershell.exe -NoProfile -Command "Get-Content -Raw -Encoding UTF8
'<wslpath -w file>' | Set-Clipboard"`; read it back with `[Console]::OutputEncoding=[Text.Encoding]::UTF8` first, or
→ and … come back garbled though the clipboard is right (2026-10-26). Remind them to save (Cmd+S) before reloading or previewing.
On 2026-10-19 they switched v2 from "no git" to git plus a private GitHub repo, to run several agents at once; see
[[git-and-parallel-agents]]. See [[v2-rewrite]] for project decisions.

Update 2026-10-19: they guide work with screenshots of Figma, WordPress and the live page, and ask "what do i do" at
each step. Answer with short numbered steps naming exactly what's on that screen (the button's label, the panel's
tab), one screen at a time; confirm when a screenshot shows it right ("That looks right"). For design decisions with
trade-offs, a multiple-choice question with small text previews worked well (they picked "Hero colour" for photo
edges, "In the page" and "Spreadsheet in the panel" for lists). They want every fix to work for other designers'
files, not just theirs ("does this work on general cases right"). Edge-case layout questions without a picture lose
them: on 2026-10-28, asked two "should this case get the even space too?" questions, they answered "I'm not sure how to
answer these … put it in a way where it looks more aesthetic". For such cases, pick what looks better yourself, say
what it will look like, and keep questions for real trade-offs, with a preview. Their team uses WPForms; the live site and its
post-paste steps are in [[site-and-team]].

Screenshots Justin sends may be taken at browser zoom (on 2026-10-29 two were at about 75%, a ~2560px CSS window): before measuring sizes from a shot, solve the zoom from two or three known sizes in it.

After a new build, tell him to close the plugin panel (X) and reopen it, and to check the panel's "Figma to Bricks v2 build …" line before Convert: on 2026-10-30 his first Convert after build 30.1 still ran 29.3 (Figma loads `\\wsl.localhost\Ubuntu\home\justin\Documents\FigmaToBricksV2\manifest.json`, but only on reopen).

A technical trade-off question needs a concrete "what you would see" example before the options (2026-11-15): asked whether shared button classes losing to a site's Theme Style should be fixed now, he answered "Wait I didn't get it" and then "What do you mean beat that class"; he chose only after an example ("your navy Figma button shows the theme's orange"). Never use words like "beat", "outweigh" or "specificity" without such an example.
