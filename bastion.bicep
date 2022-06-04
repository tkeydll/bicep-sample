param location string = resourceGroup().location

param bastionName string = 'bastion'
param bastionPublicIpName string = 'bastion-public-ip'
param vnetName string = 'my-vnet'


// Bastion subnet
resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  name: '${vnetName}/AzureBastionSubnet'
  properties: {
    addressPrefix: '192.168.0.0/27'
  }
}

// Bastion IP address
resource bastionPublicIp 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: bastionPublicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}


// Bastion
resource bastion 'Microsoft.Network/bastionHosts@2021-08-01' = {
  name: bastionName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    disableCopyPaste: false
    enableFileCopy: true
    enableIpConnect: false
    enableShareableLink: true
    enableTunneling: true
    ipConfigurations: [
      {
        id: 'ipconf'
        name: 'ipconf'
        properties:  {
          publicIPAddress: {
            id: bastionPublicIp.id
          }
          subnet: {
            id: bastionSubnet.id
          }
        }
      }
    ]
  }
}

output bastionId string = bastion.id
