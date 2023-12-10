Connect-MsolService

Write-Host "Recherche des comptes Azure Active Directory..."
$Users = Get-MsolUser -All | Where-Object { $_.UserType -ne "Guest" }
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file
Write-Host "Processing" $Users.Count "accounts..." 
ForEach ($User in $Users) {

    $MFADefaultMethod = ($User.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq "True" }).MethodType
    $MFAPhoneNumber = $User.StrongAuthenticationUserDetails.PhoneNumber

    If ($User.StrongAuthenticationRequirements) {
        $MFAState = $User.StrongAuthenticationRequirements.State
    }
    Else {
        $MFAState = 'Disabled'
    }

    If ($MFADefaultMethod) {
        Switch ($MFADefaultMethod) {
            "OneWaySMS" { $MFADefaultMethod = "Text code authentication phone" }
            "TwoWayVoiceMobile" { $MFADefaultMethod = "Call authentication phone" }
            "TwoWayVoiceOffice" { $MFADefaultMethod = "Call office phone" }
            "PhoneAppOTP" { $MFADefaultMethod = "Authenticator app or hardware token" }
            "PhoneAppNotification" { $MFADefaultMethod = "Microsoft authenticator app" }
        }
    }
    Else {
        $MFADefaultMethod = "Not enabled"
    }
  
    $ReportLine = [PSCustomObject] @{
        UserPrincipalName = $User.UserPrincipalName
        City              = $User.City
        Country           = $User.Country
        DisplayName       = $User.DisplayName
        Department        = $User.Department
        MFAState          = $MFAState
        MFADefaultMethod  = $MFADefaultMethod
        MFAPhoneNumber    = $MFAPhoneNumber
        MobilePhone       = $User.MobilePhone
    }
                 
    $Report.Add($ReportLine)
}

Write-Host "Le rapport est dans le dossier des telechargements"
$Report | Select-Object UserPrincipalName, DisplayName, City, Country, Department, MFAState, MFADefaultMethod, MFAPhoneNumber, MobilePhone | Sort-Object UserPrincipalName | Out-GridView
$Report | Sort-Object UserPrincipalName | Export-CSV -Encoding UTF8 -NoTypeInformation C:\Users\$env:UserName\Downloads\MFAUsers.csv