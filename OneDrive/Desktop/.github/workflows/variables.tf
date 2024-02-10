variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
  default = "asia-south1-a"
}

variable "vpc_name" {
  type = string
  default = "gcp-infra"
}

variable "public_subnet_cidr" {
  type = string
  default = "10.10.10.0/24"
}

variable "private_subnet_cidr" {
  type = string
  default = "10.10.20.0/24"
}

# ... (Existing variables from previous response)

variable "db_password" {
  type = string
  sensitive = true
}

variable "gke_num_nodes" {
  type = number
  default = 1
}

variable "gke_node_type" {
  type = string
  default = n1-standard-1
}



# ... (Add any additional variables for environment variables or other settings)


# Additional variables for PostgreSQL credentials, GKE cluster settings, etc.
