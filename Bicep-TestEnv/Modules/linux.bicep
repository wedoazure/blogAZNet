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
  name: '${vmname}-lnx-nic01'
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

resource lnxVM 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: '${vmname}-lnx'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${vmname}-lnx'
      adminUsername: vmAdm
      adminPassword: vmPass
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '20.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: '${vmname}-lnx-osdisk'
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
