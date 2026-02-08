# AzureVM (Rocky Linux 9) Terraform テンプレート

## クイックスタート

1. Azure にログインします。
```powershell
az login
```

2. サブスクリプションを指定します（複数ある場合に推奨）。
```powershell
az account set --subscription <YOUR_SUBSCRIPTION_ID>
```

3. 変数ファイルを作成し、最低限 `admin_password` を設定します。
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

4. Terraform を実行します。
```powershell
terraform init
terraform plan
terraform apply
```

## 命名ルール

`prefix` を 1 つ指定すると、全リソース名が以下の形式で作成されます。

- Resource Group: `rg-<prefix>`
- Virtual Network: `vnet-<prefix>`
- Subnet: `subnet-<prefix>`
- Public IP: `public-ip-<prefix>`
- Network Security Group: `nsg-<prefix>`
- NSG Rule: `nsg-rule-<prefix>`
- Network Interface: `nic-<prefix>`
- NIC IP Configuration: `ip-config-<prefix>`
- Virtual Machine: `vm-<prefix>`

例: `prefix = "dev"` の場合、VM 名は `vm-dev` になります。

## 注意事項

- `terraform.tfvars` の `subscription_id` は任意です。省略した場合は Azure CLI の現在のサブスクリプションが使われます。
- `terraform.tfvars` は Git 管理対象外です。
- `prefix` は `a-z` / `0-9` / `-` のみ利用できます。
