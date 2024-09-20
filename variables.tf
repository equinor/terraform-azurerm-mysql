variable "server_name" {
  description = "The name of this MySQL server."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
}

variable "administrator_login" {
  description = "The login username of the administrator for this MySQL server."
  type        = string
}

variable "databases" {
  description = "A list of databases to create on the MySQL Flexible Server."
  type = map(object({
    name      = string
    collation = optional(string, "utf8_general_ci")
    charset   = optional(string, "utf8")
  }))
}

variable "server_version" {
  description = "The version of this MySQL server"
  default     = "5.7"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "The name of the SKU to use for this MySQL database."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_size_gb" {
  description = "Sets size for this MySQL database."
  type        = number
  default     = 20

  validation {
    condition     = var.storage_size_gb >= 20 && var.storage_size_gb <= 16384
    error_message = "Possible values are between 20 and 16384"
  }
}

variable "storage_auto_grow_enabled" {
  description = "Should Storage Auto Grow be enabled?"
  type        = bool
  default     = true
}

variable "geo_redundant_backup_enabled" {
  description = "Should geo redundant backup enabled?"
  type        = bool
  default     = false
}

variable "zone" {
  description = "Specifies the Availability Zone in which this MySQL Flexible Server should be located."
  type        = number
  default     = 1

  validation {
    condition     = contains([1, 2, 3], var.zone)
    error_message = "The zone must be 1, 2, or 3."
  }
}

variable "firewall_rules" {
  description = "A list of firewall rules to apply to the MySQL Flexible Server."
  type = map(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))

  default = {
    "azure" = {
      name             = "AllowAllWindowsAzureIps"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}
