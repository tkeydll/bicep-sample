# Azure Functions Event Grid BLOB トリガー

## 手順

### Function App の作成

```bash
az deployment group create -g <resource_group_name> -f function-premium-vnet-integration.bicep
```

### Function App のデプロイ

```bash
dotnet publish [options]
```

### ストレージアカウントの作成

```bash
az deployment group create -g <resource_group_name> -f storage-account.bicep
```


### Event Grid の作成

```bash
az deployment group create -g <resource_group_name> -f eventgrid-blob-function.bicep
```
