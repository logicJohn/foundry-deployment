provider "google" {
  project     = "foundryService"
  region      = "us-central1"
}


module "foundry_instance" {
    source = "../modules/foundry-vault"
}