terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.25.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.project_region
}


resource "google_project_iam_binding" "admin-account-iam" {
  role    = "roles/cloudsql.client"
  members = ["serviceAccount:${var.project_number}@cloudbuild.gserviceaccount.com"]
  project = var.project_id
}

module "sql_database" {
  source        = "./modules/sql_database"
  user_name     = var.user_name
  user_password = var.user_password
}


module "api-service" {
  source                            = "./modules/cloud_run"
  location                          = var.project_region
  cloudsql_instance_connection_name = module.sql_database.cloudsql_instance_connection_name
  sendgrid_api_key                  = var.sendgrid_api_key
  sql_alchemy_database_url          = "mysql+pymysql://${var.user_name}:${var.user_password}@/${module.sql_database.cloudsql_database_name}?unix_socket=/cloudsql/${module.sql_database.cloudsql_instance_connection_name}"
  docker_image                      = "${var.container_registry_hostname}/${var.project_id}/${var.cloud_run_name}:latest"
  cloud_run_name                    = var.cloud_run_name
}


module "cloud_build_trigger" {
  source                      = "./modules/cloud_build_trigger"
  name                        = "api"
  included_files              = "src/api/**"
  branch                      = "main"
  container_registry_hostname = var.container_registry_hostname
  cloud_run_name              = var.cloud_run_name
  region                      = var.project_region
}


module "scheduler_job_monitor_animes_episodes" {
  source   = "./modules/http_job"
  target   = "${module.api-service.api_service_url}/animes/monitor/"
}
