provider "google" {
  project     = "foundryservice"
  region      = "us-central1"
}


module "foundry_vault" {
    source = "../../modules/foundry_vault_run"
}