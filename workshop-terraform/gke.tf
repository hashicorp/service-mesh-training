resource "random_id" "password" {
  byte_length = 16
}

resource "google_container_cluster" "cluster" {
  depends_on = ["google_project_services.services"]

  count = "${length(var.emails)}"
  
  project            = "${element(google_project.project.*.project_id, count.index)}"
  name               = "cluster"
  zone               = "${var.zone}"
  initial_node_count = 3

  additional_zones = []

  master_auth {
    username = "workshop"
    password = "${random_id.password.hex}"
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  node_config {
    machine_type = "${var.node_type}"

    labels {
      role = "workshop"
    }

    tags = ["workshop", "attendee"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/logging.write",
    ]

    # commented out b/c tf/gcp complaining about this being a beta feature
    #workload_metadata_config = {
      #node_metadata = "SECURE"
    #}
  }
}
