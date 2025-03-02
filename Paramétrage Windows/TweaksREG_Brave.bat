REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\BraveSoftware\Brave" /v BraveRewardsDisabled /t REG_DWORD /d 1 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\BraveSoftware\Brave" /v BraveWalletDisabled /t REG_DWORD /d 1 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\BraveSoftware\Brave" /v BraveVPNDisabled /t REG_DWORD /d 1 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\BraveSoftware\Brave" /v BraveAIChatEnabled /t REG_DWORD /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\BraveSoftware\Brave" /v PasswordManagerEnabled /t REG_DWORD /d 0 /f
REG ADD "HKEY_LOCAL_MACHINE\Software\Policies\BraveSoftware\Brave" /v TorDisabled /t REG_DWORD /d 0 /f

pause