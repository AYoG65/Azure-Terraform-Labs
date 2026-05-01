# main.tf
# Lab 1 - Azure Resource Group, VNet, Subnet, NSG, and Linux VM

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Lab 2 - uncomment this block once you've completed the storage account setup
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "stterraformstate<yourname>"
  #   container_name       = "tfstate"
  #   key                  = "lab1.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

# -------------------------------------------------------
# Resource Group
# -------------------------------------------------------
resource "azurerm_resource_group" "lab1" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# -------------------------------------------------------
# Virtual Network
# -------------------------------------------------------
resource "azurerm_virtual_network" "lab1" {
  name                = "vnet-${var.prefix}-${var.environment}"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
  address_space       = ["10.0.0.0/16"]

  tags = var.tags
}

# -------------------------------------------------------
# Subnet
# -------------------------------------------------------
resource "azurerm_subnet" "lab1" {
  name                 = "snet-${var.prefix}-${var.environment}"
  resource_group_name  = azurerm_resource_group.lab1.name
  virtual_network_name = azurerm_virtual_network.lab1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# -------------------------------------------------------
# Network Security Group
# -------------------------------------------------------
resource "azurerm_network_security_group" "lab1" {
  name                = "nsg-${var.prefix}-${var.environment}"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name

  # Allow SSH only - no wide-open rules
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_ip
    destination_address_prefix = "*"
  }

  # Deny all other inbound traffic explicitly
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "lab1" {
  subnet_id                 = azurerm_subnet.lab1.id
  network_security_group_id = azurerm_network_security_group.lab1.id
}

# -------------------------------------------------------
# Public IP (for SSH access to the VM)
# -------------------------------------------------------
resource "azurerm_public_ip" "lab1" {
  name                = "pip-${var.prefix}-${var.environment}"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

# -------------------------------------------------------
# Network Interface
# -------------------------------------------------------
resource "azurerm_network_interface" "lab1" {
  name                = "nic-${var.prefix}-${var.environment}"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lab1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lab1.id
  }

  tags = var.tags
}

# -------------------------------------------------------
# Linux Virtual Machine (B1s - Free tier eligible)
# -------------------------------------------------------
resource "azurerm_linux_virtual_machine" "lab1" {
  name                = "vm-${var.prefix}-${var.environment}"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
  size                = "Standard_B1s"  # Free tier eligible
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.lab1.id
  ]

  # SSH key authentication only - no passwords
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Disable password authentication - SSH key only
  disable_password_authentication = true

  tags = var.tags
}
