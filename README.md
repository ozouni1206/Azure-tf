# AzureVM(RockyLinux9) Terraform テンプレート

## クイックスタート

1. Azure にログインします。
```powershell
az login
```

2. サブスクリプションを指定します（複数ある場合に推奨）。
```powershell
az account set --subscription <YOUR_SUBSCRIPTION_ID>
```

3. ローカルの変数ファイルを作成し、最低限 `admin_password` を設定します。
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

4. Terraform を実行します。
```powershell
terraform init
terraform plan
terraform apply
```

## 付記

- `terraform.tfvars` の `subscription_id` は任意です。省略した場合は Azure CLI の現在のサブスクリプションが使われます。
- `terraform.tfvars` は Git 管理対象外です。
- VM 名は `prefix` から `vm-<prefix>` 形式で作成されます。
