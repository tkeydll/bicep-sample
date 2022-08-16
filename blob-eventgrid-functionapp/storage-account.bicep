param location string = resourceGroup().location
param storageAccountName string = 'assets${uniqueString(resourceGroup().id)}'
param vnetName string = 'vnet'
param defaultSubnetName string = 'DefaultSubnet'
param functionSubnetName string = 'FunctionSubnet'

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
      // virtualNetworkRules: [
      //   {
      //     id: '${virtualNetwork.id}/subnets/${defaultSubnetName}'
      //     action: 'Allow'
      //     state: 'Succeeded'
      //   }
      //   {
      //     id: '${virtualNetwork.id}/subnets/${functionSubnetName}'
      //     action: 'Allow'
      //     state: 'Succeeded'
      //   }
      // ]
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
