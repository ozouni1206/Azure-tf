variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "subnet_name" {
  type = string
}

variable "subnet_address_prefixes" {
  type = list(string)
}

variable "public_ip_name" {
  type = string
}

variable "public_ip_allocation_method" {
  type = string
}

variable "public_ip_sku" {
  type = string
}

variable "nsg_name" {
  type = string
}

variable "nsg_rule_name" {
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

variable "nic_name" {
  type = string
}

variable "nic_ip_configuration_name" {
  type = string
}

variable "nic_private_ip_allocation" {
  type = string
}

variable "prefix" {
  type = string
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
