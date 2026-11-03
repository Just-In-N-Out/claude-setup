# Role: VERIFIER — djtrees-panel-edge (merge-train car 6)

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-verifier-common.md` first and follow it, with these
differences: review-1's P2 R1-1 (a rounded panel opened on its side stopped cutting what grows in it to its corners) was
fixed (`E/fixer/`, commits `bd51756`, `f425e79`), and the job was then rebased into the merge train (HANDOFF-only
conflict; `style.ts` merged cleanly beside car 5's line, see `E/rebase/conflicts.md`). Prove every AC on the rebased
head, confirm R1-1 is closed with your own probe (a rounded clipping panel against a side with a drawing/photo growing
in it, at 1512 and 1920), and judge the rebase (report-only).

**MACHINE RULE (the PC froze 3 times under overlapping Chrome runs):** follow djtrees-common's "One Chrome-driven run"
rule exactly, including the shared `flock ~/.cache/f2b-chrome.lock` and the node-named lock process.

- E = `/home/justin/.hermes/plans/figma-to-bricks/evidence/djtrees-panel-edge` (write `E/verifier/`, fresh).
- Approved plan: `E/plan-approved.md` (AC1–AC10 by test/receipt; AC11 live, 3cj). Fonts for DJ Trees measurements:
  inject the DJ fonts (djtrees-common "Fonts").
- **head** `f425e79c52eef094b94033ad96fbbae0705d8a50` (branch `train-panel-edge`), **base** = train car 5
  `5b312ae24ebe2ad7138d604bc82ca17a396e7032` (judge AC8/AC9's "differs only in…/byte-identical" against it).
  Use your own worktree, detached at the head, as `ac-check --repo`.
- Rebase: `git range-diff 1aef12f..d4405ca3b66b6bfd12c302055c2baebc475b33e4 <base>..<head>` changes no job line.
- Ticks as a JSON string.
