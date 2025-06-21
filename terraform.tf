# resource "local_file" "firstfile" {
#   content  = "Learning terraform is fun!"
#   filename = "firstfile.txt"
# }


# resource "random_string" "firststring" {
#   length  = 10
#   special = false
#   upper   = false
#   lower   = true
#   numeric = true

# }

# resource "random_pet" "practicevariables" {
#   length    = 8
#   prefix    = var.prefix_tuple[2]
#   separator = "-"

# }

# provision a vm with terraform code in azure portal

# provision a vnet in the resource group

resource "azurerm_resource_group" "mainrg" {
  name     = "mainrg"
  location = "canada central"

}

# provision a vnet in the resource group
resource "azurerm_virtual_network" "mainvnet" {
  name                = "mainvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mainrg.location
  resource_group_name = azurerm_resource_group.mainrg.name
}

# provision a subnet in the vnet
resource "azurerm_subnet" "mainsn" {
  name                 = "mainsn"
  resource_group_name  = azurerm_resource_group.mainrg.name
  virtual_network_name = azurerm_virtual_network.mainvnet.name
  address_prefixes     = ["10.0.2.0/24"]

}

# provision a network interface in the subnet
resource "azurerm_network_interface" "mainnic" {
  name                = "mainnic"
  location            = azurerm_resource_group.mainrg.location
  resource_group_name = azurerm_resource_group.mainrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mainsn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mainpip.id
  }
}

# provision a public ip address which is associated with the network interface
resource "azurerm_public_ip" "mainpip" {
  name                = "mainpip"
  resource_group_name = azurerm_resource_group.mainrg.name
  location            = azurerm_resource_group.mainrg.location
  allocation_method   = "Static"

}

# provision network security group in the resource group
resource "azurerm_network_security_group" "mainnsg" {
  name                = "mainnsg"
  location            = azurerm_resource_group.mainrg.location
  resource_group_name = azurerm_resource_group.mainrg.name
}
#provision network security group rule 
resource "azurerm_network_security_rule" "nsgrule" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.mainrg.name
  network_security_group_name = azurerm_network_security_group.mainnsg.name
}

# Attach the network security group to the subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association_subnet" {
  subnet_id                 = azurerm_subnet.mainsn.id
  network_security_group_id = azurerm_network_security_group.mainnsg.id
}

# create public key and private key using tls provider
resource "tls_private_key" "mainsshkeys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Path to ssh key private key
resource "local_file" "private_key" {
  content  = trimspace(tls_private_key.mainsshkeys.private_key_pem)
  filename = "${path.module}/private_key.pem"
}

# Path to ssh key public key
# resource "local_file" "public_key" {
#   content  = trimspace(tls_private_key.mainsshkeys.public_key_openssh)
#   filename = "${path.module}/public_key.pub"
# }

# provision a key vault to store the ssh keys
resource "azurerm_key_vault" "mainchinwekv" {
  name                        = "mainchinwekv"
  location                    = azurerm_resource_group.mainrg.location
  resource_group_name         = azurerm_resource_group.mainrg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_user.user.object_id


    secret_permissions = [
      "Get", "Set", "Delete", "List", "Purge", "Recover", "Backup", "Restore"
    ]

  }
}

# Create and Store the public key in the key vault
resource "azurerm_key_vault_secret" "mainpubk" {
  name         = "mainpubk"
  value        = trimspace(tls_private_key.mainsshkeys.public_key_openssh)
  key_vault_id = azurerm_key_vault.mainchinwekv.id
}

# Create and Store the private key in the key vault
resource "azurerm_key_vault_secret" "mainprivk" {
  name         = "mainprivk"
  value        = trimspace(tls_private_key.mainsshkeys.private_key_pem)
  key_vault_id = azurerm_key_vault.mainchinwekv.id
}


resource "azurerm_linux_virtual_machine" "mainvm" {
  name                = "mainvm"
  resource_group_name = azurerm_resource_group.mainrg.name
  location            = azurerm_resource_group.mainrg.location
  computer_name       = "mainvm"
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.mainnic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = data.azurerm_key_vault_secret.mainpubk.value # Use the public key from the key vault fetched using data source
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}