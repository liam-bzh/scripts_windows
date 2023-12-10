# Fonction récursive pour traiter les éléments à l'intérieur des dossiers
function SupprimerAnciensElements {
    param (
        [string]$chemin
    )

    $elements = Get-ChildItem $chemin

    foreach ($element in $elements) {
        # Obtenir la date la plus récente entre la date de modification et la date de création
        $datePlusRecente = $element.LastWriteTime
        if ($element.CreationTime -gt $datePlusRecente) {
            $datePlusRecente = $element.CreationTime
        }

        # Calculer la différence de jours entre la date actuelle et la date la plus récente
        $differenceJours = ($dateActuelle - $datePlusRecente).Days

        # Vérifier si la différence de jours dépasse la période de rétention
        if ($differenceJours -ge $periodeRetention) {
            # Supprimer l'élément (fichier ou dossier)
            Remove-Item $element.FullName -Force -Recurse
            Write-Host "Element supprime : $($element.FullName)"
        }

        # Si c'est un dossier, appeler récursivement la fonction pour traiter les éléments à l'intérieur
        if ($element.PSIsContainer) {
            SupprimerAnciensElements -chemin $element.FullName
        }
    }
}

# Chemin du répertoire à surveiller
$repertoire = "C:\Users\*****\Desktop\*****"

# Récupérer la date actuelle
$dateActuelle = Get-Date

# Définir la période de rétention en jours (30 jours dans cet exemple)
$periodeRetention = 30

# Appeler la fonction pour traiter les éléments du répertoire et de ses sous-dossiers
SupprimerAnciensElements -chemin $repertoire

Write-Host "Execution terminee"