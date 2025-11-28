resource "azurerm_linux_web_app" "app_service_container" {
  name                = var.web_app_container_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  site_config {
    always_on       = true   
  }

  app_settings = merge(
    var.app_settings,
    var.docker_image_name != null ? { "DOCKER_CUSTOM_IMAGE_NAME" = var.docker_image_name } : {}
  )

  identity { type = "SystemAssigned" }
  tags = merge(var.tags)
}

resource "azurerm_container_group" "example" {
  name                = "example-cg"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"

  container {
    name   = "app"
    image  = "mehul1887/nginx:latest"
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "example-cg"
}
