resource "google_cloudbuild_trigger" "filename-trigger" {
  provider = google
  name     = replace("${var.name}-build-trigger", "_", "--")

  github {
    owner = "MichalKacprzak99"
    name  = "wfiis-gcp-sabre"
    push {
      branch = var.branch
    }
  }
  included_files = [var.included_files]


  substitutions = {
    _REGION : var.region
    _SERVICE_NAME : var.cloud_run_name
    _HOST : var.container_registry_hostname

  }

  filename = "cloudbuild.yaml"
}