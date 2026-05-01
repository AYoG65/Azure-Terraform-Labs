# Azure Lab 1 — VNet, NSG, and Linux VM with Terraform

Provisions a complete baseline Azure environment using Terraform — resource group, virtual network, subnet, network security group, and a hardened Linux VM. The first lab in an Azure Infrastructure as Code series.

---

## What Gets Built

```
Azure Subscription
└── Resource Group (rg-lab1-dev)
    ├── Virtual Network (10.0.0.0/16)
    │   └── Subnet (10.0.1.0/24)
    │       └── NSG — SSH from your IP only, deny all other inbound
    ├── Public IP (Static)
    ├── Network Interface
    └── Linux VM (Ubuntu 22.04, Standard_B1s)
        └── SSH key auth only — no passwords, no root login
```

---

## Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/install) installed
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- An Azure account (free tier works for this lab)
- An SSH key pair on your machine (`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`)

---

## Setup

### 1. Authenticate with Azure

```bash
az login
az account show   # Confirm the right subscription is active
```

### 2. Generate an SSH key (if you don't have one)

```bash
ssh-keygen -t rsa -b 4096 -C "azure-lab1"
# Accept the default path (~/.ssh/id_rsa)
```

### 3. Find your public IP (for NSG SSH rule)

```bash
curl ifconfig.me
```

### 4. Configure your variables

Copy `terraform.tfvars` and fill in your values:

```bash
cp terraform.tfvars terraform.tfvars
```

Update `allowed_ssh_ip` with your IP from step 3 (format: `1.2.3.4/32`).

---

## Deploy

```bash
# Initialize Terraform and download the AzureRM provider
terraform init

# Preview what will be created - read this carefully
terraform plan

# Deploy the infrastructure
terraform apply
```

Type `yes` when prompted. Terraform will print outputs when complete including your VM's public IP and a ready-to-run SSH command.

---

## Connect to the VM

After apply completes, Terraform prints an `ssh_command` output. Run it directly:

```bash
ssh devopsadmin@<your-vm-public-ip>
```

---

## Clean Up

**Important:** Always destroy resources when you're done to avoid Azure charges.

```bash
terraform destroy
```

Type `yes` to confirm. All resources created by this lab will be removed.

---

## Files

| File | Purpose |
|---|---|
| `main.tf` | All Azure resources defined here |
| `variables.tf` | Input variable declarations |
| `outputs.tf` | Values printed after apply (IP, SSH command, etc.) |
| `terraform.tfvars` | Your personal variable values (gitignored) |
| `.gitignore` | Keeps state files and secrets out of Git |

---

## Key Concepts Practiced

- `terraform init` / `plan` / `apply` / `destroy` workflow
- AzureRM provider configuration and authentication
- Resource dependencies (Terraform figures out the correct order automatically)
- Input variables and outputs
- NSG rules — restricting SSH to your IP only
- Tagging strategy for resource tracking
- SSH key authentication on Azure VMs

---

## Next: Lab 2 — Remote State in Azure Blob Storage

Lab 2 moves the Terraform state file off your laptop and into an Azure Storage Account container — the way real teams manage shared infrastructure state.
