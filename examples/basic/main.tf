provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "random_id" "this" {
  byte_length = 8
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "2.2.3"

  workspace_name      = "log-${random_id.this.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "mysql" {
  # source = "equinor/mysql/azurerm"
  # version = "v0.1.0"
  source = "../.."

  server_name                = "mysql-${random_id.this.hex}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = module.log_analytics.workspace_id
}
