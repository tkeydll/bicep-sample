param location string = resourceGroup().location

param vnetName string = 'vnet'
param defaultSubnetName string = 'DefaultSubnet'
param functionSubnetName string = 'FunctionSubnet'
param assetsStorageAccountName string = 'assets${uniqueString(resourceGroup().id)}'
param functionAppName string = 'functionapp-${uniqueString(resourceGroup().id)}'

module vnetDeploy 'module/virtual-network.bicep' = {
  name: 'vnetDeploy'
  params: {
    location: location
    vnetName: vnetName
    defaultSubnetName: defaultSubnetName
    functionSubnetName: functionSubnetName
  }
}

module functionDeploy 'module/function-premium-vnet-integration.bicep' = {
  name: 'functionDeploy'
  params: {
    location: location
    vnetName: vnetName
    functionSubnetName: functionSubnetName
    appName: functionAppName
  }
}

module storageAccountDeploy 'module/storage-account.bicep' = {
  name: 'storageAccountDeploy'
  params: {
    location: location
    vnetName: vnetName
    storageAccountName: assetsStorageAccountName
  }
}
