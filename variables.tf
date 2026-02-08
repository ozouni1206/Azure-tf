variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_address_prefixes" {
  type = list(string)
}

variable "public_ip_allocation_method" {
  type = string
}

variable "public_ip_sku" {
  type = string
}

variable "nsg_rule_priority" {
  type = number
}

variable "nsg_rule_direction" {
  type = string
}

variable "nsg_rule_access" {
  type = string
}

variable "nsg_rule_protocol" {
  type = string
}

variable "nsg_rule_source_port_range" {
  type = string
}

variable "nsg_rule_destination_port_range" {
  type = string
}

variable "nsg_rule_source_address_prefix" {
  type = string
}

variable "nsg_rule_destination_address_prefix" {
  type = string
}

variable "nic_private_ip_allocation" {
  type = string
}

variable "prefix" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix))
    error_message = "prefix must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "deployment_mode" {
  type = string

  validation {
    condition     = contains(["shared_rg", "per_vm_rg"], var.deployment_mode)
    error_message = "deployment_mode must be either shared_rg or per_vm_rg."
  }
}

variable "vm_count" {
  type = number

  validation {
    condition = (
      var.vm_count > 0 &&
      floor(var.vm_count) == var.vm_count
    )
    error_message = "vm_count must be a positive integer."
  }
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "disable_password_authentication" {
  type = bool
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "os_disk_caching" {
  type = string
}

variable "os_disk_storage_account_type" {
  type = string
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "image_version" {
  type = string
}

variable "plan_publisher" {
  type = string
}

variable "plan_product" {
  type = string
}

variable "plan_name" {
  type = string
}
