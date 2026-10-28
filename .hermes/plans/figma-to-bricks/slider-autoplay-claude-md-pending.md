# slider-autoplay — exact main CLAUDE.md edits pending

Target: `/home/justin/Documents/FigmaToBricksV2/CLAUDE.md`.
Local build **2026-10-28.3**, release commit `979c5b331cc095ed1602602fb7a49eb295fa78e0`.
Accepted feature head `2b55134485cdf5f2d58eec03775a658e5f0544f6`, base
`27b787b78d88850cbb9863bb31fcfc840406331c`. Main was fast-forwarded by the orchestrator before this release.
**Push is blocked, not complete:** SSH rejects `/etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf` with
`Bad owner or permissions` before authentication, including the normal escalated retry. No account, remote,
helper or transport was changed. Push was not attempted because the required Just-In-N-Out greeting could not
be verified. Exact output: `evidence/slider-autoplay/finisher-release/ssh-identity{,-escalated}.log`.

**Apply after the older ones, in build order**, including the backlog through
`hero-media-row-claude-md-pending.md` (2026-10-22.9). The current CLAUDE.md says build2026-10-28.2 but explicitly
records that builds21.13–22.9 remain pending; the newer build line is not proof that those older edits landed.
Preserve every older pending file and partial-application note. **None of this feature's edits below landed or
was attempted.** No protected write was denied in this finisher; the existing ordering rule caused this queue.
Never route around an older denied/expired write. Re-read target sections before applying by a permitted path.
Apply the build-line edit LAST; rename this file applied only after all required sections actually land.

## Edit 1 — Start here: insert before Bigger words in pills and Learn more links

```text
- **A slider that plays by itself (28.3, slider-autoplay):**
  - A component whose variants loop After delay becomes Bricks' Slider (Nestable), one Block per variant.
    Slide1 keeps the instance's words; later slides use their variants. Non-looping/hover/click/moved-row/linked
    cases stay still and are named. Only arrows and dots drawn consistently in every slide become controls.
    Across its section it runs edge to edge, words in the 1440 Container; a narrow slider stays in its column.
  - **Confirmed answers (2026-10-27):** full Figma wait after each change, so interval=delay+speed; smaller arrows
    on phones; opposite arrows side by side in a corner qualify too. Defaults below remain rulings.
  - Every slide keeps its buttons on phones, full width, with no hero Phone-buttons copy. Rulings, unconfirmed:
    pause on hover/focus and reduced motion; Bricks' own edge arrows; 24px phone arrows, 32px phone content sides,
    58px band-Container tablet sides (larger drawn sides kept); common delay, under50→seconds, first duration,
    no per-slide easing/direction or gap. Smart animate/Dissolve/Instant fade; Instant speed0.
  - Independent verifier+blind auditor round3 accepted AC1–AC12 on2b551344/base27b787b; ac-check READY FOR THE USER.
    **AC13/AC14, paste check3bo owed:** installed Bricks2.3.9 paste/save/copy-back and published autoplay,
    rewind/Instant/arrows/phone taps; real Figma test delay5000+speed800→interval5800. Schema2.4.3 is documented,
    not a user-copied sample. Local release commit979c5b3, rebuilt bundles byte-reproduced; push blocked by SSH
    system-config permissions before authentication. This is not live publication.
  - Known limit OBS1: arrows intercept the ends of a narrow slider's centered full-width linked button at
    1440/991/768; phones pass. Narrow desktop/tablet clearance is not solved. No touch pause control. Three v1
    Mac-path corpus files remain unavailable; full browser has the same12 font/environment failures and1 skip as
    base. Available hydraulics/GRO full reports and all five user-file pastes/warnings match. B-Dry Home's paste
    artifact remains a separate main-session deliverable. Details and all defaults/deferred items: HANDOFF/ledger.
```

## Edit 2 — Where things stand: insert after Label minimums and tight-row space, before Paste checks

