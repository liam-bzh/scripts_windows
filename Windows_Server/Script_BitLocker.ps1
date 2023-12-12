# Déclaration des variables
$NAME = hostname
$BitlockerRecoveryPath = "\\WIN-SERVER\NomDuPartage\$NAME" # Modifier uniquement cette variable en incluant le nom du partage réseau dédié à BitLocker
$BitlockerStatus = (Get-BitLockerVolume -MountPoint "C:").VolumeStatus

# Si le dossier du PC n'existe pas, création...
if(!(Test-Path -Path $BitlockerRecoveryPath)){
    New-Item -ItemType Directory -Path $BitlockerRecoveryPath
}

# Si BitLocker est désactivé, activation et copie de la clé...
if ($BitlockerStatus -eq "FullyDecrypted") {
    Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector -UsedSpaceOnly -SkipHardwareTest

    $RecoveryKey = Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'}
    $RecoveryKeyPath = "$BitlockerRecoveryPath\BitLockerKey_$NAME" + ".txt"
    $RecoveryKeyPath | Out-File $RecoveryKeyPath
    Add-Content $RecoveryKeyPath "Recovery Password: $($RecoveryKey.RecoveryPassword)"
    Exit 0
# Sinon, copie uniquement de la clé...
} else {
    $RecoveryKey = Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'}
    $RecoveryKeyPath = "$BitlockerRecoveryPath\BitLockerKey_$NAME" + ".txt"
    $RecoveryKeyPath | Out-File $RecoveryKeyPath
    Add-Content $RecoveryKeyPath "Recovery Password: $($RecoveryKey.RecoveryPassword)"
    Exit 0
}