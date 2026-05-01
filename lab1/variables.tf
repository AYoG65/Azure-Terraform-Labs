# variables.tf
# All input variables for Lab 1

variable "prefix" {
  description = "Short prefix used in all resource names (e.g. guerod)"
  type        = string
  default     = "guerod"
}

variable "environment" {
  description = "Environment label used in resource names"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region to deploy resources into"
  type        = string
  default     = "westus2"  # Close to LA - low latency
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-lab1-dev"
}

variable "admin_username" {
  description = "Admin username for the Linux VM"
  type        = string
  default     = "devopsadmin"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file on your local machine"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_ip" {
  description = "Your public IP address allowed to SSH into the VM. Use 'curl ifconfig.me' to find yours."
  type        = string
  # No default - must be set in terraform.tfvars to prevent wide-open SSH
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    project     = "azure-lab1"
    environment = "dev"
    owner       = "guerod"
    managed_by  = "terraform"
  }
}
