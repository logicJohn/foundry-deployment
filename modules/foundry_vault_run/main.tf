

resource "google_storage_bucket" "static-site" {
  name          = "foundry-vault-storage"
  location      = "US"
  force_destroy = true

}


resource "google_service_account" "service_account" {
  account_id   = "foundry-vault"
  display_name = "foundry-vault"
  description  = "Service account for foundry vault service running on cloud run"
}

resource "google_project_iam_binding" "bucket_binding" {
    project = "foundryservice"
    role = "roles/storage.objectAdmin"
    members = ["serviceAccount:${google_service_account.service_account.email}",]
}

resource "google_project_iam_binding" "secret_binding" {
    project = "foundryservice"
    role = "roles/secretmanager.secretAccessor"
    members = ["serviceAccount:${google_service_account.service_account.email}",]
}


resource "google_secret_manager_secret" "vault_secret" {
  secret_id = "vault-secret"
  replication {
    auto {
      
    }
  }
}

resource "google_kms_key_ring" "vault-keyring" {
    name = "vault-keyring"
    location = "global"
}

resource "google_kms_crypto_key" "vault_seal" {
    name = "vault-seal"
    key_ring = google_kms_key_ring.vault-keyring.id
    purpose = "ENCRYPT_DECRYPT"
  
}

resource "google_kms_crypto_key_iam_binding" "vault_key_iam" {
    crypto_key_id = google_kms_crypto_key.vault_seal.id
    role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    members = [
        "serviceAccount:${google_service_account.service_account.email}",
    ]
  
}

resource "google_cloud_run_v2_service" "vault_server" {
  name     = "foundry_vault"
  location = "us-central1"
  description = "vault server used by foundryvtt-autoform"
  ingress = "INGRESS_TRAFFIC_ALL"
  
   template {
    service_account = google_service_account.service_account.email
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      ports {
        container_port = 8200
      }
      resources {
        limits = {
          cpu    = "2"
          memory = "1024Mi"
        }
      }
    }
}