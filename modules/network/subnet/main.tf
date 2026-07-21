resource "azurerm_subnet" "subnet" {
  for_each             = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = each.value.address_prefixes
  #service_endpoints    = lookup(each.value, "service_endpoints", [])
  #tags                 = lookup(each.value, "tags", {})
}
