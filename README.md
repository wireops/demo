# wireops demo

Sample self-hosted stacks and a scheduled job used to populate a wireops demo
environment for screenshots and docs. Not meant for production use — image
tags and ports are chosen for a local screenshot pass, not for real deploys.

## Stacks

- `stacks/uptime-monitor` — Uptime Kuma, single service, minimal `wireops.yaml`.
- `stacks/docs-site` — nginx + whoami, static page injected via inline
  `configs:` (no bind mounts — the worker only ever receives the rendered
  compose file, never the rest of the repo, so relative bind mounts to
  sibling repo files don't resolve on deploy).
- `stacks/metrics-stack` — Prometheus + Grafana + node-exporter, multi-service
  with named volumes, an inline `configs:` scrape config, and a `worker.tags`
  example.
- `stacks/gitea` — Gitea + Postgres + Redis + a runner, 4 services on 2
  networks with a `depends_on` chain (runner → gitea → db/cache) and 4 named
  volumes — good for showing off the dependency graph.
- `stacks/paperless` — Paperless-ngx + Postgres + Redis + Gotenberg + Tika,
  5 services, 2 networks, 6 named volumes, deepest dependency chain of the
  set.
- `stacks/nginx-configs-demo` — nginx serving a static page, both the page
  and the nginx config are separate files committed under `files/` and
  declared by name in `wireops.yaml`'s `configs:` (`name` + `path`), then
  referenced from `docker-compose.yml` via Compose's native `configs:`
  element. Unlike `docs-site`/`metrics-stack` above (which inline the
  content directly into `docker-compose.yml`), wireops resolves these from
  the separate git files and embeds them into the rendered compose file at
  deploy time — no bind mounts, no copy-pasting config content into YAML.

## Jobs

- `jobs/nightly-backup` — daily, `once`, tars a volume and prunes old backups.
- `jobs/healthcheck-ping` — every 15 min, `once_all` (fans out to every
  matching worker), curls each demo stack's exposed port.
- `jobs/gitea-db-vacuum` — weekly, `once`, runs `VACUUM ANALYZE` against the
  gitea stack's Postgres, targets the gitea stack's compose network directly.
- `jobs/prune-docker` — weekly, `once_all`, demo docker cleanup job.
- `jobs/config-demo-report` — daily, `once`, demonstrates `job.yaml`'s
  `configs:` (`name` + `path` + `target`): `files/report.sh` is a plain git
  file, resolved server-side and bind-mounted read-only into the job
  container at `/scripts/report.sh` — the worker never clones this repo, it
  only receives the resolved script content in the dispatch command.

All stacks and jobs target `worker.tags: [local, node]` — match those tags on
whichever worker you connect to this demo.

Point a wireops repository record at this repo, add a stack per `stacks/*`
subdirectory (or a wildcard import), and schedule each `jobs/*/job.yaml`.
