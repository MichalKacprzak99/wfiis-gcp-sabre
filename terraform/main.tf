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
  db_user_name     = var.db_user_name
  db_user_password = var.db_user_password
  db_name = var.db_name
  db_instance_name = var.db_instance_name
  db_tier          = var.db_tier
}


module "api_service" {
  source                            = "./modules/cloud_run"
  project_region                          = var.project_region
  cloudsql_instance_connection_name = module.sql_database.cloudsql_instance_connection_name
  sendgrid_api_key                  = var.sendgrid_api_key
  sql_alchemy_database_url          = "mysql+pymysql://${var.db_user_name}:${var.db_user_password}@/${module.sql_database.cloudsql_database_name}?unix_socket=/cloudsql/${module.sql_database.cloudsql_instance_connection_name}"
  docker_image                      = "${var.container_registry_hostname}/${var.project_id}/${var.cloud_run_name}:latest"
  cloud_run_name                    = var.cloud_run_name
}


module "cloud_build_trigger" {
  source                             = "./modules/cloud_build_trigger"
  container_registry_hostname        = var.container_registry_hostname
  cloud_run_name                     = var.cloud_run_name
  project_region                     = var.project_region
  project_id                         = var.project_id
  project_number                     = var.project_number
  github_repo_trigger_branch         = var.github_repo_trigger_branch
  cloud_trigger_build_filename       = var.cloud_trigger_build_filename
  github_repo_owner                  = var.github_repo_owner
  github_repo_name                   = var.github_repo_name
  cloud_build_trigger_included_files = var.cloud_build_trigger_included_files
  cloud_build_trigger_name           = var.cloud_build_trigger_name
}


module "scheduler_job_monitor_animes_episodes" {
  source    = "./modules/http_job"
  scheduler_target    = "${module.api_service.api_service_url}/animes/monitor/"
  scheduler_name      = var.scheduler_name
  scheduler_cron_time  = var.scheduler_cron_time
  scheduler_time_zone = var.scheduler_time_zone
}
