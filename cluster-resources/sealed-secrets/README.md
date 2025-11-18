# Sealed Secrets for DB Credentials

This directory contains SealedSecret templates used by ArgoCD to create DB credentials in namespaces for apps.

How to create a sealed secret for the resume backend Postgres:

1. Generate a password and create a temporary secret in the `resume-db` namespace:

```bash
export PG_PASSWORD=$(openssl rand -hex 16)
kubectl --kubeconfig ~/.kube/config-oci -n resume-db create secret generic resume-backend-postgresql \
  --from-literal=postgresql-password="${PG_PASSWORD}" \
  --from-literal=postgresql-username="resume_user" \
  --from-literal=postgresql-database="resume_db" \
  --dry-run=client -o yaml > resume-backend-postgresql-secret.yaml
```

2. Seal the secret using kubeseal and the cluster's Sealed Secrets pub key (this requires access to the cluster):

```bash
kubeseal --format=yaml < resume-backend-postgresql-secret.yaml > sealed-resume-backend-postgresql.yaml
```

3. Copy that sealed secret into `cluster-resources/sealed-secrets/` and commit it to the repo. The ApplicationSet will apply it to the cluster.

4. Repeat steps to create a copy of the same secret for the `resume-app` namespace so the backend can read DB credentials locally (pods cannot read secrets from other namespaces).

Testing:

- After ArgoCD reconciles, verify the secret exists:
  kubectl --kubeconfig ~/.kube/config-oci -n resume-db get secret resume-backend-postgresql
  kubectl --kubeconfig ~/.kube/config-oci -n resume-app get secret resume-backend-postgresql

Quick test commands:

```bash
# Verify DB pods are running
kubectl --kubeconfig ~/.kube/config-oci -n resume-db get pods -l app.kubernetes.io/name=postgresql

# Verify the backend pod can connect to the DB (use the app's image or a debug pod if needed)
kubectl --kubeconfig ~/.kube/config-oci -n resume-app run -it --rm --image=postgres:15 debug -- bash -c \
"export PGPASSWORD=$(kubectl --kubeconfig ~/.kube/config-oci -n resume-app get secret resume-backend-postgresql -o jsonpath='{.data.postgresql-password}' | base64 --decode); psql -h resume-backend-postgresql.resume-db.svc.cluster.local -U resume_user -d resume_db -c '\dt'"
```
