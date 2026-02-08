resource "azurerm_resource_group" "rg_terraform" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet_terraform" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_terraform.name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "subnet_terraform" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg_terraform.name
  virtual_network_name = azurerm_virtual_network.vnet_terraform.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "public_ip_terraform" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg_terraform.location
  resource_group_name = azurerm_resource_group.rg_terraform.name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
}

resource "azurerm_network_security_group" "nsg_terraform" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg_terraform.location
  resource_group_name = azurerm_resource_group.rg_terraform.name
}

resource "azurerm_network_security_rule" "nsg_rule_terraform" {
  name                        = var.nsg_rule_name
  resource_group_name         = azurerm_resource_group.rg_terraform.name
  network_security_group_name = azurerm_network_security_group.nsg_terraform.name
  priority                    = var.nsg_rule_priority
  direction                   = var.nsg_rule_direction
  access                      = var.nsg_rule_access
  protocol                    = var.nsg_rule_protocol
  source_port_range           = var.nsg_rule_source_port_range
  destination_port_range      = var.nsg_rule_destination_port_range
  source_address_prefix       = var.nsg_rule_source_address_prefix
  destination_address_prefix  = var.nsg_rule_destination_address_prefix
}

resource "azurerm_network_interface" "nic_terraform" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg_terraform.location
  resource_group_name = azurerm_resource_group.rg_terraform.name

  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet_terraform.id
    private_ip_address_allocation = var.nic_private_ip_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip_terraform.id
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic_terraform.id
  network_security_group_id = azurerm_network_security_group.nsg_terraform.id
}

resource "azurerm_linux_virtual_machine" "vm_terraform" {
  name                            = "vm-${var.prefix}"
  resource_group_name             = azurerm_resource_group.rg_terraform.name
  location                        = azurerm_resource_group.rg_terraform.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = var.disable_password_authentication
  admin_password                  = var.admin_password
  network_interface_ids           = [azurerm_network_interface.nic_terraform.id]

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
