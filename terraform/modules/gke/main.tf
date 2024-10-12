provider "google" {
  project = var.gcp_project_id
  region  = "us-central1"
}

resource "google_container_cluster" "example" {
  name               = "test-couster"
  location           = "us-central1"
  initial_node_count = 3

  node_pool {
    name       = "solo-dolo"
    node_count = 1

    node_config {
      machine_type = "n1-standard-2"
      disk_size_gb = 100
    }
  }
}
