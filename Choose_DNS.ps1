# Vérifie si le script est exécuté avec des privilèges administrateur
$ELEVATED = [bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $ELEVATED) {
    Write-Host "Le script doit être exécuté avec des privilèges administrateur. Veuillez relancer le script en tant qu'administrateur."
    pause
    exit
}

# Fonction pour afficher le menu
function Show-Menu {
    Write-Host "Choisissez les serveurs DNS à configurer :" -ForegroundColor Cyan
    Write-Host "1. Cloudflare (IPv4 : 1.1.1.1, 1.0.0.1 | IPv6 : 2606:4700:4700::1111, 2606:4700:4700::1001)" -ForegroundColor Yellow
    Write-Host "2. Quad9 (IPv4 : 9.9.9.9, 149.112.112.112 | IPv6 : 2620:fe::fe, 2620:fe::9)" -ForegroundColor Yellow
    Write-Host ""
    $choice = Read-Host "Entrez votre choix (1 ou 2)"
    return $choice
}

# Définition des serveurs DNS
$dnsCloudflareIPv4 = "1.1.1.1", "1.0.0.1"
$dnsCloudflareIPv6 = "2606:4700:4700::1111", "2606:4700:4700::1001"
$dnsQuad9IPv4 = "9.9.9.9", "149.112.112.112"
$dnsQuad9IPv6 = "2620:fe::fe", "2620:fe::9"

# Afficher le menu et récupérer le choix de l'utilisateur
$selectedDns = Show-Menu

switch ($selectedDns) {
    "1" {
        $dnsServersIPv4 = $dnsCloudflareIPv4
        $dnsServersIPv6 = $dnsCloudflareIPv6
        Write-Host "Vous avez choisi les serveurs DNS de Cloudflare." -ForegroundColor Green
    }
    "2" {
        $dnsServersIPv4 = $dnsQuad9IPv4
        $dnsServersIPv6 = $dnsQuad9IPv6
        Write-Host "Vous avez choisi les serveurs DNS de Quad9." -ForegroundColor Green
    }
    default {
        Write-Host "Choix invalide. Le script va se terminer." -ForegroundColor Red
        exit
    }
}

# Fonction pour configurer les serveurs DNS pour une carte réseau donnée
function Set-DnsServers {
    param (
        [string]$interfaceAlias,
        [string[]]$dnsServersIPv4,
        [string[]]$dnsServersIPv6
    )
    # Configuration des serveurs DNS pour IPv4
    if ($dnsServersIPv4) {
        Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses $dnsServersIPv4
    }
    # Configuration des serveurs DNS pour IPv6
    if ($dnsServersIPv6) {
        Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses $dnsServersIPv6
    }
}

# Demande à l'utilisateur de saisir les noms des interfaces Ethernet et Wi-Fi
$ethernetInterfaces = Read-Host "Entrez les noms des interfaces Ethernet séparés par des virgules (laissez vide si aucune)"
$wifiInterfaces = Read-Host "Entrez les noms des interfaces Wi-Fi séparés par des virgules (laissez vide si aucune)"

# Conversion des entrées utilisateur en tableaux
$ethernetInterfacesArray = if ($ethernetInterfaces) { $ethernetInterfaces -split "," } else { @() }
$wifiInterfacesArray = if ($wifiInterfaces) { $wifiInterfaces -split "," } else { @() }

# Configuration des serveurs DNS pour les interfaces Ethernet
foreach ($interface in $ethernetInterfacesArray) {
    if ($interface.Trim()) {
        Set-DnsServers -interfaceAlias $interface.Trim() -dnsServersIPv4 $dnsServersIPv4 -dnsServersIPv6 $dnsServersIPv6
    }
}

# Configuration des serveurs DNS pour les interfaces Wi-Fi
foreach ($interface in $wifiInterfacesArray) {
    if ($interface.Trim()) {
        Set-DnsServers -interfaceAlias $interface.Trim() -dnsServersIPv4 $dnsServersIPv4 -dnsServersIPv6 $dnsServersIPv6
    }
}

# Nettoyage du cache DNS
Write-Host "Nettoyage du cache DNS..." -ForegroundColor Yellow
ipconfig /flushdns > $null 2>&1

Write-Host ""
Write-Host "Les serveurs DNS ont été configurés pour les interfaces spécifiées." -ForegroundColor Green