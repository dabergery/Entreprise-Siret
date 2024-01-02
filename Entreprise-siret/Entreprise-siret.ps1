# TRIER LES SECTEURS D'ACTIVITE PAR...
param(
    [string]$Le_Code_APE="*",
    [string]$denomination="*",
    [string]$commune="*",
    [string]$date_AAAA_MM_JJ="1950-01-01",
    [bool]$masquerValeursNulles=$true
)

$response = "There is a bad Token, Go fuck Your self, and youre a lil son of a butch btw !"
$oldtoken = "Bearer e5e6336c-b926-3f46-8fe4-058cdb24093e"

Remove-Item $PWD\out.txt
# CREATION DU JETON API VALIDE SEPT JOURS
$url = "https://api.insee.fr/entreprises/sirene/V3/siret"
$headers = @{
    "Content-Type" = "application/x-www-form-urlencoded"
    "Authorization" = "Bearer e5e6336c-b926-3f46-8fe4-058cdb24093e"
}

# Exporter le resultat
$urlWithParameters = $url+"?q=activitePrincipaleUniteLegale:$Le_Code_APE denominationUniteLegale:$denomination libelleCommuneEtablissement:$commune&date=$date_AAAA_MM_JJ&masquerValeursNulles=$masquerValeursNulles"
$response = Invoke-RestMethod -Uri $urlWithParameters -Method Get -Headers $headers
$outputFilePath = "$PWD\out.txt"
$response | ConvertTo-Json | Out-File -FilePath $outputFilePath -Append -Encoding UTF8

# BLAH BLAH BLAH
cls;Write-Host "#======SUCCES=======#"
Write-Host "Résultat exporté avec succès dans : $outputFilePath" -ForegroundColor Yellow
Write-Host "full URL arguments : $urlWithParameters" -ForegroundColor Green
Write-Host "Note : do you know --> the api.insee.fr <-- site can take up to 63 differents arguments in paramters to find youre <right> enterprise !" -BackgroundColor red