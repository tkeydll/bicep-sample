param location string
param vnetName string
param storageAccountName string

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
    // networkAcls: {
    //   bypass: 'AzureServices'
    //   virtualNetworkRules: any(virtualNetwork.properties.subnets)
    //   ipRules: []
    //   defaultAction: 'Deny'
    // }
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

// Create file share directory.
// ${shareName}/foo/bar
param dir1 string = 'foo'
param dir2 string = 'bar'
var accountKey = listKeys(sa.id, sa.apiVersion).keys[0].value
resource script 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'CreateFileShareDir'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.29.0'
    retentionInterval: 'P1D'
    arguments: '${dir1} ${dir2}'
    environmentVariables: [
      {
        name: 'accountName'
        value: sa.name
      }
      {
        name: 'shareName'
        value: shareName
      }
      {
        name: 'accountKey'
        value: accountKey
      }
    ]
    scriptContent: '''
      az storage directory create --name $1 --account-name $accountName --share-name $shareName --account-key $accountKey
      az storage directory create --name $1/$2 --account-name $accountName --share-name $shareName --account-key $accountKey
    '''
  }
}
