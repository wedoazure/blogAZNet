param vnetName string
param location string
param vnetAddress string
param subnet1Name string
param subnet1Address string
param subnet2Name string
param subnet2Address string
param subnet3Name string
param subnet3Address string

resource net 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddress
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1Address
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Address
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Address
        }
      }
      
    ]
  }
}
