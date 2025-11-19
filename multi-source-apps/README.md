# Multi-source app templates

# NOTE: The Prometheus-based kube-prometheus-stack application has been replaced by Alloy (OpenTelemetry collector with Prometheus pipeline) for the resume app.

# To restore the previous setup, re-enable the `prometheus-app.yaml.disabled` file and remove `alloy-app.yaml`.

Key points:
Each app gets its own Helm release and its own namespace to avoid accidental cross-app data sharing.

## Observability migration notes

-- This repository uses Alloy (Grafana Alloy) to collect metrics and remote_write them to the central Mimir instance in the `observability` namespace.
-- Prometheus (kube-prometheus-stack) has been removed from this repository. The prior ApplicationSet entries were intentionally removed and replaced by Alloy + Mimir.
ServiceMonitor resources have been disabled in `all-infrastructure` to avoid requiring Prometheus operator. If you plan to re-enable Prometheus, revert these settings.

If you’d like to have database (Postgres) or other app-specific exporter metrics collected: - Enable the exporter for Postgres in `all-infrastructure/charts/postgres/resume-values.yaml` by setting `metrics.enabled: true` (no ServiceMonitor required). - Add a `metrics.prometheus.scrape_configs` entry to Alloy's `charts/alloy/values.yaml` pointing to the exporter service (we added the `resume-postgres` job as an example). - Verify Alloy can see and scrape the endpoint; Alloy will remote_write to Mimir for long-term storage.

- After Alloy is running, verify the `resume-backend` metrics are visible in Mimir by running a PromQL query in Grafana (Datasource: `Resume Mimir`) or via the Mimir query API.
- Once you confirm metrics are being written to Mimir, delete or clean up any Prometheus-related ApplicationSet entries and ServiceMonitor resources to complete the migration.
  Testing & verification:
- Use ArgoCD to sync `resume-app` and verify the Alloy deployment in the `resume-app` namespace. Confirm Alloy pods are running and have the configured remote_write endpoint.
- After Alloy is running, verify the `resume-backend` metrics are visible in Mimir by running a PromQL query in Grafana (Datasource: `Resume Mimir`) or via the Mimir query API.
- Once you confirm metrics are being written to Mimir, remove any local Prometheus configs if present (they were removed in this repository).
- Use ArgoCD to sync `resume-app` and verify the Alloy deployment in the `resume-app` namespace. Confirm Alloy pods are running and have the configured remote_write endpoint.
- After Alloy is running, verify the `resume-backend` metrics are visible in Mimir by running a PromQL query in Grafana (Datasource: `Resume Mimir`) or via the Mimir query API.
- Once you confirm metrics are being written to Mimir, delete or clean up any Prometheus-related ApplicationSet entries and ServiceMonitor resources to complete the migration.

# Postgres Helm releases for this repository

We use the Bitnami `postgresql` Helm chart for app-specific Postgres instances managed by ArgoCD.

Key points:

- Each app gets its own Helm release and its own namespace to avoid accidental cross-app data sharing.
- Chart versions are pinned inside `multi-source-apps/*.yaml`. Update the `chartVersion` value to upgrade the chart.
- We prefer `SealedSecret` for DB credentials so we can store them safely in Git.

How to upgrade the chart version:

Note: Postgres Helm releases are now managed by the `all-infrastructure` repository. To upgrade the chart version, edit the file in `all-infrastructure/multi-source-apps/` instead of this repo.

1. Update the chart `chartVersion` value in `all-infrastructure/multi-source-apps/postgres-resume-backend-app.yaml`.
2. Update the values file if any values have been deprecated/renamed.
3. Commit and push. ArgoCD will pick up the change and perform a Helm upgrade.
