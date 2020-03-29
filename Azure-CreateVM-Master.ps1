$VMBuild = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$username = "258d2509-d846-4e42-966c-425da28d4f8c@rahamathoutlook.onmicrosoft.com"

#$pass = Get-Content "C:\GitHub\Test\Password.txt" | ConvertTo-SecureString -Verbose
$Pass = ConvertTo-SecureString “Mysore11!” -AsPlainText -Force
$cred = New-Object -TypeName pscredential –ArgumentList "258d2509-d846-4e42-966c-425da28d4f8c@rahamathoutlook.onmicrosoft.com", $pass

# login non-interactive
Login-AzAccount -Credential $cred -ServicePrincipal –TenantId "05c575ab-b007-47e7-a0ea-f8f2564e6097"



If (!(Get-AzResourceGroup -Name $ResouceGroup)) {
    New-AzResourceGroup -Name $ResouceGroup -Location "East Asia"
}

$password = ConvertTo-SecureString “Passw0rd1234” -AsPlainText -Force
$Cred1 = New-Object System.Management.Automation.PSCredential (“vagrantuser1”, $password)

Write-Host "Creating new VM"
New-AzVm -ResourceGroupName $ResouceGroup -Name $VMBuild -Image "MyWindowsOSImage" `
    -Location "East Asia" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIP" `
    -OpenPorts 80,3389 `
    -Credential $Cred1 | Out-Null

Write-Host "VM creation completed"