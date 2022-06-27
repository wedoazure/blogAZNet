param vnetName string





var afwPolRuleName = '${vnetName}-afw-pol-rules'
var afwPolName = '${vnetName}-afw-pol'

resource azFWPolRule 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-03-01' = {
  name: '${afwPolName}/${afwPolRuleName}'
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
