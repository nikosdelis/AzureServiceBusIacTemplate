@allowed(['dev', 'test', 'prod'])
param env string

@minLength(3)
@maxLength(24)
@description('The name that describes each all resoruces e.g. "message-broker" would be rg-message-broker-test')
param resourceName string

resource sb 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: 'sb-${resourceName}-${env}'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource deadLetterFirehoseQueue 'Microsoft.ServiceBus/namespaces/queues@2018-01-01-preview' = {
  name: 'sbq-deadletter-${resourceName}-${env}'
  parent: sb
  properties: {
    requiresDuplicateDetection: false
    requiresSession: false
    enablePartitioning: false
  }
}

module topicDefault 'topics/default.bicep' = {
  name: 'sbt-default-${env}'
  params: {
    env: env
    sbName: sb.name
    dlqName: deadLetterFirehoseQueue.name
  }
}