```text
- **A slider that plays by itself** (build `2026-10-28.3`, `worktree-slider-autoplay`, Full pipeline): see
  "Start here" and HANDOFF; plan/ledger `docs/plans/2026-10-26-slider-autoplay*`.
  - `normalise/carousel.ts` follows After-delay variant loops; controls read from their drawings/click wiring;
    all slides reach content/link/layout passes. `understand/carousel.ts` makes native slider/Block slides,
    `style/slides.ts` fills the tallest slide, `adapt/rules/slider.ts` shares phone/band-tablet arrow clearance with
    the layout plan, `emit/carousel.ts` writes documented Bricks settings. Panel notes deduplicate by source layer,
    so two same-named sliders each get a note. Phone sliders without After delay stay as before.
  - Justin confirmed full wait (interval=delay+speed), smaller phone arrows and corner-pair recognition; defaults
    and thresholds remain unconfirmed rulings, preserved in the plan/HANDOFF. No new product ruling at release.
  - Verifier+blind auditor round3 clean on2b551344/base27b787b; ac-check READY FOR THE USER (AC1–AC12 accepted).
    Carousel browser7/7. Full browser373 pass vs364 base, same12 failures/1 Mac-only skip by exact test name.
    Auditor localized check2402 unit+3performance passes,36+3 unavailable-v1 skips; full corpus exits1 on both for
    missing design/final-design/page-1 Mac paths. Available hydraulics/GRO complete reports match at6 widths,
    all five payload/warnings pairs equal, golden unchanged. Full v1 corpus work remains owed on a Mac.
  - OBS1: narrow-slider full-width CTA endpoints can fall under default50px arrows at1440/991/768; phones pass.
    Outside the approved narrow-phone/band-tablet clearance matrix; not solved. Also deferred: no touch pause,
    per-slide delays/easing/direction, drawn arrow place/icon, moved-row/strip autoplay, slide-copy zigzag ordering,
    instance-root motion/hover duplication and silent nested strip/carousel/marquee skips (HANDOFF).
  - Local build commit979c5b3 and manifest dist bundles verified; push blocked by SSH system-config permissions,
    not released remotely. Preserve the feature worktree/branch. **AC13/AC14 / paste check3bo owed**, real Figma
    test interval5800/speed800; installed Bricks2.3.9 compatibility and live checks remain unverified.
    Evidence `~/.hermes/plans/figma-to-bricks/evidence/slider-autoplay/`; B-Dry paste artifact separately pending.
```

## Edit 3 — Decisions the user made → Interactions: insert before Flip cards

```text
  - **After-delay sliders** (2026-10-26 request; build `2026-10-28.3`): a component whose variants loop After delay
    becomes Bricks' Slider (Nestable), playing by itself; arrows/dots only where consistently drawn. The initial
    Q1A–Q6A choices were taken under auto-go. Slide buttons stay on each slide on phones, full width.
    - **Justin confirmed (2026-10-27):** each slide waits the full Figma delay after the change ends, so Bricks'
      interval is delay+speed (5000+2500→7500); phone arrows stay but get smaller; opposite arrows side by side
      in one corner qualify. The sample gate was lifted for documented official-schema/live-page evidence;
      installed-version acceptance still needs the user's paste/save/copy-back (AC13).
    - **Rulings, not yet confirmed:** modal delay (tie:first), under50 read as seconds; first change's duration;
      no easing/slide direction; Smart animate/Dissolve/Instant fade+rewind, Instant speed0; edge-to-edge band
      content within1440; hover/focus pause and reduced-motion stillness; Bricks' edge arrow icon in drawn colour
      and size; later slides use variant content, own phone sliders never autoplay, gap0. Phone arrow box24px,
      icon≤24px, phone content sides≥32px; band Container sides≥58px at768–991, keep larger drawn sides. Corner
      pair gap≤one arrow width, outer third each way. These thresholds are defaults, not confirmed user answers.
    - **Limits/acceptance:** no touch pause control; narrow desktop/tablet CTA endpoints can be intercepted by
      arrows (OBS1). AC13 and AC14 / check3bo remain live; real Figma5000ms+800ms must emit interval5800/speed800.
```

## Edit 4 — Current build line LAST

Change only:

```text
**Current build `2026-10-28.2`.** Builds 21.13–22.9 were recorded only in `docs/HANDOFF.md` (their agents
```

to:

```text
**Current local build `2026-10-28.3` (push blocked by SSH configuration).** Builds 21.13–22.9 were recorded only in `docs/HANDOFF.md` (their agents
```

If the push blocker has since been resolved with verified remote readback, replace the parenthetical with that
actual state. Never roll back a later sibling build line; reconcile this edit against the then-current BUILD.

## Rules-summary amendment for the main session to assess

No skill or memory was edited. Proposed one bullet under User decisions:

```text
- After-delay variant loop→native slider/Block slides, controls only consistently drawn, phone buttons stay per
  slide. Confirmed: full wait interval=delay+speed, smaller phone arrows, corner pairs. Defaults/rulings and limits
  in HANDOFF; schema-backed settings still need installed Bricks paste/copy-back and real Figma timing proof.
```

Evidence: committed plan "Justin's answers (2026-10-27)", Docs & records; independent round3 AC2/AC6/AC13/AC14.
