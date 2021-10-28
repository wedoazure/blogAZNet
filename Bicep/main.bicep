param vnetNameFile string
param locationFile string
param vnetAddressPrefixFile string
param subnet1PrefixFile string
param subnet1NameFile string
param subnet2PrefixFile string
param subnet2NameFile string
param subnet3PrefixFile string
param subnet3NameFile string


module vnet 'Modules/network.bicep' ={
  name: 'vnet-deploy'
  params: {
    vnetName: vnetNameFile
    location: locationFile
    vnetAddress: vnetAddressPrefixFile
    subnet1Name: subnet1NameFile
    subnet1Address: subnet1PrefixFile
    subnet2Name: subnet2NameFile
    subnet2Address: subnet2PrefixFile
    subnet3Name: subnet3NameFile
    subnet3Address: subnet3PrefixFile
  }
}
