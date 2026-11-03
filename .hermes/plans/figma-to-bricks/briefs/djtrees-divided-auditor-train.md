# Role: AC AUDITOR (blind) — the divided-row cars (merge-train cars 7, 8, 9) — one car per agent

Read `/home/justin/.hermes/plans/figma-to-bricks/briefs/djtrees-auditor-common.md` first and follow it (and
djtrees-common.md's machine rules: Chrome, fonts, ticks as a JSON string, bounded mutation runs, never end your turn
to wait). Your prompt names your car. You write only `E/auditor/` (move an older one to `E/auditor-pre-train/` first).
Use your own worktree, detached at the head, as `ac-check --repo`.

| car | job | head | base (the commit this job sits on in the train) | E |
|---|---|---|---|---|
| 7 | djtrees-stack-gaps | `9599c9e7418adc9b9fa39e550c58baf2b0c5e1c0` | `f425e79c52eef094b94033ad96fbbae0705d8a50` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-gaps` |
| 8 | djtrees-stack-lines | `d2c58998f57de1d7404378e35354c139e314de40` | `9599c9e7418adc9b9fa39e550c58baf2b0c5e1c0` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-stack-lines` |
| 9 | djtrees-step-sides | `a8bef6c2b3bb227a39d385eb8d33f7b6e68e5bed` | `d2c58998f57de1d7404378e35354c139e314de40` | `~/.hermes/plans/figma-to-bricks/evidence/djtrees-step-sides` |

Approved plan: `E/plan-approved.md`. Inject the DJ fonts for any real-file measurement.
