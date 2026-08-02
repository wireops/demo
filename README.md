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

## Jobs

- `jobs/nightly-backup` — cron-scheduled one-shot job (`job.yaml`), tars a
  volume and prunes old backups.

Point a wireops repository record at this repo, add a stack per `stacks/*`
subdirectory (or a wildcard import), and schedule `jobs/nightly-backup`.
