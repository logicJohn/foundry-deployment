
# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "foundry_vtt" {
  boot_disk {
    auto_delete = true
    device_name = var.device_name

    initialize_params {
      image = "projects/cos-cloud/global/images/cos-stable-113-18244-151-57"
      size  = var.size
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    container-vm = "cos-stable-113-18244-151-57"
    goog-ec-src  = "vm_add-tf"
  }

  machine_type = var.machine_type

  metadata = {
    gce-container-declaration = "spec:\n  containers:\n  - name: foundryvtt\n    image: https://hub.docker.com/r/felddy/foundryvtt\n    stdin: false\n    tty: false\n  restartPolicy: Always\n# This container declaration format is not public API and may change without notice. Please\n# use gcloud command-line tool or Google Cloud Console to run Containers on Google Compute Engine."
    startup-script            = "./start-foundry"
  }

  name = "foundryvtt"

  network_interface {
    access_config {
      nat_ip       = "34.42.163.238"
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/foundryservice/regions/us-central1/subnetworks/default"
  }

  scheduling {
    automatic_restart   = false
    on_host_maintenance = "TERMINATE"
    preemptible         = false
    provisioning_model  = "SPOT"
  }

  service_account {
    email  = "foundry-service-user@foundryservice.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = var.tags
  zone = var.zone
}
