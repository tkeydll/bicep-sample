param location string = resourceGroup().location

resource devcenter 'Microsoft.DevCenter/devcenters@2023-10-01-preview' = {
  name: 'myDevCenter'
  location: location
  properties: {
    displayName: 'My Dev Center'
  }
}

resource devproject 'Microsoft.DevCenter/projects@2023-10-01-preview' = {
  name: 'myDevProject'
  location: location
  properties: {
    displayName: 'My Dev Project'
    devCenterId: devcenter.id
    maxDevBoxesPerUser: 1
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'devboxVnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  parent: vnet
  name: 'devBoxSubnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

resource networkConnection 'Microsoft.DevCenter/networkConnections@2023-10-01-preview' = {
  name: 'myNetworkConnection'
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: subnet.id
  }
}

resource attachedNetwork 'Microsoft.DevCenter/devcenters/attachednetworks@2023-10-01-preview' = {
  parent: devcenter
  name: 'myAttachedNetwork'
  properties: {
    networkConnectionId: networkConnection.id
  }
}


// resource devboxpool 'Microsoft.DevCenter/projects/pools@2023-10-01-preview' = {
//   parent: devproject
//   name: 'myDevBoxPool'
//   location: location
//   properties: {
//     displayName: 'My Dev Box Pool'
//     devBoxDefinitionName: 'myDevBoxDefinition'
//     virtualNetworkType: 'Unmanaged'
//     localAdministrator: 'Disabled'
//     licenseType: 'Windows_Client'
//     networkConnectionName: networkConnection.name 
//   }
// }
