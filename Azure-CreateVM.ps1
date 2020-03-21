$VMBuild = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$password = ConvertTo-SecureString “Mysore11!” -AsPlainText -Force

$Cred = New-Object System.Management.Automation.PSCredential (“rahamath@outlook.com”, $password) 

Connect-AzAccount -Subscription 'a0cdbf8e-57ce-4f3c-a387-5a10b681ba11' -Tenant "05c575ab-b007-47e7-a0ea-f8f2564e6097" -Credential $Cred

#New-AzResourceGroup -Name $ResouceGroup -Location "East Asia"

$password = ConvertTo-SecureString “Passw0rd1234” -AsPlainText -Force
$Cred1 = New-Object System.Management.Automation.PSCredential (“vagrantuser1”, $password)

New-AzVm -ResourceGroupName $ResouceGroup -Name $VMBuild -Image "MyWindowsOSImage" `
    -Location "East Asia" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress" `
    -OpenPorts 80,3389 `
    -Credential $Cred1

$vm = Get-AzVM -Name $VMBuild -ResourceGroupName $ResouceGroup
$nicname = $vm.NetworkProfile[0].NetworkInterfaces.id.Split('/')[-1]
$nic = Get-AzNetworkInterface -name $nicname -ResourceGroupName $vm.ResourceGroupName

$pubIP = $Nic.IpConfigurations.PublicIPAddress.Id

$PubObj = Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where {$_.id -eq $pubIP}

$PublicIP = $PubObj.IpAddress

$PublicIP

Read-Host "check URL"

$WebReq = Invoke-WebRequest -Uri $PublicIP/default.html
If ($($WebReq.Content) -like "*Rahamath*") {
    Write-Host "Server build completed sucessfully"
    Read-Host "check URL 2"
    Remove-AzVM -name $VMbuild -ResourceGroupName $Vm.ResourceGroupName -Force

    $nic = Get-AzNetworkInterface -Name $VMBuild -ResourceGroup $ResouceGroup
    $nic.IpConfigurations.publicipaddress.id = $null
    Set-AzNetworkInterface -NetworkInterface $nic | Out-Null

    Remove-AzPublicIpAddress -Name myPublicIpAddress -ResourceGroupName $ResouceGroup -Force
}
Else {
    Write-Host "Server build failed"
}



#Remove-AzResourceGroup -Name myResourceGroup

#$sp = New-AzADServicePrincipal -DisplayName ServicePrincipalName