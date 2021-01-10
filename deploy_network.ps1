# Connect to Azure
Connect-AzAccount

# Get / Set variables
$location = 'centralindia'
$RGName = 'rg-network'
$user = Get-AzADUser -UserPrincipalName 'username@usergmail.onmicrosoft.com'
$role = 'Contributor'

# Create new resource group
$newRG = New-AzResourceGroup -Name $RGName -Location $location

# Assign Contributor permission to the Resource Group
New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName $role -ResourceGroupName $RGName

# Virtual Network Deployment
New-AzResourceGroupDeployment -ResourceGroupName $RGName -Name 'Deployment-Network' `
    -TemplateFile .\KeyVault\keyvault.json -TemplateParameterFile .\KeyVault\keyvault.parameters.json

# Azure Firewall and Route Table deployment
New-AzResourceGroupDeployment -ResourceGroupName $RGName -Name 'Deployment-Firewall' `
    -TemplateFile .\AzureFirewall\firewall.json -TemplateParameterFile .\AzureFirewall\firewall.parameters.json

# Remove Azure resource group
# Remove-AzResourceGroup -Name $RGName  -Force
