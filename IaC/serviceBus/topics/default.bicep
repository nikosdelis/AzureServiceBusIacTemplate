@allowed(['dev', 'test', 'prod'])
param env string
param sbName string
param dlqName string

resource sb 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' existing = { name: sbName }
resource dlq 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' existing = { name: dlqName }

resource topicDefault 'Microsoft.ServiceBus/namespaces/topics@2022-01-01-preview' = {
  name: 'sbt-default-${env}'
  parent: sb
  properties: {
    requiresDuplicateDetection: true
    duplicateDetectionHistoryTimeWindow: 'PT1H'
  }
  
  resource subDefault 'subscriptions@2022-01-01-preview' = {
    name: 'default'
    properties: {
      forwardDeadLetteredMessagesTo: dlq.name
      defaultMessageTimeToLive: 'PT1M'
    }
  }
  
  resource subWithFilter 'subscriptions@2022-01-01-preview' = {
    name: 'TypeToFilter'
    properties: {
      forwardDeadLetteredMessagesTo: dlq.name
    }

    resource filter 'rules@2022-01-01-preview' = {
      name: 'MessageType'
      properties:{
        filterType: 'CorrelationFilter'
        correlationFilter: {
          properties: {
            messageType: 'typeToFilter'
          }
        }
      }
    }
  }
  
  resource ruleListen 'authorizationRules@2022-01-01-preview' = {
    name: 'listenRule'
    dependsOn: [
      subDefault
      subWithFilter
    ]
    properties: {
      rights: [
        'Listen'
      ]
    }
  }
  resource ruleSend 'authorizationRules@2022-01-01-preview' = {
    name: 'sendRule'
    dependsOn: [
      ruleListen
    ]
    properties: {
      rights: [
        'Send'
      ]
    }
  }
}
