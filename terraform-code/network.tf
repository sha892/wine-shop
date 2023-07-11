# Create the VPC
resource "google_compute_network" "vpc" {
  name                    = "my-vpc-1"
  auto_create_subnetworks = false
}

# Create the subnet
resource "google_compute_subnetwork" "subnet-1" {
  name          = "my-subnet-01"
  ip_cidr_range = "10.0.0.0/28"
  network       = google_compute_network.vpc.self_link
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "subnet-2" {
  name          = "my-subnet-02"
  ip_cidr_range = "10.1.0.0/28"
  network       = google_compute_network.vpc.self_link
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Create Firewall rule
resource "google_compute_firewall" "allow-all" {
  name    = "allow-all"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "all"
  }
  source_ranges = ["0.0.0.0/0"]
}