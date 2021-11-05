param location string
param date string 
param email string
param vmSize string
param vmname string
param vmAdm string
@secure()
param vmPass string
param subid string


resource nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: '${vmname}-win-nic01'
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
            id: subid
          }
        }
      }
    ]
  }
}

resource winVM 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: '${vmname}-win'
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
      computerName: '${vmname}-win'
      adminUsername: vmAdm
      adminPassword: vmPass
      windowsConfiguration: {
        timeZone: 'GMT Standard Time'
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: '${vmname}-win-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
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


