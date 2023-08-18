param asaInstanceName string
param gatewayAppName string
param adminAppName string
param customersAppName string
param vetsAppName string
param visitsAppName string
param location string = resourceGroup().location
param tags object = {}

resource asaInstance 'Microsoft.AppPlatform/Spring@2022-12-01' = {
  name: asaInstanceName
  location: location
  tags: tags
  sku: {
      name: 'E0'
      tier: 'Enterprise'
  }
}

resource asaConfigServer 'Microsoft.AppPlatform/Spring/configurationServices@2022-12-01' = {
  name: 'default'
  parent: asaInstance
  properties: {
    settings: {
      gitProperty: {
        repositories: [
          {
            label: 'master'
            name: 'spring-petclinic-microservices-config'
            uri: 'https://github.com/azure-samples/spring-petclinic-microservices-config'
            patterns: [ 'admin-server', 'api-gateway', 'customers-service', 'vets-service', 'visits-service' ]
          }
        ]
      }
    }
  }
}

resource asaServiceRegistries 'Microsoft.AppPlatform/Spring/serviceRegistries@2022-12-01' = {
  name: 'default'
  parent: asaInstance
}

resource gatewayApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: gatewayAppName
  location: location
  parent: asaInstance
  properties: {
    public: true
    addonConfigs: {
	  applicationConfigurationService: {
	    resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/configurationServices/default'
	  }
	  serviceRegistry: {
	    resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/serviceRegistries/default'
	  }
	}
  }
  dependsOn: [
    asaConfigServer
    asaServiceRegistries
  ]
}

resource adminApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: adminAppName
  location: location
  parent: asaInstance
  properties: {
    public: true
	addonConfigs: {
	  applicationConfigurationService: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/configurationServices/default'
	  }
	  serviceRegistry: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/serviceRegistries/default'
	  }
	}
  }
  dependsOn: [
    asaConfigServer
    asaServiceRegistries
  ]
}

resource customersApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: customersAppName
  location: location
  parent: asaInstance
  properties: {
    public: false
	addonConfigs: {
	  applicationConfigurationService: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/configurationServices/default'
	  }
	  serviceRegistry: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/serviceRegistries/default'
	  }
	}
  }
  dependsOn: [
    asaConfigServer
    asaServiceRegistries
  ]
}

resource vetsApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: vetsAppName
  location: location
  parent: asaInstance
  properties: {
    public: false
	addonConfigs: {
	  applicationConfigurationService: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/configurationServices/default'
	  }
	  serviceRegistry: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/serviceRegistries/default'
	  }
	}
  }
  dependsOn: [
    asaConfigServer
    asaServiceRegistries
  ]
}

resource visitsApp 'Microsoft.AppPlatform/Spring/apps@2022-12-01' = {
  name: visitsAppName
  location: location
  parent: asaInstance
  properties: {
    public: false
	addonConfigs: {
	  applicationConfigurationService: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/configurationServices/default'
	  }
	  serviceRegistry: {
		resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.AppPlatform/Spring/${asaInstanceName}/serviceRegistries/default'
	  }
	}
  }
  dependsOn: [
    asaConfigServer
    asaServiceRegistries
  ]
}

resource gatewayDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2022-12-01' = {
  name: 'default'
  parent: gatewayApp
  properties: {
    deploymentSettings: {
      addonConfigs: {
		applicationConfigurationService: {
			configFilePatterns: gatewayAppName
		}
	  }
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
    }
    source: {
	  type: 'BuildResult'
      buildResultId: '<default>'
    }
  }
}

resource adminDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2022-12-01' = {
  name: 'default'
  parent: adminApp
  properties: {
    deploymentSettings: {
	  addonConfigs: {
		applicationConfigurationService: {
			configFilePatterns: adminAppName
		}
	  }
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
    }
    source: {
	  type: 'BuildResult'
      buildResultId: '<default>'
    }
  }
}

resource customersDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2022-12-01' = {
  name: 'default'
  parent: customersApp
  properties: {
    deploymentSettings: {
	  addonConfigs: {
		applicationConfigurationService: {
			configFilePatterns: customersAppName
		}
	  }
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
    }
    source: {
	  type: 'BuildResult'
      buildResultId: '<default>'
    }
  }
}

resource vetsDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2022-12-01' = {
  name: 'default'
  parent: vetsApp
  properties: {
    deploymentSettings: {
	  addonConfigs: {
		applicationConfigurationService: {
			configFilePatterns: vetsAppName
		}
	  }
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
    }
    source: {
	  type: 'BuildResult'
      buildResultId: '<default>'
    }
  }
}

resource visitsDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2022-12-01' = {
  name: 'default'
  parent: visitsApp
  properties: {
    deploymentSettings: {
	  addonConfigs: {
		applicationConfigurationService: {
			configFilePatterns: visitsAppName
		}
	  }
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
    }
    source: {
	  type: 'BuildResult'
      buildResultId: '<default>'
    }
  }
}

resource buildAgentpool 'Microsoft.AppPlatform/Spring/buildServices/agentPools@2022-12-01' = {
  name: '${asaInstance.name}/default/default'
  properties: {
    poolSize: {
      name: 'S2'
    }
  }
  dependsOn: [
    asaInstance
  ]
}
