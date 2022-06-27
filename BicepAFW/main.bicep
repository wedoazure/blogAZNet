param vnetNameFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string
param vnetAddressPrefixFile string
param monNameFile string
param afwSKUFile string
@secure()
param vmPassFile string
param vmAdmFile string
param vmSizeFile string
param vmNameFile string

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
    vnetAddress: vnetAddressPrefixFile
    location: locationFile
    date: dateNow
    email: emailFile
  }
}

module bstMDL 'Modules/bastion.bicep' = {
  name: 'bst-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: {
    vnetName: vnetNameFile
    location: locationFile
    date: dateNow
    email: emailFile
    vnet: vnetMDL.outputs.net
  }
}

module afwMDL 'Modules/afw.bicep' = {
  name: 'afw-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: { 
    log: monMDL.outputs.workspace
    location: locationFile
    date: dateNow
    email: emailFile
    vnetName: vnetNameFile
    vnet: vnetMDL.outputs.net
    afwSKU: afwSKUFile
  }
}

module ruleMDL 'Modules/rules.bicep' = {
  name: 'rules-deploy'
  dependsOn: [
    afwMDL
  ]
  params: { 
    vnetName: vnetNameFile
  }
}

module w10MDL 'Modules/w10.bicep' = {
  name: 'w10-deploy'
  dependsOn: [
    vnetMDL
  ]
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    vnet: vnetMDL.outputs.net
    nextHop: afwMDL.outputs.nextHop
    rt: vnetMDL.outputs.rt
    vmName: vmNameFile
    vmPass: vmPassFile
    vmAdm: vmAdmFile
    vmSize: vmSizeFile
    vnetAddress: vnetAddressPrefixFile
  }
}
