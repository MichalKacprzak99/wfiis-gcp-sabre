resource "google_cloud_run_service" "api" {
  name     = var.cloud_run_name
  location = var.location

  template {
    spec {
      containers {
        image = var.docker_image
        env {
          name  = "SQLALCHEMY_DATABASE_URL"
          value = var.sql_alchemy_database_url
        }
        env {
          name  = "SENDGRID_API_KEY"
          value = var.sendgrid_api_key
        }
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = var.cloudsql_instance_connection_name
      }
    }
  }
  autogenerate_revision_name = true

  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role    = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.api.location
  project  = google_cloud_run_service.api.project
  service  = google_cloud_run_service.api.name

  policy_data = data.google_iam_policy.noauth.policy_data
}