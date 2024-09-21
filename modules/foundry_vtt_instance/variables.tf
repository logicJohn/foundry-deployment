# Input variable definitions

variable "tags" {
  description = "Tags to set on instance"
  type        = set(string)
  default     = ["foundryvtt", "http-server", "https-server"]
}

variable "device_name" {
    description = "Name of compute engine instance"
    type        = string
    default     = "foundryvtt"
}

variable "size" {
    description = "Size of disk drive to container image"
    type        = number
    default     = 10
}

variable "machine_type" {
    description = "GCP core and memory size"
    type        = string
    default     = "e2-standard-4"
}

variable "zone" {
    description = "Zone in which"
    type        = string
    default        = "us-central1-c"
}  

variable "username" {
    description = "defintion of username"
    type        = string
}

variable "password" {
    description = "foundry password for username"
    type        = string
}

variable "data_dir" {
    description = "foundry data descritption"
    type        = string
}

variable "image" {
    description = "foundryvtt image and version"
    type        = string
}