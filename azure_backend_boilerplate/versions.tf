terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.80"
    }

    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.10.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">=3.5.1"
    }
  }

  required_version = ">=1.5.0"
}