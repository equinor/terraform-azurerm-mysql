output "server_id" {
  description = "The ID of this MySQL server."
  value       = azurerm_mysql_flexible_server.this.id
}

output "server_name" {
  description = "The name of this MySQL server."
  value       = azurerm_mysql_flexible_server.this.name
}

output "server_fqdn" {
  description = "The fully qualified domain name (FQDN) of this MySQL server."
  value       = azurerm_mysql_flexible_server.this.fqdn
}

output "administrator_login" {
  description = "The login username of the administrator for this MySQL server."
  value       = azurerm_mysql_flexible_server.this.administrator_login
}

output "administrator_password" {
  description = "The login password of the administrator for this MySQL server."
  value       = azurerm_mysql_flexible_server.this.administrator_password
}

output "databases" {
  description = "A map of MySQL databases."
  value = {
    for database in azurerm_mysql_flexible_database.this :
    database.name => {
      name = database.name
      id   = database.id
    }
  }
}
