
resource "google_sql_database_instance" "database_instance" {
    name = var.db_instance_name
    database_version = "MYSQL_8_0"
    deletion_protection = true
    settings {
        tier = var.db_tier
        backup_configuration {
            enabled = false
        }
    }
}

resource "google_sql_database" "database" {
    name = var.db_name
    instance = google_sql_database_instance.database_instance.name
}

resource "google_sql_user" "users" {
  name     = var.db_user_name
  instance = google_sql_database_instance.database_instance.name
  password = var.db_user_name
  type = "BUILT_IN"
}
