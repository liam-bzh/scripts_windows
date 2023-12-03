Write-Host "Desactivation des options complementaires Windows :"

Write-Host "Hyper-V :"
Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Hyper-V-All
Write-Host "Windows Sandbox :"
Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Containers-DisposableClientVM
Write-Host "WSL :"
Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

Write-Host "Desactivation de hypervisorlaunchtype avec bcdedit :"
bcdedit /set hypervisorlaunchtype off