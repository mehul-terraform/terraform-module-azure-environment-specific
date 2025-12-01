variable "web_app_container_name" {
  description = "The name of the Azure Web App container."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy the app."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
}

variable "service_plan_id" {
  description = "The ID of the Azure App Service Plan."
  type        = string
}

variable "docker_image_name" {
  description = "The Docker image to use for the single container (e.g., myusername/myapp:latest)."
  type        = string
  default     = null # Optional: Only used if deploying a single container
}

variable "app_settings" {
  description = "A map of application settings to configure the app."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "The subnet ID to associate with the network interface"
  type        = string
}

variable "docker_compose_image" {
  default = "mehul1887/nginx:latest"
}

variable "main_app_container_image" {
  description = "Docker image for the main application container"
  type        = string
  default     = "myacr.azurecr.io/myapp:latest" # Example Azure Container Registry image
}

variable "sidecar_container_image" {
  description = "Docker image for the sidecar container"
  type        = string
  default     = "myacr.azurecr.io/sidecar:latest" # Example Azure Container Registry image
}
