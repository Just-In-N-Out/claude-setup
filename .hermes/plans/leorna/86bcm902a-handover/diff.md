# 86bcm902a — stop and show (diff at `9a9bdec`)

Branch `feat/86bcm902a-quick-start`, head `9a9bdecc2f6ab53356fddddbc62b06b6533a4867`, base `6c1709e39efd2d4efcb1fa226e0a8fa9221dc76f` (= GitHub `main`, re-checked 2026-10-29 15:46 UTC). Not pushed. `git status --porcelain`: 0 lines.

## Stat (`git diff --stat 6c1709e...HEAD`)

```
 README.md                                          |    4 +
 cmd/control-plane/main.go                          |    9 +-
 delivery/stories.json                              |    6 +
 internal/audit/README.md                           |    6 +
 internal/onboarding/README.md                      |   43 +-
 internal/onboarding/quickstart.go                  |  346 ++++++
 internal/onboarding/quickstart_test.go             |  476 +++++++
 internal/onboarding/starters.go                    |   77 ++
 internal/onboarding/starters_test.go               |   53 +
 .../migrations/000024_quick_starts.down.sql        |    1 +
 .../postgres/migrations/000024_quick_starts.up.sql |   23 +
 internal/store/postgres/quick_starts.go            |  177 +++
 internal/store/postgres/quick_starts_test.go       |  377 ++++++
 internal/store/postgres/store_test.go              |    6 +-
 internal/web/README.md                             |    9 +
 internal/web/handler.go                            |   19 +-
 internal/web/quick_start.go                        |  339 +++++
 internal/web/quick_start_test.go                   | 1300 ++++++++++++++++++++
 internal/web/setup.go                              |   33 +-
 19 files changed, 3294 insertions(+), 10 deletions(-)
```

## Checks

- `git diff --name-only 6c1709e...HEAD -- .github/`: **empty** (0 paths). No CI change.
- OpenAPI / contracts: **no change** (0 paths under `contracts/`, `packages/contracts/` or named openapi). No client change.
- `CLAUDE.md`: 0 paths.
- Commits: 21; authors: Justin Issa <justin@leorna.com> (1 identity); committers: Justin Issa <justin@leorna.com> .
- Commit bodies matching `^co-authored-by:|generated with|noreply@anthropic|🤖` (case-insensitive): 0.
- Subjects not `feat(86bcm902a):`/`fix(86bcm902a):`: 0.

## Commits

```
deef0f6 feat(86bcm902a): role starter stand-in list and its resolution against the library
d94c8e0 feat(86bcm902a): quick start service that assigns a starter pack to a team
61399c6 feat(86bcm902a): quick_starts table (migration 24) and its audited store
7bddcbe feat(86bcm902a): quick start panel, page and routes in the admin console
53a69ef feat(86bcm902a): check delivered starter items are closed under their requirements
0737395 feat(86bcm902a): document the quick start and record the story
5303863 feat(86bcm902a): log the engineer's sync before and after in the AC tests
7b45d43 feat(86bcm902a): simplify a test condition for staticcheck
96b86ec fix(86bcm902a): pin the role mapping in a literal test and use 901r's secure coding pack name
f5c12fa fix(86bcm902a): pin the routes' own admin check and the quick start's tenant key in tests
5a6d185 fix(86bcm902a): finish a quick start pick when the browser goes away mid-request
4ac80bb fix(86bcm902a): reuse only the pack the name index matches and say so in the done sentence
58422ad fix(86bcm902a): say when a quick start pick found setup busy, and prove the setup lock in AC4
707a4c0 fix(86bcm902a): put a starter card's pack name and description on their own lines
789791b fix(86bcm902a): make the quick start done shape two-sided
66afa86 fix(86bcm902a): pin PackByName to the whole name in the store test
15f3d8f fix(86bcm902a): refuse a done quick start row that carries nothing
71dc9bd fix(86bcm902a): check the done sentence's version number past 1
19baa19 fix(86bcm902a): test the quick start pick's time bound
28c0944 fix(86bcm902a): write nothing when the same quick start pick is made again
9a9bdec fix(86bcm902a): pin that only a done record counts as the same pick
```

## Gates on `9a9bdec` (the verifier's own run, `evidence/86bcm902a/verifier/`)

```
make-check EXIT=0
module-add EXIT=0
pg-json EXIT=0
unit EXIT=0
story-gate EXIT=0
gitleaks-story EXIT=0
porcelain after: 0
done 2026-10-29T15:05:17Z
```

