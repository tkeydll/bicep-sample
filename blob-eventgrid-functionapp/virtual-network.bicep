param location string = resourceGroup().location

param vnetName string = 'vnet'
param defaultSubnetName string = 'DefaultSubnet'
param functionSubnetName string = 'FunctionSubnet'

var vnetAddressPrefix = '10.0.0.0/16'
var defaultSubnetAddressPrefix = '10.0.0.0/24'
var functionSubnetAddressPrefix = '10.0.1.0/24'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: defaultSubnetName
        properties: {
          addressPrefix: defaultSubnetAddressPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]        }
      }
      {
        name: functionSubnetName
        properties: {
          addressPrefix: functionSubnetAddressPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}
