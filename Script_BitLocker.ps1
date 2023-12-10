$NAME = hostname
$BitlockerRecoveryPath = "\\WIN-SERVER\NomDuPartage\$NAME"
$BitlockerStatus = (Get-BitLockerVolume -MountPoint "C:").VolumeStatus

if(!(Test-Path -Path $BitlockerRecoveryPath)){
    New-Item -ItemType Directory -Path $BitlockerRecoveryPath
}

if ($BitlockerStatus -eq "FullyDecrypted") {
    Enable-BitLocker -MountPoint "C:" -RecoveryPasswordProtector -UsedSpaceOnly -SkipHardwareTest

    $RecoveryKey = Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'}
    $RecoveryKeyPath = "$BitlockerRecoveryPath\BitLockerKey_$NAME" + ".txt"
    $RecoveryKeyPath | Out-File $RecoveryKeyPath
    Add-Content $RecoveryKeyPath "Recovery Password: $($RecoveryKey.RecoveryPassword)"
    Exit 0
} else {
    $RecoveryKey = Get-BitLockerVolume -MountPoint "C:" | Select-Object -ExpandProperty KeyProtector | Where-Object {$_.KeyProtectorType -eq 'RecoveryPassword'}
    $RecoveryKeyPath = "$BitlockerRecoveryPath\BitLockerKey_$NAME" + ".txt"
    $RecoveryKeyPath | Out-File $RecoveryKeyPath
    Add-Content $RecoveryKeyPath "Recovery Password: $($RecoveryKey.RecoveryPassword)"
    Exit 0
}