Plus the image build (`image-9a9bdec.txt`: `docker build --no-cache` EXIT=0, packaged gitleaks `8.30.1`) and the Postgres stream (`pg-9a9bdec-summary.txt`: 501 pass, 4 allowed skips, no skip naming `LEORNA_TEST_DATABASE_URL`, all 260 declared top-level tests have a result, all 50 `TestQuickStart*` results pass). `ac-check.sh`: `ALL ACCEPTED: 5 of 5 ACs on 9a9bdec`.

## Key hunks

### `internal/store/postgres/migrations/000024_quick_starts.up.sql`

```diff
+++ b/internal/store/postgres/migrations/000024_quick_starts.up.sql
@@ -0,0 +1,23 @@
+-- One-click quick start (story 86bcm902a). One row per tenant once an admin
+-- has skipped or finished the quick start; no row means it is still offered.
+CREATE TABLE quick_starts (
+ tenant_id uuid PRIMARY KEY REFERENCES tenants(id) ON DELETE RESTRICT,
+ status text NOT NULL CHECK (status IN ('skipped','done')),
+ starter text NULL CHECK (char_length(starter) <= 64 AND starter ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
+ pack_id uuid NULL,
+ -- The pack version number the pick assigned, and whether the pick reused a
+ -- pack the tenant already had (the done sentence says so).
+ pack_number integer NULL CHECK (pack_number >= 1),
+ pack_reused boolean NOT NULL DEFAULT false,
+ -- The tenant check is in CompleteQuickStart; this key only clears a deleted team.
+ team_id uuid NULL REFERENCES teams(id) ON DELETE SET NULL,
+ updated_by uuid NOT NULL,
+ updated_at timestamptz NOT NULL DEFAULT now(),
+ -- A done row has a starter, a pack and its version number; a skipped row has
+ -- none of them and is never "reused".
+ CONSTRAINT quick_starts_done_shape CHECK (
+   (status = 'done' AND starter IS NOT NULL AND pack_id IS NOT NULL AND pack_number IS NOT NULL)
+   OR (status <> 'done' AND starter IS NULL AND pack_id IS NULL AND pack_number IS NULL AND NOT pack_reused)),
+ CONSTRAINT quick_starts_skipped_has_no_team CHECK (status = 'done' OR team_id IS NULL),
+ CONSTRAINT quick_starts_pack_fk FOREIGN KEY (tenant_id, pack_id) REFERENCES pack_lineages (tenant_id, id) ON DELETE RESTRICT
+);
```

### `internal/store/postgres/migrations/000024_quick_starts.down.sql`

```diff
+++ b/internal/store/postgres/migrations/000024_quick_starts.down.sql
@@ -0,0 +1 @@
+DROP TABLE quick_starts;
```

### `cmd/control-plane/main.go`

```diff
@@ -28,6 +28,7 @@ import (
 	"github.com/LeornaAI/leorna-control-plane/internal/library"
 	"github.com/LeornaAI/leorna-control-plane/internal/library/gate"
 	"github.com/LeornaAI/leorna-control-plane/internal/metric/clickhouse"
+	"github.com/LeornaAI/leorna-control-plane/internal/onboarding"
 	"github.com/LeornaAI/leorna-control-plane/internal/pack"
 	"github.com/LeornaAI/leorna-control-plane/internal/secret"
 	"github.com/LeornaAI/leorna-control-plane/internal/store"
@@ -188,7 +189,13 @@ func run(ctx context.Context, logger *slog.Logger) error {
 	application.SetItemBuilder(itembuilder.New(versions, gate.NewGitleaks("gitleaks")))
 	application.SetPackAssignments(repository)
 	application.SetBundleServer(repository)
-	application.SetPackBuilder(pack.NewBuilderService(repository))
+	builder := pack.NewBuilderService(repository)
+	application.SetPackBuilder(builder)
+	quickStart, err := onboarding.NewQuickStart(shippedLibrary, repository, builder, repository, repository, repository)
+	if err != nil {
+		return err
+	}
+	application.SetQuickStart(quickStart)
 	encryptor, err := secret.New(runtimeConfig.SecretEncryptionKey)
 	if err != nil {
 		return err
```

### `internal/web/handler.go`

