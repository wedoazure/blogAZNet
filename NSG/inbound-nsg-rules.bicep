param nsgName string

var dir = 'Inbound'

resource nsgRule4000 'Microsoft.Network/networkSecurityGroups/securityRules@2021-05-01' = {
  name: '${nsgName}/IN_VNET_Deny'
  properties: {
    access: 'Deny'
    description: 'Deny default VNET traffic'
    destinationAddressPrefix: 'VirtualNetwork'
    destinationPortRange: '*'
    direction: dir
    priority: 4000
    protocol: '*'
    sourceAddressPrefix: '*'
    sourcePortRange: '*'
  }
}

resource nsgRule3000 'Microsoft.Network/networkSecurityGroups/securityRules@2021-05-01' = {
  name: '${nsgName}/IN_Ping_ALLOW'
  properties: {
    access: 'Allow'
    description: 'Allow PING from VNET'
    destinationAddressPrefix: 'VirtualNetwork'
    destinationPortRange: '*'
    direction: dir
    priority: 3000
    protocol: 'Icmp'
    sourceAddressPrefix: 'VirtualNetwork'
    sourcePortRange: '*'
  }
}
