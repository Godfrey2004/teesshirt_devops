output "application_url" {
  description = "The URL where the application is accessible"
  value       = google_cloud_run_service.app.status[0].url
}

output "artifact_registry" {
  description = "Artifact Registry repository details"
  value       = google_artifact_registry_repository.app.name
}