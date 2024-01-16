<# EXECUTER CE SCRIPT EN TANT QU'ADMINISTRATEUR
Par défaut, l'exécution de script est désactivée sous Windows, en cas de blocage d'exécution de ce script : Set-ExecutionPolicy Unrestricted
Chocolatey doit être installé avant l'exécution de ce script : https://chocolatey.org/install #>

# Première mise à jour des dépots Chocolatey
choco upgrade all

# Installation des logiciels souhaités (personnalisez la liste comme vous le souhaitez)
choco install 7zip autoruns discord everything nilesoft-shell notion paint.net protondrive protonvpn putty rdm sharex steam tidal ubisoft-connect veracrypt virtualbox vlc vscode winscp

# Blocage de l'exécution des prochains scripts
Set-ExecutionPolicy Restricted