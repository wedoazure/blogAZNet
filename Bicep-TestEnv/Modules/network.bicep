param addressSpace string
param vnetName string
param location string
param date string 
param email string
param log string
param deployVNG bool
param afwSKU string


var firstOutput = split(addressSpace, '.' )
var mask1 = firstOutput[0]
var mask2 = firstOutput[1]

var sub1 = '${mask1}.${mask2}.250.0/26'
var sub2 = '${mask1}.${mask2}.1.0/24'
var sub3 = '${mask1}.${mask2}.2.0/24'
var sub4 = '${mask1}.${mask2}.123.0/24'
var sub5 = '${mask1}.${mask2}.255.0/24'

var bstPIPName = '${vnetName}-bst-pip'
var afwPIPName = '${vnetName}-afw-pip'
var vngPIPName = '${vnetName}-vng-pip'

var vngName = '${vnetName}-vng'

var bstName = '${vnetName}-bst'

var afwPolRuleName = '${vnetName}-afw-pol-rules'
var afwPolName = '${vnetName}-afw-pol'
var afwName = '${vnetName}-afw'

var rtName = '${vnetName}-default-rt'
var nsgName = '${vnetName}-nsg-def' 

resource rtDefault 'Microsoft.Network/routeTables@2021-02-01' = {
  name: rtName
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
}

resource nsgDef 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsgName
  location: location
}


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: sub1
        }
      }
      {
        name: 'WindowsSubnet'
        properties: {
          addressPrefix: sub2
          routeTable: {
             id: rtDefault.id
          }
          networkSecurityGroup: {
             id: nsgDef.id
          }
        }
      }
      {
        name: 'LinuxSubnet'
        properties: {
          addressPrefix: sub3
          routeTable: {
            id: rtDefault.id
         }
         networkSecurityGroup: {
          id: nsgDef.id
        }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: sub4
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: sub5
        }
      }
    ]
  }
}

resource vngPIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = if (deployVNG) {
  name: vngPIPName
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vng 'Microsoft.Network/virtualNetworkGateways@2021-03-01' = if (deployVNG) {
  name: vngName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetwork.id}/subnets/GatewaySubnet'
          }
          publicIPAddress: {
            id: vngPIP.id
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
  }
}


resource bstPIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: bstPIPName
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

resource azureBastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: bstName
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
             id: bstPIP.id
           }
           subnet: {
             id: '${virtualNetwork.id}/subnets/AzureBastionSubnet'
           }
         }
       }
    ]
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
    threatIntelMode: 'Deny'
    sku: {
      tier: afwSKU
    }
    insights: {
       isEnabled: true
        logAnalyticsResources: {
           defaultWorkspaceId: {
              id: log
           }
          workspaces: [
            {
              region: location
              workspaceId: {
                id: log
              }
            }
          ]

        }
    }
    
  }
}

resource azFWPolRule 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-03-01' = {
  name: afwPolRuleName
  parent: azFWPol
  properties: {
    priority: 100
    ruleCollections: [
      {
        name: 'test-collection'
        priority: 100
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            description: 'Testing Rule'
            name: 'Allow_Azure'
            ruleType: 'ApplicationRule'
            protocols: [
              {
                port: 443
                protocolType: 'Https'
              }
            ]
            sourceAddresses: [
              '*' 
            ]
            webCategories: [ 
              'ComputersAndTechnology'
              'Business'
            ]
          }
        ]
      }
    ]
  }
}

resource azFW 'Microsoft.Network/azureFirewalls@2021-03-01' = {
  name: afwName
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
                   id: '${virtualNetwork.id}/subnets/AzureFirewallSubnet'
                }
            }
        }
     ]
      firewallPolicy: {
         id: azFWPol.id
      }

  }
  
}

resource rtDefaultRoute 'Microsoft.Network/routeTables/routes@2021-03-01' = {
  name: 'Default-Route'
  parent: rtDefault
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: '${azFW.properties.ipConfigurations[0].properties.privateIPAddress}'
    }
}

output winNetworkID string = '${virtualNetwork.id}/subnets/WindowsSubnet'
output lnxNetworkID string = '${virtualNetwork.id}/subnets/LinuxSubnet'
