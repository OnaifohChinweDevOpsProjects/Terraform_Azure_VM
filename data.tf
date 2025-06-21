data "azurerm_client_config" "current" {}

# data "azuread_client_config" "current" {}

# use data to get the user object id from the user principal name
data "azuread_user" "user" {
  user_principal_name = var.user_principal_name #"ebube094_outlook.com#EXT#@ebube094outlook.onmicrosoft.com"
}

# use the data to get the key vault
data "azurerm_key_vault" "mainchinwekv" {
  name                = azurerm_key_vault.mainchinwekv.name
  resource_group_name = azurerm_resource_group.mainrg.name
}

# use data to feth the private key from the key vault
data "azurerm_key_vault_secret" "mainpubk" {
  name         = azurerm_key_vault_secret.mainpubk.name
  key_vault_id = data.azurerm_key_vault.mainchinwekv.id
}