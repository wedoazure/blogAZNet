param location string
param date string 
param email string
param name string

resource law 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: name
  location: location
  tags: {
    createdDate: date
    Owner: email
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output workspace string = law.id
