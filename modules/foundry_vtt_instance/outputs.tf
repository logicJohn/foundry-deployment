output "id" {
    description = "name of foundry instance id"
    value = google_compute_instance.foundry_vtt.id
  
}

output "instance_id" {
    description = "name of foundry host id"
    value = google_compute_instance.foundry_vtt.instance_id
}

