terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.80"
    }

    random = {
      source  = "hashicorp/random"
      version = ">=3.5.1"
    }
  }

  required_version = ">=1.5.0"
}