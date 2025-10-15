variable "project_name"    { type = string  default = "aca-secure-api" }
variable "location"        { type = string  default = "eastus" }
variable "container_image" { type = string  default = "ghcr.io/REPLACE_ME/aca-secure-api:latest" }
variable "cpu"             { type = number  default = 0.25 }
variable "memory"          { type = string  default = "0.5Gi" }
