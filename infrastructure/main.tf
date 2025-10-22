terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "teetime-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.region
}

# Create Artifact Registry repository for Docker images
resource "google_artifact_registry_repository" "app" {
  location      = var.region
  repository_id = "teetime-store"
  description   = "Docker repository for TeeTime store"
  format        = "DOCKER"
}

# Create Cloud Run service
resource "google_cloud_run_service" "app" {
  name     = "teetime-store-service"
  location = var.region

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/${var.gcp_project}/teetime-store/app:latest"
        
        ports {
          container_port = 80
        }

        resources {
          limits = {
            cpu    = "1000m"
            memory = "512Mi"
          }
        }
      }
      container_concurrency = 80
      timeout_seconds      = 300
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_artifact_registry_repository.app]
}

# Make Cloud Run service publicly accessible
resource "google_cloud_run_service_iam_member" "public" {
  service  = google_cloud_run_service.app.name
  location = google_cloud_run_service.app.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Output the service URL
output "service_url" {
  description = "The URL of the Cloud Run service"
  value       = google_cloud_run_service.app.status[0].url
}

output "artifact_registry_url" {
  description = "The URL of the Artifact Registry repository"
  value       = google_artifact_registry_repository.app.name
}