$content = "This server is build by Rahamath using Packer"

If ($content -like "*Rahamath*") {
    Write-Host "Present"
}
Else {
    Write-Host "Absent"
}