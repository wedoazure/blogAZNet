param nsgName string

var dir = 'Outbound'

resource nsgRule4000 'Microsoft.Network/networkSecurityGroups/securityRules@2021-05-01' = {
  name: '${nsgName}/OUT_VNET_Deny'
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
  name: '${nsgName}/OUT_Ping_ALLOW'
  properties: {
    access: 'Allow'
    description: 'Allow PING to VNET'
    destinationAddressPrefix: 'VirtualNetwork'
    destinationPortRange: '*'
    direction: dir
    priority: 3000
    protocol: 'Icmp'
    sourceAddressPrefix: 'VirtualNetwork'
    sourcePortRange: '*'
  }
}

resource nsgRule100 'Microsoft.Network/networkSecurityGroups/securityRules@2021-05-01' = {
  name: '${nsgName}/OUT_RDP_ALLOW'
  properties: {
    access: 'Allow'
    description: 'Allow RDP to VNET'
    destinationAddressPrefix: 'VirtualNetwork'
    destinationPortRange: '3389'
    direction: dir
    priority: 100
    protocol: 'Tcp'
    sourceAddressPrefix: 'VirtualNetwork'
    sourcePortRange: '*'
  }
}
