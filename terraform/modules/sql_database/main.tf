
resource "google_sql_database_instance" "database_instance" {
    name = var.instance_name
    database_version = "MYSQL_8_0"
    deletion_protection = false
    settings {
        tier = var.tier
        backup_configuration {
            enabled = false
        }
    }
}

resource "google_sql_database" "database" {
    name = var.database_name
    instance = google_sql_database_instance.database_instance.name
}

resource "google_sql_user" "users" {
  name     = var.user_name
  instance = google_sql_database_instance.database_instance.name
  password = var.user_name
  type = "BUILT_IN"
}
