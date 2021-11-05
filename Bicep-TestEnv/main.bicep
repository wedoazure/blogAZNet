param vnetNameFile string
param vnetAddressPrefixFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string
param vmSizeFile string
param vmNameFile string
@secure()
param vmPassFile string
param vmAdmFile string
param monNameFile string
param deployVNGFile bool
param afwSKUFile string


module monMDL 'Modules/monitor.bicep' = {
  name: 'mon-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    name: monNameFile
  }
}

module vnetMDL 'Modules/network.bicep' = {
  name: 'vnet-deploy'
  params: {
    vnetName: vnetNameFile
    addressSpace: vnetAddressPrefixFile
    location: locationFile
    date: dateNow
    email: emailFile
    log: monMDL.outputs.workspace
    deployVNG: deployVNGFile
    afwSKU: afwSKUFile
  }
}

module winMDL 'Modules/windows.bicep' = {
  name: 'win-deploy'
  params: {
    vmname: vmNameFile
    location: locationFile
    date: dateNow
    email: emailFile
    vmSize: vmSizeFile
    vmPass: vmPassFile
    vmAdm: vmAdmFile
    subid: vnetMDL.outputs.winNetworkID
  }
}

module lnxMDL 'Modules/linux.bicep' = {
  name: 'lnx-deploy'
  params: {
    vmname: vmNameFile
    location: locationFile
    date: dateNow
    email: emailFile
    vmSize: vmSizeFile
    vmPass: vmPassFile
    vmAdm: vmAdmFile
    subid: vnetMDL.outputs.lnxNetworkID
  }
}
