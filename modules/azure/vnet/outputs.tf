output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.app.name
}

output "subnet_appgw_id" {
  description = "The ID of the AppGW subnet"
  value       = azurerm_subnet.appgw.id
}
