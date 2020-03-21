## Prereqs
## the AZ PowerShell modules
## Install-Module AZ

## Authenticate to your Azure subscription with the interactive prompt
Connect-AzAccount -Subscription 'a0cdbf8e-57ce-4f3c-a387-5a10b681ba11' -Tenant "05c575ab-b007-47e7-a0ea-f8f2564e6097" -Credential(Get-Credential)

## Note the subscription and tenant IDs. We'll need those later. If you forget, you can always use Get-AZASubscription.

#region Create the Azure AD application
$secPassword = ConvertTo-SecureString -AsPlainText -Force -String 'Passw0rd123'
$myApp = New-AZADApplication -DisplayName 'Rahamath@outlook.com' -IdentifierUris 'http://www.techsnips.io' -Password $secPassword
$myApp
#endregion

#region Create the service principal referencing the application created
$sp = New-AZADServicePrincipal -ApplicationId $myApp.ApplicationId
$sp
#endregion

#region Assign a role to the service principal
New-AZRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $sp.ServicePrincipalNames[0]
#endregion

#region Authenticating with Add-AZAccount
$subscription = Get-AZSubscription -SubscriptionName 'Visual Studio Premium with MSDN'
$appCred = Get-Credential -UserName $myApp.ApplicationId -Message 'Azure AD Cred'
Connect-AZAccount -ServicePrincipal -SubscriptionId $subscription.SubscriptionId -Tenant $subscription.TenantId -Credential $appCred
#endregion