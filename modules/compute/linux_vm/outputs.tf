output "network_interface_id" {
  value       = azurerm_network_interface.vm_nic.id
  description = "ID of the network interface attached to the VM."
}

output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "ID of the Linux virtual machine."
}

output "vm_name" {
  value       = azurerm_linux_virtual_machine.vm.name
  description = "Name of the Linux virtual machine."
}
