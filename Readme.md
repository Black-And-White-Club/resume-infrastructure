# Resume Infrastructure

This repository houses the Infrastructure-as-Code (IaC) for my personal resume website. It leverages a variety of tools and technologies that I've learned while transitioning from QA Automation to DevOps. This project is built using primarily free and open-source tools, along with trial credits from Google Cloud Platform (GCP).

## Technologies Used

**Infrastructure:**

- **Terraform**
- **Google Cloud Platform (GCP)**
- **Artifact Registry**

**Deployment & Management:**

- **Kubernetes**
- **Helm**
  - [Argo CD](https://artifacthub.io/packages/helm/argo/argo-cd)
  - [Kube Prometheus Stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)
  - [Cert Manager](https://artifacthub.io/packages/helm/jetstack/cert-manager)
  - [Bitnami Postgres](https://artifacthub.io/packages/helm/bitnami/postgresql)
- **Argo CD**

**Application:**

- **Go** (backend API) - [Source Code](https://github.com/Black-And-White-Club/resume-backend)
- **Astro** (frontend) - [Source Code](https://github.com/Black-And-White-Club/resume-frontend)
- **Nginx**

**Monitoring & Observability:**

- **Prometheus**
- **Grafana**
- **Cert-Manager**

**Data:**

- **Postgres**

## Repository Structure

```bash
.
├── argocd-applications
├── charts
│   ├── argo-cd
│   ├── cert-manager
│   ├── postgres
│   └── prometheus
├── cluster-resources
├── multi-source-apps
├── resume-app-manifests
├── terraform
│   └── modules
│       ├── artifact-registry
│       ├── cloud-engine
│       └── service-account
└── the-overmind
```
