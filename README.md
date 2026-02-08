# Azure VM (Rocky Linux 9) Terraform Template

`prefix` と `vm_count` から VM 名を自動採番します。
例: `prefix = "web"` かつ `vm_count = 3` のとき、VM 名は `web-1`, `web-2`, `web-3` になります。

また、`deployment_mode` で次の 2 パターンを選べます。
- `shared_rg`: 1 つの Resource Group / VNet / Subnet / NSG を共有して複数 VM を作成
- `per_vm_rg`: VM ごとに Resource Group / VNet / Subnet / NSG を分離して作成

## 前提

- Terraform 1.x
- Azure CLI (`az`)
- 対象サブスクリプションで VM 作成権限があること

## クイックスタート

1. Azure にログイン
```powershell
az login
```

2. サブスクリプションを設定
```powershell
az account set --subscription <YOUR_SUBSCRIPTION_ID>
```

3. 変数ファイルを作成して編集
```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
```

4. 作成
```powershell
terraform init
terraform plan
terraform apply
```

5. 削除
```powershell
terraform destroy
```

## 重要な変数

- `subscription_id`: Azure サブスクリプション ID（この構成では必須）
- `location`: デプロイ先リージョン（例: `japaneast`）
- `prefix`: リソース名の接頭辞。VM 名は `<prefix>-<連番>` になる
- `vm_count`: VM 台数（正の整数）
- `deployment_mode`: `shared_rg` または `per_vm_rg`

## 命名ルール

`prefix = "web"` と `vm_count = 2` の場合:
- VM: `web-1`, `web-2`
- Public IP: `public-ip-web-1`, `public-ip-web-2`
- NIC: `nic-web-1`, `nic-web-2`
- NIC IP Configuration: `ip-config-web-1`, `ip-config-web-2`

`deployment_mode = "shared_rg"` の場合:
- `rg-web`, `vnet-web`, `subnet-web`, `nsg-web`, `nsg-rule-web`

`deployment_mode = "per_vm_rg"` の場合:
- `rg-web-1`, `vnet-web-1`, `subnet-web-1`, `nsg-web-1`, `nsg-rule-web-1`
- `rg-web-2`, `vnet-web-2`, `subnet-web-2`, `nsg-web-2`, `nsg-rule-web-2`

## `terraform.tfvars` 設定例

同一 RG にまとめる場合:
```hcl
location        = "japaneast"
prefix          = "web"
vm_count        = 3
deployment_mode = "shared_rg"
```

VM ごとに RG を分ける場合:
```hcl
location        = "japaneast"
prefix          = "web"
vm_count        = 3
deployment_mode = "per_vm_rg"
```

## 運用の目安

- `shared_rg`: 同一システムとしてまとめて管理したい場合に向く
- `per_vm_rg`: VM ごとに権限、ライフサイクル、削除単位を分けたい場合に向く

## 注意点

- `prefix` は `a-z`, `0-9`, `-` のみ使用可能
- `vm_count` は 1 以上の整数のみ使用可能
- `admin_password` を `terraform.tfvars` に置く場合は Git 管理しないこと
