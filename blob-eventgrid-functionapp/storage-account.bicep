param location string = resourceGroup().location
param storageAccountName string = 'assets${uniqueString(resourceGroup().id)}'

// Storage Account
resource sa 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

// Blob containers
param containerName string = 'container'
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' =  {
  name: '${sa.name}/default/${containerName}'
}

// File share
param shareName string = 'contents'
resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-09-01' = {
  name: '${sa.name}/default/${shareName}'
}
