
Write-Host ("Made by Bluewave2")
Write-Host ("https://github.com/Bluewave2/HyperV-Disable-Enable")
$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
if($hyperv.State -eq "Enabled") {
    Write-Host "Hyper-V is enabled"
} else {
    Write-Host "Hyper-V is disabled."
}