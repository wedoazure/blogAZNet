param nsgNameFile string
param locationFile string
param dateNow string = utcNow('yyyy-MM-dd')
param emailFile string

//deploy NSG resource
module nsgMDL 'nsg.bicep' = {
  name: 'nsg-deploy'
  params: {
    location: locationFile
    date: dateNow
    email: emailFile
    nsgName: nsgNameFile
  }
}

//deploy NSG rules
module inRuleMDL 'inbound-nsg-rules.bicep' = {
  name: 'in-rules-deploy'
  dependsOn: [
    nsgMDL
  ]
  params: { 
    nsgName: nsgNameFile
  }
}

module outRuleMDL 'outbound-nsg-rules.bicep' = {
  name: 'out-rules-deploy'
  dependsOn: [
    nsgMDL
  ]
  params: { 
    nsgName: nsgNameFile
  }
}
