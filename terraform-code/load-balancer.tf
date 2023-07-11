# reserved IP address
resource "google_compute_global_address" "lb-ip" {
  provider = google-beta
  name     = "tcp-proxy-xlb-ip"
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-proxy-xlb-forwarding-rule"
  provider              = google-beta
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http-proxy.id
  ip_address            = google_compute_global_address.lb-ip.id
}

# http proxy
resource "google_compute_target_http_proxy" "http-proxy" {
  name     = "l7-xlb-target-http-proxy"
  provider = google-beta
  url_map  = google_compute_url_map.my-map.id
}

resource "google_compute_url_map" "my-map" {
  name            = "url-map-target-proxy"
  description     = "a description"
  default_service = google_compute_backend_service.my-backend.id
}

# backend service
resource "google_compute_backend_service" "my-backend" {
  provider              = google-beta
  name                  = "http-proxy-xlb-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.lb-hc.id]
  backend {
    group           = google_compute_instance_group_manager.my-app-igm.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 1.0
    capacity_scaler = 1.0
  }
}

# health check
resource "google_compute_health_check" "lb-hc" {
  name               = "check-backend"
  check_interval_sec = 10
  timeout_sec        = 5
  http_health_check {
    request_path = "/wine/getAllWines"
    port         = "8080"
  }
}