# Paired client/server live-acceptance setup

Use this recipe when moving a reviewed Leorna candidate into a user-operated test-server setup. It establishes source/artifact identity and a local installer launch. It does **not** establish cloud installation, browser visibility, authentication, deployed image identity or completed live acceptance.

## Contents

- [Bind the candidate](#1-bind-the-intended-candidate)
- [Discover process and profile ownership](#2-discover-current-process-ownership)
- [Open the installer](#3-open-a-pinned-local-installer)
- [Guide the operator and launch the client](#4-operator-handoff-and-client-launch)
- [Review the write set and permission](#review-the-proposed-write-set-before-application)
- [Verify a scoped run](#verify-a-scoped-run-without-repeating-sync)
- [Preserve evidence](#preserve-evidence-and-the-current-handoff)

## 1. Bind the intended candidate

Resolve these values from the current approved handoff and actual artifact receipts, never from an older session or another story:

- `SERVER_WT`, `CLIENT_WT`: absolute feature worktrees.
- `SERVER_HEAD`, `CLIENT_HEAD`, `BRANCH`: exact approved identities.
- `LAUNCHER_BIN`, `CLIENT_BIN`: absolute built-artifact paths.
- Artifact sizes/SHA-256s and the validated Go toolchain binding.
- The real operator HOME, kept separate from isolated test homes.

For each worktree:

```sh
git -C "$SERVER_WT" branch --show-current
git -C "$SERVER_WT" rev-parse HEAD
git -C "$SERVER_WT" status --porcelain --untracked-files=all

git -C "$CLIENT_WT" branch --show-current
git -C "$CLIENT_WT" rev-parse HEAD
git -C "$CLIENT_WT" status --porcelain --untracked-files=all
```

Require the approved branch/head and no unexplained changes. Recompute each selected artifact's size/hash against its producer receipt, then inspect without executing it:

```sh
go version -m "$LAUNCHER_BIN"
go version -m "$CLIENT_BIN"
```

Require the intended module, clean VCS revision and OS/architecture when those metadata are embedded. Do not equate macOS launcher architecture with server deployment architecture. An unstamped `go run` binary is not a proven revision mismatch: retain its observed module/cwd binding and prefer the already-stamped artifact for a fresh launch. Docker readiness is a separate local prerequisite for local-image deployment.

## 2. Discover current process ownership

Read full-width process data into a parser, not into chat:

```sh
ps -ww -axo pid=,ppid=,args=
lsof -a -p "$PID" -d cwd,txt -Fn
```

Filter before printing: command lines can contain private URLs or credentials. Print only PIDs, executable/cwd, parent relation and allowlisted mode flags. Match the installer by its approved executable or go-run module **and** server worktree. Match its browser by the exact dedicated `Library/Caches/Leorna/chrome-profile` path; do not read browser storage.

Refresh discovery immediately before stopping anything. With explicit restart authorization, gracefully stop only this owned installer/browser tree, verify those targets exited, and leave unrelated Chrome sessions and cloud resources alone. If no old targets remain, do not invent a cleanup step. Recheck before launching a replacement to prevent duplicate installers or profile locks.

Re-establish client profile ownership after an operator workaround or relaunch, even when the same artifact path is running. Start with `ps -ww -axo pid=,comm=` to find the exact verified executable without collecting arguments, then check executable/cwd with `lsof -a -p "$PID" -d cwd,txt -Fn`. When app-state isolation matters, inspect open-file **path metadata only** with `lsof -a -p "$PID" -F fn`: parse each `f` descriptor followed by its `n` pathname inside the tool process and retain only the expected app-database/WAL/SHM paths. Do not log the unfiltered stream or read database rows, credentials or unrelated files. Compare observed database paths with the launch receipt's owned root. A real-profile database is evidence that app-state isolation changed, not proof that every tool override disappeared; reconcile each writer separately before applying changes. Preserve the operator's state rather than restoring an old profile merely to regain an isolation claim.

## 3. Open a pinned local installer

Construct the command from verified absolute paths using `shlex.quote`, then JSON-escape it for AppleScript rather than manually nesting shell quotes. Use the operator's real HOME and the project's validated task-only PATH/toolchain; never inherit a test worker's HOME or offline proxy settings.

Command shape:

```sh
cd "$SERVER_WT" &&
test "$(git rev-parse HEAD)" = "$SERVER_HEAD" &&
test -z "$(git status --porcelain --untracked-files=all)" &&
env HOME="$OPERATOR_HOME" \
    PATH="$VALIDATED_PATH" \
    GOTOOLCHAIN="$VALIDATED_GO_TOOLCHAIN" \
    LEORNA_IMAGE_SOURCE=local \
    DOCKER_DEFAULT_PLATFORM=linux/amd64 \
    "$LAUNCHER_BIN"
```

Use the deployment architecture authorized by the test; do not substitute the Mac's host architecture. The working directory is essential because local-image installation consumes that source tree.

AppleScript shape, with `COMMAND_AS_APPLESCRIPT_STRING` safely encoded by the caller:

```applescript
tell application "Terminal"
    set launchTab to do script COMMAND_AS_APPLESCRIPT_STRING
    set custom title of launchTab to "Leorna feature - SERVER installer"
    activate
    return launchTab
end tell
```

Retain the returned tab/window handle. Read `custom title` and `busy` from **that exact target**, then use fresh process discovery to verify one intended artifact process. Never use whichever Terminal window happens to be frontmost. If the call times out, reconcile its actual effect before retrying; do not start another copy merely because no handle returned.

Keep these claims separate:

1. Exact Terminal readback and launcher process verified.
2. Operator confirms the Scaleway sign-in/project screen is visible.
3. Operator selects his own empty project and completes installation.
4. Deployed feature image and live server/client behavior verified.

Only advance from proof of that stage. A successful local launch is not evidence for stages below it.

## 4. Operator handoff and client launch

### Follow the observed state

Read the latest screenshot, give one current next action, and ask a question only when necessary information or permission is missing. Do not append a routine readiness question to every click. Use persisted table rows to establish completed membership, assignments and existing projects; do not ask for another create/assign click merely because a blank creation form is also present. Conversely, a selected team in that form is not evidence about an existing project's team association.

If a window is not visible, reconcile/restart only within the user's local permission; do not silently select a cloud project or provision resources. Keep private targets and sign-in details on-device. Give an image description when that is what the user asked for, without turning it into permission for a new app/server action.

### Resolve the client's independent storage boundaries

After server readiness and before launching the paired client for sign-in, recheck `CLIENT_BIN` and build a source-backed path/authority matrix:

| Boundary | Establish before use |
|---|---|
| App database, settings and temporary state | Trace the actual runtime directory resolution and supported overrides. State which paths remain task-owned and whether existing user state would be reused. |
| Claude, Codex, Cursor and project output | Trace each destination separately, including native user-directory lookup versus environment lookup. Check every displayed target before Sync; config-home bindings alone do not establish every writer's destination. |
| Native credential integration | Inspect the selected production vault backend and how it obtains its user/session/store context. Separate normal authentication storage from permission to inspect or alter the credential store. |
| Coordinator environment | Keep the operator's real HOME/profile binding separate from test process bindings; apply task overrides to the child invocation rather than leaving shared exports changed. |

Record actual supported bindings such as HOME/tool/config overrides only after tracing them in the current candidate. Do not invent a flag, assume an arbitrary HOME preserves native sign-in, or assume switching HOME back preserves tool isolation. Source/environment analysis is not runtime authentication proof. If supported bindings cannot satisfy both credential integration and the approved data/output boundaries, stop with a precise decision before launching a different configuration.

On Darwin, check `os.UserConfigDir` rather than assuming XDG overrides move app state: it normally uses `HOME/Library/Application Support`. Trace the real credential backend through subprocess creation too; a native backend that invokes an absolute `/usr/bin/security` with inherited environment can resolve default-keychain preferences under the test HOME, and a PATH shim will not change that executable. Tool config overrides do not necessarily cover user-level `.cursor` or `.agents` writers. Returning to the real HOME can therefore expose the real app DB/startup AutoSync, user tool roots and an existing credential entry even while Claude/Codex config overrides remain set. Reverify these details in the current candidate instead of treating them as permanent API contracts.

Classify a fully traced source mechanism plus a captured launch environment as source-supported, not runtime-confirmed. State inferred filesystem absence, unmatched OS source builds and untested alternatives explicitly. If a disposable native credential store is proposed, keep it UNAPPLIED until the operator approves that exact test-profile scope. Before any default/search-list setter, require a guarded canonical target, an expected initial scope and fail-closed handling of every command; an interactive throwaway password stays local and never goes into chat, agent typing, argv or a recorded script. A source-only proposal is not a validated correction or general permission to alter the user's normal Keychain.

Launch the verified binary with the approved bindings, not a similarly named installed app. Have the operator sign in. Distinguish these checkpoints: company discovery, saved company settings, browser/device approval, successful native credential storage, and authenticated client UI. An approval page or a running process does not establish the later checkpoints. Do not proceed to Sync while any required checkpoint is blocked.

For native project-folder selection, resolve the approved workspace from the current launch receipt and verify its canonical, existing, non-symlink path before giving instructions. Do not accept the picker's highlighted folder merely because its name sounds like a test: the dialog can start in an older real-user directory, which does not establish the app's HOME or output isolation. Give the exact approved path with **Cmd+Shift+G → paste → Return → Open**, then distinguish completed selection from proof of the full selected path. Prefer an existing supported absolute-path readback. If the UI exposes only a basename and no supported readback exists, ask once whether the operator pasted that exact canonical path; record the path and answer as **operator-attested selection**, not direct runtime readback. Do not keep requesting the same basename-only screenshot or repeat an answered confirmation unless the selection changes. An open picker or a highlighted row is not a completed selection, and selecting a folder is not permission to write elsewhere. Raw picker screenshots can expose unrelated personal filenames; crop/redact them before sharing.

### Review the proposed write set before application

1. Keep automatic startup updates off for a permission-scoped manual test unless the approved scenario explicitly requires them. Confirm the remote-project selection and local-project state from the current screen, not an earlier image.
2. Distinguish **Review Sync**, the confirmation checkbox and **Apply Sync**. An open review with an unchecked confirmation and disabled Apply button is review-state evidence, not an executed Sync. Before promising that preview is write-free, establish which supported operation writes app cache/settings versus actual tool files.
3. Check what the review actually exposes. Version and tool names do not prove absolute destinations, individual content items or deployed source identity. If paths are absent, reuse the existing path matrix and commission only the missing read-only binding/source check; do not rerun clean feature reviews or keep requesting screenshots of a summary that lacks those fields.
4. Confirm whether detected-tool checkboxes are editable or informational before telling the operator to exclude a tool. A checked or grey-looking control alone does not establish a supported tool-selection mechanism. When a subset is supported, uncheck out-of-scope tools and test only the permitted target; do not assume the project choice confines other tools' user-level writers. Treat the previous review and consent as stale after changing targets, reopen Review Sync as needed, and verify the displayed target list before confirmation. Keep excluded tools' acceptance criteria pending.
5. Classify every destination as **observed**, **source-inferred** or **unknown**, then compare the complete proposed writes with the actual permission. Use current process/path metadata and supported readbacks first. If nonsecret launch bindings are needed and authorized, extract only an explicit allowlist inside the tool before returning output; never print or persist a complete process environment, raw arguments or private values. Do not inspect credential stores or private tool configuration to compensate for missing path visibility.
6. Resolve app-state and tool-output scope separately. A project-only Sync can still record history and remember targets in the normal app database. Check whether existing approval covers those records; if not, ask for that narrow permission rather than blanket access to real tool homes. Group an independent exact-path confirmation and app-record permission into one `clarify` form when both are needed. Permission for normal desktop-app records does not authorize a normal native CLI profile's history/configuration, credential administration or broad tool-home writes.
7. Record the accepted tool subset, exact project path and its evidence class, permitted app records, automatic-update setting and unchanged exclusions before Apply. While scope is unresolved, hold application and return one concrete inspection or decision. Once resolved, give the operator the confirmation-checkbox → **Apply Sync once** procedure and request its result; do not repeatedly ask for already-settled readiness. A prepared bundle or confirmation screen never expands a one-file grant into a whole real-tool-home bundle.

### Diagnose a native credential blocker without changing user security state

When a native credential-store dialog blocks sign-in, identify the visible failure without echoing auth identifiers or approval codes. Ask the operator to cancel rather than use a reset/reinitialize action. If the same blocker returns, pause retries and start a bounded read-only diagnosis of the captured launch environment and actual vault implementation; do not repeat a Cancel/retry loop or restart the entire clean feature pipeline.

Keep an isolated-HOME explanation a hypothesis until supported by evidence. Do not reset/create/replace a user's default Keychain, read/export stored secrets, copy or symlink credential stores into scratch, remove auth checks, or substitute a mock/plaintext vault to manufacture live acceptance. A normal-HOME relaunch is an unapplied proposal until its app-state, credential and every tool-output consequence is established and authorized. No working correction is prescribed here: a failed or unresolved launch is not a validated recipe.

### Verify a scoped run without repeating Sync

After an authorized manual Apply, advance through these checkpoints without treating one as proof of the next:

1. **Sync result:** capture the actual per-tool status and exact item warnings. A successful tool run can skip individual content kinds. Identify the warned kind before attributing a failure to the feature under test; an agent-skip warning is not evidence that a prompt failed. Do not invent why an item was skipped.
2. **Recorded-file integrity:** use **Check files** for the completed run and capture its result, within the authorized app-record scope. A clean result proves agreement with recorded hashes, not that every required content item was included. Do not repeat Apply merely to obtain this check.
3. **Expected artifact:** check the specific approved output path using metadata first: regular file, not a symlink, canonical target inside the authorized workspace. Label file existence separately from body/frontmatter correctness. Read only the authorized artifact when semantic validation is necessary; do not inspect unrelated tool profiles or credentials.
4. **Native behavior:** retain a separate checkpoint for the actual tool's command menu or invocation, whichever the acceptance criterion requires. File existence, clean hashes, headless fixtures and an unapplied launch recipe are not interactive proof. Keep CLI profile/auth/write permission separate from desktop-app record permission; an unfinished launch preflight remains pending, not a validated workaround.

Where the native-tool step is already part of the approved scenario, include its executable, supported launch bindings and auth/write questions in the existing acceptance preparation when feasible. Reuse still-valid preparation instead of serially spawning a fresh checker after each successful screenshot; investigate only a newly unresolved boundary. Do not save unexecuted CLI or credential-store repair proposals as proven recipes.

### Native command-menu verification

Separate native CLI metadata, generated-prompt structure and interactive menu visibility. Bare/simple/safe modes can disable custom-command discovery or OAuth and therefore cannot stand in for an ordinary authenticated menu. Establish task-owned bindings before even help/version; do not assume a separate config directory shares the normal profile's login or macOS credential entry. A fresh isolated profile may require its own setup; normal-profile startup may write global state/cache/session backups. Ask for any missing normal-profile write/native-login scope explicitly, separately from permission for Leorna's app database. Never copy credentials or blindly fake HOME to manufacture native sign-in.

Check current official documentation and actual safely isolated help instead of adopting a stock skill's historical version, model pin or another person's configuration paths. Where supported, suppress prompt/transcript history explicitly; interactive history suppression is not write-free startup, and print-only no-session flags do not solve an interactive menu test. Type only a completion prefix without Enter; stop at unapproved login/security/trust prompts. For long Terminal commands use a short file-backed launch invocation, then verify the exact target's real process and UI. Carry any denied-input pause into every successor; do not reroute a blocked cleanup action.

### Preserve evidence and the current handoff

Capture actual admin, Sync, warning, file and menu evidence during their checks; log screenshots and fixture completion do not satisfy manual UI proof. Label user-provided screenshots as operator-observed state, preserve the original locally, and crop/redact copies without concealing the demonstrated result. Inspect sanitized copies for server addresses, tenant/account identifiers, auth-item labels, device approval codes, tokens and email before sharing.

Save source/artifact pins, exact new process/window handles, mode/architecture, supported bindings and the proven stage outcome in the feature evidence and handoff. Replace superseded current instructions without rewriting sealed historical reports. Keep installation, live acceptance, publication and teardown permissions distinct.
