# AzureVM(RockyLinux9) Terraform template

## Quick Start

1. Login to Azure.
```powershell
az login
```

2. Set subscription (recommended when you have multiple subscriptions).
```powershell
az account set --subscription <YOUR_SUBSCRIPTION_ID>
```

3. Create local vars file and set at least `admin_password`.
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

4. Run Terraform.
```powershell
terraform init
terraform plan
terraform apply
```

## Notes

- `subscription_id` in `terraform.tfvars` is optional. If omitted, Azure CLI current subscription is used.
- `terraform.tfvars` is ignored by Git.
