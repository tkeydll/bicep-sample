param location string = resourceGroup().location
param webAppName string = 'webapp-${uniqueString(resourceGroup().id)}'

// Get existing vnet and subnet.
param vnetName string = 'webappvnet'
param subnetName string = 'AppServiceSubNet'
resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' existing = {
  name: vnetName
}
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing = {
  parent: vnet
  name: subnetName
}

output hoge string = subnet.id

resource webapp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    siteConfig: {
      netFrameworkVersion: 'v4.0'
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
      http20Enabled: true
      ftpsState: 'Disabled'
      // use32BitWorkerProcess: false
      virtualApplications: [
        {
          physicalPath: 'site\\wwwroot'
          preloadEnabled: false
          virtualPath: '/'
          virtualDirectories: [
            {
              physicalPath: 'site\\wwwroot\\foo'
              virtualPath: '/foo'
            }
            {
              physicalPath: 'site\\wwwroot\\foo\\bar'
              virtualPath: '/foo/bar'
            }
          ]
        }
        {
          physicalPath: 'site\\wwwroot\\hoge'
          preloadEnabled: true
          virtualPath: '/hoge'
        }
      ]
    }
    httpsOnly: true
    virtualNetworkSubnetId: subnet.id
  }
}


resource vnetConnection 'Microsoft.Web/sites/virtualNetworkConnections@2022-03-01' = {
  parent: webapp
  name: 'AppServiceConnection'
  properties: {
    vnetResourceId: subnet.id
    isSwift: true
  }  
}
