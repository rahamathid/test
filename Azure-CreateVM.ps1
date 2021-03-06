﻿$VMBuild = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$username = "258d2509-d846-4e42-966c-425da28d4f8c@rahamathoutlook.onmicrosoft.com"
$pass = Get-Content "C:\GitHub\Test\Password.txt" | ConvertTo-SecureString

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

Write-Host "VM creation completed; reading public IP now"
$vm = Get-AzVM -Name $VMBuild -ResourceGroupName $ResouceGroup
$nicname = $vm.NetworkProfile[0].NetworkInterfaces.id.Split('/')[-1]
$nic = Get-AzNetworkInterface -name $nicname -ResourceGroupName $vm.ResourceGroupName

$pubIP = $Nic.IpConfigurations.PublicIPAddress.Id

$PubObj = Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where {$_.id -eq $pubIP}

$PublicIP = $PubObj.IpAddress

Write-Host "Public IP is: $PublicIP"

Read-Host "check URL"

$WebReq = ""
$WebReq = Invoke-WebRequest -Uri $PublicIP/default.html
If ($($WebReq.Content) -like "*Rahamath*") {
    Write-Host "Server build completed sucessfully"
    Read-Host "check URL 2"
    Write-Host "Deleting VM"
    Remove-AzVM -name $VMbuild -ResourceGroupName $Vm.ResourceGroupName -Force | Out-Null

    Write-host "Disassociate NIC card"
    $nic = Get-AzNetworkInterface -Name $VMBuild -ResourceGroup $ResouceGroup
    $nic.IpConfigurations.publicipaddress.id = $null
    Set-AzNetworkInterface -NetworkInterface $nic | Out-Null

    #Remove-AzPublicIpAddress -Name myPublicIpAddress -ResourceGroupName $ResouceGroup -Force
}
Else {
    Write-Host "Server build failed"
}



#Remove-AzResourceGroup -Name myResourceGroup

#$sp = New-AzADServicePrincipal -DisplayName ServicePrincipalName