resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-rg"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.project_name}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "env" {
  name                       = "${var.project_name}-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_container_app" "app" {
  name                         = "${var.project_name}-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "api"
      image  = var.container_image
      cpu    = var.cpu
      memory = var.memory
      env { name = "ENV" value = "prod" }
    }
    http_scale_rule {
      name = "httpscale"
      min_replicas = 0
      max_replicas = 2
      http_concurrency = 50
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    transport        = "auto"
  }
}

output "container_app_fqdn" {
  value = azurerm_container_app.app.latest_revision_fqdn
}