```diff
@@ -102,6 +102,8 @@ type Handler struct {
 	bundleServer                  bundleResolver
 	setupDatabases                setupDatabases
 	setupStore                    setupRepository
+	quickStart                    quickStarter
+	quickStartPickTimeout         time.Duration // zero: quickStartTimeout; tests shorten it
 	devLogin                      bool
 	autoSetup                     bool
 	bootstrapLoader               func(ctx context.Context, tenantID store.TenantID) error
@@ -290,6 +292,9 @@ func (handler *Handler) Routes() http.Handler {
 	routes.Handle("POST /admin/setup/database", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.setupDatabase)), false))
 	routes.Handle("POST /admin/setup/database/existing", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.setupExistingDatabase)), false))
 	routes.Handle("POST /admin/setup/pack", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.setupPack)), false))
+	routes.Handle("GET /admin/quick-start", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.quickStartPage)), true))
+	routes.Handle("POST /admin/quick-start", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.quickStartAssign)), false))
+	routes.Handle("POST /admin/quick-start/skip", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.quickStartSkip)), false))
 	routes.Handle("GET /v1/audit", handler.requireSession(handler.requireAdmin(api), false))
 	routes.Handle("GET /admin/audit", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.auditView)), true))
 	routes.Handle("GET /admin/third-party-content", handler.requireSession(handler.requireAdmin(http.HandlerFunc(handler.thirdPartyContentView)), true))
@@ -527,7 +532,8 @@ type adminPageData struct {
 	TenantID    store.TenantID
 	CSRFToken   string
 	Setup       *onboarding.Progress
-	Client      clientConnect // leorna-client onboarding domain + readiness (empty Domain hides the card)
+	QuickStart  *onboarding.QuickStartState // shown in the setup banner once setup is ready
+	Client      clientConnect               // leorna-client onboarding domain + readiness (empty Domain hides the card)
 }
 
 func (handler *Handler) admin(w http.ResponseWriter, r *http.Request) {
@@ -557,6 +563,14 @@ func (handler *Handler) admin(w http.ResponseWriter, r *http.Request) {
 			handler.logger.Warn("setup banner unavailable", "error", err)
 		}
 	}
+	var quickStart *onboarding.QuickStartState
+	if setup != nil && setup.Ready && handler.quickStartWired() {
+		if state, err := handler.quickStart.State(r.Context(), session.Principal); err == nil {
+			quickStart = &state
+		} else {
+			handler.logger.Warn("quick start banner unavailable", "error", err)
+		}
+	}
 
 	var page bytes.Buffer
 	if err := handler.template.Execute(&page, adminPageData{
@@ -566,6 +580,7 @@ func (handler *Handler) admin(w http.ResponseWriter, r *http.Request) {
 		TenantID:    session.Principal.TenantID,
 		CSRFToken:   csrfCookie.Value,
 		Setup:       setup,
+		QuickStart:  quickStart,
 		Client:      handler.clientConnectStatus(r.Context()),
 	}); err != nil {
 		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "The admin page could not be rendered", err)
@@ -752,7 +767,7 @@ const adminTemplate = `<!doctype html>
     <p>Your Google identity is connected to one server-resolved tenant.</p>
     ` + clientURLCardHTML + `
     {{if .Setup}}<section class="card" id="setup-banner">
-      {{if .Setup.Ready}}<p>Setup complete. <a href="/admin/setup">Review setup</a></p>{{else}}<p>Setup: {{.Setup.Done}} of 3 done. <a href="/admin/setup">Continue setup</a></p>{{end}}
+      {{if .Setup.Ready}}<p>Setup complete. <a href="/admin/setup">Review setup</a>{{if .QuickStart}}{{if ne .QuickStart.Status "done"}} · <a id="quick-start-banner" href="/admin/quick-start">{{if eq .QuickStart.Status "skipped"}}Resume quick start{{else}}Start the quick start{{end}}</a>{{end}}{{end}}</p>{{else}}<p>Setup: {{.Setup.Done}} of 3 done. <a href="/admin/setup">Continue setup</a></p>{{end}}
     </section>{{end}}
     <section class="card" aria-labelledby="session-title">
       <h2 id="session-title">Current session</h2>
```

### `internal/web/setup.go`

```diff
@@ -153,6 +153,16 @@ func (handler *Handler) renderSetupPage(w http.ResponseWriter, r *http.Request,
 		}
 		autoRefresh = setupIsAdvancing(progress)
 	}
