provider "google" {
  project     = "foundryService"
  region      = "us-central1"
}


module "foundry_vault" {
    source = "././modules/foundry_vault"
}