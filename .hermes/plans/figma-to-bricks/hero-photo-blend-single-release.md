# Hero photo blend — single-shadow release split (approved 2026-10-21)

## Approval and scope
Justin approved: 'Yes go for it I don’t want it paused', in reply to releasing the tested cylinder/single-shadow correction separately on Opus5.5medium, followed by freshOpus5.5xhighreview BEFORE merge.
This supersedes the previous decision to hold the single-shadow release for H1B. It does NOT cancel independent multiple-shadow research; that remains separate held work. No page/name/ID-specific fix.

## Behaviour
- Every supported picture with exactly one zero-spread outer shadow uses filter drop-shadow following visible alpha, sigma = Figma/box blur radius /2 (R1 correction46c17a5).
- Pictures with multiple shadows retain their PRE-FEATURE original box-shadow rendering and get a clear warning that independent alpha-following multiple shadows are deferred. Do not leave a chain that invents a phantom shadow, drop any drawn shadow, or silently snapshot palette policy into this release.
- Inner/spread/mixed unsupported shadow cases retain original approved box fallback +warning. Painted boxes unaffected. OriginalFigma thinframe/stroke stays. Layerblur retains ownhalf mapping without doubleapplication, opacity/bakedrenders/zoom/clipping preserved.
- NoSVG transport, newelements/Code/signatures, extrauploads, browsercoverage/CSPchanges or filtersknownfailSafari. Pale sourcefringe outside scope.

## Execution
Existingworktree .claude/worktrees/hero-photo-blend at46c17a5, reusewithoutreset. Main.19+, pill-clip finisher may change paint.ts; preserve separate source meaning on rebase and keep allHANDOFFsections. Read latest actual diffs before touching sharedpaint. Finite local supported CSS drop-shadow path only; realSafari single-shadow smoke ifavailable, do not falselyclaim installedBricksroundtrip.

1. Verify saved R1 and review evidence including original mapping/max36→≤1RGB and multi-shadowphantom.
2. Add regression first for ≥2fallbackexact originalboxshadow and warning/nochain; validsingletransparent/opaque rounded alpha, halfblur, inner/spread/mixedcontrols and zoomstillpass. No unnecessary changes tocorrectR1.
3. Implement minimal selector forsingle vs multiple preserving palette/readability and currentCSSserialization. Archived evidence/provenance untouched. Update plan copy/ledger/HANDOFF toclearlymarksplit and deferredmultiple, no blanket'allshadowsfixed'.
4. Rebase latestmain +retest actualsharedpaintintegration, fullcheck/browser/corpus with fullmatchedfonts/motionreports and exact changedCSS. Real currentdebugscratch and cylinderbefore/afterproof. Returncleancommittedreadyforreview NOT merge/push.
5. Parent freshOpusxhighreview independent; only then separate Opusmediumfinisher gatedmerge/build/push aftervalidfixes. No selfreview shortcut.

## Docs & records
Plan copy docs/plans/2026-10-21-hero-photo-blend-single-release.md, ledger, HANDOFF nextfreepastecheck atmerge. BUILD andmainCLAUDE onlyfinalfinisher. Priorblockedprotectedwrites no retry/bypass; exactpendingfileifdenied. Foundrecords closeonlygenuine single-shadow rectangle cause, leave multipletransportandpalefringe open. Usersteps afterrelease: reload/reconvertRemanufactured/paste/save/PurgeAll, replypastedpage. Existing Bricksproof limitations remainhonest.
