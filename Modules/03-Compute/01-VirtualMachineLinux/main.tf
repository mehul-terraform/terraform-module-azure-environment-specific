# Random Password for VM Admin
resource "random_password" "admin" {
  for_each = var.virtual_machines

  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  for_each            = var.virtual_machines
  name                = lookup(each.value, "public_ip_name", "${each.value.name}-pip")
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = lookup(each.value, "public_ip_allocation_method", "Static")
  tags                = merge(var.tags, lookup(each.value, "tags", {}))
}

# Network Interface
resource "azurerm_network_interface" "network_interface" {
  for_each            = var.virtual_machines
  name                = lookup(each.value, "network_interface_name", "${each.value.name}-nic")
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = lookup(each.value, "private_ip_name", "${each.value.name}-ip-config")
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = lookup(each.value, "private_ip_allocation", "Dynamic")
    private_ip_address            = lookup(each.value, "private_ip_address", null)
    public_ip_address_id          = azurerm_public_ip.public_ip[each.key].id
  }
  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "virtual_machine" {
  for_each                        = var.virtual_machines
  name                            = each.value.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = lookup(each.value, "size", "Standard_F2")
  admin_username                  = each.value.admin_username
  admin_password                  = random_password.admin[each.key].result
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.network_interface[each.key].id]

  os_disk {
    caching              = lookup(each.value, "os_disk_caching", "ReadWrite")
    storage_account_type = lookup(each.value, "os_disk_storage_account_type", "Standard_LRS")
  }

  source_image_reference {
    publisher = lookup(each.value, "image_publisher", "Canonical")
    offer     = lookup(each.value, "image_offer", "0001-com-ubuntu-server-jammy")
    sku       = lookup(each.value, "image_sku", "22_04-lts")
    version   = lookup(each.value, "image_version", "latest")
  }

  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

# Store Admin Password in Key Vault
resource "azurerm_key_vault_secret" "vm_admin" {
  for_each = var.virtual_machines

  name         = "${each.value.name}-vmpassword"
  value        = random_password.admin[each.key].result
  key_vault_id = var.key_vault_id
}
