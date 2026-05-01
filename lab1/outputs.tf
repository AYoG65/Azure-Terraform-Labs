# outputs.tf
# Values displayed after terraform apply completes

output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.lab1.name
}

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = azurerm_linux_virtual_machine.lab1.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM - use this to SSH in"
  value       = azurerm_public_ip.lab1.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the VM within the VNet"
  value       = azurerm_network_interface.lab1.private_ip_address
}

output "ssh_command" {
  description = "Ready-to-run SSH command to connect to your VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.lab1.ip_address}"
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.lab1.name
}

output "vnet_address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.lab1.address_space
}
