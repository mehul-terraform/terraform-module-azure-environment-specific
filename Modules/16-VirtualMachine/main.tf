# Public IP

resource "azurerm_public_ip" "public_ip" {
  name                = var.virtual_machine_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  tags                = local.tags  
}

# Network Interface
resource "azurerm_network_interface" "network_interface" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name  

  ip_configuration {
    name                          = var.private_ip_address_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = azurerm_public_ip.public_ip.id    
  }
  tags = local.tags
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                  = var.virtual_machine_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.virtual_machine_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  patch_mode            = "AutomaticByPlatform"
  
  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.virtual_machine_image_publisher
    offer     = var.virtual_machine_image_offer
    sku       = var.virtual_machine_image_sku
    version   = var.virtual_machine_image_version
  }
  
  tags = local.tags
}
