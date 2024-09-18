variable "server_name" {
  description = "The name of this MySQL server."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resouces in."
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

variable "administrator_password" {
  description = "The login password of the administrator for this MySQL server."
  type        = string
}
variable "databases" {
  description = ""
  type = list(object({
    name      = string
    collation = string
    charset   = string
  }))
}

variable "server_version" {
  description = "The version of this MySQL server"
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

variable "size_gb" {
  description = "Sets size for this MySQL database."
  type        = number
  default     = 20
}

variable "auto_grow_enabled" {
  description = ""
  type        = bool
  default     = false
}

variable "geo_redundant_backup_enabled" {
  description = ""
  type        = bool
  default     = false
}

variable "zone" {
  description = ""
  type        = number
  default     = 1
}

variable "firewall_rules" {
  description = ""
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}

variable "server_configurations" {
  description = ""
  type = list(object({
    name  = string
    value = string
  }))
}
