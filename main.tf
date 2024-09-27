locals {
  diagnostic_setting_metric_categories = ["AllMetrics"]
}

resource "random_password" "this" {
  length      = 128
  lower       = true
  upper       = true
  numeric     = true
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_mysql_flexible_server" "this" {
  name                         = var.server_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = var.server_version
  administrator_login          = var.administrator_login
  administrator_password       = random_password.this.result
  sku_name                     = var.sku_name
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  zone                         = null # Automatically managed by Azure.

  storage {
    auto_grow_enabled = var.storage_auto_grow_enabled
    size_gb           = var.storage_size_gb
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      # Allow admin password to be updated outside of Terraform.
      administrator_password,

      # Allow availability zone to be automatically managed by Azure.
      zone
    ]
  }
}

# Ideally, we would create a resource "azurerm_mysql_flexible_server_active_directory_administrator" to enforce
# configuration of a Microsoft Entra administrator.
#
# However, this resource has a required property "identity_id" which requires the resource ID of a user-assigned managed
# identity with the following permissions in Microsoft Entra:
# - User.Read.All
# - GroupMember.Read.All
# - Application.Read.All
#
# We can't expect users of this module to have access to a user-assigned managed identity with these privileges in
# Microsoft Entra by default. As a result, we choose not to include that resource in this module.
#
# Ref: https://learn.microsoft.com/en-us/azure/mysql/flexible-server/how-to-azure-ad

resource "azurerm_mysql_flexible_database" "this" {
  for_each = var.databases

  resource_group_name = azurerm_mysql_flexible_server.this.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name

  name      = each.value.name
  collation = each.value.collation
  charset   = each.value.charset
}

resource "azurerm_mysql_flexible_server_firewall_rule" "this" {
  for_each = var.firewall_rules

  resource_group_name = azurerm_mysql_flexible_server.this.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name

  name             = each.value.name
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mysql_flexible_server_configuration" "aad_auth_only" {
  server_name         = azurerm_mysql_flexible_server.this.name
  resource_group_name = azurerm_mysql_flexible_server.this.resource_group_name
  name                = "aad_auth_only"
  value               = "ON"
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_mysql_flexible_server.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.65.0/docs/resources/monitor_diagnostic_setting#log_analytics_destination_type
  log_analytics_destination_type = null

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_enabled_log_categories)

    content {
      category = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = toset(concat(local.diagnostic_setting_metric_categories, var.diagnostic_setting_enabled_metric_categories))

    content {
      # Azure expects explicit configuration of both enabled and disabled metric categories.
      category = metric.value
      enabled  = contains(var.diagnostic_setting_enabled_metric_categories, metric.value)
    }
  }
}
