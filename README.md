# Azure Infrastructure Setup with Terraform

This repository contains Terraform scripts to provision infrastructure on Microsoft Azure, including a **Resource Group**, **Virtual Network**, **Subnet**, **Public IP**, **Network Interface**, **Network Security Group**, **Virtual Machine**, and **SSH Key Vault**. The main goal is to automate the provisioning of a Linux Virtual Machine (VM) with secure SSH access using public and private keys stored in Azure Key Vault.

## Directory Structure

terraform-azure-infrastructure/
├── terraform.tf # Main infrastructure definition file
├── variables.tf # Variable definitions
├── outputs.tf # Output variables
├── provider.tf # Provider configurations
├── data.tf # Data source configuration
├── versions.tf # Provider versions

#1. **`terraform.tf`**
Contains the primary infrastructure configuration, defining the resources that need to be provisioned such as:
- **Resource Group** (`azurerm_resource_group`)
- **Virtual Network** (`azurerm_virtual_network`)
- **Subnet** (`azurerm_subnet`)
- **Network Security Group** (`azurerm_network_security_group`)
- **Network Security Rules** (`azurerm_network_security_rule`)
- **Public IP Address** (`azurerm_public_ip`)
- **Network Interface** (`azurerm_network_interface`)
- **Linux Virtual Machine** (`azurerm_linux_virtual_machine`

#2. **`variables.tf`**
Defines all the variables used throughout the Terraform configuration.

#3. **`outputs.tf`**
Contains all the output values, including sensitive values that are useful for subsequent integrations and for retrieving resource details after the deployment.

#4. **`provider.tf`**
Defines the Terraform provider configurations, specifying the version of the Azure RM provider and any additional features such as Key Vault settings.

#5. **`data.tf`**
This file defines data sources in Terraform, used to query existing resources or information outside of the current configuration. It allows you to reference external resources without managing them directly in your configuration.

#5. **`versions.tf`**
This file specifies the required Terraform version and provider versions for your project. It ensures that Terraform and the providers are compatible with your configuration.

## 🛠️ Terraform Usage Instructions

### 📋 Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- [Azure account](https://azure.microsoft.com/) set up with proper permissions
- Azure CLI installed and logged in (recommended)

### 🚀 Deployment

#1. **⚙️ Initialize Terraform**
on your bash terminal:
- terraform init -- Initializes providers and modules

#2. **📝 Plan the Deployment**
- terraform plan -- Preview changes before applying

#3. **🛠️ Apply the Deployment**
- terraform apply -- Creates the actual infrastructure (In this case, Azure Portal)

🧹 Clean Up
#4. **💥 Destroy Infrastructure**
- terraform destroy -- Removes all created resources

🔒 Security Notes
📝 ❗ Important Implementation Details

SSH Key Storage: SSH keys are securely stored in Azure Key Vault to prevent accidental exposure
Public IP: A static public IP is assigned to the VM for remote SSH access
Network Security: NSG rules restrict access to only port 22 for SSH
Sensitive Data: Data sources are used to fetch credentials/secrets instead of hardcoding them

ℹ️ General Notes
Run all commands from the directory containing your Terraform files (main.tf or terraform.tf - for me)
Review the plan carefully before applying...

🙋‍♂️ Author Chinwe Ebube Onaifoh 📫 onaifohchinwe094@gmail.com 📞 +1 (437) 473-4649 📍 Ajax, Ontario, Canada
