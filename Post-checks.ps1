$VMBuild = "PackerTestVM"
$ResouceGroup = "PackerGroup"
$username = "258d2509-d846-4e42-966c-425da28d4f8c@rahamathoutlook.onmicrosoft.com"

#$pass = Get-Content "C:\GitHub\Test\Password.txt" | ConvertTo-SecureString -Verbose
$Pass = ConvertTo-SecureString “AEab3__nAJ7a@0D1JUqXrxx@ZH/VnGZR!” -AsPlainText -Force

$cred = New-Object -TypeName pscredential –ArgumentList "258d2509-d846-4e42-966c-425da28d4f8c@rahamathoutlook.onmicrosoft.com", $pass

# login non-interactive
Login-AzAccount -Credential $cred -ServicePrincipal –TenantId "05c575ab-b007-47e7-a0ea-f8f2564e6097"



$vm = Get-AzVM -Name $VMBuild -ResourceGroupName $ResouceGroup
$nicname = $vm.NetworkProfile[0].NetworkInterfaces.id.Split('/')[-1]
$nic = Get-AzNetworkInterface -name $nicname -ResourceGroupName $vm.ResourceGroupName

$pubIP = $Nic.IpConfigurations.PublicIPAddress.Id

$PubObj = Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where {$_.id -eq $pubIP}

$PublicIP = $PubObj.IpAddress

Write-Host "Public IP is: $PublicIP"


$WebReq = ""
$WebReq = Invoke-WebRequest -Uri $PublicIP/default.html
If ($($WebReq.Content) -like "*Rahamath*") {
    Write-Host "Server build completed sucessfully"
    Write-Host "$($WebReq.Content)"
    #Remove-AzPublicIpAddress -Name myPublicIpAddress -ResourceGroupName $ResouceGroup -Force
}
Else {
    Write-Host "Server build failed"
}



#Remove-AzResourceGroup -Name myResourceGroup

#$sp = New-AzADServicePrincipal -DisplayName ServicePrincipalName