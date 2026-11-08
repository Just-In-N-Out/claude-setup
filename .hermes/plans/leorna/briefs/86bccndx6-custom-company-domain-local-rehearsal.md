# LOCAL REHEARSAL — 86bccndx6 custom company domain (AC4 stand-in, supporting evidence only)

Role: rehearsal runner. Justin has no DNS or domain to run AC4 live, and said on 2026-11-08 "run a fake test for now" (`<evidence>/rehearsal/justin.json`). Your job is to rehearse AC4's end-to-end chain **locally**, with real components wherever possible, and record exactly what it does and doesn't prove. This is **supporting evidence only: AC4 stays owed** (live, needs a test domain). Never write `ac.json`, never mark AC4 accepted, and never call this a live pass.

**Never:** edit, commit or stash anything in the story worktree; push, open PRs, post to ClickUp; touch Scaleway, real DNS, `/etc/hosts`, system CA stores, or anything needing `sudo`; restart Docker Desktop or WSL; touch `leorna-pg` or `ndx6-preview-*`. No nested agents.

## Load these skills first
`leorna` (incl. `references/live-acceptance-setup.md` for how live AC4 is meant to run), `engineering-best-practices`, `security-best-practices`. Follow the repo's `AGENTS.md`.

## Pins
- Worktree (read-only) `/home/justin/Leorna/leorna-control-plane/.claude/worktrees/86bccndx6-custom-company-domain`, accepted head `e6ea3d7f0ec1082be6330a2405835c637de5d6cb` (`ac-check-e6ea3d7.txt`: READY FOR THE USER, AC4 owed). Work from your own copy: `git -C <worktree> archive e6ea3d7 | tar -x -C <scratch>`.
- Approved plan: `~/.hermes/plans/leorna/evidence/86bccndx6/plan-approved.md` (AC4 at line 24). AC4's canonical live test is `TestCustomDomainLiveClientDiscovery` (`internal/web/custom_domain_live_test.go`); read what it asserts.
- The unchanged client: `leorna-client` at `feafa3cdf8fafaa1e07a92e32a698b5d9a9ac2c6`. The existing probe binary `/home/justin/.hermes/cache/scratch/ndx6-v-4fqmPu/bin/client-probe` (sha256 starting `803b4617`, `vcs.revision` feafa3c) is built from `internal/web/testdata/custom_domain_client_probe.go.txt`; reuse it if it fits, or rebuild it the same way.
- Your folder: `~/.hermes/plans/leorna/evidence/86bccndx6/rehearsal/` (keep `justin.json`). Scratch: `~/.cache/86bccndx6-rehearsal/`.

## What to rehearse
Mirror AC4 and its live test as closely as the machine allows:
1. **Real server.** Run the real control-plane server from the e6ea3d7 copy (built binary or a local image, as the repo's own local/demo docs do), with your own Postgres `_test` DB (and ClickHouse with CI's env if the server needs it), configured the way the installer configures a server after **Activate domain**: `LEORNA_PUBLIC_BASE_URL=https://leorna.company.test` (custom) and the generated URL as `https://<something>.functions.fnc.fr-par.scw.cloud.test` or similar, matching the env names the story's installer writes (read `internal/installer/scaleway/domain.go` `updateURLs`). Set up a tenant as a first sign-in would (use the repo's test/demo seeding path, not hand-written SQL, if one exists).
2. **Real HTTPS on both names.** Make a throwaway local CA and a certificate for both hostnames (a short Go program built with `-buildvcs=false`, or `openssl`), and terminate TLS in front of the server with SNI for both names (a small Go reverse proxy is fine), mirroring Scaleway's edge.
3. **Name resolution without touching the system.** Point both hostnames at 127.0.0.1 inside the client process only: e.g. a tiny driver around the unchanged client resolver whose `http.Transport.DialContext` maps those two names to the local proxy while keeping the real Host and SNI. Trust the throwaway CA only for that process (`SSL_CERT_FILE` or the driver's own pool). Say exactly how you did it.
4. **Assertions, mirroring the live test:** `https://leorna.company.test/.well-known/leorna` returns the tenant (id and name) and `Leorna-Custom-Domain: v1`; the generated origin returns the same tenant; the unchanged `leorna-client` resolver resolves both origins to the right tenant and backend; the generated-host browser redirect and `requireClient` host binding behave as the story's code says (spot-check one admin GET on the generated host → 307 to the custom origin, and one client API call with each host). Optionally run `TestCustomDomainLiveClientDiscovery` itself against the rehearsal if its manifest can point at local endpoints without faking the Scaleway image binding; if it can't, say why and don't force it.
5. **Negative controls**, so the rehearsal can fail: a wrong/unknown Host gets refused, a certificate for the wrong name is rejected by the client, and the server started without the custom URL doesn't serve the custom origin.

## Gates and environment
This is the Windows desktop (WSL): run heavy steps under `systemd-run --user --scope -p MemoryMax=4G -p MemorySwapMax=0 <cmd>`, export env vars instead of `--setenv` (logs echo the command line), and check `journalctl -u earlyoom --since "-30 min" -o short-iso | grep sending` before reading a 137/143/"Killed" as a result. The desktop has no host `pg_isready` (use `docker exec <c> pg_isready -h 127.0.0.1`). If Docker Desktop crashes, stop and report; don't restart it. Remove every container, process and scratch you start; keep the scripts in `rehearsal/scripts/`. gitleaks your folder before reporting; no real hostnames, emails or secrets in it.

## Report
- `verdict`: `rehearsal passed` / `rehearsal failed` / `blocked`, with each assertion and negative control's result and log path.
- A short **"what this proves / does not prove"** section. It must say it does not prove the Scaleway domain binding, real DNS, Scaleway's certificate issuance or a deployed Scaleway image, and that AC4 stays owed.
- A terminal or UI screenshot of the passing run (`rehearsal/rehearsal-run.png`; real PNG).
- `ac_status`: AC4 `not_run (live owed; local rehearsal only)`; other ACs unchanged from `ac-check-e6ea3d7.txt`.
- `skill_lessons[{skill, lesson, evidence, enforce}]`: only reusable lessons a future task needs that the skill doesn't already say (empty is normal). `enforce` is `none`, or a one-line proposal for a check (kind, what it checks, where it runs). Never edit skills or lessons yourself.
- End with `MAIN SESSION: check and save these skill_lessons now.`
