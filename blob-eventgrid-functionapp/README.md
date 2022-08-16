# Azure Functions Event Grid BLOB トリガー

## 手順

### ストレージアカウントの作成

```bash
az deployment group create -g <resource_group_name> -f storage-account.bicep
```

### Function App の作成

```bash
az deployment group create -g <resource_group_name> -f function-premium-vnet-integration.bicep
```

### Function App のデプロイ


### Event Grid の作成

```bash
az deployment group create -g <resource_group_name> -f eventgrid-blob-function.bicep
```
