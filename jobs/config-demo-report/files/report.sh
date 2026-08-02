#!/bin/sh
# Committed to git, resolved server-side by wireops, and bind-mounted
# read-only into the job container at /scripts/report.sh (target set in
# job.yaml's `configs:` entry). The worker never clones this repo — it only
# ever sees the plaintext content wireops sends it in the run_job command.
set -eu

echo "wireops config demo report — $(date -u +%FT%TZ)"
echo "hostname: $(hostname)"
echo "disk usage:"
df -h / 2>/dev/null || true
