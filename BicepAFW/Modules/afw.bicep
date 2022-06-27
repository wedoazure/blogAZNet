param vnetName string
param location string
param date string 
param email string
param log string
param vnet string
param afwSKU string

var afwPIPName = '${vnetName}-afw-pip'
var afwPolName = '${vnetName}-afw-pol'
var afwName = '${vnetName}-afw'

resource afwPIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: afwPIPName
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource azFWPol 'Microsoft.Network/firewallPolicies@2021-03-01' = {
  name: afwPolName
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
  properties: {
    threatIntelMode: 'Alert'
    intrusionDetection: {
      mode: 'Alert'
    }
    sku: {
      tier: afwSKU
    }
  }
}



resource azFW 'Microsoft.Network/azureFirewalls@2021-03-01' = {
  name: afwName
  dependsOn: [
    azFWPol
    afwPIP
  ]
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
  properties: {
     ipConfigurations: [
        {
           name: 'ipConf'
            properties: {
               publicIPAddress: {
                  id: afwPIP.id
               }
                subnet: {
                   id: '${vnet}/subnets/AzureFirewallSubnet'
                }
            }
        }
     ]
      firewallPolicy: {
         id: azFWPol.id
      }
      sku: {
        name: 'AZFW_VNet'
        tier: afwSKU
      }

  }
  
}

resource azfwDiags 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${afwName}-diags'
  scope: azFW
  dependsOn: [
    azFW
  ]
  properties: {
    logs: [
      {
        category: 'AzureFirewallApplicationRule'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: true
        }
      }
      {
        category: 'AzureFirewallNetworkRule'
        enabled: true
        retentionPolicy: {
          days: 90
          enabled: true
        }
      }
    ]
    workspaceId: log
  }
}

output nextHop string = '${azFW.properties.ipConfigurations[0].properties.privateIPAddress}'
output afwpol object = azFWPol
