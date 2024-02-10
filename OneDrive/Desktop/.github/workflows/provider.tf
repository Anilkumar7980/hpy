provider "google" {
  credentials = file(var.google_application_credentials)
  project     = var.project_id
  region      = var.region
}
