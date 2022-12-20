
resource "google_cloudbuild_trigger" "filename-trigger" {
  provider = google
  name     = replace("${var.cloud_build_trigger_name}-build-trigger", "_", "--")

  github {
    owner = var.github_repo_owner
    name  = var.github_repo_name
    push {
      branch = var.github_repo_trigger_branch
    }
  }
  included_files = [var.cloud_build_trigger_included_files]

  service_account = "projects/${var.project_id}/serviceAccounts/${var.project_number}-compute@developer.gserviceaccount.com"


  substitutions = {
    _REGION : var.project_region
    _SERVICE_NAME : var.cloud_run_name
    _HOST : var.container_registry_hostname

  }

  filename = var.cloud_trigger_build_filename
}