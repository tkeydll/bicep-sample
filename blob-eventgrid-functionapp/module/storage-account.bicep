param location string
param vnetName string

param storageAccountName string = 'assets${uniqueString(resourceGroup().id)}'

// Existing VNET
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
  name: vnetName
}

// Storage Account
resource sa 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: any(virtualNetwork.properties.subnets)
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
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
