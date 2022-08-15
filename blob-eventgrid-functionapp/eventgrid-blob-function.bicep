param location string = resourceGroup().location
param storageAccountName string = 'assets${uniqueString(resourceGroup().id)}'
//param appName string = 'functionapp-${uniqueString(resourceGroup().id)}'
param appName string = 'deploytest20220815'
param functionName string = 'Function1'
param containerName string = 'contents'

param eventSubName string = 'blob-to-function'
param systemTopicName string = 'assetstoragesystemtopic'

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
      subjectBeginsWith: containerName
      subjectEndsWith: '.json'
    }
  }
}
