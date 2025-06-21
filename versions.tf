terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = " ~> 3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.38.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
}


