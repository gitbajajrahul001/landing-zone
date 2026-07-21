output "subnet_ids" {
  value       = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
  description = "Map of subnet names to subnet IDs."
}
