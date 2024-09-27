variable "server_name" {
  description = "The name of this MySQL server."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
  nullable    = false
}

variable "location" {
  description = "The location to create the resources in."
  type        = string
  nullable    = false
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
  nullable    = false
}

variable "administrator_login" {
  description = "The login username of the administrator for this MySQL server."
  type        = string
  default     = "mysqladmin"
  nullable    = false
}

variable "databases" {
  description = "A list of databases to create on the MySQL server."

  type = map(object({
    name      = string
    collation = optional(string, "utf8_general_ci")
    charset   = optional(string, "utf8")
  }))

  default  = {}
  nullable = false
}

variable "diagnostic_setting_name" {
  description = "The name of this diagnostic setting."
  type        = string
  default     = "audit-logs"
  nullable    = false
}

variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)
  default     = ["MySqlAuditLogs"]
  nullable    = false
}

variable "diagnostic_setting_enabled_metric_categories" {
  description = "A list of metric categories to be enabled for this diagnostic setting."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "server_version" {
  description = "The version of this MySQL server. Value must be \"5.7\" or \"8.0.21\"."
  type        = string
  default     = "8.0.21"
  nullable    = true

  validation {
    condition     = var.server_version == "8.0.21" || var.server_version == "5.7"
    error_message = "Possible values are \"5.7\", and \"8.0.21\""
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
  nullable    = true
}

variable "sku_name" {
  description = "The name of the SKU to use for this MySQL server."
  type        = string
  default     = "B_Standard_B1ms"
  nullable    = true
}

variable "storage_size_gb" {
  description = "The max storage allowed for this MySQL server in GB. Value must be between 20 and 16384."
  type        = number
  default     = 20
  nullable    = true

  validation {
    condition     = var.storage_size_gb >= 20 && var.storage_size_gb <= 16384
    error_message = "Possible values are between 20 and 16384"
  }
}

variable "storage_auto_grow_enabled" {
  description = "Should storage auto grow be enabled for this MySQL server?"
  type        = bool
  default     = true
  nullable    = true
}

variable "geo_redundant_backup_enabled" {
  description = "Should geo redundant backup be enabled for this MySQL server?"
  type        = bool
  default     = false
  nullable    = true
}

variable "zone" {
  description = "Specifies the availability zone in which this MySQL server should be located."
  type        = number
  default     = null
  nullable    = true

  validation {
    condition     = contains([1, 2, 3, null], var.zone)
    error_message = "The zone must be 1, 2, or 3."
  }
}

variable "firewall_rules" {
  description = "A list of firewall rules to apply to the MySQL server."

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

  nullable = true
}
