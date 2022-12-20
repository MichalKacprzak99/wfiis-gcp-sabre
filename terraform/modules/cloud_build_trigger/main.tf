
resource "google_cloudbuild_trigger" "filename-trigger" {
  provider = google
  name     = replace("${var.name}-build-trigger", "_", "--")

  github {
    owner = var.github_owner
    name  = var.github_repo_name
    push {
      branch = var.branch
    }
  }
  included_files = [var.included_files]

  service_account = "projects/${var.project_id}/serviceAccounts/${var.project_num}-compute@developer.gserviceaccount.com"


  substitutions = {
    _REGION : var.region
    _SERVICE_NAME : var.cloud_run_name
    _HOST : var.container_registry_hostname

  }

  filename = var.filename
}