resource "google_cloud_scheduler_job" "http_job" {
    name                    = var.scheduler_name
    schedule                = var.scheduler_cron_time
    time_zone               = var.scheduler_time_zone

    http_target {
        http_method         = "POST"
        uri                 = var.scheduler_target
    }
}