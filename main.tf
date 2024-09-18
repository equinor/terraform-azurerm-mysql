
resource "azurerm_mysql_flexible_server" "this" {
  name                         = var.server_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = var.server_version
  administrator_login          = var.administrator_login
  administrator_password       = var.administrator_password
  sku_name                     = var.sku_name
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  zone                         = var.zone

  storage {
    auto_grow_enabled = var.auto_grow_enabled
    size_gb           = var.size_gb
  }

  lifecycle {
    ignore_changes = [
      administrator_password
    ]
  }

  tags = var.tags
}

resource "azurerm_mysql_flexible_server_configuration" "this" {
  for_each = { for config in var.server_configurations : config.name => config }

  resource_group_name = azurerm_mysql_flexible_server.this.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name

  name  = each.value.name
  value = each.value.value
}

resource "azurerm_mysql_flexible_database" "this" {
  for_each = { for database in var.databases : database.name => database }

  resource_group_name = azurerm_mysql_flexible_server.this.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name

  name      = each.value.name
  collation = each.value.collation
  charset   = each.value.charset
}

resource "azurerm_mysql_flexible_server_firewall_rule" "this" {
  for_each = { for rule in var.firewall_rules : rule.name => rule }

  resource_group_name = azurerm_mysql_flexible_server.this.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name

  name             = each.value.name
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
