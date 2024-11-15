IaC Repo that consists of the actual frontend and backend of the application, using Go for the backend API and Astro for the frontend
ArgoCD managed via Helm Charts but also manages/monitors the deployments of the Helm Charts and Manifest
Helm Charts that are being used are ArgoCD (as mentiomed above) Kube-Prometheus-Stack (contains Prometheus and Grafana, Cert Manager, and Bitnamis Helm Chart for Postgres. 
You will notice that the there are really only Values.yml files and then a coresponding manifest which is referenced in the Mult Source Appset Manifests. 

saving for now TODO Rest of it 