param nsgName string
param location string
param date string 
param email string


resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgName
  location: location
  tags: {
    CreatedOn: date
    Owner: email
  }
  properties: {}   
}
