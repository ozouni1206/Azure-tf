# Azure VM (Rocky Linux 9) Terraform Template

`deployment_mode` を切り替えることで、次の 2 パターンで複数 VM を作成できます。

- `shared_rg`: 1 つの Resource Group / VNet / Subnet / NSG を共有して、VM だけ複数作成
- `per_vm_rg`: VM ごとに Resource Group / VNet / Subnet / NSG を個別作成

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

- `subscription_id`: Azure サブスクリプション ID（現状の実装では必須）
- `location`: リージョン（例: `japaneast`）
- `prefix`: リソース名の共通接頭辞
- `deployment_mode`: `shared_rg` または `per_vm_rg`
- `vm_names`: VM 識別子のリスト（例: `["app-1", "app-2"]`）

## モード別の挙動

### `shared_rg`

- 共有: `rg`, `vnet`, `subnet`, `nsg`, `nsg-rule`
- VM ごとに作成: `public-ip`, `nic`, `vm`

命名例（`prefix = "dev"`, `vm_names = ["app-1", "app-2"]`）

- `rg-dev`
- `vnet-dev`
- `subnet-dev`
- `nsg-dev`
- `nsg-rule-dev`
- `public-ip-dev-app-1`, `public-ip-dev-app-2`
- `nic-dev-app-1`, `nic-dev-app-2`
- `vm-dev-app-1`, `vm-dev-app-2`

### `per_vm_rg`

- VM ごとに `rg`, `vnet`, `subnet`, `nsg`, `nsg-rule`, `public-ip`, `nic`, `vm` を作成

命名例（`prefix = "dev"`, `vm_names = ["app-1", "app-2"]`）

- `rg-dev-app-1`, `vnet-dev-app-1`, `subnet-dev-app-1`, `vm-dev-app-1`
- `rg-dev-app-2`, `vnet-dev-app-2`, `subnet-dev-app-2`, `vm-dev-app-2`

## `terraform.tfvars` 設定例

### 1. 同一 RG にまとめる場合

```hcl
location        = "japaneast"
prefix          = "dev"
deployment_mode = "shared_rg"
vm_names        = ["app-1", "app-2", "app-3"]
```

### 2. VM ごとに RG を分ける場合

```hcl
location        = "japaneast"
prefix          = "dev"
deployment_mode = "per_vm_rg"
vm_names        = ["app-1", "batch-1", "jump-1"]
```

## 運用の目安

- `shared_rg`: 同じシステムとして一括運用し、ネットワークを共通化したい場合に向く
- `per_vm_rg`: VM 単位でライフサイクルや権限を分離し、用途ごとに境界を分けたい場合に向く

## バリデーションと注意点

- `prefix` と `vm_names` は `a-z`, `0-9`, `-` のみ使用可能
- `vm_names` は重複不可
- `admin_password` を `terraform.tfvars` に書く場合は、Git 管理しないこと
