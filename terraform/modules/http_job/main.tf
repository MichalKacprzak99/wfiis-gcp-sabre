resource "google_cloud_scheduler_job" "http_job" {
    name                    = var.name
    schedule                = var.schedule
    time_zone               = var.time_zone

    http_target {
        http_method         = "POST"
        uri                 = var.target
    }
}