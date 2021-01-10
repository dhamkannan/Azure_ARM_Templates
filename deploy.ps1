# Connect to Azure
Connect-AzAccount

# Get / Set variables
$location = 'centralindia'
$RGName = 'rg-data'
$user = Get-AzADUser -UserPrincipalName 'username@usergmail.onmicrosoft.com'
$role = 'Contributor'

# Create new resource group
$newRG = New-AzResourceGroup -Name $RGName -Location $location

# Assign Contributor permission to the Resource Group
New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName $role -ResourceGroupName $RGName

# Key Vault Deployment
New-AzResourceGroupDeployment -ResourceGroupName $RGName -Name 'Deployment-keyvault' `
    -TemplateFile .\KeyVault\keyvault.json -TemplateParameterFile .\KeyVault\keyvault.parameters.json

# Data Lake Deployment
New-AzResourceGroupDeployment -ResourceGroupName $RGName -Name 'Deployment-storage' `
    -TemplateFile .\StorageAccount\blockblob.json -TemplateParameterFile .\StorageAccount\blockblob.parameters.json

# Data Factory Deployment
New-AzResourceGroupDeployment -ResourceGroupName $RGName -Name 'Deployment-datafactory' `
    -TemplateFile .\DataFactory\datafactory.json -TemplateParameterFile .\DataFactory\datafactory.parameters.json

# Synapse Workspace Deployment
New-AzResourceGroupDeployment -ResourceGroupName $RGName -Name 'Deployment-synapse' `
    -TemplateFile .\SynapseAnalytics\synapse.json -TemplateParameterFile .\SynapseAnalytics\synapse.parameters.json

# Remove Azure resource group
# Remove-AzResourceGroup -Name $RGName  -Force
