# Menu principale
param(
    [string]$denomination="*",
    [string]$Le_Code_APE="*",
    [string]$commune="*"
)
# Watermark david berger
$salopard = @"
______        _                       _             _____ _____ _____  ______ _______ 
|  ____|     | |                     (_)           / ____|_   _|  __ \|  ____|__   __|
| |__   _ __ | |_ _ __ ___ _ __  _ __ _ ___  ___  | (___   | | | |__) | |__     | |   
|  __| | '_ \| __| '__/ _ \ '_ \| '__| / __|/ _ \  \___ \  | | |  _  /|  __|    | |   
| |____| | | | |_| | |  __/ |_) | |  | \__ \  __/  ____) |_| |_| | \ \| |____   | |   
|______|_| |_|\__|_|  \___| .__/|_|  |_|___/\___| |_____/|_____|_|  \_\______|  |_|    By David BERGER
                          | |                                                         
                          |_|                                                         
"@

# CREATION DU JETON API VALIDE SEPT JOURS
$url = "https://api.insee.fr/entreprises/sirene/V3/siret"
$headers = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Authorization" = "Bearer 209b86a5-bb35-3ef8-9b5e-e62027b2ab4e"
}

# out.txt and result.txt
Write-Host "Gestion des fichiers out.txt et Result.txt"
$fileout = Test-Path "$PWD\out.txt"
$fileresult = Test-Path "$PWD\Result.txt"
if($fileresult -eq $true -or $fileout -eq $true){
    Write-Host "Le repertoire a trouvé un fichier de sortie, suppression en cours...`nOK" -ForegroundColor red
    Remove-Item *.txt
    $fileout = Test-Path "$PWD\out.txt"
    $fileresult = Test-Path "$PWD\Result.txt"
} else {
    Write-Host "Le repertoire n'a rien trouvé, lancement de la requete HTTP..." -ForegroundColor darkgreen
}$salopard

# Exporter le resultat
$urlWithParameters = $url+"?q=activitePrincipaleUniteLegale:$Le_Code_APE denominationUniteLegale:$denomination libelleCommuneEtablissement:$&masquerValeursNulles=$masquerValeursNulles"
$response = Invoke-RestMethod -Uri $urlWithParameters -Method Get -Headers $headers
$outputFilePath = "$PWD\out.txt"
$response | ConvertTo-Json | Out-File -FilePath $outputFilePath -Append -Encoding UTF8
(Get-Content .\out.txt) -replace ";", "`n" | Set-Content .\out.txt

# Restructuration des données
$searches = @(
    "denominationUniteLegale",
    "libelleCommuneEtablissement",
    "siren",
    "codePostalEtablissement")

$test = Get-Content -Path .\out.txt | Select-String $searches 
$test = $test -replace "siren", "`n`n`nSIREN="
$test = $test -replace 'denominationUniteLegale=', 'Nom='
$test = $test -replace 'codePostalEtablissement=', 'Code Postal='
$test = $test -replace 'libelleCommuneEtablissement=', 'Ville='
# Gestion des Artefacts
$test = $test -replace "u0026", "&"
$test = $test -replace "u0027", " "
$test = $test -replace "adresseEtablissement", "`n"
Remove-Item ./out.txt -ErrorAction SilentlyContinue
Remove-Item Result.txt -ErrorAction SilentlyContinue
$test >> Result.txt

# Témoins d'execution
Write-Host "#======SUCCES=======#"- -ForegroundColor green
Write-Host "Résultat exporté avec succès dans : $outputFilePath" -ForegroundColor yellow
Write-Host "full URL arguments : $urlWithParameters" -ForegroundColor yellow
Write-Host "Note : do you know --> the api.insee.fr <-- site can take up to 63 differents arguments in paramters to find youre <right> enterprise !" -ForegroundColor yellow
Write-Host "Ecrivez la commande cat result.txt pour voir le resultat" -ForegroundColor red
