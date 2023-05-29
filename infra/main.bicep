targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Id of the user or app to assign application roles')
param principalId string = ''


@description('Relative Path of ASA API gateway app Jar')
param gatewayRelativePath string

@description('Relative Path of ASA admin server app Jar')
param adminRelativePath string

@description('Relative Path of ASA customers service app Jar')
param customersRelativePath string

@description('Relative Path of ASA vets service app Jar')
param vetsRelativePath string

@description('Relative Path of ASA visits service app Jar')
param visitsRelativePath string

@secure()
@description('MYSQL Server administrator password')
param mysqlAdminPassword string

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var asaInstanceName = '${abbrs.springApps}${resourceToken}'
var gatewayAppName = 'spring-petclinic-api-gateway'
var adminAppName = 'spring-petclinic-admin-server'
var customersAppName = 'spring-petclinic-customers-service'
var vetsAppName = 'spring-petclinic-vets-service'
var visitsAppName = 'spring-petclinic-visits-service'
var keyVaultName = '${abbrs.keyVaultVaults}${resourceToken}'
var mysqlServerName = '${abbrs.sqlServers}${resourceToken}'
var databaseName = 'petclinic'
var mysqlDatabaseSecretName = 'MYSQL_DATABASE_NAME'
var mysqlServerSecretName = 'MYSQL_SERVER_FULL_NAME'
var mysqlUserSecretName = 'MYSQL_SERVER_ADMIN_LOGIN_NAME'
var mysqlPasswordSecretName = 'MYSQL_SERVER_ADMIN_PASSWORD'
var mysqlAdminName = 'mysqladmin'
var tags = {
  'azd-env-name': environmentName
  'spring-cloud-azure': 'true'
}
var asaTag = {
  'azd-service-name': [ gatewayAppName, adminAppName, customersAppName, vetsAppName, visitsAppName ]
}


// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

module springApps 'modules/springapps/springapps.bicep' = {
  name: '${deployment().name}--asa'
  scope: resourceGroup(rg.name)
  params: {
    location: location
	gatewayAppName: gatewayAppName
	adminAppName: adminAppName
	customersAppName: customersAppName
	vetsAppName: vetsAppName
	visitsAppName: visitsAppName
	tags: union(tags, asaTag)
	asaInstanceName: asaInstanceName
	gatewayRelativePath: gatewayRelativePath
	adminRelativePath: adminRelativePath
	customersRelativePath: customersRelativePath
	vetsRelativePath: vetsRelativePath
	visitsRelativePath: visitsRelativePath
  }
}
