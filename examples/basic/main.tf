provider "azurerm" {
  features {}
}

resource "random_id" "this" {
  byte_length = 8
}

resource "random_password" "this" {
  length           = 72
  lower            = true
  upper            = true
  numeric          = true
  special          = true
  override_special = "!@#$%&_-+="
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
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

  server_name                  = "mysql-${random_id.this.hex}"
  server_version               = "5.7"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  administrator_login          = "mysqladmin"
  administrator_password       = random_password.this.result
  auto_grow_enabled            = false
  geo_redundant_backup_enabled = false
  log_analytics_workspace_id   = module.log_analytics.workspace_id

  server_configurations = [{
    name  = "require_secure_transport"
    value = "OFF"
  }]

  databases = [{
    name      = "foo"
    collation = "utf8mb4_unicode_ci"
    charset   = "utf8mb4"
  }]

  firewall_rules = [{
    name             = "AllowAllWindowsAzureIps"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
  }]
}
