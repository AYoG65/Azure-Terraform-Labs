# terraform.tfvars
# Your personal variable values - DO NOT commit this file to GitHub if it contains sensitive data
# The .gitignore in this repo already excludes terraform.tfvars

prefix              = "guerod"
environment         = "dev"
location            = "westus2"
resource_group_name = "rg-lab1-dev"
admin_username      = "devopsadmin"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

# REQUIRED: Set this to your own public IP to restrict SSH access
# Run: curl ifconfig.me  — then paste the result below
allowed_ssh_ip = "YOUR_PUBLIC_IP/32"

tags = {
  project     = "azure-lab1"
  environment = "dev"
  owner       = "guerod"
  managed_by  = "terraform"
}
