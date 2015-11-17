provider "google" {
  account_file = "${file("pkey.json")}"
  project      = "${var.GOOGLE_PROJECT_ID}"
  region       = "us-central1"
}

//
// ARTIFACTS
//
resource "atlas_artifact" "atlasdemo" {
  name = "${var.ATLAS_USERNAME}/atlasdemo"
  type = "google.image"
}


//
// INSTANCES
//


resource "google_compute_instance" "atlasdemo" {
  name         = "${format("atlasdemo-%d", count.index)}"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"
  tags         = ["atlasdemo"]

  disk {
      image = "${atlas_artifact.atlasdemo.id}"
  }

  network_interface {
      network = "default"
      access_config {
          // Ephemeral IP
      }
  }
  count = 3
  lifecycle = {
    create_before_destroy = false
  }
}

//
// NETWORKING
//
resource "google_compute_firewall" "fwrule" {
    name = "atlasdemo-web"
    network = "default"
    source_ranges = ["10.241.0.0/16"]
    allow {
        protocol = "tcp"
        ports = ["80"]
    }
    target_tags = ["atlasdemo"]
}

resource "google_compute_forwarding_rule" "fwd_rule" {
    name = "fwdrule"
    target = "${google_compute_target_pool.tpool.self_link}"
    port_range = "80"
}

resource "google_compute_target_pool" "tpool" {
    name = "tpool"
    instances = [
        "${google_compute_instance.atlasdemo.*.self_link}"
    ]
}

output "lb_ip" {
  value = "${google_compute_forwarding_rule.fwd_rule.ip_address}"
}
