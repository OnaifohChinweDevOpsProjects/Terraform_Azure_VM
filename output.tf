output "my_subscription_id" {
  value     = data.azurerm_client_config.current.subscription_id
  sensitive = true
}

output "my_tenant_id" {
  value     = data.azurerm_client_config.current.tenant_id
  sensitive = true

}

output "my_object_id" {
  value     = data.azuread_user.user.object_id
  sensitive = true

}

# use output to get the public key from the nic attach it to the VM
output "my_vm_public_ip" {
  value       = azurerm_public_ip.mainpip.ip_address
  description = "Public IP of the VM"
}