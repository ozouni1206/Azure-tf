locals {
  vm_instances = {
    for idx in range(var.vm_count) :
    tostring(idx + 1) => format("%s-%d", var.prefix, idx + 1)
  }

  shared = {
    rg_name       = "rg-${var.prefix}"
    vnet_name     = "vnet-${var.prefix}"
    subnet_name   = "subnet-${var.prefix}"
    nsg_name      = "nsg-${var.prefix}"
    nsg_rule_name = "nsg-rule-${var.prefix}"
  }
}

resource "azurerm_resource_group" "rg_shared" {
  count    = var.deployment_mode == "shared_rg" ? 1 : 0
  name     = local.shared.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet_shared" {
  count               = var.deployment_mode == "shared_rg" ? 1 : 0
  name                = local.shared.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_shared[0].name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet_shared" {
  count                = var.deployment_mode == "shared_rg" ? 1 : 0
  name                 = local.shared.subnet_name
  resource_group_name  = azurerm_resource_group.rg_shared[0].name
  virtual_network_name = azurerm_virtual_network.vnet_shared[0].name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "nsg_shared" {
  count               = var.deployment_mode == "shared_rg" ? 1 : 0
  name                = local.shared.nsg_name
  location            = azurerm_resource_group.rg_shared[0].location
  resource_group_name = azurerm_resource_group.rg_shared[0].name
}

resource "azurerm_network_security_rule" "nsg_rule_shared" {
  count                       = var.deployment_mode == "shared_rg" ? 1 : 0
  name                        = local.shared.nsg_rule_name
  resource_group_name         = azurerm_resource_group.rg_shared[0].name
  network_security_group_name = azurerm_network_security_group.nsg_shared[0].name
  priority                    = var.nsg_rule_priority
  direction                   = var.nsg_rule_direction
  access                      = var.nsg_rule_access
  protocol                    = var.nsg_rule_protocol
  source_port_range           = var.nsg_rule_source_port_range
  destination_port_range      = var.nsg_rule_destination_port_range
  source_address_prefix       = var.nsg_rule_source_address_prefix
  destination_address_prefix  = var.nsg_rule_destination_address_prefix
}

resource "azurerm_public_ip" "public_ip_shared" {
  for_each            = var.deployment_mode == "shared_rg" ? local.vm_instances : {}
  name                = "public-ip-${each.value}"
  location            = azurerm_resource_group.rg_shared[0].location
  resource_group_name = azurerm_resource_group.rg_shared[0].name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

resource "azurerm_network_interface" "nic_shared" {
  for_each            = var.deployment_mode == "shared_rg" ? local.vm_instances : {}
  name                = "nic-${each.value}"
  location            = azurerm_resource_group.rg_shared[0].location
  resource_group_name = azurerm_resource_group.rg_shared[0].name

  ip_configuration {
    name                          = "ip-config-${each.value}"
    subnet_id                     = azurerm_subnet.subnet_shared[0].id
    private_ip_address_allocation = var.nic_private_ip_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip_shared[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc_shared" {
  for_each                  = var.deployment_mode == "shared_rg" ? local.vm_instances : {}
  network_interface_id      = azurerm_network_interface.nic_shared[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg_shared[0].id
}

resource "azurerm_linux_virtual_machine" "vm_shared" {
  for_each                        = var.deployment_mode == "shared_rg" ? local.vm_instances : {}
  name                            = each.value
  resource_group_name             = azurerm_resource_group.rg_shared[0].name
  location                        = azurerm_resource_group.rg_shared[0].location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = var.disable_password_authentication
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.nic_shared[each.key].id]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  plan {
    publisher = var.plan_publisher
    product   = var.plan_product
    name      = var.plan_name
  }
}

resource "azurerm_resource_group" "rg_per_vm" {
  for_each = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name     = "rg-${each.value}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet_per_vm" {
  for_each            = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name                = "vnet-${each.value}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_per_vm[each.key].name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet_per_vm" {
  for_each             = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name                 = "subnet-${each.value}"
  resource_group_name  = azurerm_resource_group.rg_per_vm[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet_per_vm[each.key].name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "nsg_per_vm" {
  for_each            = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name                = "nsg-${each.value}"
  location            = azurerm_resource_group.rg_per_vm[each.key].location
  resource_group_name = azurerm_resource_group.rg_per_vm[each.key].name
}

resource "azurerm_network_security_rule" "nsg_rule_per_vm" {
  for_each                    = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name                        = "nsg-rule-${each.value}"
  resource_group_name         = azurerm_resource_group.rg_per_vm[each.key].name
  network_security_group_name = azurerm_network_security_group.nsg_per_vm[each.key].name
  priority                    = var.nsg_rule_priority
  direction                   = var.nsg_rule_direction
  access                      = var.nsg_rule_access
  protocol                    = var.nsg_rule_protocol
  source_port_range           = var.nsg_rule_source_port_range
  destination_port_range      = var.nsg_rule_destination_port_range
  source_address_prefix       = var.nsg_rule_source_address_prefix
  destination_address_prefix  = var.nsg_rule_destination_address_prefix
}

resource "azurerm_public_ip" "public_ip_per_vm" {
  for_each            = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name                = "public-ip-${each.value}"
  location            = azurerm_resource_group.rg_per_vm[each.key].location
  resource_group_name = azurerm_resource_group.rg_per_vm[each.key].name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

resource "azurerm_network_interface" "nic_per_vm" {
  for_each            = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name                = "nic-${each.value}"
  location            = azurerm_resource_group.rg_per_vm[each.key].location
  resource_group_name = azurerm_resource_group.rg_per_vm[each.key].name

  ip_configuration {
    name                          = "ip-config-${each.value}"
    subnet_id                     = azurerm_subnet.subnet_per_vm[each.key].id
    private_ip_address_allocation = var.nic_private_ip_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip_per_vm[each.key].id
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc_per_vm" {
  for_each                  = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  network_interface_id      = azurerm_network_interface.nic_per_vm[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg_per_vm[each.key].id
}

resource "azurerm_linux_virtual_machine" "vm_per_vm" {
  for_each                        = var.deployment_mode == "per_vm_rg" ? local.vm_instances : {}
  name                            = each.value
  resource_group_name             = azurerm_resource_group.rg_per_vm[each.key].name
  location                        = azurerm_resource_group.rg_per_vm[each.key].location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = var.disable_password_authentication
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.nic_per_vm[each.key].id]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  plan {
    publisher = var.plan_publisher
    product   = var.plan_product
    name      = var.plan_name
  }
}
