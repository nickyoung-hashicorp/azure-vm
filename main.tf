terraform {
  required_version = ">= 0.11.1"
}

variable "location" {
  description = "Azure location in which to create resources"
  default = "West US"
}

variable "windows_dns_prefix" {
  description = "DNS prefix to add to to public IP address for Windows VM"
}

variable "admin_password" {
  description = "admin password for Windows VM"
}

module "windowsserver" {
  source              = "Azure/compute/azurerm"
  version             = "1.1.5"
  location            = "${var.location}"
  resource_group_name = "${var.windows_dns_prefix}-rg"
  vm_hostname         = "{var.windows_dns_prefix}-azure-vm"
  admin_password      = "${var.admin_password}"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["${var.windows_dns_prefix}"]
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
  tags = {
    environment = "demo"
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  version             = "1.1.1"
  location            = "${var.location}"
  resource_group_name = "${var.windows_dns_prefix}-rg"
  allow_ssh_traffic   = true
  tags = {
    environment = "demo"
  }
}

output "windows_vm_public_name"{
  value = "${module.windowsserver.public_ip_dns_name}"
}
