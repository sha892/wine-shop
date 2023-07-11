resource "google_compute_instance_template" "my-template" {
  name           = "my-template"
  machine_type   = "e2-medium"
  can_ip_forward = false

  # Create a new boot disk from an image
  disk {
    source_image = "ubuntu-springboot-image"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc.self_link
    subnetwork = google_compute_subnetwork.subnet-1.self_link
    access_config {
    }
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/wine/getAllWines"
    port         = "8080"
  }
}

resource "google_compute_instance_group_manager" "my-app-igm" {
  name               = "my-app-igm"
  base_instance_name = "app"
  zone               = "us-central1-a"
  version {
    instance_template = google_compute_instance_template.my-template.self_link_unique
  }
  named_port {
    name = "http"
    port = 8080
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "autoscaler" {
  name   = "my-autoscaler"
  zone   = "us-central1-a"
  target = google_compute_instance_group_manager.my-app-igm.id
  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 2
    cooldown_period = 60
    cpu_utilization {
      target = 0.5
    }
  }
}
