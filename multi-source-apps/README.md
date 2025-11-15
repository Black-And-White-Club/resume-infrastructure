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
