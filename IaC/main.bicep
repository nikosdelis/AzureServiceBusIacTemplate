targetScope = 'subscription'

@description('Specifies the location for resources.')
param location string = 'westeurope'

@allowed(['dev', 'test', 'prod'])
param env string

@minLength(3)
@maxLength(24)
@description('The name that describes each all resoruces e.g. "message-broker" would be rg-message-broker-test')
param resourceName string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${resourceName}-${env}'
  location: location
}

module sb 'serviceBus/sb.bicep' = {
  name: 'sb-${resourceName}-${env}'
  scope: rg
  params: {
    env: env
    resourceName: resourceName
  }
}
