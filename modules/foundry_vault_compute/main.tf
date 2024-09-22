
resource "google_compute_firewall" "vault_firewall" {
  name          = "vault-firewall"
  network       = "default"

  allow {
    protocol    = "icmp"
  }

  allow {
    protocol    = "tcp"
    ports        = ["80", "8080", "8200"]
  }

  source_tags = ["vault-source"]
  target_tags = ["vault"]
}


# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "foundry_vault" {
  boot_disk {
    auto_delete = true
    device_name = "foundry-vault"

  initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20240910"
      size  = 10
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"
  name         = "foundry-vault"

  network_interface {
    access_config {
      nat_ip       = "35.225.181.1"
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/foundryservice/regions/us-central1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
    preemptible         = true
    provisioning_model  = "SPOT"
  }

  service_account {
    email  = "348066436876-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server", "vault"]
  zone = "us-central1-c"
}
