terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.3.0"
    }
  }

  required_version = ">= 1.9.8"
}
