param vnetName string
param location string
param date string 
param email string
param vnet string

var bstPIPName = '${vnetName}-bst-pip'
var bstName = '${vnetName}-bst'


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
             id: '${vnet}/subnets/AzureBastionSubnet'
           }
         }
       }
    ]
  }
}