+	var quickStart quickStartPanel
+	if progress.Ready && handler.quickStartWired() {
+		// The panel is a convenience on this page: a read error hides it, as the
+		// admin home does with the setup banner.
+		if panel, err := handler.loadQuickStartPanel(r.Context(), actor, cookie.Value, true); err == nil {
+			quickStart = panel
+		} else {
+			handler.logger.Warn("quick start panel unavailable", "error", err)
+		}
+	}
 	nonce, err := handler.randomHex(16)
 	if err != nil {
 		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "Setup could not be rendered", err)
@@ -161,7 +171,7 @@ func (handler *Handler) renderSetupPage(w http.ResponseWriter, r *http.Request,
 	var page bytes.Buffer
 	if err := setupTemplate.Execute(&page, setupPageData{
 		Nonce: nonce, CSRF: cookie.Value, Progress: progress, Pack: current, Notice: notice,
-		AutoRefresh: autoRefresh, Client: handler.clientConnectStatus(r.Context()),
+		AutoRefresh: autoRefresh, Client: handler.clientConnectStatus(r.Context()), QuickStart: quickStart,
 	}); err != nil {
 		handler.writeProblem(w, r, http.StatusInternalServerError, "RENDER_FAILED", "Setup could not be rendered", err)
 		return
@@ -387,7 +397,8 @@ type setupPageData struct {
 	Pack        pack.Pack
 	Notice      setupNotice
 	AutoRefresh bool
-	Client      clientConnect // leorna-client onboarding domain + readiness (empty Domain hides the card)
+	Client      clientConnect   // leorna-client onboarding domain + readiness (empty Domain hides the card)
+	QuickStart  quickStartPanel // the quick start offer once setup is ready (story 86bcm902a)
 }
 
 var setupTemplate = template.Must(template.New("setup").Parse(`<!doctype html>
@@ -409,6 +420,7 @@ var setupTemplate = template.Must(template.New("setup").Parse(`<!doctype html>
     input { min-height: 44px; padding: .5rem .75rem; border: 1px solid #2b4058; border-radius: .5rem; background: #07111f; color: #eef6ff; }
     form button { margin-top: 1rem; }
     ` + clientURLCSS + `
+    ` + quickStartCSS + `
   </style>
 </head>
 <body>
@@ -426,6 +438,21 @@ var setupTemplate = template.Must(template.New("setup").Parse(`<!doctype html>
       <p><a class="view" href="/admin/workspace">Open your workspace →</a></p>
       <p class="meta">Next: <a href="/admin/teams">create a team</a> · <a href="/admin/projects">add a project</a> · <a href="/admin/packs">browse the catalog</a> · <a href="/admin">admin home</a></p>
     </section>
+    {{if .QuickStart.Wired}}
+    <section class="card" id="quick-start">
+      <h2>Quick start: give a team a starter pack</h2>
+      {{if eq .QuickStart.State.Status "done"}}
+      {{template "quick-start-done" .QuickStart.State}}
+      <p class="meta"><a href="/admin/quick-start">Give another team a starter pack</a> · <a href="/admin/packs/assignments">See pack assignments</a> · <a href="/admin/teams">Add engineers to the team</a> · <a href="/admin/projects">Add a project</a></p>
+      {{else if eq .QuickStart.State.Status "skipped"}}
+      <p id="quick-start-skipped">You skipped the quick start. You can pick it up any time.</p>
+      <p><a class="view" id="quick-start-resume" href="/admin/quick-start">Resume quick start →</a></p>
+      {{else}}
+      <p class="meta">Pick a role's starter pack and a team. Engineers in that team get it the next time their Leorna client syncs.</p>
+      {{template "quick-start-offer" .QuickStart}}
+      {{end}}
+    </section>
+    {{end}}
     {{end}}
     <ol>
       <li><section class="step step-{{.Progress.Login}}" id="step-login">
@@ -487,4 +514,4 @@ var setupTemplate = template.Must(template.New("setup").Parse(`<!doctype html>
           <label for="existing-password">Password</label><input id="existing-password" name="password" type="password" autocomplete="new-password">
           <button type="submit">Test and connect</button>
         </form>
-{{end}}`))
+{{end}}` + quickStartPartsHTML))
```

### `internal/onboarding/starters.go` (new, 77 lines: the stand-in for 86bcm901r)

```go
// starters is a stand-in for 86bcm901r "Role-based starter packs", which is
// still open: the roles and items are that card's proposed mapping ("to
// confirm"), with upstream's /plan command shipped as prompt "planning", and
// the pack names are the ones 901r's branch uses. 86bcm901r replaces this list.
var starters = []Starter{
	{
		Key: "backend", Role: "Backend", PackName: "Backend starter pack",
		Description: "Spec, plan, build, test and review backend services and APIs.",
		Items: []StarterRef{
			skill("spec-driven-development"), skill("planning-and-task-breakdown"), skill("incremental-implementation"),
			skill("test-driven-development"), skill("api-and-interface-design"), skill("code-review-and-quality"),
			skill("debugging-and-error-recovery"),
			prompt("spec"), prompt("planning"), prompt("build"), prompt("test"), prompt("review"),
		},
	},
	{
		Key: "frontend", Role: "Frontend", PackName: "Frontend starter pack",
		Description: "Build and test user interfaces and keep pages fast.",
		Items: []StarterRef{
			skill("frontend-ui-engineering"), skill("browser-testing-with-devtools"), skill("performance-optimization"),
			agent("web-performance-auditor"), prompt("webperf"),
		},
	},
	{
		Key: "platform-devops", Role: "Platform/DevOps", PackName: "Platform/DevOps starter pack",
		Description: "CI/CD, versioning, observability, launches and migrations.",
		Items: []StarterRef{
			skill("ci-cd-and-automation"), skill("git-workflow-and-versioning"), skill("observability-and-instrumentation"),
			skill("shipping-and-launch"), skill("deprecation-and-migration"), prompt("ship"),
		},
	},
	{
		Key: "secure-coding", Role: "Secure coding (regulated)", PackName: "Secure coding (regulated) starter pack",
		Description: "Security hardening, careful review and recorded decisions for regulated teams.",
		Items: []StarterRef{
			skill("security-and-hardening"), skill("code-review-and-quality"), skill("doubt-driven-development"),
			skill("documentation-and-adrs"), skill("source-driven-development"), agent("security-auditor"), prompt("review"),
		},
	},
}
```

### `internal/onboarding/quickstart.go` (new, 346 lines): `Apply` (lines 206–264)

```go
// Apply makes the chosen starter the team's default pack. Every check that can
// refuse the request runs before the first write. The writes run in order: the
// team (when new), the pack (an existing pack with the starter's name is
// reused), the assignment, then the done record; with a reused pack, the last
// two only when they change (see changes). A failure part-way keeps what
// was already written: a new team stays (a retry picks it from the list, since
// its name is now taken) and a new pack is reused by the retry. The web layer
// runs Apply to its end even when the browser goes away.
func (q *QuickStart) Apply(ctx context.Context, actor store.Principal, choice QuickStartChoice) (QuickStartResult, error) {
	offer, ok := q.offer(choice.Starter)
	if !ok {
		return QuickStartResult{}, ErrUnknownStarter
	}
	teamID, newTeam := strings.TrimSpace(choice.TeamID), strings.TrimSpace(choice.NewTeamName)
	if (teamID == "") == (newTeam == "") {
		return QuickStartResult{}, ErrTeamChoice
	}
	ids, err := q.libraryIDs(ctx, actor, offer)
	if err != nil {
		return QuickStartResult{}, err
	}
	var team org.Team
	if teamID != "" {
		team, err = q.teams.GetTeam(ctx, actor, teamID)
	} else {
		team, err = q.teams.CreateTeam(ctx, actor, newTeam)
		if errors.Is(err, store.ErrConflict) {
			err = ErrTeamNameTaken
		}
	}
	if err != nil {
		return QuickStartResult{}, err
	}
	result := QuickStartResult{Offer: offer, Team: team, CreatedTeam: newTeam != ""}
	if err := q.starterPack(ctx, actor, offer, ids, &result); err != nil {
		return QuickStartResult{}, err
	}
	assign, record := true, true
	if !result.CreatedPack {
		// A new pack changes both; a reused one may repeat what is in place.
		if assign, record, result.State, err = q.changes(ctx, actor, result); err != nil {
			return QuickStartResult{}, err
		}
	}
	if assign {
		if _, err := q.assign.AssignTeam(ctx, actor, team.ID, result.Version); err != nil {
			return QuickStartResult{}, err
		}
	}
	if record {
		result.State, err = q.state.CompleteQuickStart(ctx, actor, QuickStartCompletion{
			Starter: offer.Key, PackID: result.PackID, TeamID: team.ID, PackNumber: result.Number, PackReused: !result.CreatedPack,
		})
		if err != nil {
			return QuickStartResult{}, err
		}
	}
	return result, nil
}
```

`starterPack` (lines 322–346): create, or reuse the pack the name index matches

```go
// starterPack fills result with the tenant's pack for the offer: a new pack at
// version 1, or, when the tenant already has a pack the pack name index treats
// as the same name (an earlier pick, an admin's own pack, a concurrent save),
// that pack at its latest version. The database's own index decides what
// "the same name" is, so no pack it would allow alongside is reused.
func (q *QuickStart) starterPack(ctx context.Context, actor store.Principal, offer StarterOffer, ids []string, result *QuickStartResult) error {
	built, err := q.packs.CreatePack(ctx, actor, offer.PackName, ids)
	if errors.Is(err, pack.ErrNameTaken) {
		found, findErr := q.state.PackByName(ctx, actor, offer.PackName)
		if errors.Is(findErr, store.ErrNotFound) {
			// Never a not-found or conflict status: the team and starter were fine.
			return errors.New("starter pack name is taken but the pack was not found")
		}
		if findErr != nil {
			return findErr
		}
		result.PackID, result.Version, result.Number = found.ID, found.LatestVersion, found.LatestNumber
		return nil
	}
	if err != nil {
		return err
	}
	result.PackID, result.Version, result.Number, result.CreatedPack = built.PackID, built.Version.Version, built.Number, true
	return nil
}
```

### `internal/store/postgres/quick_starts.go` (new, 177 lines): `CompleteQuickStart` (lines 68–110)

```go
// CompleteQuickStart records "done" with the starter, pack (with the version
// number assigned and whether it was reused) and team, with its
// quickstart.complete audit record in the same transaction. The team and the
// pack must be the actor's tenant's. Admin only.
func (database *Store) CompleteQuickStart(ctx context.Context, actor store.Principal, done onboarding.QuickStartCompletion) (onboarding.QuickStartState, error) {
	if len(done.Starter) > 64 || !starterKey.MatchString(done.Starter) || !validUUID(done.PackID) || !validUUID(done.TeamID) || done.PackNumber < 1 {
		return onboarding.QuickStartState{}, org.ErrInvalid
	}
	packID, teamID := strings.ToLower(done.PackID), strings.ToLower(done.TeamID)
	tx, _, err := database.beginOrg(ctx, actor, true)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()
	// team_id's foreign key alone would accept another tenant's team.
	var ownTeam bool
	if err := tx.QueryRow(ctx, `SELECT EXISTS(SELECT 1 FROM teams WHERE tenant_id=$1 AND id=$2)`, actor.TenantID, teamID).Scan(&ownTeam); err != nil {
		return onboarding.QuickStartState{}, orgError(err)
	}
	if !ownTeam {
		return onboarding.QuickStartState{}, store.ErrNotFound
	}
	before, err := quickStartTx(ctx, tx, actor.TenantID, true)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	if _, err := tx.Exec(ctx,
		`INSERT INTO quick_starts(tenant_id,status,starter,pack_id,pack_number,pack_reused,team_id,updated_by) VALUES($1,'done',$2,$3,$4,$5,$6,$7)
		 ON CONFLICT (tenant_id) DO UPDATE SET status='done', starter=EXCLUDED.starter, pack_id=EXCLUDED.pack_id,
		   pack_number=EXCLUDED.pack_number, pack_reused=EXCLUDED.pack_reused,
		   team_id=EXCLUDED.team_id, updated_by=EXCLUDED.updated_by, updated_at=now()`,
		actor.TenantID, done.Starter, packID, done.PackNumber, done.PackReused, teamID, actor.UserID); err != nil {
		return onboarding.QuickStartState{}, orgError(err) // another tenant's pack: 23503 -> store.ErrNotFound
	}
	after, err := quickStartTx(ctx, tx, actor.TenantID, false)
	if err != nil {
		return onboarding.QuickStartState{}, err
	}
	if err := database.appendAudit(ctx, tx, actor, "quickstart.complete", string(actor.TenantID), quickStartAudit(before), quickStartAudit(after)); err != nil {
		return onboarding.QuickStartState{}, orgError(err)
	}
	return after, orgError(tx.Commit(ctx))
}
```

### `internal/web/quick_start.go` (new, 339 lines): `quickStartAssign` (lines 126–180)

```go
func (handler *Handler) quickStartAssign(w http.ResponseWriter, r *http.Request) {
	if !handler.quickStartWired() {
		handler.writeProblem(w, r, http.StatusServiceUnavailable, "QUICK_START_UNAVAILABLE", "The quick start is unavailable")
		return
	}
	session, form, ok := handler.adminForm(w, r)
	if !ok {
		return
	}
	choice := onboarding.QuickStartChoice{Starter: form.Get("starter"), TeamID: strings.TrimSpace(form.Get("team_id")), NewTeamName: strings.TrimSpace(form.Get("team_name"))}
	refill := quickStartPanel{Starter: choice.Starter, TeamID: choice.TeamID, TeamName: choice.NewTeamName}
	var notReady bool
	var applyErr error
	// The pick runs to its end even when the browser goes away (a double-click
	// or a closed tab cancels the request): stopping between its writes would
	// leave a new team without its pack. quickStartTimeout still bounds it.
	ctx, cancel := context.WithTimeout(context.WithoutCancel(r.Context()), handler.pickTimeout())
	defer cancel()
	ran, err := handler.setupStore.TrySetupLock(ctx, session.Principal.TenantID, func() error {
		progress, _, stateErr := handler.setupState(ctx, session.Principal)
		if stateErr != nil {
			return stateErr
		}
		if !progress.Ready {
			notReady = true
			return nil
		}
		_, applyErr = handler.quickStart.Apply(ctx, session.Principal, choice)
		return nil
	})
	switch {
	case err != nil:
		handler.writeProblem(w, r, http.StatusInternalServerError, "QUICK_START_FAILED", "The quick start could not finish", err)
	case !ran:
		// Another setup or quick-start step is running (a double-click's first
		// submit, a second tab): nothing was saved, and the page says so above
		// the other step's result.
		w.Header().Set("Cache-Control", "no-store")
		http.Redirect(w, r, "/admin/quick-start?notice="+quickStartBusyNotice, http.StatusSeeOther)
	case notReady:
		refill.Notice = quickStartNotReady
		handler.renderQuickStart(w, r, http.StatusConflict, refill)
	case errors.Is(applyErr, org.ErrForbidden):
		handler.writeProblem(w, r, http.StatusForbidden, "FORBIDDEN", "Administration rights are required")
	case applyErr != nil:
		status, notice := quickStartFailure(applyErr)
		if status == http.StatusInternalServerError {
			handler.logSetupFailure(w, r, "QUICK_START_FAILED", applyErr)
		}
		refill.Notice = notice
		handler.renderQuickStart(w, r, status, refill)
	default:
		handler.redirectToQuickStart(w, r)
	}
}
```

`quickStartFailure` (lines 184–197): refusal → status and fixed notice (never echoes input)

```go
func quickStartFailure(err error) (int, string) {
	switch {
	case errors.Is(err, onboarding.ErrTeamNameTaken):
		return http.StatusConflict, "A team with that name already exists. Pick it from the list instead."
	case errors.Is(err, pack.ErrScriptApprovalRequired):
		return http.StatusConflict, "This starter pack has scripts to review first. Approve them on Pack versions, then try again."
	case errors.Is(err, store.ErrNotFound):
		return http.StatusNotFound, "That team isn't available. Pick one from the list or name a new team."
	case errors.Is(err, org.ErrInvalid):
		return http.StatusBadRequest, "Pick one starter pack, and either one team or a new team name."
	default:
		return http.StatusInternalServerError, "The quick start could not finish. It is safe to try again."
	}
}
```

### Docs and tests (not shown)

- Docs: root `README.md` (+4: authorization row, setup sentence), `internal/onboarding/README.md` (+42/-1: "Quick start (86bcm902a)" section; the intro now says the quick start answer is the one stored fact), `internal/web/README.md` (+9: three routes, the panel and the banner link), `internal/audit/README.md` (+6: `quickstart.skip`, `quickstart.complete`).
- Tests: `internal/web/quick_start_test.go` (+1300: the five AC tests plus done-sentence, browser-gone, time-bound and same-pick-again tests), `internal/onboarding/quickstart_test.go` (+476), `internal/onboarding/starters_test.go` (+53), `internal/store/postgres/quick_starts_test.go` (+377), `store_test.go` (`quick_starts` added to both round-trip table lists and the reset drop list).
- `delivery/stories.json`: `86bcm902a` appended last with `prs: []` (earlier 40 entries unchanged by value; the PR number goes in after the PR opens).
