# Resource Group Variables
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string  
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string  
}

# Public IP Variables
variable "virtual_machine_public_ip_name" {
  description = "The name of the public IP resource"
  type        = string    
}

variable "public_ip_allocation_method" {
  description = "The name of the public IP resource"
  type        = string    
}

# Network Interface Variables
variable "network_interface_name" {
  description = "The name of the network interface"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to associate with the network interface"
  type        = string
}

variable "private_ip_address_name" {
  description = "The static private IP address for the VM"
  type        = string  
}

variable "private_ip_address" {
  description = "The static private IP address for the VM"
  type        = string  
}

variable "private_ip_address_allocation" {
  description = "The static private IP address for the VM"
  type        = string  
}

# Virtual Machine Variables
variable "virtual_machine_name" {
  description = "The name of the virtual machine"
  type        = string
  default     = "project-az-vm01"
}

variable "virtual_machine_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
}

# OS Disk Variables
variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS disk"
  type        = string
}

variable "os_disk_storage_account_type" {
  description = "The type of storage account to use for the OS disk"
  type        = string
}

# Image Reference Variables
variable "virtual_machine_image_publisher" {
  description = "Publisher of the OS image"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "virtual_machine_image_offer" {
  description = "Offer of the OS image"
  type        = string
  default     = "WindowsServer"
}

variable "virtual_machine_image_sku" {
  description = "SKU of the OS image"
  type        = string
  default     = "2016-Datacenter"
}

variable "virtual_machine_image_version" {
  description = "Version of the OS image"
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type = object({
    environment = string
    project     = string
  })
}