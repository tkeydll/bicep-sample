param location string = resourceGroup().location


// Event Grid system topic
param storageAccountName string = 'assets${uniqueString(resourceGroup().id)}'
resource sa 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

resource systemTopic 'Microsoft.EventGrid/systemTopics@2022-06-15' = {
  name: systemTopicName
  location: location
  properties: {
    source: sa.id
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}


// Event Grid subscription
param eventSubName string = 'blob-to-function'
param systemTopicName string = 'assetstoragesystemtopic'
param containerName string = 'container'

// Outbound function app
param appName string = 'functionapp-${uniqueString(resourceGroup().id)}'

@description('Function name')
param functionName string

resource functionApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appName
}


resource eventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2022-06-15' = {
  parent: systemTopic
  name: eventSubName
  properties: {
    destination: {
      endpointType: 'AzureFunction'
      properties: {
        resourceId: '${functionApp.id}/functions/${functionName}'
      }
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
      ]
      subjectBeginsWith: '/blobServices/default/containers/${containerName}'
      subjectEndsWith: '.json'
    }
  }
}
