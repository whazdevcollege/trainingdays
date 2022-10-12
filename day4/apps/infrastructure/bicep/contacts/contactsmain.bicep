@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@secure()
@description('Sql server\'s admin password')
param sqlUserPwd string
param location string = resourceGroup().location

var sqlUserName = uniqueString(resourceGroup().id, env, sqlUserPwd)

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-Contacts'
}

module database 'databases.bicep' = {
  name: 'deployDatabaseContacts'
  params: {
    env: env
    resourceTag: resourceTag
    sqlUserName: sqlUserName
    sqlUserPwd: sqlUserPwd
    location: location
  }
}

module webapp 'webapp.bicep' = {
  name: 'deployWebAppContacts'
  params: {
    env: env
    resourceTag: resourceTag
    sqlConnectionString: database.outputs.connectionString
    location: location
  }
}

output contactsApiWebAppName string = webapp.outputs.contactsApiWebAppName
output sqlUserName string = sqlUserName
