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
  zone                         = var.zone

  storage {
    auto_grow_enabled = var.storage_auto_grow_enabled
    size_gb           = var.storage_size_gb
  }

  lifecycle {
    ignore_changes = [
      # Allow admin password to be updated outside of Terraform.
      administrator_password
    ]
  }

  tags = var.tags
}

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
