# Ne pas exécuter ce script si Docker est utilisé !

# Vérifie si le script est exécuté avec des privilèges administrateur
$ELEVATED = [bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $ELEVATED) {
    Write-Host "Le script doit être exécuté avec des privilèges administrateur. Veuillez relancer le script en tant qu'administrateur."
    pause
    exit
}

Write-Host "Desactivation des options complementaires Windows :"

Write-Host "Hyper-V :"
Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Hyper-V-All
Write-Host "Windows Sandbox :"
Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Containers-DisposableClientVM
Write-Host "WSL :"
Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

Write-Host "Desactivation de hypervisorlaunchtype avec bcdedit :"
bcdedit /set hypervisorlaunchtype off