# VPC
resource "google_compute_network" "vpc" {
  name    = var.vpc_name
  project = var.project_id
  region  = var.region
}

# Public subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "${var.vpc_name}-public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}

# Private subnet for GKE cluster
resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.vpc_name}-private-subnet"
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.name
}

# Windows 10 jumpbox instance
resource "google_compute_instance" "jumpbox" {
  name         = "${var.vpc_name}-jumpbox"
  machine_type = "e2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.name
  }
}

# ... (Existing resources)

# PostgreSQL database
resource "google_sql_database_instance" "db" {
  name             = "${var.vpc_name}-db"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }

  # User authentication (using sensitive variable)
  user "infra_user" {
    name     = "infra-postgre"
    password = var.db_password  # Accessing the sensitive variable
  }
}


# GKE private cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "${var.vpc_name}-gke-cluster"
  location = var.region
  network  = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.private_subnet.name

  # Configure node pool and other settings
  node_pool {
    name      = "default-pool"
    machine_type = var.gke_node_type
    initial_node_count = var.gke_num_nodes
  }

# Container registry
resource "google_container_registry" "registry" {
  project = var.project_id
  location = var.region
}

# Cloud Storage bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name = "${var.vpc_name}-terraform-state"
}
