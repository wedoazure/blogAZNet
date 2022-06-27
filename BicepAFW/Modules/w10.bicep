param location string
param date string 
param email string
param vnet string
param nextHop string
param rt string
param vmName string
@secure()
param vmPass string
param vmAdm string
param vmSize string
param vnetAddress string

resource rtDefaultRoute 'Microsoft.Network/routeTables/routes@2021-03-01' = {
  name: '${rt}/Default-Route'
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: nextHop
    }
}

resource rtLocalRoute 'Microsoft.Network/routeTables/routes@2021-03-01' = {
  name: '${rt}/Local-Route'
    properties: {
      addressPrefix: vnetAddress
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: nextHop
    }
}

resource w10Nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: '${vmName}-nic01'
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
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vnet}/subnets/WindowsSubnet'
          }
        }
      }
    ]
  } 
}

resource w10VM 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmName
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: vmAdm
      adminPassword: vmPass
      windowsConfiguration: {
        timeZone: 'GMT Standard Time'
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-10'
        sku: '20h1-Pro'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: w10Nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
